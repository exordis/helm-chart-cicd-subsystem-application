{{- define "subsystem-application.configuration.defaults.values" -}}
{{- $canonical_name := include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $.Values.application) -}}
workload: deployment
repository: {{ $canonical_name }}
registry: docker.io
dataFolders: {}
deployment:
  revisionHistoryLimit: 1
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
{{- end -}}
