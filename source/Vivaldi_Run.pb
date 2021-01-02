; * Утилита для браузера VIVALDI / Vivaldi browser utility
; * автор / author: kichrot
; * https://forum.vivaldi.net/topic/43971/vivaldi_run-utility-windows-only
; * 2020 year 

; ////////////////// Процедуры и функции ////////////////////////////

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

; Процедура запрета повторного запуска VIVALDI
Procedure CheckRun(FileName.s) 
    *a = CreateSemaphore_(0, 0, 1, FileName)
    If *a <> 0 And GetLastError_()= #ERROR_ALREADY_EXISTS
        CloseHandle_(*a)
        End
    EndIf
EndProcedure

; Процедура изменения приоритета собственного процесса программы Vivaldi_Run
Procedure ChangeProcessPriority(Priority) 
    ; меняем приоритет своего процесса
    SetThreadPriority_( GetCurrentThread_() , #THREAD_BASE_PRIORITY_MAX)
    SetPriorityClass_(  GetCurrentProcess_(), Priority)
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
                            keybd_event_(18 , 0, 0, 0)
                            SetForegroundWindow_(hWnd)
                            Delay(70)
                            keybd_event_(18 , 0, #KEYEVENTF_KEYUP, 0)
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
Procedure RunVIVALDI(Command_Line_P.s)
    Protected Command_Line.s="", CountParam, Command_Line_Vivaldi_Run.s="",  CountParamVivaldi_Run
    Protected Dim ParamVivaldi_Run.s(0)
    
    If Command_Line_P=""
        ; меняем приоритет своего процесса
        ChangeProcessPriority(#HIGH_PRIORITY_CLASS)
        
        ; изменяем рабочий каталог на каталог расположения файла Vivaldi_Run.exe
        SetCurrentDirectory(GetPathPart(ProgramFilename())) 
    EndIf
    
    ; Получаем параметры командной строки для файла Vivaldi_Run.exe
    Command_Line_Vivaldi_Run=Trim(Mid(PeekS(GetCommandLine_()), Len(ProgramFilename())+3))
    
    ; Проверяем наличие файла VIVALDI_COMMAND_LINE.txt
    If FileSize("VIVALDI_COMMAND_LINE.txt")=-1 
        CreateFile(0, "VIVALDI_COMMAND_LINE.txt")
        CloseFile(#PB_All)
    Else
        Command_Line = LoadFromFile("VIVALDI_COMMAND_LINE.txt")
    EndIf
    
    ; Проверяем наличие файла vivaldi.exe и запускаем VIVALDI
    If FileSize("vivaldi.exe")=-1 
        MessageRequester("Vivaldi_Run", "File vivaldi.exe not found!", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
        End
    Else
        Command_Line=Command_Line_P+" "+Command_Line_Vivaldi_Run+" "+Command_Line
        
        ; Проверяем наличие в параметрах коммандной строки параметра мини режима --only-start-with-VIVALDI_COMMAND_LINE.txt
        CreateRegularExpression(3, "--only-start-with-VIVALDI_COMMAND_LINE.txt")
        CountParamVivaldi_Run=ExtractRegularExpression(3, Command_Line, ParamVivaldi_Run())
        Command_Line = ReplaceRegularExpression(3, Command_Line, " ") ; удаляем параметр --only-start-with-VIVALDI_COMMAND_LINE.txt
        FreeRegularExpression(3)
        If CountParamVivaldi_Run>0
            LaunchingExternalProgram(Chr(34)+GetCurrentDirectory()+"vivaldi.exe"+Chr(34), Command_Line)
            End
        EndIf   
        
        If Command_Line_P=""
            LaunchingExternalProgram(Chr(34)+GetCurrentDirectory()+"vivaldi.exe"+Chr(34), Command_Line)
        Else
            RunProgram(Chr(34)+GetCurrentDirectory()+"vivaldi.exe"+Chr(34), Command_Line,"", #PB_Program_Open)
        EndIf    
    EndIf
    
    If Command_Line_P=""
        ;Запрет/проверка на запуск Vivaldi_Run.exe более одного раза
        CheckRun("Vivaldi_Run.exe")
        
        ; меняем приоритет своего процесса
        ChangeProcessPriority(#BELOW_NORMAL_PRIORITY_CLASS)
    EndIf
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
    FreeRegularExpression(0)
    If return_proc>0
        ProcedureReturn return_proc  
    Else
        ProcedureReturn 0  
    EndIf
EndProcedure

; Процедура проверки наличия и ожидания окон VIVALDI
Procedure VivaldiWndEnumWait()
    
    Protected counter=0
    Repeat    
        If WndEnumEx("Chrome_WidgetWin_1", "\s-\sVivaldi\Z", "N")=0
            counter=counter+1
            Delay(40)
        Else 
            Break    
        EndIf
        If counter=3000 
            ;             MessageRequester("Vivaldi_Run", "Закрытие", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
            End ; завершаем Vivaldi_Run
        EndIf
    ForEver
EndProcedure


; Процедура перехода на страницу по адресу из буфера обмена
Procedure VivaldiClipboardAddress(Address.s)
    Protected ClipboardText.s
    ClipboardText=GetClipboardText()
    SetClipboardText(Address)
    Delay(100)
    keybd_event_(17 , 0, 0, 0)
    keybd_event_(16 , 0, 0, 0)
    keybd_event_(86 , 0, 0, 0)
    Delay(70)
    keybd_event_(86 , 0, #KEYEVENTF_KEYUP, 0)
    keybd_event_(16 , 0, #KEYEVENTF_KEYUP, 0)
    keybd_event_(17 , 0, #KEYEVENTF_KEYUP, 0)
    Delay(1000)
    SetClipboardText(ClipboardText)
    ClipboardText=""
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
        ChangeProcessPriority(#HIGH_PRIORITY_CLASS)
        CreateRegularExpression(1, VirtKeyRegExp)
        GetWindowText_(hWnd, @name, 256)
        If MatchRegularExpression(1, name)
            CountKodeKey=ExtractRegularExpression(1, name, VirtKeyCode.s())
            If GetKeyState_(#VK_NUMLOCK)=1
                OnNumLock=1
                keybd_event_(#VK_NUMLOCK, 0, 0, 0 );
                Delay(50)
                keybd_event_(#VK_NUMLOCK, 0, #KEYEVENTF_KEYUP, 0); 
            EndIf
            If CountKodeKey=1 And (Val(VirtKeyCode(0))=35 Or Val(VirtKeyCode(0))=36)
                ; перевод фокуса на страницу
                keybd_event_(120, 0, 0, 0 );
                Delay(50)
                keybd_event_(120, 0, #KEYEVENTF_KEYUP, 0);
                Delay(10)
            EndIf
            If CountKodeKey=1 And Val(VirtKeyCode(0))=0
                ; Реализация рестарта VIVALDI
                VivaldiClipboardAddress("vivaldi://restart")
            ElseIf CountKodeKey=1 And Val(VirtKeyCode(0))=7
                ; Открыть DevTools для интерфейса VIVALDI 
                Protected counter=0
                hWndDevTool=0
                If WndEnumEx("Chrome_WidgetWin_1", "DevTools - chrome-extension://mpognobbkildjkofajifpdfhcoklimli/browser.html", "N")<>0
                    hWndDevTool=WndEnumEx("Chrome_WidgetWin_1", "DevTools - chrome-extension://mpognobbkildjkofajifpdfhcoklimli/browser.html", "N")
                    SetForegroundWindow_(hWndDevTool)
                    SetActiveWindow_(hWndDevTool)
                Else
                    RunVIVALDI("chrome-extension://mpognobbkildjkofajifpdfhcoklimli/browser.html")
                    Repeat 
                        If WndEnumEx("Chrome_WidgetWin_1", "Vivaldi - Vivaldi", "Y")=0
                            counter=counter+1
                            Delay(5)
                        Else 
                            counter=0
                            Delay(100)
                            keybd_event_(123 , 0, 0, 0)
                            Delay(10)
                            keybd_event_(123 , 0, #KEYEVENTF_KEYUP, 0)
                            Repeat 
                                If WndEnumEx("Chrome_WidgetWin_1", "DevTools - chrome-extension://mpognobbkildjkofajifpdfhcoklimli/browser.html", "Y")=0
                                    counter=counter+1
                                    Delay(5)
                                Else
                                    keybd_event_(18 , 0, 0, 0)
                                    SetForegroundWindow_(hWnd)
                                    keybd_event_(18 , 0, #KEYEVENTF_KEYUP, 0)
                                    SetActiveWindow_(hWnd)
                                    keybd_event_(123 , 0, 0, 0)
                                    Delay(10)
                                    keybd_event_(123 , 0, #KEYEVENTF_KEYUP, 0)
                                    keybd_event_(17 , 0, 0, 0)
                                    keybd_event_(87 , 0, 0, 0)
                                    Delay(10)
                                    keybd_event_(87 , 0, #KEYEVENTF_KEYUP, 0)
                                    keybd_event_(17 , 0, #KEYEVENTF_KEYUP, 0)
                                    Delay(50)
                                    keybd_event_(17 , 0, 0, 0)
                                    keybd_event_(87 , 0, 0, 0)
                                    Delay(10)
                                    keybd_event_(87 , 0, #KEYEVENTF_KEYUP, 0)
                                    keybd_event_(17 , 0, #KEYEVENTF_KEYUP, 0)
                                    Break    
                                EndIf
                                If counter=3000
                                    MessageRequester("Vivaldi_Run", "Failed to open the DevTools", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
                                    Break
                                EndIf
                            ForEver
                            Break    
                        EndIf
                        If counter=5000
                            Break
                        EndIf
                    ForEver
                    
                EndIf
            ElseIf CountKodeKey=1 And Val(VirtKeyCode(0))=10
                ; Переход на стартовую страницу VIVALDI в текущей вкладке
                VivaldiClipboardAddress("vivaldi://startpage")
            ElseIf CountKodeKey=1 And Val(VirtKeyCode(0))=11
                ; Реализация кнопки запуска программ WINDOWS
                CreateRegularExpression(2, "(?<=()\|)\S(.*?)(?=()\|)")
                CountCommandLineParameters=ExtractRegularExpression(2, name, CommandLineParameters())
                If CountCommandLineParameters=1
                    LaunchingExternalProgram(Chr(34)+CommandLineParameters(0)+Chr(34), "")
                ElseIf  CountCommandLineParameters>1 
                    LaunchingExternalProgram(Chr(34)+CommandLineParameters(0)+Chr(34), Chr(34)+CommandLineParameters(1)+Chr(34))   
                EndIf
                FreeRegularExpression(2)
            ElseIf CountKodeKey=1 And Val(VirtKeyCode(0))=14
                ; Открытие страницы, по заданному адресу, в текущей вкладке
                ClipboardText=GetClipboardText()
                CreateRegularExpression(2, "(?<=()\|)\S(.*?)(?=()\|)")
                ExtractRegularExpression(2, name, PageAddress())
                Delay(100)
                VivaldiClipboardAddress(PageAddress(0))
                FreeRegularExpression(2)
            ElseIf CountKodeKey=1 And Val(VirtKeyCode(0))=15
                ; Открытие страницы, по заданному адресу, в новой вкладке
                CreateRegularExpression(2, "(?<=()\|)\S(.*?)(?=()\|)")
                ExtractRegularExpression(2, name, PageAddress())
                RunVIVALDI(PageAddress(0))
                FreeRegularExpression(2)
            EndIf
            For k = 0 To CountKodeKey-1
                keybd_event_(Val(VirtKeyCode(k)), 0, 0, 0)
            Next
            Delay(70)
            For k=CountKodeKey-1 To 0 Step -1
                keybd_event_(Val(VirtKeyCode(k)), 0, #KEYEVENTF_KEYUP, 0)
            Next
            If OnNumLock=1
                keybd_event_(#VK_NUMLOCK, 0, 0, 0 );
                Delay(50)
                keybd_event_(#VK_NUMLOCK, 0, #KEYEVENTF_KEYUP, 0);
            EndIf
        Else
            FreeRegularExpression(1)
            ChangeProcessPriority(#BELOW_NORMAL_PRIORITY_CLASS)
            ProcedureReturn 0   
        EndIf   
    Else
        ChangeProcessPriority(#BELOW_NORMAL_PRIORITY_CLASS)
        ProcedureReturn 0
    EndIf
    GetWindowText_(hWnd, @name2, 256)
    If name=name2
        SetWindowText_(hWnd,"  - Vivaldi")
    EndIf    
    FreeRegularExpression(1)
    ChangeProcessPriority(#BELOW_NORMAL_PRIORITY_CLASS)
    ProcedureReturn 1 
EndProcedure

; Процедура ожидания кодов клавиш
Procedure VivaldiKodeKeyWait()
    Protected counter
    Repeat 
        counter=0
        Repeat
            counter=counter+1 
            ; ищем и окно VIVALDI  с кодом клавиш и получаем коды
            If VivaldiKodeKey("Chrome_WidgetWin_1", "\A(VIVALDI_EMULATE_KEYPRESS)\s", "(?<=()"+Chr(34)+")\S(.*?)(?=()"+Chr(34)+")")=1
                Delay(500)
            Else
                Delay(30)
            EndIf
        Until counter=300
        ; ищем/ожидаем окно VIVALDI
        VivaldiWndEnumWait()
    ForEver
EndProcedure


; ///////////////////////// Основной алгоритм //////////////////////////////////

; Запускаем VIVALDI
RunVIVALDI("")

; Нормальное функционирование
VivaldiKodeKeyWait()

EnableExplicit


; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 302
; FirstLine = 135
; Folding = g1
; EnableXP
; CompileSourceDirectory