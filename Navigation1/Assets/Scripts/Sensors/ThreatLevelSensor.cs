using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using UnityEngine;

namespace Scripts.Sensors
{
    public class ThreatLevelSensor : ReGoapSensor<string, object>
    {
        public float threatLevel = 0.0f;   // initial assessed threat level regarding the player

        public override void Init(IReGoapMemory<string, object> memory)
        {
            base.Init(memory);
            var state = memory.GetWorldState();
            state.Set("threatLevel", threatLevel);

        }

        public override void UpdateSensor()
        {
            
        }
    }
}
