{{- /*TODO: proper json schema */ -}} 
{{- /*TODO: volume mounts */ -}} 
{{- /*TODO: env from */ -}} 
{{- /*TODO: consider adding containers to entities.containers with type "job" and job reference */ -}} 


{{- define "subsystem-application.modules.cronjobs.read" -}}
  {{- /* add cronjobs to entities.cronjobs: */ -}} 
  {{- range $id, $cronjob := $.Values.cronjobs }}
    {{- include "sdk.engine.create-entity" (list $ "cronjob" $id $cronjob) -}}
  {{- end -}}
{{- end -}}


{{- define "subsystem-application.modules.cronjobs.process" -}}

{{- end -}}
