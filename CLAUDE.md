# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **GitHub Pages personal website** for Tom Haus, hosted at `www.tomhaus.io` (served through Cloudflare). It's a static single-page portfolio site with no build system or package dependencies.

## Architecture

**Static HTML Architecture**
- Single-page site using vanilla HTML/CSS/JavaScript in `index.html`
- All CSS embedded in one `<style>` block; site JavaScript is inline
- Third-party scripts only: GTM, Meta Pixel, and the Grafana Faro SDK (pinned version + SRI hash from unpkg)
- No build process, bundlers, or package managers
- Anchor-based navigation for sections: `#home`, `#blog`, `#passions`, `#about-me`

**Analytics & Observability** (all in `<head>` of `index.html`)
- **Grafana Faro** (primary): Frontend Observability app `tomhaus-io` (ID 2287) on the `espressohaus` Grafana Cloud stack. Sends page loads, Web Vitals and JS errors to `faro-collector-prod-us-east-2.grafana.net`. `environment` is `production` only on tomhaus.io hosts, `development` elsewhere. To upgrade the SDK, change the version in the URL **and** recompute the `integrity` hash (`curl -sL <url> | openssl dgst -sha384 -binary | base64`).
- **Google Tag Manager** `GTM-5P83Q728` (+ noscript iframe at top of `<body>`). GA4 `G-FVG6ZT55P0` is configured inside GTM, not in this repo. The container is **shared** with tomhaus.com and research.haus.
- **GTM blocklist**: `dataLayer.push({"gtm.blocklist": ["html"]})` blocks the container's Custom HTML tags (Hotjar, Tinylytics) on this site only. Keep it before the GTM snippet.
- **Meta Pixel**: `fbq('init', ...)` in `<head>`; its `<noscript>` image lives at the top of `<body>` (an `<img>` in `<head>` ends head parsing early).
- Not used: Tinylytics, Hotjar, Cloudflare Web Analytics.

**Cookie consent**
GA4 (via GTM Consent Mode v2) and Meta Pixel (`fbq('consent', ...)`) default to denied until the visitor clicks Accept in the banner. The choice is stored in `localStorage["cookie-consent"]`; the footer "Cookie settings" button reopens the banner. Consent defaults must stay in the inline script *before* the Meta Pixel and GTM snippets. Faro is not gated by the banner.

**Microformats**
The About section uses an h-card with `rel="me"` links. Keep the JSON-LD `sameAs` list in sync with those links.

## Development Workflow

### Preview Changes Locally
Serve over http (Faro's CORS allowlist includes `http://127.0.0.1:8765`):
```bash
python3 -m http.server 8765 --bind 127.0.0.1   # then open http://127.0.0.1:8765/
```

### Deploy to Production
Changes go live immediately when pushed to `main`; GitHub Pages deploys within 1-2 minutes.

### Checks (no repo dependencies; run tools via npx or a scratch install)
- Prettier: `prettier --check index.html`
- ESLint with `eslint-plugin-html` on `index.html`
- html-validate with `html-validate:recommended` + `html-validate:prettier`
- `gitleaks git .` and `gitleaks dir .`

## File Structure

```
index.html         # The website
CNAME              # GitHub Pages custom domain (www.tomhaus.io)
tom-haus.jpg       # Profile photo
monogram.png       # Favicon
og-image.png       # 1200x630 social share image (og:image / twitter:image)
```

## Common Modifications

**Content Updates**: Edit HTML directly in `index.html` within the appropriate section

**Style Changes**: Modify CSS in the `<style>` block in `<head>`; theme colors are CSS variables on `:root` / `html.light-mode`. Key classes:
- `.hero` - Landing section
- `.section` - Content sections wrapper
- `.blog-article`, `.hobby` - Content card components

**Navigation**: Update both the anchor links in the header nav and corresponding section IDs
