{{- define "subsystem-application.configuration.defaults.specs.external-secret" -}}
refreshInterval: 1m
target:
  creationPolicy: Owner
  deletionPolicy: Retain
{{- end }}
