{
  ctxjs,
  fetchFromGitHub,
  lib,
  nulite-js,
  stdenvNoCC,
  typst,
}:
let
  inherit (lib.attrsets) getLib;
  inherit (lib.meta) getExe;
  inherit (lib.sources) sourceByRegex;
  inherit (lib.strings) optionalString;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "nulite-typst";
  version = "0.1.1";

  src = sourceByRegex ../../typst-package [
    "^examples(/.*)?$"
    "^test(/.*)?$"
    "^lib.typ$"
    "^LICENSE$"
    "^README.md$"
    "^typst.toml$"
  ];

  # NOTE: Conditionally setting TYPST_PACKAGE_CACHE_PATH, which typst uses to resolve cached packages, allows us to
  # avoid downloading it when doCheck is false.
  env.TYPST_PACKAGE_CACHE_PATH =
    let
      typstPackages = fetchFromGitHub {
        owner = "typst";
        repo = "packages";
        rev = "d4ac49c134db967fb251d6dccd8fcce472da1cb3";
        hash = "sha256-xVj8uVLCb5wy76MVTcQKb+A129sBYu4KqgjYV/E2mJE=";
      };
    in
    optionalString finalAttrs.doCheck "${typstPackages.outPath}/packages";

  nativeBuildInputs = [
    ctxjs
    nulite-js
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    "${getExe ctxjs}" \
      nulite \
      "${getLib nulite-js}/lib/node_modules/nulite/dist/index.js" \
      nulite.kbc1
    runHook postBuild
  '';

  doCheck = true;
  nativeCheckInputs = [ typst ];
  checkPhase = ''
    runHook preCheck

    nixLog "Building typst chart tests..."
    for file in test/charts/*.typ; do
      if "${getExe typst}" compile --root=.. "$file"; then
        nixLog "Successfully built $file"
      else
        nixErrorLog "Failed to build $file"
        exit 1
      fi
    done
    nixLog "Successfully built all chart tests"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/typst/packages/local/nulite/${finalAttrs.version}/"
    install -Dm644 \
      lib.typ \
      LICENSE \
      nulite.kbc1 \
      README.md \
      typst.toml \
      "$out/share/typst/packages/local/nulite/${finalAttrs.version}/"

    runHook postInstall
  '';
})
