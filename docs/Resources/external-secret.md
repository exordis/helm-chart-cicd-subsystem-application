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
    targetSecretName: {{ include "subsystem-application.naming.conventions.kind" (list $ $id "Secret"  ) | quote }} 
    key:

```