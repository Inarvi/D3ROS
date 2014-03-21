
Func RegisterDotNetComponent($path)
    Local $text
    ;Local $regasm = "C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\regasm.exe"
	Local $regasm = _GetDotNetInstalledDir() & "\RegAsm.exe"
	Local $regasmparams = ' /tlb "' & $path & '" /codebase'
	ConsoleWrite($regasm & @CRLF & $regasm & $regasmparams & @CRLF & @CRLF)
	run($regasm & $regasmparams)
EndFunc

Func _GetDotNetInstalledDir()
    Local $DotNetDir = RegRead("HKLM\Software\Microsoft\.NetFramework","InstallRoot")
    If $DotNetDir = "" Then Return "" ;.net is not installed
    Local $version = ""
    For $i =1 To 10
        If StringRegExp(RegEnumKey("HKLM\Software\Microsoft\.NetFramework\policy",$i),"v(4.0)") Then
            $version = $i
            If @error <> 0 Then
			ConsoleWrite("NetFrameWork not installed ! " & @CRLF)
				ExitLoop
			EndIf
        EndIf
    Next
    Local $versionNum = RegEnumKey("HKLM\Software\Microsoft\.NetFramework\policy",$version)
    $version = RegEnumVal("HKLM\Software\Microsoft\.NetFramework\policy\" & $versionNum,1 )
    Return $DotNetDir & $versionNum & "." & $version
EndFunc


