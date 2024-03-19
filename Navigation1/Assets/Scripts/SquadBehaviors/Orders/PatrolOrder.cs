using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.SquadBehaviors.Orders
{
    public class PatrolOrder : Order<string, object>
    {

        public PatrolOrder()
        {
            Name = "patrol";
            orderData = new Dictionary<string, object>();
        }

        // This order is done if the PatrolPoint of interest is investigated,
        // either by the agent following this order, or another agent doing the same
        // order
        public override bool OrderDone()
        {
            // Get from the orderData the PatrolPoint of interest
            PatrolPoint patrolPoint = (PatrolPoint) GetDataValue("patrolPoint");
            if (patrolPoint.IsInvestigated())
            {
                return true;
            }
            return base.OrderDone();
        }

        // Simply remove the order from agent's memory. [*] But can't the Order Sensor do this itself?
        // This doesn't do anything rn. Pass some IReGoapAgent<string, object> and call to remove the order
        // from it.
        public override void RemoveOrder()
        {
            base.RemoveOrder();
        }
    }
}
