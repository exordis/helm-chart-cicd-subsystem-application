{{- define "subsystem-application.modules.deployment.read" -}}
  {{- if $.Values.workload | eq "deployment" -}}
    {{- $data := $.Values.deployment | default dict -}} 
    {{- $containers := dict -}} 
    {{- $_:= set $data "volumes" ($.Values.volumes | default dict | deepCopy) -}} 
    {{- $_:= set $data "containers" ($.Values.sidecars | default dict | deepCopy) -}} 
    {{- /*$_:= set $data.containers "application" ($.Values.applicationContainer | default dict ) */ -}} 
    {{- $_:= set $data "initContainers"  ($.Values.initContainers | default dict | deepCopy) -}} 
    {{- include "sdk.engine.create-entity" (list $ "deployment" "workload" $data) -}}
    {{- include "sdk.engine.create-entity" (list $ "container" "application" ($.Values.applicationContainer | default dict ) $.entities.deployments.workload ) -}}
  {{- end -}}
{{- end -}}



{{- define "subsystem-application.modules.deployment.process" -}}
{{- end -}}


