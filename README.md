# West O Sharpening

The West O Sharpening website is a static [Astro](https://astro.build/) project. GitLab CI validates every branch and merge request, then publishes the default branch with GitLab Pages.

## Local development

Requirements: Node.js 24 and npm.

```sh
npm install
npm run dev
```

Astro prints the local preview URL in the terminal. Create a production build with:

```sh
npm run build
npm run preview
```

Run the same source and production-build verification used by CI with:

```sh
npm run verify
```

## GitLab setup

1. Create an empty GitLab project and push this repository to it.
2. Make `main` the default branch.
3. Pushes and merge requests run the `build-site` job. It verifies Node and npm, performs a clean lockfile install with an explicit install-script allowlist, validates and audits the dependency tree, checks the Astro source, and creates a production build.
4. Successful builds on the default branch run `deploy-pages` and publish `dist/`.
5. Find the published address under **Deploy > Pages** in GitLab.

The Astro configuration reads GitLab's `CI_PAGES_URL` automatically, including project subpaths. For a custom production URL, add a CI/CD variable named `SITE_URL`, such as `https://westosharpening.com`.

## Project structure

- `src/pages/index.astro` contains the page content.
- `src/components/` contains reusable service and pricing cards.
- `src/layouts/BaseLayout.astro` contains document metadata and the shared page shell.
- `src/styles/global.css` contains the site design and responsive styles.
- `public/` contains static assets such as the logo.
- `legacy/website.html` preserves the pre-Astro source for reference.
