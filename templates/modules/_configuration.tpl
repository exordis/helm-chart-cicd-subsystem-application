{{- define "subsystem-application.modules.configuration.read" -}}
  {{- /* create single config map for envs: */ -}}  
  {{- $metadataEnvs := include "subsystem-application.configuration.envs.exordis-metadata-environment-variables" $ | fromYaml }}
  {{- $metadataEnvs := mustMergeOverwrite  (deepCopy $.Values.envs) $metadataEnvs }}
  {{- $envsConfigMap := dict "data" $metadataEnvs  }}
  {{- include "sdk.engine.create-entity" (list $ "config-map" "envs" $envsConfigMap) -}}

  {{- range $id, $configMap := $.Values.configMaps -}}  
    {{- if (or (not (hasKey ($configMap|default dict) "enabled")) $configMap.enabled) -}}
      {{- include "sdk.engine.create-entity" (list $ "config-map" $id $configMap) -}}
    {{- end -}}
  {{- end -}}

  {{- range $id, $externalSecret := $.Values.externalSecrets -}}  
    {{- if (or (not (hasKey ($externalSecret|default dict) "enabled")) $externalSecret.enabled) -}}
      {{- include "sdk.engine.create-entity" (list $ "external-secret" $id $externalSecret) -}}
    {{- end -}}
  {{- end -}}


  {{- range $id, $secret := $.Values.secrets -}}  
    {{- if (or (not (hasKey ($secret|default dict) "enabled")) $secret.enabled) -}}
      {{- include "sdk.engine.create-entity" (list $ "secret" $id $secret) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}


{{- define "subsystem-application.modules.configuration.process" -}}
  
{{- end -}}