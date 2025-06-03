{{- /*https://kubernetes.io/docs/concepts/services-networking/service/#field-spec-ports*/ -}}
{{- define "subsystem-application.entities.service.collection" -}}services{{- end -}}
{{- define "subsystem-application.entities.services.entity" -}}service{{- end -}}

{{- define "subsystem-application.entities.service.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-defaults" $ }}
ports: {}
spec: 
  sessionAffinity: None
  type: ClusterIP
{{- end -}}


{{- define "subsystem-application.entities.service.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $service := index . 2 -}}
{{- $_ := unset $service.spec "selector" -}}
{{- $_ := set $service.spec "ports" list -}}
{{- /*TODO: TBC - default ports to defined in applicationContainer */ -}}
# Return entity overrides
kind: Service
name: {{ include "sdk.naming.conventions.kind" (list $ $id "Service"  ) | quote }} 
labels:
  "exordis/service-name": {{ include "sdk.naming.conventions.kind" (list $ $id "Service"  ) | quote }} 
spec:
  selector: 
    {{- include "subsystem-application.metadata.selector-labels" $ | nindent 4 }}
    "exordis/application-workload": "true"
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
  {{- $wrong_ports := "" -}}


  {{- if $service.spec.type | ne "ExternalName" -}}
    {{- range $port := $service.spec.ports | default list  -}}
      {{- $found := false -}}

      {{- range $container := concat (list $.Values.applicationContainer) ($.Values.sidecars | default dict | values )  -}}
        {{- range $containerPort := (dig "spec" "ports" list $container)   -}}
          {{- $found = $found 
                        | or ($port.targetPort | toString | eq ($containerPort.name | default "")  )
                        | or ($port.targetPort | toString | eq ($containerPort.containerPort | default -1 | toString) )  -}}
        {{- end }}
      {{- end }}

      {{- if not $found -}}
        {{- $wrong_ports = printf "%s\n- service '%s' port '%s' targetPort '%s' is not exposed by 'application' container or any of sidecars" $wrong_ports $service.id $port.name ($port.targetPort| toString )   -}}    
      {{- end }}

    {{- end }}
  {{- end }}

  {{- if $wrong_ports | ne "" -}}
    {{- $error := printf "\nVALIDATION ISSUES: %s" $wrong_ports -}}
    {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
  {{- end }}
{{- end }}


