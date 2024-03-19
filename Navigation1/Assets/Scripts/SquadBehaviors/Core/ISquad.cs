using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ReGoap.Core;
using Scripts.SquadBehaviors.Core;

namespace Scripts.SquadBehaviors.Core
{
    public interface ISquad<T, W>
    {
        // Squad();
        // Create a new instance of ISquad<T, W>
        ISquad<T, W> Instantiate(IReGoapAgent<T, W> agent);
        void AddAgent(IReGoapAgent<T, W> agent);
        void DeceasedAgent(IReGoapAgent<T, W> agent);
        float SquadSize();
        List<IReGoapAgent<T, W>> Members();
        void MergeSquad(ISquad<T, W> other);
        void GiveBehavior(IBehavior<T, W> behavior);
        IBehavior<T, W> GetBehavior();
        void RemoveBehavior();

        // Other Helpful methods:

        // Check what two members are in proximity
        bool IsInProximity(IReGoapAgent<T, W> agent, IReGoapAgent<T, W> other);
        // Called by Agent's Player Sensory if the Player is detected within regular FOV
        void Engage();
        // return whether or not a Squad is engaged, meaning that the Squad had seen the player and whereAbouts are known
        bool IsEngaged();

        void Disengage();
        // Return a list of members in danger
        List<IReGoapAgent<T,W>> InDanger();
    }
}
