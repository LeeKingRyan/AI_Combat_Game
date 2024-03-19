using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts {
    public class PatrolPoint : MonoBehaviour
    {
        public string Name;
        public PatrolPoint[] adjacent; // adjacent patrol points
        public bool investigated = false;

        public string ReturnPointName()
        {
            return Name;
        }

        public void Investigate()
        {
            investigated = true;
        }
        public bool IsInvestigated()
        {
            return investigated;
        }
        public  PatrolPoint[] GetAdjacentPoints()
        {
            return adjacent;
        }
        public void UpdatePatrolPoint()
        {
            investigated = false;
        }
    }
}
