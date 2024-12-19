{{- define "subsystem-application.modules.deployment.read" -}}
  {{- if $.Values.workload | eq "deployment" -}}
    {{- $data := $.Values.deployment | default dict -}} 
    {{- $containers := dict -}} 
    {{- $_:= set $data "volumes" $.Values.volumes -}} 
    {{- $_:= set $data "containers" $.Values.sidecars -}} 
    {{- $_:= set $data.containers "applicationContainer" (dict "image" $.Values.image "version" $.Values.version "spec" $.Values.applicationContainer )  -}} 
    {{- $_:= set $data "initContainers" $.Values.initContainers -}} 
    {{- include "sdk.engine.create-entity" (list $ "deployment" "workload" $data) -}}

    {{- /* add application container to entities.containers: */ -}} 
    {{- /*$applicationContainer := (dict "image" $.Values.image "version" $.Values.version "spec" $.Values.applicationContainer )*/ -}}
    {{- /*include "sdk.engine.create-entity" (list $ "container" "applicationContainer" $applicationContainer)*/ -}}

    {{- /* add sidecar containers to entities.containers: */ -}} 
    {{- range $id, $sidecar := $.Values.sidecars }}
      {{- /*include "sdk.engine.create-entity" (list $ "container" $id $sidecar)*/ -}}
    {{- end -}}

    {{- /* add init containers to entities.initContainers: */ -}} 
    {{- range $id, $initContainer := $.Values.initContainers }}
      {{- /*include "sdk.engine.create-entity" (list $ "init-container" $id $initContainer)*/ -}}
    {{- end -}}

    {{- /* add volumes to entities.volumes: */ -}} 
    {{- range $id, $volume := $.Values.volumes -}}  
      {{- /*include "sdk.engine.create-entity" (list $ "volume" $id $volume)*/ -}}
    {{- end -}}  
  {{- end -}}
{{- end -}}



{{- define "subsystem-application.modules.deployment.process" -}}
  {{- if $.Values.workload | eq "deployment" -}}

  {{- end -}}
{{- end -}}


