{{- define "subsystem-application.modules.security.read" -}}

  {{- range $id, $clusterRole := $.Values.clusterRoles -}}  
    {{- include "sdk.engine.create-entity" (list $ "cluster-role" $id $clusterRole) -}}
  {{- end -}}


  {{- if $.Values.clusterRole | default "" | ne "" }}  
    {{- include "sdk.engine.create-entity" (list $ "service-account" "workload" (dict "clusterRoles" (list $.Values.clusterRole))) -}}
  {{- end }}      
{{- end -}}


{{- define "subsystem-application.modules.security.process" -}}
  
{{- end -}}


