using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.AINodes.Nodes;
using Scripts.SquadBehaviors.BlackBoards;
using UnityEngine;

namespace Scripts.Sensors
{
    // Make sure that Agent only considers Ambush Nodes that it's in radius of, and
    // are unreserved by other Agents. Also, keeps track of what Ambush Node it currently
    // reserves if any, and if it's at the AmbushNode.
    public class AmbushSensor : ReGoapSensor<string, object>
    {
        private List<AmbushNode> validAmbushNodes;    // Nodes that are valid

        private List<AmbushNode> usableAmbushNodes; // Nodes that can be used
        
        private AmbushNode currentNode;
        private IReGoapAgent<string, object> agent;

        private bool reservedNode = false;

        // Every call to this method, we update to the Agent's memory what usable AmbushNodes it can utilize and what Ambush Node it reserves and
        // occupies (only if it reserves a node). Also, if the Agent recently exitied a node it originally reserved, then it won't be
        // considered as an AmbushNode it reserves nor occupies.
        public override void UpdateSensor()
        {
            // Get the Nearby Valid Ambush Nodes that are Not Reserved by any other Agent. Note, validCoverNodes list
            // can be empty, but never null.
            if (BlackBoard<string, object>.Instance.TryGetValue("validAmbushNodes", out var ambushNodes))
            {
                var state = memory.GetWorldState();
                validAmbushNodes = (List<AmbushNode>) ambushNodes;
                usableAmbushNodes.Clear();
                reservedNode = false;           // need to reset this every update, so this is not true the next update when its not


                // Check if list is empty, if so, then remove from memory any nearby ambush points and reserved ambush.
                // Make sure to exit the Ambush Node that is reserved by this agent. Return from this Update iteration.
                if(validAmbushNodes.Count <= 0)
                {
                    state.Set("nearbyAmbushes", usableAmbushNodes);
                    if(state.TryGetValue("reservedAmbush", out var ambush))
                    {
                        
                        AmbushNode node = (AmbushNode) ambush;

                        Debug.Log("[AmbushSensor]: Exited Node because there's no Valid Nodes in the scene");
                        node.ExitNode();

                        state.Remove("reservedAmbush");  // No point remembering cover that becomes invalidated.
                        state.Remove("atAmbush");                                // No longer in cover
                    }
                    return;
                }

                // Add to the usableCoverNodes list Valid Ambush points that Agent is within Radius of, and are unreserved.
                // This excludes the Ambush Node that Agent currently reserves and, or occupies. Also, keep track of what Ambush Node
                // Agent has reserved, if any.

                // Warning: ReserveAmbush is ONLY true if there are valid ambush nodes to check
                foreach(var ambush in validAmbushNodes)
                {
                    currentNode = ambush;
                    // Check for Ambush Nodes Agent is within Radius of, and if they're locked
                    if (currentNode.InRadius((Vector3) state.Get("startPosition")))
                    {
                        // If not locked, then add to list of usableAmbushNodes
                        if (!currentNode.IsLocked())
                        {
                            usableAmbushNodes.Add(currentNode);
                        }
                        // Otherwise, check if it's this agent that locked and reserved it. But what if the Agent
                        // has exited this reserved Node? Because when exiting a Node, it takes time to reset its customer to
                        // null and that its unreserved, so that other agents don't immediately use it.
                        else if(currentNode.GetAgent().ToString() == agent.ToString())
                        {
                            // Check if the Agent has abandoned this Ambush Node, and if so, make sure that the AmbushNode
                            // the Agent currently reserves is not this node. If it is the node, then remove it from memory,
                            // otherwise, ignore this check.
                            if (currentNode.RecentlyExited(agent) && state.TryGetValue("reservedAmbush", out var reservation))  // Is this an old reservation?
                            {
                                AmbushNode currentReservation = (AmbushNode) reservation;
                                if (currentReservation.GetName() == currentNode.GetName())
                                {
                                    Debug.Log("[AmbushSensor]: Removing the key atAmbush, because Agent currently reserves a node that it recently exit from");
                                    state.Remove("reservedAmbush");
                                    // can remove key at Ambush if there is no ambush node the Agent reserves
                                    state.Remove("atAmbush");           // Should only remove atAmbush if not at the rservedAbush location
                                    reservedNode = false;               // say that no longer reserve an ambush node, because the reservedAmbush key was removed
                                }
                                continue;
                            }

                            // just say that the Agent reserved it, but the moment the Ambush Node is invalidated
                            // then this key condition is removed
                            state.Set("reservedAmbush", currentNode);
                            reservedNode = true;
                        }
                    }
                }

                // check whether if the Agent is in the Ambush Node it reserved if it has reserved an AMbushNode.
                // Note: It's best to get the distance between the Agent's position and the Ambush Node's position
                // and compare that to some float.
                if (reservedNode)
                {
                    Vector3 currentPosition = (Vector3) state.Get("startPosition");
                    
                    AmbushNode reservedAmbush = (AmbushNode) state.Get("reservedAmbush");

                    Vector3 objectiveNodePosition = reservedAmbush.transform.position;

                    currentPosition.y = 0;
                    objectiveNodePosition.y = 0;

                    float dist = Vector3.Distance(currentPosition, objectiveNodePosition);

                    // Note: Because, the ReGoapLogic GameObject and any Node in the Gme Scene are not at the
                    // same elevation on the y-axis, it would probably be best to remove the y components, by
                    // setting them to zero when calculating the magnitue of the difference between the two
                    // positions.


                    Debug.Log("[AmbushSensor]: The distance from the Agent's position to the Reserved Ambush Position is " + dist);
                    
                    if (dist < 0.6)
                    {
                        Debug.Log("[AmbushSensor]: At Ambush Location");
                        memory.GetWorldState().Set("atAmbush", true);
                    }
                }
                
                // Don't reserve an Ambush Node
                else
                {
                    Debug.Log("[AmbushSensor]: Agent DOes NOT reserve an AmbushNode eithether due to invalidation (not considered in usable ambushes) or been exited");
                    state.Remove("reservedAmbush");
                    state.Remove("atAmbush");
                }


                // Write the memory the usable cover the Agent can consider if any within radius and Valid, and unreserved
                // Otherwise an empty list is written with the key "neabyAmbushes". Not including the AmbushNode that the Agent already reserves.

                Debug.Log("[AmbushSensor]: The number of usable Ambush Nodes is " + usableAmbushNodes.Count);
                state.Set("nearbyAmbushes", usableAmbushNodes);
            } 
            
        }
        // Start is called before the first frame update
        void Start()
        {
            validAmbushNodes = new List<AmbushNode>();
            usableAmbushNodes = new List<AmbushNode>();
            agent = GetComponent<IReGoapAgent<string, object>>();

            // memory.GetWorldState().Set("atAmbush", false);

        }
    }
}

