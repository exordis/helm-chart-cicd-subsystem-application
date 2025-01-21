{{- define "subsystem-application.entities.pvc.collection" -}}pvcs{{- end -}}
{{- define "subsystem-application.entities.pvcs.entity" -}}pvc{{- end -}}

{{- define "subsystem-application.entities.pvc.defaults" -}}
{{- /* TODO: get rid of $ and $data, defaults should be just yaml*/ -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
namespace: {{ include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem  $.Values.global.environment) }}
annotations: {}
labels: {}
mounts: {}
size: 1Gi
spec:
  accessModes:
    - ReadWriteOnce
{{- end -}}

{{- define "subsystem-application.entities.pvc.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $pvc := index . 2 -}}

# Return entity overrides
name: {{ include "sdk.naming.application.pvc" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
spec:
  resources:
    requests:
      storage: {{ $pvc.size }}


{{- end -}}



{{- define "subsystem-application.entities.pvc.process" -}}
{{- /* TBC: provide entities instead of $ to limit context*/ -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $service := index . 2 -}}

{{- end -}}

