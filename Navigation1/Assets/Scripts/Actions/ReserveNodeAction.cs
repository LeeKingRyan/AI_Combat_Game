using System;
using System.Collections.Generic;
using System.Diagnostics;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.AINodes.Core;
using UnityEngine;

namespace Scripts.Actions
{
    public class ReserveNodeAction : ReGoapAction<string, object>
    {
        private INode<string, object> node;

        protected override void Awake()
        {
            base.Awake();
            // Keep cost of this action to 1.
            Name = "ReserveNodeAction";
            Cost = 5;
        }

        // Reserves node if not already locked, and it would not make sense for this agent to reserve a Node it already reserved! The other actions, such as
        // EnterCover or EnterAmbush, make sure that the Agent doesn't consider reserveNode action if already reserved a relevant node.
        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings, ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);
            UnityEngine.Debug.Log("[ReserveNodeAction]: The Action is running");
            if (settings.TryGetValue("reservation", out var nodeOfInterest))
            {
                node = (INode<string, object>) nodeOfInterest;
                if (node.LocKNode(agent))
                {
                    UnityEngine.Debug.Log("[ReserveNodeAction]: Locking the Node");
                    doneCallback(this);
                }
                else
                {
                    UnityEngine.Debug.Log("[ReserveNodeAction]: Failed to reserve a node, because it's already locked!");
                    failCallback(this);     // issue this could fail the KillPlayerGoal, and the goal won't be considered for planning, thus other goals should be made as a back up
                }
            }
            // No reservation, then why are we trying to even run this action!!
        }

        // set to settings the INode<string, object> that is to be reserved by this agent, only if the goal state
        // of he given stack has a single property! This ensures that this is the first action of the plan
        // when dealing with nodes that need to be reserved.
        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            settings.Clear();
            // If the goals are more macro in which multiple Nodes are to be reserved, then this cannot be the last node
            // in the plan, therefore, every Node related plan should only be comprised of a single node.
            if (stackData.goalState.TryGetValue("reservedNode", out var reservation) && stackData.goalState.Count  == 1)
            {
                node = (INode<string, object>) reservation;
                settings.Set("reservation", node);
                return base.GetSettings(stackData);
            }
            //return new List<ReGoapState<string, object>> { settings };
            return new List<ReGoapState<string, object>>();
        }

        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            if(stackData.settings.TryGetValue("reservation", out var nodeOfInterest))
                effects.Set("reservedNode", nodeOfInterest);
            else
                effects.Clear();
            return base.GetEffects(stackData);
        }

        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            if(stackData.settings.HasKey("reservation"))
                UnityEngine.Debug.Log("[ReserveNodeAction]: This Action has a Node it needs to reserve");
            else
                UnityEngine.Debug.Log("[ReserveNodeAction]: This Action has NO Node to reserve");
            return base.CheckProceduralCondition(stackData) && stackData.settings.HasKey("reservation");
        }
    }
}
