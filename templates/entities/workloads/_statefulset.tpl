{{- define "subsystem-application.entities.statefulset.collection" -}}statefulsets{{- end -}}
{{- define "subsystem-application.entities.statefulsets.entity" -}}statefulset{{- end -}}

{{- define "subsystem-application.entities.statefulset.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
namespace: {{ include "sdk.naming.conventions.kind" (list $ "" "Namespace"  ) | quote }}
annotations: {}
labels: {}
spec:  
  revisionHistoryLimit: 2
containers: {}
initContainers: {}
volumes: {}

{{ end -}}


{{- define "subsystem-application.entities.statefulset.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $statefulset := index . 2 -}}
{{- $_ := unset $statefulset.spec "selector" -}}
{{- $_ := unset (dig "spec" "template" "spec" dict $statefulset) "containers" -}}
{{- $_ := unset (dig "spec" "template" "spec" dict $statefulset) "initContainers" -}}
{{- $_ := unset (dig "spec" "template" "spec" dict $statefulset) "volumes" -}}
{{- $name := include "sdk.naming.conventions.kind" (list $ $id "StatefulSet"  ) }} 
kind: StatefulSet
name: {{ $name | quote }} 
workloadType: application
labels:
  exordis/application-workload: "true"
spec:
  replicas: {{ $.Values.workload.replicas }}
  template:
{{- if $.Values.workload.clusterRole | default "" | ne "" }}  
    spec:
      serviceAccountName: "{{ include "sdk.naming.conventions.kind" (list $ $id "ServiceAccount"  ) }}"
{{- end }}      
    metadata:
      labels:
        exordis/application-workload: "true"
  selector:
    matchLabels:
      {{- (include "subsystem-application.metadata.selector-labels" $) | nindent 6 }}
      exordis/application-workload: "true"
subcollections:
  - containers
  - initContainers
  - volumes
{{- end -}}

{{- define "subsystem-application.entities.statefulset.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $statefulset := index . 2 -}}
{{ include "subsystem-application.entities.workloads.helpers.references" (list $ $statefulset) }}
{{- end }}