using ReGoap.Unity;
using UnityEngine;

namespace Scripts.Sensors
{
    // This sensor is responsible for Monitoring Cooldowns for Dodging.
    // Cool downs are dependent on in Game seconds
    public class DodgeSensor : ReGoapSensor<string, object>
    {
        public float dodgeCoolDown = 5f;
        private float lastDodge;
        public override void UpdateSensor()
        {
            var state = memory.GetWorldState();
            if(Time.time - lastDodge < dodgeCoolDown)
                return;
            lastDodge = Time.time;
            state.Set("dodgeReady", true);
        }
        // Use the Dodge mechanic, so the coolDown will reset
        public void Dodge()
        {
            var state = memory.GetWorldState();
            state.Set("dodgeReady", false);
        }

        // Start is called before the first frame update
        void Start()
        {
            var state = memory.GetWorldState();
            state.Set("dodgeReady", false);
        }
    }
}
