{{- define "subsystem-application.entities.secret.collection" -}}secrets{{- end -}}
{{- define "subsystem-application.entities.secrets.entity" -}}secret{{- end -}}

{{- define "subsystem-application.entities.secret.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
containers:
stringData: {}
{{- end -}}

{{- define "subsystem-application.entities.secret.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
kind: "Secret"
name: {{ include "subsystem-application.convention.name" (list $ $id "Secret"  ) | quote }} 
{{- end -}}


{{- define "subsystem-application.entities.secret.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $secret := index . 2 -}}
{{- include "subsystem-application.validation.container-refs" (list $ "Secret" $id $secret.containers ) -}}



{{- end }}