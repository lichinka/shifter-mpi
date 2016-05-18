NAME = shifter-mpi
VERSION = 0.3

all:
	docker build --rm=true --tag=$(NAME):$(VERSION) .

clean:
	docker rmi $(NAME):$(VERSION)
