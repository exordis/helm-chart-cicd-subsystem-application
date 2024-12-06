{{- define "subsystem-application.entities.service.collection" -}}services{{- end -}}
{{- define "subsystem-application.entities.services.entity" -}}service{{- end -}}

{{- define "subsystem-application.entities.service.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
ports: []
spec: 
  sessionAffinity: None
{{- end -}}


{{- define "subsystem-application.entities.service.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $service := index . 2 -}}

# Set ports defaults
{{- range $portNumber, $port:=  $service.ports -}}
  {{- $_:= set $port "name" (printf "%s-%s" $service.id $portNumber) -}}
  {{- $_:= set $port "protocol" ( $port.protocol | default "TCP" ) -}}
{{- end -}}


# Return entity overrides
name: {{ include "sdk.naming.application.service" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}
spec:
  selector: {{- include "subsystem-application.metadata.selector-labels" $ | nindent 4 }}
  ports:
    {{- range $portNumber, $port :=  $service.ports }}
    - name: {{ $port.name }}
      protocol: {{ $port.protocol  }}
      port: {{ $portNumber }}
      targetPort: {{ $port.targetPort | default $portNumber }}
    {{- end -}}
{{- end }}


