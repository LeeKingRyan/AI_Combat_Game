using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.SearchService;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameController : MonoBehaviour
{
    private bool timeScaled = false;
    bool reset = true;
    // Start is called before the first frame update
    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if(Input.GetAxisRaw("Cancel") > 0)
        {
            EditorApplication.ExitPlaymode();
        }
        if(Input.GetKey(KeyCode.E) && reset)
        {
            if(timeScaled)
            {
                Time.timeScale = 1f;
                timeScaled = false;
            } 
            else
            {
                Time.timeScale = 0.02f;
                timeScaled = true;
            }
            Time.fixedDeltaTime = Time.timeScale * 0.02f;
            reset = false;
        } else
        {
            reset = true;
        }
    }
}
