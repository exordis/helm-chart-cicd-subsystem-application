{{- define "subsystem-application.entities.cronjob.collection" -}}cronjobs{{- end -}}
{{- define "subsystem-application.entities.cronjobs.entity" -}}cronjob{{- end -}}
{{- define "subsystem-application.entities.cronjob.subcollections" -}}
containers: container
initContainers: init-container
volumes: volume
{{- end -}}

{{- define "subsystem-application.entities.cronjob.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
concurrencyPolicy: "Forbid"
namespace: {{ include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem $.Values.global.environment) | quote}}
schedule: "0 0 31 2 *"
failedJobsHistoryLimit: 1
ttlSecondsAfterFinished: 86400
restartPolicy: "Never"
spec: {}
containers: {}
initContainers: {}
volumes: {}
{{ end -}}

{{- define "subsystem-application.entities.cronjob.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $cronjob := index . 2 -}}
name: {{ include "sdk.naming.application.cronjob" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
{{- end -}}


{{- define "subsystem-application.entities.cronjob.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $cronjob := index . 2 -}}

{{- end }}