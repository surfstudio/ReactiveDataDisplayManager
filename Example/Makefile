## Installs all dependencies
init:
	# Install bundler if not installed
	if ! gem spec bundler > /dev/null 2>&1; then\
  		echo "bundler gem is not installed!";\
  		sudo gem install bundler;\
	fi

	if ! xcodegen help > /dev/null 2>&1; then\
		echo "Needs to install Xcodegen";\
		sh scripts/add_xcodegen.sh;\
	fi

	-bundle update
	-bundle install --path .bundle
	-bundle exec pod repo update

	xcodegen generate

	-bundle exec pod install

## Update pbxproj and workspace
project:
	xcodegen generate

	-bundle exec pod install
