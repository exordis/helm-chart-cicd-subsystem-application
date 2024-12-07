{{- define "subsystem-application.modules.configuration.read" -}}
  {{- /* create single config map for envs: */ -}}  
  {{- $metadataEnvs := include "subsystem-application.configuration.envs.exordis-metadata-environment-variables" $ | fromYaml }}
  {{- $metadataEnvs := mustMergeOverwrite  (deepCopy $.Values.envs) $metadataEnvs }}
  {{- $envsConfigMap := dict "data" $metadataEnvs  }}
  {{- include "sdk.engine.create-entity" (list $ "config-map" "envs" $envsConfigMap) -}}

  {{- range $id, $configMap := $.Values.configMaps -}}  
    {{- include "sdk.engine.create-entity" (list $ "config-map" $id $configMap) -}}
  {{- end -}}

  {{- range $id, $externalSecret := $.Values.externalSecrets -}}  
    {{- include "sdk.engine.create-entity" (list $ "external-secret" $id $externalSecret) -}}
  {{- end -}}


  {{- range $id, $secret := $.Values.secrets -}}  
    {{- include "sdk.engine.create-entity" (list $ "secret" $id $secret) -}}
  {{- end -}}
{{- end -}}


{{- define "subsystem-application.modules.configuration.process" -}}
  
{{- end -}}


{{- define "subsystem-application.modules.external-secrets._owerrides" -}}
  {{- $:=  index . 0 -}}
  {{- $externalSecret:=  index . 1 -}}
secretStoreRef:
  name: {{ include "sdk.naming.subsystem.secret-store" (list $.Values.global.subsystem $.Values.global.environment) }}
  kind: ClusterSecretStore
target:
  name: {{ $externalSecret.targetSecretName }}    
  template:
    metadata:
      labels:
        {{- include "subsystem-application.metadata.common-labels" $ | nindent 8 }}
      annotations:
        {{- include "subsystem-application.metadata.common-annotations" $ | nindent 8 }}

{{- end -}}


{{- define "subsystem-application.modules.external-secrets._default_binding" -}}
{{- $:=  index . 0 -}}
{{- $externalSecret:=  index . 1 -}}
data:
  - secretKey: {{ $externalSecret.key }}
    remoteRef:
      key: {{ $externalSecret.key }}
{{- end -}}
