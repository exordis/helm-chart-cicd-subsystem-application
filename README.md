# Summary
Base helm-chart for deployment of application as a part of subsystem

# Description

# Components
| Component                | Description                                                                                                   |
|--------------------------|---------------------------------------------------------------------------------------------------------------|
| Chart.yaml               | A YAML file containing information about the chart                                                            |
| values.yaml              | The default configuration values for this chart                                                               |
| values.schema.json       | A JSON Schema for imposing a structure on the values.yaml file                                                |
| templates                | A directory of templates that, when combined with values, will generate valid Kubernetes manifest files       |
| tests                    | Unit tests written in helm unittests format, covering all the components                                      |
| .gitlab-ci.yml           | File defines scripts that should be run during the CI/CD pipeline                                             |
| HISTORY.md               | Release history                                                                                               |
| README.md                | Brief description of the application’s responsibilities and purpose.                                          |
| GetVersion.yml           | It is a file that helps our helper tool to generate a Semantic Version number based on our tag History        |

# Values reference

| Name                     | Description                                                                                           | Value |
|--------------------------|-------------------------------------------------------------------------------------------------------|-------|
| `application`            | Application specific name, validated as string with regex "^[a-z0-9][a-z0-9-]+[a-z0-9]$"              | `""`  |
| `global`                 | Section for global settings, they can be visible outside the project and can be shared as an include  | `{}`  |
| `product`                | Product name, validated as string with regex "^[a-z0-9][a-z0-9-]+[a-z0-9]$"                           | `""`  |
| `subsystem`              | Subsystem canonical name, validated as string with regex "^[a-z0-9][a-z0-9-]+[a-z0-9]$"               | `""`  |
| `environment`            | Environment name, validated as string with regex "^[a-z0-9]+[a-z0-9-]$"                               | `""`  |

# History
[Release history](HISTORY.md)
