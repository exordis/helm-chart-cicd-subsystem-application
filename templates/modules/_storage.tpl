{{- define "subsystem-application.modules.storage.read" -}}

  {{- range $id, $pvc := $.Values.pvcs -}}  
    {{- include "sdk.engine.create-entity" (list $ "pvc" $id $pvc) -}}
    {{- /*add volume if pvc has mounts defined */ -}}
    {{- range $workload := concat ($.entities.deployments | default dict | values) ($.entities.cronjobs | default dict | values)  -}}
      {{- if $pvc.mounts -}}
        {{- $volume := (dict "type" "persistentVolumeClaim" "pvc" $id "mounts" $pvc.mounts)   -}}
        {{- include "sdk.engine.create-entity" (list $ "volume" $id $volume $workload "volumes") -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.storage.process" -}}
  

{{- end -}}




