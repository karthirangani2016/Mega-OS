#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "Committing and pushing build-everything workflow..."
git add .github/workflows/build-everything.yml
git commit -m "ci: add build-everything workflow (no docker)" || echo "Nothing to commit"
git push origin main
echo "Done! Check GitHub Actions tab in a few seconds."
