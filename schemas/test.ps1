yq eval-all '. as $item ireduce ({}; . * $item )' /schemas/*.yaml -o=json > schemas/compiled-schema.json


yq eval-all '
  . as $item ireduce ({}; . * $item ) |
  (.. | select(has("$ref") and (.["$ref"] | type == "!!str")) | .["$ref"]) |= sub("^[^#]+#", "#")
' /schemas/*.yaml -o=json > schemas/compiled-schema.json
