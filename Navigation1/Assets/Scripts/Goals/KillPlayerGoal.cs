using ReGoap.Core;
using ReGoap.Unity;
using Scripts.SquadBehaviors.Core;

namespace Scripts.Goals
{
    public class KillPlayerGoal : ReGoapGoalAdvanced<string, object>
    {
        private IReGoapAgent<string, object> agent;
        private ISquad<string, object> squad;
        protected override void Awake()
        {
            base.Awake();
            goal.Set("playerDead", true);
            agent = GetComponent<IReGoapAgent<string, object>>();
            Priority = 5;
        }

        // This Goal is only possible if the Agent's Squad has encountered the Player

        // It takes a while for the Squad Manager to delegate a squad to the Agent,
        // as a result, this function check will not be possible
        public override bool IsGoalPossible()
        {
            if(agent.GetMemory().GetWorldState().TryGetValue("squad", out var team))
            {
                squad = (ISquad<string, object>) team;
                if(squad.IsEngaged())
                    return true;
                else
                    return false;
            }
            return false;
        }
    }
}
