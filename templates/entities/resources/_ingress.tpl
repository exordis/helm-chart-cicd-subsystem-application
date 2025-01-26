{{- define "subsystem-application.entities.ingress.collection" -}}ingresses{{- end -}}
{{- define "subsystem-application.entities.ingresses.entity" -}}ingress{{- end -}}

{{- define "subsystem-application.entities.ingress.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
type: internal
default_backend: {}
useRegex: false
proxyBuffering: true
proxyBodySize: -1
useTls: true
annotations: []
spec: {}
paths: []
tlsSecretName: {{ printf "%s-%s" ( include "sdk.naming.application.ingress" (list $.Values.global.subsystem $.Values.application $.Values.instance $id) ) "tls" }}
{{- end -}}


{{- define "subsystem-application.entities.ingress.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ingress := index . 2 -}}

name: {{ include "sdk.naming.application.ingress" (list $.Values.global.subsystem $.Values.application $.Values.instance $id)  }}
{{- end -}}




{{- define "subsystem-application.entities.ingress.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ingress := index . 2 -}}
  # Validate default backend references existing service
  {{- if and (hasKey $ingress.default_backend "service") (hasKey $.entities.services $ingress.default_backend.service | not) ($ingress.default_backend.foreign | default false | not) -}}
    {{- $error := printf "\nVALIDATION ISSUES:\n Ingress '%s' default backend references missing service '%s'. Either explicitly mark backend with `foreign: true` or define service '%s' in services" $id $ingress.default_backend.service $ingress.default_backend.service -}}
    {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
  {{- end -}}

  # Validate all backend fields reference existing services
  {{- range $path := $ingress.paths  -}}
    {{- if and (hasKey $path "backend") (hasKey $.entities.services $path.backend.service | not) ($path.backend.foreign | default false | not  ) -}}
      {{- $error := printf "\nVALIDATION ISSUES:\n Ingress '%s' path '%s' backend references missing service '%s'.  Either explicitly mark backend with `foreign: true` or define service '%s' in services" $id $path.path $path.backend.service $path.backend.service -}}
      {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
    {{- end -}}
  {{- end -}}

  # Use default backend where not provided explicitly 
  # TODO: check https://kubernetes.io/docs/concepts/services-networking/ingress/#types-of-ingress
  {{- if $ingress.default_backend -}}
    {{- range $path := $ingress.paths -}}
      {{- $_ := set $path "backend" ($path.backend | default $ingress.default_backend) -}}
    {{- end -}}
  {{- end -}}


# Return entity overrides
annotations:
  {{- if $ingress.useTls }}
  {{ if $.Values.certManagerClusterIssuer }}cert-manager.io/cluster-issuer: {{ $.Values.certManagerClusterIssuer }}{{ end }}
  kubernetes.io/tls-acme: 'true'
  nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
  {{- end }}
  {{ if $ingress.useRegex }}nginx.ingress.kubernetes.io/use-regex: {{ $ingress.useRegex | quote }}{{ end }}
  {{ if $ingress.rewriteTarget }}nginx.ingress.kubernetes.io/rewrite-target: "{{$ingress.rewriteTarget}}"{{ end }}
  {{ if ge ($ingress.proxyBodySize | int) 0 }}nginx.ingress.kubernetes.io/proxy-body-size: "{{$ingress.proxyBodySize}}"{{ end }}
  {{ if not $ingress.proxyBuffering }}nginx.ingress.kubernetes.io/proxy-buffering: "off"{{ end }}
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
                {{/* if service is missing from $.entities.services and backend is not marked as foreign, validation fails above */}}
                name:  {{ (dig $path.backend.service (dict "name" $path.backend.service) $.entities.services ).name}}
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




