# Fly.io vs Vercel: Edge Compute, Containers, and the Full-Stack Trade-Off

Companion code for the Autonoma blog post 'Fly.io vs Vercel: Edge Compute, Containers, and the Full-Stack Trade-Off'. Scripts Fly.io preview environments and GitHub Actions E2E test integration to reproduce Vercel Deployment Checks behavior on Fly.io.

> Companion code for the Autonoma blog post: **[Fly.io vs Vercel: Edge Compute, Containers, and the Full-Stack Trade-Off](https://getautonoma.com/blog/fly-io-vs-vercel)**

## Requirements

Fly.io account with flyctl CLI installed. GitHub Actions enabled on the repo. Autonoma API key (optional — the workflow also supports Playwright-direct mode).

## Quickstart

```bash
git clone https://github.com/Autonoma-Tools/fly-io-vs-vercel.git
cd fly-io-vs-vercel
Copy scripts/fly-preview.sh, fly.pr.toml, and .github/workflows/preview.yml into your project. Set FLY_API_TOKEN and AUTONOMA_API_KEY as GitHub Actions secrets. Open a PR — the workflow creates a Fly preview app, runs E2E tests, and posts results as a required status check.
```

## Project structure

```
.
├── .github/
│   └── workflows/
│       └── preview.yml
├── examples/
│   └── deploy-pr-42.sh
├── scripts/
│   └── fly-preview.sh
├── fly.pr.toml
├── .gitignore
├── LICENSE
└── README.md
```

- `scripts/` — the Fly.io preview deploy/destroy script referenced by the workflow.
- `.github/workflows/` — the GitHub Actions workflow that creates preview apps, runs Autonoma E2E tests, and posts a required status check.
- `examples/` — a runnable local example that invokes `scripts/fly-preview.sh` end-to-end.
- `fly.pr.toml` — Fly.io machine-spec overlay used by preview deploys (small, auto-sleep).

## About

This repository is maintained by [Autonoma](https://getautonoma.com) as reference material for the linked blog post. Autonoma builds autonomous AI agents that plan, execute, and maintain end-to-end tests directly from your codebase.

If something here is wrong, out of date, or unclear, please [open an issue](https://github.com/Autonoma-Tools/fly-io-vs-vercel/issues/new).

## License

Released under the [MIT License](./LICENSE) © 2026 Autonoma Labs.
