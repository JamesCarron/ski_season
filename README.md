# Ski 2027

Mobile-first summary page for a group ski trip, hosted at **https://ski.jamescarron.cloud**.

- `site/index.html`: the published page. It is self-contained, with inline CSS and JS.
- `Dockerfile`: unprivileged nginx serving `site/` on port 8080.
- Deployed built-on-box via `JamesCarron/infra` (`apps/ski/compose.yml`).

Redeploy after changing the site:

```
# on the server
cd /opt/apps-src/ski_season && git pull --ff-only
cd /opt/infra && export INFRA_PATH=/opt/infra
docker compose -p ski --env-file config.env -f apps/ski/compose.yml up -d --build
```
