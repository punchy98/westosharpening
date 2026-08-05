import { defineConfig } from "astro/config";

const deploymentUrl =
  process.env.SITE_URL ??
  process.env.CI_PAGES_URL ??
  "https://westosharpening.com";
const parsedDeploymentUrl = new URL(deploymentUrl);
const detectedBase =
  parsedDeploymentUrl.pathname === "/"
    ? "/"
    : parsedDeploymentUrl.pathname.replace(/\/$/, "");

export default defineConfig({
  output: "static",
  site: parsedDeploymentUrl.origin,
  base: process.env.BASE_PATH ?? detectedBase,
  trailingSlash: "always",
});
