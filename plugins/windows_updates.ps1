$provides = "windows_updates"

function Collect-Data {
  $windows_updates = [ordered]@{}

  $U_Session = New-Object -ComObject Microsoft.Update.Session
  $U_Searcher = $U_Session.CreateUpdateSearcher()
  $U_Searcher.Online = $true
  $U_Installed = $U_Searcher.Search("IsInstalled=1 and Type='Software'")
  $listpatches = @{}
  $patchlist = @()
  foreach ($UI_Updates in $U_Installed.Updates){
  foreach($k in $UI_Updates.KBArticleIDs){
  $Xkey = "KB" + $k
  }
  foreach($v in $UI_Updates.SecurityBulletinIDs){
  $XValue = $v
  }
  foreach($d in $UI_Updates.LastDeploymentChangeTime){
  $XDate = $d
  }
  $listpatches.Article = $XKey
  $listpatches.Bulletin = $XValue
  $listpatches.DateInstalled = $XDate
  $ObjectName = New-Object PSObject -Property $listpatches
  $patchlist += $ObjectName

  }

  [ordered]@{"windows_updates" = $patchlist}
}
