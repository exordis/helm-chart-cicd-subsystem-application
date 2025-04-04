


{{- define "subsystem-application.entities.container-base.defaults" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}
spec: 
  envFrom: []
  volumeMounts: []
  imagePullPolicy: IfNotPresent
  resources:
    limits:
      cpu: 200m
      memory: 256Mi
    requests:
      cpu: 50m
      memory: 64Mi
image: 
  version:  {{ $.Values.version }}
  registry: {{ $.Values.registry }}
  repository: {{ $.Values.repository }}

{{- end -}}


{{- define "subsystem-application.entities.container-base.create" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $data := index . 2 -}}{{- $parent := index . 3 -}}
kind: Container
name: {{ include "sdk.naming.conventions.component" (list $ $id "Container"  $parent.id $parent.kind  ) | quote }}

{{- if $parent.workloadType | eq "application" }}
ref: {{ $id }}
{{- else -}}
  {{- $templates_prefix :=  (include "sdk.engine._templates_prefix" $) | toYaml -}}
  {{- $parent_collection := include (printf (printf "%s.entities.%%s.collection" $templates_prefix) $parent.entity_type) $  }}    
ref: {{ printf "%s.%s.%s" $parent_collection $parent.id $id }}
{{- end }}

{{- end -}}


{{- define "subsystem-application.entities.container-base.process" -}}
{{- $ := index . 0 -}}{{- $id := index . 1 -}}{{- $container := index . 2 -}}
 
  {{- $namespace := $container.parent.namespace -}}

  {{- /* add config maps refs*/ -}}
  {{- range $configMap := $.entities.configMaps -}}
    {{- if and (eq $namespace $configMap.namespace) (or (eq $configMap.containers nil ) (has $container.ref $configMap.containers )) -}}
      {{- $_ := set $container.spec "envFrom" ($container.spec.envFrom | concat (list (dict "configMapRef" (dict "name" $configMap.name))))  -}}
    {{- end -}}
  {{- end -}}

  {{- /* add secrets refs*/ -}}
  {{- range $secret := $.entities.secrets -}}
    {{- if and (eq $namespace $secret.namespace) (or (eq $secret.containers nil  ) (has $container.ref $secret.containers )) }}
      {{- $_ := set $container.spec "envFrom" ($container.spec.envFrom | concat (list (dict "secretRef" (dict "name"  $secret.name))))  -}}
    {{ end -}}
  {{- end }}

  {{- /* add external secrets refs*/ -}}
  {{- range $externalSecret := $.entities.externalSecrets -}}
    {{- if and (eq $namespace $externalSecret.namespace) (or (has $container.ref $externalSecret.containers ) (eq  $externalSecret.containers nil )) }}
      {{- $_ := set $container.spec "envFrom" ($container.spec.envFrom | concat (list (dict "secretRef" (dict "name" $externalSecret.targetSecretName))))  -}}
    {{- end -}}
  {{- end -}}


  {{- range $volume := ($container.parent | default $.entities).volumes | default dict -}}
    {{- range $mountContainer, $mountPath := $volume.mounts -}}
      {{- if $mountContainer | eq $container.id }}
        {{- $_ := set $container.spec "volumeMounts" ($container.spec.volumeMounts | concat (list (dict "mountPath"  $mountPath "name" $volume.name)))  -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}




spec:
  name: {{ $container.name }}
  image: {{ printf "%s/%s:%s" $container.image.registry $container.image.repository $container.image.version }}
{{- end -}}

