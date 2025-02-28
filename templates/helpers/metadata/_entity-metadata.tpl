{{- define "subsystem-application.metadata.entity-metadata" -}}
{{- $ := index . 0 -}}{{- $entity := index . 1 -}}
{{- $cluster := false -}}
{{- if gt (len .) 2 -}}{{- $cluster =  index . 2 -}}{{- end }}
name: {{ $entity.name }}
{{- if $cluster | not }}
namespace: {{ $entity.namespace }}
{{- end }}
labels:
  {{- include "subsystem-application.metadata.common-labels" $ | fromYaml | mustMergeOverwrite $entity.labels | toYaml | nindent 4 }}
annotations:
  {{- include "subsystem-application.metadata.common-annotations" $  | fromYaml | mustMergeOverwrite $entity.annotations | toYaml | nindent 4 }}
{{- end -}}