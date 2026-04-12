#!/usr/bin/env wolframscript

(* High-Level Physics Model API Example *)

projectDir = DirectoryName[$InputFileName, 2];
PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsModelLink"}]];
Needs["PhysicsModelLink`"];

Print["--- Physics Model API Example ---"];

(* Create a scene with a floor, a bouncing sphere, a tumbling cuboid, and a cylinder *)
model = CreatePhysicsModel[{
  (* Floor: a large thin fixed cuboid *)
  FixedBody[Cuboid[{-8, -8, -1}, {8, 8, 0}]],

  (* A sphere dropped from height 5 *)
  DynamicBody[Sphere[{0, 0, 5}, 0.5], "Density" -> 2.0],

  (* A cuboid with a tilted initial orientation *)
  DynamicBody[
    Cuboid[{-0.5, -0.5, 7.5}, {0.5, 0.5, 8.5}],
    "Orientation" -> RotationMatrix[Pi/4, {0, 0, 1}]
  ],

  (* A cylinder off to the side *)
  DynamicBody[Cylinder[{{2, 0, 5.4}, {2, 0, 6.6}}, 0.35]],

  (* A fixed sphere obstacle *)
  FixedBody[Sphere[{-2, 0, 0.8}, 0.8]]
},
  "Gravity" -> {0, 0, -9.81}
];

Print[model];

(* Simulate 4 seconds, collecting frames at 60 FPS *)
dt = 1.0/60.0;
totalFrames = 240;

frames = {};
Do[
  model = PhysicsModelIterate[model, 1, dt];
  AppendTo[frames, model];,
  {totalFrames}
];

Print["Simulation complete. Final state:"];
Print[model];

(* Create animation *)
anim = ListAnimate[
  PhysicsModelPlot[#, PlotRange -> {{-6, 6}, {-6, 6}, {-2, 10}}] & /@ frames,
  AnimationRate -> 60
];

Print[anim];

(* Cleanup *)
DestroyPhysicsModel[model];
Print["Done."];
