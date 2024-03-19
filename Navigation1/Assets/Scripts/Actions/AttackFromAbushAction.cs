using System.Collections;
using System.Collections.Generic;
using ReGoap.Unity;
using System;
using UnityEngine;
using ReGoap.Core;
using Scripts.AINodes.Nodes;

namespace Scripts.Actions
{
    // This action focuses on the Agent attacking the Player from an Ambush Node.
    // Note that an Action Node has two functionalities:
    //  1. Locations where Agents navigate/coordinate to and fight from, but not to use any CoverNode animations
    //  2. Locations behind corners or other cover, especially good ambush points where Agents can wait for the
    //     Player to come into view before Attacking.

    // The first functionality is done through standard planning of KillPlayerGoal in which attacking from Cover is not a valid option
    // in planning, due to a result of no Valid unreserved Cover to consider. The Agent will navigate to the nearest Valid Ambush Node
    // and attack the Player from there like it's done for cover. Most likely functionality 1 will occur, but functionality 2 could happen
    // by the time this action is running in the plan, if the Ambush Node is still valid and the Agent doesn't see the Player.

    // Functionality 2 will most likely happen when the Ambush Goal becomes the Agent's current goal of highest priority which is
    // possible when Agent is within radius of a Valid Ambush Node and doesn't see the Player. The Ambush Goal succeeds if the Agent
    // just reserves and navigates to, and enters the AmbushNode, and KillPlyerGoal will automatically be the next highest priority Goal.
    // Though the plan to navigate to cover and attack from cover could still be valid, it will no longer be the lowest cost effective plan
    // as attacking from ambush plan is only comprised of this action, as the other preceding actions have been succeeded by the Ambush Goal.


    // An Agent will only attack from an ambush node if they see the player within [minimumWaitTime, MaximumWaitTime]
    // which is specified from the AmbushNode the Agent occupies.

    // After exceeding the minimumWaitTime, the Agent will
    // consider if this Action failed if the Ambush Node became invalidated, due to either the Player invading the
    // Node's ThreatRadius, or the Player is no longer detected by the Node's FOV and BoundryRadius.

    // The Action succeeds if the Agent sees the Player within the MaximumWaitTime, and the Agent shoots at the Player
    // some number of times, before checking if there's nearby cover or nearby Ambush Nodes farther from the Player.

    // Note: Agent should not continuosly attack from some Ambush Node if they see the Player, rather they should navigate to some
    // other unreserved Cover that's valid or another Valid nearby Ambush Node that is farther from the Player.
    public class AttackFromAbushAction : ReGoapAction<string, object>
    {
        [SerializeField] private Weapon weapon;
        // [SerializeField] private Transform pivot;
        [SerializeField] private Aiming aiming;

        private SmoothLookAt lookAt; // Rotate the Agent to look in the forward direction of this node and await Player to come to view. 

        private float minimumWaitTime = 0.0f;
        private float maximumWaitTime = 0.0f;

        protected override void Awake()
        {
            base.Awake();
            Name = "AttackFromAmbushAction";
            Cost = 2;
            lookAt = GetComponent<SmoothLookAt>();
        }

/*
        protected virtual void Update()
        {
            if (ambush && minimumWaitTime > 0.0f || maximumWaitTime > 0.0f)
            {
                // If see the Player is within LOS, then Ambush the Player
                if ((bool) agent.GetMemory().GetWorldState().Get("seePlayer"))
                    AmbushTarget();

                // Wait at least minimum amount of seconds for the Player to come into view before deciding whether to move on. [i.e. if AmbushNode becomes invalidated
                // due to Player no longer being in the AmbushNode's FOV]
                if (minimumWaitTime <= 0.0f && !agent.GetMemory().GetWorldState().HasKey("reservedAmbush"))
                {
                    maximumWaitTime = 0.0f;
                    minimumWaitTime = 0.0f;
                    ambush = false;
                    doneCallback(this);
                }

                // If after maximum number of seconds the Player has still not appeared, then the AI will move to a new location [Action will finish]
            }
            // No longer ambushing if both the minimumWaitTime and maximumWaitTime are exceeded
            else if (ambush)
            {
                maximumWaitTime = 0.0f;
                minimumWaitTime = 0.0f;
                ambush = false;
                doneCallback(this);
            }
        }
*/

        // If the Player is already visible, then the Agent will simply shoot at the Player, but if the Agent is not visible, and the Ambush Node is still Valid, then
        // the Agent will wait for the specified minimum seconds, until it will consider moving on, in which case, if the Ambush Node becomes InValid after 3 seconds, then
        // the action will fail, but if the AmbushNode still remains valid between [minimumWaitTime, MaximumWaitTime], then the agent will remain, until, the maximum wait time is exceeded
        // This action will then finish.

        // How will this action fail? 
        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings, ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);
            var state = agent.GetMemory().GetWorldState();
            // FUNCTIONALITY 1:
            // If see the player, then while the AmbushNode the Agent node still occupies is valid (while the Agent has the "reservedAmbush" key in memory),
            // then continue to attack the Player from a distance. [Hadn't incorporated melee yet]
            if ((bool) state.Get("seePlayer"))
            {
                StartCoroutine(AmbushRoutine());
            }

            // FUNCTIONALITY 2:
            // If Agent doesn't see the Player, then wait a minimum of some seconds, before consider leaving this node, including if it becomes invalidated. After the minimum
            // seconds and while the Node is still Valid, then wait some max number of seconds. This is to catch the Player off guard, so once the Player is seen, then attack.
            else if(state.TryGetValue("reservedAmbush", out var ambushPoint))
            {
                // [IMPORTANT] Make sure to rotate the Agent to face the same forward direction as the AmbushNode. Get the rotation of the Node
                // and set the rotation to the Agent.
                AmbushNode ambushNode = (AmbushNode) ambushPoint;

                lookAt.LookAtDirection(ambushNode.transform.rotation);      // If don't see the Player, then this will not matter as the Player sensor will just reset it
                // to the forward direction of the Parent Object of the Agent

                // Get the minimum and maximum number of seconds the Agent is to wait at the Node.
                ambushNode.GetWaitTime(out minimumWaitTime, out maximumWaitTime);
                
                Debug.Log("The minimum and the maximum wait time (in secs) acquired from the node are " + minimumWaitTime + "and " + maximumWaitTime + " respectively.");

                // Waiting for Player to come into view is done in a separate function.
                StartCoroutine(WaitToAmbushRoutine());
            }

            

            Debug.Log("[AttackFromAmbushAction]: Exiting the AttackFromAmbush Action!!");

            // Shouldn't we fail this Action?
            //doneCallback(this);
            
            // Rather than make the KillPlayer Goal fail if the AmbushNode is invalidated, rather why not just make it finish, so the KillPlayerGoal could be repeated, as
            // a different plan, that considers a new Node, will be formulated.
            
            // Note: The current goal can still be overridden by another goal, like the Dodge Goal, if the Agent is in LOS, but this AttackFromCover Action will likely resume if
            // the AmbushNode hasn't been invalidated, as it's the most cost-effective plan in terms of KillPlayerGoal, as the Agent already reserved the AmbushNode. But the moment
            // the AmbushNode is invalidaed, during running the plan in real-time, then this action will fail, and so would the goal. Consequently, another goal like GetToCover should
            // presume the role as the current goal for the Agent to get to Cover as KillPlayerGoal has been blacklisted upon failure for some time. 
            
            // Additional Notes:  But if the AmbushNode were invalidated during planning, then the likely plan is the Agent tries to navigate to Attack from a Valid unreserved
            // CoverNode, or another Valiud unreserved AmbushNode.

        }

        private IEnumerator WaitToAmbushRoutine()
        {
            WaitForSeconds wait = new WaitForSeconds(0.2f);

            while (true)
            {
                yield return wait;
                WaitForAmbush();
            }
        }

        private IEnumerator AmbushRoutine()
        {
            Debug.Log("[AttackFromAmbushAction]: Conducting the Ambush Routine!");
            WaitForSeconds wait = new WaitForSeconds(0.2f);
            var state = agent.GetMemory().GetWorldState();
            while ((bool) state.Get("seePlayer") && state.HasKey("reservedAmbush"))
            {
                yield return wait;
                ShootAtTarget(state);
            }
            //yield return wait;
            doneCallback(this);
        }

        private void WaitForAmbush()
        {
            minimumWaitTime -= Time.deltaTime;
            maximumWaitTime -= Time.deltaTime;
            
            Debug.Log("minimumWaitTime: " + minimumWaitTime + " ; " + "maximumWaitTime: " + maximumWaitTime);
            // Until the minimum and maximum wait time are exceeded, then finish the action 
            if (minimumWaitTime > 0.0f || maximumWaitTime > 0.0f)
            {
                // If see the Player is within LOS, then Ambush the Player
                if ((bool) agent.GetMemory().GetWorldState().Get("seePlayer"))
                    StartCoroutine(AmbushRoutine());

                // Wait at least minimum amount of seconds for the Player to come into view before deciding whether to move on. [i.e. if AmbushNode becomes invalidated
                // due to Player no longer being in the AmbushNode's FOV]
                // If minimum wait time is exceeded and the reserved Ambush Node has been invalidated, then just finish this action
                else if (minimumWaitTime <= 0.0f && !agent.GetMemory().GetWorldState().HasKey("reservedAmbush"))
                {
                    maximumWaitTime = 0.0f;
                    minimumWaitTime = 0.0f;
                    doneCallback(this);
                }

                // If after maximum number of seconds the Player has still not appeared, then the AI will move to a new location [Action will finish]
            }
            // No longer ambushing if both the minimumWaitTime and maximumWaitTime are exceeded
            else
            {
                maximumWaitTime = 0.0f;
                minimumWaitTime = 0.0f;
                doneCallback(this);
                return; // May need this to reinforce that the coroutine is over
            }
        }

        // Agent will attack/ambush the Player while within Agent's LOS and the Ambush Node hasn't been invalidated 
        //private void AmbushTarget()
        //{
        //    ShootAtTarget(state);
        //    doneCallback(this);
        //}

        // Function handles shooting at the Player
        private void ShootAtTarget(ReGoapState<string, object> state)
        {
            aiming.AimAtPoint((Vector3) state.Get("lastPlayerLocation"));
            weapon.TryFire();
        }

        // Check if the Agent is already reserved and, or occupying a Valid AmbushNode, otherwise, the Agent needs to Enter an AmbushNode as a precondition: "atAmbush".
        // Functionality 1 of Ambushes, should not be considered if there are nearby Valid unreserved cover, unless we are executing functionality 2. Again, functionality 1
        // happens if the AttackFromCover related plans cannot be validated, and functionality 2 happens when related plans or more cost effective than Attack From Cover
        // related plans.

        // Also, rather than code the Agent navigate to the nearest Ambush Point that's furthest from the Player. This should just be left up to the level design of the map 
        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            settings.Clear();
            // Settings in which the Agent is NOT at an ambush point
            if (stackData.goalState.HasKey("playerDead") && !stackData.currentState.HasKey("atAmbush"))
            {
                settings.Set("needAmbushPoint", true);
                return base.GetSettings(stackData);
            }
            // Settings for which the Agent is at an ambush point. Note: "atAmbush" key is only in Agent's
            // memory if it's at the location of the AmbushNode it reserved. 
            else if (stackData.goalState.HasKey("playerDead") && stackData.currentState.HasKey("atAmbush"))
            {
                settings.Set("needAmbushPoint", false);
                return base.GetSettings(stackData);
            }
            return new List<ReGoapState<string, object>> { settings };
        }

        // The Player would be dead (ideally) as a consequence of this action
        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            effects.Clear();
            if (stackData.settings.HasKey("needAmbushPoint"))
                effects.Set("playerDead", true);
            return effects;
        }

        // Either the Agent needs to be at an AmbushNode or is already at an Ambush Node
        public override ReGoapState<string, object> GetPreconditions(GoapActionStackData<string, object> stackData)
        {
            preconditions.Clear();
            if (stackData.settings.TryGetValue("needAmbushPoint", out var needAmbushPoint) && (bool) needAmbushPoint)
                preconditions.Set("ambushReady", true);
            return preconditions;
        }

        // Check that there are Valid unreserved AmbushNodes nearby or that the Agent has already reserved an AmbushNode, as the
        // Ambush Sensor, like the Cover Sensor, only considers nearby AmbushNodes that aren't reserved. This means that the AmbushNode
        // the Agent currently reserves is separate in its own key - "reservedAmbush".
        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            if(stackData.currentState.TryGetValue("nearbyAmbushes", out var usableAmbushPoints))
            {
                List<AmbushNode> potentialCover = (List<AmbushNode>) usableAmbushPoints;
                return base.CheckProceduralCondition(stackData) && potentialCover.Count > 0;
            }
            else if(stackData.currentState.HasKey("reservedAmbush"))
                return true;
            else
                return false;
        }
    }
}
