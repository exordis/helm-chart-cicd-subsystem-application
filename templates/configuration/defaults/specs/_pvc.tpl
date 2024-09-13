{{- define "subsystem-application.configuration.defaults.specs.pvc" -}}
accessModes:
  - ReadWriteOnce
resources:
  requests:
    storage: 1Gi
{{- end }}


