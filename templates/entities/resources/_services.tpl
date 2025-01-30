{{- define "subsystem-application.entities.service.collection" -}}services{{- end -}}
{{- define "subsystem-application.entities.services.entity" -}}service{{- end -}}

{{- define "subsystem-application.entities.service.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
ports: {}
spec: 
  sessionAffinity: None
{{- end -}}


{{- define "subsystem-application.entities.service.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $service := index . 2 -}}
{{- $_ := unset $service.spec "selector" -}}
{{- $_ := set $service.spec "ports" list -}}
# Return entity overrides
kind: Service
name: {{ include "subsystem-application.naming.conventions.kind" (list $ $id "Service"  ) | quote }} 
spec:
  selector: {{- include "subsystem-application.metadata.selector-labels" $ | nindent 4 }}
  ports:
    {{- range $name, $port := $service.ports -}}
    {{- $port = $port | default dict }}
    {{- $_ := set $service.ports $name $port }}
    - name: {{ $name }}
      protocol: {{ $port.protocol | default "TCP"  }}
      port: {{ $port.port | default 80 }}
      targetPort: {{ $port.targetPort | default $name }}
    {{- end -}}

{{- end -}}


{{- define "subsystem-application.entities.service.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $service := index . 2 -}}
{{- end }}


