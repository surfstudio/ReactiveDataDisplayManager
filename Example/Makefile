## Installs all dependencies
init:
	# Install bundler if not installed
	if ! gem spec bundler > /dev/null 2>&1; then\
  		echo "bundler gem is not installed!";\
  		sudo gem install bundler;\
	fi

	-bundle update
	-bundle install --path .bundle

	$(MAKE) project

## Update pbxproj and workspace
project:
	xcodegen generate

	-bundle exec pod install

## Build Configuration
destination='platform=iOS Simulator,name=iPhone 8'

## Build Example sources for **iOS** platform (produce xctestrun)
build_example_iOS:
	xcodebuild -workspace ReactiveDataDisplayManagerExample.xcworkspace -scheme ReactiveDataDisplayManagerExample_iOS -sdk iphonesimulator -destination ${destination} build-for-testing

## Run tests of Example for **iOS** platform
test_example_iOS:
	xcodebuild test-without-building -workspace ReactiveDataDisplayManagerExample.xcworkspace -scheme ReactiveDataDisplayManagerExample_iOS -configuration "Debug" -sdk iphonesimulator -enableCodeCoverage YES -destination ${destination} | xcpretty -c

## Preparing report contains test-coverage results
prepare_report:
	-bundle exec slather coverage --workspace ReactiveDataDisplayManagerExample.xcworkspace --scheme ReactiveDataDisplayManagerExample_iOS --source-directory ReactiveDataDisplayManager --output-directory build/reports --cobertura-xml ReactiveDataDisplayManagerExample.xcodeproj

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
