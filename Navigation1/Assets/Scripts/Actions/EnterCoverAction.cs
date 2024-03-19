using System;
using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using UnityEngine;

namespace Scripts.Actions
{
    // Placeholder Action that for future developemnt can be set to run an Animation by calling the Animate State
    // when Agent performs to officially enter some Cover. This action should be of lower cost, as it should be the
    // last action in the plan when navigating to use some Cover 
    public class EnterCoverAction : ReGoapAction<string, object>
    {
        private List<CoverNode> usableCover;

        protected override void Awake()
        {
            base.Awake();
            // Keep cost of this action to 1.
            Name = "EnterCoverAction";
        }

        // PlaceHolder, this action is more so to chain a plan to be able to reserve a Cover Node at the start. 
        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings,
            ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);
            doneCallback(this);
        }

        // If already in Cover, then ignore thisAction, otherwise, try to find the nearest Valid and unreserved cover
        // that Agent considers from their memory, if it hadn't reserved cover already.
        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            if (!stackData.currentState.HasKey("inCover") && stackData.goalState.HasKey("inCover"))
            {
                // If the Agent already reserved cover, then it will just navigate to that cover that's already been reserved.
                if (stackData.currentState.TryGetValue("reservedCover", out var cover))
                {
                    settings.Set("nearestCover", cover);
                    settings.Set("getToCover", true);
                    return base.GetSettings(stackData);
                }

                // Otherwise, go to the nearest Unreserved CoverNode.
                usableCover = (List<CoverNode>) stackData.currentState.Get("nearbyCover");
                CoverNode nearestCover = GetNearestCover((Vector3) stackData.currentState.Get("startPosition"));
                // If there's Valid cover nearby that is not reserved 
                if (nearestCover != null)
                {
                    settings.Set("nearestCover", nearestCover);
                    settings.Set("getToCover", true);
                    return base.GetSettings(stackData);
                }
            }
            return new List<ReGoapState<string, object>>();
        }
        // Only chain the Enter Cover Plan to have the ReserveAction at the start, only if reservedCover hasn't been set
        // by the agent, meaning that the Agent never reserved any CoverNode
        public override ReGoapState<string, object> GetPreconditions(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.HasKey("getToCover"))
            {
                CoverNode cover = (CoverNode) stackData.settings.Get("nearestCover");
                preconditions.Set("isAtNode", cover);
                
                // If Agent hasn't reserved Cover, then set to the Goal state to reserve the CoverNode
                if(!stackData.currentState.HasKey("reservedCover"))
                    preconditions.Set("reservedNode", cover);

                // Set to the preconditions if suppressive fire is necessary if the agent is in Player's LOS (line of sight)
                if((bool) stackData.currentState.Get("inLOS"))
                    preconditions.Set("suppressiveFire", true);
            }
            return preconditions;
        }
        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.HasKey("getToCover"))
                effects.Set("inCover", true);
            return effects;
        }

        // If the Agent is not already in cover, and there is nearby cover, or the Agent has already reserved Valid Cover, but has yet to occupt it
        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            return base.CheckProceduralCondition(stackData) && !stackData.settings.HasKey("getToCover");
        }

        private CoverNode GetNearestCover(Vector3 position)
        {
          CoverNode nearestCover = null;
          float minDist = Mathf.Infinity;
          Vector3 currentPos = position;

          foreach (var cover in usableCover)
          {
            if (cover.IsLocked())
                continue;
            float dist = Vector3.Distance(cover.transform.position, currentPos);
            if (dist < minDist)
            {
                nearestCover = cover;
                minDist = dist;
            }
          }
          return nearestCover;
        }
    }
}
