{{- define "subsystem-application.modules.networking.read" -}}

  {{- range $id, $ingress := $.Values.ingresses -}}  
    {{- if (or (not (hasKey ($ingress|default dict) "enabled")) $ingress.enabled) }}
      {{- include "sdk.engine.create-entity" (list $ "ingress" $id $ingress) -}}
    {{- end -}}
  {{- end -}}
  
  {{- range $id, $service := $.Values.services -}}
    {{- if (or (not (hasKey ($service|default dict) "enabled")) $service.enabled) }}
      {{- include "sdk.engine.create-entity" (list $ "service" $id $service) -}}
      {{- $service = get $.entities.services $id -}}

      {{- $monitor := dig "monitor" dict $service -}}
      
      {{- $_ := set $monitor "service" $id -}}

      {{- $endpoints := list -}}
      {{- range $name, $port := $service.ports -}}
        {{- if hasKey $port "monitorEndpoint" -}}
          {{- $endpoint := deepCopy ($port.monitorEndpoint | default dict) -}}
          {{- $_ := set $endpoint "port" $name -}}
          {{- $endpoints = append $endpoints $endpoint -}}
        {{- end -}}
      {{- end -}}

      {{- if  $endpoints | len | ne 0 -}}
        {{- $_ := set $monitor "endpoints" $endpoints -}}

        {{- include "sdk.engine.create-entity" (list $ "service-monitor" $id $monitor ) -}}
      {{- end -}}
    {{- end -}}

  {{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.networking.process" -}}

{{- end -}}

