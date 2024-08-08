{{- define "subsystem-application.modules.deployment.read" -}}
  {{- /* add application container to entities.containers: */ -}} 
  {{- $applicationContainer := (dict "image" $.Values.image "version" $.Values.version "spec" $.Values.applicationContainer ) -}}
  {{- include "sdk.engine.create-entity" (list $ "container" "applicationContainer" $applicationContainer) -}}

  {{- /* add sidecar containers to entities.containers: */ -}} 
  {{- range $id, $sidecar := $.Values.sidecars }}
    {{- include "sdk.engine.create-entity" (list $ "container" $id $sidecar) -}}
  {{- end -}}

  {{- /* add init containers to entities.initContainers: */ -}} 
  {{- range $id, $initContainer := $.Values.initContainers }}
    {{- include "sdk.engine.create-entity" (list $ "init-container" $id $initContainer) -}}
  {{- end -}}

  {{- /* add volumes to entities.volumes: */ -}} 
  {{- range $id, $volume := $.Values.volumes -}}  
    {{- include "sdk.engine.create-entity" (list $ "volume" $id $volume) -}}
  {{- end -}}  
{{- end -}}



{{- define "subsystem-application.modules.deployment.process" -}}
  {{- /* iterrate entities.containers and assemble specs: */ -}} 
  {{- range $id, $container := $.entities.containers -}}
    {{- $spec_overrides := (include "subsystem-application.modules.deployment.container_spec" (list $ $container) ) |fromYaml -}}
    {{- $defaultsFrom := ( $id | eq "applicationContainer" | ternary "subsystem-application.configuration.defaults.specs.application-container" "subsystem-application.configuration.defaults.specs.sidecar-container") -}}
    {{- $_:= set $container "spec" (include "sdk.common.with-defaults" (list $ .spec $defaultsFrom $spec_overrides ) | fromYaml )  -}}
  {{ end -}}

  {{- /* iterrate entities.initContainers and assemble specs: */ -}} 
  {{- range $id, $container := $.entities.initContainers -}}
    {{- $spec_overrides := (include "subsystem-application.modules.deployment.container_spec" (list $ $container) ) |fromYaml -}}
    {{- $_:= set $container "spec" (include "sdk.common.with-defaults" (list $ .spec "subsystem-application.configuration.defaults.specs.init-container" $spec_overrides ) | fromYaml )  -}}
  {{ end -}}

  {{- /* iterrate entities.volumes and assemble specs: */ -}} 
  {{- range $name, $volume := $.entities.volumes -}}
    {{- $_:= set $volume "spec" (include "sdk.common.with-defaults" (list $ $volume.spec (printf  "subsystem-application.configuration.defaults.specs.volume.%s" $volume.type )) | fromYaml)  -}}
  {{- end -}}    
{{- end -}}




{{- define "subsystem-application.modules.deployment.container_spec" -}}
{{- $ := index . 0 -}}{{- $container := index . 1 -}}
{{- $namespace := include "sdk.naming.subsystem.namespace" (list $.Values.global.subsystem  $.Values.global.environment) -}}
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
{{- range $volume := $.entities.volumes -}}
{{- range $mountContainer, $mountPath := $volume.mounts -}}
{{- if $mountContainer | eq $container.id }}
  - mountPath: {{$mountPath}}
    name: {{ $volume.name }}
{{ end -}}
{{- end -}}
{{- end -}}

{{- end -}}