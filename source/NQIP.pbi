; модуль получения командной строки чужого процесса
; модуль реализован на основании функции WinAPI NtQueryInformationProcess
; https://www.purebasic.fr/english/viewtopic.php?p=442019#p442019  Posted: Tue Apr 08, 2014 6:32 pm
; компилировать для 32-х и 64-х разрядных систем отдельно
Structure UNICODE_STRING Align #PB_Structure_AlignC
    Length.w
    MaximumLength.w
    Buffer.i
EndStructure

Structure RTL_DRIVE_LETTER_CURDIR Align #PB_Structure_AlignC
    Flags.w
    Length.w
    TimeStamp.l
    DosPath.UNICODE_STRING
EndStructure

Structure RTL_USER_PROCESS_PARAMETERS Align #PB_Structure_AlignC
    MaximumLength.l
    Length.l
    Flags.l
    DebugFlags.l
    ConsoleHandle.i
    ConsoleFlags.i
    StdInputHandle.i
    StdOutputHandle.i
    StdErrorHandle.i
    CurrentDirectoryPath.UNICODE_STRING
    CurrentDirectoryHandle.i
    DllPath.UNICODE_STRING
    ImagePathName.UNICODE_STRING
    CommandLine.UNICODE_STRING
    Environment.i
    StartingPositionLeft.l
    StartingPositionTop.l
    Width.l
    Height.l
    CharWidth.l
    CharHeight.l
    ConsoleTextAttributes.l
    WindowFlags.l
    ShowWindowFlags.l
    WindowTitle.UNICODE_STRING
    DesktopName.UNICODE_STRING
    ShellInfo.UNICODE_STRING
    RuntimeData.UNICODE_STRING
    DLCurrentDirectory.RTL_DRIVE_LETTER_CURDIR[$20]
EndStructure

Structure PEB Align #PB_Structure_AlignC
    InheritedAddressSpace.b
    ReadImageFileExecOptions.b
    BeingDebugged.b
    Spare.b
    Mutant.i
    ImageBaseAddress.i
    *LoaderData.PEB_LDR_DATA
    *ProcessParameters.RTL_USER_PROCESS_PARAMETERS
    SubSystemData.i
    ProcessHeap.i
    FastPebLock.i
    *FastPebLockRoutine.PEBLOCKROUTINE
    *FastPebUnlockRoutine.PEBLOCKROUTINE
    EnvironmentUpdateCount.l
    KernelCallbackTable.i
    EventLogSection.i
    EventLog.i
    *FreeList.PEB_FREE_BLOCK
    TlsExpansionCounter.l
    TlsBitmap.i
    TlsBitmapBits.l[$2]
    ReadOnlySharedMemoryBase.i
    ReadOnlySharedMemoryHeap.i
    ReadOnlyStaticServerData.i
    AnsiCodePageData.i
    OemCodePageData.i
    UnicodeCaseTableData.i
    NumberOfProcessors.l
    NtGlobalFlag.l
    Spare2.b[$4]
    CriticalSectionTimeout.LARGE_INTEGER
    HeapSegmentReserve.l
    HeapSegmentCommit.l
    HeapDeCommitTotalFreeThreshold.l
    HeapDeCommitFreeBlockThreshold.l
    NumberOfHeaps.l
    MaximumNumberOfHeaps.l
    ProcessHeaps.i
    GdiSharedHandleTable.i
    ProcessStarterHelper.i
    GdiDCAttributeList.i
    LoaderLock.i
    OSMajorVersion.l
    OSMinorVersion.l
    OSBuildNumber.l
    OSPlatformId.l
    ImageSubsystem.l
    ImageSubSystemMajorVersion.l
    ImageSubSystemMinorVersion.l
    GdiHandleBuffer.l[$22]
    PostProcessInitRoutine.l
    TlsExpansionBitmap.l
    TlsExpansionBitmapBits.b[$80]
    SessionId.l
EndStructure

Structure PROCESS_BASIC_INFORMATION Align #PB_Structure_AlignC
    ExitStatus.i
    *PebBaseAddress.PEB
    AffinityMask.i
    BasePriority.i
    UniqueProcessId.i
    InheritedFromUniqueProcessId.i
EndStructure

Procedure TestForError()
    dwMessageId = GetLastError_()
    
    If dwMessageId
        *lpBuffer = AllocateMemory(#MAX_PATH)
        FormatMessage_(#FORMAT_MESSAGE_FROM_SYSTEM, #Null, dwMessageId, #Null, *lpBuffer, #MAX_PATH, #Null)
        dwErrorMsg.s = Trim(PeekS(*lpBuffer, #MAX_PATH, #PB_Ascii))
        Debug "-- Error: " + Str(dwMessageId) + " - " + Left(dwErrorMsg, Len(dwErrorMsg) - 2)
        FreeMemory(*lpBuffer)
    EndIf
EndProcedure

Procedure.b AdjustProcessPrivilege()
    Protected Result.b = #False
    
    If OpenProcessToken_(GetCurrentProcess_(), #TOKEN_ADJUST_PRIVILEGES | #TOKEN_QUERY, @TokenHandle)
        lpLuid.LUID
        
        If LookupPrivilegeValue_(#Null, #SE_DEBUG_NAME, @lpLuid)
            NewState.TOKEN_PRIVILEGES
            
            With NewState
                \PrivilegeCount = 1
                \Privileges[0]\Luid\LowPart = lpLuid\LowPart
                \Privileges[0]\Luid\HighPart = lpLuid\HighPart
                \Privileges[0]\Attributes = #SE_PRIVILEGE_ENABLED
            EndWith
            Result = AdjustTokenPrivileges_(TokenHandle, #False, @NewState, SizeOf(TOKEN_PRIVILEGES), @PreviousState.TOKEN_PRIVILEGES, @ReturnLength)
        EndIf
        CloseHandle_(TokenHandle)
    EndIf
    ProcedureReturn Result
EndProcedure

Procedure GetPBI(hProcess)
    Protected Result = #Null
    #ProcessBasicInformation = 0
    Protected pbi.PROCESS_BASIC_INFORMATION
    
    If Not NtQueryInformationProcess_(hProcess, #ProcessBasicInformation, @pbi, SizeOf(pbi), @ReturnLength)
        If pbi\PebBaseAddress
            Result = pbi\PebBaseAddress
        EndIf
    EndIf
    ProcedureReturn Result
EndProcedure

Procedure GetPEB(hProcess, PebBaseAddress)
    Protected Result = #Null
    Protected peb.PEB
    
    If ReadProcessMemory_(hProcess, PebBaseAddress, @peb, SizeOf(PEB), #Null)
        If peb\ProcessParameters
            Result = peb\ProcessParameters
        EndIf
    EndIf
    ProcedureReturn Result
EndProcedure

Procedure.s GetCMD(hProcess, ProcessParameters)
    Protected Result.s = ""
    Protected rtl.RTL_USER_PROCESS_PARAMETERS
    ZeroMemory_(@rtl, SizeOf(rtl))
    
    If ReadProcessMemory_(hProcess, ProcessParameters, @rtl, SizeOf(rtl), #Null)
        If rtl\CommandLine\Buffer
            *CmdLine = AllocateMemory(rtl\CommandLine\MaximumLength)
            
            If ReadProcessMemory_(hProcess, rtl\CommandLine\Buffer, *CmdLine, rtl\CommandLine\MaximumLength, #Null)
                Result = PeekS(*CmdLine, rtl\CommandLine\MaximumLength, #PB_Unicode)
            EndIf
            FreeMemory(*CmdLine)
        EndIf
    EndIf
    ProcedureReturn Result
EndProcedure

Procedure.s NQIP_GetCommandLine(PID)
    hSnapshot = CreateToolhelp32Snapshot_(#TH32CS_SNAPPROCESS, #Null)
    If hSnapshot
        ProcEntry.PROCESSENTRY32
        ProcEntry\dwSize = SizeOf(PROCESSENTRY32)
        If Process32First_(hSnapshot, @ProcEntry)
            While Process32Next_(hSnapshot, @ProcEntry)
                AdjustProcessPrivilege()
                dwProcessId = ProcEntry\th32ProcessID
                If PID=dwProcessId
                    hProcess = OpenProcess_(#PROCESS_QUERY_INFORMATION | #PROCESS_VM_READ, #False, dwProcessId)
                    If hProcess
                        Protected pbi.PROCESS_BASIC_INFORMATION
                        ZeroMemory_(@pbi, SizeOf(pbi))
                        pbi\PebBaseAddress = GetPBI(hProcess)
                        Protected peb.PEB
                        ZeroMemory_(@peb, SizeOf(PEB))
                        peb\ProcessParameters = GetPEB(hProcess, pbi\PebBaseAddress)
                        CommandLine.s = GetCMD(hProcess, peb\ProcessParameters)
                        If CommandLine <>""
                            CloseHandle_(hProcess)
                            ProcedureReturn Trim(CommandLine)            
                            ;Debug Str(dwProcessId)+"  "+CommandLine : 
                        Else 
                            TestForError()  
                        EndIf
                    EndIf
                EndIf
            Wend
        EndIf
        CloseHandle_(hSnapshot)
    EndIf
EndProcedure
; Debug NQIP_GetCommandLine(22296)
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 99
; FirstLine = 98
; Folding = A-
; EnableXP
; CompileSourceDirectory
; Compiler = PureBasic 5.72 (Windows - x64)