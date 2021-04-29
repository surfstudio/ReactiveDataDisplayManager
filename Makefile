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
