using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Rotate the Sprite, based on the transform.Rotation.Y of some GameObject with an FOV
public class RotateSprite : MonoBehaviour
{   
    public Transform _FOV;
    private const float step = 22.5f;

    private Vector3 N, S, E, W, NE, NW, SE, SW;

    // Initialize all directions N, S, E, W, NE, SE, NW, SW.
    void Start()
    {
        N = new Vector3(0, 0, 0);
        S = new Vector3(0, 180, 0);
        E = new Vector3(0, 90, 0);
        W = new Vector3(0, 270, 0); // -90
        NE = new Vector3(0, 45, 0);
        NW = new Vector3(0, 315, 0); // -45
        SE = new Vector3(0, 135, 0);
        SW = new Vector3(0, 225, 0); // -135
    }



    // Change the Sprite Animate State or Sprite itself based on the Rotation.Y of the _FOV
    // As a placeholder, simply rotate this Transform to one of the preset rotations.
    public void ChangeSpriteRotation()
    {
        // Extract the angle - axis rotation from the _FOV's transform rotation
        float angle = 0.0f;
        Vector3 axis = Vector3.zero;
        _FOV.transform.rotation.ToAngleAxis(out angle, out axis);   // converts rotation to angle-axis representation

        var AbsAngle = Mathf.Abs(angle);
        
        // Rotate the Sprite to Face North/Forward, In this case the rotation of the GameObject Agent.
        // Note that Rotating the Capsule is just a place holder for sprites
        //Debug.Log("ANGLE Is " + angle + "Degrees");
        // Full Rotation!!

        if (AbsAngle < step || AbsAngle > 337.5)
        {
            // rotate to the forward direction 
            transform.localEulerAngles = N;
            //spriteRenderer.sprite = N;
        }
        else if (AbsAngle > step && AbsAngle < step*3)
        {
            transform.localEulerAngles = Mathf.Sign(angle) < 0 ? NW : NE;
            // spriteRenderer.sprite = Mathf.Sign(angle) < 0 ? NW : NE;
        }
        else if (AbsAngle > 3*step && AbsAngle < step*5)
        {
            transform.localEulerAngles = Mathf.Sign(angle) < 0 ? W : E;
            //spriteRenderer.sprite = Mathf.Sign(angle) < 0 ? W : E;
        }
        else if (AbsAngle > 5*step && AbsAngle < step*7)
        {
            transform.localEulerAngles = Mathf.Sign(angle) < 0 ? SW : SE;
            //spriteRenderer.sprite = Mathf.Sign(angle) < 0 ? SW : SE;
        }
        else if (AbsAngle > 7*step && AbsAngle < step*9)
        {
            transform.localEulerAngles = S;
            //spriteRenderer.sprite = S;
        }
        else if (AbsAngle > 9*step && AbsAngle < step*11)
        {
            transform.localEulerAngles = SW;
        }
        else if (AbsAngle > 11*step && AbsAngle < step*13)
        {
            transform.localEulerAngles = W;
        }
        else if (AbsAngle > 13*step && AbsAngle < step*15)
        {
            transform.localEulerAngles = NW;
        }

    }

    // How to reset the Sprite back to N if Player is no longer detected. Whatever the current orientation is, Navigate back to N

    // N, NE, E, SE, S, SW, W, NW
    // Get the index of the current orientation, then rotate through the orientations that chain to the shortest one way path, back to
    // the index holding the orientation N.


    // private SpriteRenderer spriteRenderer;
    // public Transform plane;
    // public Camera cam;

    // private const float step = 22.5f;

    // public Sprite N, NW, W, SW, S, SE, E, NE;
    // public void Start() => spriteRenderer = GetComponent<SpriteRenderer>();

    /*
    public void Update()
    {
        var projected = Vector3.ProjectOnPlane(cam.transform.forward, plane.up);

        var angle = Vector3.SignedAngle(projected, plane.forward, plane.up);
        
        var AbsAngle = Mathf.Abs(angle);
        
        if (AbsAngle < step) spriteRenderer.sprite = N;
        else if (AbsAngle < step*3) spriteRenderer.sprite = Mathf.Sign(angle) < 0 ? NW : NE;
        else if (AbsAngle < step*5) spriteRenderer.sprite = Mathf.Sign(angle) < 0 ? W : E;
        else if (AbsAngle < step*7) spriteRenderer.sprite = Mathf.Sign(angle) < 0 ? SW : SE;
        else spriteRenderer.sprite = S;
        
        Billboard(spriteRenderer.transform, cam);
    }
    */
}
