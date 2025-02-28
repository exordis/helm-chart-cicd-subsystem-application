{{- define "subsystem-application.entities.service-account.collection" -}}serviceAccounts{{- end -}}
{{- define "subsystem-application.entities.serviceAccounts.entity" -}}service-account{{- end -}}

{{- define "subsystem-application.entities.service-account.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
clusterRoles: []
{{- end -}}

{{- define "subsystem-application.entities.service-account.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
kind: ServiceAccount
name: {{ include "subsystem-application.naming.conventions.kind" (list $ $id "ServiceAccount"  ) | quote }} 
{{- end -}}


{{- define "subsystem-application.entities.service-account.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $serviceAccount := index . 2 -}}

{{- $clusterRoles := list -}}
{{- range $clusterRoleName := $serviceAccount.clusterRoles -}}
  {{- if hasKey $.entities.clusterRoles $clusterRoleName -}}
    {{- $clusterRole := index $.entities.clusterRoles $clusterRoleName  -}}
    {{- $clusterRoles = append $clusterRoles $clusterRole.name -}}
  {{- else -}}
    {{- $clusterRoles = append $clusterRoles $clusterRoleName -}}
  {{- end -}}
{{- end }}

{{- $_ := set $serviceAccount "clusterRoles" $clusterRoles -}}

{{- end }}