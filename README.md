# RTS
Download link: https://godotengine.org/download/windows/

Make sure to download the

Godot Engine - .NET version

along with Visual Studio and the .NET SDK through it.

Possible languages:
Gdscript
C++ 17
C#, up to 11, any that works on .net 6
Any more requires extensions for all of us.

You might have to download the github app so you can push the to the repository.

(Discord server)[https://discord.gg/egXPKJv2ju]

Game:

Right click: make a target location
Space: spawn a unit at the mouse's position
If a unit is spawned after creating a target, the unit will not move.



Aight so I've decided flow field can work, but we gotta work on map creation so that we can implement any pathfinding
Also Constrained Delaunay Triangulation may work for pathfinding instead of flowfield (just has to be baked when loading, I think its godot's default pathfinding system but idk)
