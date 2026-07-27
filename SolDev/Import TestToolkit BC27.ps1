# ******************************************************************************************************
#"C:\Dynamics.365.BC.33876.DE.DVD\Test Assemblies\Mock Assemblies\MockTest.dll"
# in Verzeichnis kopieren: C:\Program Files\Microsoft Dynamics 365 Business Central\260\Service\Add-ins
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#Vorbereiten

$si = 'BC270'
$dvdpath = 'C:\Dynamics.365.BC.45458.DE.DVD'

Copy-Item 'C:\Dynamics.365.BC.45458.DE.DVD\Test Assemblies\Mock Assemblies\MockTest.dll' 'C:\Program Files\Microsoft Dynamics 365 Business Central\270\Service\Add-ins' -Force


#"C:\Dynamics.365.BC.33876.DE.DVD\applications\testframework\testlibraries\variable storage\Microsoft_Library Variable Storage.app"
$appname1 = 'Library Variable Storage'
$apppath1 = $dvdpath + '\applications\testframework\testlibraries\variable storage\Microsoft_Library Variable Storage.app'

#"C:\Dynamics.365.BC.33876.DE.DVD\applications\BusinessFoundation\Test\Microsoft_Business Foundation Test Libraries.app"
$appname2 = 'Business Foundation Test Libraries'
$apppath2 = $dvdpath + '\applications\BusinessFoundation\Test\Microsoft_Business Foundation Test Libraries.app'

#"C:\Dynamics.365.BC.33876.DE.DVD\applications\BusinessFoundation\Test\Microsoft_Business Foundation Tests.app"
$appname3 = 'Business Foundation Tests'
$apppath3 = $dvdpath + '\applications\BusinessFoundation\Test\Microsoft_Business Foundation Tests.app'

$appname4 = 'Any'
$apppath4 = $dvdpath + '\applications\testframework\testlibraries\any\Microsoft_Any.app'

$appname5 = 'Library Assert'
$apppath5 = $dvdpath + '\applications\testframework\testlibraries\assert\Microsoft_Library Assert.app'

$appname6 = 'System Application Test Library'
$apppath6 = $dvdpath + '\applications\System Application\Test\Microsoft_System Application Test Library.app'

$appname7 = 'Test Runner'
$apppath7 = $dvdpath + '\applications\testframework\TestRunner\Microsoft_Test Runner.app'

$appname8 = 'Tests-TestLibraries'
$apppath8 = $dvdpath + '\applications\BaseApp\Test\Microsoft_Tests-TestLibraries.app'



Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\270\Service\NavAdminTool.ps1" -Force | Out-Null

# Restart-NAVServerInstance -ServerInstance $si

#Extension deinstallieren
#Uninstall-NAVApp -ServerInstance $si -Name $appname1 -ClearSchema
#Unpublish-NAVApp -ServerInstance $si -Name $appname1

#Uninstall-NAVApp -ServerInstance $si -Name $appname2 -ClearSchema
#Unpublish-NAVApp -ServerInstance $si -Name $appname2

#Uninstall-NAVApp -ServerInstance $si -Name $appname3 -ClearSchema
#Unpublish-NAVApp -ServerInstance $si -Name $appname3

#Uninstall-NAVApp -ServerInstance $si -Name $appname4 -ClearSchema
#Unpublish-NAVApp -ServerInstance $si -Name $appname4

#Uninstall-NAVApp -ServerInstance $si -Name $appname5 -ClearSchema
#Unpublish-NAVApp -ServerInstance $si -Name $appname5

#Uninstall-NAVApp -ServerInstance $si -Name $appname6 -ClearSchema
#Unpublish-NAVApp -ServerInstance $si -Name $appname6

#Uninstall-NAVApp -ServerInstance $si -Name $appname7 -ClearSchema
#Unpublish-NAVApp -ServerInstance $si -Name $appname7

#Uninstall-NAVApp -ServerInstance $si -Name $appname8 -ClearSchema
#Unpublish-NAVApp -ServerInstance $si -Name $appname8



#Extension installieren
publish-NAVApp -ServerInstance $si -Path $apppath5 -SkipVerification
Sync-NAVApp -ServerInstance $si -Name $appname5 -Mode ForceSync
Install-NAVApp -ServerInstance $si -Name $appname5


Publish-NAVApp -ServerInstance $si -Path $apppath1 -SkipVerification
Sync-NAVApp -ServerInstance $si -Name $appname1 -Mode ForceSync
Install-NAVApp -ServerInstance $si -Name $appname1

Publish-NAVApp -ServerInstance $si -Path $apppath2 -SkipVerification
Sync-NAVApp -ServerInstance $si -Name $appname2 -Mode ForceSync
Install-NAVApp -ServerInstance $si -Name $appname2

publish-NAVApp -ServerInstance $si -Path $apppath4 -SkipVerification
Sync-NAVApp -ServerInstance $si -Name $appname4 -Mode ForceSync
Install-NAVApp -ServerInstance $si -Name $appname4


publish-NAVApp -ServerInstance $si -Path $apppath3 -SkipVerification
Sync-NAVApp -ServerInstance $si -Name $appname3 -Mode ForceSync
Install-NAVApp -ServerInstance $si -Name $appname3



publish-NAVApp -ServerInstance $si -Path $apppath6 -SkipVerification
Sync-NAVApp -ServerInstance $si -Name $appname6 -Mode ForceSync
Install-NAVApp -ServerInstance $si -Name $appname6

publish-NAVApp -ServerInstance $si -Path $apppath7 -SkipVerification
Sync-NAVApp -ServerInstance $si -Name $appname7 -Mode ForceSync
Install-NAVApp -ServerInstance $si -Name $appname7

publish-NAVApp -ServerInstance $si -Path $apppath8 -SkipVerification
Sync-NAVApp -ServerInstance $si -Name $appname8 -Mode ForceSync
Install-NAVApp -ServerInstance $si -Name $appname8