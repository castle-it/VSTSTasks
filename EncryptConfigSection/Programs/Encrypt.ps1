[CmdletBinding()]

param()

Trace-VstsEnteringInvocation $MyInvocation

###########################################
#Author: MD. Jawed
#Description: Ecryption of config file using asp.net
############################################
Write-Host "##################################################################################"
# Output the logo.
"Set of Task to Encrypt Config File Using aspnet_regiis.exe"
"Author: Mohammed,Jawed.`n"
Write-Host "##################################################################################"

##################################################################################
# Initialize the default script exit code.
$exitCode =0
#####################################################################################
try
{
  
  
# Get the inputs.
[string]$configFilePath = Get-VstsInput -Name configFilePath
[string]$configFilePattern = Get-VstsInput -Name configFilePattern
[string]$sectionName = Get-VstsInput -Name sectionName
[string]$dataProtectionProvider = Get-VstsInput -Name dataProtectionProvider
[string]$ToComment = Get-VstsInput -Name ToComment
[bool]$SectionToCommentsInConfig = Get-VstsInput -Name 'SectionToCommentsInConfig' -AsBool
[bool]$RecursiveBool = Get-VstsInput -Name 'Recursive' -AsBool

#################################################################
Write-Host "Replacing $ToComment"
##################################################################################
# Initialize the default script exit code.
$exitCode = 0

##################################################################################
# Output execution parameters.
"Executing with the following parameters:"
" Config FilePath: $configFilePath"
" Config File Pattern: $configFilePattern"
" section Name: $sectionName"
" Data Protection Provider: $dataProtectionProvider"
" Section To Comment: $SectionToCommentsInConfig"
#################################################################################

#check for path
if(!(Test-Path -Path "$configFilePath"))
{
    $exitCode=1

    $(throw "Config Path $configFilePath does not exist.")

}

##################### Funtion to comments custom section from config before encrytion ########
 $commentLine="<!--"+$ToComment+"-->"
function commentSection([string]$path,[bool]$comment,[bool]$CommentSection)
{ 
 Write-Debug "Inside Comment and uncomment section."  
 if($CommentSection)
 {
        
        $text = Get-Content $path
        if($comment)
        {
         Write-Host "Commenting the section from config file: START."
		 $text -replace $ToComment, $commentLine | Set-Content $path
        Write-Host "Commenting the section from config file: DONE."
        }
        else
        {
            write-Host "UnCommenting the section from config file: START."
            $text -replace $commentLine, $ToComment | Set-Content $path
            write-Host "UnCommenting the section from config file: DONE."
        }        
   
   }
}

##########################END of Function ##############
 if ($RecursiveBool)
 {
	Write-Debug "In if"
	$GetAllFilesToBeEncryted = GCI "$configFilePath" -Include $configFilePattern -Recurse
 }
 else
 {
	Write-Debug "In else"
	$GetAllFilesToBeEncryted = GCI "$configFilePath" -Filter $configFilePattern
	#Write-Debug $GetAllFilesToBeEncryted.Count
 }
 # $GetAllFilesToBeEncryted=GCI "$configFilePath" -Include "$configFilePattern" -Recurse
 
Write-Host "Number of Files Found:" $GetAllFilesToBeEncryted.Count
#The System.Configuration assembly must be loaded
$configurationAssembly = "System.Configuration, Version=2.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a"
[void] [Reflection.Assembly]::Load($configurationAssembly)
  
$configurationFileMap = New-Object -TypeName System.Configuration.ExeConfigurationFileMap

 foreach($file in $GetAllFilesToBeEncryted)
 {
    Write-Host "########Encryption Start###"
   
    $configPath=$file.fullName
    Write-Host "...in file  $($configPath)" 
    commentSection -path $configPath -comment $true -CommentSection $SectionToCommentsInConfig

    $configurationFileMap.ExeConfigFilename = $configPath
    $configuration = [System.Configuration.ConfigurationManager]::OpenMappedExeConfiguration($configurationFileMap, [System.Configuration.ConfigurationUserLevel]"None")
    $section = $configuration.GetSection($sectionName)
     if ($section -ne $null)
     {  
        if (-not $section.SectionInformation.IsProtected)
        {
          Write-Host "Encrypting configuration section for File: $configPath  ..."
          $section.SectionInformation.ProtectSection($dataProtectionProvider);
          $section.SectionInformation.ForceSave = [System.Boolean]::True;
          $configuration.Save([System.Configuration.ConfigurationSaveMode]::Modified);
          Write-Host "Section $sectionName succesfuly Encrypted!"
        }
        else
        {
             $exitCode=1

             $(throw "Unable to Encrypt $($sectionName) as this is Protected.")
        }
        commentSection -path $configPath -comment $false -CommentSection $SectionToCommentsInConfig
        
        Write-Host "########Encryption Start###"
    }
    else
    {
        $exitCode=1

        $(throw "Cound not find Section Name $sectionName Provided.")
    }    

 }


}
 catch 
    {
        $ErrorMessage=$_.Exception.Message
        Write-Host "`n ERROR: " $ErrorMessage
        $exitCode=1
      
    }

finally
{
    Trace-VstsLeavingInvocation $MyInvocation
}
##################################################################################
# Indicate the resulting exit code to the calling process.
if ($exitCode -gt 0)
{
	"`nERROR: Operation failed with error code $exitCode."
  Write-VstsSetResult -Result 'Failed' -Message "ERROR: Operation failed" -DoNotThrow
    
}
"`nDone."