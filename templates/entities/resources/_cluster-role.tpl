{{- define "subsystem-application.entities.cluster-role.collection" -}}clusterRoles{{- end -}}
{{- define "subsystem-application.entities.clusterRoles.entity" -}}cluster-role{{- end -}}

{{- define "subsystem-application.entities.cluster-role.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
rules: []
{{- end -}}

{{- define "subsystem-application.entities.cluster-role.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
kind: ClusterRole
name: {{ include "sdk.naming.conventions.kind" (list $ $id "ClusterRole"  ) | quote }} 

{{- end -}}


{{- define "subsystem-application.entities.cluster-role.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ClusterRole := index . 2 -}}

{{- end }}