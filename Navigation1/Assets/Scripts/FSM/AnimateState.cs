using System;
using System.Collections;
using System.Collections.Generic;
using ReGoap.Unity.FSM;
using UnityEngine;

namespace Scripts.FSM
{
    [RequireComponent(typeof(StateMachine))]
    [RequireComponent(typeof(GoToState))]
    public class AnimateState : SmState
    {
        Animator animator;
        private string currentState;
        private Action onDoneAnimateCallback;
        private Action onFailureAnimateCallback;
        private string goalAnimationState;

        private enum AnimateStateStatus
        {
            Disabled, Pulsed, Active, Success, Failure
        }

        private AnimateStateStatus currentStatus;

        protected override void Start()
        {
            animator = GetComponent<Animator>();
            goalAnimationState = null;
        }

        protected override void Update()
        {
            if (currentStatus == AnimateStateStatus.Pulsed)
            {
                ChangeAnimationState(goalAnimationState);
            }
        }

        void ChangeAnimationState(string newState)
        {
            // stop the same animation from interrupting itself
            if (currentState == newState) return;

            // play the animation
            animator.Play(newState);

            // Success when we play a new animation
            currentStatus = AnimateStateStatus.Success;

            // reassign the current state.
            currentState = newState;
        }



        #region StateHandler
        public override void Init(StateMachine stateMachine)
        {
            base.Init(stateMachine);
            var transition = new SmTransition(GetPriority(), Transition);
            stateMachine.GetComponent<GoToState>().Transitions.Add(transition);
        }


        private Type Transition(ISmState state)
        {
            if (currentStatus == AnimateStateStatus.Pulsed)
                return GetType();
            return null;
        }

        public void Animate(string animationState, Action onDoneAnimate, Action onFailureAnimate)
        {
            goalAnimationState = animationState;
            Animate(onDoneAnimate, onFailureAnimate);
        }
        public void Animate(Action onDoneAnimate, Action onFailureAnimate)
        {
            currentStatus = AnimateStateStatus.Pulsed;
            onDoneAnimateCallback = onDoneAnimate;
            onFailureAnimateCallback = onFailureAnimate;
        }

        // Allows the StateMachine to enter this state.
        public override void Enter()
        {
            base.Enter();
            currentStatus = AnimateStateStatus.Active;
        }

        public override void Exit()
        {
            base.Exit();
            if (currentStatus == AnimateStateStatus.Success)
                onDoneAnimateCallback();
            else if(currentStatus == AnimateStateStatus.Failure)
                onFailureAnimateCallback();
        }
        #endregion
    }
}
