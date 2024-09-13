{{- define "subsystem-application.modules.storage.read" -}}

  {{- range $id, $pvc := $.Values.pvcs -}}  
    {{- include "sdk.engine.create-entity" (list $ "pvc" $id $pvc) -}}
    {{- $name :=  dig $id "name" "UNSET" $.entities.pvcs -}}
    {{- $volume := (dict "type" "persistentVolumeClaim"  "spec" (dict "claimName" $name) "mounts" $pvc.mounts )   -}}
    {{- include "sdk.engine.create-entity" (list $ "volume" $id $volume) -}}
  {{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.storage.process" -}}
  
  {{- range $name, $pvc := $.entities.pvcs -}}
    {{- $spec_overrides := (include "subsystem-application.modules.pvc._pvc-spec-overrides" (list $ $pvc)) |fromYaml -}}
    {{- $_:= set $pvc "spec" (include "sdk.common.with-defaults" (list $ $pvc.spec "subsystem-application.configuration.defaults.specs.pvc" $spec_overrides) | fromYaml )  -}}
  {{- end -}}

{{- end -}}



{{- define "subsystem-application.modules.pvc._pvc-spec-overrides" -}}
{{- $ := index . 0 -}}{{- $ingress := index . 1 -}}
{{- end -}}

