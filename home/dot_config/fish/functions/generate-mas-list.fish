function generate-mas-list

    echo "masApps = {"

    # Run mas list and process each line
    mas list | while read -l line
        # Extract app ID (first column) and name (second column)
        set -l app_id (string match -r '^\s*(\d+)' $line)[2]
        set -l app_name (string match -r '^\s*\d+\s+(.*?)\s+\(' $line)[2]

        # Output the Nix attribute with quoted original app name
        echo "  \"$app_name\" = $app_id;"
    end

    echo "};"
end
