{{- define "subsystem-application.entities.deployment.collection" -}}deployments{{- end -}}
{{- define "subsystem-application.entities.deployments.entity" -}}deployment{{- end -}}

{{- define "subsystem-application.entities.deployment.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
spec: {}
containers: {}
initContainers: {}
volumes: {}
{{ end -}}


{{- define "subsystem-application.entities.deployment.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $cronjob := index . 2 -}}
name: {{ include "sdk.naming.application.deployment" (list $.Values.global.subsystem $.Values.application $.Values.instanceName) }}
subcollections:
  - containers
  - initContainers
  - volumes
{{- end -}}

{{- define "subsystem-application.entities.deployment.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $cronjob := index . 2 -}}

{{- end }}