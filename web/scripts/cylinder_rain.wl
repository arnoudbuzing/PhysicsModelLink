(* Cylinder Rain — many small cylinders raining into a bowl-like enclosure *)

projectDir = DirectoryName[$InputFileName, 3];
PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsModelLink"}]];
Needs["PhysicsModelLink`"];

Print["Generating cylinder rain video..."];

SeedRandom[99];

cylinders = Table[
  DynamicBody[{MaterialShading["Silver"],
    Cylinder[{{x, y, 4 + RandomReal[{0, 2}]},
              {x, y, 4.4 + RandomReal[{0, 2}]}}, 0.15]},
    "Orientation" -> RotationMatrix[RandomReal[{0, Pi}], RandomReal[{-1, 1}, 3]]],
  {x, -2.5, 2.5, 1.0}, {y, -2.5, 2.5, 1.0}
];

model = CreatePhysicsModel[{
  PhysicsBoundaryBox[{{-4, -4, 0}, {4, 4, 6}}, "Thickness" -> 1],
  FixedBody[{HatchShading[.6, Purple], Cuboid[{-4, -4, -1}, {4, 4, 0}]}],

  (* Raised rim walls to create a bowl effect *)
  FixedBody[{HatchShading[.5, Magenta], Cuboid[{-3.5, -3.5, 0}, {-3.3, 3.5, 1.5}]}],
  FixedBody[{HatchShading[.5, Magenta], Cuboid[{3.3, -3.5, 0}, {3.5, 3.5, 1.5}]}],
  FixedBody[{HatchShading[.5, Magenta], Cuboid[{-3.5, -3.5, 0}, {3.5, -3.3, 1.5}]}],
  FixedBody[{HatchShading[.5, Magenta], Cuboid[{-3.5, 3.3, 0}, {3.5, 3.5, 1.5}]}],

  cylinders
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
outFile = FileNameJoin[{outDir, "cylinder_rain.mp4"}];
Export[outFile, video, "FrameRate" -> 60, ImageSize -> {Automatic, 720}];

Print["Exported: ", outFile];

DestroyPhysicsModel[Last[frames]];
Print["Done."];
