BLOG_URL := http://localhost:4000

install:
	gem install jekyll bundler
	bundle install && bundle update

start:
	xdg-open $(BLOG_URL) || open $(BLOG_URL)
	bundle exec jekyll serve

.PHONY: install start
