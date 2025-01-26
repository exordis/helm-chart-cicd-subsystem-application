


{{- define "subsystem-application.entities.container-base.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
spec: 
  imagePullPolicy: IfNotPresent
  resources:
    limits:
      cpu: 200m
      memory: 1024Mi
    requests:
      cpu: 2m
      memory: 70Mi
image: 
  version:  {{ $.Values.version }}
  registry: {{ $.Values.registry }}
  repository: {{ $.Values.repository }}
version: latest

{{- end -}}


{{- define "subsystem-application.entities.container-base.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
name: {{ include "sdk.naming.application.deployment.container" (list $.Values.global.subsystem $.Values.application $.Values.instance ( $id | eq "applicationContainer" | ternary "" $id) )  }}
{{- end -}}


{{- define "subsystem-application.entities.container-base.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $container := index . 2 -}}
{{- $namespace := include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem  $.Values.global.environment) -}}
{{- $containerRef := $container.id -}}

{{- if $container.parent.workloadType | eq "batch" -}}
  {{- $templates_prefix :=  (include "sdk.engine._templates_prefix" $) | toYaml -}}
  {{- $parent_collection_name := include  (printf (printf "%s.entities.%%s.collection" $templates_prefix) $container.parent.entity_type) $ -}}
  {{- $containerRef = printf "%s.%s.%s" $parent_collection_name $container.parent.id $container.id -}}
{{- end -}}

spec:
  name: {{ $container.name }}
  image: {{ printf "%s/%s:%s" $container.image.registry $container.image.repository $container.image.version }}
  envFrom: 
  {{- range $configMap := $.entities.configMaps -}}
    {{- if and (eq $namespace $configMap.namespace) (or (eq $configMap.containers nil ) (has $containerRef $configMap.containers )) }}
    - configMapRef:
        name: {{ $configMap.name }}
    {{ end -}}
  {{- end }}
  {{- range $externalSecret := $.entities.externalSecrets -}}
    {{- if or (has $containerRef $externalSecret.containers ) (eq  $externalSecret.containers nil ) }}
    - secretRef:
        name: {{ $externalSecret.targetSecretName }}
    {{ end -}}
  {{- end }}
  {{- range $secret := $.entities.secrets -}}
    {{- if and (eq $namespace $secret.namespace) (or (eq $secret.containers nil  ) (has $containerRef $secret.containers )) }}
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

