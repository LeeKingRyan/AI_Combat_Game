using System;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.FSM;
using Scripts.SquadBehaviors.Core;
using UnityEngine;

namespace Scripts.Actions
{
    public class FollowAction : ReGoapAction<string, object>
    {
        public float stoppingDistance = 1.0f;
        protected GoToState goToState;
        private const string FOLLOW = "follow";


        protected override void Awake()
        {
            base.Awake();
        }

        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings,
            ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);
            done(this);
        }
        

        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            if (stackData.goalState.HasKey("following") && stackData.currentState.HasKey("order"))
            {
                IOrder<string, object> order = (IOrder<string, object>) stackData.currentState.Get("order");

                if (order.GetName() != "follow")
                    return new List<ReGoapState<string, object>> { settings };

                IReGoapAgent<string, object> otherAgent = (IReGoapAgent<string, object>) order.GetDataValue("followAgent");
                // Set the agent we are to follow
                // set the position of the agent, or the transform etc.
                settings.Set(FOLLOW, otherAgent);
                if (!otherAgent.GetMemory().GetWorldState().TryGetValue("startPosition", out var otherAgentPosition))
                {
                    stackData.settings.Clear();
                    return new List<ReGoapState<string, object>> { settings };
                }
                Vector3 position = (Vector3) otherAgentPosition;
                settings.Set("otherAgentPosition", position);

                Debug.Log("INITIALIZED FOLLOW ACTION II SETTINGS");
                return new List<ReGoapState<string, object>> { settings };
            }
            return new List<ReGoapState<string, object>> { settings };
        }
        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.HasKey("follow"))
            {
                Debug.Log("SET EFFECTS OF FOLLOW ACTION II SETTINGS");
                effects.Set("following", true);
            }
            return effects;
        }
        public override ReGoapState<string, object> GetPreconditions(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.HasKey("follow") && stackData.settings.HasKey("otherAgentPosition"))
            {
                Debug.Log("SET PRECONDITIONS OF FOLLOW ACTION II SETTINGS");
                preconditions.Set("isAtPosition", stackData.settings.Get("otherAgentPosition"));
                preconditions.Set("stoppingDistance", stoppingDistance);
            }
            return preconditions;
        }

        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            return base.CheckProceduralCondition(stackData) && stackData.settings.HasKey("follow");
        }
    }   
}
