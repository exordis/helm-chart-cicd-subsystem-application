


{{- define "subsystem-application.entities.container-base.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
{{- $application_type := $id | eq "applicationContainer" | ternary $.Values.applicationType "service"  -}}
{{- $application := $id | eq "applicationContainer" | ternary $.Values.application $id  -}}
{{- $canonical_name := include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $application) -}}
{{- $image:= printf "%s/%s" $.Values.dockerRegistry $canonical_name -}}

spec: 
  imagePullPolicy: IfNotPresent
  resources:
    limits:
      cpu: 200m
      memory: 1024Mi
    requests:
      cpu: 2m
      memory: 70Mi
image: {{ $image }}
version: latest

{{- end -}}


{{- define "subsystem-application.entities.container-base.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.deployment.container" (list $.Values.global.subsystem $.Values.application $.Values.instanceName ( $id | eq "applicationContainer" | ternary "" $id) )  }}
{{- end -}}


{{- define "subsystem-application.entities.container-base.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $container := index . 2 -}}
{{- $namespace := include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem  $.Values.global.environment) -}}
spec:
  name: {{ $container.name }}
  image: {{ printf "%s:%s" ($container.image) ($container.version) }}
  envFrom: 
    - configMapRef:
        name: {{ include "sdk.naming.application.config-map" (list $.Values.global.subsystem $.Values.application $.Values.instanceName "envs") }}
  {{- range $externalSecret := $.entities.externalSecrets -}}
    {{- if or (has $container.id $externalSecret.containers ) (not $externalSecret.containers ) }}
    - secretRef:
        name: {{ $externalSecret.targetSecretName }}
    {{ end -}}
  {{- end }}
  {{- range $secret := $.entities.secrets -}}
    {{- if and (eq $namespace $secret.namespace) (or (has $container.id $secret.containers ) (not $secret.containers )) }}
    - secretRef:
        name: {{ $secret.name }}
    {{ end -}}
  {{- end }}
  volumeMounts:
  {{- range $volume := ($container.parent | default $.entities).volumes | default dict -}}
  {{- range $mountContainer, $mountPath := $volume.mounts -}}
  {{- if $mountContainer | eq $container.id }}
    - mountPath: {{$mountPath}}
      name: {{ $volume.name }}
  {{ end -}}
  {{- end -}}
  {{- end -}}

{{- end -}}

