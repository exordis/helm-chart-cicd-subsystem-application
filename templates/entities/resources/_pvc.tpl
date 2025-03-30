{{- define "subsystem-application.entities.pvc.collection" -}}pvcs{{- end -}}
{{- define "subsystem-application.entities.pvcs.entity" -}}pvc{{- end -}}

{{- define "subsystem-application.entities.pvc.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-defaults" $ }}
mounts: {}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi    
{{- end -}}

{{- define "subsystem-application.entities.pvc.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $pvc := index . 2 -}}

# Return entity overrides
kind: PersistentVolumeClaim
name: {{ include "sdk.naming.conventions.kind" (list $ $id "PersistentVolumeClaim"  ) | quote }} 
{{- end -}}



{{- define "subsystem-application.entities.pvc.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $pvc := index . 2 -}}
    {{- $wrong_references := "" -}}

    {{- $known_containers := list -}}
    {{- range $workload := concat ($.entities.deployments | default dict | values) ($.entities.cronjobs | default dict | values)  -}}
      {{- range $container := $workload.containers | values | concat ($workload.initContainers | values)  -}}
        {{- $known_containers = $known_containers | concat (list $container.ref)  -}}
      {{- end -}}
    {{- end -}}
    
    {{- range $mount_ref := $pvc.mounts | keys -}}
      {{- if  $known_containers | has $mount_ref | not -}}
        {{- $wrong_references = printf "%s\n- pvc '%s' references undefined container '%s'" $wrong_references $id $mount_ref  -}}
      {{- end -}}
    {{- end -}}

    {{- if $wrong_references | ne "" -}}
      {{- $error := printf "\nVALIDATION ISSUES: %s" $wrong_references -}}
      {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
    {{- end }}

{{- end -}}

