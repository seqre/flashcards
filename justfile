default:
	@just --choose

[working-directory("Space Technologies Master's Degree")]
list-todos:
	@clear && rg -g '!justfile' --sort path --no-heading --color never 'TODO' \
	| awk -F: '{ path = $1; sub(/^[^:]*:/, ""); \
		sub(/^[[:space:]]*\/\/[[:space:]]*TODO:?[[:space:]]*/, ""); \
		dir = path; sub(/\/[^\/]*$/, "", dir); \
		file = path; sub(/.*\//, "", file); sub(/\.cards$/, "", file); \
		if (dir != last) { if (NR > 1) print ""; print "\033[1;35m" dir "\033[0m"; last = dir } \
		print "  \033[32m" file "\033[0m: " $0 }'

build-agh:
	@ankigen build "Space Technologies Master's Degree" -o agh.apkg
	@echo "REMEMBER TO COMMIT NEW CARD AND DECK IDS"
	@git add -p

edit-agh:
	@ranger "Space Technologies Master's Degree/Semester 0"

# two-way sync of every media/ folder with the same tree in dir (newer file wins, nothing is deleted)
[no-cd]
sync-media dir:
	#!/usr/bin/env bash
	set -euo pipefail
	repo={{ quote(justfile_directory()) }}
	dir={{ quote(dir) }}
	opts=(-rtuOm --exclude=.git --include='*/' --include='media/**' --exclude='*')
	rsync "${opts[@]}" --out-format='-> %n' -- "$repo/" "$dir/"
	rsync "${opts[@]}" --out-format='<- %n' -- "$dir/" "$repo/"

# give every SVG a white background (skips files that already have it)
add-white-background:
	@rg --no-ignore -0 --files-without-match -F ':root{background:white}' -g '*.svg' . \
	| xargs -0 -r sed -i 's|</svg>|<style>:root{background:white}</style></svg>|'
