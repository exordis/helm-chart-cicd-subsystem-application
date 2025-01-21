{{- define "subsystem-application.entities.config-map.collection" -}}configMaps{{- end -}}
{{- define "subsystem-application.entities.configMaps.entity" -}}config-map{{- end -}}

{{- define "subsystem-application.entities.config-map.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
namespace: {{ include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem $.Values.global.environment) | quote}}
data: {}
labels: {}
annotations: {}
{{- end -}}

{{- define "subsystem-application.entities.config-map.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.config-map" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
{{- end -}}


{{- define "subsystem-application.entities.config-map.process" -}}
{{- end }}