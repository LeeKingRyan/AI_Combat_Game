using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.AINodes.Nodes;
using Scripts.SquadBehaviors.Core;
using UnityEngine;

namespace Scripts.Goals
{
    // This goal strictly does the second functionality of Ambush Nodes in which the Agent actually
    // ambushes the Player, rather than act in functionality 1 where the Agent attacks from the Ambush Node
    // without the element of surprise. ALos, this Ambush Goal does not include attacking the Player, rather
    // it just coordinates the Agent to get to the Ambush Node, and the KilllayerGoal should take over the
    // the killing part.
    public class AmbushGoal : ReGoapGoalAdvanced<string, object>
    {
        private IReGoapAgent<string, object> agent;
        private ISquad<string, object> squad;
        private List<AmbushNode> usableAmbushNodes;
        protected override void Awake()
        {
            base.Awake();
            goal.Set("ambushReady", true); // Simply have Agent get to some Ambush Node
            agent = GetComponent<IReGoapAgent<string, object>>();
            Priority = 3;
        }
        // Goal is only possible if the BlacckBoard has any AmbushNode for the Agent to consider or if
        // the Agent has already reserved an Ambush node, but doesn't occupy it. Also, the Agent's squad must be
        // engaged first!
        public override bool IsGoalPossible()
        {
            // Get the squad of the agent and check if its engaged, and if not, then ignore this goal.
            if (agent.GetMemory().GetWorldState().TryGetValue("squad", out var team))
            {
                squad = (ISquad<string, object>) team;

                // Only if the Squad is Engaged, can this goal be possible. Squad can only be engaged if they
                // encountered the Player, in other words, if a squad member has seen the Player.

                Debug.Log("[AmbushGoal]: Checking if the Agent's Squad is engaged or NOT");
                if(!squad.IsEngaged())
                    return false;
                
                else
                {
                    Debug.Log("[AmbushGoal]: The Agent's Squad is engaged and now determining if this goal is possible");
                    
                    // If agent has already reserved an AmbushNode, but has not yet navigated to occupy that Ambush Node, then return true. 
                    if (agent.GetMemory().GetWorldState().HasKey("reservedAmbush") && !agent.GetMemory().GetWorldState().HasKey("atAmbush"))
                    {
                        Debug.Log("[AmbushGoal]: The Agent has already reserved an AmbushNode, but hasn't reached it - IsPossible()");
                        return true;
                    }

                    // The agent squad' is engaged, so check for nearby Valid AmbushNodes that are unreserved. Even if the Agent already
                    // occupies an Ambush Node, we want to navigate to an Ambush Node in which the Agent doesn't see the Player to
                    // get the jump on the Player. This relies heavily that Agents can see the Player from a reasonable distance concerning
                    // the map.
                    else if(agent.GetMemory().GetWorldState().TryGetValue("nearbyAmbushes", out var nodes))
                    {
                        usableAmbushNodes = (List<AmbushNode>) nodes;
                        Debug.Log("[AmbushGoal]: Considering the number of nearby Ambush Nodes, and that number is " + usableAmbushNodes.Count);
                        if (usableAmbushNodes.Count <= 0)
                            return false;
                        else
                        {
                            Debug.Log("[AmbushGoal]: Ambush Goal is Possible as there are nearby Ambush Nodes - IsPossible()");
                            return true;
                        }
                    }
                }
            }
            return false;
        }
        // Ambush Goal has a higher priority than the KillPlayer Goal and the Cover Goal if there is some nearby Ambush Nodes
        // and the Player is not seen by Agent. Return a priority of 3 or 6. If already at an ambush Node and don't see
        // player, then don't bother with Ambush Goal.

        // Note that completed goals do not fail, so this goal mustn't be bother with if already at a Valid Ambush Node

        // Ambush Goal simply means navigating to an ambush goal. But if see
        // player and already at ambush node, then return default priority of 3.
        public override float GetPriority()
        {
            ReGoapState<string, object> memory = agent.GetMemory().GetWorldState();
            if (memory.TryGetValue("nearbyAmbushes", out var nodes))
            {
                usableAmbushNodes = (List<AmbushNode>) nodes;
                Debug.Log("[AmbushGoal]: Considering the number of nearby Ambush Nodes, in GetPriority(), is " + usableAmbushNodes.Count);

                if(memory.HasKey("atAmbush"))
                    Debug.Log("[AmbushGoal]: Goal has detected that Agent is at an AMbushNode it reserved.");

                // IN LOS and occupying an Ambush Node, and there are nearby Ambush Nodes. Priority of 6.
                // if (memory.TryGetValue("inLOS", out var danger2) && (bool) danger2 && memory.HasKey("atAmbush"))
                /*
                if (agent.GetMemory().GetWorldState().TryGetValue("reservedAmbush", out var ambushNode))
                {
                    Debug.Log("[AmbushGoal]: Inside Get Priotiy(), the Goal is aware the Agent reserved an AmbushNode");
                    if (memory.TryGetValue("inLOS", out var danger2) && (bool) danger2 && memory.HasKey("atAmbush"))
                    {
                        if (usableAmbushNodes.Count > 0)
                            Debug.Log("[AmbushGoal]: The priority of the Ambush Goal is 6");
                            return 6;
                    }
                }
                */

                // If the Agent is in LOS or the Agent sees the Player, then likely the Agent has lost the element of
                // surprise to Ambush the agent (Functionality 2). The only reason why we wanted this Goal to have a higher
                // priority than default when in LOS and at an AMbush Node specifically, is because we want the Agent to
                // prioritize navigating to other locations, rather than staying in one place attacking through the KillPlayerGoal.

                // What can be done then is that, whenever the Agent is in LOS, then this will take a higher priority than KillPlayerGoal,
                // as the Agent moving from AmbushNode and AmbushNode will just cause the Agent to shoot at the player through the GoTo action
                // while in LOS. We won't have to worry specifically if the Agent is at an AmbushNode, as it will deal with exiting any
                // still valid ambush node it occupies through planning anyway.

                // Meanwhile if the Agent is not in LOS and doesn't see the Player, then the Agent likely has the element of surprise...

                // If this goals priority is just a default of 3, then the Goal is less than the KillPlayerGoal, so KillPlayerGoal will prioritize
                // how the Agent will bast coordinate and attack the Player, either from COver, and AmbushPoint, or navigate to an ambushPoint
                // or some Cover.

                // If Agent sees the Player and either in LOS or NOT, navigate to an Ambush Node nearby with a
                // standard priority of 3. The GetToCover Goal should then override, unless there are no cover nodes
                // for Agent to consider...

                // Prefer to navigate to an AmbushNode without the Agent being in LOS

                // Also for Cover Goal, the priority will have to be higher in order for the Agent to prefer navigating to Cover!
                if(memory.TryGetValue("inLOS", out var danger) && (bool) danger)
                {
                    if (usableAmbushNodes.Count > 0)
                    {
                        Debug.Log("[AmbushGoal]: Is in LOS, so the prioirty of the ambush goal is 6 - GetPriority()");
                        return 6;
                    }
                }

                // DOn't want interference to the KillPlayerGoal to attack from AmbushPoint if not in LOS.
                if ((bool) agent.GetMemory().GetWorldState().Get("seePlayer"))
                {
                    if (usableAmbushNodes.Count > 0)
                    {
                        Debug.Log("[AmbushGoal]: Just see the Player, so the prioirty of the ambush goal is default 3 - GetPriority()");
                        return base.GetPriority();
                    }
                }
                    
                // Don't see Player and is either already at an ambush node or reserved one, or neither, and
                // there are nearby Ambush Nodes, then give Player the element of surprise.
                if (usableAmbushNodes.Count > 0)
                {
                    Debug.Log("[AmbushGoal]: Don't see the Player! The priority of the Ambush Goal is 6 - GetPriority()");
                    return 6;
                }
            }
            Debug.Log("[AmbushGoal]: Returning the base priority.");
            return base.GetPriority();
        }

        private bool AtNode(AmbushNode node)
        {
            Vector3 currentPosition = (Vector3) agent.GetMemory().GetWorldState().Get("startPosition");
            float dist = Vector3.Distance(currentPosition, node.transform.position);
            // ReGoapLogic GameObject is not on the same horizontal axis as the cover nodes and ambush nodes, so the ReGoapLogic Game Object
            // may have to be adjusted.
            if (dist <= 1.5)
            {
                Debug.Log("[AmbushGoal]: At Ambush Location... called in AtNode helper function");
                return true;
            }
            return false;
        }
    }
}

