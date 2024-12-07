{{- define "subsystem-application.modules.storage.read" -}}

  {{- range $id, $pvc := $.Values.pvcs -}}  
    {{- include "sdk.engine.create-entity" (list $ "pvc" $id $pvc) -}}
    {{- /*TBC: add volume only id pvc has mounts defined*/ -}}
    {{- $volume := (dict "type" "persistentVolumeClaim"  "pvc" $id)   -}}
    {{- include "sdk.engine.create-entity" (list $ "volume" $id $volume) -}}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.storage.process" -}}
  

{{- end -}}




