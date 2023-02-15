# In order for this powershell to work, you must have dbatools installed and/or sql server installed.
# This can be installed as install-module dbatools OR install-module sqlserver
# Then you would need to import it. 
# EX: import-module dbatools or import-module sqlserver
#
###Notes####
# - Creation KF 2/10/2023
#
#
#
Add-type -AssemblyName system.windows.forms
$Path = New-Object System.Windows.Forms.OpenFileDialog
#this function handles the import for the excel file
#opens file selector for choosing CSV
Add-type -AssemblyName system.windows.forms
$Path = New-Object System.Windows.Forms.OpenFileDialog
$Path.ShowDialog()
$pathselect = $Path
$data = Import-Excel -Path $Path.FileName
$server = Read-Host "Please enter a server name"
$databasechoice = Read-Host "Please enter a database name"
$AreYouOverThere = Read-Host "Please enter a table name"
 Foreach($d in $data) 
 {
 Write-DbaDataTable -SqlInstance $server -Database $databasechoice -InputObject $d -Table $AreYouOverThere -KeepNulls -AutoCreateTable
 
 }

###Testing###
# This powershell is what I used to troubleshoot and test
# 2/10/2023 - WARNING: [09:11:50][Write-DbaDbTableData] Failed to bulk import to [test].[dbo].[Proforma_2023] | The given ColumnMapping does not match up with any column in the source or destination.
# Check number of columns per object
# $test = $d | Get-Member -MemberType Properties | Select-Object name
# Write-Host "Num of columns in sheet" + $test.count
# Data type research:
# Float stores an approximate value and decimal stores an exact value. 
# In summary, exact values like money should use decimal, and approximate values like scientific measurements should use float. 
# When multiplying a non integer and dividing by that same number, decimals lose precision while floats do not.
# reference
# https://www.catapultsystems.com/blogs/float-vs-decimal-data-types-in-sql-server/
# Game plan: 
# Create a table importing as is
# Create a view to lay ontop of it to manipulate the data
#View Def: 
#
#
#