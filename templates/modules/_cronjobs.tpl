{{- /*TODO: proper json schema */ -}} 
{{- /*TODO: volume mounts */ -}} 
{{- /*TODO: env from */ -}} 
{{- /*TODO: consider adding containers to entities.containers with type "job" and job reference */ -}} 


{{- define "subsystem-application.modules.cronjobs.read" -}}
  {{- /* add cronjobs containers to entities.cronjobs: */ -}} 
  {{- range $id, $cronjob := $.Values.cronjobs }}
    {{- include "sdk.engine.create-entity" (list $ "cronjob" $id $cronjob) -}}
  {{- end -}}
{{- end -}}


{{- define "subsystem-application.modules.cronjobs.process" -}}

{{- end -}}

{{- /***************************/ -}}
{{- define "subsystem-application.modules.cronjobs.container_spec" -}}
{{- $ := index . 0 -}}{{- $container := index . 1 -}}
{{- $namespace := include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem  $.Values.global.environment) -}}
name: {{ $container.name }}
image: {{ printf "%s:%s" ($container.image) ($container.version) }}
{{- end -}}