using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ReGoap.Unity;
using ReGoap.Core;
using System;
using Scripts.SquadBehaviors.Core;

namespace Scripts.Actions
{
    public class InvestigateAction : ReGoapAction<string, object>
    {
        private const string INVESTIGATED_POINT = "investigatedPatrolPoint";
        private const string PATROL_POINT_NAME = "patrolPointName";
        private const string PATROL_POINT = "patrolPoint";
        private const string PATROL_POINT_POSITION = "patrolPointPosition";
        const string IS_AT_POSITION = "isAtPosition";

        public float stoppingDistance = 1.5f;

        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings, ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);
            if (settings.TryGetValue(PATROL_POINT, out var point))
            {
                PatrolPoint finish = (PatrolPoint) point;
                // If Patrol Point is already investigated, then move on.
                if (finish.IsInvestigated())
                    fail(this);
                finish.Investigate();
                Debug.Log("[From Investigate Action] Push the next Action");
                done(this);
            }
        }

        // New Goal State:
        // goal.Set("investigatedPatrolPoint", true);
        // goal.Set("reconcilePosition", true);

        // Rather than looking for the patrol point name set in the goal state, we know that the patrol goal is only possible if there
        // is a patrol order in agent's memory, so access the agent's memory instead for the patrol point of interest to navigate to.

        // The Patrol Order possesses the Patrol Point of interest to investigate, so we can get its transform and its position directly.
        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            // Look inside the goal state and make sure that there is the condition to investigate a patrol point, otherwise don't set the settings.
            // Also make sure an order is given.
            if (stackData.goalState.HasKey(INVESTIGATED_POINT) && stackData.currentState.HasKey("order"))
            {
                IOrder<string, object> order = (IOrder<string, object>) stackData.currentState.Get("order");

                if (order.GetName() != "patrol")
                    return new List<ReGoapState<string, object>> { settings };

                PatrolPoint pointOfInterest = (PatrolPoint) order.GetDataValue("patrolPoint");
                settings.Set(PATROL_POINT, pointOfInterest);
                settings.Set(PATROL_POINT_POSITION, pointOfInterest.transform.position);
                settings.Set(PATROL_POINT_NAME, pointOfInterest.ReturnPointName());
                
                Debug.Log("Investigate Action's Settings has been initialized from Patrol Orrder");
                Debug.Log("[Investigate Actionii GetSettings()] Investigating Patrol Point reported by Order: " + pointOfInterest.ReturnPointName());
                return new List<ReGoapState<string, object>> { settings };
                
            }
            /*
            else if (stackData.goalState.HasKey(INVESTIGATED_POINT) && stackData.currentState.HasKey("nearestPatrolPoint"))
            {
                PatrolPoint pointOfInterest = (PatrolPoint) stackData.currentState.Get("nearestPatrolPoint");
                settings.Set(PATROL_POINT, pointOfInterest);
                settings.Set(PATROL_POINT_POSITION, pointOfInterest.transform.position);
                settings.Set(PATROL_POINT_NAME, pointOfInterest.ReturnPointName());
                
                Debug.Log("Investigate Action's Settings has been initialized (normal)");
                Debug.Log("[Investigate Actionii GetSettings()] Investigating Patrol Point (normal)" + pointOfInterest.ReturnPointName());
                return new List<ReGoapState<string, object>> { settings };
            }
            */

            return new List<ReGoapState<string, object>> { settings };
        }
        // Precondition is to be at the Patrol Point Position
        public override ReGoapState<string, object> GetPreconditions(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.HasKey(PATROL_POINT)) {
                preconditions.Set(IS_AT_POSITION, stackData.settings.Get(PATROL_POINT_POSITION));
                preconditions.Set("stoppingDistance", stoppingDistance);
            }
            return preconditions;
        }
        // Just check if there is even a unique patrol point to investigate. Could be checking for a name or a patrol point object
        // in settings.
        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.HasKey(PATROL_POINT_NAME))
                effects.Set(INVESTIGATED_POINT, true);
            return effects;

        }
        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            return base.CheckProceduralCondition(stackData) && stackData.settings.HasKey(PATROL_POINT);
        }
    }
}
