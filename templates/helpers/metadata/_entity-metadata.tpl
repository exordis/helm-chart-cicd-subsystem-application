{{- define "subsystem-application.metadata.entity-metadata" -}}
{{- $ := index . 0 -}}{{- $entity := index . 1 -}}
name: {{ $entity.name }}
namespace: {{ $entity.namespace }}
labels:
  {{- include "subsystem-application.metadata.common-labels" $ | fromYaml | mustMergeOverwrite $entity.labels | toYaml | nindent 4 }}
annotations:
  {{- include "subsystem-application.metadata.common-annotations" $  | fromYaml | mustMergeOverwrite $entity.annotations | toYaml | nindent 4 }}
{{- end -}}