# West O Sharpening

The West O Sharpening website is a static [Astro 7](https://astro.build/) project. GitHub Actions validates every pull request and publishes the `main` branch with GitHub Pages.

## Local development

Requirements: Node.js 24 and npm.

```sh
npm install
npm run dev
```

Astro prints the local preview URL in the terminal. Create and preview a production build with:

```sh
npm run build
npm run preview
```

Run the same source and production-build verification used by CI with:

```sh
npm run verify
```

## GitHub Pages

The workflow in `.github/workflows/deploy.yml`:

1. Runs for pull requests, pushes to `main`, and manual dispatches.
2. Installs the pinned Node.js release and restores the npm cache.
3. Performs a clean lockfile install with the project's install-script policy.
4. Audits production dependencies at high severity and the full build-time tree at critical severity.
5. Checks the Astro source and creates a production build.
6. Publishes successful `main` builds through GitHub Pages.

Astro builds for the custom domain `https://westosharpening.com` by default, so assets are served from the domain root. Configure that domain under **Settings > Pages**. The optional `SITE_URL` repository variable can override the deployment URL for another environment.

## Project structure

- `src/pages/index.astro` contains the homepage, services, pricing, and previous-work gallery.
- `src/pages/about.astro` contains Michael's story and service philosophy.
- `src/pages/blog/` contains the blog index and knife-care articles.
- `src/components/` contains reusable cards and the accessible previous-work carousel.
- `src/layouts/` contains document metadata, shared navigation, the footer, and article framing.
- `src/styles/global.css` contains the site design and responsive styles.
- `public/` contains static assets such as the logo and previous-work images.
- `legacy/website.html` preserves the pre-Astro source for reference.

The carousel uses real before-and-after project photos from `public/images/previous-work/`. Project groupings, labels, descriptions, and alternative text are configured in `src/pages/index.astro`.
