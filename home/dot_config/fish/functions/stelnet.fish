function stelnet --description="Use OpenSSL to connect to a server over TLS/SSL"
    argparse h/help v/verbose 'servername=' -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: stelnet [options] HOST PORT"
        echo
        echo "Options:"
        echo "  -h, --help                Show this help message"
        echo "  -v, --verbose            Show verbose SSL handshake output"
        echo "  --servername=NAME        Specify SNI server name"
        echo
        echo "Example:"
        echo "  stelnet example.com 443"
        echo "  stelnet --servername=example.com example.com 443"
        return 0
    end

    # Check if we have the required arguments
    if test (count $argv) -lt 2
        echo "Error: Missing required arguments"
        echo "Use 'stelnet --help' for usage information"
        return 1
    end

    # Get the host and port from arguments
    set -l host $argv[1]
    set -l port $argv[2]

    # Build OpenSSL options
    set -l opts

    # Add quiet option unless verbose is specified
    if not set -q _flag_verbose
        set -a opts -quiet
    end

    # Add SNI server name if specified
    if set -q _flag_servername
        set -a opts -servername $_flag_servername
    end

    # Add standard options
    set -a opts -crlf -connect "$host:$port"

    # Connect using openssl s_client
    openssl s_client $opts
end
