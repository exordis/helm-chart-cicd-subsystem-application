{{- define "subsystem-application.validation.container-refs" -}}
{{- $ := index . 0 -}}{{- $referrer_type := index . 1 -}}{{- $referrer_id := index . 2 -}}{{- $containers := index . 3 -}}
  {{- $wrong_references := "" -}}
  {{- range $container := $containers | default list -}}
      {{- $parent_entity_collection := "" -}}
      {{- $parent_id := "" -}}
      {{- $container_id := "" -}}

      {{- $wrong_id := false -}}

      {{- $parts := split "." $container -}}
      {{- if $parts | len | eq 1 | and ($.Values.workload | ne "none") -}}
        {{- /*TODO: extract templates to get collection by entity name and vice versa */ -}}
        {{- $templates_prefix :=  (include "sdk.engine._templates_prefix" $) | toYaml -}}
        {{- $collection_name_template := printf (printf "%s.entities.%%s.collection" $templates_prefix) $.Values.workload -}}
        {{- $parent_entity_collection = (include $collection_name_template $) -}}
        {{- $parent_id = "workload" -}}
        {{- $container_id = $container -}}
      {{- else if $parts | len | eq 3 -}}
        {{- $parent_entity_collection = $parts._0 -}}
        {{- $parent_id = index $parts._1 -}}
        {{- $container_id = index $parts._2 -}}
      {{- else -}}
        {{- $wrong_id = true -}}
      {{- end -}}      

      {{- if not $wrong_id -}}
        {{- if hasKey $.entities $parent_entity_collection | not -}}
          {{- $wrong_id = true -}}
        {{- else -}}
          {{- $collection := index $.entities $parent_entity_collection -}}   
          {{- $parent := index $collection $parent_id | default nil -}}   
          
          {{- if not $parent -}}
            {{- $wrong_id = true -}}
          {{- end -}}    

          {{- if not (has $container_id (concat ($parent.containers | default dict | keys ) ($parent.initContainers | default dict | keys) ) )   -}}
            {{- $wrong_id = true -}}
          {{- end -}}

        {{- end -}}
      {{- end -}}      

      {{- if $wrong_id -}}
        {{- if $wrong_references | ne "" -}}
          {{ $wrong_references = printf "%s, '%s'" $wrong_references $container  -}}
        {{- else -}}
          {{ $wrong_references = printf "'%s'" $container  -}}
        {{- end -}}
      {{- end -}}


  
  {{- end -}}

  {{- if gt ($wrong_references | len) 0 -}}
    {{- /* Container reference should have one part for main workload container and three part for others  */ -}}
    {{- $error := printf "\nVALIDATION ISSUES:\n %s '%s' references undefined containers: %s" $referrer_type $referrer_id $wrong_references -}}
    {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
  {{- end }}

{{- end }}