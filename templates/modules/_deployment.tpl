{{- define "subsystem-application.modules.deployment.read" -}}
  {{- if $.Values.workload.kind | eq "Deployment" | and $.Values.workload.enabled -}}
    {{- $data := $.Values.deployment | default dict -}} 
    {{- $containers := dict -}} 
    {{- $_:= set $data "volumes" ($.Values.volumes | default dict | deepCopy) -}} 
    {{- $_:= set $data "containers" ($.Values.sidecars | default dict | deepCopy) -}} 
    {{- $_:= set $data "initContainers"  ($.Values.initContainers | default dict | deepCopy) -}} 
    {{- include "sdk.engine.create-entity" (list $ "deployment" "workload" $data) -}}
    {{- $workload := $.entities.deployments.workload  -}}
    {{- include "sdk.engine.create-entity" (list $ "container" "application" ($.Values.applicationContainer | default dict ) $workload ) -}}

    {{- /* create pvc volumes */ -}} 
    {{- range $pvc_id, $pvc := $.Values.pvcs -}}  
      {{- $pvc := $pvc | default dict -}}
      {{- $mounts := $pvc.mounts | default dict  -}}   
      {{- $needsVolume := false -}}

      {{- range $container := $workload.containers | values | concat ($workload.initContainers | values) -}}
        {{- if hasKey $mounts  $container.ref   -}}
          {{- $volume := dict "pvc" $pvc_id "mounts" ($pvc.mounts | default dict) "pvc" $pvc_id   -}}
          {{- include "sdk.engine.create-entity" (list $ "volume" $pvc_id $volume $workload) -}}
        {{- end -}}        
      {{- end -}}
    {{- end -}}

  {{- end -}}


{{- end -}}



{{- define "subsystem-application.modules.deployment.process" -}}
{{- end -}}


