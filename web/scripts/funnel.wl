(* Funnel — objects funneled through a narrow gap between fixed walls *)

projectDir = DirectoryName[$InputFileName, 3];
PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsModelLink"}]];
Needs["PhysicsModelLink`"];

Print["Generating funnel video..."];

SeedRandom[7];

(* Angled funnel walls *)
funnelWalls = {
  FixedBody[{HatchShading[.5, Green],
    Cuboid[{-4, -1.5, 1.5}, {-0.6, 1.5, 2.0}]},
    "Orientation" -> RotationMatrix[-Pi/8, {0, 1, 0}]],
  FixedBody[{HatchShading[.5, Green],
    Cuboid[{0.6, -1.5, 1.5}, {4, 1.5, 2.0}]},
    "Orientation" -> RotationMatrix[Pi/8, {0, 1, 0}]]
};

(* Assorted objects dropped from above *)
objects = {
  DynamicBody[{MaterialShading["Gold"], Sphere[{-1, 0, 5}, 0.3]}],
  DynamicBody[{MaterialShading["Copper"], Sphere[{0, 0.5, 5.3}, 0.25]}],
  DynamicBody[{MaterialShading["Silver"], Sphere[{1, -0.3, 4.8}, 0.35]}],
  DynamicBody[{MaterialShading["Brass"], Sphere[{0.5, 0, 5.6}, 0.2]}],
  DynamicBody[{MaterialShading["Bronze"],
    Cuboid[{-0.5, -0.2, 4.5}, {0.1, 0.4, 5.1}]},
    "Orientation" -> RotationMatrix[Pi/5, {1, 1, 0}]],
  DynamicBody[{MaterialShading["Gold"],
    Cuboid[{-1.2, -0.3, 5.5}, {-0.6, 0.3, 6.1}]}],
  DynamicBody[{MaterialShading["Copper"],
    Cone[{{0.8, 0.8, 5}, {0.8, 0.8, 5.6}}, 0.25]}],
  DynamicBody[{MaterialShading["Silver"],
    Cone[{{-0.3, -0.8, 5.2}, {-0.3, -0.8, 5.8}}, 0.2]}]
};

model = CreatePhysicsModel[{
  PhysicsBoundaryBox[{{-4, -4, 0}, {4, 4, 6}}, "Thickness" -> 1],
  FixedBody[{HatchShading[.6, Gray], Cuboid[{-4, -4, -1}, {4, 4, 0}]}],
  funnelWalls,
  objects
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
outFile = FileNameJoin[{outDir, "funnel.mp4"}];
Export[outFile, video, "FrameRate" -> 60, ImageSize -> {Automatic, 720}];

Print["Exported: ", outFile];

DestroyPhysicsModel[Last[frames]];
Print["Done."];
