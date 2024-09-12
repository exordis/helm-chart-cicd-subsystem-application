{{- define "subsystem-application.entities.ingress.collection" -}}ingresses{{- end -}}

{{- define "subsystem-application.entities.ingress.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
type: internal
useRegex: false
proxyBuffering: true
proxyBodySize: -1
useTls: true
annotations: []
spec: {}
paths: []
tlsSecretName: {{ printf "%s-%s" ( include "sdk.naming.application.ingress" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id) ) "tls" }}
{{- end -}}

{{- define "subsystem-application.entities.ingress.overrides" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.ingress" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
{{- end -}}


{{- define "subsystem-application.entities.ingress.pre-process" -}}
  {{- if $.default_backend -}}
    {{- range $path := $.paths -}}
      {{- $_ := set $path "backend" ($path.backend | default $.default_backend) -}}
    {{- end -}}
  {{- end -}}
{{- end }}



