{{- define "subsystem-application.entities.volume.collection" -}}volumes{{- end -}}

{{- define "subsystem-application.entities.volume.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
type: emptyDir
spec: {}
mounts: {}
{{- end -}}

{{- define "subsystem-application.entities.volume.overrides" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.deployment.volume" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
{{- end -}}


{{- define "subsystem-application.entities.volume.pre-process" -}}
{{- end }}


