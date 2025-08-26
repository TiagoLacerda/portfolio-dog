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


## Notes

- Keep in mind that textures are setup to use unsigned bytes, so textures that hold gradient data should be normalized to [0, 1].


## TODO:
- ~~Initialize the pipeline with all empty textures, and automate loading an asset outside the pipeline's scope~~
- ~~Properly handle webgl support detection~~
- ~~Properly handle shader compilation/link errors~~
- ~~Properly handle framebuffer configuration errors~~
- ~~Develop a mechanism for the shader pipeline to notify HTMLElementView that new canvas dimensions are available~~
- Add option to scale the image
- Add option to ~~toggle~~ and configure color-mapping
- ~~Add option to save image to a new file~~
- ~~Add option to save image by right clicking? (Very low priority)~~
    - ~~This actually just works like that (I guess because it is an embedded html canvas)~~
- Look into moving shader pipeline to a separate thread (Isolates not available on web :c)
- Reduce number of textures by overwriting previous steps
- Parameterize shader path in pipeline initialization
- Show image resolution in scale slider



https://www.youtube.com/watch?v=5EuYKEvugLU&t=388s&ab_channel=Acerola
- At 11:10 he talks about coloring the final image