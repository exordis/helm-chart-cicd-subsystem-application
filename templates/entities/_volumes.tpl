{{- define "subsystem-application.entities.volume.collection" -}}volumes{{- end -}}
{{- define "subsystem-application.entities.volumes.entity" -}}volume{{- end -}}
{{- define "subsystem-application.entities.volume.subcollections" -}}{{- end -}}

{{- define "subsystem-application.entities.volume.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
type: emptyDir
mounts: {}
spec: {}
{{- end -}}



{{- define "subsystem-application.entities.volume.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $volume := index . 2 -}}
name: {{ include "sdk.naming.application.deployment.volume" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
  {{- /* emptyDir defaults */ -}}
  {{- if $volume.type | eq "emptyDir" }}
spec:
  sizeLimit: {{  $volume.spec.sizeLimit | default "100Mi" }}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.entities.volume.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $volume := index . 2 -}}

  {{- /* Handle pvc reference */ -}}
  {{- if eq $volume.type "persistentVolumeClaim" | and $volume.pvc -}}

    {{- /* Validate referenced pvc exists */ -}}
    {{- if hasKey $.entities.pvcs $volume.pvc | not -}}
      {{- $error := printf "\nVALIDATION ISSUES:\n Volume '%s' references missing PVC '%s'." $id $volume.pvc -}}
      {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
    {{- end -}}

  {{- $pvc := get $.entities.pvcs $volume.pvc -}} 
spec:
  claimName: {{ $pvc.name }}
  {{- end -}}
{{- end -}}
