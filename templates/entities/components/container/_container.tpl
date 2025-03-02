{{- define "subsystem-application.entities.container.collection" -}}containers{{- end -}}
{{- define "subsystem-application.entities.containers.entity" -}}container{{- end -}}

{{- define "subsystem-application.entities.container.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}

{{- $defaults:=  include "subsystem-application.entities.container-base.defaults" .  | fromYaml -}}
{{- if $id | eq "application" }}
  {{- $_:= mustMergeOverwrite $defaults.spec (include "subsystem-application.entities.applicationContainer.spec.defaults" . | fromYaml ) -}}
{{- end -}} 

{{ $defaults | toYaml| nindent 2}}



{{- end -}}



{{- define "subsystem-application.entities.container.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}

{{- $data:= include "subsystem-application.entities.container-base.create" . | fromYaml -}}
{{- $_:= set $data "sidecar" ($id | eq "application" | not) -}}


{{ $data | toYaml| nindent 2}}

{{- end -}}

{{- define "subsystem-application.entities.container.process" -}}
{{- include "subsystem-application.entities.container-base.process" . -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $container := index . 2 -}}

  {{- if $id | eq "application" -}}
    {{- range $probe:= list "startupProbe" "livenessProbe" "readinessProbe"  -}}
      {{- if and (dig "spec" $probe "tcpSocket" dict $container | len | eq 0) (dig "spec" $probe "exec" dict $container | len | eq 0)  (dig "spec" $probe "httpGet" dict $container | len | eq 0) -}}
        {{- $found := false -}}
        {{- range $port := $container.spec.ports | default list -}}
          {{- if $port.protocol | default "TCP" | eq "TCP" | and (not $found) }}
            {{- $found = true }}
  {{$probe}}:           
    tcpSocket:
      port: {{$port.containerPort }}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end -}}


{{- end }}



{{- define "subsystem-application.entities.applicationContainer.spec.defaults" -}}
startupProbe:
  failureThreshold: 30
  periodSeconds: 5
  successThreshold: 1
  timeoutSeconds: 1
livenessProbe:
  failureThreshold: 30
  periodSeconds: 10
  successThreshold: 1
  timeoutSeconds: 1
readinessProbe:
  failureThreshold: 30
  periodSeconds: 10
  successThreshold: 1
  timeoutSeconds: 1
{{- end -}}