{{- define "subsystem-application.entities.service.collection" -}}services{{- end -}}
{{- define "subsystem-application.entities.services.entity" -}}service{{- end -}}

{{- define "subsystem-application.entities.service.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
ports: []
spec: 
  sessionAffinity: None
{{- end -}}


{{- define "subsystem-application.entities.service.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $service := index . 2 -}}

# Return entity overrides
kind: Service
name: {{ include "subsystem-application.convention.name" (list $ $id "Service"  ) | quote }} 
spec:
  selector: {{- include "subsystem-application.metadata.selector-labels" $ | nindent 4 }}
  ports:
    {{- range $portNumber, $port :=  $service.ports -}}
    {{- $port = $port | default dict }}
    - name: {{ $port.name | default (printf "%s-%s" $id $portNumber) }}
      protocol: {{ $port.protocol | default "TCP"  }}
      port: {{ $portNumber }}
      targetPort: {{ $port.targetPort | default $portNumber }}
    {{- end -}}

{{- end -}}


{{- define "subsystem-application.entities.service.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $service := index . 2 -}}
{{- end }}


