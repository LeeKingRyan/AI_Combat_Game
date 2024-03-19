using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Scripts.SquadBehaviors.Squads;
using ReGoap.Core;

namespace Scripts.SquadBehaviors.Squads
{
    public class SoldierSquad : Squad<string, object> 
    {
        public SoldierSquad(IReGoapAgent<string, object> agent) : base(agent)
        {

        }

        // SO far none of these other methods are used by other classes. Specifically, they should be used by squad behavior derived
        // classes to decide what orders to give. These may not even be necessary.

        // Two agents within proximity return true. Not really used by any other classes, can proabbaly get rid of this.
        public override bool IsInProximity(IReGoapAgent<string, object> agent, IReGoapAgent<string, object> other)
        {
            return Vector3.Distance((Vector3) agent.GetMemory().GetWorldState().Get("startPosition"),
                                    (Vector3) other.GetMemory().GetWorldState().Get("startPosition")) <= proximity;
        }
        
        // Players in danger are added to the list of agents returned. The calculation for whether an agent is in danger is
        // decided by agents' THreat Level sensors.
        public override List<IReGoapAgent<string, object>> InDanger()
        {
            List<IReGoapAgent<string, object>> endangeredMembers = new List<IReGoapAgent<string, object>>();
            foreach(var member in Members())
            {
                if((bool) member.GetMemory().GetWorldState().Get("inDanger"))
                    endangeredMembers.Add(member);
            }
            return endangeredMembers;
        }
    }
}
