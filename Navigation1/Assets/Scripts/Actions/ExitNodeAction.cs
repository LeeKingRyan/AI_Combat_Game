using System;
using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.AINodes.Core;
using UnityEngine;

namespace Scripts.Actions
{
    public class ExitNodeAction : ReGoapAction<string, object>
    {
        protected override void Awake()
        {
            base.Awake();
            Name = "ExitNodeAction";
            Cost = 1;
        }
        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings, ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);
            // May be redundant to exit a node that is already invalidated...
            if (settings.TryGetValue("abandonNode", out var node))
            {
                INode<string, object> abandonNode = (INode<string, object>) node;
                Debug.Log("[ExitNodeAction]: Exiting Node.");
                abandonNode.ExitNode();
                doneCallback(this);
            }
        }

        // If the goal state has only one condition or two conditions including reservedNode and exitedNode key, then this action will have preconditons and effects
        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            if (stackData.goalState.TryGetValue("exitedNode", out var node) && 
                ((stackData.goalState.HasKey("reservedNode") && stackData.goalState.Count == 2) || stackData.goalState.Count == 1))
            {
                INode<string, object> abandonNode = (INode<string, object>) node;
                settings.Set("abandonNode", abandonNode);
                return base.GetSettings(stackData);
            }
            return base.GetSettings(stackData);
        }

        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.TryGetValue("abandonNode", out var node))
            {
                INode<string, object> abandonNode = (INode<string, object>) node;
                effects.Set("exitedNode", abandonNode);
            }
            return effects;
        }

        // No preocnditions necessary
        public override ReGoapState<string, object> GetPreconditions(GoapActionStackData<string, object> stackData)
        {
            return preconditions;
        }

        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            return base.CheckProceduralCondition(stackData) && stackData.settings.HasKey("abandonNode");
        }
    }
}
