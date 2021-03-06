NAME = sunfoxcz/sphinx
VERSION = 2.2.9

.PHONY: all build tag_latest release

all: build

build:
	docker build -t $(NAME):$(VERSION) --rm .

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
