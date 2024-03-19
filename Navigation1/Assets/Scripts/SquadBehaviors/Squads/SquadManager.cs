using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ReGoap.Core;
using Scripts.SquadBehaviors.Core;

namespace Scripts.SquadBehaviors.Squads
{
    
    public class SquadManager<T, W> : MonoBehaviour, ISquadManager<T, W>
    {
        public static SquadManager<T, W> Instance;
        public float maxSquadSize = 4;
        public float maxSquads = 1;
        public float proximity = 0.5f;
        public float managementDelay = 0.5f; // squad management delay
        protected float lastManagementTime;

        protected Dictionary<IReGoapAgent<T, W>, ISquad<T, W>> aliveAgents;

        protected List<ISquad<T, W>> squads;
        void Awake()
        {
            if (Instance != null)
            {
                Destroy(this);
                var errorString =
                    "[SquadManager] Trying to instantiate a new squad manager but there can be only one per scene.";
                Debug.LogError(errorString);
                throw new UnityException(errorString);
            }
            Instance = this;
            lastManagementTime = -100;
            aliveAgents = new Dictionary<IReGoapAgent<T, W>, ISquad<T, W>>(2 * (int) (maxSquads * maxSquadSize));
            squads = new List<ISquad<T, W>>((int) (2 * maxSquads));
            // RefreshSquadType();
            // What about the instance to the blackboard we try to update?
        }
        
        void Update()
        {
            // Only check what agents are alive and what squads can be merged every half a second, then update this
            // information to the blackboard.
            if (Time.time - lastManagementTime <= managementDelay)
            {
                IsAlive();          // Remove deceased agents from the aliveAgents dictionary, and any wiped squads.
                CombineSquads();    // Combine squads that are within proximity and their sum is less than or equal max squad capacity.
                UpdateBlackBoard(); // send to blackboard list of available squads and dictionary of living agents with their associated squad.

                // If there are any squads available, then print out each squad members name
                int i = 0;
                if (squads.Count > 0)
                {
                    Debug.Log("[Squad Manager] There are available squads");
                    foreach (var squad in squads)
                    {
                        i++;
                        Debug.Log("[Squad Manager] Squad Members of Squad " + i + ":");
                        foreach(var member in squad.Members())
                        {
                            Debug.Log("[Squad Manager] Squad Member " + member.ToString() + " of Squad " + i);
                        }
                    }
                }
                else
                {
                    Debug.Log("[Squad Manager] No available Squads yet");
                }
            }
            lastManagementTime = Time.time;
        }

        public virtual bool IsInProximity(IReGoapAgent<T, W> agent, IReGoapAgent<T, W> other)
        {
            return true;
        }
        // Combine Squads only if members are in proximity and the sum of members is less than max squad size.
        public virtual void CombineSquads()
        {
            ISquad<T, W> mainSquad;
            int squadIndex;
            int end;
            foreach (var squad in squads)
            {
                if (squad.SquadSize() < maxSquadSize)
                {
                    mainSquad = squad;
                    squadIndex = squads.IndexOf(squad);
                    end = squads.Count - 1;
                    // starting from the end, search for eligible squad to merge, unless end equals the squad we compare to
                    while (squadIndex < end)
                    {
                        if (squads[end].SquadSize() <= maxSquadSize - mainSquad.SquadSize())
                        {
                            foreach(var agent in mainSquad.Members())
                            {
                                foreach(var member in squads[end].Members())
                                {
                                    // merge squads
                                    if (IsInProximity(agent, member))
                                    {
                                        mainSquad.MergeSquad(squads[end]);
                                        // remove the absorbed squad in the squads list, and reappoint the agents
                                        // in the absorbed squad to be associated with the new main squad
                                        foreach(var transfer in squads[end].Members())
                                        {
                                            aliveAgents[transfer] = mainSquad;
                                        }
                                        squads.Remove(squads[end]);
                                        // Remove the main squad's behavior, so a new behavior is calculated considering the new members
                                        mainSquad.RemoveBehavior();
                                    }
                                }
                            }
                        }
                        end--;
                    } // Outer If statement
                }
            } // Outer For each statement
        }
        // Agents reference this squad manager upon awakening, and add themselves to the
        // dictionary of live agents and to their respective squads based on proximity, otherwise they have their own squad.
        public virtual void AddToSquad(IReGoapAgent<T, W> agent)
        {
            if (!aliveAgents.ContainsKey(agent) && squads.Count > 0)
            {
                foreach (var squad in squads)
                {
                    if (squad.SquadSize() == maxSquadSize)
                        continue;
                    foreach (var member in squad.Members())
                    {
                        if (IsInProximity(agent, member))
                        {
                            squad.AddAgent(agent);
                            aliveAgents.Add(agent, squad);
                            return;
                        }
                    }
                }
                // Create a new squad with the agent if no other agents in proximity, and add the
                // agent to the aliveAgents list and the new squad to the list of valid squads.
                if (!aliveAgents.ContainsKey(agent))
                {
                    Squad<T, W> newSquad = new Squad<T, W>(agent);
                    aliveAgents[agent] = newSquad;
                    squads.Add(newSquad);
                }
            }
            else
            {
                Squad<T, W> newSquad = new Squad<T, W>(agent);
                aliveAgents[agent] = newSquad;
                squads.Add(newSquad);
            }
        }
        public virtual void IsAlive()
        {

        }

        public virtual void UpdateBlackBoard()
        {

        }


    }
}