## Definition

``` yaml
externalSecrets:
  externalPassword:
    containers:
    spec: 
      refreshInterval: 1m
      target:
        creationPolicy: Owner
        deletionPolicy: Retain
    targetSecretName: {{ include "sdk.naming.application.secret" (list $.Values.global.subsystem $.Values.application $.Values.instance $id) }}
    key:

```