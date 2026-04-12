(* Bouncing Ball — a single sphere dropped onto a floor *)

projectDir = DirectoryName[$InputFileName, 3];
PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsModelLink"}]];
Needs["PhysicsModelLink`"];

Print["Generating bouncing ball video..."];

model = CreatePhysicsModel[{
  PhysicsBoundaryBox[{{-4, -4, 0}, {4, 4, 6}}, "Thickness" -> 1],
  FixedBody[{HatchShading[.6, Blue], Cuboid[{-4, -4, -1}, {4, 4, 0}]}],
  DynamicBody[{MaterialShading["Gold"], Sphere[{0, 0, 5}, 0.6]}]
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
outFile = FileNameJoin[{outDir, "bouncing_ball.mp4"}];
Export[outFile, video, "FrameRate" -> 60, ImageSize -> {Automatic, 720}];

Print["Exported: ", outFile];

DestroyPhysicsModel[Last[frames]];
Print["Done."];
