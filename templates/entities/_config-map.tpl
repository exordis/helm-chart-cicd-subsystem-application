{{- define "subsystem-application.entities.config-map.collection" -}}configMaps{{- end -}}

{{- define "subsystem-application.entities.config-map.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
data: {}
{{- end -}}

{{- define "subsystem-application.entities.config-map.overrides" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.config-map" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
{{- end -}}


{{- define "subsystem-application.entities.config-map.pre-process" -}}
{{- end }}