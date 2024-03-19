using System;
using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.AINodes.Core;
using Scripts.AINodes.Nodes;
using Scripts.FSM;
using UnityEngine;
using UnityEngine.AI;

namespace Scripts.Actions
{

    // This Action is very similar to the GoTo Action, with the only difference being that if the Agent sees the Player and is within Player's
    // LOS (line of sight), then this Action will set to the the GoTo state the destination and the GoTo state will simply set the destination
    // to the NavMeshAgent Component of the Parent Game Object.

    // Meanwhile, as the Agent navigates to the Objective destination, the Agent will shoot at the Player if the Agent sees the Player and
    // detects that it's within PLayer's LOS.
    
    // Unlike GoTo Action, if use the GoTo state, then the GoTo state will have to worry about shooting, but setting the destination to the go
    // to state means that there are other complications for implementation, like how when a stopping distance and a distance Agent needs to be within
    // for GoTo state to transitions out on success. 
    public class AttackToAction : ReGoapAction<string, object>
    {
        protected GoToState goToState;
        const string OBJECTIVE_POSITION = "objectivePosition";
        const string OBJECTIVE_NODE = "objectiveNode";

        private NavMeshAgent navAgent;

        [SerializeField] private Weapon weapon;
        // [SerializeField] private Transform pivot;
        [SerializeField] private Aiming aiming;

        private Node<string,object> currentNode;
        protected override void Awake()
        {
            base.Awake();
            navAgent = GetComponentInParent<NavMeshAgent>();
            Name = "AttackToAction";
            Cost = 1;
            goToState = GetComponent<GoToState>();
            
        }
        // Similar to the GoTo Action and GoTo state. This action will set to the NavMeshAgent component the destination, and once that is set, it will run until
        // the Agent reaches within 0.5f distance from the Node, or until the Node is invalidated which fails the Action. In the meantime, while the Agent sees the Player,
        // it will shoot.

        // Should use the GoToState....

        // Only shoot at the player while navigate to a destination if Agent is in LOS, and note that the Agent only considers LOS if it sees the Player.
        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings,
                                 ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);
            if (settings.TryGetValue(OBJECTIVE_NODE, out var node))
            {
                currentNode = (Node<string, object>) node;
                navAgent.destination = currentNode.transform.position;
                
                while (navAgent.remainingDistance < 0.5f)
                {
                    if ((bool) agent.GetMemory().GetWorldState().Get("inLOS"))
                    {
                        // Pivot the weapon to aim at the player
                        aiming.AimAtPoint((Vector3) agent.GetMemory().GetWorldState().Get("lastPlayerLocation"));
                        // Fire the weapon
                        weapon.TryFire();
                    }
                    if (!currentNode.IsValid())
                        failCallback(this);
                }
                doneCallback(this);

            }
            /*
            if (settings.TryGetValue(OBJECTIVE_NODE, out var node))
            {
                currentNode = (Node<string, object>) node;
                navAgent.destination = currentNode.transform.position;
                while (navAgent.remainingDistance < 0.5f)
                {
                    if ((bool) agent.GetMemory().GetWorldState().Get("inLOS"))
                    {
                        // Pivot the weapon to aim at the player
                        aiming.AimAtPoint((Vector3) agent.GetMemory().GetWorldState().Get("lastPlayerLocation"));
                        // Fire the weapon
                        weapon.TryFire();
                    }
                    if (!currentNode.IsValid())
                        failCallback(this);
                }
                doneCallback(this);

            }
            else if (settings.TryGetValue(OBJECTIVE_POSITION, out var position))
            {
                navAgent.destination = (Vector3) position;
                while (navAgent.remainingDistance < 0.5f)
                {
                    if ((bool) agent.GetMemory().GetWorldState().Get("inLOS"))
                    {
                        // Pivot the weapon to aim at the player
                        aiming.AimAtPoint((Vector3) agent.GetMemory().GetWorldState().Get("lastPlayerLocation"));
                        // Fire the weapon
                        weapon.TryFire();
                    }
                    // This action should fail if the Player were to intercept the direction the Agent is moving
                }
                doneCallback(this);
            }
            */
            doneCallback(this);
        }

        // Look into the Goal state if suppressive fire is necessary and if there is a isAtPosition or a isAtNode key in the goal state
        // to navigate too.

        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            if (stackData.goalState.HasKey("suppressiveFire") && stackData.goalState.TryGetValue("isAtNode", out var node))
            {
                Debug.Log("[AttackToAction]: Activate Suppressive Fire in this action's settings");
                settings.Set(OBJECTIVE_NODE, node);
                return base.GetSettings(stackData);
            }
            else if(stackData.goalState.HasKey("suppressiveFire") && stackData.goalState.TryGetValue("isAtPosition", out var position))
            {
                settings.Set(OBJECTIVE_POSITION, position);
                return base.GetSettings(stackData);
            }
            return new List<ReGoapState<string, object>>();
        }

        // Suppressive fire is true and navigate to node or position is true.
        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            if(stackData.settings.TryGetValue(OBJECTIVE_NODE, out var node))
            {
                effects.Set("suppressiveFire", true);
                effects.Set("isAtNode", node);
            }
            else if (stackData.settings.TryGetValue(OBJECTIVE_POSITION, out var position))
            {
                effects.Set("suppressiveFire", true);
                effects.Set("isAtPosition", position);
            }
            return effects;
        }
        // Check if the Agent detects that it's currently in LOS of the Player, only do suprresive fire if in LOS
        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            if (stackData.settings.HasKey(OBJECTIVE_POSITION) || stackData.settings.HasKey(OBJECTIVE_NODE))
                Debug.Log("[AttackToAction] Agent has to lay suppressive fire onto the Player whose got this agent in LOS");
            else
                Debug.Log("[AttackToAction] This action has not been ticked");
            return base.CheckProceduralCondition(stackData) && (stackData.settings.HasKey(OBJECTIVE_POSITION) || stackData.settings.HasKey(OBJECTIVE_NODE));
        }

    }
}
