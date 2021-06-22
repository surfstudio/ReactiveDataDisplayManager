# Release guide

This document contains steps needed for preparing release of new version of library.

## Check stability of develop branch

- [x] Framework is building without any errors
- [x] Example project for pods version is building without any errors
- [x] Example project for swift package manager version is building without any errors
- [x] Branch is not contain any unfinished work like: partially implemented plugins or not tested platform support

## Update versions

- [x] Run command `make versionUpdate value={version number}` in terminal
- [x] Update Changelog.md

This will update versions in `project.yml` files

## Lint library

- [x] Run command `make lintLib` in terminal

This will check that library is ready for delievering through cocoapods.

If this command found some **errors** than you must **resolve** them.

## Publish library

- [x] Merge version updates to branch `develop`
- [x] Merge `develop` to `master`
- [x] Create tag with version number from previous step
- [x] Create release on Github with copy of changes from changelog.md
- [x] Run command `make publishLib` in terminal to publish in cocoapods

At last step you should have authorized access to push new version.
Request the confirmation from project owner.
