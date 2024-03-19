using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Scripts.SquadBehaviors.Core;
using ReGoap.Core;

namespace Scripts.SquadBehaviors.Squads
{
    public class Squad<T, W> : ISquad<T, W>
    {
        protected List<IReGoapAgent<T, W>> agents;
        private IBehavior<T, W> squadBehavior;
        protected float proximity;

        private bool engaged = false;

        public Squad(IReGoapAgent<T, W> agent)
        {
            agents = new List<IReGoapAgent<T, W>>();
            agents.Add(agent);
            squadBehavior = null;
            proximity = 2.0f;
        }
        public virtual ISquad<T, W> Instantiate(IReGoapAgent<T, W> agent)
        {
            Squad<T, W> squad;
            squad = new Squad<T, W>(agent);

            return squad;
        }
        public virtual void AddAgent(IReGoapAgent<T, W> agent)
        {
            agents.Add(agent);
        }
        public virtual void DeceasedAgent(IReGoapAgent<T, W> agent)
        {
            agents.Remove(agent);
        }
        public virtual float SquadSize()
        {
            return agents.Count;
        }

        public virtual List<IReGoapAgent<T, W>> Members()
        {
            return agents;
        }
        public virtual void MergeSquad(ISquad<T, W> other)
        {
            foreach (var newMember in other.Members())
            {
                agents.Add(newMember);
            }
        }
        public virtual void GiveBehavior(IBehavior<T, W> behavior)
        {
            squadBehavior = behavior;

        }
        public virtual IBehavior<T, W> GetBehavior()
        {
            return squadBehavior;
        }
        public virtual void RemoveBehavior()
        {
            squadBehavior = null;
        }
        // Define this is some derived class, as there are specifics to the type of key and value pairs that will be used
        public virtual bool IsInProximity(IReGoapAgent<T, W> agent, IReGoapAgent<T, W> other)
        {
            return true;
        }
        public virtual void Engage()
        {
            engaged = true;
        }
        public virtual bool IsEngaged()
        {
            return engaged;
        }
        public virtual void Disengage()
        {
            engaged = false;
        }
        public virtual List<IReGoapAgent<T,W>> InDanger()
        {
            return agents;
        }
    }
}
