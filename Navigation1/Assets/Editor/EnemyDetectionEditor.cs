using Scripts.Sensors;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(EnemyDetection))]
public class EnemyDetectionEditor : Editor
{
    private void OnSceneGUI()
    {
        EnemyDetection detection = (EnemyDetection) target;

        // Standard FOV
        Handles.color = Color.green;
        Handles.DrawWireArc(detection.transform.position, Vector3.up, Vector3.forward, 360, detection.radius);

        Vector3 viewAngle01 = DirectionFromAngle(detection.transform.eulerAngles.y, -detection.angle / 2);
        Vector3 viewAngle02 = DirectionFromAngle(detection.transform.eulerAngles.y, detection.angle / 2);

        Handles.color = Color.yellow;
        Handles.DrawLine(detection.transform.position, detection.transform.position + viewAngle01 * detection.radius);
        Handles.DrawLine(detection.transform.position, detection.transform.position + viewAngle02 * detection.radius);

        if (detection.canSeeEnemies)
        {
            foreach (var enemy in detection.GetDetectedAgents())
            {
                Handles.color = Color.green;
                Handles.DrawLine(detection.transform.position, enemy.transform.position);
            }
        }
    }

    private Vector3 DirectionFromAngle(float eulerY, float angleInDegrees)
    {
        angleInDegrees += eulerY;

        return new Vector3(Mathf.Sin(angleInDegrees * Mathf.Deg2Rad), 0, Mathf.Cos(angleInDegrees * Mathf.Deg2Rad));
    }
}
