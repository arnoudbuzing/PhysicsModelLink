(* Capsule Drop — capsules tumbling down a stepped ramp *)

projectDir = DirectoryName[$InputFileName, 3];
PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsModelLink"}]];
Needs["PhysicsModelLink`"];

Print["Generating capsule drop video..."];

SeedRandom[13];

model = CreatePhysicsModel[{
  PhysicsBoundaryBox[{{-4, -4, 0}, {4, 4, 6}}, "Thickness" -> 1],
  FixedBody[{HatchShading[.6, Gray], Cuboid[{-4, -4, -1}, {4, 4, 0}]}],

  (* Stepped platforms *)
  FixedBody[{HatchShading[.5, Cyan], Cuboid[{-3, -2, 0}, {-1, 2, 1.5}]}],
  FixedBody[{HatchShading[.5, Cyan], Cuboid[{0, -2, 0}, {2, 2, 3.0}]}],

  (* Capsules dropped from height with random initial rotations *)
  DynamicBody[{MaterialShading["Gold"],
    CapsuleShape[{{-2, -1, 5}, {-2, -1, 5.8}}, 0.3]},
    "Orientation" -> RotationMatrix[RandomReal[{0, Pi}], RandomReal[{-1, 1}, 3]]],
  DynamicBody[{MaterialShading["Copper"],
    CapsuleShape[{{-2, 1, 5.5}, {-2, 1, 6}}, 0.25]},
    "Orientation" -> RotationMatrix[RandomReal[{0, Pi}], RandomReal[{-1, 1}, 3]]],
  DynamicBody[{MaterialShading["Silver"],
    CapsuleShape[{{1, 0, 5}, {1, 0, 5.6}}, 0.2]},
    "Orientation" -> RotationMatrix[RandomReal[{0, Pi}], RandomReal[{-1, 1}, 3]]],
  DynamicBody[{MaterialShading["Brass"],
    CapsuleShape[{{-1.5, 0, 4.5}, {-1.5, 0, 5.3}}, 0.28]},
    "Orientation" -> RotationMatrix[RandomReal[{0, Pi}], RandomReal[{-1, 1}, 3]]]
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
outFile = FileNameJoin[{outDir, "capsule_drop.mp4"}];
Export[outFile, video, "FrameRate" -> 60, ImageSize -> {Automatic, 720}];

Print["Exported: ", outFile];

DestroyPhysicsModel[Last[frames]];
Print["Done."];
