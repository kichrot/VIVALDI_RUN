

; ////////////////// Процедуры и функции ////////////////////////////

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
            Strings= Strings+" "+String
        Wend
        CloseFile(OpFile)
        ProcedureReturn Strings
    Else
        MessageRequester("", "Не удалось открыть файл "+File)
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

; Процедура запуска VIVALDI
Procedure RunVIVALDI()
    Protected Command_Line.s ; переменная для хранения коммандной строки VIVALDI
    Command_Line = ""
    
    ; Проверяем наличие файла VIVALDI_COMMAND_LINE.txt
    If FileSize("VIVALDI_COMMAND_LINE.txt")=-1 
        CreateFile(0, "VIVALDI_COMMAND_LINE.txt")
        CloseFile(#PB_All)
    Else
        Command_Line = LoadFromFile("VIVALDI_COMMAND_LINE.txt")
    EndIf
    
    ; Проверяем наличие файла vivaldi.exe и запускаем VIVALDI
    If FileSize("vivaldi.exe")=-1 
        MessageRequester("Vivaldi_Run", "File vivaldi.exe not found! / Файл vivaldi.exe не найден!", #MB_OK|#MB_ICONERROR)
        End
    Else
        RunProgram("vivaldi.exe", Command_Line,"") 
    EndIf
    
    ;Запрет/проверка на запуск Vivaldi_Run.exe более одного раза
    CheckRun("Vivaldi_Run.exe")
    
    ; меняем приоритет своего процесса
    ChangeProcessPriority(#BELOW_NORMAL_PRIORITY_CLASS)
    
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
    ; 2) при WndForeground="N", при соблюдении условий Class и TextTitleRegExp - 1, при не соблюдении условий возвращает - 0
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
                            return_proc=return_proc+1
                        EndIf
                    EndIf
                EndIf
            Else
                Flag=0 
            EndIf
        Until hWnd=0
        FreeRegularExpression(0)
        If return_proc>0
            ProcedureReturn #True  
        Else
            ProcedureReturn #False  
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
            Delay(10)
        Else 
            Break    
        EndIf
        If counter=6000
            End ; завершаем Vivaldi_Run
        EndIf
    ForEver
EndProcedure

; Процедура перехода на страницу по адресу из буфера обмена
Procedure VivaldiClipboardAddress(Address.s)
    Protected ClipboardText.s
    ClipboardText=GetClipboardText()
    SetClipboardText(Address)
    keybd_event_(119 , 0, 0, 0)
    Delay(70)
    keybd_event_(119 , 0, #KEYEVENTF_KEYUP, 0)
    Delay(70)
    keybd_event_(46 , 0, 0, 0)
    Delay(70)
    keybd_event_(46 , 0, #KEYEVENTF_KEYUP, 0)
    Delay(70)
    keybd_event_(17 , 0, 0, 0)
    keybd_event_(16 , 0, 0, 0)
    keybd_event_(86 , 0, 0, 0)
    Delay(70)
    keybd_event_(86 , 0, #KEYEVENTF_KEYUP, 0)
    keybd_event_(16 , 0, #KEYEVENTF_KEYUP, 0)
    keybd_event_(17 , 0, #KEYEVENTF_KEYUP, 0)
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
    Protected hWnd, name.s = Space(256), CountKodeKey, ClipboardText.s,  OnNumLock=0
    Protected Dim VirtKeyCode.s(0) 
    hWnd = WndEnumEx(Class, TextTitleRegExp, "Y")
    If hWnd>0
        ChangeProcessPriority(#HIGH_PRIORITY_CLASS)
        CreateRegularExpression(1, VirtKeyRegExp)
        GetWindowText_(hWnd, @name, 256)
        If MatchRegularExpression(1, name)
            CountKodeKey = ExtractRegularExpression(1, name, VirtKeyCode.s())
            If GetKeyState_(#VK_NUMLOCK)=1
                OnNumLock=1
                keybd_event_(#VK_NUMLOCK, 0, 0, 0 );
                Delay(50)
                keybd_event_(#VK_NUMLOCK, 0, #KEYEVENTF_KEYUP, 0); 
            EndIf
            If CountKodeKey=1 And Val(VirtKeyCode(0))=0
                ; Реализация рестарта VIVALDI
                VivaldiClipboardAddress("vivaldi://restart")
            ElseIf CountKodeKey=1 And Val(VirtKeyCode(0))=7
                ; Открыть DevTools для интерфейса VIVALDI 
                ClipboardText=GetClipboardText()
                SetClipboardText("chrome-extension://mpognobbkildjkofajifpdfhcoklimli/browser.html")
                keybd_event_(17 , 0, 0, 0)
                keybd_event_(84 , 0, 0, 0)
                Delay(70)
                keybd_event_(84 , 0, #KEYEVENTF_KEYUP, 0)
                keybd_event_(17 , 0, #KEYEVENTF_KEYUP, 0)
                Repeat
                    If WndEnumEx("Chrome_WidgetWin_1", "Vivaldi - Vivaldi", "Y")>0
                        Break
                    EndIf 
                   Delay(0) 
                ForEver
                Delay(1500)
                keybd_event_(17 , 0, 0, 0)
                keybd_event_(16 , 0, 0, 0)
                keybd_event_(86 , 0, 0, 0)
                Delay(70)
                keybd_event_(86 , 0, #KEYEVENTF_KEYUP, 0)
                keybd_event_(16 , 0, #KEYEVENTF_KEYUP, 0)
                keybd_event_(17 , 0, #KEYEVENTF_KEYUP, 0)
                keybd_event_(123 , 0, 0, 0)
                Delay(70)
                keybd_event_(123 , 0, #KEYEVENTF_KEYUP, 0)
                keybd_event_(17 , 0, 0, 0)
                keybd_event_(87 , 0, 0, 0)
                Delay(70)
                keybd_event_(87 , 0, #KEYEVENTF_KEYUP, 0)
                keybd_event_(17 , 0, #KEYEVENTF_KEYUP, 0)
                SetClipboardText(ClipboardText)
                ClipboardText=""
            ElseIf CountKodeKey=1 And Val(VirtKeyCode(0))=10
                ; Переход на стартовую страницу VIVALDI в текущей вкладке
                VivaldiClipboardAddress("vivaldi://startpage")
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
            ProcedureReturn 0   
        EndIf   
    Else
        ProcedureReturn 0
    EndIf
    SetWindowText_(hWnd," - Vivaldi")
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
            VivaldiKodeKey("Chrome_WidgetWin_1", "\A(VIVALDI_EMULATE_KEYPRESS)\s", "(?<=()"+Chr(34)+")\S(.*?)(?=()"+Chr(34)+")")
            Delay(30)
        Until counter=300
        ; ищем/ожидаем окно VIVALDI
        VivaldiWndEnumWait()
    ForEver
EndProcedure

; ///////////////////////// Основной алгоритм //////////////////////////////////

; Запускаем VIVALDI
RunVIVALDI()

; Нормальное функционирование
VivaldiKodeKeyWait()
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 152
; FirstLine = 18
; Folding = g8
; EnableXP
; CompileSourceDirectory