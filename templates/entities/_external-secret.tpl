{{- define "subsystem-application.entities.external-secret.collection" -}}externalSecrets{{- end -}}

{{- define "subsystem-application.entities.external-secret.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
containers:
spec: {}
key:
{{- end -}}

{{- define "subsystem-application.entities.external-secret.overrides" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.external-secret" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
targetSecretName: {{ $data.targetSecretName | default (include "sdk.naming.application.secret" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)) }}
{{- end -}}


{{- define "subsystem-application.entities.external-secret.pre-process" -}}
{{- end }}