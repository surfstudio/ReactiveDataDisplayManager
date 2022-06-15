## Init Framework and Example projects
init:
	brew bundle --no-upgrade

	mkdir -p .git/hooks
	$(MAKE) install_hooks

	xcodegen generate

	cd Example; make init

## Regenerate Framework and Example projects
projects:
	xcodegen generate

	cd Example; make project

## Build Configuration
destination='platform=iOS Simulator,name=iPhone 8'

## Build lib sources for **tvOS** platform
build_lib_tvOS:
	xcodebuild -target ReactiveDataDisplayManager_tvOS

## Build lib sources for **iOS** platform (produce xctestrun)
build_lib_iOS:
	xcodebuild -scheme ReactiveDataDisplayManager_iOS -sdk iphonesimulator -destination ${destination} build-for-testing

## Run tests of lib for **iOS** platform
test_lib_iOS:
	xcodebuild test-without-building -scheme ReactiveDataDisplayManager_iOS -configuration "Debug" -sdk iphonesimulator -enableCodeCoverage YES -parallel-testing-enabled YES -destination ${destination} | xcpretty -c

## Build example sources
build_example_iOS:
	cd Example; make build_example_iOS

## Run tests of example
test_example_iOS:
	cd Example; make test_example_iOS

## Install concrete hook with {name}
install_hook:
	chmod +x hooks/$(name)
	ln -s -f ../../hooks/$(name) .git/hooks/$(name)

## Install all git hooks
install_hooks:
	$(MAKE) install_hook name=post-checkout
	$(MAKE) install_hook name=post-merge

## Update version to {value}
update_version:
	sed -E -i .back 's/MARKETING_VERSION: \"(.*)\"/MARKETING_VERSION: \"$(value)\"/' project.yml
	sed -E -i .back 's/MARKETING_VERSION: \"(.*)\"/MARKETING_VERSION: \"$(value)\"/' Example/project.yml

## Lint lib for cocoapods
lint_lib:
	pod lib lint --allow-warnings

## Publish Lib in cocoapods
publish_lib:
	pod trunk push --allow-warnings

## Colors
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

TARGET_MAX_CHAR_NUM=20
## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
