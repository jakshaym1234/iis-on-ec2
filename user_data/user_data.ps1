Install-WindowsFeature -name Web-Server -IncludeManagementTools
New-Item -Path C:\inetpub\wwwroot\index.html -ItemType File -Value "welcomes you" -Force
