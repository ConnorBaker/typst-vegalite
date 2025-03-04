#import "@preview/ctxjs:0.3.1"

#let nulite-bytecode = read("nulite.kbc1", encoding: none)

#let nulite-js-module = ctxjs.new-context(
  load: (
    ctxjs.load.load-module-bytecode(nulite-bytecode),
  ),
)

#let eval-later(js) = ctxjs.ctx.eval-later(js)

#let render(width: auto, height: auto, zoom: 1, spec) = {
  layout(size => {
    let calc_height = height
    let calc_width = width
    if type(calc_height) == ratio {
      calc_height = size.height * calc_height
    } else if type(calc_height) == relative {
      calc_height = size.height * calc_height.ratio + calc_height.length
    }
    if type(calc_width) == ratio {
      calc_width = size.width * calc_width
    } else if type(calc_width) == relative {
      calc_width = size.width * calc_width.ratio + calc_width.length
    }
    calc_height = (calc_height).pt()
    calc_width = (calc_width).pt()

    let spec2 = spec + (width: calc_width / zoom, height: calc_height / zoom)

    image(
      bytes(
        ctxjs.ctx.call-module-function(
          nulite-js-module,
          "nulite",
          "render",
          (spec2,),
        ),
      ),
      format: "svg",
      fit: "cover",
    )
  })
}
