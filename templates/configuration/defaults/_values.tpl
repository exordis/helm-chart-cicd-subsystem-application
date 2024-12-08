{{- define "subsystem-application.configuration.defaults.values" -}}
{{- if and $.Values.version (default .Values.deployment true) -}}
deployment: true
{{- end }}
version: {{(default .Values.version "latest") }}
image: {{ printf "%s/%s" .Values.dockerRegistry (include "sdk.naming.application-canonical-name" (list .Values.global.subsystem .Values.application))  }}
externalSecretScope: {{ $.Values.global.environment }}
dataFolders: {}
strategy:
  rollingUpdate:
    maxSurge: 25%
    maxUnavailable: 25%
  type: RollingUpdate
{{- end -}}
