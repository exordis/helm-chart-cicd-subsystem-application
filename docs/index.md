---
order: 1
---


This Helm chart provides a **streamlined and validated** approach to deploying applications in Kubernetes, significantly **reducing configuration effort** compared to pure Helm. 

It **enforces best practices, automates naming conventions, and adds built-in validation**, ensuring that deployments are **consistent, reliable, and easy to manage**.

An **application** is a standalone software unit that provides specific functionality within a **subsystem**. This chart ensures that applications are deployed in a **structured, unified, and validated manner**, reducing complexity and operational overhead.

**:material-github: [Source](https://github.com/exordis/helm-chart-cicd-subsystem-application)**


## Key Benefits:

- **Less Configuration, Faster Deployment** – Predefined defaults and structured settings eliminate the need for extensive customization.
- **Built-in Validation** – Prevents misconfigurations by enforcing Kubernetes naming constraints and required values.
- **Consistent Naming Conventions** – Automatically generates resource names to ensure clarity and avoid conflicts.
- **Preconfigured Workloads** – Supports microservices and web applications with minimal setup effort.
- **Metadata-Driven Configuration** – Injects key metadata into application pods as environment variables.
- **Unified Deployments Across Applications** – Ensures that all applications within a **structured environment** follow a consistent deployment pattern, improving maintainability.

## Why This Chart?

In pure Helm, deployments require **manual validation, careful naming, and extensive configuration** to ensure consistency. This chart **automates these aspects**, providing **smart defaults, validation mechanisms, and enforced unification**, allowing applications to be deployed quickly, reliably, and with **minimal manual input**.

## Getting Started with a Sample  

If you prefer to start with a practical example, jump to the [Real World Samples](#real-world-samples) section to see Helm chart values in action. These examples provide ready-to-use configurations that demonstrate common deployment scenarios.


## Installation

```
helm install \
    oci://ghcr.io/exordis/helm-charts/cicd-subsystem-application \
    --version {{ package_version() }}
```


## Values

### Key Principles

- **Single application deployment** – There is only one workload for the application. 
- **Consistent Metadata** – All generated k8s resources manifests have labels identifying the application . 
- **Entities based configuration** – k8s resources are defined in `Values` as entities dictionaries where key is `id` of the entity which is used  for referencing within `Values` and expanded according to [Naming Conventions](naming conventions.md) to get `metadata.name`. 
- **Reuse of native k8s manifest format** – any entity may be defined with just `spec` field containing manifest `spec`  (in some cases where `spec` is not part of manifest same is applied to kind specific fields e.g. `data` for  [ConfigMap](Resources/configmap.md))
- **Shortcuts rather than custom format** – all chart specific configuration for entity is optional and acts as shortcut - e.g. `ingress.services`defines how to expose [services](Resources/service.md) and when processed it is transformed to patch for ingress `spec` 
- **Validation** – when entity is configured in chart specific way all possible validations are applied to highlight misconfigurations to developer. Chart has json schema validation.
- **Defaults** – most common use case is default to minimize required configuration. Any default may be overridden. E.g. [Service](Resources/secret.md) port defaults to point to application container port with the same name
 

### Metadata

``` yaml
--8<-- "snippets/values/metadata.yaml"
```

All metadata values, except `product`, are used to build resource names following [Naming Conventions](naming conventions.md) and are available in application pods as environment variables. To comply with Kubernetes naming constraints, they are validated using the regex `^[a-z]([-a-z0-9]*[a-z0-9])?$`.

`product` is used only as a reference value and represents the mapping of a subsystem as a technical asset to an organization's business unit or marketing name.

`product` value is not used for resource naming to prevent massive Kubernetes resource renaming in case of a `subsystem` handover between business units or a marketing name change.

!!! NOTE
    Kubernetes has a 64-character limit for resource names, so metadata values should be as short as possible to avoid exceeding this limit while maintaining clear identification.


#### Global Metadata Values

The following values are defined within the global section as they belong to the subsystem context. If the application Helm chart is deployed as part of a subsystem, these values should be provided by the subsystem Helm chart and remain the same for all `subsystem` applications:



`subsystem` 

:   name of the `subsystem` owning the application. 

    **Mandatory** 

`product` 

:   name of product owning the `subsystem`.

    **Mandatory** 


`environment` 

:   environment application is being deployed to. 

    **Mandatory** 

#### Application Specific Metadata Values:

`version`

:    version of the application. Appears as value of `app.kubernetes.io/version` label of all manifests generated by the chart and used as default docker  images version

    All [containers](Components/containers.md) defined in values are using root `version`, `registry`, `repository` as default values of `image` fields.


    **Mandatory** 

`application`

:   application name

    **Mandatory** 

`applicationType`

:   type of the application:
      -  `service` - microservice
      -  `web` - web application
    
    **Default:** `service`

`instance`

:   name of the instance of the application. E.g. subsystem may deploy multiple application instances in sharding scenarios. If there is only one instance this field is ok to be omitted.

    **Default:** null


### Docker Default Values   


``` yaml
--8<-- "snippets/values/docker-defaults.yaml"
```

`registry` 

:   Default registry to pull  application docker images from. 

    **Default:** `docker.io`


`repository`

:   Default repository (image name)

    **Default:** application canonical name `[Values.global.subsystem]-[Values.global.application]` (format may be changed with [Naming Conventions](naming conventions.md) ). 


### Envs config map

`envs` configMap is always generated. It defines environment variables to be available in all containers of application.

#### Definition in values
```
envs:
  VARIABLE: value
```

#### Metadata environment variables

Metadata variables are added to the `envs` ConfigMap. If `envs` is missing from values, the ConfigMap contains only metadata:

  - `EXORDIS_PRODUCT` - Subsystem product name
  - `EXORDIS_SUBSYSTEM` - Subsystem name  
  - `EXORDIS_APPLICATION` - Application canonical name as `[Values.global.subsystem]-[Values.global.application]`  
  - `EXORDIS_INSTANCE` - Instance name  
  - `EXORDIS_ENVIRONMENT` - Environment  


### Workload

``` yaml
--8<-- "snippets/values/workload.yaml"
```

As the application is intended to be a microservice or web application, only one workload can be deployed.  
(If multiple workloads are needed, each should be deployed independently within the same `subsystem`, or the entire Helm chart may not be suitable for the use case.)  


Application workload is configured with `workload`:

`enabled`

:   Indicates whether to deploy application workload. 
    
    `false` is degenerate case but may be useful in some cases e.g. if Resources deployed by the chart have independent lifecycle within `subsystem`

    **default:** `true`

`kind`

:   workload kind. Only [Deployment](Workloads/deployment.md) is supported at the moment

    **default:** `Deployment`

`replicas` 

:   number of pod replicas of workload.

    **default:** 3

`clusterRole`

:   Workload cluster role. If value contains `id` of [Cluster Role](Resources/cluster-role.md) defined in `.Values.workload.clusterRoles` it is expanded to full name, otherwise value considered as pre-created Cluster Role and kept as is. If `clusterRole` is defined, ServiceAccount and binding to this role is created for application workload

    **default:** null (no explicit cluster role to be assigned)


!!! NOTE
    Support of `StatefulSet` workload kind to be added later





### Entities

The remaining part of the values defines entities that are translated into Kubernetes manifests.

Entities are of the following types:



#### Resources

Standalone resources to be deployed.

- [configmap](Resources/configmap.md)
- [secret](Resources/secret.md)
- [external-secret](Resources/external-secret.md)
- [ingress](Resources/ingress.md)
- [PVC](Resources/pvc.md)
- [service](Resources/service.md)

#### Workload components

Components of workloads. 

Application workload components are defined at the root level of values. If the `workload.enable` value is set to `false`, these components are ignored.  
This ensures that only one application workload exists and allows changing the application workload type without significant changes in `values`.

Batch workload components are defined as part of the corresponding workload.

- [components](Components/containers.md)
- [volumes](Components/volumes.md)

#### Workloads


##### Application Workloads 

Tuning of workload based on its type.

- [Deployment](Workloads/deployment.md)


##### Batch Workloads

Batch workloads to be deployed.

- [CronJob](Batch Workloads/cronjob.md)


### Real world samples

#### It Tools

Deployment of [it tools](https://github.com/CorentinTh/it-tools) - set of IT tools like IPv4 address converter and Base64 string encoder/decoder.

``` yaml
--8<-- "snippets/samples/it-tools.yaml"
```

#### Homepage

Deployment of [Homepage](https://gethomepage.dev/) dashboard


``` yaml
--8<-- "snippets/samples/homepage.yaml"
```