using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using System;
using UnityEngine;

namespace Scripts.Actions
{
    /// <summary>
    /// This action considers multiple scenarios as listed:
    /// 1. Shoot at Player from Cover [Already in cover]: The Agent is already at a Valid CoverNode, so the agent will
    /// proceed to attack from cover, either using the SmartObject StepCover animation or if the Agent sees the Player
    /// already, then the Agent will simply Attack.
    /// 2. The Agent is not in cover, but it has already reserved cover, thus the Agent will continue to navigate to the
    /// reserved CoverNode and shoot from their or use the SmartObject StepCover.
    /// 3. The Agent has yet to reserve cover, but there's valid cover neaby that's unreserved, so it reserves the nearest Cover
    /// Node, and navigates to, to then proceed to Attack if sees the Player or use the related SmartObject at the Node only if
    /// the CoverNode is still Valid
    /// 
    /// Note: The EnterCoverAction handles what CoverNode the Agent will occupy and if it already reserved cover, while this
    ///       action handles whether or not it needs cover or already has cover. 
    /// </summary>

    public class AttackFromCoverAction : ReGoapAction<string, object>
    {
        [SerializeField] private Weapon weapon;
        // [SerializeField] private Transform pivot;
        [SerializeField] private Aiming aiming;
        protected override void Awake()
        {
            base.Awake();
            Name = "AttackFromCoverAction";
            Cost = 1;       
        }

        // Use the related Smart Object or just shoot if see the Player. This Action fails if the Cover is invalidated, or the Agent doesn't occupy the Cover it reserved!
        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings, ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);
            // Though the Agent has reserved cover up to this point, the reservedCover key in agent memory could be erased if the Cover became invalidated. This is
            // consequence of how CoverSensor is implemented in which any invalidated cover including reserved are no longer considered by the Agent.

            // If Agent doesn't reserve cover, due to invalidation, nor does it occupy the cover it reserved, then this action failed
            if (!agent.GetMemory().GetWorldState().TryGetValue("reservedCover", out var cover) || !agent.GetMemory().GetWorldState().HasKey("inCover"))
                failCallback(this);

            // Two scenarios, if the Agent sees the Player from cover, and at this point, cover shouldn't be invalidated, then continue to fire until run out of ammunition
            // or the Player is no longer in sight
            else if(agent.GetMemory().GetWorldState().TryGetValue("seePlayer", out var vision) && (bool) vision)
            {
                while ((bool) agent.GetMemory().GetWorldState().Get("seePlayer"))   // need to consider ammunition too!
                {
                    // Pivot the weapon to aim at the player
                    aiming.AimAtPoint((Vector3) agent.GetMemory().GetWorldState().Get("lastPlayerLocation"));
                    // Fire the weapon
                    weapon.TryFire();
                }
                doneCallback(this);
            }
            // Alternatively, the Agent doesn't see the Player, but Cover at this point is still Valid, otherwise Action would have failed the previous check, then use the
            // Smart Object in this CoverNode (i.e. StepCover)

            // Placeholder for now
            else
                doneCallback(this);

        }

        // Check if the Agent is already in cover or not.
        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            // In the CoverSensor, "inCover" key is never set to false, but true, and is removed otherwise.
            if (stackData.goalState.HasKey("playerDead") && !stackData.currentState.HasKey("inCover"))
            {
                settings.Set("needCover", true);
                return base.GetSettings(stackData);
            }
            else if (stackData.goalState.HasKey("playerDead") && !stackData.currentState.HasKey("inCover"))
            {
                settings.Set("needCover", false);
                return base.GetSettings(stackData);
            }
            return new List<ReGoapState<string, object>> { settings };
        }
        // This action has the same effect as the standard AttackAction, but since this action is of a lesser cost, then this action will be considered first.
        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.HasKey("needCover"))
                effects.Set("playerDead", true);
            return effects;
        }

        // If already in cover, then don't write to preconditions the key <"inCover", true>, otherwise write the condition to the goal state. 
        public override ReGoapState<string, object> GetPreconditions(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.TryGetValue("needCover", out var needCover) && (bool) needCover)
                preconditions.Set("inCover", true);
            return preconditions;
        }

        // Make sure that there are valid Cover Nodes that are unreserved in the Agent's memory [check in agent's memory for usableCover].
        // EnterCover can handle whether or not the usable cover in Agent's memory is still usuable [unreserved]
        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            
            if(stackData.currentState.TryGetValue("nearbyCover", out var usableCover))
            {
                List<CoverNode> potentialCover = (List<CoverNode>) usableCover;
                return base.CheckProceduralCondition(stackData) && potentialCover.Count > 0;
            }
            else
                return false;
        }
    }
}
