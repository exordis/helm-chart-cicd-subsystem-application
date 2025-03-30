{{- define "subsystem-application.metadata.entity-defaults" -}}
namespace: {{ include "sdk.naming.conventions.kind" (list $ "" "Namespace"  ) | quote }}
labels: {}
annotations: {}
enabled: true
{{- end -}}