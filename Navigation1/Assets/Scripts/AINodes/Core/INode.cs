using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using UnityEngine;

namespace Scripts.AINodes.Core
{
    public interface INode<T, W> 
    {
        // Have Node get a reference to the dataBank(s) of its respective 
        void Init(INodeManager<T, W> manager);
        // Update Information to the respective Manager
        void UpdateToManager();
        // Get the Name of the Node
        string GetName();

        // Check whether the Node is Valid.
        bool IsValid();
        // Is an Agent in Radius for it to consider using this node
        bool InRadius(Vector3 agentPosition);
        // Can the given Agent lock/reserve this Node, and if so return true and
        // lock it with this Agent.
        bool LocKNode(IReGoapAgent<T, W> agent);
        // Is this Node locked?
        bool IsLocked();
        // Get the Agent that reserved this Node
        IReGoapAgent<T, W> GetAgent();
        // Check if the Agent that reserved this Node is still alive.
        bool IsAgentAlive();
        // Function called for Agent to Exit the Node, thus freeing it
        void ExitNode();

        // Check if the Agent recently exited the Node
        bool RecentlyExited(IReGoapAgent<T, W> goapAgent);
    }
}
