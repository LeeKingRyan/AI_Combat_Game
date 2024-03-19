using UnityEditor;
using UnityEngine;

using Scripts.Sensors;

[CustomEditor(typeof(PlayerSensor))]

public class PlayerSensorEditor : Editor{
    private void OnSceneGUI()
    {
        PlayerSensor detection = (PlayerSensor) target;
        // Standard FOV
        Handles.color = Color.green;
        Handles.DrawWireArc(detection.transform.position, Vector3.up, Vector3.forward, 360, detection.radius);

        Vector3 viewAngle01 = DirectionFromAngle(detection.transform.eulerAngles.y, -detection.angle / 2);
        Vector3 viewAngle02 = DirectionFromAngle(detection.transform.eulerAngles.y, detection.angle / 2);

        Handles.color = Color.yellow;
        Handles.DrawLine(detection.transform.position, detection.transform.position + viewAngle01 * detection.radius);
        Handles.DrawLine(detection.transform.position, detection.transform.position + viewAngle02 * detection.radius);

        if (detection.canSeePlayer)
        {
            Handles.color = Color.green;
            Handles.DrawLine(detection.transform.position, detection.playerRef.transform.position);
        }

        // Extended FOV

        // Extended Radius
        Handles.color = Color.red;
        Handles.DrawWireArc(detection.transform.position, Vector3.up, Vector3.forward, 360, detection.extendedRadius);

        // Extended FOV
        Vector3 viewEXAngle01 = DirectionFromAngle(detection.transform.eulerAngles.y, -detection.extendedAngle / 2);
        Vector3 viewEXAngle02 = DirectionFromAngle(detection.transform.eulerAngles.y, detection.extendedAngle / 2);

        Handles.color = Color.blue;
        Handles.DrawLine(detection.transform.position, detection.transform.position + viewEXAngle01 * detection.extendedRadius);
        Handles.DrawLine(detection.transform.position, detection.transform.position + viewEXAngle02 * detection.extendedRadius);
    }

    private Vector3 DirectionFromAngle(float eulerY, float angleInDegrees)
    {
        angleInDegrees += eulerY;

        return new Vector3(Mathf.Sin(angleInDegrees * Mathf.Deg2Rad), 0, Mathf.Cos(angleInDegrees * Mathf.Deg2Rad));
    }
}
