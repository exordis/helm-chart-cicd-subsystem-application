{{- define "subsystem-application.metadata.entity-metadata-defaults" -}}
namespace: {{ include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem $.Values.global.environment) | quote}}
labels: {}
annotations: {}
{{- end -}}