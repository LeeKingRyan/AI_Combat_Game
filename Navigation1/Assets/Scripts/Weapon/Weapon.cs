using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class Weapon : MonoBehaviour
{
    [SerializeField] private float fireRate = 300;
    [SerializeField] private bool _isAutomatic = false;
    public bool isAutomatic => _isAutomatic;
    [SerializeField] private float recoilWidth = 20;
    [SerializeField] private float recoilRecoverSpeed = 5; // Vague, but it affects how quickly the gun recovers from recoil
    [SerializeField] private GameObject barrel;
    [SerializeField] private GameObject bullet;
    [SerializeField] private Transform bank;
    [SerializeField] private Bullet.SenderType type = Bullet.SenderType.ENEMY;
    [SerializeField] private TrailRenderer bulletTrail;

    private GameObject newBullet;

    private Quaternion originalRotation;
    private Quaternion currentRot;
    
    private bool canFire = true;

    private void Start()
    {
        originalRotation = transform.localRotation;
    }

    private void Update()
    {
        currentRot = Quaternion.Lerp(transform.localRotation, originalRotation, (recoilRecoverSpeed / Time.timeScale) * Time.deltaTime);
        transform.localRotation = currentRot;
    }

    public bool TryFire()
    {
        if (canFire)
        {
            Fire();
            Recoil();
        }
        return false;
    }
    private void Fire()
    {
        newBullet = Instantiate(bullet, barrel.transform.position, barrel.transform.rotation, bank);
        newBullet.GetComponent<Bullet>().Type = type;
        TrailRenderer trail = Instantiate(bulletTrail, barrel.transform.position, barrel.transform.rotation, bank);
        StartCoroutine(DrawTrail(trail, newBullet.transform));
        StartCoroutine(WaitFireRate());
    }

    private void Recoil()
    {
        transform.rotation = Quaternion.Euler(transform.eulerAngles.x, transform.eulerAngles.y + UnityEngine.Random.Range(-recoilWidth/2, recoilWidth/2), transform.eulerAngles.z);
    }

    private IEnumerator WaitFireRate()
    {
        canFire = false;
        yield return new WaitForSeconds(60 / (fireRate / Time.timeScale));
        canFire = true;
    }

    private IEnumerator DrawTrail(TrailRenderer newTrail, Transform b_transform)
    {
        while(b_transform != null)
        {
            newTrail.transform.position = b_transform.position;
            yield return null;
        }

        Destroy(newTrail, newTrail.time);
    }

}
