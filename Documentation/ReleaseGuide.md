# Release guide

This document contains steps needed for preparing release of new version of library.

## Check stability of develop branch

[*] Framework is building without any errors
[*] Example project for pods version is building without any errors
[*] Example project for swift package manager version is building without any errors
[*] Branch is not contain any unfinished work like: partially implemented plugins or not tested platform support

## Update versions

[*] Run command `make versionUpdate value={version number}` in terminal
[*] Update Changelog.md

This will update versions in `project.yml` files

## Lint library

[*] Run command `make lintLib` in terminal

This will check that library is ready for delievering through cocoapods.

If this command found some **errors** than you must **resolve** them.

## Publish library

[*] Merge version updates to branch `develop`
[*] Merge `develop` to `master`
[*] Create tag with version number from previous step
[*] Create release on Github with copy of changes from changelog.md
[*] Run command `make publishLib` in terminal to publish in cocoapods

At last step you should have authorized access to push new version.
Request the confirmation from project owner.
