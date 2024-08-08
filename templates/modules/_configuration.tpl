{{- define "subsystem-application.modules.external-secrets.read" -}}
  {{- /* create single external secret: */ -}}  
  {{- /* NOTE: Later should come from values: */ -}}  
  {{- $mainSecret := dict "key" (include "sdk.naming.application.external-secret-key" (list $.Values.global.subsystem $.Values.application $.Values.instance $.Values.externalSecretScope  )) -}}
  {{- include "sdk.engine.create-entity" (list $ "external-secret" "main" $mainSecret) -}}

  {{- /* create single config map for envs: */ -}}  
  {{- $metadataEnvs := include "subsystem-application.configuration.envs.inceptum-metadata-environment-variables" $ | fromYaml }}
  {{- $metadataEnvs := mustMergeOverwrite  (deepCopy $.Values.envs) $metadataEnvs }}
  {{- $envsConfigMap := dict "data" $metadataEnvs  }}
  {{- include "sdk.engine.create-entity" (list $ "config-map" "envs" $envsConfigMap) -}}
{{- end -}}


{{- define "subsystem-application.modules.external-secrets.process" -}}
  {{- range $name, $externalSecret := $.entities.externalSecrets -}}
    {{- $overrides:= ( (include "subsystem-application.modules.external-secrets._owerrides" (list $ $externalSecret) ) | fromYaml) -}}
    {{- $_:= set $externalSecret "spec" ( (include "sdk.common.with-defaults" (list $ $externalSecret.spec "subsystem-application.configuration.defaults.specs.external-secret" $overrides )) | fromYaml ) -}}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.external-secrets._owerrides" -}}
  {{- $:=  index . 0 -}}
  {{- $externalSecret:=  index . 1 -}}
secretStoreRef:
  name: {{ include "sdk.naming.subsystem.secret-store" (list $.Values.global.subsystem $.Values.global.environment) }}
  kind: SecretStore
target:
  name: {{ $externalSecret.targetSecretName }}    
dataFrom:
  - extract:
      conversionStrategy: Default
      decodingStrategy: None      
      key: {{ $externalSecret.key }}
{{- end -}}

