# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **GitHub Pages personal website** for Tom Haus, hosted at `www.tomhaus.io`. It's a static single-page portfolio site with no build system or package dependencies.

## Architecture

**Static HTML Architecture**
- Single-page application using vanilla HTML/CSS/JavaScript
- All CSS embedded in `<style>` tags (no external stylesheets)
- All JavaScript embedded inline (no external scripts)
- No build process, bundlers, or package managers
- Anchor-based navigation for sections: `#home`, `#blog`, `#passions`, `#about-me`

**Analytics Integration**
The site includes three analytics platforms (all configured in `index.html` head):
- Tinylytics: `tinylytics.app/embed/...` script in `<head>`
- Facebook Meta Pixel: `fbq('init', ...)` in `<head>`; its `<noscript>` image is at the top of `<body>` (an `<img>` in `<head>` breaks head parsing)
- Google Tag Manager: `GTM-5P83Q728` in `<head>` + noscript iframe at top of `<body>`. GA4 (`G-FVG6ZT55P0`) is configured inside the GTM container, not in this repo

**Microformats**
The About section uses h-card microformat for structured personal data with `rel="me"` links for identity verification across web profiles.

## Development Workflow

### Preview Changes Locally
```bash
open index.html      # macOS
# or
open test.html       # for testing before promoting to production
```

### Deploy to Production
Changes go live immediately when pushed to `main` branch:
```bash
git add index.html
git commit -m "Description of changes"
git push origin main
```
GitHub Pages auto-deploys within 1-2 minutes to https://www.tomhaus.io

### Testing Strategy
- Use `test.html` as a staging/preview version before modifying `index.html`
- Use browser dev tools for CSS/JavaScript debugging
- No automated testing or CI/CD

## File Structure

```
index.html          # Main production website
test.html           # Development/preview version
CNAME              # GitHub Pages custom domain (www.tomhaus.io)
tom-haus.jpg       # Profile photo
monogram.png       # Favicon
webResult.jpg      # Unused image asset
```

## Common Modifications

**Content Updates**: Edit HTML directly in `index.html` within the appropriate section div

**Style Changes**: Modify CSS in the `<style>` block in `<head>`; theme colors are CSS variables on `:root` / `html.light-mode`. Key classes:
- `.hero` - Landing section
- `.section` - Content sections wrapper
- `.blog-article`, `.hobby`, `.pillar` - Content card components

**Navigation**: Update both the anchor links in the header nav and corresponding section IDs

**Analytics IDs**: Update tracking IDs directly in the embedded scripts in the `<head>` section
