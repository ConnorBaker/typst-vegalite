import fs from "fs";
import path from "path";
import { render } from "../dist/index.js";
import spec from "./spec.json" with { type: "json" };

async function test() {
  const expected = fs.readFileSync(path.join(process.cwd(), "test", "expected.svg"), "utf-8");
  const actual = await render(spec);
  if (actual !== expected) {
    fs.writeFileSync(path.join(process.cwd(), "test", "actual.svg"), actual, "utf-8");
    throw new Error("Test failed");
  }
  console.log("Test passed");
}

test();
