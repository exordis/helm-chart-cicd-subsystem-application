{{- define "subsystem-application.metadata.entity-metadata-defaults" -}}
namespace: {{ include "sdk.naming.conventions.kind" (list $ "" "Namespace"  ) | quote }}
labels: {}
annotations: {}
{{- end -}}