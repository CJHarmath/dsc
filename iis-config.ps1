Configuration iis-config {
    [CmdletBinding()]
    param()

    Import-DscResource -ModuleName xWebAdministration, PSDesiredStateConfiguration
    $windowsFeatures = @("web-server", "web-webserver","Web-Mgmt-Console")

    foreach ($feature in $windowsFeatures){
        WindowsFeature $feature {
            Ensure = "Present"
            Name = $feature
        }
    }

   xWebSiteDefaults SiteDefaults{
       ApplyTo = "Machine"
       LogFormat = "IIS"
       LogDirectory = "c:\logs\iis"
       TraceLogDirectory = "c:\logs\FailedRequestLogs"
       AllowSubDirConfig = "true"
       
   }

   xIisLogging Logging{
       LogPath = "c:\logs\iis"
       LogFlags = @("Date","Time","ClientIP","UserName","ServerIP")
       LogPeriod = "Daily"
       LogFormat = "W3C"
   } 

   xWebSite DefaultSite{
       Ensure = "Absent"
       Name = "Default Web Site"
   }

   xWebAppPool DefaultPool {
       Ensure = "Absent"
       Name = "DefaultAppPool"
   }

   xWebAppPoolDefaults PoolDefaults{
        ApplyTo = "Machine"
        ManagedRuntimeVersion = "v4.0"
        IdentityType = "ApplicationPoolIdentity"
   }

}