using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    [SerializeField] private float speed = 100f;
    [SerializeField] private int frameHitDelay = 10; // Used for predicting a collision x frames in the future (For high speeds)
    [SerializeField] private float lifeTime = 5f;
    private bool hitObject = false;

    private float scaledSpeed;
    public enum SenderType { PLAYER, ENEMY };
    private SenderType _type;
    public SenderType Type
    {
        set { _type = value; }
    }

    // Start is called before the first frame update
    void Start()
    {
        scaledSpeed = speed;
        Destroy(gameObject, lifeTime);
        gameObject.GetComponent<Rigidbody>().velocity = transform.forward * scaledSpeed;
    }

    // Update is called once per frame
    void Update()
    {
        if(!hitObject && Physics.Raycast(transform.position, transform.forward, out RaycastHit hit, frameHitDelay * scaledSpeed * Time.deltaTime))
        {
            checkHitType(hit);
        }
    }

    void checkHitType(RaycastHit hit)
    {
        switch(hit.collider.tag)
        {
            case "Enemy":
                StartCoroutine(HitEnemy(hit));
                hitObject = true;
                break;
            default: break;
        }
    }

    private IEnumerator HitEnemy(RaycastHit hit)
    {
        if(_type == SenderType.ENEMY)
        {
            yield return null;
        }
        yield return new WaitForSeconds(hit.distance / scaledSpeed);
        Destroy(gameObject);
    }

    
}
