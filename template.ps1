# Get all the values files dynamically from the sample-values folder
$valuesFiles = Get-ChildItem -Path ./sample-values -Filter *.yaml | ForEach-Object { "-f" ; $_.FullName }

# Combine all arguments into a single array
$helmArgs = @("template", ".")
$helmArgs += $valuesFiles
$helmArgs += $args
 
# Execute Helm with proper argument splitting
& helm @helmArgs
