## Definition


=== "Values"

    ``` yaml
    --8<-- "snippets/values/secrets.yaml"
    ```

=== "Secret Manifests"

    ``` yaml
    --8<-- "snippets/manifests/Secret/cicd-sample-docs-secret-full-metadata.yml"
    ```

    ``` yaml
    --8<-- "snippets/manifests/Secret/cicd-sample-docs-secret-with-containers.yml"
    ```

    ``` yaml
    --8<-- "snippets/manifests/Secret/cicd-sample-docs-secret-without-containers.yml"
    ```

=== "Deployment Manifest"

    ``` yaml
    --8<-- "snippets/manifests/Deployment/cicd-sample-docs.yml"
    ```

=== "CronJob Manifest"

    ``` yaml
    --8<-- "snippets/manifests/CronJob/cicd-sample-docs-cleanup.yml"
    ```

`enabled`

:   if set to false secret is excluded from rendering

    **default:** true


`namespace`

:   secret namespace

    **default:** subsystem namespace generated by convention

`labels`

:   list of labels to add to secret in addition to [common labels](../common metadata.md)

    **default:** empty dict

`annotations`

:   list of annotations to add to secret in addition to [common labels](../common metadata.md)

    **default:** empty dict

`containers`

:   list of container ids to add `secretRef` for the secret. If  `containers` is not provided, `secretRef` would be added to all containers in secret namespace.
    Batch workloads should be referenced as `[workload collection].[workload id].[container id]` e.g `cronjobs.cleanup.main`


    **default:** nil (add `secretRef` to all containers)

`type`

:   `type` to be added to secret manifest

    **default:** Opaque

`data`

:   `data` to be added to secret manifest

    **default:** empty dict

`stringData`

:   `stringData` to be added to secret manifest

    **default:** empty dict



## Validations

- Secret `id` is unique with respect to [external secrets](external-secret.md) ids
- Each item in `containers` references existing container
- Each item in `containers` references container from the same namespace as secret

## Overrides

`name`

:   `name` is generated from id by [convention](../naming conventions.md)


## Manifests Generation 

- [common labels](../common metadata.md) are added to metadata
- `secretRef` is added to containers with ids listed in `secret.containers` (all if this field is not set)
- annotation with checksum of configmap is added to workloads manifests if at least one container of has `secretRef` added
- secret manifest is generated each secret
 