NAME = shifter-mpi
VERSIONS = 0.3 0.4 nersc

all: $(VERSIONS)

$(VERSIONS):
	docker build --rm=true --tag=$(NAME):$@ --file=Dockerfile.$@ .

clean:
	@$(foreach ver,$(VERSIONS),docker rmi shifter-mpi:$(ver);)
