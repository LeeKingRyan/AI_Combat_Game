using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ReGoap.Core;

namespace Scripts.SquadBehaviors.Core
{
    public interface ISquadManager<T, W>
    {
        // Check whether agents are within proximity
        bool IsInProximity(IReGoapAgent<T, W> agent, IReGoapAgent<T, W> other);
        // Combine squads whose sums are less than or equal max squad size while in proximity
        void CombineSquads();
        // Add an agent to the squad
        void AddToSquad(IReGoapAgent<T, W> agent);
        // check what agent are still alive
        void IsAlive();

        // Update relevant information concerning avaliable squads to the blackboard
        void UpdateBlackBoard();

    }
}
