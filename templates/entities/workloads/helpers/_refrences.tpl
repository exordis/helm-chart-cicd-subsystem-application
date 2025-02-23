{{- define "subsystem-application.entities.workloads.helpers.references" -}}
{{- $ := index . 0 -}}{{- $workload := index . 1 -}}

{{- $ref_template := "%s" -}}
{{- if ne $workload.workloadType "main" -}}
  {{- $templates_prefix :=  (include "sdk.engine._templates_prefix" $) | toYaml -}}
  {{- $workload_collection := printf (printf "%s.entities.%%s.collection" $templates_prefix) $workload.entity_type  -}}        
  {{- $ref_template = printf "%s.%s.%%s" $workload.id $workload_collection -}}
{{- end -}}

referencedConfigMaps:
  {{- range $configMap := $.entities.configMaps -}}
    {{- if eq $workload.namespace $configMap.namespace -}}
      {{- $referenceIsNeeded := false -}}
      {{- range $container := concat ($workload.containers | default dict | values) ($workload.initContainers | default dict | values) -}}
        {{- $ref := printf $ref_template $container.id -}}
        {{- if or (not $configMap.containers ) (has $ref $configMap.containers ) }}{{- $referenceIsNeeded = true -}}{{- end -}}
      {{- end -}}
      {{- if $referenceIsNeeded }}
  - {{ $configMap.id }}
      {{- end -}}
    {{- end }}
  {{- end }}
referencedSecrets:
  {{- range $secret := $.entities.secrets -}}
    {{- if eq $workload.namespace $secret.namespace -}}
      {{- $referenceIsNeeded := false -}}
      {{- range $container := concat ($workload.containers | default dict | values) ($workload.initContainers | default dict | values) -}}
        {{- $ref := printf $ref_template $container.id -}}
        {{- if or (not $secret.containers ) (has $ref $secret.containers ) }}{{- $referenceIsNeeded = true -}}{{- end -}}
      {{- end -}}
      {{- if $referenceIsNeeded }}
  - {{ $secret.id }}
      {{- end -}}
    {{- end }}
  {{- end }}

referencedExternalSecrets:
  {{- range $secret := $.entities.externalSecrets -}}
    {{- if eq $workload.namespace $secret.namespace -}}
      {{- $referenceIsNeeded := false -}}
      {{- range $container := concat ($workload.containers | default dict | values) ($workload.initContainers | default dict | values) -}}
        {{- $ref := printf $ref_template $container.id -}}
        {{- if or (not $secret.containers ) (has $ref $secret.containers ) }}{{- $referenceIsNeeded = true -}}{{- end -}}
      {{- end -}}
      {{- if $referenceIsNeeded }}
  - {{ $secret.targetSecretName }}
      {{- end -}}
    {{- end }}
  {{- end }}

{{- end }}