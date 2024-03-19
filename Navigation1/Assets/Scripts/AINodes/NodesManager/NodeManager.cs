using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using Scripts.AINodes.Core;
using Scripts.AINodes.Nodes;
using UnityEngine;

public class NodeManager<T, W> : MonoBehaviour, INodeManager<T, W>
{
    // Update to the Global Black Instance in the Game Scene relevant information from
    // this manager's data collected from its managed nodes
    protected string ManagerName;

    [SerializeField] public float nodesUpdateDelay = 0.5f;

    public Node<T, W>[] nodes;
    private float nodesUpdateCooldown;

    protected Dictionary<INode<T, W>, W> nodesData; // Dictionary that holds node with associated value

    public virtual void UpdateToBlackBoard()
    {
        throw new System.NotImplementedException();
    }

    // Would need to call this Awake() method in a derived class of NodeManager.
    protected virtual void Awake()
    {
        // Have the nodes have a reference to their Manager and its necessary data collection instances
        foreach (var node in nodes)
        {
            node.Init(this);
        }
    }

    protected virtual void Start()
    {
        nodesData = new Dictionary<INode<T, W>, W>();
    }

    // Update is called once per frame
    protected virtual void Update()
    {
        // Have every node update to the Node Manager relevant information that may need
        // filter before updating to the Global BlackBoard Instance.
        if (Time.time > nodesUpdateCooldown)
        {
            nodesUpdateCooldown = Time.time + nodesUpdateDelay;

            foreach (var node in nodes)
            {
                node.UpdateToManager();
            }
        }
        UpdateToBlackBoard();
        
    }

    public Dictionary<INode<T, W>, W> GetNodesData()
    {
        return nodesData;
    }
}

