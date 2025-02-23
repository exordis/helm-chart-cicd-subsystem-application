{{- define "subsystem-application.configuration.defaults.values" -}}
{{- $canonical_name := include "subsystem-application.naming.conventions.metadata" (list $ "application-canonical-name") -}}
workload: deployment
repository: {{ $canonical_name }}
registry: docker.io
dataFolders: {}
{{- end -}}
