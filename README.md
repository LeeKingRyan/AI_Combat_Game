# Smart Bean Combat

## Objective
The goal is to develop a video game in Unity to which the player combats against Artificial Intelligent agents who're capable of planning and adapting to any changes in a game environment. The AI agents plan to efficiently kill the player while cautious of their own vitality. This project is directly inspired by the 2006 video game F.E.A.R. created by Monolith studios and its marketable feature G.O.A.P. G.O.A.P. or Goal Oriented Action Planning, is a dynamic planning architecture created by Jeff Orkin that permits autonomous decision making for non-playable characters in games. By completing this project, we aim to learn the depths of how G.O.A.P. functions, thus allowing us to optimize it and integrate it with other systems. Most importantly, we aim to allow this projects systems to be transferable and scalable to other future gaming projects, even without the Unity Game Engine.
## How to Run the Game & How to Play

## What interested us to develop the Game
We're simply in love with video games as a hobby, and we're absolutely astonished in how Artifical Intelligence in games appear to exhibit more human or autonomous intelligent behavior through non-payable characters (NPCs) as the Gaming Industry continues to grow. However, AI in games is not becoming more intelligent with every newly released game, and this is more apparent when discourse arises about how AI in some games appear less intelligible than their predecessors from the same franchise. This led us to ask, what actually dictates AI behavior in our favorite games and how do game developers make them so intelligent? We assumed that the best way to learn as self-starting software developers is to develop a game ourselves centered on creating autonomous AI that can dynamically adapt to new circumstances to achieve a main objective.

## What we learned
By developing the game, we learned about working as a team and independently on different systems, then integrating those systems together. Additionally, we learned about optimizing our systems to be scalable in order to develop addittional features to the game, and we learned better organization skills when working with each others' scripts.
Further, we committed ourselves to research in order to plan our development processes, including how to develop features around the G.O.A.P. architecture, and why G.O.A.P. was the optimal planning architecture for our game.
We learned how the intelligence of AI, in games especially, is really smoke and mirrors, just a system of macro and micro rules and conditions that are modeled and designed to fit together.  
## An In-Depth Look of the Game's Code Structure

### Why choose G.O.A.P.?
There are different AI planning systems in the Gaming industry, and the most popular are rule-based AI, finite state machines, behavior trees, and G.O.A.P. Rule-based AI defines how non-playable characters (NPCs) should react in various situations based on a set of predetermined rules and conditions. For example, if an AI combatant spots the player, the condition, then the AI combatant attacks the player, and there can be an additional ruling to tick off, such as if the player is acknowledged as hostile. Finite state machines (FSM) work similarly, in which NPC behavior is deconstructed into distinct states that share transitions with each other. A state represents a specific behavior or action and the transitions are the responses to triggers or fullfilled conditions. Analyzing the prior example in terms of a FSM, the AI combatant can be in an initial state of patrolling, then it transitions out of patrolling under the condition that it sees the player. Consequently, the AI combatant will be then transitioned to the kill state. Additionally, the AI combatant can return to the patrol state if it fulfills the kill state with the player dead, which is another condition that is a one-way connection from the kill state to patrol state.
When we were studying materials on "how to develop simple AI in games" from YouTube tutorials or articles, the most common practice to define AI behaviors for beginners is to use FSMs, but the practice becomes less manageable the more complex the behaviors we wanted to develop. Returning to the example, what if we wanted the AI combatant to kill the player in a more complex manner, for example, what if the AI agent didn't have a gun or was in melee range of the player. The Kill state would then have to be deconstructed further into the states Shoot or Hit, but what if we want the Agent to exhibit behaviors of self preservation when trying to kill the player. Then we would have to develop states in which the Agent would want to take cover to shoot from if the have a gun, or dodge if they are the player's line of sight if armed. More states would have to be developed for every unique situation we developers can think of, and we have to define macro conditions, so the Agent would know what behavior state to prioritize in the FSM.
This development of behavior through the FSM alone becomes overly complex to maintain and keep track of when modeling and testing. The process of using an FSM to define complex NPC behavior has been done in games like Half-Life and No one Lives Forever, but it's still as tedious and difficult to follow. We want to be able to create a model that we can   
### Overview
  
### The ReGoap architecture

### Utlization of a Finitie State Machine

### Controls

### UI Elements

## Issues Encountered

## Future Priority Goals
Further optimize game's performance and clean the code
Upload the game onto itchio.io
## Additional Features to Apply in the Future

Games created on the Unity Engine

Goals:
1.Octopath traveler inspired Camera Angle and Interactive world: 3D environment with 2D sprites.

2.Playable character that can shoot.

Based on Character's visibility, the rest of the screen will be blurry, except for what the character could see.

3.Simple UI.

4.An A.I. similar to F.E.A.R. that attacks the player.

5. Create Sprites

Extra Goals:

1. Add decorations; doll everything up.
2. Breakable objects; debris falling. 
3. Complex UI.

4. Mirrors.

Art Style:
https://www.youtube.com/watch?v=g7xeGpoCScs


Meeting Days (7-9 pm):
Wednesday
Monday


