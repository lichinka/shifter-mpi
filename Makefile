NAME = shifter-mpi
VERSIONS = 0.3 nersc

all: $(VERSIONS)

$(VERSIONS):
	docker build --rm=true --tag=$(NAME):$@ --file=Dockerfile.$@ .

clean:
	$( shell docker rmi $( docker images -q $(NAME) ) )
