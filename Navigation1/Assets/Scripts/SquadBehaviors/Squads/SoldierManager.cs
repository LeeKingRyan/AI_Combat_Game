using System.Collections;
using System.Collections.Generic;
using Scripts.SquadBehaviors.Core;
using UnityEngine;
using ReGoap.Core;
using Scripts.SquadBehaviors.BlackBoards;

namespace Scripts.SquadBehaviors.Squads
{
    public class SoldierManager : SquadManager<string, object>
    {
        public override void IsAlive()
        {
            if (!(aliveAgents.Count <= 0) && !(squads.Count <= 0))
            {
                foreach(var agent in aliveAgents)
                {
                    // If agent is not alive, then remove it from its squad and from the aliveAgents
                    // dictionary, and remove the squad from the list if that is the last member 

                    // Make sure that the alive key is written inside the agent memory first
                    if (agent.Key.GetMemory().GetWorldState().TryGetValue("alive", out var healthStatus) && !(bool) healthStatus)
                    {
                        ISquad<string, object> squad = agent.Value;
                        squad.DeceasedAgent(agent.Key); // Remove memebr from squad
                        if (squad.SquadSize() <= 0) // remove squad if wiped out
                        {
                            squads.Remove(squad);
                        }
                        aliveAgents.Remove(agent.Key);  // remove agent from alive agents
                    }
                }
            }
        }
        public override bool IsInProximity(IReGoapAgent<string, object> agent, IReGoapAgent<string, object> other)
        {
            // make sure that the start position has been set to agent's memory first before retrieving
            if (agent.GetMemory().GetWorldState().TryGetValue("startPosition", out var agentPosition) && other.GetMemory().GetWorldState().TryGetValue("startPosition", out var otherPosition))
            {
                return Vector3.Distance((Vector3) agentPosition, (Vector3) otherPosition) <= proximity;
            }
            return false;
        }
        // Update the dictionary of alive agents and their associated squad to blackboard and the list of available squads
        public override void UpdateBlackBoard()
        {
            // if aliveAgents || squads have not yet been updated (i.e. less than or equal to count 0, then don't updae the blackboard to avoid a null exception)
            if (!(aliveAgents.Count <= 0) && !(squads.Count <= 0))
            {
                Debug.Log("[Soldier Manager] Sending valid squads and agents to the Global BlackBoard");
                BlackBoard<string, object>.Instance.Set("aliveAgents", aliveAgents);
                BlackBoard<string, object>.Instance.Set("squads", squads);
            }
            else
            {
                BlackBoard<string, object>.Instance.Remove("aliveAgents");
                BlackBoard<string, object>.Instance.Remove("squads");
            }
        }
    }
}
