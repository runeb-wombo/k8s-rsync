#!/bin/bash

# original article: https://serverfault.com/questions/741670/rsync-files-to-a-kubernetes-pod

if [ -z "$KRSYNC_STARTED" ]; then
    export KRSYNC_STARTED=true
    # blocking-io option seems to cause less issues with SSH
    /opt/homebrew/bin/rsync --blocking-io --rsh "$0" $@ 
    # exec /opt/homebrew/bin/rsync --blocking-io --rsh "$0" $@ 
    # exec rsync --blocking-io --rsh "$0" $@
fi

# Running as --rsh
namespace=''
pod=$1
shift

# If use uses pod@namespace rsync passes as: {us} -l pod namespace ...
if [ "X$pod" = "X-l" ]; then
    pod=$1
    shift
    namespace="-n $1"
    shift
fi

# echo "KUBECTL ACTION $@"

exec kubectl -n wombo exec -c shadow-builder -i $pod -- "$@"
# exec kubectl $namespace  -c shadow-builder exec -i $pod -- "$@"

