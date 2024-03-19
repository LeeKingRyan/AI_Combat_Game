using System;
using System.Collections;
using System.Collections.Generic;
using ReGoap.Unity;
using ReGoap.Unity.FSM;
using ReGoap.Utilities;
using Scripts.AINodes.Core;
using Scripts.AINodes.Nodes;
using UnityEngine;
using UnityEngine.AI;

namespace Scripts.FSM
{
    [RequireComponent(typeof(StateMachine))]
    [RequireComponent(typeof(AnimateState))]
    public class GoToState : SmState
    {
        public GameObject parent; // Parent GameObject AI that has the NavMeshAgent component.
        private NavMeshAgent navAgent;

        private Node<string, object> objectiveNode;

        private ReGoapAgent<string, object> goapAgent; 

        private Vector3? objective;
        private Transform objectiveTransform;
        private Action onDoneMovementCallback;
        private Action onFailureMovementCallback;

        private bool following = false;

        private enum GoToStateStatus
        {
            Disabled, Pulsed, Active, Success, Failure
        }
        
        private GoToStateStatus currentStatus;

        public bool WorkInFixedUpdate = false;
        public float Speed;

        public float targetRadius;

        // when the magnitude of the difference between the objective and self is <= of this then we're done
        public float MinPowDistanceToObjective = 0.5f;


        // additional feature, check for stuck, userful when using rigidbody or raycasts for movements
        private Vector3 lastStuckCheckUpdatePosition;
        private float stuckCheckCooldown;
        public bool CheckForStuck;
        public float StuckCheckDelay = 1f;
        public float MaxStuckDistance = 0.1f;

        [SerializeField] private Weapon weapon;
        // [SerializeField] private Transform pivot;
        [SerializeField] private Aiming aiming;

        // Inside Awake get the NavMeshAgent component of the Agent
        protected override void Awake()
        {
            base.Awake();
            navAgent = parent.GetComponent<NavMeshAgent>();
            goapAgent = GetComponent<ReGoapAgent<string, object>>();
        }

        // if your games handle the speed from something else (ex. stats class) you can override this function
        protected virtual float GetSpeed()
        {
            return Speed;
        }

        #region Work
        protected override void FixedUpdate()
        {
            base.FixedUpdate();
            if (!WorkInFixedUpdate) return;
            Tick();
        }

        protected override void Update()
        {
            base.Update();
            if (WorkInFixedUpdate) return;
            Tick();
        }

        // if you're using an animation just override this, call base function (base.Tick()) and then 
        //  set the animator variables (if you want to use root motion then also override MoveTo)
        protected virtual void Tick()
        {
            var objectivePosition = objectiveTransform != null ? objectiveTransform.position : objective.GetValueOrDefault();

            // check whether following or a generic go to:
            if (following)
                Follow();
            else
                // Can just assign NavMeshAgent here
                MoveTo(objectivePosition);
        }

        protected virtual void Follow()
        {
            // Set the speed of the NavMeshAgent
            navAgent.speed = GetSpeed();
            // Tell NavMeshAgent to head to this destination.
            navAgent.destination = objectiveTransform.position;
        }

        protected virtual void MoveTo(Vector3 position)
        {
            // Then make the NavMeshAgent Target destination null
            if (objective.GetValueOrDefault() == null)
            {
                return;
            }

            // Set the speed of the NavMeshAgent
            navAgent.speed = GetSpeed();
            // Tell NavMeshAgent to head to this destination.
            //navAgent.destination = objective.GetValueOrDefault();
            navAgent.destination = position;
            Debug.Log("[FSM GoToState]: The set Target destination is " + navAgent.destination);

            // if target Radius is still 0.0f, then no worries
            navAgent.stoppingDistance = targetRadius;

            // If the objectiveNode becomes invalidated, then this GoToState should fail
            if (objectiveNode != null && !objectiveNode.IsValid())
            {
                objectiveNode = null;
                currentStatus = GoToStateStatus.Failure;
            }

            if ((bool) goapAgent.GetMemory().GetWorldState().Get("inLOS"))
            {
                // Pivot the weapon to aim at the player
                aiming.AimAtPoint((Vector3) goapAgent.GetMemory().GetWorldState().Get("lastPlayerLocation"));
                // Fire the weapon
                weapon.TryFire();
            }

            // Use custom stopping distance if the Agent is near its destination.
            if (navAgent.stoppingDistance > 0f)
            {
                if (!navAgent.pathPending && navAgent.remainingDistance <= targetRadius)
                {
                    objectiveNode = null;
                    currentStatus = GoToStateStatus.Success;
                }
            }
            // Otherwise use the standard
            else if (!navAgent.pathPending && navAgent.remainingDistance < 0.5f)
            {
                objectiveNode = null;
                currentStatus = GoToStateStatus.Success;
            }

            if (CheckForStuck && CheckIfStuck())
                currentStatus = GoToStateStatus.Failure;
        }

        private bool CheckIfStuck()
        {
            if (Time.time > stuckCheckCooldown)
            {
                stuckCheckCooldown = Time.time + StuckCheckDelay;
                if ((lastStuckCheckUpdatePosition - transform.position).magnitude < MaxStuckDistance)
                {
                    ReGoapLogger.Log("[SmsGoTo] '" + name + "' is stuck.");
                    return true;
                }
                lastStuckCheckUpdatePosition = transform.position;
            }
            return false;
        }
        #endregion

        #region StateHandler
        public override void Init(StateMachine stateMachine)
        {
            base.Init(stateMachine);


            var transition = new SmTransition(GetPriority(), Transition);
            var doneTransition = new SmTransition(GetPriority(), DoneTransition);


            stateMachine.GetComponent<AnimateState>().Transitions.Add(transition);
            // Only added the done transition to GoTo, so once finished it will just send the type of AnimateState
            // because Idle animation is handled by Animate State.
            Transitions.Add(doneTransition);
        }

        private Type DoneTransition(ISmState state)
        {
            if (currentStatus != GoToStateStatus.Active)
                return typeof(AnimateState);
            return null;
        }

        private Type Transition(ISmState state)
        {
            if (currentStatus == GoToStateStatus.Pulsed)
                return GetType();
            return null;
        }

        public void Follow(Transform otherAgent, Action onDoneMovement, Action onFailureMovement)
        {
            following = true;
            objectiveTransform = otherAgent;
            GoTo(onDoneMovement, onFailureMovement);
        }

        // Called from Generic GoTo action, and it sets the objective position Vector and calls the other
        // GoTo() with the action delegates to tell an agent when the action failed or finished.
        public void GoTo(Vector3? position, Action onDoneMovement, Action onFailureMovement, float radius = 0.0f)
        {
            following = false;
            objective = position;
            targetRadius = radius;
            GoTo(onDoneMovement, onFailureMovement);
        }

        // Goto method concerned about Nodes
        public void GoTo(Node<string, object> node, Action onDoneMovement, Action onFailureMovement)
        {
            following = false;
            objectiveNode = node;
            objectiveTransform = objectiveNode.transform;
            Debug.Log("[FSM GoToState]: The Passed Objective Node World Positon is " + objectiveTransform.position);
            GoTo(onDoneMovement, onFailureMovement);
        }
        

        public void GoTo(Transform transform, Action onDoneMovement, Action onFailureMovement)
        {
            following = false;
            objectiveTransform = transform;
            GoTo(onDoneMovement, onFailureMovement);
        }

        // Sets the action delegates to their respective instances. Only get called upon exiting the state
        // and if current state was enumerated to be a success.
        void GoTo(Action onDoneMovement, Action onFailureMovement)
        {
            currentStatus = GoToStateStatus.Pulsed;
            onDoneMovementCallback = onDoneMovement;
            onFailureMovementCallback = onFailureMovement;
        }

        // Allows the StateMachine to enter this state.
        public override void Enter()
        {
            base.Enter();
            currentStatus = GoToStateStatus.Active;
        }

        public override void Exit()
        {
            base.Exit();
            if (currentStatus == GoToStateStatus.Success)
                onDoneMovementCallback();
            else
                onFailureMovementCallback();
        }
        #endregion
    }
    
}
