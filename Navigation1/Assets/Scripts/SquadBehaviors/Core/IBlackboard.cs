using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.SquadBehaviors.Core
{
    public interface IBlackboard<T, W>
    {
        IBlackboard<T, W> GetInstance();
        W Get(T key); // Get a value given some key
        void Set(T key, W value); // Set a key-value pair
        void Remove(T key);
        Dictionary<T, W> GetValues();
        bool HasKey(T key);
        void Clear();
        bool TryGetValue(T key, out W value);

    }
}
