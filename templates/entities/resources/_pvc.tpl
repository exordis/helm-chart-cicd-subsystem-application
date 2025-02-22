{{- define "subsystem-application.entities.pvc.collection" -}}pvcs{{- end -}}
{{- define "subsystem-application.entities.pvcs.entity" -}}pvc{{- end -}}

{{- define "subsystem-application.entities.pvc.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{ include "subsystem-application.metadata.entity-metadata-defaults" $ }}
mounts: {}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi    
{{- end -}}

{{- define "subsystem-application.entities.pvc.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $pvc := index . 2 -}}

# Return entity overrides
kind: PersistentVolumeClaim
name: {{ include "subsystem-application.naming.conventions.kind" (list $ $id "PersistentVolumeClaim"  ) | quote }} 
{{- end -}}



{{- define "subsystem-application.entities.pvc.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $pvc := index . 2 -}}

{{- end -}}

