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
- At 11:10 he talks about coloring the final image
    - https://www.youtube.com/watch?v=5EuYKEvugLU&t=388s&ab_channel=Acerola

## TODO:
- Optimize pipeline by reducing number of intermediate textures (by reusing them).
- Parameterize shader asset locations.
- ~~Add option to define colors used for color-mapping.~~
    - Add option to choose between monochromatic, complimentary and tertiary palettes.
- Implement presets, which on selection would animate controls and canvas status towards a defined collection of values.
- ~~Add brief contextualization text ("The Difference of Gaussians is a post-processing effect that ... in Winnemollers paper [link]...").~~
    - For now it's fine, but feels a little stiff. Make it more shitposty like acerola's stuff?
    - When moving to portfolio, add hyperlink to the paper (which can be found in acerola's video).
    - When presets are implemented, have keyword such as the stylization examples trigger a preset.
- Improve controls layout.
    - Math text stylization.
    - Make them less cluttered.


- Prevent pipeline draw call before initialization.
- Fine-tune music loop offset.
- ~~Implement charcoal sketch effect.~~
- Implement hatching effect.
- Implement dithering effect.
- Implement watercolor effect. (https://youtu.be/5EuYKEvugLU?t=739)
- Implement stipple brush effect. (https://youtu.be/5EuYKEvugLU?t=767)
- Implement option to blend final image onto a selection of textures, such as watercolor paper and wood.

## TODO (maybe):
- Look into viability of using webworkers to offload graphics or audio work from the UI thread.


The Flow-Based Difference of Gaussians (FDoG) is an image processing technique that enables a wide range of stylizations, including pencil, hatching, watercolor, charcoal sketch, and stipple-brush effects. Proposed by Holger Winnemöller, it extends the traditional Difference of Gaussians (DoG) by approximating the structure tensor of the image using the Sobel operator, then guiding the filtering process so that blurring and edge enhancement occur along the natural flow of the image's features.




- localizations
- html icons and metadata setup to match portfolio
- register subdomain in squarespace
- create page in firebase
- flesh out descriptive text
- (optional) setup canvas in popup window
- show unchanged image side by side