# Ski 2027

Mobile-first summary page for a group ski trip, hosted at **https://ski.jamescarron.cloud**.

- `site/2027/index.html`: the published trip summary page at **https://ski.jamescarron.cloud/2027/** (the bare domain 302-redirects there). It is self-contained, with inline CSS and JS.
- `site/ucpa_2027/`: UCPA January 2027 options comparison at **https://ski.jamescarron.cloud/ucpa_2027/**, with full-resolution piste maps in `maps/`. The maps are rendered from skimap.org originals; each map links to its source.
- `Dockerfile` + `nginx.conf`: unprivileged nginx serving `site/` on port 8080, with relative redirects so it works behind Traefik.
- Deployed built-on-box via `JamesCarron/infra` (`apps/ski/compose.yml`).

Redeploy after changing the site:

```
# on the server
cd /opt/apps-src/ski_season && git pull --ff-only
cd /opt/infra && export INFRA_PATH=/opt/infra
docker compose -p ski --env-file config.env -f apps/ski/compose.yml up -d --build
```
