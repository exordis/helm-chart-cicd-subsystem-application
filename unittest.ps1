# docker is very slow when working with windows mounted as  volume 
# so mounting it to /src and copying to /apps and run helm unittest there for it to work with linux filesystem
# better solution would be to install helm-unitest on windows but it fails 
# docker run -ti --rm -v .:/src --entrypoint /bin/sh helmunittest/helm-unittest:3.16.3-0.7.0 -c "cp -R /src/* /apps && cd /apps && helm unittest . $args && rm -rf /src/tests/__snapshot__ && cp -R /apps/tests/__snapshot__ /src/tests/" > unittests.txt


# Define the default -f argument
$defaultArg = "-f 'tests/**/*_test.yaml'"

# Parse the provided arguments
$providedArgs = @() # Initialize an array for processed arguments
$hasFileArg = $false # Flag to check if -f is present

foreach ($arg in $args) {
  if ($arg -match "^-f$") {
      # If -f is detected, mark the flag as true
      $hasFileArg = $true
  }
  $providedArgs += $arg
}

# Add the default -f argument if none is found
if (-not $hasFileArg) {
  $providedArgs += $defaultArg
}


docker run -ti --rm -v .:/src --entrypoint /bin/sh helmunittest/helm-unittest:3.16.3-0.7.0 -c "cp -R /src/* /apps && cd /apps && helm unittest . $providedArgs && rm -rf /src/tests/__snapshot__ && cp -R /apps/tests/__snapshot__ /src/tests/" 