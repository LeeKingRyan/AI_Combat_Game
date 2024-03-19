using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.SquadBehaviors.BlackBoards;
using Scripts.SquadBehaviors.Core;
using UnityEngine;

namespace Scripts.Sensors
{
    // Get from the Global BlackBoard the squad that this Agent is associated with and set
    // it to the agent's memory 
    public class SquadSensor : ReGoapSensor<string, object>
    {
        private IReGoapAgent<string, object> agent;
        private void Awake()
        {
            agent = GetComponent<IReGoapAgent<string, object>>();
        }
        // Start is called before the first frame update
        void Start()
        {
            
        }

        // Update is called once per frame
        void Update()
        {
            
        }

        public override void UpdateSensor()
        {
            if(!BlackBoard<string, object>.Instance.TryGetValue("aliveAgents", out var dictionary))
                return;
            else
            {
                Dictionary<IReGoapAgent<string, object>, ISquad<string, object>> affiliations = (Dictionary<IReGoapAgent<string, object>, ISquad<string, object>>) dictionary;
                if(!affiliations.ContainsKey(agent))
                    return;
                else
                {
                     var state = memory.GetWorldState();
                     state.Set("squad",affiliations[agent]);
                }
            }
        }
    }
}

