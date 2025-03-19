{{- define "subsystem-application.entities.cronjob.collection" -}}cronjobs{{- end -}}
{{- define "subsystem-application.entities.cronjobs.entity" -}}cronjob{{- end -}}


{{- define "subsystem-application.entities.cronjob.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
namespace: {{ include "sdk.naming.conventions.kind" (list $ "" "Namespace"  ) | quote }}
spec: 
  schedule: "0 0 31 2 *"
  concurrencyPolicy: Forbid
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      ttlSecondsAfterFinished: 86400
      template:
        spec:
          serviceAccountName: default
          restartPolicy: "Never"


containers: {}
initContainers: {}
volumes: {}
labels: {}
annotations: {}
{{ end -}}

{{- define "subsystem-application.entities.cronjob.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $cronjob := index . 2 -}}
kind: CronJob
name: {{ include "sdk.naming.conventions.kind" (list $ $id "CronJob"  ) | quote }} 
workloadType: batch
subcollections:
  - containers
  - initContainers
  - volumes
{{- end -}}


{{- define "subsystem-application.entities.cronjob.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $cronjob := index . 2 -}}
{{ include "subsystem-application.entities.workloads.helpers.references" (list $ $cronjob) }}
  {{- if hasKey $cronjob "serviceAccount" }}
spec: 
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccountName: {{ $cronjob.serviceAccount.name | quote }}
  {{- end }}
{{- end }}

