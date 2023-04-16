#This is an introduction to basic powershell commands.
#Commenting your code can be done with the ( # ) character

<#
    Block commenting can be done by using the <> and # like here.
    This is usually used for writing the help documentation for functions. It is good practice to document each function.
    More on that topic can be found here: 
        https://learn.microsoft.com/en-us/powershell/scripting/developer/help/writing-help-for-windows-powershell-scripts-and-functions?view=powershell-7.3
#>

#How to define variables
#In PowerShell, variables are represented by text strings that begin with a dollar sign ( $ ), such as $a or $HelloWorld
#You generally don't have to specify the type of the variable as Powershell is pretty good at figuring this out by itself.
#More on that topic can be found here: 
#   https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_variables?view=powershell-7.3

$HelloWorld = 'Hello world.'

#Printing output to the screen 
#The opinions are divided on this topic, but since most of our code needs to be ready for use in Urban Code or TFS, it is best to use Write-Host

Write-Host 'Hello world from string'

#Printing variables to the screen 

Write-Host $HelloWorld

#Be aware that variables are case insensitive which means that $HelloWorld is the same variable as $HELLOWORLD
Write-Host $HELLOWORLD

#Using variables in strings. This requires the use of double quotes. 
#When using strings with double quotes in powershell, it indicates to the system that you want it to evaluate an expression inside that string.

Write-Host "This is a message: $($HelloWorld) from a variable."

#How to get the name and location of the powershell script that is currently running
Write-Host "The location of the script that is being executed: $($PSScriptRoot)"
Write-Host "The script that is currently being executed: $($myInvocation.MyCommand)"

#Commonly used system variables
Write-Host "Current user: $($env:USERNAME)"
Write-Host "Current domain: $($env:DOMAIN)"
Write-Host "Current computername: $($env:COMPUTERNAME)"
Write-Host "Current profile folder: $($env:USERPROFILE)"

#How to create a new directory
#Let's start with defining the name of the new folder:
$FoldernameToCreate = 'NewFolder'

#Let's define the full path of the new folder by creating a new variable and joining the location of the current script to the new directory name.
#We will use a new method for that called Join-Path
#You can read more about it here:
#    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/join-path?view=powershell-7.3

$FullPathToFolderToCreate = Join-Path -Path $PSScriptRoot -ChildPath $FoldernameToCreate
Write-Host "Directory to create: $($FullPathToFolderToCreate)"
#When defining paths, always use Join-Path and never just concatenate two strings. Join-Path takes care of a lot of the problems you have to think about when defining paths.

#Let's first test if the directory exists
Write-Host "The statement the directory exists is a: $(Test-Path -path  $FullPathToFolderToCreate) statement"

#Let's create the directory:
New-Item  -ItemType Directory -Path $FullPathToFolderToCreate 

#let's try it again
Write-Host "The statement the directory exists is a: $(Test-Path -path  $FullPathToFolderToCreate) statement"

#If we try to create the directory again we'll get an error message
New-Item  -ItemType Directory -Path $FullPathToFolderToCreate 

#Let's write some content to a file in our new directory. 
$FileNameToWriteTo = "Test.txt"
#Let's create the full path
$PathToWriteTo = Join-Path -path $FullPathToFolderToCreate -ChildPath $FileNameToWriteTo
Write-Host "Path to write to: $($PathToWriteTo)"

#There are various ways to write some text to a file. Let's start with the method that is closest to what you would be used to do:
Add-Content -Path $PathToWriteTo -Value "This text will be the first line."
#You will notice that I did not bother to create the file first. Powershell is build to be very robust so you can get away with a lot of things you would normally get errors for.

#Another method would be to pipe the output from an object to a file. This is making use of the pipe paradigm in powershell. It means that you can connect objects to methods and connect the output of those methods again to more methods. 
#In this way you can create a processing chain.
#For now let's keep it simple. We'll take a string and direct it to flow into a file.
'This text will flow into the file' | Out-File -FilePath $PathToWriteTo -Append

<#
    Let's break down what is happening here:
    We have the string, and then a pipe ( | ) symbol and finally a method. This structure tells Powershell to take the string, and pipe it into a function. 
    The function will take the input and process it. 
    The function we used in this case is called Out-File, it takes input and writes it to a file. We used one
        FilePath: The location of the file to write to
    And one flag. A flag is a parameter that is there or not there. When you supply the flag to the function it tells to function to do something different then when the flag is not there.
        Append: it tells the function to not overwrite the file but append the supplied input to what is allready there.
#>

#Let's see if we can read the file and output to screen. We'll use the pipe mechanism again:
Get-Content -Path $PathToWriteTo | Write-Host

#What if we want to do something with the contents of the file before we output it to screen? 
#We would have to write a function that can process our inputs the way we need them to be processed.
#We do not yet know how to do that. So let's first try to do without.
#Under the hood the object that goes through your processing chain can be accessed
#by using the following variable ( $_  )
#We will put a ( % ) symbol after the pipe followed by function open and closing brackets ( {} )
Get-Content -Path $PathToWriteTo | % { 
    Write-Host "Add some text: $($_) before outputting."
} 

#More info on writing output to a file can be found here:
#    https://devblogs.microsoft.com/powershell-community/how-to-send-output-to-a-file/
#It also has examples on how to directly use .Net classes and execute the methods on those. 
#This shows that Powershell really is build on .Net and if you want to you can use all the same methods.

#Let's create another file.
'This text will flow into the second file' | Out-File -FilePath (Join-Path -Path $FullPathToFolderToCreate -ChildPath "File2.txt") -Append

#It is usefull to know which files are available in our directory. To figure this out we'll use the pipes again.
Get-ChildItem -Path $FullPathToFolderToCreate | Write-Host 

#PowerShell is pretty smart and understands that these files are actually objects with methods and properties:
Get-ChildItem -Path $FullPathToFolderToCreate | % {
    Write-Host "Filename: $($_.Name)"
    Write-Host "Basename: $($_.BaseName)"
    Write-Host "Directory: $($_.Directory)"
    Write-Host "Parent: $($_.FullName)"
}

#This looks a bit inconvenient, maybe we can output as a table:
Get-ChildItem -Path $FullPathToFolderToCreate | Format-Table 

#Let's add the properties we wanted to see:
Get-ChildItem -Path $FullPathToFolderToCreate | Format-Table -Property Name, BaseName, Directory, FullName

#Let's create a file in the same folder as where our script is located.
'This text will flow into the third file' | Out-File -FilePath (Join-Path -Path $PSScriptRoot -Child "File3.txt") -Append

#Let's navigate powershell to our script directory:
CD $PSScriptRoot

#We can now make use of relative locations to find our files. For instance:
Get-Content -Path .\File3.txt | Write-Host

#This works because we know where the PowerShell prompt is because we explicitly navigated there using the CD command.
#Usually it is a good idea to be either sure that everything is always in the same place for example
#through the use of $PSScriptRoot or explicitly navigate there by using the CD command.

#Or folders:
Get-Content -Path .\NewFolder\File2.txt | Write-Host

#What if we don't like the output and want to replace some text?
(Get-Content -Path .\NewFolder\File2.txt) -replace 'second file', 'a different file'| Write-Host

#How to copy a file. 
Copy-Item .\NewFolder\File2.txt -Destination .\NewFolder\File3.txt 

#Untill now we have one created an inline script. There is no reusable functionality. For that we turn to the script TestFunction.ps1 located in the same folder as this current script.
#You can run that script by itself and it would run the command on line 63. That command calls the function Add-Two-Numbers which is defined above line.
#What we would like to do is reuse that functionality.
#To do that we first have to load the fuctions that are defined in TestFunction.ps1. We do this through something called dot loading. 
#Dot is done by placing a ( . ) in your script, after which you provide the location of the script you want to load.
#We know that the script is located in the same folder as this script. Therefore:

. .\TestFunction.ps1

#Which is the same as for example 

. (Join-Path -Path $PSScriptRoot -Child 'TestFunction.ps1')

#What you'll notice is that the command of line 63 is still executed and you'll see two times a 3 in your screen. 
#If you create reusable scripts in the future it's best to leave out calling any commands outside of the functions.

#Now we can use the function
Add-Two-Numbers -A 2 -B 3

#The last line of the function returns the object to the pipeline. Which means we can use that for example like this:
Add-Two-Numbers -A 2 -B 3 | Write-Host

#Or, since we're adding numbers:
(Add-Two-Numbers -A 2 -B 3 ) + 1

#And now that we know how to make functions. Let's turn our attention to the second function in the TestFunction.ps1. 
#This looks like a function we can use in our process to make strings nicer.
#Let's go back to our first example:
Get-Content -Path $PathToWriteTo | % { 
    Write-Host "Add some text: $($_) before outputting."
} 
#Now let's replace that with our new function
Get-Content -Path $PathToWriteTo | Make-String-Nicer | Write-Host

#Powershell operators are a bit different than you are probably used to in some areas. 
#You can read all about it here:
#    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.3
#The comparison operators should be noted particularly:
#The ( < ) and ( > ) are not used instead the comparison operators are as follows:
# == is -eq
# Example use:
if (3 -eq 3) {
    Write-Host '3 is equal to 3'
} else {
    Write-Host '3 is not equal to 3'
}

# != is -ne
if (2 -ne 3) {
    Write-Host '2 is not equal to 3'
} else {
    Write-Host '2 is equal to 3'
}

# > is -gt
if (3 -gt 2) {
    Write-Host '3 is greater than 2'
} else {
    Write-Host '3 is not greater than 2'
}

# < is -lt
if (2 -lt 3) {
    Write-Host '2 is less than 3'
} else {
    Write-Host '2 is not less than 3'
}

# => is -ge
if (3 -ge 3) {
    Write-Host '3 is greater than or equal to 3'
} else {
    Write-Host '3 is not greater than or equal to 3'
}

if (3 -ge 2) {
    Write-Host '3 is greater than or equal to 2'
} else {
    Write-Host '3 is not greater than or equal to 2'
}

# =< is -le
if (3 -le 3) {
    Write-Host '3 is less than or equal to 3'
} else {
    Write-Host '3 is not less than or equal to 3'
}

if (2 -le 3) {
    Write-Host '2 is less than or equal to 3'
} else {
    Write-Host '2 is not less than or equal to 3'
}

