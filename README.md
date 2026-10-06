# discourse_theme

BeamMP forum theme. Designed to match [beammp.com](https://beammp.com): neutral
greys, `#f36d24` orange accent, `#4470b6` links, rounded corners, translucent
blurred header. Source of truth for the tokens is `Website/src/style.css`.

## Layout

- `about.json`: theme metadata and the two colour schemes (BeamMP Light, BeamMP Dark)
- `common/color_definitions.scss`: brand CSS variables
- `common/common.scss`: component styling

## Using it

Install the [discourse_theme CLI](https://github.com/discourse/discourse_theme)
and live-sync against the instance:

```bash
gem install discourse_theme
discourse_theme watch .
```

In Admin > Customize > Themes > BeamMP, set the color palette to **BeamMP Light**
and the dark mode palette to **BeamMP Dark**. Discourse then follows the
visitor's browser/OS `prefers-color-scheme` automatically (visitors can override
it in their own preferences). `about.json` can't declare this pairing, so it has
to be set once per instance.
Set the logo (black and white variants) under Admin > Appearance > Branding,
using `BeamMP_blk.png` and `BeamMP_wht.png` from the website repo.
