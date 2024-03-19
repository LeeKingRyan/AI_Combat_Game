using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.SquadBehaviors.BlackBoards;
using UnityEngine;

namespace Scripts. Sensors
{
    // The Cover Sensor tells the Agent, via its memory, what VALID Cover Node it reserves, and what VALID other
    // Cover Nodes are nearby, unreserved by other Agents. Note that a VALID CoverNode already implies that the Node
    // is close to the Player. And nearby means that the Agent is within Radius of Cover Nodes to even consider using them.

    // Best to have a list of neaby Valid Cover Nodes, rather than a single Node from the list, so that
    // the sensor remains open ended, and is more general purpose for Behaviors.

    // The conditions set to memory every update are:
    // <"nearbyCover", List<INode<string, object>> usableCoverNode> Cover nearby to Agent, exclusive from
    // cover that Agent already reserved.

    // <"reservedCover", CoverNode cover> Cover that the agent reserved. Whether or not Agent occupys 
    // the cover is checked by the other systems, such as Agent's Goals and Actions for their purposes.
    public class CoverSensor : ReGoapSensor<string, object>
    {
        private List<CoverNode> validCoverNodes;    // Nodes that are valid

        private List<CoverNode> usableCoverNodes; // Nodes that can be used
        
        private CoverNode currentNode;
        private IReGoapAgent<string, object> agent;

        private bool reservedNode = false;
        public override void UpdateSensor()
        {
            // Get the Nearby Valid Cover Nodes that are Not Reserved by any other Agent. Note, validCoverNodes list
            // can be empty, but never null.
            if (BlackBoard<string, object>.Instance.TryGetValue("validCoverNodes", out var coverNodes))
            {
                var state = memory.GetWorldState();
                validCoverNodes = (List<CoverNode>) coverNodes;
                usableCoverNodes.Clear();
                reservedNode = false;

                // Check if list is empty, if so, then remove from memory any nearby cover and reserved cover.
                // Make sure to exit cover that is reserved by this agent. Return from this Update iteration.
                if(validCoverNodes.Count <= 0)
                {
                    state.Set("nearbyCover", usableCoverNodes);
                    if(state.TryGetValue("reservedCover", out var cover))
                    {
                        CoverNode node = (CoverNode) cover;
                        node.ExitNode();                // make sure CoverNode has been exited
                        state.Remove("reservedCover");  // No point remembering cover that becomes invalidated.
                        state.Remove("inCover");                                // No longer in cover
                    }
                    return;
                }

                // Add to the usableCoverNodes list Valid Cover that Agent is within Radius of, and are unreserved.
                // This excludes Cover that Agent already reserves and, or occupies. Also, keep track of what Cover Node
                // Agent has reserved, if any.
                foreach(var cover in validCoverNodes)
                {
                    currentNode = cover;
                    // Check for Nodes Agent is within Radius of, and add them to usableCover list if they're NOT locked
                    if (currentNode.InRadius((Vector3) state.Get("startPosition")))
                    {
                        // If not locked, then add to list of usableCoverNodes
                        if (!currentNode.IsLocked())
                        {
                            usableCoverNodes.Add(currentNode);
                        }
                        // Otherwise, check if it's this agent that locked and reserved it
                        else if(currentNode.GetAgent().ToString() == agent.ToString())
                        {
                            // just say that the Agent reserved it, but the moment the cover is invalidated
                            // then this key condition is removed
                            state.Set("reservedCover", currentNode);
                            reservedNode = true;
                        }
                    }
                }

                // check whether if the Agent is in cover, if it has reserved cover
                if (reservedNode)
                {
                    Vector3 currentPosition = (Vector3) state.Get("startPosition");
                    CoverNode reservedCover = (CoverNode) state.Get("reservedCover");
                    if (currentPosition == reservedCover.transform.position)
                        state.Set("inCover", true);
                }
                else
                {
                    state.Remove("reservedCover");  // Remove reservedNode, including if it's been previously set.
                    state.Remove("atAmbush");
                }

                // Write the memory the usable cover the Agent can consider if any within radius and Valid, and unreserved.
                // This includes empty list of usableCover as well.
                state.Set("nearbyCover", usableCoverNodes);
            } 
            
        }
        // Start is called before the first frame update
        void Start()
        {
            validCoverNodes = new List<CoverNode>();
            usableCoverNodes = new List<CoverNode>();
            agent = GetComponent<IReGoapAgent<string, object>>();

        }
    }
}
