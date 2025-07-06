## Definition


=== "Values"

    ``` yaml
    --8<-- "snippets/values/workload.yaml"

    --8<-- "snippets/values/containers.yaml"

    --8<-- "snippets/values/cronjobs.yaml"
    ```



=== "Deployment Manifest"

    ``` yaml
    --8<-- "snippets/manifests/deployment/Deployment/cicd-sample-docs.yml"
    ```

=== "CronJob Manifest"

    ``` yaml
    --8<-- "snippets/manifests/deployment/CronJob/cicd-sample-docs-cleanup.yml"
    ```

`image`    

:   Docker image to use for container

    `registry`

    :   registry to load image from 

        **default:** `Values.registry` with fallback to `docker.io`

    `repository`

    :   repository of the image

        **default:** `Values.repository`

    `version`

    :   version (tag) of the image

        **default:** `Values.version` 


`spec`

:   Container spec

    **default:**
     
    ``` yaml
    envFrom: []
    volumeMounts: []
    imagePullPolicy: IfNotPresent
    resources:
      limits:
        cpu: 200m
        memory: 256Mi
      requests:
        cpu: 50m
        memory: 64Mi
    ```

    for application container default `spec` is extended with default probes

    ``` yaml
    startupProbe:
      failureThreshold: 30
      periodSeconds: 5
      successThreshold: 1
      timeoutSeconds: 1
      tcpSocket:
        port: 80 # first exposed TCP port
    livenessProbe:
      failureThreshold: 30
      periodSeconds: 10
      successThreshold: 1
      timeoutSeconds: 1
      tcpSocket:
        port: 80 # first exposed TCP port
    readinessProbe:
      failureThreshold: 30
      periodSeconds: 10
      successThreshold: 1
      timeoutSeconds: 1    
      tcpSocket:
        port: 80 # first exposed TCP port
    ```

    `tcpSocket` is added only if container has exposed ports with protocol `TCP` (otherwise default default probe is generated without probe type and has no effect) , actual port number is populated as number of first exposed port. 
     


## Validations

- Container `id` is unique with respect to `application` container, init containers and sidecars in scope of same workload


## Overrides

`metadata.name`

:   `name` is generated from id (assumed to be `application` for application container) by [convention](../naming conventions.md)
 
`spec.image`

: is generated from container  `.image.repository`,`.image.registry` and `.image.version`


## Manifests Generation 

- `spec.envFrom`  is with references to application defined [ConfigMaps](../Resources/external-secret.md) if config map is in the same namespace
- `spec.envFrom`  is with references to application defined [Secrets](../Resources/secret.md) if secret is in the same namespace
- `spec.envFrom`  is with references to application defined [External Secrets](../Resources/external-secret.md) if secret is in the same namespace
- `spec.volumeMounts`  is extended as per [Volume](./volumes.md)
- Application container spec is added to [workload](../index.md#workload) manifest `containers` if  [workload](../index.md#workload) is not set to `none`
- Sidecar container specs are added to [workload](../index.md#workload) manifest `containers` if  [workload](../index.md#workload) is not set to `none`
- Init containers specs is added to [workload](../index.md#workload) manifest `initContainers` if  [workload](../index.md#workload) is not set to `none`
