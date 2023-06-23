#!/bin/bash

token="YOUR_PERSONAL_ACCESS_TOKEN" # Your Token Here

owner="Vanilla-OS" # Example, change it to your org/user.

repositories=(
  "vanilla-os-build"
  "first-setup"
  "ppa"
  "plymouth-theme-vanilla"
  "vanilla-distrologo"
  "os"
  "calamares-settings-vanilla"
  ".github"
  "assets"
  "apx"
  "almost"
  "testing-issues"
  "documentation"
  "website"
  "vanilla-beta-notice"
  "almost-extras"
  "vanilla-control-center"
  "dev-help-tools"
  "micro-distrobox"
  "vanilla-backgrounds"
  "info"
  "base-files"
  "vanilla-updater"
  "repository"
  "distinst"
  "vanilla-installer"
  "handbook"
  "gnome-control-center"
  "kernelstub"
  "adwaita-icon-theme"
) # selected repos will be here

echo "Unique contributors:"
all_contributors=()

for repository in "${repositories[@]}"; do
  echo "Contributors for repository: ${repository}"
  response=$(curl -s -H "Authorization: token $token" "https://api.github.com/repos/$owner/${repository}/contributors")

  if [[ -n "$response" ]]; then
    contributors=($(echo "$response" | grep -oE '"login": "[^"]+"' | cut -d'"' -f4 | grep -Ev 'weblate|dependabot'))

    if [[ ${#contributors[@]} -gt 0 ]]; then
      unique_contributors=($(echo "${contributors[@]}" | tr ' ' '\n' | sort -u))
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
  else
    echo "No contributors found."
    echo
  fi
done

echo "Combined unique contributors:"
unique_all_contributors=($(echo "${all_contributors[@]}" | tr ' ' '\n' | sort -u | grep -Ev 'weblate|dependabot'))
for contributor in "${unique_all_contributors[@]}"; do
  echo "* [@${contributor}](https://github.com/${contributor})"
done

echo "Total combined contributors: ${#unique_all_contributors[@]}"
