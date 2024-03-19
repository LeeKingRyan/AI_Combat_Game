using ReGoap.Core;
using ReGoap.Unity;
using UnityEngine;

namespace Scripts
{
    public class AgentsSpawner : MonoBehaviour
    {
        public int GuardsCount;
        private int spawnedGuards = 0;
        public GameObject GuardPrefab;

        public float DelayBetweenSpawns = 0.7f;
        public int AgentsPerSpawn = 100;
        private float spawnCooldown;

        void Awake()
        {
        }

        void Update()
        {
            if (Time.time >= spawnCooldown && spawnedGuards < GuardsCount)
            {
                spawnCooldown = Time.time + DelayBetweenSpawns;
                for (int i = 0; i < AgentsPerSpawn && spawnedGuards < GuardsCount; i++)
                {
                    var gameObj = Instantiate(GuardPrefab);
                    gameObj.SetActive(true);
                    gameObj.transform.SetParent(transform);

                    // Make Name of Agents different.
                    ReGoapAgent<string, object> agent = gameObj.GetComponentInChildren<ReGoapAgent<string, object>>();
                    agent.Name += spawnedGuards.ToString();

                    spawnedGuards++;
                }
            }
        }
    }
}
