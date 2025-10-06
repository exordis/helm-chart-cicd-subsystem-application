{{- define "subsystem-application.entities.external-secret.collection" -}}externalSecrets{{- end -}}
{{- define "subsystem-application.entities.externalSecrets.entity" -}}external-secret{{- end -}}

{{- define "subsystem-application.entities.external-secret.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{- /*TODO: Better default ClusterSecretStore name resolution. For now just relay on convention*/ -}}
{{ include "subsystem-application.metadata.entity-defaults" $ }}
containers:
spec:
  secretStoreRef:
    name: {{ include "sdk.naming.conventions.kind" (list $ "" "ClusterSecretStore"  ) | quote }}
    kind: ClusterSecretStore
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
name: {{ include "sdk.naming.conventions.kind" (list $ $id "ExternalSecret"  ) | quote }} 
targetSecretName: {{ include "sdk.naming.conventions.kind" (list $ $id "Secret"  ) | quote }} 

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

{{- /*TODO: Better ClusterSecretStore name resolution. For now just relay on convention*/ -}}
spec:
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
        {{- range $secretKey,$remoteRef := $externalSecret.keys -}} 
        {{- $remoteRef = $remoteRef | default $secretKey }}
        {{ $secretKey }}: '{{`{{`}} .{{$secretKey}} {{`}}`}}'
        {{- $_ := set $externalSecret.spec "data" ( append $externalSecret.spec.data  (dict "secretKey" $secretKey "remoteRef" (dict "key" $remoteRef) ) ) -}}
        {{- end }} 
      {{- end }} 
{{- end }}