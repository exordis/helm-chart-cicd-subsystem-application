{{- define "subsystem-application.entities.container.collection" -}}containers{{- end -}}

{{- define "subsystem-application.entities.container.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{- $application_type := $id | eq "applicationContainer" | ternary $.Values.applicationType "service"  -}}
{{- $application := $id | eq "applicationContainer" | ternary $.Values.application $id  -}}
{{- $canonical_name := include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $application) -}}
{{- $image:= printf "%s/software-development/subsystems/%s/%s-%s" $.Values.dockerRegistry $.Values.global.subsystem $application_type  $canonical_name -}}
spec: {}
image: {{ $image }}
{{- end -}}

{{- define "subsystem-application.entities.container.overrides" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.deployment.container" (list $.Values.global.subsystem $.Values.application $.Values.instanceName ( $id | eq "applicationContainer" | ternary "" $id) )  }}
sidecar:  {{ not ($id | eq "applicationContainer") }}
{{- end -}}


{{- define "subsystem-application.entities.container.pre-process" -}}
{{- end }}


