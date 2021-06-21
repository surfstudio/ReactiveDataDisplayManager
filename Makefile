# Init Framework and Example projects
init:
	xcodegen generate

	cd Example; make init

# Init Framework and Example projects
projects:
	xcodegen generate

	cd Example; make project

# Install git hooks
hooks:

	chmod +x post-checkout
	ln -s -f ../../post-checkout .git/hooks/post-checkout

	chmod +x post-merge
	ln -s -f ../../post-merge .git/hooks/post-merge

# Update version
versionUpdate:
	sed -E -i .back 's/MARKETING_VERSION: \"(.*)\"/MARKETING_VERSION: \"$(value)\"/' project.yml
	sed -E -i .back 's/MARKETING_VERSION: \"(.*)\"/MARKETING_VERSION: \"$(value)\"/' Example/project.yml

# Lint lib for cocoapods
lintLib:
	pod lib lint --allow-warnings

# Publish Lib in cocoapods
publishLib:
	pod trunk push --allow-warnings
