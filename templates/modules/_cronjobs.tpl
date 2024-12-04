{{- /*TODO: proper json schema */ -}} 
{{- /*TODO: volume mounts */ -}} 
{{- /*TODO: env from */ -}} 
{{- /*TODO: consider adding containers to entities.containers with type "job" and job reference */ -}} 


{{- define "subsystem-application.modules.cronjobs.read" -}}
  {{- /* add cronjobs containers to entities.cronjobs: */ -}} 
  {{- range $id, $cronjob := $.Values.cronjobs }}
    {{- include "sdk.engine.create-entity" (list $ "cronjob" $id $cronjob) -}}
    {{- /* add containers to cronjob: */ -}} 
    {{- $cronjob_ := index $.entities.cronjobs $id -}}
    {{- range $container_id, $container := $cronjob.containers }}
      {{- $container := (include "sdk.engine.initialize-entity" (list $ "container" $container_id $container))  | fromYaml -}}
      {{- $spec_overrides := (include "subsystem-application.modules.cronjobs.container_spec" (list $ $container) ) |fromYaml -}}
      {{- $_:= set $container "spec" (include "sdk.common.with-defaults" (list $ $container.spec "subsystem-application.configuration.defaults.specs.job-container" $spec_overrides ) | fromYaml )  -}}
      {{- $_:= set $cronjob_.containers $id $container -}}
    {{- end -}}    
  {{- end -}}
{{- end -}}


{{- define "subsystem-application.modules.cronjobs.process" -}}
  {{- /* iterate entities.cronjobs and assemble specs: */ -}} 
  {{- range $id, $cronjobs := $.entities.cronjobs -}}
    {{- $spec_overrides := dict -}}
    {{- $_:= set $cronjobs "spec" (include "sdk.common.with-defaults" (list $ $cronjobs.spec "subsystem-application.configuration.defaults.specs.cronjob" $spec_overrides ) | fromYaml )  -}}
    
  {{ end -}}
{{- end -}}


{{- define "subsystem-application.modules.cronjobs.container_spec" -}}
{{- $ := index . 0 -}}{{- $container := index . 1 -}}
{{- $namespace := include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem  $.Values.global.environment) -}}
name: {{ $container.name }}
image: {{ printf "%s:%s" ($container.image) ($container.version) }}
{{- end -}}