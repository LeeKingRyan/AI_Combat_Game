using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using Scripts.SquadBehaviors.BlackBoards;
using UnityEngine;

namespace Scripts.Sensors
{
    
    // This is an exlusive Sensor for the Player to Detect Enemy Agents
    // in its FOV relative to where it aims.
    public class EnemyDetection : MonoBehaviour
    {
        public float radius;
        [Range(0,360)]
        public float angle;

        public LayerMask targetMask;
        public LayerMask obstructionMask;

        public bool canSeeEnemies;

        private List<IReGoapAgent<string, object>> enemyAgents;
        private List<GameObject> enemyObjects;
        private IReGoapAgent<string, object> currentEnemyAgent;
        
        private void Awake()
        {
            enemyObjects = new List<GameObject>();
            enemyAgents = new List<IReGoapAgent<string, object>>();
        }

        private void Start()
        {
            enemyAgents = new List<IReGoapAgent<string, object>>();
            StartCoroutine(FOVRoutine());
        }

        public List<GameObject> GetDetectedAgents()
        {
            return enemyObjects;
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

        private void FieldOfViewCheck()
        {
            enemyAgents.Clear();
            enemyObjects.Clear();

            Collider[] rangeChecks = Physics.OverlapSphere(transform.position, radius, targetMask);

            if (rangeChecks.Length != 0)
            {
                foreach (var enemy in rangeChecks)
                {
                    Transform target = enemy.transform;
                    Vector3 directionToTarget = (target.position - transform.position).normalized;

                    if (Vector3.Angle(transform.forward, directionToTarget) < angle / 2)
                    {
                        float distanceToTarget = Vector3.Distance(transform.position, target.position);
                        // If the player is within distance and there are no obstructions blocking the view, then the player can be seen
                        if (!Physics.Raycast(transform.position, directionToTarget, distanceToTarget, obstructionMask))
                        {
                            enemyObjects.Add(enemy.gameObject);
                            currentEnemyAgent = enemy.gameObject.GetComponentInChildren<IReGoapAgent<string, object>>();
                            enemyAgents.Add(currentEnemyAgent);
                        }
                    }
                }
                if (enemyAgents.Count > 0)
                {
                    canSeeEnemies = true;
                    BlackBoard<string, object>.Instance.Set("detectedAgents", enemyAgents);
                }
            }

            // player is no longer visible, so set canSeePlayer to false.
            // This base check originally just make sure that canSeePlayer is reset to false. But it also means that the
            // Agent has just lost sight of the player, so activating the Extended FOV for a duration makes sense here.
            else if (canSeeEnemies)
            {
                canSeeEnemies = false;
                BlackBoard<string, object>.Instance.Set("detectedAgents", enemyAgents);
            }
        }
    }   
}
