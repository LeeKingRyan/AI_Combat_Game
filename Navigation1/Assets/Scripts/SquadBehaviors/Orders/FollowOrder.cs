using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.SquadBehaviors.Orders
{
    public class FollowOrder : Order<string, object>
    {
        public FollowOrder()
        {
            Name = "follow";  
            orderData = new Dictionary<string, object>();
        }
        // This function just returns false, so the agent follows another agent as long
        // as possible, until a new order is set
        public override bool OrderDone()
        {
            return base.OrderDone();
        }
        // Never remove this order, instead it will be replaced by another order, or removed if the behavior fails.
        // Remove Order can just be done by the OrderSensor, all that's necessary is the check.
        public override void RemoveOrder()
        {
            base.RemoveOrder();
        }
    }
}
