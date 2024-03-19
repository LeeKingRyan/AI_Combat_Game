using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.SquadBehaviors.BlackBoards;
using UnityEngine;

namespace Scripts.Sensors
{
    // This sensor detects whether or not it's within Player's LOS (line of sight). Agent would
    // only care about being in Player's LOS if the agent sees the Player.
    public class AvoidanceSensor : ReGoapSensor<string, object>
    {
        private List<IReGoapAgent<string, object>> detectedAgents;
        private IReGoapAgent<string, object> agent;
        public override void UpdateSensor()
        {
            var state = memory.GetWorldState();
            if(BlackBoard<string, object>.Instance.TryGetValue("detectedAgents", out var agentAI))
            {
                // Don't see Player, then ignore, not in LOS
                if (state.TryGetValue("seePlayer", out var seePlayer) && !(bool) seePlayer)
                {
                    state.Set("inLOS", false);
                    return;
                }
                detectedAgents = (List<IReGoapAgent<string, object>>) agentAI;
                if (detectedAgents.Count > 0)
                {
                    foreach (var iteratedAgent in detectedAgents)
                    {
                        if(iteratedAgent.ToString() == agent.ToString())
                        {
                            state.Set("inLOS", true);
                            return;
                        }
                    }
                }
                state.Set("inLOS", false);
            }
            else
                state.Set("inLOS", false);
        }

        // Start is called before the first frame update
        void Start()
        {
            detectedAgents = new List<IReGoapAgent<string, object>>();
            agent = GetComponent<IReGoapAgent<string, object>>();
        }
    }
}
