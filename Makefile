## Init Framework and Example projects
init:
	if ! gem spec bundler > /dev/null 2>&1; then\
  		echo "bundler gem is not installed!";\
  		sudo gem install bundler;\
	fi

	-bundle update
	-bundle install --path .bundle

	brew bundle --no-upgrade

	mkdir -p .git/hooks
	$(MAKE) install_hooks

	$(MAKE) projects

## Regenerate Framework and Example projects
projects:
	xcodegen generate
	-bundle install --path .bundle
	-bundle exec pod install

## Build Configuration
destination='platform=iOS Simulator,name=iPhone 14 Pro'
destination_tv='platform=tvOS Simulator,name=Apple TV'

## Build lib sources for **tvOS** platform
build_lib_tvOS:
	xcodebuild -scheme ReactiveDataDisplayManager_tvOS -sdk appletvsimulator -destination ${destination_tv}

## Build lib sources for **iOS** platform (produce xctestrun)
build_lib_iOS:
	xcodebuild -scheme ReactiveDataDisplayManager_iOS -sdk iphonesimulator -destination ${destination} build-for-testing

## Run tests of lib for **iOS** platform
test_lib_iOS:
	xcodebuild test-without-building -scheme ReactiveDataDisplayManager_iOS -configuration "Debug" -sdk iphonesimulator -enableCodeCoverage YES -destination ${destination} | bundle exec xcpretty -c | tee xcodebuild.log

## Count failures in xcodebuild.log and `exit 0` if no failures or `exit 1` otherwise
check_test_log:
	echo "Test results: xcodebuild.log"
	$(eval failures_count := $(shell cat xcodebuild.log | grep -Eo "[0-9]+ failures" | grep -Eo "[0-9]+"))
	echo "Failures count: $(failures_count)"
	@if [ $(failures_count) == "0" ]; then\
		echo "Tests passed";\
		exit 0;\
	else\
		echo "Tests failed";\
		exit 1;\
	fi

## Preparing report contains test-coverage results
prepare_report:
	bundle exec slather

## Build Example sources for **tvOS** platform
build_example_tvOS:
	xcodebuild -workspace ReactiveDataDisplayManager.xcworkspace -scheme ReactiveDataDisplayManagerExample_tvOS -sdk appletvsimulator -destination ${destination_tv}

## Build Example of usage with Swift Package Manager for specified **iOS** version
build_example_SPM:
	cd SPMExample
	swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios${version}-simulator"

## Build Example sources for **iOS** platform (produce xctestrun)
build_example_iOS:
	xcodebuild -workspace ReactiveDataDisplayManager.xcworkspace -scheme ReactiveDataDisplayManagerExample_iOS -sdk iphonesimulator -destination ${destination} build-for-testing

## Run tests of Example for **iOS** platform
test_example_iOS:
	xcodebuild test-without-building -workspace ReactiveDataDisplayManager.xcworkspace -scheme ReactiveDataDisplayManagerExample_iOS -configuration "Debug" -sdk iphonesimulator -enableCodeCoverage YES -destination ${destination} | bundle exec xcpretty -c | tee xcodebuild.log

## Preparing report contains test-coverage results
prepare_example_report:
	bundle exec slather coverage --workspace ReactiveDataDisplayManager.xcworkspace --scheme ReactiveDataDisplayManagerExample_iOS --binary-basename ReactiveDataDisplayManager --arch x86_64 --output-directory build/reports --cobertura-xml

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
	sed -E -i .back 's/MARKETING_VERSION: \"(.*)\"/MARKETING_VERSION: \"$(value)\"/' Example/targets/template.yml
	sed -E -i .back 's/MARKETING_VERSION: \"(.*)\"/MARKETING_VERSION: \"$(value)\"/' ReactiveDataComponents/project.yml


## Lint lib for cocoapods
lint_lib:
	bundle exec pod lib lint --allow-warnings

## Publish Lib in cocoapods
publish_lib:
	bundle exec pod trunk push --allow-warnings

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
