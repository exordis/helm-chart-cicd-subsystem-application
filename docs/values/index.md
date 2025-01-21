## ConfigMaps

```
configMaps:
  namespace: 
  data:
    key: value
```

- namespace default is subsystem namespace
- data default is empty dict

  
### Envs config map

`envs` configMap is always generated. It defines environment variables to be available in all containers of application.

#### Definition in values
```
envs:
  VARIABLE: value
```

#### Metadata environment variables

- Metadata variables are added to `envs` config map. If `envs` is missing from values, config map contains only metadata.
  - `EXORDIS_PRODUCT` - subsystem product
  - `EXORDIS_SUBSYSTEM` - subsystem canonical name
  - `EXORDIS_APPLICATION` - application canonical name
  - `EXORDIS_INSTANCE` - instance name
  - `EXORDIS_ENVIRONMENT` - environment
