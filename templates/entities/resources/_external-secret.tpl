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
targetSecretName: {{ include "subsystem-application.naming.conventions.kind" (list $ $id "Secret"  ) | quote }} 
key:
{{- end -}}



{{- define "subsystem-application.entities.external-secret.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $externalSecret := index . 2 -}}
kind: ExternalSecret
name: {{ include "subsystem-application.naming.conventions.kind" (list $ $id "ExternalSecret"  ) | quote }} 
spec:
  secretStoreRef:
    name: {{ include "subsystem-application.naming.conventions.kind" (list $ "" "ClusterSecretStore"  ) | quote }} 
    kind: ClusterSecretStore
  target:
    name: {{ $externalSecret.targetSecretName }}    
    template:
      metadata:
        labels:
          {{- include "subsystem-application.metadata.common-labels" $ | nindent 10 }}
        annotations:
          {{- include "subsystem-application.metadata.common-annotations" $ | nindent 10 }}
{{- /* apply default binding if none is provided in external secret sepc*/ -}}  
{{- if  and (not $externalSecret.spec.data) (not $externalSecret.spec.dataFrom) ($externalSecret.key)  }}
    data:
      - secretKey: {{ $externalSecret.key }}
        remoteRef:
          key: {{ $externalSecret.key }}
{{- end -}} 

{{- end -}}


{{- define "subsystem-application.entities.external-secret.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $externalSecret := index . 2 -}}



{{- end }}