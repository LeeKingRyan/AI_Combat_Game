using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using UnityEngine;

namespace Scripts.Sensors
{
    public class HealthSensor : ReGoapSensor<string, object>
    {
        public float health = 100;

        public override void Init(IReGoapMemory<string, object> memory)
        {
            base.Init(memory);
            var state = memory.GetWorldState();
            state.Set("alive", true);

        }

        public override void UpdateSensor()
        {
            var state = memory.GetWorldState();
            if (health <= 0)
            {
                state.Set("alive", false);
            }
        }

        // Add a Function that takes a float variable and subtracts current health. This will be called outside
        // by the bullet upon collision to parent game object Agent.
        public void Damage(float damage)
        {
            health -= damage;            
        } 
    }
}
