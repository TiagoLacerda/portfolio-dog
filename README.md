# portfolio_dog

An implementation of the Flow-based Difference of Gaussians using WebGL on a Flutter Web application.

## Notes

- Keep in mind that textures are setup to use unsigned bytes, so textures that hold gradient data should be normalized to [0, 1].
- At 11:10 Acerola talks about coloring the final image
    - https://www.youtube.com/watch?v=5EuYKEvugLU&t=388s&ab_channel=Acerola

## TODO:
- ~~Optimize pipeline by reducing number of intermediate textures (by reusing them).~~
- Parameterize shader asset locations.
- ~~Add option to define colors used for color-mapping.~~
    - Add option to choose between monochromatic, complimentary and tertiary palettes.
- ~~Implement presets, which on selection would animate controls and canvas status towards a defined collection of values.~~
- ~~Add brief contextualization text ("The Difference of Gaussians is a post-processing effect that ... in Winnemollers paper [link]...").~~
    - For now it's fine, but feels a little stiff. Make it more shitposty like acerola's stuff?
    - When moving to portfolio, add hyperlink to the paper (which can be found in acerola's video).
    - When presets are implemented, have keyword such as the stylization examples trigger a preset.
- Improve controls layout.
    - Math text stylization.
    - Make them less cluttered.

- ~~Prevent pipeline draw call before initialization.~~
- Fine-tune music loop offset.
- ~~Implement charcoal sketch effect.~~
- Implement hatching effect.
- Implement dithering effect.
- Implement watercolor effect. (https://youtu.be/5EuYKEvugLU?t=739)
- Implement stipple brush effect. (https://youtu.be/5EuYKEvugLU?t=767)
- Implement option to blend final image onto a selection of textures, such as watercolor paper and wood.
- Give option to show canvas in a popup window
- ~~Show unprocessed image beside canvas~~
- Change page icon to something akin to Marilyn Diptych

## TODO (maybe):
- Look into viability of using webworkers to offload graphics or audio work from the UI thread.