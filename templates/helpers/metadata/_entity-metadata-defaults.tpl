{{- define "subsystem-application.metadata.entity-metadata-defaults" -}}
namespace: {{ include "subsystem-application.naming.conventions.kind" (list $ "" "Namespace"  ) | quote }}
labels: {}
annotations: {}
{{- end -}}