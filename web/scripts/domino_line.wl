(* Domino Line — a row of thin cuboids toppling in sequence *)

projectDir = DirectoryName[$InputFileName, 3];
PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsModelLink"}]];
Needs["PhysicsModelLink`"];

Print["Generating domino line video..."];

dominoes = Table[
  DynamicBody[{MaterialShading["Copper"],
    Cuboid[{x - 0.08, -0.3, 0}, {x + 0.08, 0.3, 0.8}]}],
  {x, -3, 3, 0.6}
];

(* A sphere to knock over the first domino *)
pusher = DynamicBody[{MaterialShading["Gold"],
  Sphere[{-3.8, 0, 0.4}, 0.35]},
  "Density" -> 5.0, "Velocity" -> {3, 0, 0}];

model = CreatePhysicsModel[{
  PhysicsBoundaryBox[{{-4, -4, 0}, {4, 4, 6}}, "Thickness" -> 1],
  FixedBody[{HatchShading[.6, Gray], Cuboid[{-4, -4, -1}, {4, 4, 0}]}],
  dominoes,
  pusher
},
  "Gravity" -> {0, 0, -9.81},
  "Graphics3DOptions" -> {Background -> Black, Axes -> False,
    Boxed -> False, ViewPoint -> Front, ImageSize -> Large}
];

frames = PhysicsModelEvolve[model, 300, 1.0/60.0];

video = PhysicsModelVideo[frames,
  PlotRange -> 1.03 {{-4, 4}, {-4, 4}, {-0.5, 6}}
];

outDir = FileNameJoin[{DirectoryName[$InputFileName, 2], "videos"}];
outFile = FileNameJoin[{outDir, "domino_line.mp4"}];
Export[outFile, video, "FrameRate" -> 60, ImageSize -> {Automatic, 720}];

Print["Exported: ", outFile];

DestroyPhysicsModel[Last[frames]];
Print["Done."];
