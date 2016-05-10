#!/bin/bash

set -e

docker build --rm=true --tag=shifter-mpi:0.1 .
