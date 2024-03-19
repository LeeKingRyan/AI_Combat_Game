using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Scripts.SquadBehaviors.Core;

namespace Scripts.SquadBehaviors.Orders
{
    public class Order<T, W> : IOrder<T, W>
    {
        public string Name;
        protected Dictionary<T, W> orderData;

        // Override
        public virtual bool OrderDone()
        {
            return false;
        }
        // Override
        public virtual void RemoveOrder()
        {
            return;
        }
    
        public virtual Dictionary<T, W> GetData()
        {
            return orderData;
        }

        public virtual string GetName()
        {
            return Name;
        }

        public virtual void SetData(T key, W value)
        {
            lock (orderData)
            {
                orderData[key] = value;
            }
        }
        public virtual W GetDataValue(T key)
        {
            lock (orderData)
            {
                if (!orderData.ContainsKey(key))
                    return default(W);
                return orderData[key];
            }
        }
    }   
}
