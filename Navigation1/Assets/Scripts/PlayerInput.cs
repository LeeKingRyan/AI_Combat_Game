using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInput : MonoBehaviour
{
    [SerializeField] private Weapon weapon;
    [SerializeField] private Camera m_camera;
    [SerializeField] private LayerMask lm;
    [SerializeField] private Transform pivot;
    [SerializeField] private float mouseSens;
    private Vector3 mousePos;
    private bool isAutomatic;
    private bool triggerReset;
    private float YAxisRotation = 0f;

    // Start is called before the first frame update
    void Start()
    {
        isAutomatic = weapon.isAutomatic;
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetAxisRaw("Fire1") > 0 && triggerReset)
        {
            weapon.TryFire();
            triggerReset = isAutomatic;
        } else if(Input.GetAxisRaw("Fire1") == 0 && !triggerReset) 
        {
            triggerReset = true;
        }

        Aim();
    }

    private void Aim()
    {
        YAxisRotation += Input.GetAxisRaw("Mouse X") * mouseSens;

        pivot.eulerAngles = new Vector3(0f, YAxisRotation, 0f);
    }
}
