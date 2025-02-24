## Definition


=== "Values"

    ``` yaml
    --8<-- "snippets/values/workload-common.yaml"

    --8<-- "snippets/values/containers.yaml"

    --8<-- "snippets/values/CronJob.yaml"
    ```



=== "Deployment Manifest"

    ``` yaml
    --8<-- "snippets/manifests/Deployment/cicd-sample-docs.yml"
    ```

=== "CronJob Manifest"

    ``` yaml
    --8<-- "snippets/manifests/CronJob/cicd-sample-docs-cleanup.yml"
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
      failureThreshold: 20
      httpGet:
        path: /healthcheck/live
        port: 8080
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 10
    livenessProbe:
      failureThreshold: 5
      httpGet:
        path: /healthcheck/live
        port: 8080
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 10
    readinessProbe:
      httpGet:
        path: /healthcheck/ready
        port: 8080
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 10
    ```


## Validations

- Container `id` is unique with respect to `application` container, init containers and sidecars in scope of same workload


## Overrides

`spec.name`

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
