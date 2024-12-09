{{- define "subsystem-application.configuration.defaults.values" -}}
{{ $workload := $.Values.workload | default ($.Values.version | default "" | eq ""  | ternary "none" "deployment") }}
{{- if $workload | ne "none " }}
version: {{ default .Values.version "latest" }}
{{ end -}}
image: {{ printf "%s/%s" .Values.dockerRegistry (include "sdk.naming.application-canonical-name" (list .Values.global.subsystem .Values.application))  }}
externalSecretScope: {{ $.Values.global.environment }}
dataFolders: {}
workload: {{ $workload }}
deployment:
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
{{- end -}}
