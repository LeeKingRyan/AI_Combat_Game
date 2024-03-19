using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ReGoap.Core;
using ReGoap.Unity;
using Scripts.SquadBehaviors.Core;
using Scripts.SquadBehaviors.BlackBoards;

namespace Scripts.SquadBehaviors
{
    // The squad Behavior System (SBS)
    public class SquadBehaviorSystem<T, W> : MonoBehaviour
    {
        public static SquadBehaviorSystem<T, W> Instance;

        protected List<IBehavior<T, W>> behaviors; // list of behavior components.
        protected IBehavior<T, W> currentBehavior; // enumerator to keep track of a valid behavior for some squad.

        //protected BlackBoard<T, W> blackboard;
        protected virtual void Awake()
        {
            if (Instance != null)
            {
                Destroy(this);
                var errorString =
                    "[SquadBehaviorSystem] Trying to instantiate a new SBS but there can be only one per scene.";
                Debug.LogError(errorString);
                throw new UnityException(errorString);
            }
            Instance = this;
        }

        void Start()
        {
            RefreshBehaviorsSet();
            // sort the list of behaviors based on priority. Behaviors of highest priority are at the end of the list.
            behaviors.Sort((x, y) => x.GetPriority().CompareTo(y.GetPriority()));
        }
        // Get list of behaviors attached as components to the same Game Object
        public virtual void RefreshBehaviorsSet()
        {
            // If Behvaiours are not derived from the MonoBehaviour class, instead create new behaviors that we want to add
            // to the list of behaviours we want to consider. For example override this function in a deriving class like Squad Coordination.
            return;
        }
    }
}
