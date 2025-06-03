{{- define "subsystem-application.entities.service-monitor.collection" -}}serviceMonitors{{- end -}}
{{- define "subsystem-application.entities.serviceMonitors.entity" -}}service-monitor{{- end -}}

{{- define "subsystem-application.entities.service-monitor.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-defaults" $ }}
spec: {}
endpoints: []
{{- end -}}


{{- define "subsystem-application.entities.service-monitor.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $monitor := index . 2 -}}

# Return entity overrides
kind: ServiceMonitor
name: {{ include "sdk.naming.conventions.kind" (list $ $id "ServiceMonitor"  ) | quote }} 
spec:
  endpoints:
  {{- range $endpoint := $monitor.endpoints -}}
    {{- $_ := set $endpoint "interval" ($endpoint.interval | default "15s") }}
    - {{ $endpoint | toYaml | nindent 6 }}
  {{- end -}}
{{- end -}}



{{- define "subsystem-application.entities.service-monitor.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $monitor := index . 2 -}}
{{- $_ := unset $monitor.spec "namespaceSelector" -}}
{{- $_ := set $monitor.spec "selector" list -}}

{{- $service := get $.entities.services $monitor.service -}}
{{- $_ := set $monitor.spec "jobLabel" ($monitor.spec.jobLabel | default $monitor.service) -}}
spec:
  namespaceSelector:
    matchNames:
      - {{ $service.namespace | quote }}  
  selector:
      matchLabels: 
        {{- include "subsystem-application.metadata.selector-labels" $ | nindent 8 }}

{{- end -}}


