{{- define "subsystem-application.validation.container-refs" -}}
{{- $ := index . 0 -}}{{- $referrer_type := index . 1 -}}{{- $referrer_id := index . 2 -}}{{- $containers := index . 3 -}}{{- $namespace := index . 4 -}}
  {{- $wrong_references := "" -}}
  {{- $wrong_namespaces := "" -}}
  {{- range $container := $containers | default list -}}
      {{- $parent_entity_collection := "" -}}
      {{- $parent_id := "" -}}
      {{- $container_id := "" -}}

      {{- $wrong_id := false -}}
      {{- $wrong_namespace := false -}}

      {{- $parts := split "." $container -}}
      {{- if $parts | len | eq 1 | and ($.Values.workload.enabled ) -}}
        {{- /*TODO: extract templates to get collection by entity name and vice versa */ -}}
        {{- $templates_prefix :=  (include "sdk.engine._templates_prefix" $) | toYaml -}}
        {{- $collection_name_template := printf (printf "%s.entities.%%s.collection" $templates_prefix) ( $.Values.workload.kind | lower ) -}}
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

          {{- if and (not $wrong_id) ( $parent.namespace | ne $namespace )  -}}
            {{ $wrong_references = printf "%s\n- %s '%s' references container '%s' from namespace '%s' while belongs to '%s' " $wrong_references $referrer_type $referrer_id $container $parent.namespace $namespace -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}      

      {{- if $wrong_id -}}
        {{- $wrong_references = printf "%s\n- %s '%s' references undefined container '%s'" $wrong_references $referrer_type $referrer_id $container  -}}
      {{- end -}}
  
  {{- end -}}

  {{- if $wrong_references | ne "" -}}
    {{- $error := printf "\nVALIDATION ISSUES: %s" $wrong_references -}}
    {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
  {{- end }}

{{- end }}