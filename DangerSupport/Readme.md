
We use [danger-swift](https://github.com/danger/swift) to improve our code review.

If you want to edit some danger rules - please read this overview.

- Run `cd DangerSupport`
- Run `swift build`
- Run `swift danger-swfit edit`

After all yo will get xcode opened.

You have full access to `Danger.DSL` to work with git data.
Also you can use `Foundation` and other standart swift libraries to make some cool custom rules.

Press enter to finish editing of config file.
At the end just copy and replace *Dangerfile.swift* to the root of the project.

Next pull request will use new rules.

That is allю
