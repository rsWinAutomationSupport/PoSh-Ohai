$provides = "ServerFeatures", "OptionalFeatures"

function Collect-Data {
  $ServerFeatures = [ordered]@{}
  $OptionalFeatures = [ordered]@{}
  $list_ServerFeatures = Get-WmiObject -Class Win32_ServerFeature | select ParentId,Id,Name
  $list_OptionalFeatures = Get-WmiObject -Class Win32_OptionalFeature | select Name,InstallState

  [ordered]@{"ServerFeatures" = $list_ServerFeatures}
  [ordered]@{"OptionalFeatures" = $list_OptionalFeatures}
}
