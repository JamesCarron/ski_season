# Ski season — project notes

Ski season planning: a group ski trip (Dublin group + Leeds group, ~7–10 people; source chat: WhatsApp group "Ski 2027"), a separate UCPA trip comparison, and equipment buying research.

## This repo stays private
- **Decided 2026-10-18:** the GitHub repo `JamesCarron/ski_season` is to stay **private**, so private material (friends' names, research, chat notes, task summaries) may be stored **and committed** here. Don't move it out of the repo or scrub it from working files.
- When this was decided the repo was still **public** on GitHub, and the user is switching it to private. Check with `gh repo view JamesCarron/ski_season --json visibility` before committing any private file. While it still says `PUBLIC`, keep the whitelist `.gitignore` and commit only `site/` and the docs that carry no names.
- **The hosted website is still public.** Every page under `site/` must have names removed and carry `noindex`. `.dockerignore` sends only `site/` into the image, so nothing else is ever served.

## Repo layout (restructured 2026-10-18)

```
ski_season/
  README.md, CLAUDE.md, Dockerfile, nginx.conf, pixi.toml   root: hosting + project files
  site/                published website (public). Deployed as-is, so never move it
    2027/                DIY trip page   -> /2027/   (built from trip_2027/)
    ucpa_2027/           UCPA options    -> /ucpa_2027/ (copied from ucpa_2027/)
    equipment/           equipment guides -> /equipment/ (built from equipment/)
  trip_2027/           subproject: DIY group trip. Every iteration, its research, chat notes
  ucpa_2027/           subproject: UCPA trip. Options page, mockup, January packages, maps/
  equipment/           subproject: equipment research. Working guides (helmets, boots, gloves, poles)
  scripts/             build_site.py (trip page), build_equipment.py (equipment guides)
  docs/                task summaries and planning notes
  tools/bin/           flight-goat CLI binary, put on PATH by pixi.toml (not a scripts folder)
  .claude/skills/      project skills
```

- Working pages link to the hosted copies' assets relatively: trip pages use `MAPDIR='../site/2027/maps/'`, and the UCPA page loads `maps/` from beside itself (`ucpa_2027/maps/`).
- Task summaries for this repo go in `docs/`, named after the task.

## HTML summaries are read on phones
- Every HTML summary will mostly be opened on **mobile** (shared into WhatsApp). Build **mobile-first**:
  - `<meta name="viewport" content="width=device-width, initial-scale=1">`, 16px side gutters, single-column layout by default. Widen to 2–3 columns only via `min-width` media queries.
  - **No wide tables.** Use stacked cards or key/value rows instead. Nothing may cause horizontal page scroll.
  - Text ≥ 12px (body 15–16px), tap targets ≥ 32px (aim for 40px), no hover-only information.
  - Self-contained single file (inline CSS/JS, no external fonts needed), light and dark mode via CSS variables.
- **Test before handing over.** Serve the folder locally (`python -m http.server <free port> --bind 127.0.0.1 --directory C:\GitHub\ski_season`; port 8765 is often taken by another project), load the page in 390×844 and 360×740 iframes, and check with JS that:
  - `scrollWidth <= clientWidth` (no overflow) and no element's content is clipped
  - no text is under 12px and no link or summary is under 32px tall
  
  Chrome window resizing and screenshots can be unreliable here, so the DOM measurements are the source of truth.

## Iterations — keep them all
- The DIY trip files below live in `trip_2027/`; the UCPA files (options page, mockup, iteration 4 January packages) live in `ucpa_2027/`.
- Each plan iteration gets its own HTML summary. **Never overwrite or delete an earlier iteration or its research.**
- Naming: `ski_trip_<period>_27.html` for the summary, and `ski_trip_<period>_27_research.md` for the full data and sources.
  - Iteration 1–2 (March weeks): `ski_trip_march_27.html` / `ski_trip_march_27_research.md`. March was later ruled out by the group.
  - Iteration 3 (late Jan / early Feb, DIY): `ski_trip_jan_feb_27.html` / `ski_trip_jan_feb_27_research.md` (current DIY plan, hosted)
  - UCPA options (separate effort, UCPA-only, travel from Dublin + Zurich): `ski_trip_ucpa_options_27.html` (full version) + `ski_trip_ucpa_options_27_research.md`. The mockup is kept as `ski_trip_ucpa_options_mockup.html`. Don't mix DIY or Leeds content into this effort.
    - Piste map viewer loads full-resolution JPEGs from `maps/` (rendered from skimap.org originals). It shows the skimap preview first, then swaps in the full image. Zoom is capped at native resolution.
    - **Hosted** at https://ski.jamescarron.cloud/ucpa_2027/ (decided 2026-10-13). The published copy is `site/ucpa_2027/index.html` + `site/ucpa_2027/maps/*.jpg`. When the working file `ski_trip_ucpa_options_27.html` changes, copy it to `site/ucpa_2027/index.html`, grep for names, commit, then redeploy (README).
    - Travel: each option lists the airports with driving times, and the week rows pick the best-value Dublin airport per week (Geneva, Lyon, Grenoble or Turin; Chambéry has no Dublin flights). Zurich: direct train for Argentière, train to Geneva Airport for the rest, fly to Turin for Serre Chevalier. Don't assume one airport for all resorts.
    - Redeploy check: after `up -d --build`, Traefik returns 404 for ~30 s until the container is healthy, and Cloudflare caches 404s for images for ~3 min. Wait for `healthy` plus ~30 s before curling the image URLs.
    - Chrome throttles timers in background tabs, so test async UI with synchronous DOM checks rather than setTimeout loops.
  - Iteration 4 (UCPA all-inclusive packages, January): `ski_trip_ucpa_jan_27.html` / `ski_trip_ucpa_jan_27_research.md`. Companion page to iteration 3, not a replacement. Not hosted yet.
  - Iteration 5 (DIY, three weeks: Sat 30 Jan, 6 Feb, 13 Feb; prices 13/10/2026): `ski_trip_feb_27.html` / `ski_trip_feb_27_research.md`. **Current DIY plan, hosted as `site/2027/index.html` at ski.jamescarron.cloud/2027/** (replaced iteration 3 there; iteration 3 is still kept locally).
    - Layout (13/10/2026): each resort card shows the facts and a piste-map preview first. Weeks, totals, flights and apartments sit in the card's "More detail". The page-wide week and flight comparisons are collapsed blocks. The previous layout is kept as `ski_trip_feb_27_v1.html`.
    - Update 16/10/2026: **direct flights only**; the Irish group may fly from **Cork or Dublin** (whichever direct flight is lower); Sauze d'Oulx removed; each resort/week shows a **representative apartment** (median of the 8 lowest-priced Booking.com listings for the group). A "mostly couples" rule (3–4 bedrooms, 2+ doubles, no bunk/sofa beds, or a hotel with 3 private rooms) was deployed on 16/10/2026 (`75c6181`) and **rolled back the same day because it was too expensive** (11 of 12 options over €1,200 pp). The live and working pages are back to the median-of-8 version (same content as `ski_trip_feb_27_v3.html`); the couples version is kept as `ski_trip_feb_27_couples.html`, with its data in section 8 of `ski_trip_feb_27_research.md`. The pick card and week cards are computed in the page from the data; every flight and apartment links to its live search. Totals and the best airport per resort/group/week are computed in the page's JS from the `FL` fares table. The previous layout is kept as `ski_trip_feb_27_v2.html`. Google Flights direct-only links use the query text `Nonstop flights from X to Y on A through B`. Booking.com prices were read while signed in to a Genius account (member discounts), and the page says so.
    - House stylesheet (16/10/2026): the page's own CSS variables are re-pointed onto the house semantic tokens (`--a-bg`, `--a-ink`, `--a-link`, `--a-good`…), with no raw hex. **Always build with `python scripts/build_site.py`** (run from the repo root; it reads `trip_2027/ski_trip_feb_27.html` by default). It inlines the house CSS and fonts **with every comment stripped**, because the comments name the employer and this page is public. The house stylesheet module is `C:\GitHub\Applets\brand` on this PC. It then writes both the working file and `site/2027/index.html` (with `MAPDIR` swapped), and refuses to write if the company name appears anywhere. Never inline the house CSS with its own inliner here: its marker comment also carries the name.
    - Piste maps live in `site/2027/maps/` (full ≤6000 px) and `site/2027/maps/thumb/` (900 px previews; Les 2 Alpes is portrait, at 600 px). Tapping a preview opens the full JPEG in a new tab. Sources on skimap.org: Portes du Soleil 38554, Les 2 Alpes 35289, Grandvalira 38216 (PDF p1), Via Lattea 36684 (PDF p2, cropped to the left 65.5% to drop the lift table), 3 Vallées 34989. The working file uses `MAPDIR='../site/2027/maps/'`; the hosted copy replaces it with `'maps/'`.
  - `ski_2027_plan.html` / `.md` are the original working files (identical to the March copies). Keep them.
- Other research to keep: `andorra_pricing.md` (GBP, March-based), `whatsapp_chat_notes.md`, `whatsapp_poll_draft.md`.

## Equipment research (subproject, 2026-10-18)
- Buying guides for ski helmets, boots, gloves and poles, plus snowboards and snowboard bindings (added 2026-10-18). Each has a ranked "what matters" list, diagrams, calculators where useful, a filterable glossary and a shop checklist. The working files are `equipment/Ski_<Item>_Guide.html`, `equipment/Snowboard_Guide.html` and `equipment/Snowboard_Binding_Guide.html`. Their task summaries are `docs/Ski_<Item>_Guide.md` and `docs/Snowboard_Guides.md`.
- To add a guide: copy an existing guide's page `<style>` block (the one after the house-CSS block), write the page, run `label_tables()` from `%CLAUDE_TOOLS%\scratch\equipment_guides_mobile_house.py` to add the `data-label`s, add a row to `GUIDES` in `scripts/build_equipment.py`, then build. Content comes from general knowledge, without a web search, and the figures are typical values.
- **Hosted** at https://ski.jamescarron.cloud/equipment/ (landing page plus `helmets/`, `boots/`, `gloves/`, `poles/`, `snowboards/`, `snowboard-bindings/`). **Always build with `python scripts/build_equipment.py`**. It inlines the house CSS with comments stripped, writes the working files back, writes `site/equipment/<slug>/index.html` (adding `noindex` and a back link) and the landing page, and refuses to write if the company name appears.
- Mobile-first like the trip pages: colours are house tokens only (diagram fills use `--a-cat-1`…`6`), tables stack into labelled rows below 700 px (`data-label` on every cell), and the diagrams scroll sideways inside their figure on phones rather than shrinking text below 12px. When adding a table row, give each cell its `data-label`.

## Hosting (ski.jamescarron.cloud)
- The published page is `site/2027/index.html` (URL /2027/; `/` 302-redirects there via nginx.conf; the container healthcheck in infra checks /2027/), a copy of the current iteration with names removed (e.g. "<name>'s week" becomes "pencilled-in week") and no links to local files. It has `noindex`. When a new iteration becomes current, regenerate it from the new HTML and grep it for names before committing.
- Served by `nginxinc/nginx-unprivileged:alpine` on port 8080 (`Dockerfile`). Deployed built-on-box via `C:\GitHub\Applets\infra\apps\ski\compose.yml`. The redeploy recipe is in `README.md`.
- **Running the redeploy from this laptop** (worked 2026-10-18): use **PowerShell's** `ssh`, not Git Bash's. Git Bash's ssh has a different home (`/c/SPB_DATA`), so it ignores `~\.ssh\config` (user `admin`, `id_ed25519_hetzner`) and fails host-key verification. sshd listens on the tailnet only, so connect through Tailscale and check the key against the stored public-IP entry: `ssh -o HostName=100.68.148.7 -o HostKeyAlias=167.233.82.105 apps-01 '<commands>'`. Then wait until `docker inspect -f '{{.State.Health.Status}}' ski-app-1` says `healthy`, plus about 30 s, before curling the public URLs.

## Wording
- Never say "cheap" / "cheapest" / "cheaper". Use "best value", "great value", "affordable", "low-cost". Source URLs can stay as they are.

## Current brief (as of 30/09/2026)
- Budget **€1,000–€1,200 pp** for flights + transfer + accommodation + 6-day pass. Hire, lessons, food and drink are extra.
- Two groups: **Ireland (Cork or Dublin)** and **Leeds Bradford**. Flights are **direct only** (since 16/10/2026). Leeds Bradford only flies direct to Geneva and Chambéry (plus Salzburg in January); otherwise the Leeds group goes via Manchester. James may fly from Zurich (low priority).
- Big areas only (≥ ~200 km linked or multi-resort pass). Bulgaria is ruled out (too small).
- Dates: the group is focusing on **Sat 30 Jan, 6 Feb and 13 Feb 2027** (as of 13/10/2026). **March is ruled out.** 6 Feb clashes with French Zone C, Scotland and Bavaria holidays; 13 Feb is Irish mid-term + English half-term (peak). On 6 and 13 Feb the Leeds group is better off via Manchester (Leeds Bradford → Geneva €298 / €637).
- The UCPA pages are a **separate, finished project**. Don't touch them when working on the DIY plan.
- Prices are estimates from live Google Flights / Booking.com searches. Always state the search date.
