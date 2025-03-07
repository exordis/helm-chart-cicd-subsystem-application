{{- define "subsystem-application.entities.deployment.collection" -}}deployments{{- end -}}
{{- define "subsystem-application.entities.deployments.entity" -}}deployment{{- end -}}

{{- define "subsystem-application.entities.deployment.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{- /* 
TODO:
- Values.deployment should be source of spec. 
- template should take .spec from deployment entity or spec should be removed
 */ -}}
namespace: {{ include "subsystem-application.naming.conventions.kind" (list $ "" "Namespace"  ) | quote }}
annotations: {}
labels: {}
spec:  
  revisionHistoryLimit: 2
containers: {}
initContainers: {}
volumes: {}

{{ end -}}


{{- define "subsystem-application.entities.deployment.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $deployment := index . 2 -}}
{{- $_ := unset $deployment.spec "selector" -}}
{{- $_ := unset (dig "spec" "template" "spec" dict $deployment) "containers" -}}
{{- $_ := unset (dig "spec" "template" "spec" dict $deployment) "initContainers" -}}
{{- $_ := unset (dig "spec" "template" "spec" dict $deployment) "volumes" -}}
{{- $name := include "subsystem-application.naming.conventions.kind" (list $ $id "Deployment"  ) }} 
kind: Deployment
name: {{ $name | quote }} 
workloadType: application
labels:
  exordis/application-workload: "true"
spec:
  replicas: {{ $.Values.workload.replicas }}
  template:
{{- if $.Values.workload.clusterRole | default "" | ne "" }}  
    spec:
      serviceAccountName: "{{ include "subsystem-application.naming.conventions.kind" (list $ $id "ServiceAccount"  ) }}"
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

{{- define "subsystem-application.entities.deployment.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $deployment := index . 2 -}}
{{ include "subsystem-application.entities.workloads.helpers.references" (list $ $deployment) }}
{{- end }}