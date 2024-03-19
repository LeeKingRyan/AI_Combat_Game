using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.AINodes.Core
{
    public interface INodeManager<T, W>
    {
        // Update to the Gloabl BlackBoard Instance relevant data from this
        // AINode Manager
        void UpdateToBlackBoard();
        Dictionary<INode<T, W>, W> GetNodesData();
    }
}
