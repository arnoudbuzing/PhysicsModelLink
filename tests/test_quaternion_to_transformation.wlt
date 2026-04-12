VerificationTest[
  PacletDirectoryLoad[FileNameJoin[{DirectoryName[$TestFileName, 2], "PhysicsModelLink"}]],
  {__String},
  SameTest -> MatchQ,
  TestID -> "PacletDirectoryLoad-QuaternionToTransformation"
]

VerificationTest[
  Needs["PhysicsModelLink`"],
  Null,
  TestID -> "NeedsPhysicsModelLink-QuaternionToTransformation"
]

VerificationTest[
  QuaternionToTransformation[{0.0, 0.0, 0.0, 1.0}],
  IdentityMatrix[3],
  SameTest -> (Max[Abs[Flatten[#1 - #2]]] < 10^-12 &),
  TestID -> "QuaternionToTransformation-Identity"
]

VerificationTest[
  Module[{q, m, expected},
    q = {0.0, 0.0, Sin[Pi/4], Cos[Pi/4]};
    m = QuaternionToTransformation[q];
    expected = {{0.0, -1.0, 0.0}, {1.0, 0.0, 0.0}, {0.0, 0.0, 1.0}};
    {m, expected}
  ],
  {_, _},
  SameTest -> (Max[Abs[Flatten[#[[1]] - #[[2]]]]] < 10^-12 &),
  TestID -> "QuaternionToTransformation-ZAxis90"
]
