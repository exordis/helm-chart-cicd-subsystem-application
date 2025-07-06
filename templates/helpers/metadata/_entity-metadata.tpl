{{- define "subsystem-application.metadata.entity-metadata" -}}
{{- $ := index . 0 -}}{{- $entity := index . 1 -}}
{{- $cluster := false -}}
{{- $immutable := false -}}
{{- if gt (len .) 2 -}}{{- $cluster =  index . 2 -}}{{- end -}}
{{- if gt (len .) 3 -}}{{- $immutable =  index . 3 -}}{{- end -}}
name: {{ $entity.name }}
{{- if $cluster | not }}
namespace: {{ $entity.namespace }}
{{- end }}
labels:
{{- if $immutable -}}
  {{- include "subsystem-application.metadata.common-labels-immutable" $ | fromYaml | mustMergeOverwrite $entity.labels | toYaml | nindent 4 -}}
{{- else -}}  
  {{- include "subsystem-application.metadata.common-labels" $ | fromYaml | mustMergeOverwrite $entity.labels | toYaml | nindent 4 -}}
{{- end }}
annotations:
  {{- include "subsystem-application.metadata.common-annotations" $  | fromYaml | mustMergeOverwrite $entity.annotations | toYaml | nindent 4 }}
{{- end -}}