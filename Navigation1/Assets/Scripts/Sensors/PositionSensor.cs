using System.Collections;
using System.Collections.Generic;
using ReGoap.Core;
using ReGoap.Unity;
using UnityEngine;

namespace Scripts.Sensors
{
    public class PositionSensor : ReGoapSensor<string, object>
    {
        public GameObject parent;
        public override void Init(IReGoapMemory<string, object> memory)
        {
            base.Init(memory);
            var state = memory.GetWorldState();
            state.Set("startPosition", parent.transform.position);
            state.Set("agentTransform", parent.transform);          // in case if following doesn't work
        }

        public override void UpdateSensor()
        {
            var state = memory.GetWorldState();
            state.Set("startPosition", parent.transform.position);
        }
    }
}
