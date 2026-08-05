import { defineConfig } from "astro/config";

const customSiteUrl = process.env.SITE_URL?.trim();
const [githubOwner = "", githubRepository = ""] = (
  process.env.GITHUB_REPOSITORY ?? ""
).split("/");
const isUserOrOrganizationSite =
  githubRepository.toLowerCase() === `${githubOwner.toLowerCase()}.github.io`;
const githubPagesUrl = githubOwner
  ? `https://${githubOwner}.github.io${isUserOrOrganizationSite ? "" : `/${githubRepository}`}`
  : "https://westosharpening.com";
const deploymentUrl = customSiteUrl || githubPagesUrl;
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
