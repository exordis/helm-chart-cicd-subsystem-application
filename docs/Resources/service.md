## Definition



=== "Values"

    ``` yaml
    --8<-- "snippets/values/services.yaml"
    ```

=== "Service Manifest"

    ``` yaml
    --8<-- "snippets/manifests/Service/cicd-sample-docs-full.yml"
    ```

=== "ServiceMonitor Manifest"

    ``` yaml
    --8<-- "snippets/manifests/ServiceMonitor/cicd-sample-docs-full.yml"
    ```


`namespace`

:   service namespace

    **default:** subsystem namespace generated with [naming conventions](../naming conventions.md)

`labels`

:   list of labels to add to service in addition to [common labels](../common metadata.md)

    **default:** empty dict

`annotations`

:   list of annotations to add to service in addition to [common annotations](../common metadata.md)

    **default:** empty dict

`spec`

:   service kubernetes manifests `spec` field value. 
    
    `spec.ports` is ignored and generated based on `service.ports`. 
    
    `spec.selector` is ignored and generated to match application workload

    **default:** empty dict


`ports`

:   service ports dictionary with port name as key. 

    **default:** empty dict

    Port definition: 

    `port` 
    
    : service port number

    `targetPort` 

    : target container port name (recommended) or number

    `protocol` 
    
    : protocol `TCP` (default), `UDP` or `STCP`

    `monitorEndpoint` 
    
    : endpoint definition for service monitor 


`monitor`

: service monitor

    `annotations` 
    
    : annotations to add to service monitor  in addition to [common annotations](../common metadata.md).  
        **default:** empty dict
    
    `labels`  
    : labels to add to service monitor in addition to [common annotations](../common metadata.md).  
        **default:** empty dict


    `namespace`

    :   service namespace

        **default:** subsystem namespace generated with [naming conventions](../naming conventions.md)

    `spec` 
    
    : service monitor manifest `spec` field. 
        
        `namespaceSelector` and `selector` are ignored and generated to match the service

        `endpoints` is ignored and generated from service `ports` (as defined by `ServiceMonitor` CRD)

        **default:** `jobLabel: <service id>`


### Minimum Viable Service Definition

- Default metadata
- Single port named `http` with  default 80 port number 
- Service is mapped to workload container ports named the same as service port - `http`      
- No service monitor

``` yaml

applicationContainer:
  spec:
    ports:
      - containerPort: 8080
        name: http  

services:
  minimum: 
    ports:
      http:
```

## Validations

- Port referenced in service is not exposed by `applicationContainer` or any of `sidecars`

## Overrides

`name`

:   generated with [naming conventions](../naming conventions.md) from service `id`

`spec.selector`

:   generated to match application workload


## Manifests Generation 


### Service

Service manifest is generated for each service. 

- [common annotations](../common metadata.md) are added to metadata


!!! Note

    If `Values.workload` is `none` service will be generated with selector matching no pods 

### Service Monitor

- [common annotations](../common metadata.md) are added to metadata
- Service monitor is generated if service defines at least one port with `monitorEndpoint` (may be null)
- Service monitor `id` is considered to be equal to service `id`
- Service monitor is generated with [naming conventions](../naming conventions.md) 


 