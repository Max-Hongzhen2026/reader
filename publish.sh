#!/usr/bin/env bash
# Publish only this reader to Max-Hongzhen2026/reader using existing gh credentials.
set -euo pipefail

reader_repo='Max-Hongzhen2026/reader'
reader_source="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
for reader_command in gh git python3 curl; do
  command -v "$reader_command" >/dev/null || { printf 'Missing command: %s\n' "$reader_command" >&2; exit 1; }
done
for reader_file in index.html README.md .nojekyll; do
  test -f "$reader_source/$reader_file" || { printf 'Missing file: %s\n' "$reader_file" >&2; exit 1; }
done

printf 'Checking access to %s...\n' "$reader_repo"
reader_login="$(gh api user --jq .login)"
reader_allowed="$(gh api "repos/$reader_repo" --jq '.permissions.push == true and .permissions.admin == true')"
if [[ "$reader_allowed" != 'true' ]]; then
  printf 'The current GitHub account needs push and admin access to this repository to publish GitHub Pages.\n' >&2
  exit 1
fi
reader_branch="$(gh api "repos/$reader_repo" --jq .default_branch)"
reader_tmp="$(mktemp -d "${TMPDIR:-/tmp}/folio-publish.XXXXXX")"
trap 'rm -rf -- "$reader_tmp"' EXIT

printf 'Preparing the reader...\n'
gh repo clone "$reader_repo" "$reader_tmp/repository"
cd "$reader_tmp/repository"
if git rev-parse --verify HEAD >/dev/null 2>&1; then
  git checkout "$reader_branch"
else
  git symbolic-ref HEAD "refs/heads/$reader_branch"
fi
cp "$reader_source/index.html" "$reader_source/README.md" "$reader_source/.nojekyll" .
cp "$reader_source/publish.sh" .
git add -- index.html README.md .nojekyll publish.sh
if ! git diff --cached --quiet; then
  git -c "user.name=$reader_login" -c "user.email=$reader_login@users.noreply.github.com" commit -m 'Publish Folio with open-access article and paper switcher'
fi
git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push origin "HEAD:$reader_branch"
reader_commit="$(git rev-parse HEAD)"

printf 'Configuring GitHub Pages...\n'
python3 - "$reader_branch" > "$reader_tmp/pages-input.json" <<'PY'
import json,sys
json.dump({'build_type':'legacy','source':{'branch':sys.argv[1],'path':'/'}},sys.stdout)
PY
if gh api "repos/$reader_repo/pages" > "$reader_tmp/pages.json" 2> "$reader_tmp/pages-error.txt"; then
  gh api --method PUT "repos/$reader_repo/pages" --input "$reader_tmp/pages-input.json" --silent
else
  if ! python3 - "$reader_tmp/pages-error.txt" <<'PY'
import sys
sys.exit(0 if 'HTTP 404' in open(sys.argv[1]).read() else 1)
PY
  then
    cat "$reader_tmp/pages-error.txt" >&2
    exit 1
  fi
  gh api --method POST "repos/$reader_repo/pages" --input "$reader_tmp/pages-input.json" --silent
fi
reader_url="$(gh api "repos/$reader_repo/pages" --jq .html_url)"
printf 'Waiting for publication (usually 1–3 minutes)...\n'
for reader_attempt in {1..36}; do
  if gh api "repos/$reader_repo/pages/builds/latest" > "$reader_tmp/build.json" 2>/dev/null; then
    reader_build_status="$(python3 - "$reader_tmp/build.json" <<'PY'
import json,sys
print(json.load(open(sys.argv[1])).get('status',''))
PY
)"
    reader_build_commit="$(python3 - "$reader_tmp/build.json" <<'PY'
import json,sys
print(json.load(open(sys.argv[1])).get('commit',''))
PY
)"
    if [[ "$reader_build_status" == 'errored' && "$reader_build_commit" == "$reader_commit" ]]; then
      python3 - "$reader_tmp/build.json" <<'PY'
import json,sys
b=json.load(open(sys.argv[1]));print('GitHub Pages build failed:',b.get('error',{}).get('message','See repository Actions.'))
PY
      exit 1
    fi
  fi
  if curl --fail --silent --show-error --location --max-time 15 "${reader_url}?folio-check=${reader_commit}" -o "$reader_tmp/published.html" 2>/dev/null; then
    if cmp -s index.html "$reader_tmp/published.html"; then
      printf '\nPublished and verified:\n%s\n\nFocus view:\n%s?focus=1\n' "$reader_url" "$reader_url"
      exit 0
    fi
  fi
  if (( reader_attempt % 3 == 0 )); then printf 'Still waiting for the new page (%s/36)...\n' "$reader_attempt"; fi
  sleep 5
done
printf '\nSource uploaded, but publication could not yet be verified.\nCheck: https://github.com/%s/actions\nExpected URL: %s\n' "$reader_repo" "$reader_url" >&2
exit 1
