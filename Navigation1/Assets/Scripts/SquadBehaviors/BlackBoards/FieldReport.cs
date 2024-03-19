using System.Collections;
using System.Collections.Generic;
using Scripts.SquadBehaviors.Core;
using UnityEngine;
namespace Scripts.SquadBehaviors.BlackBoards
{
    public class FieldReport : BlackBoard<string, object>
    {
        private Vector3 lastPlayerLocation; // The last known player's position

        // Agents will add data to these list and queues from their player sensors
        private List<Vector3> playerLocations;      // reported sightings of player
        private List<ISquad<string, object>> squadsEngaged; // engaged squads

        public float updateReportDelay = 0.5f; // squad management delay
        protected float lastUpdatedReportTime;

        protected override void Awake()
        {
            base.Awake();
            // Instance = this;

            lastPlayerLocation = new Vector3(0, 0, 0);
            playerLocations = new List<Vector3>();

            squadsEngaged = new List<ISquad<string, object>>();

            Instance.Set("playerDetected", false);

            // Filtered out the other data by blackboard to get theses values
            Instance.Set("lastKnownPlayerLocation", lastPlayerLocation);

            // Squads that are engaged with the player
            Instance.Set("squadsEngaged", squadsEngaged);
        }
        void Update()
        {
            // if we exceed the updateReportDelay, then proceed to update the field report
            if (Time.time - lastUpdatedReportTime <= updateReportDelay)
                return;
            lastUpdatedReportTime = Time.time;
            UpdateFieldReport();
        }
        // Update the last known player location and the list of squads engaged with the player
        public void UpdateFieldReport()
        {
            // Player is visible, so update the the Player's last knonw location
            // [lastPlayerLocation]
            if (playerLocations.Count > 0)
            {
                lastPlayerLocation = playerLocations[playerLocations.Count - 1];
                Instance.Set("playerDetected", true);
                Instance.Set("lastKnownPlayerLocation", lastPlayerLocation);
                playerLocations.Clear();
                Instance.Set("reportedLocations", playerLocations);
            }
            // Player is no longer visible, so player is no longer detected by the standrd FOV nor the
            // alternate extended FOV upon losing sight. The Player is only confirmed missing after searching
            // the last player location.
            else
            {
                Instance.Set("playerDetected", false);
            }
            
            // Squads that had seen the player, with at least one member having seen the player and
            // reported it, are considered engaged, until the last known Player location is reported
            // as Vector(0, 0, 0). Also, rather than checking every update, iterating through the
            // list of squads and their members to see if one currently sees the player. Why not
            // do so in the Player Sensor in which if an Agent sees the Player, then they say their
            // squad is engaged through the sensor, rather than waiting for a resulting plan to report to
            // finish.

            // This way, squads that have yet to encounter the player are not written as engaged with player.
            if (lastPlayerLocation.magnitude != 0 && Instance.TryGetValue("squads", out var squads))
            {
                foreach(var squad in (List<ISquad<string, object>>) squads)
                {
                    if (squad.IsEngaged())
                        squadsEngaged.Add(squad);
                }
                Instance.Set("squadsEngaged", squadsEngaged);
            }
            // No Squads are engaged and the where abouts of Player are unknown, so disengage all available squads.
            // last known player location would have been resetted, due to ReportPlayerMissing() function.
            else if (Instance.TryGetValue("squads", out var teams))
            {
                Instance.Remove("squadsEngaged");
                foreach(var squad in (List<ISquad<string, object>>) teams)
                {
                    squad.Disengage();
                }
            }
        }

        public override void ReportPlayerPosition(Vector3 target)
        {   
            playerLocations.Add(target);
        }
        public override Vector3 GetPlayerPosition()
        {
            return lastPlayerLocation;
        }
        public override void ReportPlayerMissing()
        {
            lastPlayerLocation = new Vector3(0, 0, 0);
        }
    }
}
