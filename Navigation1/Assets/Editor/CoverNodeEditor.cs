using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(CoverNode))]
public class CoverNodeEditor : Editor
{
    private void OnSceneGUI()
    {
        CoverNode detection = (CoverNode) target;

        // BoundryRadius
        Handles.color = Color.magenta;
        Handles.DrawWireArc(detection.transform.position, Vector3.up, Vector3.forward, 360, detection.boundryRadius);

        // FOV

        Vector3 viewAngle01 = DirectionFromAngle(detection.transform.eulerAngles.y, -detection.angleFOV / 2);
        Vector3 viewAngle02 = DirectionFromAngle(detection.transform.eulerAngles.y, detection.angleFOV / 2);

        Handles.color = Color.blue;
        Handles.DrawLine(detection.transform.position, detection.transform.position + viewAngle01 * detection.boundryRadius);
        Handles.DrawLine(detection.transform.position, detection.transform.position + viewAngle02 * detection.boundryRadius);


        // Draw Line to Player

        if (detection.valid)
        {
            Handles.color = Color.green;
            Handles.DrawLine(detection.transform.position, detection.playerRef.transform.position);
        }

        // Threat Radius
        Handles.color = Color.red;
        Handles.DrawWireArc(detection.transform.position, Vector3.up, Vector3.forward, 360, detection.threatRadius);

        // Radius for Agents to Consider the Node.
        Handles.color = Color.green;
        Handles.DrawWireArc(detection.transform.position, Vector3.up, Vector3.forward, 360, detection.radius);

    }

    private Vector3 DirectionFromAngle(float eulerY, float angleInDegrees)
    {
        angleInDegrees += eulerY;

        return new Vector3(Mathf.Sin(angleInDegrees * Mathf.Deg2Rad), 0, Mathf.Cos(angleInDegrees * Mathf.Deg2Rad));
    }
}
