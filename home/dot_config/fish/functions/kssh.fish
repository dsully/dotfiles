function kssh --description "SSH to a Kubernetes Host"
    argparse 'n/namespace=' -- $argv
    or return 1

    if test (count $argv) -eq 0
        echo "Usage: kssh [OPTIONS] POD_NAME"
        echo "Options:"
        echo "  -n, --namespace=NAMESPACE  Kubernetes namespace"
        return 1
    end

    set -l pod_name $argv[1]
    set -l kubectl_args $pod_name

    if set -q _flag_namespace
        set -a kubectl_args -n $_flag_namespace
    end

    kubectl exec -it $kubectl_args -- /bin/bash 2>/dev/null
end
