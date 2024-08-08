[x] defaults should contain only yamls with defaults for entities
[x] datafolders - instead of independently building volumes from data folders and volumes need to extends volumes with generated from data folders and build (less copy paste artefacts)
[x] same for sidecars and main container - build containers collection and render it 
[x] contaner defaults likely should be hierarchical
[x] ingresses
[x] services
[x] secrets are not linked to containers (secretRef/secretRef and checksum in anotations to force refresh on secrets change)
[x] values schema does not validate ingresses
[x] ingresses should be dict instead of array in values
[x] entities name uniquiness is not validated. possible conflicts:
    - data folder vs init container
    - data folder vs volume
    - sidecar named "applictaionContainer"
[X] naming templates should have same args in the same order 
[x] ugly set of selectors in services.yaml
[x] store logs and outut on fail
[ ] service monitors
[ ] sidecar probes are missing and not clear what there should be by default
[ ] certificates and ingress tls
[ ] naming convention may generate name that does not fit 63
[ ] values json schema is not complete
[ ] checksum annotations 
    - is checksum annotations needed both in deployment metadata and in deployment.template metadata?
[ ] docs for moudules/entities approach
[ ] what is 'refreshInterval: 1m' in external secret manifest an dhow to set it properly
[ ] fix tests