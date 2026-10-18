# Ski season

Planning for the 2026/27 ski season: a group trip, a UCPA trip comparison and equipment buying guides. The mobile-first summary pages are hosted at **https://ski.jamescarron.cloud**.

## Layout

- `site/`: the published website, served as-is.
  - `site/2027/index.html`: the group trip summary at **https://ski.jamescarron.cloud/2027/** (the bare domain 302-redirects there). Self-contained, with inline CSS and JS.
  - `site/ucpa_2027/`: UCPA January 2027 options comparison at **https://ski.jamescarron.cloud/ucpa_2027/**, with full-resolution piste maps in `maps/`. The maps are rendered from skimap.org originals, and each map links to its source.
  - `site/equipment/`: buying guides for helmets, boots, gloves and poles at **https://ski.jamescarron.cloud/equipment/**.
- `trip_2027/`, `ucpa_2027/`, `equipment/`: the working files and research for each subproject.
- `scripts/`: `build_site.py` builds `site/2027/` from `trip_2027/`, and `build_equipment.py` builds `site/equipment/` from `equipment/`.
- `docs/`: task summaries and planning notes.
- `Dockerfile` + `nginx.conf`: unprivileged nginx serving `site/` on port 8080, with relative redirects so it works behind Traefik. `.dockerignore` sends only `site/` into the image.
- Deployed built-on-box via `JamesCarron/infra` (`apps/ski/compose.yml`).

Redeploy after changing the site:

```
# on the server
cd /opt/apps-src/ski_season && git pull --ff-only
cd /opt/infra && export INFRA_PATH=/opt/infra
docker compose -p ski --env-file config.env -f apps/ski/compose.yml up -d --build
```
