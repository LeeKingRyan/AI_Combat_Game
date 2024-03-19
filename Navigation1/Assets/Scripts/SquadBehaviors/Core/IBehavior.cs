using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Scripts.SquadBehaviors;
using Scripts.SquadBehaviors.Core;

using Unity.Jobs;

namespace Scripts.SquadBehaviors.Core
{
    public interface IBehavior<T, W>
    {
        string GetName();
        void Initialize(ISquad<T, W> squad);
        float GetPriority();
        // check if the squad behavior is warranted
        bool IsWarranted(ISquad<T, W> squad);
        // Call IsFailed and IsFinished() inside the SBS Update() to check whether or not to assign a new Behvaior to the squad
        bool IsFinished();
        bool IsFailed(); // IsFailed references some Threshold time limit to complete a behavior.
        // Given a squad, give orders to each squad member. Orders will be continued to be given until IsFinished returns true
        void GiveOrders(ISquad<T, W> squad);

        void RemoveOrders();

        IBehavior<T, W> Clone();
    }
}
