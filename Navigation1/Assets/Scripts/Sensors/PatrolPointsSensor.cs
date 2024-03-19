using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ReGoap.Unity;
using Scripts;

namespace Scripts.Sensors
{
    public class PatrolPointsSensor : ReGoapSensor<string, object>
    {
        private Dictionary<PatrolPoint, Vector3> patrolpoints;
        // Start is called before the first frame update
        void Start()
        {
            patrolpoints = new Dictionary<PatrolPoint, Vector3>(PatrolPointsManager.Instance.PatrolPoints.Length);
            foreach (var patrolpoint in PatrolPointsManager.Instance.PatrolPoints)
            {
                patrolpoints[patrolpoint] = patrolpoint.transform.position; // patrol points are static
            }

            var worldstate = memory.GetWorldState();
            worldstate.Set("seePatrolPoint", PatrolPointsManager.Instance != null && PatrolPointsManager.Instance.PatrolPoints.Length > 0);
            worldstate.Set("patrolpoints", patrolpoints);
        }
        public override void UpdateSensor()
        {
            foreach(var patrolpoint in patrolpoints)
            {
                var worldstate = memory.GetWorldState();
                if (patrolpoint.Key.IsInvestigated())
                    worldstate.Set("PatrolPoint " + patrolpoint.Key.ReturnPointName(), "was investigated");
            }
        }
    }
}
