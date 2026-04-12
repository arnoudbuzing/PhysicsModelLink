VerificationTest[
  PacletDirectoryLoad[FileNameJoin[{DirectoryName[$TestFileName, 2], "PhysicsModelLink"}]],
  {__String},
  SameTest -> MatchQ,
  TestID -> "PacletDirectoryLoad"
]

VerificationTest[
  Needs["PhysicsModelLink`"],
  Null,
  TestID -> "NeedsPhysicsModelLink"
]

VerificationTest[
  StringQ[PhysicsModelLink`RapierVersion[]],
  True,
  TestID -> "RapierVersionCall"
]
