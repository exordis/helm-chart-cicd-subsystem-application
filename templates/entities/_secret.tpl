{{- define "subsystem-application.entities.secret.collection" -}}secrets{{- end -}}
{{- define "subsystem-application.entities.secrets.entity" -}}secret{{- end -}}
{{- define "subsystem-application.entities.secret.subcollections" -}}{{- end -}}

{{- define "subsystem-application.entities.secret.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
namespace: {{ include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem $.Values.global.environment) | quote}}
containers:
stringData: {}
{{- end -}}

{{- define "subsystem-application.entities.secret.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.secret" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
{{- end -}}


{{- define "subsystem-application.entities.secret.process" -}}
{{- end }}