{{- define "subsystem-application.entities.pvc.collection" -}}pvcs{{- end -}}

{{- define "subsystem-application.entities.pvc.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
mounts: {}
{{- end -}}

{{- define "subsystem-application.entities.pvc.overrides" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.pvc" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
{{- if hasKey $data "size" }}
spec:
  resources:
    requests:
      storage: {{ $data.size }}
{{- end -}}
{{- end -}}



{{- define "subsystem-application.entities.pvc.pre-process" -}}
{{- end }}
