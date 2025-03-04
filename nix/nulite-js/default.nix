{ buildNpmPackage, lib }:
buildNpmPackage {
  pname = "nulite-js";
  version = "1.1.0";

  src = lib.sourceByRegex ../../js [
    "^src(/.*)?$"
    "^test(/.*)?$"
    "^build.mjs$"
    "^package.json$"
    "^package-lock.json$"
  ];

  npmDepsHash = "sha256-MVuARlR1NZzardqMHNtOhiTOfxaTBcOt8kR7rpsi5YE=";

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    npm run test
    runHook postCheck
  '';
}
