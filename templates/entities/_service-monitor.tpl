{{- define "subsystem-application.entities.service-monitor.collection" -}}serviceMonitors{{- end -}}

{{- define "subsystem-application.entities.service-monitor.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
spec:
    endpoints:
    - path: /metrics
      basicAuth:
        password:
          key: Metrics__Authentication__Password
          name: {{ include "sdk.naming.application.external-secret" (list $.Values.global.subsystem $.Values.application $.Values.instanceName "main")  }}
        username:
          key: Metrics__Authentication__Username
          name: {{ include "sdk.naming.application.external-secret" (list $.Values.global.subsystem $.Values.application $.Values.instanceName "main")  }}
{{- end -}}

{{- define "subsystem-application.entities.service-monitor.overrides" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.service-monitor" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id) }}
{{- end -}}


{{- define "subsystem-application.entities.service-monitor.pre-process" -}}
{{- end }}


