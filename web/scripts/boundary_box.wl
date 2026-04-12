(* Boundary Box — raining cones inside a transparent enclosed box *)

projectDir = DirectoryName[$InputFileName, 3];
PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsModelLink"}]];
Needs["PhysicsModelLink`"];

Print["Generating boundary box video..."];

SeedRandom[42];

model = CreatePhysicsModel[{
  PhysicsBoundaryBox[{{-4, -4, 0}, {4, 4, 6}}, "Thickness" -> 1],
  FixedBody[{HatchShading[.6, Blue], Cuboid[{-4, -4, -1}, {4, 4, 0}]}],
  FixedBody[{HatchShading[.6, Orange],
    Cylinder[{{-2, -2, 0.5}, {2, 2, 0.5}}, 1.0]}],
  Table[
    DynamicBody[{MaterialShading["Copper"],
      Cone[{{i, j, 4}, {i + RandomReal[{0, 0.1}],
        j + RandomReal[{0, 0.1}], 5}}, 0.25]}],
    {i, -3, 3, 1}, {j, -3, 3, 1}]
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
outFile = FileNameJoin[{outDir, "boundary_box.mp4"}];
Export[outFile, video, "FrameRate" -> 60, ImageSize -> {Automatic, 720}];

Print["Exported: ", outFile];

DestroyPhysicsModel[Last[frames]];
Print["Done."];
