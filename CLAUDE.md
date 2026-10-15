# Ski 2027 trip planning — project notes

Group ski trip planning (Dublin group + Leeds group, ~7–10 people). Source chat: WhatsApp group "Ski 2027".

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
    - Update 16/10/2026: **direct flights only**; the Irish group may fly from **Cork or Dublin** (whichever direct flight is lower); Sauze d'Oulx removed; each resort/week has one Booking.com place to stay chosen for a group of **mostly couples**: an entire place with 3–4 bedrooms and at least 2 doubles, or a hotel with 3 private rooms. **No bunk beds, sofa beds or futons.** The pick is the lowest-priced fit rated 7.5+ (then 7.0+, then unrated, marked). The previous median-of-8 rule picked bunk/sofa-bed apartments and was replaced on 16/10/2026; the page before that change is `ski_trip_feb_27_v3.html`. The pick card and week cards are computed in the page from the data; every flight and apartment links to its live search. Totals and the best airport per resort/group/week are computed in the page's JS from the `FL` fares table. The previous layout is kept as `ski_trip_feb_27_v2.html`. Google Flights direct-only links use the query text `Nonstop flights from X to Y on A through B`. Booking.com prices were read while signed in to a Genius account (member discounts), and the page says so.
    - House stylesheet (16/10/2026): the page's own CSS variables are re-pointed onto the house semantic tokens (`--a-bg`, `--a-ink`, `--a-link`, `--a-good`…), with no raw hex. **Always build with `python build_site.py`** (local only, gitignored). It inlines the house CSS and fonts **with every comment stripped**, because the comments name the employer and this page is public. It then writes both the working file and `site/2027/index.html` (with `MAPDIR` swapped), and refuses to write if the company name appears anywhere. Never inline the house CSS with its own inliner here: its marker comment also carries the name.
    - Piste maps live in `site/2027/maps/` (full ≤6000 px) and `site/2027/maps/thumb/` (900 px previews; Les 2 Alpes is portrait, at 600 px). Tapping a preview opens the full JPEG in a new tab. Sources on skimap.org: Portes du Soleil 38554, Les 2 Alpes 35289, Grandvalira 38216 (PDF p1), Via Lattea 36684 (PDF p2, cropped to the left 65.5% to drop the lift table), 3 Vallées 34989. The working file uses `MAPDIR='site/2027/maps/'`; the hosted copy replaces it with `'maps/'`.
  - `ski_2027_plan.html` / `.md` are the original working files (identical to the March copies). Keep them.
- Other research to keep: `andorra_pricing.md` (GBP, March-based), `whatsapp_chat_notes.md`, `whatsapp_poll_draft.md`.

## Hosting (ski.jamescarron.cloud) and the public repo
- GitHub repo `JamesCarron/ski_season` is **public** and tracks **only** the hosted site and build files (whitelist `.gitignore`). Research, iterations and chat notes contain friends' names and personal details and must **stay local**. Never un-ignore them.
- The published page is `site/2027/index.html` (URL /2027/; `/` 302-redirects there via nginx.conf; the container healthcheck in infra checks /2027/), a copy of the current iteration with names removed (e.g. "<name>'s week" becomes "pencilled-in week") and no links to local files. It has `noindex`. When a new iteration becomes current, regenerate it from the new HTML and grep it for names before committing.
- Served by `nginxinc/nginx-unprivileged:alpine` on port 8080 (`Dockerfile`). Deployed built-on-box via `C:\GitHub\Applets\infra\apps\ski\compose.yml`. The redeploy recipe is in `README.md`.

## Wording
- Never say "cheap" / "cheapest" / "cheaper". Use "best value", "great value", "affordable", "low-cost". Source URLs can stay as they are.

## Current brief (as of 30/09/2026)
- Budget **€1,000–€1,200 pp** for flights + transfer + accommodation + 6-day pass. Hire, lessons, food and drink are extra.
- Two groups: **Ireland (Cork or Dublin)** and **Leeds Bradford**. Flights are **direct only** (since 16/10/2026). Leeds Bradford only flies direct to Geneva and Chambéry (plus Salzburg in January); otherwise the Leeds group goes via Manchester. James may fly from Zurich (low priority).
- Big areas only (≥ ~200 km linked or multi-resort pass). Bulgaria is ruled out (too small).
- Dates: the group is focusing on **Sat 30 Jan, 6 Feb and 13 Feb 2027** (as of 13/10/2026). **March is ruled out.** 6 Feb clashes with French Zone C, Scotland and Bavaria holidays; 13 Feb is Irish mid-term + English half-term (peak). On 6 and 13 Feb the Leeds group is better off via Manchester (Leeds Bradford → Geneva €298 / €637).
- The UCPA pages are a **separate, finished project**. Don't touch them when working on the DIY plan.
- Prices are estimates from live Google Flights / Booking.com searches. Always state the search date.
