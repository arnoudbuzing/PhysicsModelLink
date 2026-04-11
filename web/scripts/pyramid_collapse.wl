(* Pyramid Collapse — a pyramid of cuboids hit by a heavy sphere *)

projectDir = DirectoryName[$InputFileName, 3];
PacletDirectoryLoad[FileNameJoin[{projectDir, "PhysicsLink"}]];
Needs["PhysicsLink`"];

Print["Generating pyramid collapse video..."];

(* Build a 4-layer pyramid of cuboids *)
(* Each block is 0.8 x 0.8 x 0.4 — wide and flat like bricks *)
bw = 0.8;  (* block width/depth *)
bh = 0.4;  (* block height *)
layers = {};
Do[
  n = 4 - layer;  (* number of blocks per side: 4, 3, 2, 1 *)
  offset = (n - 1) * bw / 2;  (* center the row *)
  zlo = layer * bh;
  zhi = (layer + 1) * bh;
  Do[
    Do[
      cx = col * bw - offset;
      cy = row * bw - offset;
      AppendTo[layers,
        DynamicBody[{MaterialShading["Brass"],
          Cuboid[{cx - bw/2, cy - bw/2, zlo}, {cx + bw/2, cy + bw/2, zhi}]}]
      ],
      {col, 0, n - 1}
    ],
    {row, 0, n - 1}
  ],
  {layer, 0, 3}
];

(* Wrecking sphere — centered above the pyramid, falling down *)
wrecker = DynamicBody[{MaterialShading["Bronze"],
  Sphere[{0, 0, 4.5}, 0.6]},
  "Density" -> 8.0,
  "Velocity" -> {0, 0, -8}];

model = CreatePhysicsModel[{
  PhysicsBoundaryBox[{{-4, -4, 0}, {4, 4, 6}}, "Thickness" -> 1],
  FixedBody[{HatchShading[.6, Gray], Cuboid[{-4, -4, -1}, {4, 4, 0}]}],
  layers,
  wrecker
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
outFile = FileNameJoin[{outDir, "pyramid_collapse.mp4"}];
Export[outFile, video, "FrameRate" -> 60, ImageSize -> {Automatic, 720}];

Print["Exported: ", outFile];

DestroyPhysicsModel[Last[frames]];
Print["Done."];
