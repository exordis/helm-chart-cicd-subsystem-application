{{- define "subsystem-application.configuration.defaults.values" -}}
version: {{(default .Values.version "latest") }}
image: {{ printf "%s/%s" .Values.dockerRegistry (include "sdk.naming.application-canonical-name" (list .Values.global.subsystem .Values.application))  }}
externalSecretScope: {{ $.Values.global.environment }}
dataFolders: {}
workload: deployment
deployment:
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
{{- end -}}
