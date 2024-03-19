using System.Collections;
using System.Collections.Generic;
using Scripts.SquadBehaviors.Core;
using UnityEngine;

namespace Scripts.SquadBehaviors.Behaviors
{
    public class Behavior<T, W> : IBehavior<T, W>
    {
        public string Name;
        public float priority = 1;
        private ISquad<T, W> squad;

        public virtual void Initialize(ISquad<T, W> squad)
        {
            this.squad = squad;
        }

        public ISquad<T, W> GetSquad()
        {
            return squad;
        }

        public virtual IBehavior<T, W> Clone()
        {
            return this;
        }

        // override this to get a different name
        public virtual string GetName()
        {
            return Name;
        }

        // Override this to return a different priority
        public virtual float GetPriority()
        {
            return priority;
        }

        public virtual void GiveOrders(ISquad<T, W> squad)
        {
            return;
        }

        public virtual bool IsFailed()
        {
            return false;
        }

        public virtual bool IsFinished()
        {
            return true;
        }

        // override this function as it requires specific types of Key and value for IReGoapAgent<T, W>
        public virtual void RemoveOrders()
        {
        }

        public virtual bool IsWarranted(ISquad<T, W> squad)
        {
            return true;
        }
    }
}
