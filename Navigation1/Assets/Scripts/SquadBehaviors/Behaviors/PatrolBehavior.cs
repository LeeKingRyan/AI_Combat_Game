using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using Scripts.SquadBehaviors.Core;
using Scripts.SquadBehaviors;
using Scripts.SquadBehaviors.Orders;
using ReGoap.Core;
using ReGoap.Unity;
using UnityEditor.Experimental.GraphView;
using Scripts.SquadBehaviors.BlackBoards;
using System.Runtime.InteropServices;

namespace Scripts.SquadBehaviors.Behaviors
{
    // Note: Patrol will have a rather low priority, as it doesn't concern the safety of the squad,
    //       so overriding the GetPriority() function is ignored  
    public class PatrolBehavior : Behavior<string, object>
    {
        // Get all the Patrol Point nodes and their locations
        private Dictionary<PatrolPoint, Vector3> patrolpoints;  
        private Queue<PatrolPoint> expand; // Some patrol Points are adjacent to others via corridors, so adjacent patrol points are place
        // in this list of patrol nodes that can be expanded to. Patrol points that are already investigated are not placed inside expand,
        // in other words, nodes that found in the remaining patrolpoints.
        private List<PatrolPoint> investigated; // patrol points that have been investigated are placed in this list

        private Dictionary<IReGoapAgent<string, object>, PatrolPoint> assignments;  // what patrol points are members assigned to investigate (not including followers)
        private Dictionary<IReGoapAgent<string, object>, List<IReGoapAgent<string, object>>> divisions; // split sub groups of squad


        private float lastCalculationTime;
        private float CalculationDelay = 3f;

        
        private PatrolBehavior()
        {
            patrolpoints = new Dictionary<PatrolPoint, Vector3>();
            expand = new Queue<PatrolPoint>();
            investigated = new List<PatrolPoint>();
            assignments = new Dictionary<IReGoapAgent<string, object>, PatrolPoint>();
            divisions = new Dictionary<IReGoapAgent<string, object>, List<IReGoapAgent<string, object>>>();
            lastCalculationTime = -100;
            
        }

        // We ignored caches which was utilized in ReGoapState
        public static PatrolBehavior Instantiate(PatrolBehavior old = null)
        {
            PatrolBehavior currentBehavior;
            currentBehavior = new PatrolBehavior();
            currentBehavior.Init(old);
            
            return currentBehavior;

        }
        private void Init(PatrolBehavior old)
        {
            patrolpoints.Clear();
            expand.Clear();
            investigated.Clear();
            assignments.Clear();
            divisions.Clear();

            // Copy the patrol points available in the Game Scene
            if (old != null)
            {
                lock (old.patrolpoints)
                {
                    foreach (var pair in old.patrolpoints)
                    {
                        patrolpoints[pair.Key] = pair.Value;
                    }
                }
            }
            // Get the patrol points in the Game Scene directly if can't copy from another Patrol Behavior
            else
            {
                patrolpoints = new Dictionary<PatrolPoint, Vector3>(PatrolPointsManager.Instance.PatrolPoints.Length);
                foreach (var patrolpoint in PatrolPointsManager.Instance.PatrolPoints)
                {
                    patrolpoints[patrolpoint] = patrolpoint.transform.position; // patrol points are static
                }
            }
        }
        // Clone the Behavior, so that other sqads may have the same behavior, but different object
        public override IBehavior<string, object> Clone()
        {
            return Instantiate(this);
        }

        // Get a reference to the squad the behavior is applied to, and set it to the instances inside Behavior class.
        public override void Initialize(ISquad<string, object> squad)
        {
            base.Initialize(squad);
        }

        public override float GetPriority()
        {
            return base.GetPriority();
        }

        public override string GetName()
        {
            return "patrolBehavior";
        }


        // Check whether the behavior is warranted, as long as the player remains undetected
        // and that there is a patrol point to investigate.
        public override bool IsWarranted(ISquad<string, object> squad)
        {
            if(BlackBoard<string, object>.Instance.TryGetValue("playerDetected", out var flag) && (bool) flag)
                return false;

            foreach (var patrolpoint in patrolpoints)
            {
                if (patrolpoint.Key.IsInvestigated())
                {
                    return false;        
                }
            }
            return base.IsWarranted(squad);
        }
        // Until all Patrol Points are investigated, return false.
        public override bool IsFinished()
        {
            foreach(var patrolpoint in patrolpoints)
            {
                if(!patrolpoint.Key.IsInvestigated())
                    return false;
            }
            // remove any order in the squad's memory once behavior is complete
            RemoveOrders();
            return base.IsFinished();
        }
        // Can also put some time threshold to signal a failed behavior. What if stealth were a mechanic
        // and player was not detected, but the squad could be wiped out, hence failing the behavior. Or all
        // squad members failed to report in.

        // This patrol behavior has no time limit associated with its failure unlike other squad behaviors.
        // Fail if player is detected or squad is wiped out.
        public override bool IsFailed()
        {
            if ((BlackBoard<string, object>.Instance.TryGetValue("playerDetected", out var flag) && (bool) flag) || GetSquad().SquadSize() <= 0)
            {
                // remove orders if behavior failed
                RemoveOrders();
                return true;
            }
            return base.IsFailed();
        }
        // Go through each squad member and remove the "order" key condition. Note that every squad member only has one
        // order at a time as each squad is associated with one squad behavior at a time. 
        public override void RemoveOrders()
        {
            ISquad<string, object> crew = GetSquad();
            foreach (var member in crew.Members())
            {
                if (member.GetMemory().GetWorldState().HasKey("order"))
                {
                    member.GetMemory().GetWorldState().Remove("order");
                }
            }
        }

        // Note: Squad must split up to cover as much ground as possible, so depending on the number of patrol points that can be
        //       expand from, split the squad as much as possible to investigate, even if all squad mates investigate alone.

        // Give orders to navigate non-investigated patrol points either adjacent or nearest the squad. 
        public override void GiveOrders(ISquad<string, object> squad)
        {
            if (Time.time - lastCalculationTime <= CalculationDelay)
                return;
            lastCalculationTime = Time.time;


            //[*] Determine what PatrolPoints have been investigated, and recently investigated points are added to expand.
            foreach (var patrolpoint in patrolpoints)
            {
                if (patrolpoint.Key.IsInvestigated() && !investigated.Contains(patrolpoint.Key))
                {
                    expand.Enqueue(patrolpoint.Key);
                    investigated.Add(patrolpoint.Key);
                }
            }

            // Can retrieve any member from the squad at this point as team leader, since the squad is not spread out, as no points are investigated.

            // Make sure that if there have yet to be assignments, and if there are already patrol points investigated, the team will first navigate to
            // some non-investigated patrol point. Need to have some assignments no matter what after the base class, otherwise errors.

            // But what if there were no more patrol points to be investigated upon starting the Patrol Behavior?

            // Navigate to the nearest non-investigated patrol point if there are  no assignments.
            if (assignments.Count <= 0)
            {
                IReGoapAgent<string, object> teamLeader;
                List<IReGoapAgent<string, object>> team = new List<IReGoapAgent<string, object>>(); // includes captain too

                teamLeader = squad.Members()[0];

                //Invoke("GetNearestPatrolPoint")

                PatrolPoint nearestPoint = GetNearestPatrolPoint(teamLeader);

                Debug.Log("The first Patrol Point that the team BEFORE SPLITTING is investigating towards is Patrol Point " + nearestPoint.ReturnPointName());
                
                // Meaning that there is no more patrol points to investigate, as a nearest non-investigated point couldn't be found in the
                // game scene.
                if (nearestPoint == null)
                    return;

                assignments[teamLeader] = nearestPoint; // assign captain to investigate nearest patrol point

                // Assign each member in squad to the new team.
                foreach(var member in squad.Members())
                {
                    team.Add(member);
                }

                divisions[teamLeader] = team;

                //[*] Give orders for the teamLeader to travel to this patrol point
                PatrolOrder patrol = new PatrolOrder();
                patrol.SetData("patrolPoint", nearestPoint);
                teamLeader.GetMemory().GetWorldState().Set("order", patrol);

                //[*] Give orders for every other squad member to follow the agent preceding their index in the list. (pass references to their IReGoapAgent)
                for (int i = (int)(squad.SquadSize() - 1); i > 0; i--)
                {
                    //[*] squad member at index i follows the member in the preceding index i - 1.
                    FollowOrder follow = new FollowOrder();
                    follow.SetData("followAgent", squad.Members()[i - 1]);
                    squad.Members()[i].GetMemory().GetWorldState().Set("order", follow);
                }
            }
            // If the expand queue is not empty, then until it is, dequeue each patrolpoint and search what adjacent patrol points need to be investigated.
            // A least one assignment has been made at this point;
            else if (expand.Count > 0)
            {
                while (expand.Count > 0)
                {
                    PatrolPoint parent = expand.Dequeue();
                    // every agent assigned to investigate the parent patrol node, will investigate the adjacent patrol point(s), even if
                    // splitting up is necessary.

                    // Search what agents were assigned to the investigated patrol point that can be expanded upon. Ignores any patrol points
                    // in expand that hadn't been assigned to any member, so continue.
                    if (assignments.ContainsValue(parent))
                    {
                        Dictionary<IReGoapAgent<string, object>, PatrolPoint> copy = new Dictionary<IReGoapAgent<string, object>, PatrolPoint>(assignments);
                        foreach(var assignment in copy)
                        { 
                            // look for assignment which an agent was assigned to investigate the parent patrol point.
                            if (assignment.Value.ReturnPointName() == parent.ReturnPointName())
                            {
                                // Have all adjacent patrol points be investigated by the agent and their team
                                List<PatrolPoint> children = parent.GetAdjacentPoints().ToList();
                                // filter out patrol points investigated in adjacency list

                                List<PatrolPoint> adjacentValidPoints = new List<PatrolPoint>(children);

                                // Filtering modifies the collection children, so enumeration can't execute.
                                foreach(var child in children)
                                {
                                    if (child.IsInvestigated())
                                        adjacentValidPoints.Remove(child);
                                }

                                IReGoapAgent<string, object> teamLeader = assignment.Key;
                                List<IReGoapAgent<string, object>> team;

                                // Retrieved the assoicated team of the team leader, if there is one, even if the leader is a team of only itself.
                                if (divisions.TryGetValue(teamLeader, out team))
                                {
                                    // if only one neighboring patrol point, have the Team leader navigate to it
                                    // and no split necessary
                                    if (adjacentValidPoints.Count == 1)
                                    {
                                        PatrolOrder patrol = new PatrolOrder();
                                        patrol.SetData("patrolPoint", adjacentValidPoints[0]);
                                        teamLeader.GetMemory().GetWorldState().Set("order", patrol);

                                        // Debugging start:
                                        teamLeader.GetMemory().GetWorldState().Set("Patrol to Point", adjacentValidPoints[0].ReturnPointName());
                                        Debug.Log("Gave Order to agent " + teamLeader.ToString());
                                        // Debugging End.
                                        
                                        assignments[teamLeader] = adjacentValidPoints[0];          // overwrite the prior assignment with the new for the agent
                                        //continue;
                                        // No edits to dictionary, as team didn't split into sub teams                                
                                    }
                                    else if (adjacentValidPoints.Count <= 0)
                                    {
                                        PatrolPoint nearestPoint = GetNearestPatrolPoint(teamLeader);

                                        // Would be the same case for other divisions assigned to same patrol point, so just return/exit the GiveOrders() method
                                        if (nearestPoint == null)
                                            return;

                                        PatrolOrder patrol = new PatrolOrder();
                                        patrol.SetData("patrolPoint", nearestPoint);
                                        teamLeader.GetMemory().GetWorldState().Set("order", patrol);
                                        assignments[teamLeader] = nearestPoint;
                                        
                                    }

                                    // More than one nighboring Valid patrolpoint
                                    else
                                    {
                                        Debug.Log("SPLITTING THE TEAM");
                                        int split = team.Count / adjacentValidPoints.Count; // Have members, at indexes divisible by split, investigate

                                        // split could be zero if there are more adjacent patrol points than the team sub-team size, for example,
                                        // 2 / 4 = 0, then just assign an available agent some valid patrol point

                                        int i = team.Count - 1; // enumerating from end of division list

                                        int j = adjacentValidPoints.Count - 1;

                                        if (split == 0)
                                            split = 1;
                                        
                                        Debug.Log("SPLIT IS " + split + "!!!");
                                        Debug.Log("ZERO MOD BY SPLIT IS : " + 0 % split);

                                        // Can't assign anymore agents to investigate adjacent patrol points if no more
                                        // agents in a subdivision to send out.

                                        // May also need to check if j is still greater than or equal to zero.
                                        while (i >= 0 && j >= 0)
                                        {
                                            Debug.Log("ENTERED WHILE INSIDE PATROL BEHAVIOR SPLITTING CASE!!");
                                            Debug.Log("[PATROL BEHAVIOR]: ENUMERATION OF i IS " + i);

                                            // Make sure that the team leader of a division is given a Patrol Order, otherwise the
                                            // team leader and what's left of its division is stuck investigating the initial parent
                                            // Patrol Point assignment
                                            if (j == 1 && i != 0)
                                            {
                                                PatrolOrder patrol = new PatrolOrder();
                                                patrol.SetData("patrolPoint", adjacentValidPoints[j]);
                                                teamLeader.GetMemory().GetWorldState().Set("order", patrol);

                                                assignments[teamLeader] = adjacentValidPoints[j];
                                                j--;
                                                // break; Just causes other agents to just follow.
                                            }

                                            if  (i % split == 0)
                                            {
                                                PatrolOrder patrol = new PatrolOrder();
                                                patrol.SetData("patrolPoint", adjacentValidPoints[j]);
                                                team[i].GetMemory().GetWorldState().Set("order", patrol);

                                                // Make a new assignment for the new sub-division team leader
                                                assignments[team[i]] = adjacentValidPoints[j];
                                                j--;

                                                // Don't make a new team if i == 0, at this point the original team as been divided and reassigned in divisions
                                                if (i != 0)
                                                {
                                                    // Create a new team copying the subgroup starting at this index
                                                    IReGoapAgent<string, object>[] splitTeam = new IReGoapAgent<string, object>[split];
                                                    team.CopyTo(i, splitTeam, 0, split); 
                                                    // team.CopyTo(startingindex to copy, other array, starting index in the other array, # of elements to copy);

                                                    // Appoint this new team to the new resulting team Leader
                                                    divisions[team[i]] = splitTeam.ToList();
                                                    //divisions.Add(team[i], splitTeam.ToList());

                                                    // Remove this split team from the parent team, unless i == 0
                                                    team.RemoveRange(i, split);
                                                    divisions[teamLeader] = team.ToList();
                                                    Debug.Log("SIZE OF ORIGINAL TEAM IS CUT TO " + divisions[teamLeader].Count + " AGENTS!");
                                                }
                                            }
                                            i--;
                                        }

                                        /*
                                        // Some instances there may not be enough agents to cover all neighboring patrol points.
                                        foreach(var child in adjacentValidPoints)
                                        {
                                            Debug.Log("[PATROL BEHAVIOR]: ENUMERATION OF i IS " + i);

                                            if (i < 0)  // Can't assign anymore agents to investigate adjacent patrol points
                                                break;

                                            else if (i % split == 0) // indexes divisible by split always include 0
                                            {
                                                if (i == 0)
                                                    Debug.Log("[Patrol Behavior] Give an adjacent Patrol Point to team leader");

                                                PatrolOrder patrol = new PatrolOrder();
                                                patrol.SetData("patrolPoint", child);
                                                team[i].GetMemory().GetWorldState().Set("order", patrol);

                                                // Make a new assignment for the new sub-division team leader
                                                assignments[team[i]] = child;

                                                // Don't make a new team if i == 0, at this point the original team as been divided and reassigned in divisions
                                                if (i != 0)
                                                {
                                                    // Create a new team copying the subgroup starting at this index
                                                    IReGoapAgent<string, object>[] splitTeam = new IReGoapAgent<string, object>[split];
                                                    team.CopyTo(i, splitTeam, 0, split); 
                                                    // team.CopyTo(startingindex to copy, other array, starting index in the other array, # of elements to copy);

                                                    // Appoint this new team to the new resulting team Leader
                                                    divisions[team[i]] = splitTeam.ToList();
                                                    //divisions.Add(team[i], splitTeam.ToList());

                                                    // Remove this split team from the parent team, unless i == 0
                                                    team.RemoveRange(i, split);
                                                    divisions[teamLeader] = team.ToList();
                                                    Debug.Log("SIZE OF ORIGINAL TEAM IS CUT TO " + divisions[teamLeader].Count + " AGENTS!");
                                                }
                                            }
                                            i--;
                                        }
                                        */
                                    }
                                }
                                // Agent is not associated with any team. 
                                else
                                {
                                    Debug.LogError("Agent is not associated with a team, not even a team of itself");
                                }
                            }
                        }
                    }
                }
            }
        }

        // Get the nearest non-investigated patrol point to some agent
        private PatrolPoint GetNearestPatrolPoint(IReGoapAgent<string, object> agent)
        {
          PatrolPoint nearestPoint = null;
          float minDist = Mathf.Infinity;
          Vector3 currentPos = (Vector3) agent.GetMemory().GetWorldState().Get("startPosition");
          foreach (var patrolpoint in patrolpoints)
          {
            if (patrolpoint.Key.IsInvestigated())
                continue;
            float dist = Vector3.Distance(patrolpoint.Value, currentPos);
            if (dist < minDist)
            {
                nearestPoint = patrolpoint.Key;
                minDist = dist;
            }
          }
          return nearestPoint;
        }
    }
}
