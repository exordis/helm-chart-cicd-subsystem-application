{{- define "subsystem-application.entities.service-monitor.collection" -}}serviceMonitors{{- end -}}
{{- define "subsystem-application.entities.serviceMonitors.entity" -}}service-monitor{{- end -}}

{{- define "subsystem-application.entities.service-monitor.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
spec:
  endpoints:
    - path: /metrics
      basicAuth:
        password:
          key: Metrics__Authentication__Password
          name: {{ include "subsystem-application.naming.conventions.kind" (list $ "main" "ExternalSecret"  ) | quote }} 
        username:
          key: Metrics__Authentication__Username
          name: {{ include "subsystem-application.naming.conventions.kind" (list $ "main" "ExternalSecret"  ) | quote }} 
{{- end -}}


{{- define "subsystem-application.entities.service-monitor.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ingress := index . 2 -}}

# Return entity overrides
kind: ServiceMonitor
name: {{ include "subsystem-application.naming.conventions.kind" (list $ $id "ServiceMonitor"  ) | quote }} 
spec:
  selector:
      matchLabels: {{- include "subsystem-application.metadata.selector-labels" $ | nindent 8 }}

{{- end -}}



{{- define "subsystem-application.entities.service-monitor.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $serviceMonitor := index . 2 -}}


{{- end -}}


