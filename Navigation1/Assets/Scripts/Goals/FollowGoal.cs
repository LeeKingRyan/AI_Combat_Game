using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.SquadBehaviors.Core;

namespace Scripts.Goals
{
    public class FollowGoal : ReGoapGoalAdvanced<string, object>
    {
        public float ThreatLevelThreshold = 0.0f;
        public IReGoapAgent<string, object> otherAgent;
        public IReGoapAgent<string, object> agent;
        protected override void Awake()
        {
            base.Awake();
            agent = GetComponent<IReGoapAgent<string, object>>();
            goal.Set("following", true);
        }            
        
        public override bool IsGoalPossible()
        {   
            if (agent.GetMemory().GetWorldState().TryGetValue("threatLevel", out var threat) && agent.GetMemory().GetWorldState().TryGetValue("order", out object order))
            {
                IOrder<string, object> newOrder = (IOrder<string, object>)order;
                if ((float) threat <= ThreatLevelThreshold && newOrder.GetName() == "follow")
                {
                    Debug.Log("[FollowGoalii] The Follow Goal is Possible");
                    return base.IsGoalPossible();
                }
            }
            return false;
        }
        // judge the priority based on whether the goal is possible and if the Threat Level Threshold isn't exceeded.
        public override float GetPriority()
        {
            if(agent.GetMemory().GetWorldState().TryGetValue("order", out object order) &&
                (float) agent.GetMemory().GetWorldState().Get("threatLevel") <= ThreatLevelThreshold)
            {
                IOrder<string, object> newOrder = (IOrder<string, object>)order;
                // Check the order and threat level of the agent: 
                if (newOrder.GetName() == "follow")
                {
                    return 10.0f;
                }
            }
            return base.GetPriority();
        }
    }
}
