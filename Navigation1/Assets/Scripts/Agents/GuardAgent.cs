using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Scripts.SquadBehaviors.Squads;
using ReGoap.Unity;

namespace Scripts.Agents
{
    public class GuardAgent : ReGoapAgentAdvanced<string, object>
    {
        protected override void Awake()
        {
            base.Awake();
            // set this agent to be referenced by the squad Manager in the GameScene
            SquadManager<string, object>.Instance.AddToSquad(this);
        }
        protected override void Start()
        {
            // set this agent to be referenced by the squad Manager in the GameScene
            // SquadManager<string, object>.Instance.AddToSquad(this);
            base.Start();
        }
    }
}
