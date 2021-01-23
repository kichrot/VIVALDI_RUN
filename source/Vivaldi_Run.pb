; * Утилита для браузера VIVALDI / Vivaldi browser utility
; * автор / author: kichrot
; * https://forum.vivaldi.net/topic/43971/vivaldi_run-utility-windows-only
; * 2021 year 

XIncludeFile "NQIP.pbi"


; ////////////////// Глобальные переменные и константы ////////////////////////////

; глобальная переменная о состоянии автоскрытия панели задач. с которым был запущен VIVALDI
; 0 - автоскрытие выключено, 1 - автоскрытие включено
Global AutoHideTrayWnd=0

; глобальная переменная о назначенном текущем состоянии автоскрытия панели задач
; 0 - автоскрытие без изменений, 1 - автоскрытие переключено (по отношению к начальному состоянию)
Global TrigerAutoHide=0

; глобальная переменная содержащая имя файла с параметрами командной строки VIVALDI
Global NameFileCommandLineVivaldi.s="VIVALDI_COMMAND_LINE.txt"

; глобальная переменная содержащая PID процесса текщего активного окна VIVALDI
Global PidActiveWndVivaldi=0

; глобальная переменная содержащая параметр ком. строки к профилю VIVALDI для активного окна
Global ParamProfileActiveWndVivaldi.s=""

; объявление внешней переменной из WINAPI для процедуры OSbits()
Import ""
    GetNativeSystemInfo(*info)
EndImport

; ////////////////// Процедуры и функции ////////////////////////////

; Прототипы процедур для работы с процессами 
Prototype ProcessFirst(Snapshot, Process)
Prototype ProcessNext(Snapshot, Process)

; Процедура проверки OS 32 или 64 bit.
Procedure OSbits()
    Protected Info.SYSTEM_INFO
    GetNativeSystemInfo(Info)
    If info\wProcessorArchitecture
        ProcedureReturn 64
    Else
        ProcedureReturn 32 
    EndIf
EndProcedure

; Процедура закрытия процесса по PID
Procedure KillProcess(Pid) 
    phandle = OpenProcess_ (#PROCESS_TERMINATE, #False, Pid) 
    If phandle <> #Null 
        If TerminateProcess_ (phandle, 1) 
            Result = #True 
        EndIf 
        CloseHandle_ (phandle) 
    EndIf 
    ProcedureReturn Result 
EndProcedure 

; Процедура поиска и закрытия экземпляра Vivaldi_Run запущенного ранее
Procedure KillProcessSecondVivaldi_Run(Name.s="Vivaldi_Run.exe")
    Protected ProcessFirst.ProcessFirst
    Protected ProcessNext.ProcessNext
    Protected ProcLib
    Protected ProcName.s
    Protected Process.PROCESSENTRY32
    Protected x
    Protected retval=#False
    Name=UCase(Name.s)
    ProcLib= OpenLibrary(#PB_Any, "Kernel32.dll") 
    If ProcLib
        CompilerIf #PB_Compiler_Unicode
            ProcessFirst = GetFunction(ProcLib, "Process32FirstW") 
            ProcessNext  = GetFunction(ProcLib, "Process32NextW") 
        CompilerElse
            ProcessFirst = GetFunction(ProcLib, "Process32First") 
            ProcessNext  = GetFunction(ProcLib, "Process32Next") 
        CompilerEndIf
        If  ProcessFirst And ProcessNext 
            Process\dwSize = SizeOf(PROCESSENTRY32) 
            Snapshot =CreateToolhelp32Snapshot_(#TH32CS_SNAPALL,0)
            If Snapshot 
                ProcessFound = ProcessFirst(Snapshot, Process) 
                x=1
                While ProcessFound 
                    ProcName=PeekS(@Process\szExeFile)
                    ProcName=GetFilePart(ProcName)
                    If UCase(ProcName)=UCase(Name) 
                        ret=Process\th32ProcessID
                        If ret<>GetCurrentProcessId_()
                            KillProcess(ret) 
                            Break
                        EndIf
                    EndIf
                    ProcessFound = ProcessNext(Snapshot, Process) 
                    x=x+1  
                Wend 
            EndIf 
            CloseHandle_(Snapshot) 
        EndIf 
        CloseLibrary(ProcLib) 
    EndIf 
    ;ProcedureReturn ret
EndProcedure

; Проверяем наличие в параметрах коммандной строки параметра управления Vivaldi_Run
Procedure.s CheckParametr(Command_Line.s, Parametr.s)
    Protected Dim ParamVivaldi_Run.s(0)
    CreateRegularExpression(3, Parametr)
    CountParamVivaldi_Run=ExtractRegularExpression(3, Command_Line, ParamVivaldi_Run())
    If CountParamVivaldi_Run>0
        ProcedureReturn ParamVivaldi_Run(0)
    Else
       ProcedureReturn ""
   EndIf  
   FreeRegularExpression(3)
EndProcedure
    
; Процедура проверки повторного запуска Vivaldi_Run
Procedure CheckRun(FileName.s) 
    Protected Command_Line_Vivaldi_Run.s, ParametrRFCLP.s=""
    ; Получаем параметры командной строки для файла Vivaldi_Run.exe
    Command_Line_Vivaldi_Run=Trim(Mid(PeekS(GetCommandLine_()), Len(ProgramFilename())+3))
    ParametrRFCLP=CheckParametr(Command_Line_Vivaldi_Run, "--RFCLP=(["+Chr(34)+"])(\\?.)*?\1")
    *a = CreateSemaphore_(0, 0, 1, FileName)
    If *a <> 0 And GetLastError_()= #ERROR_ALREADY_EXISTS
        CloseHandle_(*a)
        If ParametrRFCLP<>""
            KillProcessSecondVivaldi_Run(FileName)
            *a = CreateSemaphore_(0, 0, 1, FileName)
        ElseIf ParametrRFCLP=""
            End
        EndIf
    EndIf
EndProcedure

; Процедура чтения файла (возвращает содержимое в виде строки)
Procedure.s LoadFromFile(File.s)
    Protected OpFile,StringFormat,String.s,Strings.s
    CreateRegularExpression(0, "(<)(.*?)(>)")
    If OpenFile(OpFile, File.s)   
        While Eof(OpFile) = 0              ; пока не прочли весь файл
            StringFormat = ReadStringFormat(OpFile)
            If StringFormat = #PB_Ascii
                String =  ReadString(OpFile,#PB_Ascii)  ; читает строки как ASCII построчно
            ElseIf StringFormat = #PB_UTF8
                String =  ReadString(OpFile,#PB_UTF8)  ; читает строки как UTF8 построчно
            ElseIf StringFormat = #PB_Unicode
                String =  ReadString(OpFile,#PB_Unicode)  ; читает строки как UTF16 построчно
            EndIf
            Strings = Strings+" "+String
        Wend
        CloseFile(OpFile)
        Strings = ReplaceRegularExpression(0, Strings, " ") ; удаляем комментарии
        FreeRegularExpression(0)
        ProcedureReturn Strings
    Else
        MessageRequester("Vivaldi_Run", "Failed to open the file: "+File, #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
        FreeRegularExpression(0)
        End ; Завершение работы программы
    EndIf
EndProcedure 

; Процедура изменения приоритета собственного процесса программы Vivaldi_Run 
Procedure ChangeProcessPriorityVivaldi_Run(Priority)
    ; меняем приоритет своего процесса
    SetThreadPriority_( GetCurrentThread_() , #THREAD_BASE_PRIORITY_MAX)
    SetPriorityClass_(  GetCurrentProcess_(), Priority)
EndProcedure

; Процедура изменения приоритета процесса окна Vivaldi находящегося на переднем плане
Procedure ChangeProcessPriorityVivaldi(Priority)
    Protected ThreadProcessId, HandleProcess
    GetWindowThreadProcessId_(GetForegroundWindow_(), @ThreadProcessId)
    SetThreadPriority_(ThreadProcessId , #THREAD_BASE_PRIORITY_MAX)
    HandleProcess=OpenProcess_(#PROCESS_DUP_HANDLE | #PROCESS_SET_INFORMATION, #True, ThreadProcessId)
    SetPriorityClass_(HandleProcess, Priority)
    CloseHandle_(HandleProcess)
EndProcedure

; Процедура определения значения глобальнjq переменнjq AutoHideTrayWnd
;(состоянии автоскрытия панели задач, с которым был запущен VIVALDI)
Procedure Set_AutoHideTrayWnd()
    #ABM_SETSTATE = 10
    aBdata.AppBarData
    aBdata\cbsize = SizeOf(AppBarData)
    ; проверка существования семафоров, что режим автоскрытия панели задач в WINDOWS выключен/включен
    *a = CreateSemaphore_(0, 0, 1, "AutoHideTrayWnd")
    *b = CreateSemaphore_(0, 0, 1, "NoAutoHideTrayWnd")
    If *b <> 0 And GetLastError_()= #ERROR_ALREADY_EXISTS
        AutoHideTrayWnd=0 
    ElseIf *a <> 0 And GetLastError_()= #ERROR_ALREADY_EXISTS
        AutoHideTrayWnd=1
    Else
        If SHAppBarMessage_(#ABM_GETSTATE, @aBdata)=#ABS_AUTOHIDE
            AutoHideTrayWnd=1
            ; создание семафора, что режим автоскрытия панели задач в WINDOWS включен
            CreateSemaphore_(0, 0, 1, "AutoHideTrayWnd")
        Else
            AutoHideTrayWnd=0
            ; создание семафора, что режим автоскрытия панели задач в WINDOWS выключен
            CreateSemaphore_(0, 0, 1, "NoAutoHideTrayWnd")
        EndIf
    EndIf
    CloseHandle_(*a)
    CloseHandle_(*b)
    TrigerAutoHide=0
EndProcedure

; Процедура изменения режима автоскрытия панели задач 
Procedure TrayWndAutoHide(AutoHide=1)
    ChangeProcessPriorityVivaldi_Run(#HIGH_PRIORITY_CLASS)
    #ABM_SETSTATE = 10
    aBdata.AppBarData
    aBdata\cbsize = SizeOf(AppBarData)
    If AutoHide=1
        If SHAppBarMessage_(#ABM_GETSTATE, @aBdata)=#ABS_AUTOHIDE
            aBdata\lparam = #ABS_ALWAYSONTOP
            SHAppBarMessage_(#ABM_SETSTATE, @aBdata)
            If AutoHideTrayWnd=0
                TrigerAutoHide=0
            Else
                TrigerAutoHide=1
            EndIf   
        Else
            ShowWindow_(FindWindow_("Shell_TrayWnd", 0), SW_HIDE)
            Delay(400)
            aBdata\lparam = #ABS_AUTOHIDE
            SHAppBarMessage_(#ABM_SETSTATE, @aBdata)
            ShowWindow_(FindWindow_("Shell_TrayWnd", 0), SW_SHOW)
            If AutoHideTrayWnd=0
                TrigerAutoHide=1
            Else
                TrigerAutoHide=0
            EndIf  
        EndIf
    Else
        If AutoHideTrayWnd=0
            aBdata\lparam = #ABS_ALWAYSONTOP
            SHAppBarMessage_(#ABM_SETSTATE, @aBdata)
        Else
            aBdata\lparam = #ABS_AUTOHIDE
            SHAppBarMessage_(#ABM_SETSTATE, @aBdata) 
        EndIf
        TrigerAutoHide=0
    EndIf
    ChangeProcessPriorityVivaldi_Run(#BELOW_NORMAL_PRIORITY_CLASS)
EndProcedure

; Процедура эмуляции нажатия сочетания клавиш
Procedure KeybdEvent(KEYUPDelay, KodeKey_1, KodeKey_2=0, KodeKey_3=0, KodeKey_4=0, KodeKey_5=0, KodeKey_6=0)
    keybd_event_(KodeKey_1, 0, 0, 0)
    If KodeKey_2>0
        keybd_event_(KodeKey_2, 0, 0, 0)
        If KodeKey_3>0
            keybd_event_(KodeKey_3, 0, 0, 0)
            If KodeKey_4>0
                keybd_event_(KodeKey_4, 0, 0, 0)
                If KodeKey_5>0
                    keybd_event_(KodeKey_5, 0, 0, 0)
                    If KodeKey_6>0
                        keybd_event_(KodeKey_6, 0, 0, 0)
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf    
    Delay(KEYUPDelay)
    keybd_event_(KodeKey_1, 0, #KEYEVENTF_KEYUP, 0)
    If KodeKey_2>0
        keybd_event_(KodeKey_2, 0, #KEYEVENTF_KEYUP, 0)
        If KodeKey_3>0
            keybd_event_(KodeKey_3, 0, #KEYEVENTF_KEYUP, 0)
            If KodeKey_4>0
                keybd_event_(KodeKey_4, 0, #KEYEVENTF_KEYUP, 0)
                If KodeKey_5>0
                    keybd_event_(KodeKey_5, 0, #KEYEVENTF_KEYUP, 0)
                    If KodeKey_6>0
                        keybd_event_(KodeKey_6, 0, #KEYEVENTF_KEYUP, 0)
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf    
EndProcedure

; Процедура принудительного вывода окна на передний план
Procedure SetForegroundWindow(hWnd) 
    If GetWindowLong_(hWnd, #GWL_STYLE) & #WS_MINIMIZE 
        ShowWindow_(hWnd, #SW_MAXIMIZE) 
        UpdateWindow_(hWnd) 
    EndIf 
    foregroundThreadID = GetWindowThreadProcessId_(GetForegroundWindow_(), 0) 
    ourThreadID = GetCurrentThreadId_() 
    If (foregroundThreadID <> ourThreadID) 
        AttachThreadInput_(foregroundThreadID, ourThreadID, #True); 
    EndIf 
    SetForegroundWindow_(hWnd) 
    If (foregroundThreadID <> ourThreadID) 
        AttachThreadInput_(foregroundThreadID, ourThreadID, #False) 
    EndIf   
    InvalidateRect_(hWnd, #Null, #True)
    
    ;запасной рабочий но костыльный вариант процедуры
    ;     keybd_event_(18 , 0, 0, 0)
    ;     SetForegroundWindow_(hWnd)
    ;     Delay(70)
    ;     keybd_event_(18 , 0, #KEYEVENTF_KEYUP, 0)
EndProcedure  

; Процедура запуска внешнего приложения WINDOWS, с выводом окна на передний план
Procedure LaunchingExternalProgram(ProgramName.s, Command_Line.s)
    Protected RunProgramPID, hWnd, pid, Flag=0, Program, hWndForeground, hWndProg=0, Count=0
    Program=RunProgram(ProgramName, Command_Line,"", #PB_Program_Open)
    If Program=0
        MessageRequester("Vivaldi_Run", "Failed to open the file: "+ProgramName, #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
    Else
        RunProgramPID=ProgramID(Program)
        CloseProgram(Program)
        Repeat
            Delay(10)
            Repeat
                If Flag=0
                    hWnd = FindWindow_( 0, 0 )
                    Flag=1
                Else    
                    hWnd = GetWindow_(hWnd, #GW_HWNDNEXT)
                EndIf
                If hWnd <> 0
                    If IsWindowVisible_(hWnd) 
                        GetWindowThreadProcessId_(hWnd, @pid)
                        hWndForeground=GetForegroundWindow_()
                        If RunProgramPID=pid And hWnd<>hWndForeground
                            SetForegroundWindow(hWnd)
                            SetActiveWindow_(hWnd)
                            hWndProg=1
                            Break
                        ElseIf RunProgramPID=pid And hWnd=hWndForeground
                            hWndProg=1
                            Break
                        EndIf
                    EndIf
                Else
                    Flag=0 
                EndIf
            Until hWnd=0
            Count=Count+1
        Until hWndProg=1 Or Count=1000       
    EndIf
EndProcedure

; Процедура запуска VIVALDI
Procedure RunVIVALDI()
    Protected Command_Line.s="", CountParam, Command_Line_Vivaldi_Run.s="",  CountParamVivaldi_Run, ParametrRFCLP.s=""
    Protected Dim ParamVivaldi_Run.s(0)
    Protected Dim FileNameCommandLineVivaldi.s(0)
    
    ; проверяем разрядность OS
    If OSbits()=32 And #PB_Compiler_Processor=#PB_Processor_x64
        MessageRequester("Vivaldi_Run", "For your OS, use the 32-bit version of Vivaldi_Run.", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL) 
        End
    ElseIf OSbits()=64 And #PB_Compiler_Processor=#PB_Processor_x86
        MessageRequester("Vivaldi_Run", "For your OS, use the 64-bit version of Vivaldi_Run.", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL) 
        End
    EndIf
    
    ; заполняем глобальную переменную AutoHideTrayWnd
    Set_AutoHideTrayWnd()
    ; меняем приоритет своего процесса
    ChangeProcessPriorityVivaldi_Run(#HIGH_PRIORITY_CLASS)
    
    ; изменяем рабочий каталог на каталог расположения файла Vivaldi_Run.exe
    SetCurrentDirectory(GetPathPart(ProgramFilename())) 
    
    ; Получаем параметры командной строки для файла Vivaldi_Run.exe
    Command_Line_Vivaldi_Run=Trim(Mid(PeekS(GetCommandLine_()), Len(ProgramFilename())+3))
    
    ; ищем вкомандной строке Vivaldi_Run параметр --RFCLP
    ParametrRFCLP=CheckParametr(Command_Line_Vivaldi_Run, "--RFCLP=(["+Chr(34)+"])(\\?.)*?\1")
    CreateRegularExpression(3, "(?<=()\"+Chr(34)+")\S(.*?)(?=()\"+Chr(34)+")")
    ExtractRegularExpression(3, ParametrRFCLP, FileNameCommandLineVivaldi())
    FreeRegularExpression(3)
    
    ; Меняем значение глобальной переменной с именем файла содержащим параметры командной строки VIVALDI
    If ParametrRFCLP<>""
        NameFileCommandLineVivaldi=FileNameCommandLineVivaldi(0)
    EndIf
    
    ; Проверяем наличие файла с именем из глобальной переменной NameFileCommandLineVivaldi
    If FileSize(NameFileCommandLineVivaldi)=-1 
        CreateFile(0, NameFileCommandLineVivaldi)
        CloseFile(#PB_All)
    Else
        Command_Line = LoadFromFile(NameFileCommandLineVivaldi)
    EndIf
    
    ; Проверяем наличие файла vivaldi.exe
    If FileSize("vivaldi.exe")=-1 
        MessageRequester("Vivaldi_Run", "File vivaldi.exe not found!", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
        End
    Else
        Command_Line=Command_Line_Vivaldi_Run+" "+Command_Line
        
        ; Проверяем наличие в параметрах коммандной строки параметра мини режима --only-start-with-VIVALDI_COMMAND_LINE.txt
        CreateRegularExpression(3, "--only-start-with-VIVALDI_COMMAND_LINE.txt")
        CountParamVivaldi_Run=ExtractRegularExpression(3, Command_Line, ParamVivaldi_Run())
        Command_Line = ReplaceRegularExpression(3, Command_Line, " ") ; удаляем параметр --only-start-with-VIVALDI_COMMAND_LINE.txt
        FreeRegularExpression(3)
        If CountParamVivaldi_Run>0
            LaunchingExternalProgram(Chr(34)+GetCurrentDirectory()+"vivaldi.exe"+Chr(34), Command_Line)
            End
        EndIf  
        
        ; Удаляем параметр --RFCLP
        CreateRegularExpression(3, "--RFCLP=(["+Chr(34)+"])(\\?.)*?\1") 
        Command_Line = ReplaceRegularExpression(3, Command_Line, " ") ; удаляем параметр --RFCLP
        FreeRegularExpression(3)
        
        ; запускаем VIVALDI
        RunProgram(Chr(34)+GetCurrentDirectory()+"vivaldi.exe"+Chr(34), Command_Line,"", #PB_Program_Open)
    EndIf
    
    ;Запрет/проверка на запуск Vivaldi_Run.exe более одного раза
    CheckRun("Vivaldi_Run.exe")
    
    ; меняем приоритет своего процесса
    ChangeProcessPriorityVivaldi_Run(#BELOW_NORMAL_PRIORITY_CLASS)
    
EndProcedure

; Процедура поиска окон
Procedure WndEnumEx(Class.s, TextTitleRegExp.s, WndForeground.s) 
    ; Проверяет существование окон по классу и имени окна в фрмате рег. выражений
    ; Параметры:
    ; Class - класс окна
    ; TextTitleRegExp - имя окна в формате регулярного выражения
    ; WndForeground - указание на обработку активного окна переднего плана, "Y" - обрабатывать,"N" - не обрабатывать
    ; Возвращает:
    ; 1) при WndForeground="Y", при соблюдении условий Class и TextTitleRegExp - хендл активного окна, при не соблюдении условий возвращает - 0
    ; 2) при WndForeground="N", при соблюдении условий Class и TextTitleRegExp - хендл окна, при не соблюдении условий возвращает - 0
    ; Пример использования: Debug WndEnumEx("Chrome_WidgetWin_1", "\s-\sVivaldi\Z", "N")
    
    Protected Flag,hWnd,return_proc
    CreateRegularExpression(0, TextTitleRegExp)
    Sleep_(0)
    If  WndForeground="Y"
        hWnd = GetForegroundWindow_()
        clas.s= Space(256) 
        GetClassName_(hWnd, @clas, 256)
        If clas=Class
            name.s = Space(256)
            GetWindowText_(hWnd, @name, 256)
            If MatchRegularExpression(0, name)
                return_proc=hWnd
            EndIf
        EndIf
    Else
        Repeat
            Sleep_(0)
            If Flag=0
                hWnd = FindWindow_( 0, 0 )
                Flag=1
            Else    
                hWnd = GetWindow_(hWnd, #GW_HWNDNEXT)
            EndIf
            If hWnd <> 0
                clas.s= Space(256) 
                GetClassName_(hWnd, @clas, 256)
                If IsWindowVisible_(hWnd)  
                    If clas=Class
                        name.s = Space(256)
                        GetWindowText_(hWnd, @name, 256)
                        If MatchRegularExpression(0, name)
                            return_proc=hWnd
                        EndIf
                    EndIf
                EndIf
            Else
                Flag=0 
            EndIf
        Until hWnd=0
        FreeRegularExpression(0)
        If return_proc>0
            ProcedureReturn return_proc  
        Else
            ProcedureReturn 0  
        EndIf
    EndIf
    Sleep_(0)
    FreeRegularExpression(0)
    If return_proc>0
        ProcedureReturn return_proc  
    Else
        ProcedureReturn 0  
    EndIf
EndProcedure

; Процедура проверки наличия и ожидания окон VIVALDI
Procedure VivaldiWndEnumWait()
    Protected counter=0, hWnd=0
    Repeat 
        Sleep_(0)
        hWnd=WndEnumEx("Chrome_WidgetWin_1", "\s-\sVivaldi\Z", "N")
        If hWnd=0
            counter=counter+1
            Delay(40)
        Else 
            Break    
        EndIf
        If counter=3000 
            End ; завершаем Vivaldi_Run
        EndIf
    ForEver
    ProcedureReturn hWnd
EndProcedure

; Процедура перехода на страницу по адресу из буфера обмена
Procedure VivaldiClipboardAddress(Address.s)
    Protected ClipboardText.s
    ClipboardText=GetClipboardText()
    SetClipboardText(Address)
    Delay(100)
    KeybdEvent(70, 17, 16, 86)
    Delay(1000)
    SetClipboardText(ClipboardText)
    ClipboardText=""
EndProcedure

; Процедура открытия URL  в новой вкладке текщего активного окна VIVALDI
Procedure OpenURLinVivaldiForegroundWindow(URL.s)
    Protected ProcessId=0, CommandLine.s="", PathProfileParam=0
    Protected Dim ParamPathProfile.s(0)
    GetWindowThreadProcessId_(GetForegroundWindow_(), @ProcessId)
    If ProcessId=PidActiveWndVivaldi
        CommandLine=ParamProfileActiveWndVivaldi
    Else
        ;CommandLine=GetCommandLines(ProcessId)
        CommandLine=NQIP_GetCommandLine(ProcessId)
        CreateRegularExpression(4, "--user-data-dir=("+Chr(34)+")(.*?)("+Chr(34)+")")
        PathProfileParam=ExtractRegularExpression(4, CommandLine, ParamPathProfile())
        If PathProfileParam>0
            CommandLine=Trim(ParamPathProfile(0))
        Else
            CommandLine=""
        EndIf
        FreeRegularExpression(4)
        PidActiveWndVivaldi=ProcessId
        ParamProfileActiveWndVivaldi=CommandLine
    EndIf
    RunProgram(Chr(34)+GetCurrentDirectory()+"vivaldi.exe"+Chr(34), URL+" "+CommandLine,"", #PB_Program_Open)
EndProcedure    

; Процедура получения и применения виртуальных кодов клавиш от VIVALDI
Procedure VivaldiKodeKey(Class.s, TextTitleRegExp.s, VirtKeyRegExp.s)
    ; Проверяет существование активного окна с задаными классом и именем
    ; извлекает из имени окна коды виртуальных клавиш и эмулирует их нажатие для найденного окна 
    ; Параметры:
    ; Class - класс окна
    ; TextTitleRegExp - имя окна в формате регулярного выражения
    ; VirtKeyRegExp - регулярное выражение для извлечения кодов виртуальных клавиш из имени найденного окна
    ; Возвращает: 1 - если окно найдено, коды клавиш извлечены и эмуляция нажатий клавиш произведена.
    Protected hWnd, hWndDevTool, name.s = Space(256),  name2.s = Space(256),CountKodeKey,  CountCommandLineParameters, ClipboardText.s,  OnNumLock=0
    Protected Dim VirtKeyCode.s(0), Dim CommandLineParameters.s(0), Dim PageAddress.s(0) 
    hWnd = WndEnumEx(Class, TextTitleRegExp, "Y")
    If hWnd>0
        ChangeProcessPriorityVivaldi_Run(#HIGH_PRIORITY_CLASS)
        ChangeProcessPriorityVivaldi(#HIGH_PRIORITY_CLASS)
        CreateRegularExpression(1, VirtKeyRegExp)
        GetWindowText_(hWnd, @name, 256)
        If MatchRegularExpression(1, name)
            CountKodeKey=ExtractRegularExpression(1, name, VirtKeyCode.s())
            If GetKeyState_(#VK_NUMLOCK)=1
                OnNumLock=1
                KeybdEvent(50, #VK_NUMLOCK)
            EndIf
            If CountKodeKey=1
                If Val(VirtKeyCode(0))=35 Or Val(VirtKeyCode(0))=36 Or Val(VirtKeyCode(0))=22
                    ; перевод фокуса на страницу
                    KeybdEvent(100, 120)
                EndIf
                If Val(VirtKeyCode(0))=0
                    ; Реализация рестарта VIVALDI
                    VivaldiClipboardAddress("vivaldi://restart")
                ElseIf Val(VirtKeyCode(0))=7
                    ; Открыть DevTools для интерфейса VIVALDI 
                    Protected counter=0
                    hWndDevTool=0
                    If WndEnumEx("Chrome_WidgetWin_1", "DevTools - chrome-extension://mpognobbkildjkofajifpdfhcoklimli/browser.html", "N")<>0
                        hWndDevTool=WndEnumEx("Chrome_WidgetWin_1", "DevTools - chrome-extension://mpognobbkildjkofajifpdfhcoklimli/browser.html", "N")
                        SetForegroundWindow_(hWndDevTool)
                        SetActiveWindow_(hWndDevTool)
                    Else
                        OpenURLinVivaldiForegroundWindow("chrome-extension://mpognobbkildjkofajifpdfhcoklimli/browser.html")
                        counter=0
                        Repeat 
                            If WndEnumEx("Chrome_WidgetWin_1", "Vivaldi - Vivaldi", "Y")=0
                                counter=counter+1
                                Delay(5)
                            Else 
                                counter=0
                                Delay(300)
                                KeybdEvent(10, 123)
                                KeybdEvent(10, 17, 87)
                                Break    
                            EndIf
                            If counter=600
                                Break
                            EndIf
                        ForEver
                    EndIf
                ElseIf Val(VirtKeyCode(0))=10
                    ; Переход на стартовую страницу VIVALDI в текущей вкладке
                    VivaldiClipboardAddress("vivaldi://startpage")
                ElseIf Val(VirtKeyCode(0))=11
                    ; Реализация кнопки запуска программ WINDOWS
                    CreateRegularExpression(2, "(?<=()\|)\S(.*?)(?=()\|)")
                    CountCommandLineParameters=ExtractRegularExpression(2, name, CommandLineParameters())
                    If CountCommandLineParameters=1
                        LaunchingExternalProgram(Chr(34)+CommandLineParameters(0)+Chr(34), "")
                    ElseIf  CountCommandLineParameters>1 
                        LaunchingExternalProgram(Chr(34)+CommandLineParameters(0)+Chr(34), Chr(34)+CommandLineParameters(1)+Chr(34))   
                    EndIf
                    FreeRegularExpression(2)
                ElseIf Val(VirtKeyCode(0))=14
                    ; Открытие страницы, по заданному адресу, в текущей вкладке
                    ClipboardText=GetClipboardText()
                    CreateRegularExpression(2, "(?<=()\|)\S(.*?)(?=()\|)")
                    ExtractRegularExpression(2, name, PageAddress())
                    Delay(100)
                    VivaldiClipboardAddress(PageAddress(0))
                    FreeRegularExpression(2)
                ElseIf Val(VirtKeyCode(0))=15
                    ; Открытие страницы, по заданному адресу, в новой вкладке
                    CreateRegularExpression(2, "(?<=()\|)\S(.*?)(?=()\|)")
                    ExtractRegularExpression(2, name, PageAddress())
                    OpenURLinVivaldiForegroundWindow(PageAddress(0))
                    FreeRegularExpression(2)
                ElseIf Val(VirtKeyCode(0))=22
                    ; включение/выключение автоскрытия панели задач
                    TrayWndAutoHide(1)
                Else
                    ; стандартные кнопки
                    KeybdEvent(50, Val(VirtKeyCode(k)))
                EndIf
            Else    
                For k = 0 To CountKodeKey-1
                    keybd_event_(Val(VirtKeyCode(k)), 0, 0, 0)
                Next
                Delay(100)
                For k=CountKodeKey-1 To 0 Step -1
                    keybd_event_(Val(VirtKeyCode(k)), 0, #KEYEVENTF_KEYUP, 0)
                Next
            EndIf
            If OnNumLock=1
                KeybdEvent(50, #VK_NUMLOCK)
            EndIf
        Else
            FreeRegularExpression(1)
            ChangeProcessPriorityVivaldi_Run(#BELOW_NORMAL_PRIORITY_CLASS)
            ChangeProcessPriorityVivaldi(#NORMAL_PRIORITY_CLASS)
            
            ProcedureReturn 0   
        EndIf   
    Else
        ChangeProcessPriorityVivaldi_Run(#BELOW_NORMAL_PRIORITY_CLASS)
        ChangeProcessPriorityVivaldi(#NORMAL_PRIORITY_CLASS)
        ProcedureReturn 0
    EndIf
    GetWindowText_(hWnd, @name2, 256)
    If name=name2
        SetWindowText_(hWnd,"  - Vivaldi")
    EndIf    
    FreeRegularExpression(1)
    ChangeProcessPriorityVivaldi_Run(#BELOW_NORMAL_PRIORITY_CLASS)
    ChangeProcessPriorityVivaldi(#NORMAL_PRIORITY_CLASS)
    ProcedureReturn 1 
EndProcedure

; Процедура ожидания кодов клавиш
Procedure VivaldiKodeKeyWait()
    Protected counter, count, hWnd=0, hWnd_New=0
    hWnd=VivaldiWndEnumWait()
    Repeat 
        counter=0
        Repeat
            counter=counter+1
            count=0
            Repeat
                count=count+1   
                ; ищем и окно VIVALDI  с кодом клавиш и получаем коды
                If VivaldiKodeKey("Chrome_WidgetWin_1", "\A(VIVALDI_EMULATE_KEYPRESS)\s", "(?<=()"+Chr(34)+")\S(.*?)(?=()"+Chr(34)+")")=1
                    Delay(500)
                Else
                    Delay(30)
                EndIf
            Until count=20
            ; Возвращаем панель задач в исходное состояние, при изменении состояния окна VIVALDI
            Sleep_(0)
            If IsWindow_(hWnd)=0 
                TrayWndAutoHide(0)
                Break
            EndIf  
            Sleep_(0)
            If TrigerAutoHide=1 And (IsZoomed_(hWnd)=0 Or GetForegroundWindow_()<>hWnd)    
                TrayWndAutoHide(0)
            EndIf
            Sleep_(0)
            If GetForegroundWindow_()<>hWnd
                hWnd_New=WndEnumEx("Chrome_WidgetWin_1", "\s-\sVivaldi\Z", "Y")
                If hWnd_New<>0
                    hWnd=hWnd_New
                    hWnd_New=0
                EndIf
            EndIf
            Sleep_(30)
        ForEver
        ; ищем/ожидаем окно VIVALDI
        hWnd=VivaldiWndEnumWait()
    ForEver
EndProcedure


; ///////////////////////// Основной алгоритм //////////////////////////////////

; Запускаем VIVALDI
RunVIVALDI()

; Нормальное функционирование
VivaldiKodeKeyWait()




; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 723
; FirstLine = 83
; Folding = AAA9
; EnableXP
; CompileSourceDirectory