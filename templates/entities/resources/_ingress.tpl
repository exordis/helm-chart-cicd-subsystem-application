{{- define "subsystem-application.entities.ingress.collection" -}}ingresses{{- end -}}
{{- define "subsystem-application.entities.ingresses.entity" -}}ingress{{- end -}}

{{- define "subsystem-application.entities.ingress.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
tls: 
  enabled: true # generate cert for all hosts in spec if tls is not explicitly configured in spec
  # TODO: have convention for secret name rather than hardcoding "-tls"
  secretName: {{ include "sdk.naming.conventions.kind" (list $ (printf "%s-tls" $id) "Secret"  ) | quote }} 
hosts:
  default: 
    - default
services: {}
spec: 
  rules: []

{{- end -}}


{{- define "subsystem-application.entities.ingress.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ingress := index . 2 -}}
kind: "Ingress"
name: {{ include "sdk.naming.conventions.kind" (list $ $id "Ingress"  ) | quote }} 
{{- end -}}


{{- define "subsystem-application.entities.ingress._service_mapping" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ingress := index . 2 -}}

  {{- range $service_name, $service_mapping := $ingress.services -}}
    {{- $service := get $.entities.services $service_name -}}
    {{- $service_mapping = $service_mapping | default dict -}}
{{ $service.name }}:
  hosts: {{ $service_mapping.hosts | default (list "default") | toYaml | nindent 4 }}
  ports:
    {{- if $service_mapping.ports | default dict | len | eq  0 -}}    
      {{- range $port_name := $service.ports | keys }}
    {{$port_name}}:
    - path: /{{ $port_name }}
      pathType: "Prefix"
      {{- end -}}
    {{- else -}}
      {{- range $port_name, $port_mappings := $service_mapping.ports  }}
    {{$port_name}}:
        {{- range $port_mapping := $port_mappings | default (list (dict "path" (printf "/%s" $port_name))) }}
      - {{ $port_mapping | mustMergeOverwrite (dict "path" (printf "/%s" $port_name) "pathType" "Prefix") | toYaml | nindent 8  }}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.entities.ingress._service_rules" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ingress := index . 2 -}}
rules:
  {{- range $service_name, $service_mapping := $ingress.services }}
    {{- range $host := $service_mapping.hosts }}
  - host: {{ $host }}
    http:
      paths:
      {{- range $port_name, $port_mappings := $service_mapping.ports -}}
        {{- range $port_mapping := $port_mappings }}
        - path: {{ $port_mapping | toYaml | nindent 10 }}
          backend:
            service:
              name: {{$service_name}}
              port:
                name: {{$port_name}}     
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

{{- end -}}

{{- define "subsystem-application.entities.ingress._expand_hosts" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ingress := index . 2 -}}
rules:
  {{- range $rule := $ingress.spec.rules }}
    {{- $host := $rule.host  | default "default" -}}
    {{- range $host := dig $host (list $host) $ingress.hosts }}
  - host: {{- set ($rule | deepCopy) "host" $host | toYaml | nindent 4 }}
    {{- end -}}
  {{- end -}}

{{- end -}}



{{- define "subsystem-application.entities.ingress.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $ingress := index . 2 -}}
  {{- /* Validation*/ -}}
  {{- $errors := "" -}}
  {{- range $service_name, $service_mapping := $ingress.services -}}
    {{- if hasKey $.entities.services $service_name | not -}}
      {{- $errors = printf "%s\n- Ingress '%s' references undefined service '%s'" $errors $id $service_name -}}
    {{- else -}}
      {{- range $port_name := ($service_mapping | default dict ).ports | default dict | keys -}}
        {{- $service := get $.entities.services $service_name -}}
        {{- if hasKey $service.ports $port_name | not -}}
          {{- $errors = printf "%s\n- Ingress '%s' references undefined service '%s' port '%s'" $errors $id $service_name $port_name -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- if $errors | ne "" -}}
    {{- $error := printf "\nVALIDATION ISSUES: %s" $errors -}}
    {{- include "sdk.engine.log.fail-with-log" (list $ $error) -}}
  {{- end }}  

  {{- /* Defaults and generation */ -}}
  {{- $_ := set $ingress "services" (include "subsystem-application.entities.ingress._service_mapping" (list $ $id $ingress ) | fromYaml)  -}}
  {{- $service_rules := include "subsystem-application.entities.ingress._service_rules" (list $ $id $ingress ) | fromYaml -}}  
  {{- $_ := set $ingress.spec "rules" ($ingress.spec.rules | default list | concat ($service_rules.rules | default list) ) -}}
  {{- $_ := set $ingress.spec "rules" ( (include "subsystem-application.entities.ingress._expand_hosts" (list $ $id $ingress ) | fromYaml).rules | default list) -}}
  
  {{- /* Return entity overrides */ -}}
  {{- if $ingress.spec.rules | len | ne 0 | and $ingress.tls.enabled -}}

    {{- /* Hosts for tls */ -}}
    {{- $hosts := list -}}
    {{- range $rule := $ingress.spec.rules -}}
      {{- $hosts = append $hosts $rule.host -}}
    {{- end -}}
    {{- $hosts = ($hosts | uniq) }}
# TODO: need a better way to do it 
annotations:
  kubernetes.io/tls-acme: "true"
  nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    {{- if not $ingress.spec.tls }}
spec:
  tls:
    - secretName: {{ $ingress.tls.secretName }}   
      hosts: 
      {{- range $host := $hosts }}
        - {{ $host }}
      {{- end }}
    {{- end }}
  {{- end }}

{{- /*include "sdk.engine.log.fail-with-log" (list $ ($ingress.spec.rules| toYaml))*/ -}}  

{{- end -}}

