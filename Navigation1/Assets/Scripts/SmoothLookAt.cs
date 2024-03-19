using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmoothLookAt : MonoBehaviour
{
    public Transform _Target;
    public Transform _Parent;

    [Tooltip("Higher Speed equals faster rotation")]
    public float Speed = 1f; // How fast want to turn

    public float ResetSpeed = 1f;

    private Coroutine LookCoroutine;

    private Quaternion originalRotationValue;

    private Quaternion someDirection;

    void Start()
    {
        originalRotationValue = transform.rotation;
    }

    // Look in the direction of a given rotation
    public void LookAtDirection(Quaternion direction)
    {
        someDirection = direction;
        StartRotating();
    }
    // Look at a target position
    public void LookAtTarget()
    {
        StartRotating(true);
    }

    public void LostSight()
    {
        if (LookCoroutine != null)
            StopCoroutine(LookCoroutine);
        ResetRotation();
    }

    // Reset the Transform to be in the rotation of a Parent Game Object
    private void ResetRotation()
    {
        Quaternion parentRotation = _Parent.transform.rotation;

        //transform.rotation = transform.rotation * parentRotation;
        transform.rotation = Quaternion.Slerp(transform.rotation, parentRotation, ResetSpeed * Time.deltaTime);
        
        // Quaternion resetRotation = transform.rotation * parentRotation;

        /*
        float time = 0;

        while (time < 1)
        {
            transform.rotation = Quaternion.Slerp(transform.rotation, parentRotation, time);
            time += Time.deltaTime * ResetSpeed;
        }
        */
        
    }
    // Begin the rotation of the Agent [Separate from Sprite, the Sprite catches up]
    public void StartRotating(bool atPlayer = false)
    {
        if(LookCoroutine != null)
            StopCoroutine(LookCoroutine);
        if (atPlayer)
            LookCoroutine = StartCoroutine(LookAt());
        else
            LookCoroutine = StartCoroutine(FaceDirection());
    }

    private IEnumerator LookAt()
    {
        // Get the direction from the transform position to target position, then pass that to Quaternion to get the desired rotation.
        Quaternion lookRotation = Quaternion.LookRotation(_Target.position - transform.position);

        float time = 0;

        while (time < 1)
        {
            transform.rotation = Quaternion.Slerp(transform.rotation, lookRotation, time);
            time += Time.deltaTime * Speed;
            yield return null;
        }
    }
    // Given some quaternion roation, face the same direction as the given rotation
    private IEnumerator FaceDirection()
    {
        float time = 0;

        while (time < 1)
        {
            transform.rotation = Quaternion.Slerp(transform.rotation, someDirection, time);
            time += Time.deltaTime * Speed;
            yield return null;
        }
    }
}
