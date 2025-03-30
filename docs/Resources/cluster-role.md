---
title: Cluster Role
---

## Definition



=== "Values"

    ``` yaml
    --8<-- "snippets/values/workload.yaml"
    --8<-- "snippets/values/clusterRoles.yaml"
    ```


=== "ClusterRole Manifests"

    ``` yaml
    
    --8<-- "snippets/manifests/ClusterRole/cicd-test-sample-docs-application.yml"
    
    ```



`enabled`

:   if set to false cluster role is excluded from rendering

    **default:** true

`labels`

:   list of labels to add to secret in addition to [common labels](../common metadata.md)

    **default:** empty dict

`annotations`

:   list of annotations to add to secret in addition to [common labels](../common metadata.md)

    **default:** empty dict

`rules`

:   Cluster role rules


## Validations

- Cluster Role  `id` is unique


## Overrides

`metadata.name`

:   `name` is generated from id by [convention](../naming conventions.md)
 

## Manifests Generation 

- [common labels](../common metadata.md) are added to metadata
- ClusterRole manifest is generated for each cluster role.
