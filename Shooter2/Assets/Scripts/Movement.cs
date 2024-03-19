using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class Movement : MonoBehaviour
{
    [SerializeField] private float speed = 10f;
    [SerializeField] private Transform camera;
    Rigidbody rigidbody;
    float timeSpeed;
    float horizontal;
    float vertical;
    // Start is called before the first frame update
    void Start()
    {
        rigidbody = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        Vector3 movement = Vector3.zero;
        timeSpeed = speed / Time.timeScale;
        horizontal = Input.GetAxisRaw("Horizontal");
        if (horizontal != 0)
        {
            //rigidbody.AddForce(0, 0, timeSpeed, ForceMode.VelocityChange);
            movement += camera.right * timeSpeed * horizontal;
        }

        vertical = Input.GetAxisRaw("Vertical");
        if (vertical != 0)
        {
            movement += camera.forward * timeSpeed * vertical;
        }

        movement.y = rigidbody.velocity.y;
        rigidbody.velocity = movement;
        //rigidbody.velocity = Vector3.ClampMagnitude(rigidbody.velocity, speed);

    }
}
