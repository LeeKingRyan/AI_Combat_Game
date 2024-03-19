using System.Collections;
using System.Collections.Generic;
using ReGoap.Planner;
using Scripts.AINodes.Core;
using Scripts.SquadBehaviors.BlackBoards;
using UnityEngine;
using Scripts.AINodes.Nodes;

namespace Scripts.AINodes.NodesManager
{
    public class CoverNodeManager : NodeManager<string, object>
    {
        // private Dictionary<INode<string, object>, object> coverNodes;  // CoverNodes with either True or False values
        private List<CoverNode> validCoverNodes;        // All valid Cover Nodes in the GameScene.
        // Update to the Blackboard a list of ony Valid Cover Nodes

        public static CoverNodeManager Instance;
        public override void UpdateToBlackBoard()
        {
            validCoverNodes.Clear();
            foreach(var coverNode in nodesData)
            {
                if((bool) coverNode.Value)
                    validCoverNodes.Add((CoverNode) coverNode.Key);
            } 
            // Update to the BlackBoard these new Valid CoverNodes. Note: The older valid covernodes are overwritten in the BlackBoard.
            BlackBoard<string, object>.Instance.Set("validCoverNodes", validCoverNodes);
            Debug.Log("Number of Valid Cover Nodes is " + validCoverNodes.Count);
        }

        // Would need to call this Awake() method in a derived class of NodeManager.
        protected override void Awake()
        {
            base.Awake();
            if (Instance != null)
            {
                Destroy(this);
                var errorString =
                    "[NodeManager] Trying to instantiate a new" + ManagerName + "Node manager but there can be only one per scene.";
                Debug.LogError(errorString);
                throw new UnityException(errorString);
            }
            Instance = this;
        }

        protected override void Start()
        {
            base.Start();
            // coverNodes = new Dictionary<INode<string,object>, object>();
            validCoverNodes = new List<CoverNode>();
        }
    }
}
