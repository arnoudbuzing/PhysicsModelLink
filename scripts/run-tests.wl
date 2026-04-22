(* PhysicsModelLink Test Runner *)

$testDir = FileNameJoin[{DirectoryName[$InputFileName, 2], "tests"}];
$pacletDir = FileNameJoin[{DirectoryName[$InputFileName, 2], "PhysicsModelLink"}];

PacletDirectoryLoad[$pacletDir];
Needs["ArnoudBuzing`PhysicsModelLink`"];

$testFiles = FileNames["*.wlt", $testDir];

Print["Running ", Length[$testFiles], " test files from: ", $testDir];
Print[StringRepeat["-", 60]];

$totalPassed = 0;
$totalFailed = 0;
$totalErrors = 0;

Do[
  Print["\n>> ", FileBaseName[file]];
  report = TestReport[file];
  passed = report["TestsSucceededCount"];
  failed = report["TestsFailedCount"];
  errors = report["TestsFailedWithErrorsCount"];
  $totalPassed += passed;
  $totalFailed += failed;
  $totalErrors += errors;
  Print["   Passed: ", passed, "  Failed: ", failed, "  Errors: ", errors];
  If[failed > 0 || errors > 0,
    Do[
      If[res["Outcome"] =!= "Success",
        Print["   FAIL [", res["TestID"], "]: ", res["Outcome"]];
        Print["         Input:    ", res["Input"]];
        Print["         Expected: ", res["ExpectedOutput"]];
        Print["         Actual:   ", res["ActualOutput"]];
      ],
      {res, report["TestResults"]}
    ]
  ],
  {file, $testFiles}
];

Print[];
Print[StringRepeat["-", 60]];
Print["TOTAL  Passed: ", $totalPassed, "  Failed: ", $totalFailed, "  Errors: ", $totalErrors];

If[$totalFailed + $totalErrors > 0, Exit[1], Exit[0]];
