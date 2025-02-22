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


`spec`    

:   Defines volume spec

**default:** 

if none of `pvc` `configMap` `secret` is defined 
```
emptyDir:
  sizeLimit: 100Mi
```


`pvc`

:   Defines [PVC](../Resources/pvc.md)` id to use in spec 

    - generates volume of `persistentVolumeClaim` type if `spec` is not provided
    - puts [PVC](../Resources/pvc.md) name to `spec.persistentVolumeClaim.claimName:`  if `claimName` is not provided explicitly

`configMap`

:   Defines [ConfigMap](../Resources/configmap.md) id to use in spec 

    - generates volume of `configMap` type if `spec` is not provided and `pvc` is not defined
    - puts [ConfigMap](../Resources/configmap.md) name to `spec.configMap.name:` and `projected.sources[?(@.configMap)].name:` if any of these is defined in `spec` without explicit  `name`.

`secret`

:   Defines [Secret](../Resources/secret.md) or [ExternalSecret](../Resources/external-secret.md) id to use in spec 

    - generates volume of `secret` type if `spec` is not provided and neither `pvc` nor `configMap` is defined
    - puts [Secret](../Resources/secret.md) name (target secret name for [ExternalSecret](../Resources/external-secret.md)) to `spec.secret.secretName:` and `projected.sources[?(@.secret)].secretName:` if any of these is defined in `spec` without explicit `secretName`




## Validations

- `pvc` references exiting [PVC](../Resources/pvc.md) id and it has same namespace as volume workload
- `configMap` references exiting [ConfigMap](../Resources/configmap.md) id and it has same namespace as volume workload
- `secret` references exiting [Secret](../Resources/secret.md) or [ExternalSecret](../Resources/external-secret.md) id and it has same namespace as volume workload

## Overrides

`spec.name`

:   `name` is generated from id by [convention](../naming conventions.md)
 

## Manifests Generation 

- Volume is added to [workload](../values.md#workload) manifest `volumes` and volume spec is added to  `spec.volumeMounts` of main workload , if  [workload](../values.md#workload) is not set to `none`
