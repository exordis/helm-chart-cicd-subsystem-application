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

{{- end -}}

