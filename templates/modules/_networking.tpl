{{- define "subsystem-application.modules.networking.read" -}}

  {{- range $id, $ingress := $.Values.ingresses -}}  
    {{- include "sdk.engine.create-entity" (list $ "ingress" $id $ingress) -}}
  {{- end -}}
  
  {{- range $id, $service := $.Values.services -}}
    {{- include "sdk.engine.create-entity" (list $ "service" $id $service) -}}
  {{- end -}}

  {{- range $id, $service := $.Values.services -}}
    {{- if hasKey $service "monitor" -}}
        {{- include "sdk.engine.create-entity" (list $ "service-monitor" $id $service.monitor ) -}}
    {{- end -}}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.networking.process" -}}
  
  {{- range $name, $ingress := $.entities.ingresses -}}
    {{- $spec_overrides := (include "subsystem-application.modules.ingress._ingress-spec-overrides" (list $ $ingress)) |fromYaml -}}
    {{- $_:= set $ingress "spec" (include "sdk.common.with-defaults" (list $ $ingress.spec "subsystem-application.configuration.defaults.specs.ingress" $spec_overrides) | fromYaml )  -}}
    {{- if hasKey $.entities.services $ingress.default_backend.service | not -}}
      {{- $error := printf "\nVALIDATION ISSUES:\n Ingress '%s' references missing service '%s'." $name $ingress.default_backend.service -}}
      {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
    {{- end -}}

    {{- range $path := $ingress.paths  -}}
      {{- if hasKey $path "backend" | and (hasKey $.entities.services $path.backend.service | not) -}}
        {{- $error := printf "\nVALIDATION ISSUES:\n Ingress '%s' path '%s' references missing service '%s'." $name $path.path $path.backend.service -}}
        {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
      {{- end -}}
    {{- end -}}

  {{- end -}}

  {{- range $id, $service := $.entities.services -}}
    {{- $spec_overrides := (include "subsystem-application.modules.ingress._service-spec-overrides" (list $ $service)) |fromYaml -}}
    {{- $_:= set $service "spec" (include "sdk.common.with-defaults" (list $ $service.spec "subsystem-application.configuration.defaults.specs.service" $spec_overrides ) | fromYaml )  -}}
  {{- end -}}

  {{- range $id, $serviceMonitor := $.entities.serviceMonitors -}}
    {{- $spec_overrides := (include "subsystem-application.modules.ingress._service-monitor-spec-overrides" (list $ $serviceMonitor)) |fromYaml -}}
    {{- $_:= set $serviceMonitor "spec" (include "sdk.common.with-defaults" (list $ $serviceMonitor.spec "subsystem-application.configuration.defaults.specs.service-monitor" $spec_overrides ) | fromYaml )  -}}
  {{- end -}}

{{- end -}}



{{- define "subsystem-application.modules.ingress._ingress-spec-overrides" -}}
{{- $ := index . 0 -}}{{- $ingress := index . 1 -}}
ingressClassName: "{{  (ternary "nginx-public" "nginx" ($ingress.type | eq "public")) }}"
rules:
  {{- range $host := $ingress.hosts }}
  - host: {{$host}}
    http:
      paths:
    {{- range $path := $ingress.paths }}
        - backend:
            service:
              name:  {{ include "sdk.naming.application.service" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $path.backend.service)  }}
              port:
                number: {{$path.backend.port}}
          path: {{$path.path}}
          pathType: {{$path.pathType | quote }}      
    {{- end -}}
  {{- end }}
tls:
  - hosts:
    {{- range $host := $ingress.hosts }}
      - {{ $host }}
    {{- end }}
    secretName: {{ $ingress.tlsSecretName }}
{{- end -}}


{{- define "subsystem-application.modules.ingress._service-spec-overrides" -}}
{{- $ := index . 0 -}}{{- $service := index . 1 -}}
selector: {{- include "subsystem-application.metadata.selector-labels" $ | nindent 2 }}
ports:
  {{- range $portNumber, $port:=  $service.ports }}
  - name: {{ $port.name }}
    protocol: {{ $port.protocol  }}
    port: {{ $portNumber }}
    targetPort: {{ $port.targetPort | default $portNumber }}
  {{- end -}}
{{- end -}}

{{- define "subsystem-application.modules.ingress._service-monitor-spec-overrides" -}}
{{- $ := index . 0 -}}{{- $service := index . 1 -}}
selector:
    matchLabels: {{- include "subsystem-application.metadata.selector-labels" $ | nindent 6 }}
{{- end -}}