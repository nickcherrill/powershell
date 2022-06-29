<#
.SYNOPSIS 
– We often need to use multiple properties that match to one another in Powershell. There are many options for this, some are displayed here.
.DESCRIPTION 
– In order to avoid separate variables storing many properties of related objects, and relying upon the order of these objects, we can instead
use objects in an array (or within other objects, if more features are needed) which enables us to write cleaner loops, reference multiple
properties as a group of properties, and it keeps the values being input in a much cleaner format.
It also enables us to reduce the amount of variables being passed to functions, as all data relevant for processing can be passed in one
variable rather than many that rely on a specific order.
.NOTES 
– Get-Car and New-Car are placeholders and not real cmdlets. The intent is to show simplification on use of variables, not to demonstrate
actual functionality of Powershell to do with making and retrieving cars!
#>

# We will first show an example to avoid, then a better approach

# Instead of
$CarNames = @(
    'Pigeon'
    'Fury'
    'Nior'
    'Lightning'
)
$CarColours = @(
    'Racecar Blue'
    'Burning Red'
    'Mightnight Black'
    'Sunlight Yellow'
)
$CarAge = @(
    24
    13
    30
    4
)

# and instead of using a loop like
$Count = $CarNames.Count
for ($num = 0 ; $num -lt $Count; $num++)
{
    $name = $CarName[$num];
    Write-Host $name
    Get-Car -Name $name -ErrorVariable $carNotExist -ErrorAction SilentlyContinue
    if ($carNotExist) {
        Write-Host "Car $name doesn't exist, creating"
        New-Car -Name $name -Colour $CarColours[$num] -Age $CarAge[$num]
    }
    else{
        Write-Host "Car $name exists"
    }
}

#####

# You should instead use this approach for more readable and easily maintainable code
# This array contains multiple objects with matching names for their values
$arrayWithObjects = @(
    [PSCustomObject]@{
        CarName = "Pigeon"
        CarColour = "Racecar Blue"
        Age = 24
    }
    [PSCustomObject]@{
        CarName = "Fury"
        CarColour = "Burning Red"
        Age = 13
    }
    [PSCustomObject]@{
        CarName = "Nior"
        CarColour = "Mightnight Black"
        Age = 30
    }
    [PSCustomObject]@{
        CarName = "Lightning"
        CarColour = "Sunlight Yellow"
        Age = 4
    }
)

# Calling this in a loop looks like this
foreach($object in $arrayWithObjects){
    Write-Host "The car name is $object.CarName"
    Get-Car -Name $object.CarName -ErrorVariable $carNotExist -ErrorAction SilentlyContinue
    if ($carNotExist) {
        Write-Host "Car $object.CarName doesn't exist, creating"
        New-Car @object
    }
    else{
        Write-Host "Car $object.CarName exists"
    }
}

<# This also enables us to use things like:
1) 
    New-Car @object
    in our loop which passes all key value pairs as parameters for a function
2)
    $arrayWithObjects.CarName
    this prints all car names
    $arrayWithObjects
    this prints all attributes with their values like this:
    CarName   CarColour        Age
    -------   ---------        ---
    Pigeon    Racecar Blue      24
    Fury      Burning Red       13
    Nior      Mightnight Black  30
    Lightning Sunlight Yellow    4

and other more advanced features, rather than keeping values that belong together in separate variables
#>