using System.Collections;
using System.Collections.Generic;
using ReGoap.Unity;
using Scripts.SquadBehaviors.Core;
using UnityEngine;

namespace Scripts.Sensors
{
    public class OrdersSensor : ReGoapSensor<string, object>
    {
        // Detect in the agent memory state if there is an "order" key
        // If there is an order key, then check whether if it could be removed, and if so, then remove it
        public override void UpdateSensor()
        {
            if (memory.GetWorldState().TryGetValue("order", out object order))
            {
                IOrder<string, object> newOrder = (IOrder<string, object>) order;
                if (newOrder.OrderDone())
                {
                    memory.GetWorldState().Remove("order");
                }

                if (newOrder.GetName() == "patrol")
                {
                    PatrolPoint interestPoint = (PatrolPoint) newOrder.GetDataValue("patrolPoint");
                    memory.GetWorldState().Set("INVESTIGATING PATROL POINT", interestPoint.ReturnPointName());
                }

                // Debugging, can remove
                /*
                if (newOrder.GetName() == "patrol")
                {
                    PatrolPoint interestPoint = (PatrolPoint) newOrder.GetDataValue("patrolPoint");
                    Debug.Log("Patrolling to Point: " + interestPoint.ReturnPointName());
                }
                */
            }

        }
    }
}
