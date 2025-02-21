## TODO

Volume Types

- EmptyDir
- PVC
- ConfigMap
- Secret


## Definition


=== "Values"

    ``` yaml
    --8<-- "snippets/values/volumes.yaml"
    ```


=== "Deployment Manifest"

    ``` yaml
    --8<-- "snippets/manifests/deployment/cicd-sample-docs.yml"
    ```


`mounts`    

:   Defines list of mounts for containers. Format `key` - container name, `value` - mount path 