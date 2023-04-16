
Function Add-Two-Numbers {
<#
.SYNOPSIS

This function is created to help explain how functions work on PowerShell

.DESCRIPTION

Adds parameter A to parameter B

.PARAMETER A
Number to start from

.PARAMETER B
The number to add to A

.OUTPUTS
A+B

#>

param ( 
    $A
    , $B
    )

    $C = $A + $B
    $C
}

Function Make-String-Nicer {
<#
.SYNOPSIS

This function is created to help explain how you can create a function to be used in a pipeline.

.DESCRIPTION

Outputs a string.

.PARAMETER ValueFromPipeline
A string which will be put into another string and then output.

.OUTPUTS
"Some nice string" then ValueFromPipeline then "Some more nice string"

#>

param ( 
    [Parameter(Mandatory, ValueFromPipeline)]
    [string[]]$StringsToProcess )

    PROCESS {
        $StringsToOutput = [System.Collections.ArrayList]::new()
        foreach ($InputString in $StringsToProcess) {
            $OutPutString = "Very nice string $($InputString) with some additional string."
            $StringsToOutput.Add($OutPutString)  |Out-Null 
        }
        $StringsToOutput
    }
}

Add-Two-Numbers -A 2 -B 1

'Test' | Make-String-Nicer 