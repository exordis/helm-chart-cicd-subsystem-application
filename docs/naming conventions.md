---
order: 3
render_macros: false
---

Naming conventions are defined with `global.naming` and split in groups `kinds`, `components`, `metadata`. Each group has its own variables available for templating.

All names are converted to lower case after templating


## Default Naming Convention

``` yaml
global:
  naming:
    kinds:
      Namespace:              "{{.subsystem}}-{{.environment}}-{{.id}}" 
      ClusterSecretStore:     "{{.subsystem}}-{{.environment}}-{{.id}}" 
      Deployment:             "{{.subsystem}}-{{.application}}-{{.instance}}"
      CronJob:                "{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}"
      ConfigMap:              "{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}"
      Secret:                 "{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}"
      ExternalSecret:         "{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}"
      Ingress:                "{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}"
      PersistentVolumeClaim:  "{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}"
      ServiceMonitor:         "{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}"
      Service:                "{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}"
    components:
      Container: '{{ .id }}'
      Volume: "{{ .id }}"
    metadata:
      application-canonical-name: "{{.subsystem}}-{{.application}}"
```
## Groups 

### Kinds

Defines naming of kubernetes kinds. Available variables:

`subsystem`

:   Subsystem name, the value of `Values.global.subsystem`

`environment`

:   Environment name, the value of `Values.global.environment` 

`application`

:   Application name, the value of `Values.application` 

`applicationType`

:   Application name, the value of `Values.applicationType` 

`instance`

:   Application name, the value of `Values.instance` 

`kind`

:   Entity kind. E.g. for [ConfigMap](Resources/configmap.md) it is `ConfigMap` 

`id`

:   Entity id. E.g. for [ConfigMap](Resources/configmap.md) it is key from `Values.configmaps` dict


### Components

Defines naming of components ([Containers](Components/containers.md), [Volumes](Components/volumes.md)). Available variables:

`subsystem`

:   Subsystem name, the value of `Values.global.subsystem`

`environment`

:   Environment name, the value of `Values.global.environment` 

`application`

:   Application name, the value of `Values.application` 

`applicationType`

:   Application name, the value of `Values.applicationType` 

`instance`

:   Application name, the value of `Values.instance` 


`kind`

:   Component kind. 

    For [Container](Components/containers.md) it is `Container` 

    For [Volume](Components/volumes.md) it is `Volume` 

`id`
:   Component id.

    For [Container](Components/containers.md) it is `application` for application container or key from `Values.containers`, `Values.sidecars`, `Values.cronjobs[].containers`, `Values.sidecars` 

    For [Volume](Components/volumes.md) it is key from `Values.volumes`, `Values.cronjobs[].volumes` or [pvc](Resources/pvc.md) `id` if volume is generated form pvc `mounts`




### Metadata

Defines values for metadata. Available variables:

`subsystem`

:   Subsystem name, the value of `Values.global.subsystem`

`environment`

:   Environment name, the value of `Values.global.environment` 

`application`

:   Application name, the value of `Values.application` 

`applicationType`

:   Application name, the value of `Values.applicationType` 

`instance`

:   Application name, the value of `Values.instance` 


#### Values

`application-canonical-name`

:   Application canonical name. Used in multiple places to identify the application.