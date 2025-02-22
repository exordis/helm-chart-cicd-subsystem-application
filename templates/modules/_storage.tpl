{{- define "subsystem-application.modules.storage.read" -}}

  {{- range $id, $pvc := $.Values.pvcs -}}  
    {{- include "sdk.engine.create-entity" (list $ "pvc" $id $pvc) -}}
    {{- /*add volume if pvc has mounts defined */ -}}
    {{- range $workload := concat ($.entities.deployments | default dict | values) ($.entities.cronjobs | default dict | values)  -}}
      {{- if ($pvc| default dict).mounts -}}
        {{- $volume := (dict "pvc" $id "mounts" ($pvc.mounts | default dict))   -}}
        {{- include "sdk.engine.create-entity" (list $ "volume" $id $volume $workload) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.storage.process" -}}
  

{{- end -}}




