helm dependency update
helm dependency build
docker run --user 0 -ti --rm -v .:/src -w /src --entrypoint /bin/sh helmunittest/helm-unittest:3.16.3-0.7.0 -c "/bin/sh ./unittests.sh $args" 
