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
    - Chrome throttles timers in background tabs, so test async UI with synchronous DOM checks rather than setTimeout loops.
  - Iteration 4 (UCPA all-inclusive packages, January): `ski_trip_ucpa_jan_27.html` / `ski_trip_ucpa_jan_27_research.md`. Companion page to iteration 3, not a replacement. Not hosted yet.
  - `ski_2027_plan.html` / `.md` are the original working files (identical to the March copies). Keep them.
- Other research to keep: `andorra_pricing.md` (GBP, March-based), `whatsapp_chat_notes.md`, `whatsapp_poll_draft.md`.

## Hosting (ski.jamescarron.cloud) and the public repo
- GitHub repo `JamesCarron/ski_season` is **public** and tracks **only** the hosted site and build files (whitelist `.gitignore`). Research, iterations and chat notes contain friends' names and personal details and must **stay local**. Never un-ignore them.
- The published page is `site/index.html`, a copy of the current iteration with names removed (e.g. "<name>'s week" becomes "pencilled-in week") and no links to local files. It has `noindex`. When a new iteration becomes current, regenerate it from the new HTML and grep it for names before committing.
- Served by `nginxinc/nginx-unprivileged:alpine` on port 8080 (`Dockerfile`). Deployed built-on-box via `C:\GitHub\Applets\infra\apps\ski\compose.yml`. The redeploy recipe is in `README.md`.

## Wording
- Never say "cheap" / "cheapest" / "cheaper". Use "best value", "great value", "affordable", "low-cost". Source URLs can stay as they are.

## Current brief (as of 30/09/2026)
- Budget **€1,000–€1,200 pp** for flights + transfer + accommodation + 6-day pass. Hire, lessons, food and drink are extra.
- Two groups: **Dublin** and **Leeds Bradford**. Leeds Bradford only flies direct to Geneva and Chambéry (plus Salzburg in January); otherwise the Leeds group goes via Manchester. James may fly from Zurich (low priority).
- Big areas only (≥ ~200 km linked or multi-resort pass). Bulgaria is ruled out (too small).
- Dates: late Jan / early Feb 2027. **March is ruled out.** Avoid 6–13 Feb (French Zone C + Scotland + Bavaria holidays) and 13–20 Feb (Irish mid-term / English half-term).
- Prices are estimates from live Google Flights / Booking.com searches. Always state the search date.
