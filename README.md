# West O Sharpening

The West O Sharpening website is a static [Astro](https://astro.build/) project. GitHub Actions validates every pull request and publishes the `main` branch with GitHub Pages.

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
4. Validates and audits dependencies, checks the Astro source, and creates a production build.
5. Publishes successful `main` builds through GitHub Pages.

Astro automatically detects the GitHub repository name and uses the correct project subpath. For a custom domain, create a repository variable named `SITE_URL`, such as `https://westosharpening.com`, and configure that same domain under **Settings > Pages**.

## Project structure

- `src/pages/index.astro` contains the page content.
- `src/components/` contains reusable service and pricing cards.
- `src/layouts/BaseLayout.astro` contains document metadata and the shared page shell.
- `src/styles/global.css` contains the site design and responsive styles.
- `public/` contains static assets such as the logo.
- `legacy/website.html` preserves the pre-Astro source for reference.
