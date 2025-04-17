# Log in to Azure (if not already logged in)
az login

# Get all subscriptions
$subscriptions = az account list --query "[].id" -o tsv

# Iterate over each subscription
foreach ($sub in $subscriptions) {
    # Set the subscription context
    az account set --subscription $sub

    # Get all resource groups in the current subscription
    $resourceGroups = az group list --query "[].name" -o tsv

    # Iterate over each resource group
    foreach ($rg in $resourceGroups) {

		# Get all SQL servers in the resource group
        $sqlServers = az sql server list --resource-group $rg --query "[].{ResourceGroup:resourceGroup, Name:name, Location:location}" -o tsv

		foreach ($sqlServer in $sqlServers) {

			# List all SQL databases in the resource group and output their IDs
			$resourceIds = az sql db list --server $sqlServer --resource-group $rg --query "[].id" -o tsv

			foreach ($resourceID in $resourceIds) {

				$policy = az sql db ltr-policy show --id $resourceID

			}
    }
}
