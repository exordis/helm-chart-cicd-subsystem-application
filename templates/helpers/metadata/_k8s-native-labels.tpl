{{- define "subsystem-application.metadata.k8s-native-labels" -}}
app.kubernetes.io/component: {{ include "subsystem-application.naming.conventions.metadata" (list $ "application-canonical-name") | quote }}
app.kubernetes.io/instance: {{ $.Values.instance | quote }}
app.kubernetes.io/managed-by: "helm"
app.kubernetes.io/name: {{ include "subsystem-application.naming.conventions.metadata" (list $ "application-canonical-name")| quote }}
app.kubernetes.io/part-of: {{ $.Values.global.subsystem | quote }}
app.kubernetes.io/version: {{ $.Values.version | quote }}
{{- end -}}