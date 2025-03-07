{{- define "subsystem-application.configuration.defaults.values" -}}
{{- $canonical_name := include "subsystem-application.naming.conventions.metadata" (list $ "application-canonical-name") -}}
repository: {{ $canonical_name }}
registry: docker.io
dataFolders: {}
workload: 
  enabled: true
  kind: Deployment
  replicas: 3
{{- end -}}
