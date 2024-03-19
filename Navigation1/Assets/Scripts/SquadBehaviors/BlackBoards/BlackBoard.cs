using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Scripts.SquadBehaviors.Core;

namespace Scripts.SquadBehaviors.BlackBoards
{
    public class BlackBoard<T, W> : MonoBehaviour, IBlackboard<T, W>
    {
        private Dictionary<T, W> records;
        public static BlackBoard<T, W> Instance;
        protected virtual void Awake() {
            if (Instance != null)
            {
                Destroy(this);
                var errorString =
                    "[BlackBoard] Trying to instantiate a new blackboard, but there can be only one per scene.";
                Debug.LogError(errorString);
                throw new UnityException(errorString);
            }
            Instance = this;
            records = new Dictionary<T, W>(100);
        }
        public virtual IBlackboard<T, W> GetInstance()
        {
            return Instance;
        }
        public virtual void Clear()
        {
            lock (records)
                records.Clear();
        }

        public virtual W Get(T key)
        {
            lock (records)
            {
                if (!records.ContainsKey(key))
                    return default;
                return records[key];
            }
        }

        public virtual Dictionary<T, W> GetValues()
        {
            lock (records)
                return records;
        }

        public virtual bool HasKey(T key)
        {
            lock (records)
                return records.ContainsKey(key);
        }

        public virtual void Remove(T key)
        {
            records.Remove(key, out _);
        }

        public virtual void Set(T key, W value)
        {
            lock (records)
            {
                records[key] = value;
            }
        }
        public virtual bool TryGetValue(T key, out W value) {
            return records.TryGetValue(key, out value);
        }

        // Extra methods:
        public virtual void ReportPlayerPosition(Vector3 target)
        {

        }
        public virtual Vector3 GetPlayerPosition()
        {
            return new Vector3(0, 0, 0);
        }
        public virtual void ReportPlayerMissing()
        {
            return;
        }
    }   
}
