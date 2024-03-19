using UnityEngine;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.SquadBehaviors.Core;


namespace Scripts.Goals{
    public class PatrolGoal : ReGoapGoalAdvanced<string, object>
    {
        public float ThreatLevelThreshold = 0.0f;
        private IReGoapAgent<string, object> agent;
        
        protected override void Awake()
        {
            base.Awake();
            agent = GetComponent<IReGoapAgent<string, object>>();
            
            // Rather than be reliant on setting the goal state if an order is given, just set the goal state regardless
            // if there is an order. Even if [a/the] planner tries to formulate a subsequent plan, if there is no Patrol order, then
            // this goal can never be validated as it will not have a valid plan to fullfill its conditions.
            goal.Set("investigatedPatrolPoint", true);
            // goal.Set("reconcilePosition", true);
        }

        // Goal is only possible if the threat level of the agent isn't more than the threshold for this goal, and if the patrol order is
        // given to the agent
        public override bool IsGoalPossible()
        {
            if (agent.GetMemory().GetWorldState().TryGetValue("threatLevel", out var threat) &&
                agent.GetMemory().GetWorldState().TryGetValue("order", out object order))
            {
                IOrder<string, object> newOrder = (IOrder<string, object>) order;
                if ((float) threat <= ThreatLevelThreshold && newOrder.GetName() == "patrol")
                {
                    return base.IsGoalPossible();
                }
            }    
            return false;
        }

        // Maybe unecessary to dynamically change the priority, as if the goal isn't even possible, then the priority becomes irrelevant.

        // Set this goal to have a higher priority if the patrol point of interest to investigate is different from what is currently being investigated.
        // Not during planning, but when the plan is running...
        public override float GetPriority()
        {
            if(agent.GetMemory().GetWorldState().TryGetValue("order", out object order) &&
                (float) agent.GetMemory().GetWorldState().Get("threatLevel") <= ThreatLevelThreshold)
            {
                IOrder<string, object> newOrder = (IOrder<string, object>) order;
                // Check the order and threat level of the agent: 
                if (newOrder.GetName() == "patrol")
                {
                    return 10.0f;
                }
            }
            return base.GetPriority();
        }
    }
}
