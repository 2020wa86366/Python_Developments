# WARNING! This script deletes data!
# Run only if you do not have systems
# that pull images via manifest digest.

# Change to 'true' to enable image delete
$ENABLE_DELETE = $true

# Modify for your environment
$REGISTRY = ""
$REPOSITORY = ""
$START_TIMESTAMP = "2024-08-01" # Start of the range
$END_TIMESTAMP = "2024-11-01"   # End of the range
$TENANTID = ""

# Retrieve the stored credentials
$credential = Get-AutomationPSCredential -Name ''

# Authenticate with Azure using the service principal
az login --service-principal -u $credential.UserName -p $credential.GetNetworkCredential().Password --tenant $TENANTID

# Delete all tags within the specified timestamp range.
if ($ENABLE_DELETE)
{
    Write-Output "Starting tag deletion process within the range $START_TIMESTAMP to $END_TIMESTAMP..."
    # Get all tags that need to be deleted based on the timestamp range
    $tagsToDelete = az acr repository show-tags --name $REGISTRY --repository $REPOSITORY --orderby time_asc --detail --query "[?lastUpdateTime >= '$START_TIMESTAMP' && lastUpdateTime <= '$END_TIMESTAMP'].name" -o tsv
    Write-Output "Tags to delete: $tagsToDelete"

    foreach ($tag in $tagsToDelete -split "`n")
    {
        if (-not [string]::IsNullOrWhiteSpace($tag))
        {
            # Delete each tag
            Write-Output "Deleting tag: $tag"
            az acr repository delete --name $REGISTRY --image "$($REPOSITORY):$tag" --yes
            Write-Output "Deleted Tag: $tag"
        }
    }
    Write-Output "Tag deletion process completed."
}
else
{
    Write-Output "No data deleted."
    Write-Output "Set ENABLE_DELETE=true to enable deletion of tags within the range $START_TIMESTAMP to $END_TIMESTAMP in $($REPOSITORY):"
    # Display the tags that would be deleted if the script were enabled
    az acr repository show-tags --name $REGISTRY --repository $REPOSITORY --orderby time_asc --detail --query "[?lastUpdateTime >= '$START_TIMESTAMP' && lastUpdateTime <= '$END_TIMESTAMP'].[name, lastUpdateTime]" -o tsv
}
