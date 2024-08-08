{{- define "subsystem-application.entities.service.collection" -}}services{{- end -}}

{{- define "subsystem-application.entities.service.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
ports: []
spec: {}
{{- end -}}

{{- define "subsystem-application.entities.service.overrides" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.service" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
{{- end -}}


{{- define "subsystem-application.entities.service.pre-process" -}}
    {{- range $portNumber, $port:=  $.ports -}}
      {{- $_:= set $port "name" (printf "%s-%s" $.id $portNumber) -}}
      {{- $_:= set $port "protocol" ( $port.protocol | default "TCP" ) -}}
    {{- end -}}
{{- end }}


