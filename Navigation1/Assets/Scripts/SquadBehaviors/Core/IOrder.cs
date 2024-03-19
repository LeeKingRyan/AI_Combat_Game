using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.SquadBehaviors.Core
{
    // This interface object will be set into the agent memory with an associated
    // order name that some goal will respond too in a IsValid() check and maybe a GetPriority() check.
    // This interface has the facilities to remove itself as a condition from agent's memory if the order has been
    // satisfied via a method to which the Order Sensor will utilize.

    // order has list of conditions too that need to be satisfied.
    public interface IOrder<T, W>
    {
        // check if the order is complete (basically removable)
        bool OrderDone();
        // If the order is complete, then remove the order from agent's memory
        void RemoveOrder();
        // Get the data of the IOrder for the agent to complete the order
        Dictionary<T, W> GetData();
        // Get the name of the IOrder, be used to choose what goal(s) will respond to the order
        string GetName();
        // Set relevant data
        void SetData(T key, W value);
        // Get relevant data
        W GetDataValue(T key);
    }
}
