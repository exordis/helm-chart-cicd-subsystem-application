{{- define "subsystem-application.entities.container.collection" -}}containers{{- end -}}
{{- define "subsystem-application.entities.containers.entity" -}}container{{- end -}}
{{- define "subsystem-application.entities.container.subcollections" -}}{{- end -}}

{{- define "subsystem-application.entities.container.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}

{{- $data:=  include "subsystem-application.entities.container-base.defaults" .  | fromYaml -}}
{{- if $id | eq "applicationContainer" }}
  {{- $_:= mustMergeOverwrite $data.spec (include "subsystem-application.entities.applicationContainer.spec.defaults" . | fromYaml ) -}}
{{- end -}} 

{{ $data | toYaml| nindent 2}}



{{- end -}}



{{- define "subsystem-application.entities.container.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}

{{- $data:= include "subsystem-application.entities.container-base.create" . | fromYaml -}}
{{- $_:= set $data "sidecar" ($id | eq "applicationContainer" | not) -}}
{{ $data | toYaml| nindent 2}}
{{- end -}}

{{- define "subsystem-application.entities.container.process" -}}
{{- include "subsystem-application.entities.container-base.process" . -}}
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