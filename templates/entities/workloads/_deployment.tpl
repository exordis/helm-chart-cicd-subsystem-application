{{- define "subsystem-application.entities.deployment.collection" -}}deployments{{- end -}}
{{- define "subsystem-application.entities.deployments.entity" -}}deployment{{- end -}}

{{- define "subsystem-application.entities.deployment.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{- /* 
TODO:
- Values.deployment should be source of spec. 
- template should take .spec from deployment entity or spec should be removed
 */ -}}
namespace: {{ include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem $.Values.global.environment) | quote}}
annotations: {}
labels: {}


spec: 
  revisionHistoryLimit: 2
containers: {}
initContainers: {}
volumes: {}

{{ end -}}


{{- define "subsystem-application.entities.deployment.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $deployment := index . 2 -}}
name: {{ include "sdk.naming.application.deployment" (list $.Values.global.subsystem $.Values.application $.Values.instance) }}
workloadType: main
subcollections:
  - containers
  - initContainers
  - volumes
{{- end -}}

{{- define "subsystem-application.entities.deployment.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $deployment := index . 2 -}}
referencedConfigMaps:
  {{- range $configMap := $.entities.configMaps -}}
    {{- if eq $deployment.namespace $configMap.namespace -}}
      {{- $referenceIsNeeded := false -}}
      {{- range $container := concat ($deployment.containers | default dict | values) ($deployment.initContainers | default dict | values) -}}
        {{- if or (not $configMap.containers ) (has $container.id $configMap.containers ) }}{{- $referenceIsNeeded = true -}}{{- end -}}
      {{- end -}}
      {{- if $referenceIsNeeded }}
  - {{ $configMap.id }}
      {{- end -}}
    {{- end }}
  {{- end }}
referencedSecrets:
  {{- range $secret := $.entities.secrets -}}
    {{- if eq $deployment.namespace $secret.namespace -}}
      {{- $referenceIsNeeded := false -}}
      {{- range $container := concat ($deployment.containers | default dict | values) ($deployment.initContainers | default dict | values) -}}
        {{- if or (not $secret.containers ) (has $container.id $secret.containers ) }}{{- $referenceIsNeeded = true -}}{{- end -}}
      {{- end -}}
      {{- if $referenceIsNeeded }}
  - {{ $secret.id }}
      {{- end -}}
    {{- end }}
  {{- end }}
{{- end }}