#import "@local/nure:0.1.1": utils
/// captioned image with auto-generated label from path
/// Usage: img("path/to/image.png", "Caption")(optional: "source")
#let img(path, caption, ..sink) = {
  let source = sink.pos().at(0, default: ())
  [ #figure(image(path, ..sink.named()), caption: utils.img-caption(caption, source)) #utils.img-label(path) ]
}
