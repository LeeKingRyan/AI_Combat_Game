using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.SquadBehaviors;
using Scripts.SquadBehaviors.BlackBoards;
using System.Runtime.InteropServices;
using Scripts.SquadBehaviors.Core;

namespace Scripts.Sensors
{
    // FieldOfViewCheck() will work in parallel to the Update() method in ReGoapMemoryAdvanced which will call to Update all
    // collected data from sensors to memory.
    public class PlayerSensor : ReGoapSensor<string, object>
    {
        public float radius;
        [Range(0,360)]
        public float angle;


        [Range(0,360)]
        [Tooltip("The Angle For ExtendedFOV")]
        public float extendedAngle;

        [Tooltip("The Radius For ExtendedFOV")]
        public float extendedRadius;

        [Tooltip("5 equates 1 second")]
        public int activeTimeEXFOV = 20;  // default 4 seconds
        
        public GameObject playerRef;

        public GameObject parent;

        public LayerMask targetMask;

        public LayerMask noObstruction;
        public LayerMask obstructionMask;

        public bool canSeePlayer;

        private Vector3 targetPosition;

        private SmoothLookAt lookAt;

        public RotateSprite spriteRotationController;

        // Get an instance of the SquadBehaviorSystem to call its method to update the last player location if player is seen.

        private void Start()
        {
            playerRef = GameObject.FindGameObjectWithTag("Player");
            StartCoroutine(FOVRoutine());
            lookAt = GetComponent<SmoothLookAt>();
        }

        private IEnumerator FOVRoutine()
        {
            WaitForSeconds wait = new WaitForSeconds(0.2f);

            while (true)
            {
                yield return wait;
                FieldOfViewCheck();
            }
        }

        private IEnumerator ExtendedFOVRoutine()
        {
            WaitForSeconds wait = new WaitForSeconds(0.2f);
            int duration = activeTimeEXFOV;
            while (duration >= 0)
            {
                yield return wait;
                ExtendedFOVCheck();
                duration--;
            }
        }

        private void FieldOfViewCheck()
        {
            Collider[] rangeChecks = Physics.OverlapSphere(transform.position, radius, targetMask);

            if (rangeChecks.Length != 0)
            {
                Transform target = rangeChecks[0].transform;
                Vector3 directionToTarget = (target.position - transform.position).normalized;

                if (Vector3.Angle(transform.forward, directionToTarget) < angle / 2)
                {
                    float distanceToTarget = Vector3.Distance(transform.position, target.position);
                    // If the player is within distance and there are no obstructions blocking the view, then the player can be seen
                    if (!Physics.Raycast(transform.position, directionToTarget, distanceToTarget, obstructionMask))
                    {
                        canSeePlayer = true;
                        // Update to the Black Board the last known Player Position, and state that their squad is engaged.
                        targetPosition = target.position;
                        BlackBoard<string, object>.Instance.ReportPlayerPosition(targetPosition);
                        // Get the squad Agent is affiliated with, and say that they're engaged.
                        if(memory.GetWorldState().TryGetValue("squad", out var team))
                        {
                            ISquad<string, object> squad = (ISquad<string, object>) team;
                            squad.Engage();
                        }
                    }
                    else
                        canSeePlayer = false;
                }
                else
                    canSeePlayer = false;
            }
            // player is no longer visible, so set canSeePlayer to false.
            // This base check originally just make sure that canSeePlayer is reset to false. But it also means that the
            // Agent has just lost sight of the player, so activating the Extended FOV for a duration makes sense here.
            else if (canSeePlayer)
            {
                canSeePlayer = false;
                // Need to repeat this function over a period of time
                StartCoroutine(ExtendedFOVRoutine());

            }
        }

        // Should only be active for a short period of time, defined by the user through the inspector window.
        // Try to get the Player's last known location. But if do not see anything, then Player vanished.
        private void ExtendedFOVCheck()
        {
            Collider[] rangeChecks = Physics.OverlapSphere(transform.position, extendedRadius, targetMask);

            if (rangeChecks.Length != 0)
            {
                Transform target = rangeChecks[0].transform;
                Vector3 directionToTarget = (target.position - transform.position).normalized;

                if (Vector3.Angle(transform.forward, directionToTarget) < extendedAngle / 2)
                {
                    float distanceToTarget = Vector3.Distance(transform.position, target.position);
                    
                    // If player is detected, dismissing any obstuctions, then we have a suspected
                    // area that can be update to the blackboard
                    if (!Physics.Raycast(transform.position, directionToTarget, distanceToTarget, noObstruction))
                    {
                        // Update to the Gloabal BlackBoard the last Known Player Location
                        targetPosition = target.position;
                        BlackBoard<string, object>.Instance.ReportPlayerPosition(targetPosition);
                    }
                }
            }
        }

        public override void UpdateSensor()
        {
            var state = memory.GetWorldState();
            Vector3 latestPlayerLocation = BlackBoard<string, object>.Instance.GetPlayerPosition();
            if (canSeePlayer)
            {
                state.Set("seePlayer", true);
                // set to state the player location retrieved from the Squad Behavior System instance.
                state.Set("lastPlayerLocation", targetPosition);

                lookAt.LookAtTarget();   // Set the Agent to Look at the Player [Target]

                spriteRotationController.ChangeSpriteRotation();    // Rotate the Agent Sprite to the same direction the Agent faces [This case the capsule]
            }
            // Reset the Look at direction to the forward direction of the parent object Agent that has the NavMesh Component
            //else if (!state.HasKey("atAmbush") && !state.HasKey("atCover"))
            else
            {
                state.Set("seePlayer", false);
                state.Set("lastPlayerLocation", latestPlayerLocation);

                lookAt.LostSight(); // Reset the Agent to face the direction its moving dictated by the NavMeshAgent component.

                spriteRotationController.ChangeSpriteRotation();
            }
        }
    }
}
