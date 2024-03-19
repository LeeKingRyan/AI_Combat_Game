using System;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.AINodes.Nodes;
using UnityEngine;

namespace Scripts.Actions
{
    public class AttackAction : ReGoapAction<string, object>
    {
        [SerializeField] private Weapon weapon;
        // [SerializeField] private Transform pivot;
        [SerializeField] private Aiming aiming;

        private bool isAutomatic;
        private bool triggerReset;

        protected override void Awake()
        {
            base.Awake();
            // Keep cost of this action to 1.
            Name = "AttackAction";
            // Cost = 5;
        }

        protected override void Start()
        {
            isAutomatic = weapon.isAutomatic;
        }
        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings, ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);
            // check if the agent can still see the player, otherwise action fails
            if ((bool)agent.GetMemory().GetWorldState().Get("seePlayer"))
            {
                // Pivot the weapon to aim at the player
                aiming.AimAtPoint((Vector3) agent.GetMemory().GetWorldState().Get("lastPlayerLocation"));
                // Fire the weapon
                weapon.TryFire();

                triggerReset = isAutomatic;
                done(this);
            }
            else
            {
                triggerReset = true;
                fail(this);
            }
                
        }
        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            settings.Clear();
            // Check if the agent can see the player, and if so, set the player's latest position prior to planning to the
            // ShootAction settings
            if (stackData.goalState.HasKey("playerDead") && stackData.currentState.TryGetValue("seePlayer", out var vision) && (bool) vision)
            {
                stackData.currentState.TryGetValue("lastPlayerLocation", out var playerPosition);
                Vector3 targetPosition = (Vector3) playerPosition;
                settings.Set("targetPosition", targetPosition);
                return new List<ReGoapState<string, object>> { settings };
            }
            return new List<ReGoapState<string, object>> { settings };
        }

        public override ReGoapState<string, object> GetPreconditions(GoapActionStackData<string, object> stackData)
        {
            return preconditions;
        }
        // Just check if there is even a unique patrol point to investigate. Could be checking for a name or a patrol point object
        // in settings.
        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            effects.Clear();
            if (stackData.settings.HasKey("targetPosition"))
                effects.Set("playerDead", true);
            return effects;

        }
        // Only applicable if there are no Valid unreserrved AmbushNodes or CoverNodes nearby 
        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            // Make sure that there are no ambush nodes or cover nodes for Agent to consider first, as attacking in the open
            // should be the last resort of the Agent. Desparate Times equates dumb behaviors.
            if(stackData.currentState.TryGetValue("nearbyAmbushes", out var ambushes)
               && stackData.currentState.TryGetValue("nearbyCover", out var cover))
            {
                List<AmbushNode> ambushNodes = (List<AmbushNode>) ambushes;
                List<CoverNode> coverNodes = (List<CoverNode>) cover;
                if (ambushNodes.Count != 0 || coverNodes.Count != 0)
                    return false;
            }
            if (stackData.currentState.TryGetValue("seePlayer", out var condition))
                return base.CheckProceduralCondition(stackData) && (bool) condition != false;
            return false;
        }
    }
}
