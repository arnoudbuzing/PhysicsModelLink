# PhysicsLink

A Wolfram Language paclet providing high-performance 3D physics simulation bindings to the Rust [rapier3d](https://rapier.rs/) physics engine via `wolfram-library-link`.

## Overview 

This paclet acts as a wrapper around the Rapier physics engine. To bridge the gap between Mathematica's functional nature and Rapier's stateful dependencies, it implements an internal Handle-Based Global memory map inside the dynamically linked Rust library.

The simulation world is persistent in memory, isolated securely per session. You iteratively create a world, populate it dynamically with bodies and colliders, step the physics pipeline, and retrieve flat matrix transformation arrays back instantly over WSTP for zero-latency 3D visual plotting.

## Building the Project

Ensure you have Rust/Cargo installed, as well as the Wolfram Engine or Mathematica.

1. Navigate to the project root.
2. Run the build script to compile the shared library and automatically route it to your OS-specific `$SystemID` paclet directory:
   ```bash
   ./scripts/build.wls
   ```

## Usage Example (Cuboids + Spheres + Cylinders + Cones + Capsules)

Load the paclet from a local checkout:

```wl
PacletDirectoryLoad[FileNameJoin[{NotebookDirectory[], "PhysicsLink"}]];
Needs["PhysicsLink`"];
```

Create a world with gravity:

```wl
worldId = RapierWorldCreate[{0.0, 0.0, -9.81}];
```

Add fixed objects (a floor cuboid and a fixed sphere obstacle):

```wl
floorId = RapierAddRigidBody[worldId, {0.0, 0.0, -1.0}, "Fixed"];
RapierAddColliderCuboid[worldId, floorId, {8.0, 8.0, 1.0}, 1.0];

fixedSphereId = RapierAddRigidBody[worldId, {2.0, 0.0, 0.8}, "Fixed"];
RapierAddColliderSphere[worldId, fixedSphereId, 0.8, 1.0];
```

Add dynamic objects (a cuboid, a sphere, a cylinder, a cone, and a capsule):

```wl
dynCuboidId = RapierAddRigidBody[worldId, {-1.5, 0.0, 4.5}, "Dynamic"];
RapierAddColliderCuboid[worldId, dynCuboidId, {0.5, 0.5, 0.5}, 1.0];

dynSphereId = RapierAddRigidBody[worldId, {0.0, 0.0, 6.0}, "Dynamic"];
RapierAddColliderSphere[worldId, dynSphereId, 0.5, 1.0];

dynCylinderId = RapierAddRigidBody[worldId, {1.5, 0.0, 5.2}, "Dynamic"];
RapierAddColliderCylinder[worldId, dynCylinderId, {0.6, 0.35}, 1.0];

dynConeId = RapierAddRigidBody[worldId, {-0.8, 1.2, 5.8}, "Dynamic"];
RapierAddColliderCone[worldId, dynConeId, {0.5, 0.3}, 1.0];

dynCapsuleId = RapierAddRigidBody[worldId, {0.8, -1.2, 6.3}, "Dynamic"];
RapierAddColliderCapsule[worldId, dynCapsuleId, {0.6, 0.25}, 1.0];
```

Step the simulation and capture body transforms:

```wl
dt = 1.0/60.0;
steps = 240;

frames = Table[
  RapierWorldStep[worldId, 1, dt];
  RapierGetBodyPositions[worldId],
  {steps}
];
```

Visualize using full rigid transforms (translation + rotation) with `GeometricTransformation`:

```wl
rowToTransform[row_] := {QuaternionToTransformation[row[[5 ;; 8]]], row[[2 ;; 4]]};

handleToTransform[mat_] := Association @ Map[(#[[1]] -> rowToTransform[#]) &, mat];

ListAnimate[
  Table[
    Module[{t = handleToTransform[frame]},
      Graphics3D[
        {
          Gray, GeometricTransformation[Cuboid[{-8, -8, -1}, {8, 8, 1}], t[floorId]],
          Darker@Blue, GeometricTransformation[Sphere[{0, 0, 0}, 0.8], t[fixedSphereId]],

          Orange, GeometricTransformation[Cuboid[{-0.5, -0.5, -0.5}, {0.5, 0.5, 0.5}], t[dynCuboidId]],
          Red, GeometricTransformation[Sphere[{0, 0, 0}, 0.5], t[dynSphereId]],
          Purple, GeometricTransformation[Cylinder[{{0, 0, -0.6}, {0, 0, 0.6}}, 0.35], t[dynCylinderId]],

          Brown, GeometricTransformation[Cone[{{0, 0, -0.5}, {0, 0, 0.5}}, 0.3], t[dynConeId]],
          Darker@Green, GeometricTransformation[CapsuleShape[{{0, 0, -0.6}, {0, 0, 0.6}}, 0.25], t[dynCapsuleId]]
        },
        PlotRange -> {{-6, 6}, {-6, 6}, {-2, 8}},
        Axes -> True,
        Boxed -> True
      ]
    ],
    {frame, frames}
  ],
  AnimationRate -> 60
]
```

Cleanup:

```wl
RapierWorldDestroy[worldId]
```
