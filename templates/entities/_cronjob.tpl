{{- define "subsystem-application.entities.cronjob.collection" -}}cronjobs{{- end -}}

{{- define "subsystem-application.entities.cronjob.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
namespace: {{ include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem $.Values.global.environment) | quote}}
schedule: "0 0 31 2 *"
concurrencyPolicy: Forbid
failedJobsHistoryLimit: 1
ttlSecondsAfterFinished: 86400
restartPolicy: Never
spec: {}
containers: {}
volumes: {}
{{- end -}}

{{- define "subsystem-application.entities.cronjob.overrides" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.cronjob" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
{{- end -}}


{{- define "subsystem-application.entities.cronjob.pre-process" -}}
# will be added by module
{{- $_ := set $ "containers" dict  -}}
{{- end }}