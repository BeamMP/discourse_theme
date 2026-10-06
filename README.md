# discourse_theme

BeamMP forum theme. Designed to match [beammp.com](https://beammp.com): neutral
greys, `#f36d24` orange accent, `#4470b6` links, rounded corners, translucent
blurred header. Source of truth for the tokens is `Website/src/style.css`.

## Layout

- `about.json`: theme metadata and the two colour schemes (BeamMP Light, BeamMP Dark)
- `common/color_definitions.scss`: brand CSS variables
- `common/common.scss`: component styling
- `settings.yml`: theme settings (`show_footer`)
- `javascripts/discourse/connectors/below-footer/beammp-footer.gjs`: the site footer
- `locales/*.yml`: footer translations

## Welcome banner (hero)

On the homepage and categories page (desktop and tablet; Discourse hides the
welcome banner on phones) the banner is restyled like the beammp.com landing hero:
the landing image (`assets/landing.jpg`, the website's `landing-lq.jpg`) under a
dark fade and a blue/orange tint, with a frosted search box and a stat row.

The stat row (`connectors/welcome-banner-below-input/beammp-hero-stats.gjs`) shows:

- **Players online** and **public servers** from `https://api.beammp.com/metrics`,
  the same endpoint the website uses. That API answers CORS only for origins it
  allows, so the forum's origin (it currently allows `https://forum.beammp.com`)
  must be on its list. If it is not, or the API is down, these two are simply left
  out. They cannot be tested from `localhost`.
- **Members, topics and posts** from Discourse's own `/about.json`.

Settings: `show_hero_stats`, `show_game_stats`, `game_stats_url`. Labels reuse the
website's translations and Discourse's built-in strings.

## Footer

A footer matching beammp.com (social icons, Patreon, copyright, About / Privacy /
Terms) is rendered through Discourse's `below-footer` outlet. It can be switched
off in Admin > Themes > BeamMP > Settings > `show_footer`.

The text is translated with Discourse theme translations. `en`, `de`, `es`, `fr`,
`it`, `ru` and `zh_CN` are copied from `Website/src/locales/*.json`
(`message.footer.*`; the website's `zh` is Discourse's `zh_CN`). The copyright line is
English only, as on the website. To add a language, add `locales/<code>.yml`.

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
