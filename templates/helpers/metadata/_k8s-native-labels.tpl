{{- define "subsystem-application.metadata.k8s-native-labels" -}}
app.kubernetes.io/component: {{ include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $.Values.application) | quote }}
app.kubernetes.io/instance: {{ $.Values.instanceName | quote }}
app.kubernetes.io/managed-by: "helm"
app.kubernetes.io/name: {{ include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $.Values.application) | quote }}
app.kubernetes.io/part-of: {{ $.Values.global.subsystem | quote }}
app.kubernetes.io/version: {{ $.Values.version | quote }}
{{- end -}}