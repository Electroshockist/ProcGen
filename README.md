# What is this?
This is a Work-in-Progress procedural 3D voxel terrain generation project I've been working on in my spare time.

This project is inspired by Minecraft and Cube World.
# How is it made?
This project is made using the Godot game engine.
# What can it do?
Right now, it generates a small area using simplex noise.
The area is composed of multiple chunks. Each chunk is composed of a grid of tiles.
The dimensions of the chunk grid and the chunk's tile grid can be determined in the editor.
The
A custom mesh is generated for every chunk to improve performance.

There are a couple of temporary objects in the scene for reference that will be removed when the project is complete.
# What are the plans for this project?
The plan is to implement a couple more features and maybe turn it into a small engine for a game.
## Planned features:
- Greedy meshing
- Mesh collisions
- Occlusion Culling
