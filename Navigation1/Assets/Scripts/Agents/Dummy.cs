using System.Collections;
using System.Collections.Generic;
using ReGoap.Unity;
using Scripts.SquadBehaviors.Squads;
using UnityEngine;

namespace Scripts.Agents
{
    public class Dummy : ReGoapAgentAdvanced<string, object>
    {
        protected override void Awake()
        {
            base.Awake();
        }
        protected override void Start()
        {
            // set this agent to be referenced by the squad Manager in the GameScene


            SquadManager<string, object>.Instance.AddToSquad(this);


            Debug.Log("Added Agent to the Squad Manager instance in GameScene");
            // Claculates a New Goal if calculate new goal upon start is ticked
            base.Start();
        }
        protected override bool CalculateNewGoal(bool forceStart = false)
        {
            if (IsPlanning)
                return false;
            if (!forceStart && (Time.time - lastCalculationTime <= CalculationDelay))
                return false;
            lastCalculationTime = Time.time;

            interruptOnNextTransition = false;
            UpdatePossibleGoals();
            //var watch = System.Diagnostics.Stopwatch.StartNew();
            startedPlanning = true;
            Debug.Log("Sending to Planner Manager a Job");

            // Only Pass a blacklisted goal if it is found in the blacklist dictionary and we ticked BlackListGoalOnFailure
            currentReGoapPlanWorker = ReGoapPlannerManager<string, object>.Instance.Plan(this,
                                                                                         (BlackListGoalOnFailure && currentGoal != null && goalBlacklist.ContainsKey(currentGoal)) ? currentGoal : null,
                                                                                         currentGoal != null ? currentGoal.GetPlan() : null,
                                                                                         OnDonePlanning);

            return true;
        }
    }
}
