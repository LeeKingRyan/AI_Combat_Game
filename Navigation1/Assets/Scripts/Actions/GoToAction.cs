using System;
using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.AINodes.Nodes;
using Scripts.FSM;
using Scripts.SquadBehaviors.Core;
using UnityEngine;

namespace Scripts.Actions
{
    [RequireComponent(typeof(GoToState))]
    public class GoToAction : ReGoapAction<string, object>
    {
        protected GoToState goToState;
        const string OBJECTIVE_POSITION = "objectivePosition";
        const string IS_AT_POSITION = "isAtPosition";
        const string RECONCILE_POSITION = "reconcilePosition";
        const string START_POSITION = "startPosition";
        protected override void Awake()
        {
            base.Awake();
            Name = "GoToAction";
            Cost = 5;
            goToState = GetComponent<GoToState>();
            
        }
        // Fail GoTo Action if caught in Player's LOS, as we want to navigate somewhere while dealing suppressive fire when in LOS.
        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings,
                                 ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);

            // if caught in LOS, then the Agent fails the GoTo action [Note that this check is also done in the GoTo state]
            if(agent.GetMemory().GetWorldState().TryGetValue("inLOS", out var los) && (bool) los)
                failCallback(this);

            // Reconcile position before navigating to a new target destination check
            if (settings.TryGetValue(OBJECTIVE_POSITION, out var followTarget) && settings.TryGetValue("stopDistance", out var radius))
                goToState.GoTo((Vector3) followTarget, OnDoneMovement, OnFailureMovement, (float) radius);

            // Navigate to some target destination
            if (settings.TryGetValue(OBJECTIVE_POSITION, out var v))
                goToState.GoTo((Vector3) v, OnDoneMovement, OnFailureMovement);

            // Navigate to some node's position
            if (settings.TryGetValue("objectiveNode", out var node))
            {
                Node<string, object> objectiveNode = (Node<string, object>) node;
                Debug.Log("GotoAction: The Objective Node position is at coordinates" + objectiveNode.transform.position);
                goToState.GoTo(objectiveNode, OnDoneMovement, OnFailureMovement);
            }

            else
                failCallback(this);
            
        }

        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.HasKey("objectiveNode"))
                Debug.Log("[GoToAction]: The Go To Action has an Objective Node it needs to navigate to");
            else
                Debug.Log("[GoToAction]: The Go To Action has NO Objective Node it needs to navigate to");
            return base.CheckProceduralCondition(stackData) && (stackData.settings.HasKey(OBJECTIVE_POSITION) || stackData.settings.HasKey("objectiveNode"));
        }

        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            effects.Clear();
            if (stackData.settings.TryGetValue(OBJECTIVE_POSITION, out var objectivePosition))
            {
                // Set the objective position
                effects.Set(IS_AT_POSITION, objectivePosition);

                // satisfy the reconcile position key
                if (stackData.settings.HasKey(RECONCILE_POSITION))
                    effects.Set(RECONCILE_POSITION, true);
                
                // satisfy the stop distance key.
                if (stackData.settings.TryGetValue("stopDistance", out var stopDistance))
                    effects.Set("stoppingDistance", stopDistance);
            }
            // Satisy that er reached the Objective node
            else if (stackData.settings.TryGetValue("objectiveNode", out var node))
                effects.Set("isAtNode", node);

            // neither navigate to a node or some Vector3 destination
            else
            {
                effects.Clear();
            }
            return base.GetEffects(stackData);
        }

        // Two optional settings, one if there is an "isAtPosition" key inside the goal state of the given stackData,
        // and the other if there is a single condition in goal state which has the key "reconcilePosition". Ony one setting at
        // a time for this call to GetSettings. But if there were more than one returned setting, then planner will apply them to each
        // their own stack data to pass to preconditions() effects, checkprocedural() and run()
        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            settings.Clear();
            if (stackData.goalState.TryGetValue(IS_AT_POSITION, out var isAtPosition) &&
                stackData.goalState.TryGetValue("stoppingDistance", out var distance))
            {
                settings.Set(OBJECTIVE_POSITION, isAtPosition);
                settings.Set("stopDistance", distance);
                return base.GetSettings(stackData);
            }

            else if (stackData.goalState.TryGetValue(IS_AT_POSITION, out var destination))
            {
                settings.Set(OBJECTIVE_POSITION, destination);
                return base.GetSettings(stackData);
            }

            else if (stackData.goalState.TryGetValue("isAtNode", out var node))
            {
                settings.Set("objectiveNode", node);
                return base.GetSettings(stackData);
            }

            // Itherwise if the goal state is of size one, then get from agent memory the startPosition, and that will be the
            // objectivePosition, and reconcilePosition is set to true.
            else if (stackData.goalState.HasKey(RECONCILE_POSITION) && stackData.goalState.Count == 1)
            {
                settings.Set(OBJECTIVE_POSITION, stackData.agent.GetMemory().GetWorldState().Get(START_POSITION));
                settings.Set(RECONCILE_POSITION, true);
                return base.GetSettings(stackData);
            }
            return new List<ReGoapState<string, object>>();
        }

        // Calculate the cost based on the destination and distance needed to be covered.
        public override float GetCost(GoapActionStackData<string, object> stackData)
        {
            var distance = 0.0f;
            if (stackData.settings.TryGetValue(OBJECTIVE_POSITION, out object objectivePosition)
                && stackData.currentState.TryGetValue(IS_AT_POSITION, out object isAtPosition))
            {
                if (objectivePosition is Vector3 p && isAtPosition is Vector3 r)
                    distance = (p - r).magnitude;
            }
            else if (stackData.goalState.TryGetValue("isAtNode", out var node)
                     && stackData.currentState.TryGetValue(IS_AT_POSITION, out object position))
            {
                Node<string, object> objectiveNode = (Node<string, object>) node;
                if (objectiveNode.transform.position is Vector3 p && position is Vector3 r)
                    distance = (p - r).magnitude;
            }
            return base.GetCost(stackData) + Cost + distance;
        }

        protected virtual void OnFailureMovement()
        {
            failCallback(this);
        }

        protected virtual void OnDoneMovement()
        {
            doneCallback(this);
        }
    }
}
