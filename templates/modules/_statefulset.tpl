{{- define "subsystem-application.modules.statefulset.read" -}}
  {{- if $.Values.workload.kind | eq "StatefulSet" | and $.Values.workload.enabled -}}
    {{- $data := $.Values.statefulset | default dict -}} 
    {{- $containers := dict -}} 
    {{- $_:= set $data "volumes" ($.Values.volumes | default dict | deepCopy) -}} 
    {{- $_:= set $data "containers" ($.Values.sidecars | default dict | deepCopy) -}} 
    {{- $_:= set $data "initContainers"  ($.Values.initContainers | default dict | deepCopy) -}} 
    {{- include "sdk.engine.create-entity" (list $ "statefulset" "workload" $data) -}}
    {{- $workload := $.entities.statefulsets.workload  -}}
    {{- include "sdk.engine.create-entity" (list $ "container" "application" ($.Values.applicationContainer | default dict ) $workload ) -}}

    {{- /* create pvc volumes */ -}} 
    {{- range $pvc_id, $pvc := $.Values.pvcs -}}  
      {{- $pvc := $pvc | default dict -}}
      {{- $mounts := $pvc.mounts | default dict  -}}   

      {{- $convertToTemplateForStatefulSet := (or (not (hasKey ($pvc|default dict) "convertToTemplateForStatefulSet")) $pvc.convertToTemplateForStatefulSet) -}}
      {{- if $convertToTemplateForStatefulSet -}}
        {{- include "sdk.engine.create-entity" (list $ "pvc" $pvc_id $pvc $workload) -}}
      {{- end -}}

      {{- range $container := $workload.containers | values | concat ($workload.initContainers | values) -}}
        {{- if hasKey $mounts  $container.ref -}}
          {{- $volume := dict "volumeClaimTemplate" $pvc_id "mounts" ($pvc.mounts | default dict)  -}}
          {{- include "sdk.engine.create-entity" (list $ "volume" $pvc_id $volume $workload) -}}
        {{- end -}}        
      {{- end -}}


    {{- end -}}

  {{- end -}}


{{- end -}}



{{- define "subsystem-application.modules.statefulset.process" -}}
{{- end -}}


