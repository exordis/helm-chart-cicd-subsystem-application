{{- define "subsystem-application.modules.external-secrets.read" -}}
  {{- /* create single external secret: */ -}}  
  {{- /* NOTE: Later should come from values: */ -}}  
  {{- /* $mainSecret := dict "key" (include "sdk.naming.application.external-secret-key" (list $.Values.global.subsystem $.Values.application $.Values.instance $.Values.externalSecretScope  ))*/ -}}
  {{- /* include "sdk.engine.create-entity" (list $ "external-secret" "main" $mainSecret) */ -}}

  {{- /* create single config map for envs: */ -}}  
  {{- $metadataEnvs := include "subsystem-application.configuration.envs.inceptum-metadata-environment-variables" $ | fromYaml }}
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


{{- define "subsystem-application.modules.external-secrets.process" -}}
  {{- range $name, $externalSecret := $.entities.externalSecrets -}}
    {{- $overrides:= ( (include "subsystem-application.modules.external-secrets._owerrides" (list $ $externalSecret) ) | fromYaml) -}}
    {{- $_:= set $externalSecret "spec" ( (include "sdk.common.with-defaults" (list $ $externalSecret.spec "subsystem-application.configuration.defaults.specs.external-secret" $overrides )) | fromYaml ) -}}

    {{- /* apply default binding if none is porviced in external secret sepc*/ -}}  
    {{- if  and (not $externalSecret.spec.data) (not $externalSecret.spec.dataFrom) ($externalSecret.key)  -}}
        {{- $binding:= include "subsystem-application.modules.external-secrets._default_binding"  (list $ $externalSecret)  | fromYaml -}}
        {{- $_:= set $externalSecret "spec" ( mustMergeOverwrite (deepCopy $externalSecret.spec) $binding ) -}}
    {{- end -}} 
  {{- end -}}
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
      {{- include "subsystem-application.metadata.common-labels" $ | nindent 4 }}
    annotations:
      {{- include "subsystem-application.metadata.common-annotations" $ | nindent 4 }}

{{- end -}}


{{- define "subsystem-application.modules.external-secrets._default_binding" -}}
{{- $:=  index . 0 -}}
{{- $externalSecret:=  index . 1 -}}
data:
  - secretKey: {{ $externalSecret.key }}
    remoteRef:
      key: {{ $externalSecret.key }}
{{- end -}}
