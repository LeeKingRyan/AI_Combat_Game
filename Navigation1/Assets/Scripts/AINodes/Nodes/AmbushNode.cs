using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using UnityEngine;

namespace Scripts.AINodes.Nodes
{
    public class AmbushNode : Node<string, object>
    {
        [Range(0,360)]
        public float angleFOV;      // Angle of the FOV player must be in to be valid
        public float boundryRadius; // Radius the Player must be within for Ambush Node to be valid
        public float threatRadius;  // Radius the Player must be in to invalidate the Cover Node and Agent retreats if on it

        public WaitForSeconds waitFOV;
        public WaitForSeconds waitValidity; // delay when checking validity if the CoverNode becomes valid

        public LayerMask obstructionMask;   // Any Obstructions

        public GameObject playerRef;
        public LayerMask targetMask;    // The Player

        // parameters for the Agent to wait in seconds to Ambush the Player
        [SerializeField] private float minWaitTime = 3f;
        [SerializeField] private float maxWaitTime = 20f;

        void Awake()
        {
            waitFOV = new WaitForSeconds(0.2f);
            waitValidity = new WaitForSeconds(0.2f);
            unlockDelay = new WaitForSeconds(3.0f);
        }

        private void Start()
        {
            playerRef = GameObject.FindGameObjectWithTag("Player");
            StartCoroutine(FOVRoutine());
        }

        public void GetWaitTime(out float minTime, out float maxTime)
        {
            minTime = minWaitTime;
            maxTime = maxWaitTime;
        }

        // Check if the Agent that reserved this CoverNode is still alive
        public override bool IsAgentAlive()
        {
            // Don't bother checking if Agent is alive or dead if there is no Agent registered to this AmbushNode
            if (customer == null)
                return true;
            if (customer.GetMemory().GetWorldState().TryGetValue("alive", out var healthStatus))
            {
                if ((bool) healthStatus)
                {
                    Debug.Log("[AmbushNode]: The Agent " + customer.ToString() + " is reported to still be alive");
                    return true;
                }
            }
            return false;
        }

        private IEnumerator FOVRoutine()
        {
            while (true)
            {
                yield return waitFOV;
                FieldOfViewCheck();
                // if valid, then start another corountine with a different routine
                if (valid)
                    StartCoroutine(ValidityRoutine());
            }
        }

        private IEnumerator ValidityRoutine()
        {
            while(valid)    // can just make this true due to the Break statement inside.
            {
                yield return waitValidity;
                FieldOfViewCheck();
                ThreatCheck();
                if (!valid)
                {
                    break;
                }
                if(!IsAgentAlive())
                {
                    Debug.Log("[AmbushNode]: The Agent is dead, so begin to Unlock this AmbushNode!");
                    StartCoroutine(UnlockNode());
                }
            }
        }

        private void FieldOfViewCheck()
        {
            Collider[] rangeChecks = Physics.OverlapSphere(transform.position, boundryRadius, targetMask);
            // Anything above zero, then we found something on that layer.
            if (rangeChecks.Length != 0)
            {
                Transform target = rangeChecks[0].transform; // Only player on the targetMask layer. But if we're looking for multiple agents on a single mask, then do a for loop

                // Direction from where Cover Node is looking to where the target/Player is
                Vector3 directionToTarget = (target.position - transform.position).normalized;

                if (Vector3.Angle(transform.forward, directionToTarget) < angleFOV / 2)
                {
                    float distanceToTarget = Vector3.Distance(transform.position, target.position);
                    // Ignores any obstructions in this FOV
                    if (!Physics.Raycast(transform.position, directionToTarget, distanceToTarget, obstructionMask))
                        valid = true;
                    else
                        valid = false;
                }
                else
                    valid = false;
            }
            // player is no longer visible, so set canSeePlayer to false.
            else if (valid)
                valid = false;
        }

        // Check if the player invaded the ThreatRadius
        private void ThreatCheck()
        {
            Collider[] rangeChecks = Physics.OverlapSphere(transform.position, threatRadius, targetMask);
            // Anything above zero, then we found something on that layer.
            if (rangeChecks.Length != 0)
            {
                valid = false;
            }
        }

        // Update to the Manager the Ambush Node itself and its associated bool valid. This is done inside a NodeManager derived class
        public override void UpdateToManager()
        {
            manager.GetNodesData()[this] = valid;
        }
    }
}
