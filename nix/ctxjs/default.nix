{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  strictDeps = true;

  pname = "ctxjs";
  version = "0.3.1-unstable-2025-02-21";

  src = fetchFromGitHub {
    owner = "lublak";
    repo = "typst-ctxjs-package";
    rev = "996af80e53e08596c218903a2d9187e18430e54a";
    hash = "sha256-snL4cPY7WSYuzy6ZuzxD8hSSFoiBn1A2wprEw0qg0f8=";
  };

  # Make sure to regenerate the Cargo.lock file when updating the source.
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "wasm-minimal-protocol-0.1.0" = "sha256-9iCwy5HdfN9Qu7IFfKkJdDghKyQ/xLZ/7Z0F+XAE0zY=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  doCheck = false;

  meta = {
    description = "Typst Plugin to run javascript in contexts";
    license = lib.licenses.mit;
    mainProgram = "ctxjs_module_bytecode_builder";
  };
}
