using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using UnityEngine;

namespace Scripts.Sensors
{
    public class PatrolPointSensorii : ReGoapSensor<string, object>
    {
        private Dictionary<PatrolPoint, Vector3> patrolpoints;
        private IReGoapAgent<string, object> agent;
        // Start is called before the first frame update

        void Awake()
        {
            agent = GetComponent<IReGoapAgent<string, object>>();
        }

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
            PatrolPoint nearest = GetNearestPatrolPoint(agent);
            if (GetNearestPatrolPoint(agent) != null)
            {
                var worldstate = memory.GetWorldState();
                worldstate.Set("nearestPatrolPoint", nearest);
                Debug.Log("Next Nearest Patrol Point is " + nearest.ReturnPointName());
            }

            foreach(var patrolpoint in patrolpoints)
            {
                var worldstate = memory.GetWorldState();
                if (patrolpoint.Key.IsInvestigated())
                    worldstate.Set("PatrolPoint " + patrolpoint.Key.ReturnPointName(), "was investigated");
            }
        }

        private PatrolPoint GetNearestPatrolPoint(IReGoapAgent<string, object> agent)
        {
          PatrolPoint nearestPoint = null;
          float minDist = Mathf.Infinity;
          Vector3 currentPos = (Vector3) agent.GetMemory().GetWorldState().Get("startPosition");
          foreach (var patrolpoint in patrolpoints)
          {
            if (patrolpoint.Key.IsInvestigated())
                continue;
            float dist = Vector3.Distance(patrolpoint.Value, currentPos);
            if (dist < minDist)
            {
                nearestPoint = patrolpoint.Key;
                minDist = dist;
            }
          }
          return nearestPoint;
        }
    }
}
