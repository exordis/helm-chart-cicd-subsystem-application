{{- define "subsystem-application.modules.storage.read" -}}

  {{- range $id, $pvc := $.Values.pvcs -}}  
    {{- if (or (not (hasKey ($pvc|default dict) "enabled")) $pvc.enabled) }}
      {{- $convertToTemplateForStatefulSet := (or (not (hasKey ($pvc|default dict) "convertToTemplateForStatefulSet")) $pvc.convertToTemplateForStatefulSet) -}}
      {{- if or (not $convertToTemplateForStatefulSet) ($.Values.workload.kind | ne "StatefulSet") }}
        {{- include "sdk.engine.create-entity" (list $ "pvc" $id $pvc) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.storage.process" -}}
  

{{- end -}}




