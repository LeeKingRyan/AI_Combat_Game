using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Follow : MonoBehaviour
{
    [SerializeField] private Transform player;
    private NavMeshAgent nav;
    private void Start()
    {
        nav = GetComponent<NavMeshAgent>();
        nav.updateRotation = false;
    }
    // Update is called once per frame
    void Update()
    {
        nav.SetDestination(player.position);
    }
}
