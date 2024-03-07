NAME=nf-figtree
TAG:=$(shell /bin/date +%Y%m%d%H%M%S)
REGISTRY=458432034220.dkr.ecr.us-west-2.amazonaws.com/$(NAME)

all: build push run

build:
	docker image build -t $(NAME):$(TAG) -t $(NAME):latest -f Dockerfile .
	docker image tag $(NAME):latest $(REGISTRY):latest
	docker image tag $(NAME):$(TAG) $(REGISTRY):$(TAG)

push:
	docker image push $(REGISTRY):$(TAG)
	docker image push $(REGISTRY):latest
	echo "fischbachlab/$(NAME):$(TAG)" > LATEST

run:
	docker container run --rm $(NAME):latest
