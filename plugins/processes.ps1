$provides = "processes"

function Collect-Data {
  $processes = [ordered]@{}
  $list_processes = Get-WmiObject -Class Win32_Process |
                    Select Caption,CommandLine,CreationClassName,CreationDate,ExecutablePath,Handle,HandleCount,InstallDate,KernelModeTime,MaximumWorkingSetSize,MinimumWorkingSetSize,ParentProcessId,PeakPageFileUsage,PeakVirtualSize,PeakWorkingSetSize,Priority,PrivatePageCount,ProcessId,QuotaNonPagedPoolUsage,QuotaPagedPoolUsage,QuotaPeakNonPagedPoolUsage ,QuotaPeakPagedPoolUsage,ReadOperationCount,ReadTransferCount,SessionId,ThreadCount,UserModeTime,VirtualSize,WorkingSetSize,WriteOperationCount,WriteTransferCount,ProcessName,Handles,VM,WS,Path
  [ordered]@{"processes" = $list_processes} 

}

