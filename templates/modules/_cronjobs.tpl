{{- /*TODO: proper json schema */ -}} 
{{- /*TODO: volume mounts */ -}} 
{{- /*TODO: consider adding containers to entities.containers with type "job" and job reference */ -}} 


{{- define "subsystem-application.modules.cronjobs.read" -}}
  {{- /* add cronjobs to entities.cronjobs: */ -}} 
  {{- range $id, $cronjob := $.Values.cronjobs -}}
    {{- if (or (not (hasKey ($cronjob|default dict) "enabled")) $cronjob.enabled) }}
      {{- include "sdk.engine.create-entity" (list $ "cronjob" $id $cronjob) -}}
      {{- if $cronjob.clusterRole | default "" | ne "" }}  
        {{- include "sdk.engine.create-entity" (list $ "service-account" (printf "cronjob-%s" $id) (dict "clusterRoles" (list $cronjob.clusterRole))) -}}
        {{- $serviceAccount := index $.entities.serviceAccounts (printf "cronjob-%s" $id) -}}
        {{- $cronjob := index $.entities.cronjobs $id -}}
        {{- $_ := set $cronjob "serviceAccount" $serviceAccount -}}
      {{- end }}       
    {{- end }}       
  {{- end -}}
{{- end -}}


{{- define "subsystem-application.modules.cronjobs.process" -}}

{{- end -}}

