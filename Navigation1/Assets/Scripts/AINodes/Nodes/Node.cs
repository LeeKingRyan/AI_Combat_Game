using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Planner;
using Scripts.AINodes.Core;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Rendering;

namespace Scripts.AINodes.Nodes
{
    public class Node<T, W> : MonoBehaviour, INode<T, W>
    {
        public string NodeName;
        public INodeManager<T, W> manager;
        public bool valid = false;

        public float radius;

        [SerializeField] protected bool reserved = false;   // Made public for testing purposes
        protected IReGoapAgent<T, W> customer;

        protected bool abandoned;

        public WaitForSeconds unlockDelay;
        public virtual string GetName()
        {
            return NodeName;
        }
        // Have references to any data collection instance to the given
        // Manager
        public virtual void Init(INodeManager<T, W> manager)
        {
            this.manager = manager;
        }

        public virtual void UpdateToManager()
        {
            throw new System.NotImplementedException();
        }
        public virtual bool IsValid()
        {
            return valid;
        }

        public virtual bool InRadius(Vector3 agentPosition)
        {
            float dist = Vector3.Distance(agentPosition, transform.position);
            if (dist <= radius)
                return true;
            else
                return false;
        }

        public virtual bool LocKNode(IReGoapAgent<T, W> agent)
        {
            if (!reserved)
            {
                reserved = true;
                customer = agent;
                return true;
            }
            else
                return false;
        }

        public virtual bool IsLocked()
        {
            return reserved;
        }

        public virtual IReGoapAgent<T, W> GetAgent()
        {
            return customer;
        }

        public virtual bool IsAgentAlive()
        {
            return true;
        }

        public virtual void ExitNode()
        {
            abandoned = true;
            StartCoroutine(UnlockNode());
        }

        // If the Node has been recently abandoned by some agent, then
        // check whether the given Agent was the Agent that left the
        // this Node
        public virtual bool RecentlyExited(IReGoapAgent<T, W> goapAgent)
        {
            if (abandoned && customer.ToString() == goapAgent.ToString())
                return true;
            return false;
        } 

        // Function that reactivates the CoverNode after some duration of time.
        protected IEnumerator UnlockNode()
        {
            Debug.Log("The UnlockNode function has been called!");
            yield return unlockDelay;
            reserved = false;
            customer = null;
            abandoned = false;
        }
    }
}
