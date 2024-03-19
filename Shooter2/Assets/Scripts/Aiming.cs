using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Aiming : MonoBehaviour
{
    [SerializeField] private GameObject pivot;
    [SerializeField] private float dirOffset = 90;

    Transform transform;
    // Start is called before the first frame update
    void Start()
    {
        if(pivot.TryGetComponent<Transform>(out Transform tf))
        {
            transform = tf;
        }
        else transform = GetComponent<Transform>();
        Time.timeScale = 1f;
        Time.fixedDeltaTime = Time.timeScale * 0.02f;
    }

    public void AimAtPoint(Vector3 pos)
    {
        Vector3 relativePos = pos - pivot.transform.position;
        // Determine the direction of the cursor relative to the pivot position
        float direction = Mathf.Atan2(relativePos.z, relativePos.x) * Mathf.Rad2Deg;

        // Rotate the pivot to aim toward the cursor
        pivot.transform.eulerAngles = new Vector3(pivot.transform.eulerAngles.x, -direction + dirOffset, pivot.transform.eulerAngles.z);
    }
}
