{{- define "subsystem-application.modules.data-folders.read" -}}

  {{- range $folderType := (list "content" "configuration") -}}
    {{- include "sdk.engine.log" (list $ (printf "Reading %s data folders" $folderType) 2) -}}
    {{- /* iterrate folders in values:  */ -}}
    {{- range $folderName, $dataFolder := ( index $.Values.dataFolders $folderType) | default dict }}
      {{- include "sdk.engine.log" (list $ (printf "Reading data folder '%s'" $folderName) 2) -}}

      {{- /* add data folder init container to entities.initContainers:  */ -}}
      {{- $image := include "sdk.naming.subsystem.repository-image-name" (list $.Values.dockerRegistry $.Values.global.subsystem (printf "data-%s-%s" $folderType $folderName) ) -}}
      {{- $initContainer := (dict "name" $folderName "image" $image  "version" $dataFolder.version "spec" $dataFolder.spec  ) -}}
      {{- include "sdk.engine.create-entity" (list $ "init-container" $folderName $initContainer) -}}

      {{- /* build list of init container paths:  */ -}}
      {{ $init_container_paths := list }}
      {{- range $containerName, $paths := $dataFolder.mounts }}
        {{- range $init_container_path, $path := $paths }}
          {{- if not (has $init_container_path $init_container_paths)  -}}
            {{- $init_container_paths = append $init_container_paths $init_container_path -}}
            {{- $id :=  printf "%s%s" $folderName (regexReplaceAll "[^0-9a-z]" (lower $init_container_path) "-") -}}
            {{- $volume:= include "subsystem-application.modules.data-folders.create_volume" (list $id $folderName $dataFolder $init_container_path) | fromYaml -}}
            {{- include "sdk.engine.create-entity" (list $ "volume" $id $volume)  -}}
          {{- end -}}
        {{- end -}}    
      {{- end -}}    

      {{- include "sdk.engine.log" (list $ "" -2) -}}
    {{- end -}}
    {{- include "sdk.engine.log" (list $ "" -2) -}}
  {{- end -}}
{{- end -}}  

{{- define "subsystem-application.modules.data-folders.create_volume" -}}
{{- $name := index . 0 }}{{- $initContainer := index . 1 }}{{- $dataFolder := index . 2 }}{{- $init_container_path := index . 3 }}
name: {{ $name }}
spec:
  {{- if $dataFolder.sizeLimit }}
  sizeLimit: {{ $dataFolder.sizeLimit }}
  {{- end }}
type: emptyDir
mounts: 
  {{$initContainer}}: {{$init_container_path }}
{{- range $container, $mounts := $dataFolder.mounts -}}
  {{- range $path, $mount_path := $mounts -}}
    {{- if eq $path $init_container_path }}
  {{$container}}: {{$mount_path | default $init_container_path }}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- end -}}


{{- define "subsystem-application.modules.data-folders.process" -}}
{{- end -}}

