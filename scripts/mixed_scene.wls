projectDir = DirectoryName[$InputFileName, 2];

PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsLink"}]];
Needs["PhysicsLink`"];

worldId = RapierWorldCreate[{0.0, 0.0, -9.81}];

(* Fixed objects *)
floorId = RapierAddRigidBody[worldId, {0.0, 0.0, -1.0}, "Fixed"];
RapierAddColliderCuboid[worldId, floorId, {8.0, 8.0, 1.0}, 1.0];

fixedSphereId = RapierAddRigidBody[worldId, {2.0, 0.0, 0.8}, "Fixed"];
RapierAddColliderSphere[worldId, fixedSphereId, 0.8, 1.0];

(* Dynamic objects: cuboid, sphere, cylinder *)
dynCuboidId = RapierAddRigidBody[worldId, {-1.5, 0.0, 4.5}, "Dynamic"];
RapierAddColliderCuboid[worldId, dynCuboidId, {0.5, 0.5, 0.5}, 1.0];

dynSphereId = RapierAddRigidBody[worldId, {0.0, 0.0, 6.0}, "Dynamic"];
RapierAddColliderSphere[worldId, dynSphereId, 0.5, 1.0];

dynCylinderId = RapierAddRigidBody[worldId, {1.5, 0.0, 5.2}, "Dynamic"];
RapierAddColliderCylinder[worldId, dynCylinderId, {0.6, 0.35}, 1.0];

(* Step simulation and capture body poses *)
dt = 1.0/60.0;
steps = 240;

frames = Table[
  RapierWorldStep[worldId, 1, dt];
  RapierGetBodyPositions[worldId],
  {steps}
];

handleToPos[mat_] := Association @ Map[(#[[1]] -> #[[2 ;; 4]]) &, mat];

anim = ListAnimate[
  Table[
    Module[{p = handleToPos[frame]},
      Graphics3D[
        {
          Gray, Translate[Cuboid[{-8, -8, -1}, {8, 8, 1}], p[floorId]],
          Darker@Blue, Translate[Sphere[{0, 0, 0}, 0.8], p[fixedSphereId]],

          Orange, Translate[Cuboid[{-0.5, -0.5, -0.5}, {0.5, 0.5, 0.5}], p[dynCuboidId]],
          Red, Translate[Sphere[{0, 0, 0}, 0.5], p[dynSphereId]],
          Purple, Translate[Cylinder[{{0, 0, -0.6}, {0, 0, 0.6}}, 0.35], p[dynCylinderId]]
        },
        PlotRange -> {{-6, 6}, {-6, 6}, {-2, 8}},
        Axes -> True,
        Boxed -> True
      ]
    ],
    {frame, frames}
  ],
  AnimationRate -> 60
];

Print[anim];

RapierWorldDestroy[worldId];
