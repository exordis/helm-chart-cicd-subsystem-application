{{- define "subsystem-application.metadata.k8s-native-labels-immutable" -}}
app.kubernetes.io/component: {{ include "sdk.naming.conventions.metadata" (list $ "application-canonical-name") | quote }}
app.kubernetes.io/instance: {{ $.Values.instance | quote }}
app.kubernetes.io/managed-by: "helm"
app.kubernetes.io/name: {{ include "sdk.naming.conventions.metadata" (list $ "application-canonical-name")| quote }}
app.kubernetes.io/part-of: {{ $.Values.global.subsystem | quote }}
{{- end -}}

{{- define "subsystem-application.metadata.k8s-native-labels" -}}
{{- include "subsystem-application.metadata.k8s-native-labels-immutable" $ }}
app.kubernetes.io/version: {{ $.Values.version | default $.Chart.Version  | quote }}
{{- end -}}