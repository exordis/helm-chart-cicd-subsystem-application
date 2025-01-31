{{- define "subsystem-application.entities.external-secret.collection" -}}externalSecrets{{- end -}}
{{- define "subsystem-application.entities.externalSecrets.entity" -}}external-secret{{- end -}}

{{- define "subsystem-application.entities.external-secret.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
containers:
spec: 
  refreshInterval: 1m
  target:
    creationPolicy: Owner
    deletionPolicy: Retain
  data: []
keys: []
{{- end -}}



{{- define "subsystem-application.entities.external-secret.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $externalSecret := index . 2 -}}
kind: ExternalSecret
name: {{ include "subsystem-application.naming.conventions.kind" (list $ $id "ExternalSecret"  ) | quote }} 
targetSecretName: {{ include "subsystem-application.naming.conventions.kind" (list $ $id "Secret"  ) | quote }} 

{{- end -}}


{{- define "subsystem-application.entities.external-secret.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $externalSecret := index . 2 -}}
{{- include "subsystem-application.validation.container-refs" (list $ "ExternalSecret" $id $externalSecret.containers $externalSecret.namespace) -}}

{{- $templateFrom := dig "spec" "target" "template" "templateFrom" list $externalSecret -}}
{{- range $ref := $templateFrom -}}
  {{- $configMapName := dig "configMap" "name" "" $ref -}}
  {{- if $configMapName | ne "" -}}
    {{- $configMap := dig $ref.configMap.name (dict "name" $ref.configMap.name) $.entities.configMaps -}}
    {{- $_ := set $ref.configMap "name" $configMap.name -}}
  {{- end -}}
{{- end -}}


spec:
  secretStoreRef:
    name: {{ $externalSecret.name | quote }} 
    kind: ClusterSecretStore
  target:
    name: {{ $externalSecret.targetSecretName }}    
    template:
      metadata:
        labels:
          {{- $targetLabels := dig "spec" "target" "template" "metadata" "labels" dict $externalSecret -}}
          {{- include "subsystem-application.metadata.common-labels" $ | fromYaml | mustMergeOverwrite $externalSecret.labels $targetLabels | toYaml | nindent 10 }}
        annotations:
          {{- $targetAnnotations := dig "spec" "target" "template" "metadata" "annotations" dict $externalSecret -}}
          {{- include "subsystem-application.metadata.common-annotations" $  | fromYaml | mustMergeOverwrite $externalSecret.annotations $targetAnnotations | toYaml | nindent 10 }}
      {{- if $externalSecret.keys }}
      data:
        {{- range $remoteRef, $secretKey := $externalSecret.keys -}} 
        {{- $secretKey = $secretKey | default $remoteRef}}
        {{ $secretKey }}: '{{`{{`}} .{{$secretKey}} {{`}}`}}'
        {{- $_ := set $externalSecret.spec "data" ( append $externalSecret.spec.data  (dict "secretKey" $secretKey "remoteRef" (dict "key" $remoteRef) ) ) -}}
        {{- end }} 
      {{- end }} 
{{- end }}