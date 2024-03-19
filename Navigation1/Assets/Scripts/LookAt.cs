using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAt : MonoBehaviour
{
    [SerializeField] private Transform lookingAt;
    private Aiming aiming;

    private void Start()
    {
        aiming = GetComponent<Aiming>();
    }
    // Update is called once per frame
    void Update()
    {
        aiming.AimAtPoint(lookingAt.position);
    }
}
