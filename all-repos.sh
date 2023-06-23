#!/bin/bash

token="" # your token here

owner="Vanilla-OS" # this is an example, change this to your org/user.

echo "Fetching repositories..."
mapfile -t repositories < <(curl -s -H "Authorization: token $token" "https://api.github.com/orgs/$owner/repos" | jq -r '.[].name') # remove "org" if needed

echo "Unique contributors:"
all_contributors=()

for repository in "${repositories[@]}"; do
  echo "Contributors for repository: $repository"
  mapfile -t contributors < <(curl -s -H "Authorization: token $token" "https://api.github.com/repos/$owner/$repository/contributors" | jq -r '.[].login' | grep -Ev 'weblate|dependabot')

  if [[ ${#contributors[@]} -gt 0 ]]; then
    unique_contributors=()
    mapfile -t unique_contributors < <(printf '%s\n' "${contributors[@]}" | sort -u)
    all_contributors+=("${unique_contributors[@]}")

    for contributor in "${unique_contributors[@]}"; do
      echo "* [@${contributor}](https://github.com/${contributor})"
    done

    echo "Total contributors: ${#unique_contributors[@]}"
    echo
  else
    echo "No contributors found."
    echo
  fi
done

echo "Combined unique contributors:"
unique_all_contributors=()
mapfile -t unique_all_contributors < <(printf '%s\n' "${all_contributors[@]}" | sort -u | grep -Ev 'weblate|dependabot')
for contributor in "${unique_all_contributors[@]}"; do
  echo "* [@${contributor}](https://github.com/${contributor})"
done

echo "Total combined contributors: ${#unique_all_contributors[@]}"
