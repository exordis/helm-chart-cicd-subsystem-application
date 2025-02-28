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
  {{- if or (dig "spec" "startupProbe" "tcpSocket" dict $container | len | eq 1) (dig "spec" "startupProbe" "exec" dict $container | len | eq 1) -}}
    {{- $_ := unset $container.spec.startupProbe "httpGet" -}}      
  {{- end -}}

  {{- if or (dig "spec" "livenessProbe" "tcpSocket" dict $container | len | eq 1) (dig "spec" "livenessProbe" "exec" dict $container | len | eq 1) -}}
    {{- $_ := unset $container.spec.livenessProbe "httpGet" -}}      
  {{- end -}}

  {{- if or (dig "spec" "readinessProbe" "tcpSocket" dict $container | len | eq 1) (dig "spec" "readinessProbe" "exec" dict $container | len | eq 1) -}}
    {{- $_ := unset $container.spec.readinessProbe "httpGet" -}}      
  {{- end -}}
{{- end -}}


{{- end }}



{{- define "subsystem-application.entities.applicationContainer.spec.defaults" -}}
startupProbe:
  failureThreshold: 20
  httpGet:
    path: /healthcheck/live
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 10
livenessProbe:
  failureThreshold: 5
  httpGet:
    path: /healthcheck/live
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 10
readinessProbe:
  httpGet:
    path: /healthcheck/ready
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 10
{{- end -}}