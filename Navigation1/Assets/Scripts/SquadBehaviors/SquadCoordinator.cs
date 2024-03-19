using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Scripts.SquadBehaviors.Core;
using ReGoap.Core;
using Scripts.SquadBehaviors.BlackBoards;
using Scripts.SquadBehaviors.Behaviors;

namespace Scripts.SquadBehaviors
{
    public class SquadCoordinator : SquadBehaviorSystem<string, object>
    {
        public float orderDelay = 5;
        private WaitForSeconds _waitForSeconds;

        protected override void Awake()
        {
            base.Awake();
            _waitForSeconds = new WaitForSeconds(orderDelay);
        }

        // Hard code the Squad Behaviors to the bahviors list in the RefreshBehaviorSet().
        public override void RefreshBehaviorsSet()
        {
            behaviors = new List<IBehavior<string, object>>();
            PatrolBehavior patrolBehavior = PatrolBehavior.Instantiate();
            behaviors.Add(patrolBehavior);
        }

        // Upon start, perhaps wait 2 secs to provide time for agents ot form up into squads.

        // Each Update, get the list of available squads from the blackboard, then assign new behaviors to each squad if
        // not already assigned a behavior. Also check if squads with behaviors have failed or finished, and give orders otherwise.
        void Update() {
            // Make sure that there are squads inside the global blackboard. Don't worry, only valid squads and agents are added to the global blackboard,
            // as you'll see inside the Squad Manager and derived Soldeir Manager class.
            if (BlackBoard<string, object>.Instance.TryGetValue("squads", out var squads)) {
                // check on whether the squad has a behavior (no behavior means a behavior is cancelled and warrants a new behavior),
                // otherwise, determine a new behavior if squad either finished or failed.
                foreach (var squad in (List<ISquad<string, object>>) squads)
                {
                    // Turn this if condition and GiveOrders to a Unity Job:

                    // Things to evaluate from the job: What squad members are given what orders. A dictionary of <squad member, order given>

                    // Does (!squad.GetBehavior().IsFailed() || !squad.GetBehavior().IsFinished()) returned true? If so we need to remove all orders from every squad member
                    // since that cannot be done in jobs.

                    // Is squad.GetBehavior() != null

                    // Give orders again, could be the same previous orders given.
                    if (squad.GetBehavior() != null && !(squad.GetBehavior().IsFailed() || squad.GetBehavior().IsFinished()))
                    {
                        Debug.Log("[SQUAD COORDINATOR] Giving Orders");
                        // Note: Orders are only given every 0.5f inside the Behaviors class
                        // GiveOrders may have to be called multiple times for each squad. If employed Unity's Job system to determine orders
                        // for the squad upon each iterations, in parrallel. That can help tremendously.

                        // StartCoroutine(OrdersDelay(squad));

                        // Debug.Log("[SQUAD COORDINATOR] Waited " + orderDelay + " seconds to Give Orders.");
                        
                        squad.GetBehavior().GiveOrders(squad);
                    }
                    // Remove the behavior from the squad if it is either finished or failed.
                    else if (squad.GetBehavior() != null && (squad.GetBehavior().IsFailed() || squad.GetBehavior().IsFinished()))
                    {
                        Debug.Log("[SQUAD COORDINATOR] Behavior " + squad.GetBehavior().GetName() + " " + (squad.GetBehavior().IsFinished() ? "finshed" : "failed"));
                        squad.RemoveBehavior();
                    }

                    // Squad no loner is associated with a behavior either from being cancelled, finished, or failed,
                    // determine a new behavior for the squad. SOme squads may not be assigned a behvior upon this iteration.
                    else
                    {
                        Debug.Log("[SQUAD COORDINATOR] Choosing a new behavior for a squad");
                        int i = behaviors.Count - 1;
                        // look at the behavior of highest priority
                        while (i >= 0)
                        {
                            currentBehavior = behaviors[i];
                            if (currentBehavior.IsWarranted(squad))     // make it so that behavior only takes the blackboard reference
                            {
                                squad.GiveBehavior(currentBehavior.Clone());        // Clone the behavior and give it to the squad
                                squad.GetBehavior().Initialize(squad);  // make sure that the behaviour has a reference to the squad
                                Debug.Log("[SQUAD COORDINATOR] Behavior chosen for squad " + currentBehavior.GetName());
                                // squad.GetBehavior().GiveOrders(squad);
                                break;
                            }
                            i--;
                        }
                        if (squad.GetBehavior() == null)
                            Debug.Log("[SQUAD COORDINATOR] No Behavior chosen");    
                    }
                }
            }
            else
            {
                Debug.Log("[SQUAD COORDINATOR] No Squads detected in the Global BlackBoard");
            }
            
        }

        private IEnumerator OrdersDelay(ISquad<string, object> squad)
        {
            yield return _waitForSeconds;
            Debug.Log("[SQUAD COORDINATOR] Waited " + orderDelay + " seconds to Give Orders.");
            if (squad.GetBehavior() != null)
                squad.GetBehavior().GiveOrders(squad);
        }
    }
}
