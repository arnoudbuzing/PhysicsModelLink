(* Sphere Stack — spheres of different sizes stacked and tumbling *)

projectDir = DirectoryName[$InputFileName, 3];
PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsModelLink"}]];
Needs["PhysicsModelLink`"];

Print["Generating sphere stack video..."];

model = CreatePhysicsModel[{
  PhysicsBoundaryBox[{{-4, -4, 0}, {4, 4, 6}}, "Thickness" -> 1],
  FixedBody[{HatchShading[.6, Gray], Cuboid[{-4, -4, -1}, {4, 4, 0}]}],

  DynamicBody[{MaterialShading["Gold"], Sphere[{0, 0, 1.0}, 1.0]}],
  DynamicBody[{MaterialShading["Copper"], Sphere[{0, 0, 2.8}, 0.7]}],
  DynamicBody[{MaterialShading["Silver"], Sphere[{0, 0, 4.0}, 0.5]}],
  DynamicBody[{MaterialShading["Brass"], Sphere[{0.1, 0.1, 5.0}, 0.35]}],
  DynamicBody[{MaterialShading["Bronze"], Sphere[{-0.05, 0.05, 5.6}, 0.25]}]
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
outFile = FileNameJoin[{outDir, "sphere_stack.mp4"}];
Export[outFile, video, "FrameRate" -> 60, ImageSize -> {Automatic, 720}];

Print["Exported: ", outFile];

DestroyPhysicsModel[Last[frames]];
Print["Done."];
