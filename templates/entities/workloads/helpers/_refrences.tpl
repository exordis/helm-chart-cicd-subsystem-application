{{- define "subsystem-application.entities.workloads.helpers.references" -}}
{{- $ := index . 0 -}}{{- $workload := index . 1 -}}


referencedConfigMaps:
  {{- range $configMap := $.entities.configMaps -}}
    {{- if eq $workload.namespace $configMap.namespace -}}
      {{- $referenceIsNeeded := false -}}
      {{- range $container := concat ($workload.containers | default dict | values) ($workload.initContainers | default dict | values) -}}
        {{- if or (not $configMap.containers ) (has $container.ref $configMap.containers ) }}{{- $referenceIsNeeded = true -}}{{- end -}}
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
        {{- if or (not $secret.containers ) (has $container.ref $secret.containers ) }}{{- $referenceIsNeeded = true -}}{{- end -}}
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
        {{- if or (not $secret.containers ) (has $container.ref $secret.containers ) }}{{- $referenceIsNeeded = true -}}{{- end -}}
      {{- end -}}
      {{- if $referenceIsNeeded }}
  - {{ $secret.targetSecretName }}
      {{- end -}}
    {{- end }}
  {{- end }}

{{- end }}