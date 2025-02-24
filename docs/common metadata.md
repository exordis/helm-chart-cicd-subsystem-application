---
order: 2
---

All generated manifests has common metadata labels

### Helm 

`helm.sh/chart`

:   "cicd-subsystem-application-[chart version]"


### Kubernetes Native Labels

`app.kubernetes.io/component`

:   [Application Canonical Name](naming%20conventions.md#metadata)

`app.kubernetes.io/instance`

:   `Values.instance`

`app.kubernetes.io/managed-by`

:   "helm"


`app.kubernetes.io/name`

:   [Application Canonical Name](naming%20conventions.md#metadata)


`app.kubernetes.io/part-of`

:   `Values.global.subsystem`


`app.kubernetes.io/version`

:   `Values.version`


### Metadata

`exordis/environment`

:   `Values.global.environment`

`exordis/product`

:   `Values.global.product`

`exordis/subsystem`

:   `Values.global.subsystem`

`exordis/application`

:   [Application Canonical Name](naming%20conventions.md#metadata)

`exordis/application-instance`
:   `Values.instance`

`exordis/application-type`
:   `Values.applicationType`


