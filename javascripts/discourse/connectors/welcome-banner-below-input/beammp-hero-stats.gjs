import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

// Stat row under the welcome banner's search box, like the stat row in the hero
// on beammp.com.
//
//  - Game stats (players online, public servers) come from the same metrics
//    endpoint the website uses. That API only answers origins it allows via CORS,
//    so if this forum's origin is not allowed (or the API is down) these two are
//    simply left out.
//  - Forum stats come from Discourse's own /about.json (same origin).
//
// Each source is fetched independently, so one failing never hides the other.

const GAME_CACHE_MS = 60 * 1000;
let gameCache = { at: 0, stats: null };

const format = (n) => Number(n || 0).toLocaleString();

// Prometheus text format: one "metric_name value" pair per line.
function readMetric(text, name) {
  const match = text.match(new RegExp(`^${name}\\s+([0-9.]+)`, "m"));
  return match ? Number(match[1]) : null;
}

async function fetchGameStats(url) {
  if (gameCache.stats && Date.now() - gameCache.at < GAME_CACHE_MS) {
    return gameCache.stats;
  }

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 6000);
  try {
    const response = await fetch(url, { signal: controller.signal });
    if (!response.ok) {
      return null;
    }
    const text = await response.text();
    const players = readMetric(text, "beammp_players_online");
    const servers = readMetric(text, "beammp_public_servers");
    if (players === null || servers === null) {
      return null;
    }
    const stats = [
      {
        value: format(players),
        label: i18n(themePrefix("hero.players_online")),
        live: true,
      },
      {
        value: format(servers),
        label: i18n(themePrefix("hero.public_servers")),
        live: true,
      },
    ];
    gameCache = { at: Date.now(), stats };
    return stats;
  } catch {
    return null;
  } finally {
    clearTimeout(timeout);
  }
}

async function fetchForumStats() {
  try {
    const result = await ajax("/about.json");
    const stats = result?.about?.stats;
    if (!stats || result.about.can_see_about_stats === false) {
      return null;
    }
    return [
      { value: format(stats.users_count), label: i18n("groups.members.title") },
      { value: format(stats.topics_count), label: i18n("about.topic_count") },
      { value: format(stats.posts_count), label: i18n("about.post_count") },
    ];
  } catch {
    return null;
  }
}

export default class BeamMPHeroStats extends Component {
  @tracked game = null;
  @tracked forum = null;

  constructor() {
    super(...arguments);
    if (settings.show_hero_stats) {
      fetchForumStats().then((stats) => (this.forum = stats));
    }
    if (settings.show_hero_stats && settings.show_game_stats) {
      fetchGameStats(settings.game_stats_url).then(
        (stats) => (this.game = stats)
      );
    }
  }

  get stats() {
    return [...(this.game || []), ...(this.forum || [])];
  }

  <template>
    {{#if this.stats.length}}
      <div class="beammp-hero-stats">
        {{#each this.stats as |stat|}}
          <div class="beammp-hero-stats__item">
            <span class="beammp-hero-stats__value">{{stat.value}}</span>
            <span class="beammp-hero-stats__label">
              {{#if stat.live}}<span
                  class="beammp-hero-stats__live"
                  aria-hidden="true"
                ></span>{{/if}}{{stat.label}}
            </span>
          </div>
        {{/each}}
      </div>
    {{/if}}
  </template>
}
