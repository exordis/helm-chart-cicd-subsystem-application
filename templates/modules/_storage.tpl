{{- define "subsystem-application.modules.storage.read" -}}

  {{- range $id, $pvc := $.Values.pvcs -}}  
    {{- include "sdk.engine.create-entity" (list $ "pvc" $id $pvc) -}}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.storage.process" -}}
  

{{- end -}}




