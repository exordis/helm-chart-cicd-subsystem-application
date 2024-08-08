{{- define "subsystem-application.entities.init-container.collection" -}}initContainers{{- end -}}

{{- define "subsystem-application.entities.init-container.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{- $canonical_name := include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $id ) -}}
{{- $image:= printf "%s/software-development/subsystems/%s/%s-%s" $.Values.dockerRegistry $.Values.global.subsystem "service"  $canonical_name -}}
spec: {}
image: {{ $image }}
{{- end -}}

{{- define "subsystem-application.entities.init-container.overrides" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.deployment.container" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id )  }}
sidecar:  {{ not ($id | eq "applicationContainer") }}
{{- end -}}


{{- define "subsystem-application.entities.init-container.pre-process" -}}
{{- end }}


