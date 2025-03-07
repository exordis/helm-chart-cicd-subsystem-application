{{- /* TODO: schema oneof - pvc/configmap/secret/externalSecret/none (spec should not have secret: configmap etc) and validate spec to have only one of configmap/secret/etc  */ -}}
{{- define "subsystem-application.entities.volume.collection" -}}volumes{{- end -}}
{{- define "subsystem-application.entities.volumes.entity" -}}volume{{- end -}}

{{- define "subsystem-application.entities.volume.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}

mounts: {}
spec:
{{- if $data.spec | default dict | len | ne 0 -}}
  {}
{{- else if hasKey $data "pvc" }}
  persistentVolumeClaim:
    claimName: ""
{{- else if hasKey $data "configMap" }}  
  configMap:
    name: ""
{{- else if hasKey $data "secret" }}  
  secret:
    secretName: ""
{{- else if hasKey $data "externalSecret" }}  
  secret:
    secretName: ""
{{- else }}  
  emptyDir:
    sizeLimit: 100Mi
{{- end -}}

{{- end -}}


{{- define "subsystem-application.entities.volume.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $volume := index . 2 -}}{{- $parent := index . 3 -}}
kind: Volume
name: {{ include "sdk.naming.conventions.component" (list $ $id "Volume" $parent.id $parent.kind   ) | quote }}

{{- end -}}


{{- define "subsystem-application.entities.volume._expand_projected" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $volume := index . 2 -}}{{- $source_type := index . 3 -}}{{- $name := index . 4 -}}
{{- if hasKey  ($volume.spec | default dict) "projected" -}}
  {{- $newSources := list -}}
  {{- range $source := dig "spec" "projected" "sources" list $volume }}
    {{- $source = $source | default dict | deepCopy -}}

    {{- if hasKey $source $source_type -}}
      {{- if dig "name" "" ($source.configMap | default dict) | eq "" -}}
        {{- $source = mustMergeOverwrite $source (dict $source_type (dict "name" $name)) -}}
      {{- end -}}
    {{- end -}}
    
    {{- $newSources = append $newSources $source -}}
  {{- end -}}
  {{- $_ := set $volume.spec.projected "sources" $newSources  -}}
{{- end -}}
{{- end -}}


{{- define "subsystem-application.entities.volume.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $volume := index . 2 -}}
spec:
  name: {{$volume.name}}
  {{- /* Handle pvc reference */ -}}
  {{- if $volume.pvc -}}
    {{- /* Validate referenced pvc exists */ -}}
    {{- if hasKey $.entities.pvcs $volume.pvc | not -}}
      {{- $error := printf "\nVALIDATION ISSUES:\n Volume '%s' references missing PVC '%s'." $id $volume.pvc -}}
      {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
    {{- end -}}

    {{- $pvc := get $.entities.pvcs $volume.pvc -}} 
    {{- if $pvc.namespace | ne $volume.parent.namespace -}}
      {{- $error := printf "\nVALIDATION ISSUES:\n Volume '%s' references PVC '%s' which does not belong to same namespace as %s '%s'" $id $volume.pvc $volume.parent.entity_type $volume.parent.id -}}
      {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
    {{- end -}}

    {{- if hasKey $volume.spec "persistentVolumeClaim" | and (dig "spec" "persistentVolumeClaim" "claimName" "" $volume | eq "") }}
  persistentVolumeClaim:
    claimName: {{ $pvc.name }}
    {{- end }}    
  {{- end }}


  {{- /* Handle configmap reference */ -}}
  {{- if $volume.configMap -}}
    {{- /* Validate referenced configmap exists */ -}}
    {{- if hasKey $.entities.configMaps $volume.configMap | not -}}
      {{- $error := printf "\nVALIDATION ISSUES:\n Volume '%s' references missing ConfigMap '%s'." $id $volume.configMap -}}
      {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
    {{- end -}}

    {{- $configmap := get $.entities.configMaps $volume.configMap -}} 
    {{- if $configmap.namespace | ne $volume.parent.namespace -}}
      {{- $error := printf "\nVALIDATION ISSUES:\n Volume '%s' references ConfigMap '%s' which does not belong to same namespace as %s '%s'" $id $volume.configMap $volume.parent.entity_type $volume.parent.id -}}
      {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
    {{- end -}}

    {{- include "subsystem-application.entities.volume._expand_projected" (list $ $id $volume "configMap" $configmap.name) -}} 



    {{- if hasKey $volume.spec "configMap" | and (dig "spec" "configMap" "name" "" $volume | eq "") }}
  configMap:
    name: {{ $configmap.name }}
    {{- end }}


  {{- end }}

  {{- /* Handle secret reference */ -}}
  {{- if $volume.secret -}}
    {{- /* Validate referenced secrets exists */ -}}
    {{- if or (hasKey $.entities.secrets $volume.secret) (hasKey $.entities.externalSecrets $volume.secret) | not -}}
      {{- $error := printf "\nVALIDATION ISSUES:\n Volume '%s' references missing Secret '%s'. Should be valid  id from Values.secrets or Values.externalSecrets" $id $volume.secret -}}
      {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
    {{- end -}}

    {{- $secretName := "" -}}
    {{- if hasKey $.entities.secrets $volume.secret  -}}
      {{- $secret := (get $.entities.secrets $volume.secret) }} 
      {{- if $secret.namespace | ne $volume.parent.namespace -}}
        {{- $error := printf "\nVALIDATION ISSUES:\n Volume '%s' references Secret '%s' which does not belong to same namespace as %s '%s'" $id $volume.secret $volume.parent.entity_type $volume.parent.id -}}
        {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
      {{- end -}}

      {{- $secretName = $secret.name }} 
    {{- else -}}
      {{- $externalSecrets := (get $.entities.externalSecrets $volume.secret) }} 
      {{- if $externalSecrets.namespace | ne $volume.parent.namespace -}}
        {{- $error := printf "\nVALIDATION ISSUES:\n Volume '%s' references ExternalSecret '%s' which does not belong to same namespace as %s '%s'" $id $volume.secret $volume.parent.entity_type $volume.parent.id -}}
        {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
      {{- end -}}

      {{- $secretName = $externalSecrets.targetSecretName }} 
    {{- end -}}


    {{- include "subsystem-application.entities.volume._expand_projected" (list $ $id $volume "secret" $secretName) -}} 


    {{- if hasKey $volume.spec "secret" | and (dig "spec" "secret" "secretName" "" $volume | eq "") }}
  secret:
    secretName: {{ $secretName }}
    {{- end }}

  {{- end -}}

{{- end -}}

