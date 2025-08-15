# flutter_shaders

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## TODO:
- ~~Initialize the pipeline with all empty textures, and automate loading an asset outside the pipeline's scope~~
- ~~Properly handle webgl support detection~~
- ~~Properly handle shader compilation/link errors~~
- ~~Properly handle framebuffer configuration errors~~
- ~~Develop a mechanism for the shader pipeline to notify HTMLElementView that new canvas dimensions are available~~
- Add option to scale the image
- Add option to toggle and configure color-mapping
- Add option to save image to a new file
- Add option to save image by right clicking? (Very low priority)
- Add option to save image to a new file
- Look into moving shader pipeline to a separate thread (Isolates not available on web :c)