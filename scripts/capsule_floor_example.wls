(* Capsule + Floor minimal Rapier example *)

PacletDirectoryLoad[FileNameJoin[{DirectoryName[$InputFileName], "..", "PhysicsModelLink"}]];
Needs["PhysicsModelLink`"];

rowToTransform[row_] := {QuaternionToTransformation[row[[5 ;; 8]]], row[[2 ;; 4]]};
handleToTransform[mat_] := Association @ Map[(#[[1]] -> rowToTransform[#]) &, mat];

Module[{worldId, floorId, capsuleBodyId, dt, steps, frames},
  worldId = RapierWorldCreate[{0.0, 0.0, -9.81}];

  floorId = RapierAddRigidBody[worldId, {0.0, 0.0, -1.0}, "Fixed"];
  RapierAddColliderCuboid[worldId, floorId, {8.0, 8.0, 1.0}, 1.0];

  capsuleBodyId = RapierAddRigidBody[worldId, {0.0, 0.0, 5.0}, "Dynamic"];
  RapierAddColliderCapsule[worldId, capsuleBodyId, {0.6, 0.25}, 1.0];

  dt = 1.0/60.0;
  steps = 240;

  frames = Table[
    RapierWorldStep[worldId, 1, dt];
    RapierGetBodyPositions[worldId],
    {steps}
  ];

  ListAnimate[
    Table[
      Module[{t = handleToTransform[frame]},
        Graphics3D[
          {
            Gray, GeometricTransformation[Cuboid[{-8, -8, -1}, {8, 8, 1}], t[floorId]],
            Darker@Green, GeometricTransformation[CapsuleShape[{{0, 0, -0.6}, {0, 0, 0.6}}, 0.25], t[capsuleBodyId]]
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

  RapierWorldDestroy[worldId]
]
