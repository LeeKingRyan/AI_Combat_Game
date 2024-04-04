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
We also learned the importance of documentation when developing our game.
The artifical intelligence never learned on its own, we defined its goals and actions, hence why its still an artificial intelligence.

# Development Journey

## An In-Depth Look of the Game's Code Structure

### What is Goal Oriented Action Planning - G.O.A.P.?


### Why choose G.O.A.P.?
There are different AI planning systems in the Gaming industry, and the most popular are rule-based AI, finite state machines, behavior trees, and G.O.A.P. Rule-based AI defines how non-playable characters (NPCs) should react in various situations based on a set of predetermined rules and conditions. For example, if an AI combatant spots the player, the condition, then the AI combatant attacks the player, and there can be an additional ruling to tick off, such as if the player is acknowledged as hostile. Finite state machines (FSM) work similarly, in which NPC behavior is deconstructed into distinct states that share transitions with each other. A state represents a specific behavior or action and the transitions are the responses to triggers or fullfilled conditions. Analyzing the prior example in terms of a FSM, the AI combatant can be in an initial state of patrolling, then it transitions out of patrolling under the condition that it sees the player. Consequently, the AI combatant will be then transitioned to the kill state. Additionally, the AI combatant can return to the patrol state if it fulfills the kill state with the player dead, which is another condition that is a one-way connection from the kill state to patrol state.
When we were studying materials on "how to develop simple AI in games" from YouTube tutorials or articles, the most common practice to define AI behaviors for beginners is to use FSMs, but the practice becomes less manageable the more complex the behaviors we wanted to develop. Returning to the example, what if we wanted the AI combatant to kill the player in a more complex manner, for example, what if the AI agent didn't have a gun or was in melee range of the player. The Kill state would then have to be deconstructed further into the states Shoot or Hit, but what if we want the Agent to exhibit behaviors of self preservation when trying to kill the player. Then we would have to develop states in which the Agent would want to take cover to shoot from if the have a gun, or dodge if they are the player's line of sight if armed. More states would have to be developed for every unique situation we developers can think of, and we have to define macro conditions, so the Agent would know what behavior state to prioritize in the FSM.
This development of behavior through the FSM alone becomes overly complex to maintain and keep track of when modeling and testing. The process of using an FSM to define complex NPC behavior has been done in games like Half-Life and No one Lives Forever, but it's still as tedious and difficult to follow. We want to be able to create a behavior model that even people with non-technical skills can understand, and that we could understand even if the project hasn't been revisited in months or years.
Another solution for defining complex behaviors is the utilization of behavior trees which are hiearchical structures of nodes representing specific actions, conditions, or states. The nodes are interconnected to form a treethat outlines the possible behaviors of an Agent. This model allows for decision making, thus permitting the Agent to adapt to changing conditions dynamically. Behavior trees are especially popular in gaming franchises like Halo.
Still, Behavior trees can become overly complex to maintain and to design. What we want is for an artificial intelligence to adapt on its own accord, to assess its situation and then act accordingly. In other words, rather than design every pipeline of the different combinations of behaviours and scenarios the Agent may find itself in, the Agent can authentically adapt based on preconceived knowledge and logic. If we were to define every scenario and behavior, but then came up with ways how the game world could change, then we would have to redesign the tree to accomodate for such changes, including any redundant changes, because some scenarios are very similar to others with just a few different arrangments of behaviors or exclude some behaviors, sometimes one.
The people who developed F.E.A.R. also came across this dilemna, and thus proceeded to develop G.O.A.P.

### Overview
  
### The ReGoap Architecture by Liciano Ferraro
  The ReGoap architecture is one of many implementations of G.O.A.P. created by Liciano Ferraro, and this is the implementation our team used for the project. Originally, we planned to build our own G.O.A.P. architecture from scratch by researching and referencing how other developers built their implementations. ReGoap is one of the first GOAP tools we analyzed, and because we were impressed by the implementation's readability, we decided to just use it. We first heard of ReGoap from a Bachelor's thesis created by Ferran Martín Vilà titled "Unity GOAP tool". Ferran's goal was to develop a competitive AI generation tool that supports the GOAP architecture around 2019, and what inspired his project was the limited use of UI elements, including visual editors and debugging tools, in other unofficial Unity GOAP tools, such as ReGoap. Ferraro aimed to build his tool without engine dependencies, so it can be easily integrated to any game engine, and this is also true of ReGoap. Ferraro endoresed ReGoap as a solid GOAP Library and has referenced Ferraro's 10 years of developer experience, while also going over a brief overview of Ferraro's implementation of the Core principles of GOAP.
  Ferran also mentions Peter Klooster whose architecture, simply called GOAP, is the most well documented and up-to-date GOAP tool, so for beginner developers who wish to program AI behavior with GOAP, I recommend learning, adapting, and, or utilize Klooster's tool. My team did not however used Klooster's work, because we studied the code of the ReGoap tool first and understood it, so we decided to utilize and optimize ReGoap for our project rather than build from scratch. Additonally at the time of starting the project, there was no other additional Youtube tutorials on how to use it, unlike today, which were created by Youtuber LlamAcademy. Meanwhile, there isn't any current online video tutorials about ReGoap. Though, Ferraro has provided necessary documentation on how to create AI agents and their behaviors in ReGoap, there isn't much thorough documentation about what goes on under the hood. Also, ReGoap hasn't been updated been updated in 3 years since today of 4/4/2024, so of the two I recommend Klooster's implementation.
  Fortunately, both ReGoap and Klooster's GOAP both support multithreading in their architectures, and ReGoap is very cleanly coded and organized that any experienced programmers can understood the workings of ReGoap if they're willing to invest the time to do so. Because our team invested time understanding ReGoap, it was best to use it since the process of debugging would be easier. For the rest of this section, I will explain the workings of ReGoap along with code snippets, and this in depth code analysis documentation will also be provdied as a pdf in the documents folder of the repository titled "Code Analysis of ReGoap". I will also explain the example game scene provided with the ReGoap Unity package in the documentation and a section about the small changes our team made when using it for the project and what considerations we had to keep in mind during development.
  If anyone would like a more complex example of a game scene utilizing the ReGoap tool, then I (Ryan Zeng) will also go over the code analysis of this project in relation to ReGoap in the section "Using ReGoap". We are very thankful and appreciative of the efforts of developers like Ferraro, Klooster, and Ferran for sharing their knowledge and works with the public.
  Now let's go over ReGoap's implementations of the Core Principles of Goal Oriented Action Planning
(Pending... Writing and compiling things from multiple word docs).

### Utilization of ReGoap

### Utlization of a Finitie State Machine

### Nav Mesh Navigation

### Controls

### UI Elements

## Issues Encountered

### Why we chose the unity Engine
Our team chose the Unity Engine, because of the plenty of resources available online, especially on YouTube, on how the engine and its tools can be used and the Unity commnuity is very thriving and healthy for beginner developers. Also, we're working on a budget of zero, so having no fees to publish a game with the Unity Engine is a huge plus.


## Future Priority Goals
Further optimize game's performance and clean the code
Upload the game onto itchio.io
## Additional Features to Apply in the Future

## What's next
This project's results serves more as a demo of our teams skills. We will be transfering the game's systems into another Game Project, a parody of Pac-Man. We look forward to development.

## Work Cited APA Format:
AI & Games. (2020, May 6). Building the AI of F.E.A.R. with Goal Oriented Action Planning | AI 101. YouTube. https://www.youtube.com/watch?v=PaOLBOuyswI
Ferran, Martín Vilà. (2019). Unity GOAP Tool. https://github.com/ferranmartinvila/Unity-GOAP_S
Liciano Ferraro, https://github.com/luxkun/ReGoap?tab=readme-ov-file#how-to-use-regoap-in-unity3d
Peter Klooster, https://github.com/crashkonijn/GOAP
