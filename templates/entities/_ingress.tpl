{{- define "subsystem-application.entities.ingress.collection" -}}ingresses{{- end -}}
{{- define "subsystem-application.entities.ingresses.entity" -}}ingress{{- end -}}

{{- define "subsystem-application.entities.ingress.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
type: internal
useRegex: false
proxyBuffering: true
proxyBodySize: -1
useTls: true
annotations: []
spec: {}
paths: []
tlsSecretName: {{ printf "%s-%s" ( include "sdk.naming.application.ingress" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id) ) "tls" }}
{{- end -}}


{{- define "subsystem-application.entities.ingress.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ingress := index . 2 -}}

name: {{ include "sdk.naming.application.ingress" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $id)  }}


{{- end -}}




{{- define "subsystem-application.entities.ingress.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ingress := index . 2 -}}
  # Use default backend where not provided explicitly 
  # TODO: check https://kubernetes.io/docs/concepts/services-networking/ingress/#types-of-ingress
  {{- if $ingress.default_backend -}}
    {{- range $path := $ingress.paths -}}
      {{- $_ := set $path "backend" ($path.backend | default $ingress.default_backend) -}}
    {{- end -}}
  {{- end -}}


  # Validate default backend references existing service
  {{- if hasKey $.entities.services $ingress.default_backend.service | not -}}
    {{- $error := printf "\nVALIDATION ISSUES:\n Ingress '%s' references missing service '%s'." $id $ingress.default_backend.service -}}
    {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
  {{- end -}}

  # Validate all backend fields reference existing services
  {{- range $path := $ingress.paths  -}}
    {{- if hasKey $path "backend" | and (hasKey $.entities.services $path.backend.service | not) -}}
      {{- $error := printf "\nVALIDATION ISSUES:\n Ingress '%s' path '%s' references missing service '%s'." $id $path.path $path.backend.service -}}
      {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
    {{- end -}}
  {{- end -}}




# Return entity overrides
spec:
  ingressClassName: "{{  (ternary "nginx-public" "nginx" ($ingress.type | eq "public")) }}"
  rules:
    {{- range $host := $ingress.hosts }}
    - host: {{$host}}
      http:
        paths:
      {{- range $path := $ingress.paths }}
          - backend:
              service:
                name:  {{ (get $.entities.services $path.backend.service).name}}
                # name:  {{ include "sdk.naming.application.service" (list $.Values.global.subsystem $.Values.application $.Values.instanceName $path.backend.service)  }}
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

{{- end }}




