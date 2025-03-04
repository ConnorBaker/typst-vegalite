import * as vega from "vega";
import * as lite from "vega-lite";

async function render(yourVlSpec) {
  let vegaspec = lite.compile(yourVlSpec).spec;
  var view = new vega.View(vega.parse(vegaspec), { renderer: "none" });
  const k = await view.toSVG();
  return k;
}

export { render };
