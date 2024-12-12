# docker is very slow when working with windows mounted as  volume 
# so mounting it to /src and copying to /apps and run helm unittest there for it to work with linux filesystem
# better solution would be to install helm-unitest on windows but it fails 
docker run -ti --rm -v .:/src --entrypoint /bin/sh helmunittest/helm-unittest:3.15.4-0.6.0 -c "cp -R /src/* /apps && cd /apps && helm unittest . $args && rm -rf /src/tests/__snapshot__ && cp -R /apps/tests/__snapshot__ /src/tests/"