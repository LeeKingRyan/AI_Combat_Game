using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using ReGoap.Unity;
using ReGoap.Core;
using Scripts.AINodes.Nodes;
using System.ComponentModel;

namespace Scripts.Actions
{
    // This action handles entering an Ambush in which it chooses the nearest Valid Ambush Node that isn't reserved, and sets to its presconditions to reserve
    // the Ambush Node and 
    public class EnterAmbushAction : ReGoapAction<string, object>
    {
        private List<AmbushNode> usableAmbushes;
        private SmoothLookAt lookAt; // Rotate the Agent to look in the forward direction of this node and await Player to come to view.

        [SerializeField] private Transform _Parent;

        protected override void Awake()
        {
            base.Awake();
            Name = "EnterAmbushAction";
            Cost = 1;
            lookAt = GetComponent<SmoothLookAt>();
        }
        // Place holder action to chain the actions together regarding AmbushNode related actions.
        public override void Run(IReGoapAction<string, object> previous, IReGoapAction<string, object> next, ReGoapState<string, object> settings,
                                 ReGoapState<string, object> goalState, Action<IReGoapAction<string, object>> done, Action<IReGoapAction<string, object>> fail)
        {
            base.Run(previous, next, settings, goalState, done, fail);
            // Fail if the Ambush node Agent tries to enter becomes invalidated
            if (!agent.GetMemory().GetWorldState().HasKey("reservedAmbush"))
                failCallback(this);
            else if (!(bool) agent.GetMemory().GetWorldState().Get("seePlayer"))
            {
                // Check if the Agent sees the player, otherwise, have the Agent shift its rotation to the forward direction of the Ambush Node.
                AmbushNode ambush = (AmbushNode) settings.Get("nearestAmbush");

                // lookAt.LookAtDirection(ambush.transform.rotation);  // Instead of calling this function. Lets rotate the agent's parent game object's forward direction
                // That way if the Agent doesn't see the Player, then it's look at direction and sprite image to be analogous to the parent game object's forward direction
                // which is the forward direction of the ambushNode.
                _Parent.transform.rotation = ambush.transform.rotation;

                doneCallback(this);
            }
            doneCallback(this);
        }

        // Get the nearest Valid Ambush Node that's unreserved by any other Agent, only if the goal state DOES NOT
        // have the "atAmbush" key. Otherwise, the Agent already has reserved an Ambush Node, so check if the Agent
        // is at the reserved cover, and if at reserved cover, then this action can be ignored, else set precondition that
        // Agent needs to navigate to its reserved cover.

        // Also check if the Agent is within LOS of the Player. 
        public override List<ReGoapState<string, object>> GetSettings(GoapActionStackData<string, object> stackData)
        {
            settings.Clear();
            // [Originally] If Agent is already at an Ambush Point, so it also reserved the action, then ignore this action.
            // But hat if the Agent sees the Player and is in LOS. Naturally, we lose the element of surprise of Ambushing
            // and may simply attack, but what if we want to move to a new Ambush Node to avoid being in LOS, and thus
            // commit the element of surprise possibly, better if we don't see the player, but navigate to the next nearest
            // Valid unreserved AmbushNode.

            // An alternative solution to just editing the code here to consider navigating to other ambush nodes if already
            // reserved an ambush Node, is to adjust individually the radiuses and other parameters of the Ambush Nodes in the
            // game scene, but if we want to leave that up to the Game Manager to adjust difficulty, then this idea is bad!

            // Already at an AmbushNode, but we want to navigate to an ambushNode where Agent doesn't see the Player.
            // But what if we want the Agent to shoot at Player at the Ambush Node for a while, then we should based this on whether
            // the agent is in LOS? But if in LOS, then the Agent will dodge, and Agent may return to the Ambush Node it dodge from afterwards...

            // When Dodging from an Ambush Node, Agent must first exit from the Node with the ExitNodeAction

            // If the Agent is at an ambush Point, and is in LOS and the goal state tells the agent to be ready at some ambush point,
            // then navigate to some other AMbush point if there are other Valid unreserved AMbushNodes to consider. 
            if (stackData.goalState.HasKey("ambushReady") && stackData.currentState.HasKey("atAmbush")
                && stackData.currentState.TryGetValue("inLOS", out var danger) && (bool) danger)
            {
                Debug.Log("[EnterAmbushAction] At an Ambush Point already, but in Player LOS");

                // Get the nearest unreserved Valid Ambush Node that Agent is within radius of Agent that isn't already
                usableAmbushes = (List<AmbushNode>) stackData.currentState.Get("nearbyAmbushes");
                Debug.Log("[EnterAmbushAction] First options setting, the number of usable ambuses to consider is " + usableAmbushes.Count);

                AmbushNode nearestAmbush = GetNearestAmbush((Vector3) stackData.currentState.Get("startPosition"));

                // If there's a Valid AmbushNode nearby that's not reserved.
                if (nearestAmbush != null)
                {
                    Debug.Log("[EnterAmbushAction] This action has determined the Nearest Ambush Node that the Agent is within Radius of");
                    settings.Set("nearestAmbush", nearestAmbush);   // THe nearest ambush node not yet reserved.
                    settings.Set("getToAmbush", true);

                    // Get from the Agent's memory the current Ambush Node it reserves and set to exit the Node
                    AmbushNode oldAmbush = (AmbushNode) stackData.currentState.Get("reservedAmbush");
                    settings.Set("exitingNode", oldAmbush);

                    // Check if the Agent is in Player's LOS and set to settings if suppressive fire is necessary.
                    //if ((bool) stackData.currentState.Get("inLOS"))
                        //settings.Set("suppression", true);
                
                    return base.GetSettings(stackData);
                }
            }

            // Goal state demands Agent be at an Ambush Point and in this case the Agent is not already at one.
            // But what if the Agent had dodge from its reserved Ambush Point because it was in LOS, is it wise for the
            // Agent to return to where it dodge from?

            if (stackData.goalState.HasKey("ambushReady") && !stackData.currentState.HasKey("atAmbush"))
            {
                Debug.Log("[EnterAmbushAction]: Determining the settings for this action");

                if (stackData.currentState.HasKey("reservedAmbush"))
                {
                    Debug.Log("[EnterAmbushAction]: Agent should NOT reserve another AmbushNode");
                }

                // If the Agent has reserved an Ambush Point, but is not at the Ambush area, then Agent must navigate to it
                if (stackData.currentState.TryGetValue("reservedAmbush", out var ambush) && !stackData.currentState.HasKey("atAmbush"))
                {
                    Debug.Log("[EnterAmbushAction]: Reserved an AmbushNode, but have yet to navigate to it");

                    settings.Set("nearestAmbush", ambush);  // the reserved Ambush
                    settings.Set("getToAmbush", true);      // Not at Ambush Node, need to navigate there
                    settings.Set("hasReservation", ambush);

                    // [BUG ISSUE]: There is a delay in determining whether the Agent has in fact navigated. The Agent's AmbushSensor is slow
                    // at determining whether the Agent is at an AmbushNode. So this setting could run even though the Agent is at its destination. 
                    
                    // check if Agent has to 

                    // Check if the Agent is in Player's LOS and set to settings if suppressive fire is necessary.
                    //if ((bool) stackData.currentState.Get("inLOS"))
                        //settings.Set("suppression", true);
                    
                    return base.GetSettings(stackData);
                }

                // Otherwise:
                // Get the nearest unreserved Ambush Node if the Agent hasn't already reserved an ambush Node, so Agent must reserve
                // and navigate the node.
                usableAmbushes = (List<AmbushNode>) stackData.currentState.Get("nearbyAmbushes");
                AmbushNode nearestAmbush = GetNearestAmbush((Vector3) stackData.currentState.Get("startPosition"));

                Debug.Log("[EnterAmbushAction] The number of usable Ambush Nodes within radius is " + usableAmbushes.Count);
                // If there's a Valid AmbushNode nearby that's not reserved.
                if (nearestAmbush != null)
                {
                    Debug.Log("[EnterAmbushAction] This action has determined the Nearest Ambush Node is " + nearestAmbush.GetName());
                    settings.Set("nearestAmbush", nearestAmbush);   // The nearest ambush node not yet reserved.
                    settings.Set("getToAmbush", true);

                    // Check if the Agent is in Player's LOS and set to settings if suppressive fire is necessary.
                    //if ((bool) stackData.currentState.Get("inLOS"))
                    //    settings.Set("suppression", true);
                    
                    return base.GetSettings(stackData);
                }

            }
            return new List<ReGoapState<string, object>>();
        }

        // If the settings detect that the goal state requires the Agent to enter an Ambush Node, then the following
        // effect occurs.
        public override ReGoapState<string, object> GetEffects(GoapActionStackData<string, object> stackData)
        {
            effects.Clear();
            if (stackData.settings.HasKey("getToAmbush"))
                effects.Set("ambushReady", true);
            return effects;
        }

        // If the Agent is within Play'er LOS, then the Agent can conduct suppressive fire at the Player while navigating to
        // the Ambush Node [AttackTo action]

        // Otherwise, Agent just needs to navigate to the Ambush Node [GoTo Node]

        // Potential preconditions can be as follows:
        // 1. <"isAtNode", AmbushNode>
        // 2. (optional) <"reservedNode", AmbushNode>
        // 3. (optional) <"suppressiveFire", true>
        public override ReGoapState<string, object> GetPreconditions(GoapActionStackData<string, object> stackData)
        {
            preconditions.Clear();
            if (stackData.settings.HasKey("getToAmbush"))   // The Agent has an AmbushNode to navigate too
            {
                AmbushNode ambush = (AmbushNode) stackData.settings.Get("nearestAmbush");
                preconditions.Set("isAtNode", ambush);
                
                // Check if the Agent has already reserved an AmbushNode or not, if not, then Agent must reserve one:
                if (!stackData.settings.HasKey("hasReservation"))
                {
                    Debug.Log("[EnterAmbushAction]: Setting to preconditions that the Agent needs to reserve a Node");
                    preconditions.Set("reservedNode", ambush);
                }

                // Check if the Agent needs to exit its current AmbushNode
                if (stackData.settings.TryGetValue("exitingNode", out var node))
                {
                    preconditions.Set("exitedNode", node);
                }

                // Check if the Agent is in Player's LOS
                /*
                if (stackData.settings.HasKey("suppression"))
                {
                    Debug.Log("[EnterAmbushAction]: Suppressive fire has been ticked");
                    preconditions.Set("suppressiveFire", true);
                }
                */
            }
            return preconditions;
        }

        // The agent has reserved an AmbushNode or there are AmbushNodes nearby that are unreserved and valid
        public override bool CheckProceduralCondition(GoapActionStackData<string, object> stackData)
        {
            if(stackData.settings.HasKey("getToAmbush"))
                Debug.Log("[EnterAmbushAction] This Action has a Ambush Node the Agent needs to navigate to and possibly reserve");
            return base.CheckProceduralCondition(stackData) && stackData.settings.HasKey("getToAmbush");
        }

        private AmbushNode GetNearestAmbush(Vector3 position)
        {
          AmbushNode nearestAmbush = null;
          float minDist = Mathf.Infinity;
          Vector3 currentPos = position;

          foreach (var ambush in usableAmbushes)
          {
            if (ambush.IsLocked())
                continue;
            float dist = Vector3.Distance(ambush.transform.position, currentPos);
            if (dist < minDist)
            {
                nearestAmbush = ambush;
                minDist = dist;
            }
          }
          return nearestAmbush;
        }

        // AN alternative function to check whether the Agent is at a node location, rather than solely relying on
        // if the AmbushSensor determines if at a reserved node location...
        // With the Agent's start position and the given AmbushNode, check if the Agent is at the node.
        private bool AtNode(AmbushNode node)
        {
            Vector3 currentPosition = (Vector3) agent.GetMemory().GetWorldState().Get("startPosition");
            float dist = Vector3.Distance(currentPosition, node.transform.position);
            // ReGoapLogic GameObject is not on the same horizontal axis as the cover nodes and ambush nodes, so the ReGoapLogic Game Object
            // may have to be adjusted.
            if (dist <= 1.2)
            {
                Debug.Log("[EnterAmbushAction]: At Ambush Location... called in AtNode helper function");
                return true;
            }
            return false;
        }
    }
}
