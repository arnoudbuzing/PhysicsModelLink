(* Bouncy Spheres — spheres with different restitution values *)

projectDir = DirectoryName[$InputFileName, 3];
PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsModelLink"}]];
Needs["PhysicsModelLink`"];

Print["Generating bouncy spheres video..."];

model = CreatePhysicsModel[{
  PhysicsBoundaryBox[{{-4, -4, 0}, {4, 4, 6}}, "Thickness" -> 1],
  FixedBody[{HatchShading[.6, Gray], Cuboid[{-4, -4, -1}, {4, 4, 0}]},
    "Restitution" -> 1.0, "Friction" -> 0.3],

  (* High bounce — restitution near 1.0 *)
  DynamicBody[{MaterialShading["Gold"], Sphere[{-2.5, 0, 5.0}, 0.5]},
    "Restitution" -> 0.95, "Friction" -> 0.2],

  (* Medium bounce *)
  DynamicBody[{MaterialShading["Copper"], Sphere[{-0.8, 0, 5.0}, 0.5]},
    "Restitution" -> 0.6, "Friction" -> 0.4],

  (* Low bounce — almost no restitution *)
  DynamicBody[{MaterialShading["Silver"], Sphere[{0.8, 0, 5.0}, 0.5]},
    "Restitution" -> 0.2, "Friction" -> 0.6],

  (* Zero bounce — dead stop *)
  DynamicBody[{MaterialShading["Brass"], Sphere[{2.5, 0, 5.0}, 0.5]},
    "Restitution" -> 0.0, "Friction" -> 1.0]
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
outFile = FileNameJoin[{outDir, "bouncy_spheres.mp4"}];
Export[outFile, video, "FrameRate" -> 60, ImageSize -> {Automatic, 720}];

Print["Exported: ", outFile];

DestroyPhysicsModel[Last[frames]];
Print["Done."];
