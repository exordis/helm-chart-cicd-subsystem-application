{{- define "subsystem-application.metadata.common-labels-immutable" -}}
{{ include "subsystem-application.metadata.k8s-native-labels-immutable" $ }}
{{ include "subsystem-application.metadata.exordis-labels" $ }}
{{- end -}}

{{- define "subsystem-application.metadata.common-labels" -}}
{{ include "subsystem-application.metadata.k8s-native-labels" $ }}
{{ include "subsystem-application.metadata.helm-labels" $ }}
{{ include "subsystem-application.metadata.exordis-labels" $ }}
{{- end -}}