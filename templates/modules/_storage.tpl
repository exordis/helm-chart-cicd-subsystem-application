{{- define "subsystem-application.modules.storage.read" -}}

  {{- range $id, $pvc := $.Values.pvcs -}}  
    {{- include "sdk.engine.create-entity" (list $ "pvc" $id $pvc) -}}
    {{- /*add volume if pvc has mounts defined */ -}}
    {{- if $pvc.mounts -}}
      {{- $volume := (dict "type" "persistentVolumeClaim" "pvc" $id "mounts" $pvc.mounts)   -}}
      {{- include "sdk.engine.create-entity" (list $ "volume" $id $volume) -}}
    {{- end -}}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.storage.process" -}}
  

{{- end -}}




