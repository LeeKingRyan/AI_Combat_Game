using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Scripts;
namespace Scripts
{
    public class PatrolPointsManager : MonoBehaviour
    {
        public static PatrolPointsManager Instance;
        public PatrolPoint[] PatrolPoints;
        public float resetDelay = 3f;
        protected float lastReset;
        private WaitForSeconds _waitForSeconds;

        protected virtual void Awake()
        {
            if (Instance != null)
                throw new UnityException("[PatrolPointsManager] Can have only one instance per scene.");
            Instance = this;
            lastReset = -100;
            _waitForSeconds = new WaitForSeconds(resetDelay);
        }

        // Reset all patrol points to not be investigated
        public IEnumerator ResetAllPatrolPoints()
        {
            yield return _waitForSeconds;
            for (int i = PatrolPoints.Length - 1; i >= 0; i--)
            {
                PatrolPoints[i].UpdatePatrolPoint();
            }
            /*
            foreach(var patrolPoint in PatrolPoints)
            {
                patrolPoint.UpdatePatrolPoint();
            }
            */
        }

        // All patrol points in the GameScene are investigated
        public bool OnDonePatrol()
        {
            foreach (var patrolPoint in PatrolPoints)
            {
                if (!patrolPoint.IsInvestigated())
                    return false;
            }
            return true;
        }

        public void Update()
        {
            // Only if all PatrolPoints have been investigated.
            if (OnDonePatrol())
                //Invoke("ResetAllPatrolPoints", resetDelay);
                StartCoroutine (ResetAllPatrolPoints());
        }
    }
}
