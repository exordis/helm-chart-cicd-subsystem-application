{{- define "subsystem-application.entities.config-map.collection" -}}configMaps{{- end -}}
{{- define "subsystem-application.entities.configMaps.entity" -}}config-map{{- end -}}

{{- define "subsystem-application.entities.config-map.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
data: {}
{{- end -}}

{{- define "subsystem-application.entities.config-map.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
kind: ConfigMap
name: {{ include "subsystem-application.naming.conventions.kind" (list $ $id "ConfigMap"  ) | quote }} 

{{- end -}}


{{- define "subsystem-application.entities.config-map.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $configMap := index . 2 -}}
{{- include "subsystem-application.validation.container-refs" (list $ "ConfigMap" $id $configMap.containers $configMap.namespace ) -}}

{{- end }}