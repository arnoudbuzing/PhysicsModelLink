VerificationTest[
  PacletDirectoryLoad[FileNameJoin[{DirectoryName[$TestFileName, 2], "PhysicsLink"}]],
  {__String},
  SameTest -> MatchQ,
  TestID -> "PacletDirectoryLoad"
]

VerificationTest[
  Needs["PhysicsLink`"],
  Null,
  TestID -> "NeedsPhysicsLink"
]

VerificationTest[
  StringQ[PhysicsLink`RapierVersion[]],
  True,
  TestID -> "RapierVersionCall"
]
