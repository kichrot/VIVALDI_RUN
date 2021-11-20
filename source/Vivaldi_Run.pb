; * Утилита для браузера VIVALDI / Vivaldi browser utility
; * автор / author: kichrot
; * https://forum.vivaldi.net/topic/43971/vivaldi_run-utility-windows-only
; * 2021 year 

XIncludeFile "NQIP.pbi"


; ////////////////// Глобальные переменные и константы ////////////////////////////

; глобальная переменная с именем исполняемого файла запускаемым при закрытии VIVALDI
Global VivaldiExitRunFile.s=""

; глобальная переменная с номером сборки WINDOWS
Global WindowsAssemblyNumber=0

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

; глобальная переменная содержащая hWnd текщего активного окна VIVALDI
Global hWndActiveWndVivaldi=0

; глобальная переменная содержащая параметр ком. строки к профилю VIVALDI для активного окна
Global ParamProfileActiveWndVivaldi.s=""

; глобальный массив для хранения hWnd развернутых окон VIVALDI принадлежащих к процессу активного окна VIVALDI 
Global Dim hWndVivaldiForegroundWindowAndZoomed(0)

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

; Процедура чтения значения ключа реестра WINDOWS
Procedure.s RegRead(Root, KeyPath$, ValueName$)
	Protected Size, ValueData$, hKey, Type
	; Если раздел открыт успешно
	If #ERROR_SUCCESS = RegOpenKeyEx_(Root,KeyPath$,0,#KEY_ALL_ACCESS,@hKey)
		; Чтобы получить размер данных и тип. Размер для выделения буфера,
		; тип для определения можно ли анализировать данные соответствующими функциями
		If #ERROR_SUCCESS = RegQueryValueEx_(hKey,ValueName$,0,@Type,0,@Size)
			; Debug Str(Type)
			Select Type
				Case 1
					Debug "REG_SZ Строковый"
				Case 2
					Debug "REG_EXPAND_SZ Строковый с %Temp%"
				Case 3
					Debug "REG_BINARY Бинарный"
				Case 4
					Debug "REG_DWORD 8 байт, Double, Quad"
				Case 7
					Debug "REG_MULTI_SZ Многострочный текст "
				Default
					Debug "один из редких типов"
			EndSelect
			Debug "Длина данных: " + Str(Size) + " байт"
			ValueData$=Space(Size)
			If #ERROR_SUCCESS = RegQueryValueEx_(hKey,ValueName$,0,0,@ValueData$,@Size)
				Debug "успешно, значение параметра " + ValueName$ + ": " + ValueData$
			EndIf
		EndIf
		RegCloseKey_(hKey)
	EndIf
	ProcedureReturn ValueData$
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

; Процедура замены подстроки в строке
Procedure.s ReplacementSubstringString(String.s, RegExSubstringOld.s, SubstringNew.s)
    Protected Result.s=""
    CreateRegularExpression(10, RegExSubstringOld)
    Result = ReplaceRegularExpression(10, String, SubstringNew)
    FreeRegularExpression(10)
    ProcedureReturn Result
EndProcedure

; Процедура чтения файла (возвращает содержимое в виде строки)
Procedure.s LoadFromFile(File.s)
    Protected OpFile,StringFormat,String.s,Strings.s
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
        Strings = ReplacementSubstringString(Strings, "(<)(.*?)(>)", " ") ; удаляем комментарии
        ProcedureReturn Strings
    Else
        MessageRequester("Vivaldi_Run", "Failed to open the file: "+File, #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
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
    GetWindowThreadProcessId_(hWndActiveWndVivaldi, @ThreadProcessId)
    SetThreadPriority_(ThreadProcessId , #THREAD_BASE_PRIORITY_MAX)
    HandleProcess=OpenProcess_(#PROCESS_DUP_HANDLE | #PROCESS_SET_INFORMATION, #True, ThreadProcessId)
    SetPriorityClass_(HandleProcess, Priority)
    CloseHandle_(HandleProcess)
EndProcedure

; Процедура поиска окон
Procedure WndEnumEx(Class.s, TextTitleRegExp.s, WndForeground.s) 
    ; Проверяет существование окон по классу и имени окна в формате рег. выражений
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
            name.s = Space(2048)
            GetWindowText_(hWnd, @name, 2048)
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
                        name.s = Space(2048)
                        GetWindowText_(hWnd, @name, 2048)
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

; Процедура повторного вызова для EnumWindows_ в процедуре CheckingForTwoVivaldiWindowsInOneProcess(hWnd)
Procedure.l EnumProcedure(hWnd, PID)
    ; ищем  hWnd развернутых окон VIVALDI принадлежащих к процессу активного окна VIVALDI
    ; и помещаем их в глобальный массив hWndVivaldiForegroundWindowAndZoomed()
    Protected ProcessId=0 
    GetWindowThreadProcessId_(hWnd, @ProcessId) 
    If ProcessId=PID And hWnd<>hWndActiveWndVivaldi  And IsZoomed_(hWnd)<>0
        ReDim hWndVivaldiForegroundWindowAndZoomed(ArraySize(hWndVivaldiForegroundWindowAndZoomed())+1)
        hWndVivaldiForegroundWindowAndZoomed(ArraySize(hWndVivaldiForegroundWindowAndZoomed())-1)=hWnd
    EndIf 
    ProcedureReturn 1  
EndProcedure 

; Процедура проверки на другие окна VIVALDI в одном процессе с активным окном (т.е. запущеных с одним пользовательским профилем)
Procedure CheckingForOthersVivaldiWindowsInOneProcess()
    Protected ProcessId=0
    hWndVivaldiForegroundWindowAndZoomed(0)=0
    ReDim hWndVivaldiForegroundWindowAndZoomed(0)
    GetWindowThreadProcessId_(hWndActiveWndVivaldi, @ProcessId)  
    EnumWindows_(@EnumProcedure(), ProcessId)
EndProcedure 

; Процедура определения значения глобальной переменной AutoHideTrayWnd
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
    Protected TaskBar=0, count=0, hWnd=0
    If GetForegroundWindow_()=hWndActiveWndVivaldi
        hWnd=hWndActiveWndVivaldi
    Else
        hWndActiveWndVivaldi=GetForegroundWindow_()
        hWnd=hWndActiveWndVivaldi
    EndIf
    ChangeProcessPriorityVivaldi_Run(#HIGH_PRIORITY_CLASS)
    CheckingForOthersVivaldiWindowsInOneProcess()
    If hWndVivaldiForegroundWindowAndZoomed(0)<>0
        Repeat            
            ShowWindow_(hWndVivaldiForegroundWindowAndZoomed(count), #SW_SHOWMINNOACTIVE)
            count=count+1
        Until count>(ArraySize(hWndVivaldiForegroundWindowAndZoomed())-1)
    EndIf 
    TaskBar=FindWindow_("Shell_TrayWnd", 0)
    #ABM_SETSTATE = 10
    aBdata.AppBarData
    aBdata\hwnd = TaskBar
    aBdata\cbsize = SizeOf(AppBarData)
    If AutoHide=1
        If SHAppBarMessage_(#ABM_GETSTATE, @aBdata)=#ABS_AUTOHIDE
            aBdata\lparam = #ABS_ALWAYSONTOP
            SHAppBarMessage_(#ABM_SETSTATE, @aBdata)
            SetActiveWindow_(hWnd)
            If AutoHideTrayWnd=0
                TrigerAutoHide=0
            Else
                TrigerAutoHide=1
            EndIf   
        Else
            ShowWindow_(hWnd, #SW_MAXIMIZE)
            ShowWindow_(TaskBar, SW_HIDE)
            Delay(200)
            aBdata\lparam = #ABS_AUTOHIDE
            SHAppBarMessage_(#ABM_SETSTATE, @aBdata)
            ShowWindow_(TaskBar, SW_SHOW)
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
        SetActiveWindow_(hWnd)
        TrigerAutoHide=0
    EndIf
    If hWndVivaldiForegroundWindowAndZoomed(0)<>0
        count=0
        Repeat 
            ShowWindow_(hWndVivaldiForegroundWindowAndZoomed(count), #SW_SHOWNOACTIVATE)
            SetWindowPos_(hWndVivaldiForegroundWindowAndZoomed(count), hWnd, 0, 0, 0, 0, #SWP_NOACTIVATE)
            SetWindowPos_(hWnd, HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE | #SWP_NOSIZE)
            BringWindowToTop_(hWnd)
            SetActiveWindow_(hWnd)
            SetFocus_(hWnd)
            count=count+1
        Until count>(ArraySize(hWndVivaldiForegroundWindowAndZoomed())-1)
        count=0
    EndIf
    SetActiveWindow_(hWnd)
    hWndVivaldiForegroundWindowAndZoomed(0)=0
    ReDim hWndVivaldiForegroundWindowAndZoomed(0)
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
    
    ; вариант не работающий в WINDOWS 11
;     If GetWindowLong_(hWnd, #GWL_STYLE) & #WS_MINIMIZE 
;         ShowWindow_(hWnd, #SW_MAXIMIZE) 
;         UpdateWindow_(hWnd) 
;     EndIf 
;     foregroundThreadID = GetWindowThreadProcessId_(GetForegroundWindow_(), 0) 
;     ourThreadID = GetCurrentThreadId_() 
;     If (foregroundThreadID <> ourThreadID) 
;         AttachThreadInput_(foregroundThreadID, ourThreadID, #True); 
;     EndIf 
;     SetForegroundWindow_(hWnd) 
;     If (foregroundThreadID <> ourThreadID) 
;         AttachThreadInput_(foregroundThreadID, ourThreadID, #False) 
;     EndIf   
;     InvalidateRect_(hWnd, #Null, #True)
    
    ; вариант работающий в WINDOWS 11
    keybd_event_(18 , 0, 0, 0)
    SetForegroundWindow_(hWnd)
    Delay(70)
    keybd_event_(18 , 0, #KEYEVENTF_KEYUP, 0)
EndProcedure  

; Процедура открытия(запуска) внешнего файла или папки, с возможностью принудительного вывода окна на передний план
Procedure LaunchingExternalProgram(ProgramName.s, Command_Line.s, Foreground.s="")
    Protected RunProgramPID, hWnd=0, pid, Flag=0, Program, hWndForeground, hWndProg=0, Count=0, CountLnk=0, CountForeground=1000
    Protected Dim Lnk.s(0)
    
    ; Проверяем на запуск ярлыка через имя файла программы
    CreateRegularExpression(2, "^"+Chr(34)+"(.*?)\.lnk"+Chr(34)+"$")
    CountLnk=ExtractRegularExpression(2, ProgramName, Lnk())
    FreeRegularExpression(2)
    If CountLnk>0
        Lnk(0) = ReplacementSubstringString(Lnk(0), Chr(34), "")
        If FileSize(Lnk(0))=-1 
            MessageRequester("Vivaldi_Run", "Shortcut file "+Lnk(0)+" not found!", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
        Else
            Program=RunProgram("explorer.exe", ProgramName,"", #PB_Program_Open)
            CountForeground=200
        EndIf
    Else 
        ; Проверяем на запуск ярлыка через параметры коммандной строки
        CreateRegularExpression(2, "^"+Chr(34)+"(.*?)\.lnk"+Chr(34)+"$")
        CountLnk=ExtractRegularExpression(2, Command_Line, Lnk())
        FreeRegularExpression(2)
        If CountLnk>0
            Lnk(0) = ReplacementSubstringString(Lnk(0), Chr(34), "")
            If FileSize(Lnk(0))=-1 
                MessageRequester("Vivaldi_Run", "Shortcut file "+Lnk(0)+" not found!", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
            Else
                Program=RunProgram(ProgramName, Command_Line,"", #PB_Program_Open)
                CountForeground=200
            EndIf
        Else
            Program=RunProgram(ProgramName, Command_Line,"", #PB_Program_Open)   
        EndIf   
    EndIf            
    If Program=0
        MessageRequester("Vivaldi_Run", "Failed to open the file: "+ProgramName, #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
    Else
        RunProgramPID=ProgramID(Program)
        CloseProgram(Program)
        If Foreground="N" Or Foreground="n"
            ; не выводим окно принудительно на передний фронт
        Else
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
                If hWndProg=1
                    Break
                EndIf
            Until Count=CountForeground
        EndIf
    EndIf
    
EndProcedure

; Процедура удаления параметра коммандной строки Vivaldi_Run из командной строки VIVALDI
Procedure.s DelParametrVivaldi_Run(Parametr.s, Command_Line.s)
    Protected CommandLine.s=""
    CommandLine = ReplacementSubstringString(Command_Line, Parametr, " ")
    ProcedureReturn CommandLine
EndProcedure

; Процедура запуска VIVALDI
Procedure RunVIVALDI()
    Protected Command_Line.s="", Command_Line_Vivaldi_Run.s=""
    Protected ParametrRFCLP.s="", ParametrREBSV.s="", ParametrREBEV.s="", ParametrOSWVCL.s="", Program=0
    Protected Dim ParamVivaldi_Run.s(0)
    Protected Dim FileNameCommandLineVivaldi.s(0)
    Protected Dim ProgramTo.s(0)
    
    ; определяем номер сборки WINDOWS и заносим в глобальную переменную WindowsAssemblyNumber
    WindowsAssemblyNumber= Val(RegRead(#HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentBuildNumber"))
    
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
    
    ; реализация фильтра по адресам из командной строки
    ; Проверяем наличие и размер файла BLACK_LIST_URL.txt
    If FileSize("BLACK_LIST_URL.txt") < 0 
        CreateFile(0, "BLACK_LIST_URL.txt")
        CloseFile(#PB_All)
    Else
        If Command_Line_Vivaldi_Run<>""
            ReadFile(1,"BLACK_LIST_URL.txt") ; Открываем файл
            Size=Lof(1)                      ; Узнаём размер файла 
            CloseFile(1)                     ; Закрываем файл
            If Size > 0
                Protected OpFile,StringFormat, i
                ; Создаем и заполняем массив BLACK_LIST_URL
                Protected Dim BLACK_LIST_URL.s(0)
                If OpenFile(OpFile, "BLACK_LIST_URL.txt")   
                    While Eof(OpFile) = 0 ; пока не прочли весь файл
                        StringFormat = ReadStringFormat(OpFile)
                        If StringFormat = #PB_Ascii
                            BLACK_LIST_URL.s(i) =  Trim(ReadString(OpFile,#PB_Ascii))  ; читает строки как ASCII построчно
                        ElseIf StringFormat = #PB_UTF8
                            BLACK_LIST_URL.s(i) =  Trim(ReadString(OpFile,#PB_UTF8))  ; читает строки как UTF8 построчно
                        ElseIf StringFormat = #PB_Unicode
                            BLACK_LIST_URL.s(i) =  Trim(ReadString(OpFile,#PB_Unicode))  ; читает строки как UTF16 построчно
                        EndIf
                        i=i+1
                        ReDim BLACK_LIST_URL.s(i)
                    Wend
                    CloseFile(OpFile)
                EndIf 
                ; ищем черные URL  командной строке и если находим то закрываем Vivaldi_Run
                i=0
                Repeat  
                    If  i>ArraySize(BLACK_LIST_URL()) 
                        Break 
                    EndIf 
                    If  FindString(Command_Line_Vivaldi_Run, BLACK_LIST_URL(i))>0 And BLACK_LIST_URL(i)<>""
                        End  
                    EndIf
                    i=i+1
                ForEver
                BLACK_LIST_URL.s(0)=""
                ReDim BLACK_LIST_URL.s(0)
            EndIf    
        EndIf   
    EndIf
    
    
    ; ищем вкомандной строке Vivaldi_Run параметр --RFCLP
    ; параметр указывающий имя файла с параметрами запуска VIVALDI вместо стандартного VIVALDI_COMMAND_LINE.txt
    ParametrRFCLP=CheckParametr(Command_Line_Vivaldi_Run, "--RFCLP=(["+Chr(34)+"])(\\?.)*?\1")
    If ParametrRFCLP<>""
        CreateRegularExpression(3, "(?<=()\"+Chr(34)+")\S(.*?)(?=()\"+Chr(34)+")")
        ExtractRegularExpression(3, ParametrRFCLP, FileNameCommandLineVivaldi())
        FreeRegularExpression(3)
        
        ; удаляем параметр --RFCLP
        Command_Line = DelParametrVivaldi_Run("--RFCLP=(["+Chr(34)+"])(\\?.)*?\1", Command_Line)
                
        ; Меняем значение глобальной переменной с именем файла содержащим параметры командной строки VIVALDI
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
                
        ; проверяем наличие в параметрах коммандной строки параметра --REBSV 
        ; (--REBSV - запуск произвольного исполняемого файла перед стартом VIVALDI)
        ParametrREBSV=CheckParametr(Command_Line, "--REBSV=(["+Chr(34)+"])(\\?.)*?\1")
        If ParametrREBSV<>""
            CreateRegularExpression(4, "(?<=()\"+Chr(34)+")(.*?)(?=()\"+Chr(34)+")")
            ExtractRegularExpression(4, ParametrREBSV, ProgramTo())
            FreeRegularExpression(4)
            Program=RunProgram(ProgramTo(0),"","", #PB_Program_Open)
            If Program=0
                MessageRequester("Vivaldi_Run", "Failed to open the file: "+ProgramTo(0), #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
            EndIf
            ; удаляем параметр --REBSV
            Command_Line = DelParametrVivaldi_Run("--REBSV=(["+Chr(34)+"])(\\?.)*?\1", Command_Line)
        EndIf
        
        ; проверяем наличие в параметрах коммандной строки параметра --REBEV 
        ; (--REBEV - запуск произвольного исполняемого файла после закрытия VIVALDI)
        ParametrREBEV=CheckParametr(Command_Line, "--REBEV=(["+Chr(34)+"])(\\?.)*?\1")
        If ParametrREBEV<>""
            CreateRegularExpression(4, "(?<=()\"+Chr(34)+")(.*?)(?=()\"+Chr(34)+")")
            ExtractRegularExpression(4, ParametrREBEV, ProgramTo())
            FreeRegularExpression(4)
            VivaldiExitRunFile=ProgramTo(0)
            ; удаляем параметр --REBEV
            Command_Line = DelParametrVivaldi_Run("--REBEV=(["+Chr(34)+"])(\\?.)*?\1", Command_Line)
        EndIf
                        
        ; проверяем наличие в параметрах коммандной строки параметра мини режима  --OSWVCL
        ParametrOSWVCL=CheckParametr(Command_Line, "--OSWVCL")
        If ParametrOSWVCL<>"" ; если параметр --OSWVCL присутсттвует, то запускаем VIVALDI и прекращаем работу "Vivaldi_Run"
            ; удаляем параметр --OSWVCL из параметров командной строки VIVALDI
            Command_Line = DelParametrVivaldi_Run("--OSWVCL", Command_Line)
            ;запускаем VIVALDI
            LaunchingExternalProgram(Chr(34)+GetCurrentDirectory()+"vivaldi.exe"+Chr(34), Command_Line, "Y")
            End ; закрываем Vivaldi_Run
        EndIf  
        
        ; запускаем VIVALDI
        RunProgram(Chr(34)+GetCurrentDirectory()+"vivaldi.exe"+Chr(34), Command_Line,"", #PB_Program_Open)
    EndIf
    
    ;запрет/проверка на запуск Vivaldi_Run.exe более одного раза
    CheckRun("Vivaldi_Run.exe")
    
    ; меняем приоритет своего процесса
    ChangeProcessPriorityVivaldi_Run(#BELOW_NORMAL_PRIORITY_CLASS)
    
EndProcedure

; Процедура проверки наличия и ожидания окон VIVALDI
Procedure VivaldiWndEnumWait()
    Protected counter=0, hWnd=0, Program=0
     
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
            If VivaldiExitRunFile<>""
                ;запуск исполняемого файла заданного в параметре командной строки --REBEV  
                Program=RunProgram(VivaldiExitRunFile,"","", #PB_Program_Open)
                If Program=0
                    MessageRequester("Vivaldi_Run", "Failed to open the file: "+VivaldiExitRunFile, #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
                EndIf
            EndIf
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
    KeybdEvent(70, 17, 76)
    KeybdEvent(70, 46)
    KeybdEvent(70, 17, 16, 86)
    Delay(100)
    SetClipboardText("")
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

; Процедура применения виртуальных кодов клавиш
Procedure KodeKey(KeyboardShortcut.s)
    ; Возвращает: 1 - если коды клавиш извлечены и эмуляция нажатий клавиш произведена.
    Protected hWndDevTool, CountKodeKey, CountCommandLineParameters, ClipboardText.s
    Protected Dim VirtKeyCode.s(0), Dim CommandLineParameters.s(0), Dim PageAddress.s(0), Dim WindowsShortcut.s(0)
    Protected Dim Foreground.s(0)
    
        CreateRegularExpression(1, "(?<=()"+Chr(34)+")\S(.*?)(?=()"+Chr(34)+")")
        If MatchRegularExpression(1, KeyboardShortcut)
            CountKodeKey=ExtractRegularExpression(1, KeyboardShortcut, VirtKeyCode.s())
                        ;проверка на наличие команды перевода фокуса на страницу "{FP}"
            CreateRegularExpression(2, "(?<=()\{)\S([FP])(?=()\})") 
            If MatchRegularExpression(2, KeyboardShortcut)
                ; перевод фокуса на страницу
                KeybdEvent(100, 120)    
            EndIf
            FreeRegularExpression(2)
            If CountKodeKey=1
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
                    ; Реализация команды запуска программ WINDOWS
                    If WindowsAssemblyNumber<22000 ; проверяем по номеру сборки WINDOWS на отсутствие WINDOWS 11
                        If TrigerAutoHide=1
                            TrayWndAutoHide(0)
                        EndIf  
                    EndIf
                    CreateRegularExpression(2, "(?<=()\|)\S(.*?)(?=()\|)")
                    CreateRegularExpression(3, "(?<=()\<)\S(.*?)(?=()\>)")
                    CountCommandLineParameters=ExtractRegularExpression(2, KeyboardShortcut, CommandLineParameters())
                    ExtractRegularExpression(3, KeyboardShortcut, Foreground())
                    FreeRegularExpression(2)
                    FreeRegularExpression(3)
                    If CountCommandLineParameters=1
                        LaunchingExternalProgram(Chr(34)+CommandLineParameters(0)+Chr(34), "", Foreground(0))
                    ElseIf  CountCommandLineParameters>1 
                        LaunchingExternalProgram(Chr(34)+CommandLineParameters(0)+Chr(34), Chr(34)+CommandLineParameters(1)+Chr(34), Foreground(0))   
                    EndIf
                    
                ElseIf Val(VirtKeyCode(0))=14
                    ; Открытие страницы, по заданному адресу, в текущей вкладке
                    ClipboardText=GetClipboardText()
                    CreateRegularExpression(2, "(?<=()\|)\S(.*?)(?=()\|)")
                    ExtractRegularExpression(2, KeyboardShortcut, PageAddress())
                    Delay(100)
                    VivaldiClipboardAddress(PageAddress(0))
                    FreeRegularExpression(2)
                ElseIf Val(VirtKeyCode(0))=15
                    ; Открытие страницы, по заданному адресу, в новой вкладке
                    CreateRegularExpression(2, "(?<=()\|)\S(.*?)(?=()\|)")
                    ExtractRegularExpression(2, KeyboardShortcut, PageAddress())
                    OpenURLinVivaldiForegroundWindow(PageAddress(0))
                    FreeRegularExpression(2)
                ElseIf Val(VirtKeyCode(0))=22
                    ; перевод фокуса на страницу
                    KeybdEvent(100, 120)    
                    ; включение/выключение автоскрытия панели задач
                    If WindowsAssemblyNumber<22000 ; проверяем по номеру сборки WINDOWS на отсутствие WINDOWS 11
                        TrayWndAutoHide(1)
                    Else
                        MessageRequester("Vivaldi_Run", "The taskbar auto-cover mode command for WINDOWS 11 is not supported.", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)    
                    EndIf    
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
        Else
            FreeRegularExpression(1)
            ProcedureReturn 0   
        EndIf   
    
    FreeRegularExpression(1)
    ProcedureReturn 1 
EndProcedure

; Процедура получения виртуальных кодов клавиш от VIVALDI
Procedure VivaldiKodeKey(Class.s, TextTitleRegExp.s)
; Проверяет существование активного окна с задаными классом и именем
    ; извлекает из имени окна коды виртуальных клавиш и эмулирует их нажатие для найденного окна 
    ; Параметры:
    ; Class - класс окна
    ; TextTitleRegExp - имя окна в формате регулярного выражения
    ; Возвращает: 1 - если окно найдено, коды клавиш извлечены и эмуляция нажатий клавиш произведена.
    Protected hWnd, name.s = Space(2048),  name2.s = Space(2048), OnNumLock=0, AdditionalCountKodeKey
    Protected Dim AdditionalVirtKeyCode.s(0) 
    hWnd = WndEnumEx(Class, TextTitleRegExp, "Y")
    If hWnd>0
        ChangeProcessPriorityVivaldi_Run(#HIGH_PRIORITY_CLASS)
        ChangeProcessPriorityVivaldi(#HIGH_PRIORITY_CLASS)
        If GetKeyState_(#VK_NUMLOCK)=1
            OnNumLock=1
            KeybdEvent(50, #VK_NUMLOCK)
        EndIf
        CreateRegularExpression(4, "(?<=()\[)(.*?)(?=()\])")
        GetWindowText_(hWnd, @name, 2048)
        If MatchRegularExpression(4, name)
            AdditionalCountKodeKey=ExtractRegularExpression(4, name, AdditionalVirtKeyCode.s())
            For z = 0 To AdditionalCountKodeKey-1
                KodeKey(AdditionalVirtKeyCode.s(z))
                Delay(50)
            Next
        Else
            KodeKey(name)    
        EndIf
    Else
        ProcedureReturn 0
    EndIf
    GetWindowText_(hWnd, @name2, 2048)
    If name=name2
        SetWindowText_(hWnd,"  - Vivaldi")
    EndIf    
    FreeRegularExpression(4)
    If OnNumLock=1
        KeybdEvent(50, #VK_NUMLOCK)
    EndIf
    ChangeProcessPriorityVivaldi_Run(#BELOW_NORMAL_PRIORITY_CLASS)
    ChangeProcessPriorityVivaldi(#NORMAL_PRIORITY_CLASS)
    ProcedureReturn 1     
EndProcedure

; Процедура ожидания кодов клавиш
Procedure VivaldiKodeKeyWait()
    Protected counter, count, hWnd=0, hWnd_New=0, hWndTaskBar=0, ProcessId_hWnd=0, ProcessId_hWnd_New=0
    hWnd=VivaldiWndEnumWait()
    hWndTaskBar=FindWindow_("Shell_TrayWnd", 0)
    Repeat 
        counter=0
        Repeat
            counter=counter+1
            count=0
            Repeat
                count=count+1   
                ; ищем и окно VIVALDI  с кодом клавиш и получаем коды
                If VivaldiKodeKey("Chrome_WidgetWin_1", "\A(VIVALDI_EMULATE_KEYPRESS)\s")=1
                    Delay(500)
                Else
                    Delay(30)
                EndIf
            Until count=20
            Sleep_(0)
            ; возвращаем панель задач в исходное состояние, при изменении состояния окна VIVALDI
            
            If WindowsAssemblyNumber<22000 ; проверяем по номеру сборки WINDOWS на отсутствие WINDOWS 11
                If IsWindow_(hWnd)=0 
                    TrayWndAutoHide(0)
                    Break
                ElseIf TrigerAutoHide=1
                    If IsZoomed_(hWnd)=0
                        TrayWndAutoHide(0)
                    ElseIf GetForegroundWindow_()<>hWnd And
                           GetForegroundWindow_()<>hWndTaskBar And
                           WndEnumEx("Chrome_WidgetWin_1", ".*", "Y")=0 And
                           WndEnumEx("#32770", ".*", "Y")=0
                        TrayWndAutoHide(0)
                    EndIf
                EndIf
            EndIf
            Sleep_(0)
            ; проверяем окно VIVALDI переднем плане
            If GetForegroundWindow_()<>hWndActiveWndVivaldi 
                hWnd_New=WndEnumEx("Chrome_WidgetWin_1", "\s-\sVivaldi\Z", "Y")
                If hWnd_New<>0
                    ; проверяем, что новое окно VIVALDI принадлежит к процессу текущего окна и не максимизировано (для некоторых окон расширений CHROME)
                    GetWindowThreadProcessId_(hWnd, @ProcessId_hWnd) 
                    GetWindowThreadProcessId_(hWnd_New, @ProcessId_hWnd_New) 
                    If ProcessId_hWnd=ProcessId_hWnd_New
                        If IsZoomed_(hWnd_New)<>0
                            hWnd=hWnd_New
                        EndIf   
                    Else
                        hWnd=hWnd_New
                    EndIf
                    hWnd_New=0 
                    ProcessId_hWnd=0
                    ProcessId_hWnd_New=0
                EndIf
            EndIf
            hWndActiveWndVivaldi=hWnd
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
; CursorPosition = 1023
; FirstLine = 113
; Folding = AAAA9
; EnableXP
; CompileSourceDirectory