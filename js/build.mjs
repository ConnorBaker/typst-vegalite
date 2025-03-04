import { build } from "esbuild";

await build({
  entryPoints: ["src/index.js"],
  bundle: true,
  format: "esm",
  outdir: "dist",
  minify: true,
  sourcemap: false,
  splitting: false,
  platform: "browser",
  format: "esm",
  // NOTE: Without injecting the shim, typst will fail to import the module:
  // nulite-typst> error: plugin errored with: failed to finish module import: Error: structuredClone is not defined
  // nulite-typst>     at <anonymous> (nulite:13:53980)
  // nulite-typst>
  // nulite-typst>    ┌─ @preview/ctxjs:0.3.1/ctx.typ:34:14
  // nulite-typst>    │
  // nulite-typst> 34 │   return cbor(ctxjs.call_module_function(helpers.string-to-bytes(modulename), helpers.string-to-bytes(fnname), cbor.encode(args), helpers.string-to-bytes(type-field)))
  // nulite-typst>    │               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  // nulite-typst>
  inject: ["src/structured-clone-shim.js"],
});
