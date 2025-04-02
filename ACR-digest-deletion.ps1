# WARNING! This script deletes data!
# Run only if you do not have systems
# that pull images via manifest digest.

# Change to $true to enable image delete
$ENABLE_DELETE = $true

# Modify for your environment
$REGISTRY = ""
$REPOSITORY = ""
$TENANTID = ""
$START_TIMESTAMP = "2024-08-01" # Start of the range
$END_TIMESTAMP = "2024-11-01"   # End of the range

# Retrieve the stored credentials
$credential = Get-AutomationPSCredential -Name 'aiplt-iac-dev-sp'

# Authenticate with Azure using the service principal
az login --service-principal -u $credential.UserName -p $credential.GetNetworkCredential().Password --tenant $TENANTID

# Delete all images within the specified timestamp range.
if ($ENABLE_DELETE)
{
    # Get the list of digests to delete that fall within the specified range
    $digestsToDelete = (az acr manifest list-metadata `
        --name $REPOSITORY `
        --registry $REGISTRY `
        --orderby time_asc `
        --query "[?lastUpdateTime >= '$START_TIMESTAMP' && lastUpdateTime <= '$END_TIMESTAMP'].digest" -o tsv) -split "`n"

    # Echo the digests that will be deleted
    Write-Output ("The following digests will be deleted from " + $REPOSITORY + " between " + $START_TIMESTAMP + " and " + $END_TIMESTAMP + ":")
    $digestsToDelete | ForEach-Object { Write-Output $_ }

    # Delete the digests
    $digestsToDelete | ForEach-Object {
        az acr repository delete --name $REGISTRY --image $REPOSITORY@$_ --yes
        Write-Output ("Deleted image with digest: " + $_)
    }
}
else
{
    Write-Output "No data deleted."
    Write-Output ("Set ENABLE_DELETE to $true to enable deletion of these images in " + $REPOSITORY)
    # List all images within the specified timestamp range
    az acr manifest list-metadata `
        --name $REPOSITORY `
        --registry $REGISTRY `
        --orderby time_asc `
        --query "[?lastUpdateTime >= '$START_TIMESTAMP' && lastUpdateTime <= '$END_TIMESTAMP'].[digest, lastUpdateTime]" -o tsv
}
