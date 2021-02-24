# Contributing guide

Thank you for your help! Before you start, let's take a look at some agreements.

## Versioning

Version format is `x.y.z` where
- x is major version number. Bumped only in major updates (implementaion changes, adding new functionality)
- y is minor version number. Bumped only in minor updates (interface changes)
- z is minor version number. Bumped in case of bug fixes and e.t.c.

## Branch name

We are developing with minimal Git-flow.
Base your branch from `develop` and select name with one from pattern

- bugfix/{issue_number}/{description} - for fixing small issues
- feature/{issue_number}/{description} - for adding new functionality
- hotfix/{description} - for fixing very small issues without discovered issues (like fixing unit tests, fixing typo etc)

## Pull request rules

Make sure that your code:

- [ ]	Does not contain errors
- [ ]	New functionality is covered by tests and new functionality passes old tests
- [ ]	Create example that demonstrate new functionality if it is possible

## Accepting the changes

After your pull request passes the review code, the project maintainers will merge the changes
into the branch to which the pull request was sent.

## Issues

Feel free to report any issues and bugs.

1.	To report about the problem, create an issue on GithHub
2.	In the issue add the description of the problem
3.	Do not forget to mention your development environment, Xcode version, iOS version, frameworks required for
    illustration of the problem
4.	It is necessary to attach the code part that causes an issue or to make a small demo project
    that shows the issue
5.	Attach stack trace so it helps us to deal with the issue
6.	If the issue is related to layout or animation, screen recording is required
