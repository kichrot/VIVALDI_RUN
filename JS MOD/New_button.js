/* Мод для браузера VIVALDI / Mod for the VIVALDI browser
 * Используется совместно с утилитой "Vivaldi_RUN" / Used in conjunction with the "Vivaldi_RUN" utility.
 * Репозиторий / Repository: https://github.com/kichrot/VIVALDI_RUN
 * Обсуждение / Discussion: https://forum.vivaldi.net/topic/43971/vivaldi_run-utility-windows-only
 * Назначение / Appointment:
 * Создание панели для размещения кнопок / Creating a panel for placing buttons
 * Создание новых кнопок / Create new buttons
 * автор / author: kichrot
 * 2020 г. / 2020 year 
 */

//////////////////////////////////////////  Неизменяемая часть / The unchanging part  //////////////////////////////////////////////////////////////////////////////////////////////////////
var ModPanelcssText = '' +
                      'position: absolute;' +
                      'top: 37px;' +
                      'left:0px;' +
                      'background-color: var(--colorBg);' +
                      'flex-shrink: 2;' +
                      'box-shadow: 0 0 0 1px var(--colorBorder), 0 2px 6px rgba(0, 0, 0, 0.25);' +
                      'border-radius: var(--radiusHalf);' +
                      'display: inline-flex;' +
                      'order: -1;' +
                      'float: left;' +
                      'zoom: 105%;' +
                      'visibility: hidden;';
                      
ModPanelHidden = function(e) {
    ModPanel.style.cssText = ModPanelcssText;
    browser.removeEventListener('mousedown', ModPanelHidden);
    browser.removeEventListener('click', ModPanelHidden);
    browser.removeEventListener('contextmenu', ModPanelHidden);
    document.querySelector("#ButtonModPanel > button > svg").style.transform = "scale(1) rotate(90deg)";
};

function CreateNewButtonPanel(toolbarNewButton, titleNewButton, svgNewButton, orientationNewPanel) {
       
    function openonmouseover() {
           browser.removeEventListener('mousedown', ModPanelHidden);
           browser.removeEventListener('click', ModPanelHidden);
           browser.removeEventListener('contextmenu', ModPanelHidden);
   }
   
   function openonmouseout() {
           browser.addEventListener('mousedown', ModPanelHidden); 
           browser.addEventListener('click', ModPanelHidden);
           browser.addEventListener('contextmenu', ModPanelHidden);
   }
    
    function openClick() {
        if (document.documentElement.clientHeight < (ModPanel.getBoundingClientRect().top + ModPanel.offsetHeight)) {
           var ModPanelOffsetHeight=0-(ModPanel.offsetHeight-ButtonModPanel.offsetHeight)-30;
           ModPanelcssText=ModPanelcssText+('top: '+String(ModPanelOffsetHeight)+'px;');
        }
        if (document.documentElement.clientWidth < (ModPanel.getBoundingClientRect().left + ModPanel.offsetWidth)) {
           var ModPanelOffsetWidth=0-(ModPanel.offsetWidth-ButtonModPanel.offsetWidth);
           ModPanelcssText=ModPanelcssText+('left: '+String(ModPanelOffsetWidth)+'px;');
        }
        if (ModPanel.style.visibility == "hidden") { 
           ModPanel.style.cssText = ModPanelcssText + 'visibility: visible;'; //Показываем панель
           document.querySelector("#ButtonModPanel > button > svg").style.transform = "scale(0.7) rotate(90deg)";
       } else { 
           ModPanelHidden();
       }
   }
  
   function NewButton () {
       
       var ButtoncssText = '' +
                'display: inline-flex;' +
                'justify-content: center;' +
                'align-items: center;' +
                'background-color: var(--colorBg);' +
                'background-repeat: no-repeat;' +
                'background-position: 50% 50%;' +
                'border: 0 solid rgba(0, 0, 0, 0);' +
                'border-radius: 0;' +
                'min-width: 34px;' +
                'color: inherit;' +
                'padding: 0;' +
                'max-width: 34px;' +
                'max-height: -webkit-fill-available;' +
                'border-style: unset;' +
                'flex: 0 1 auto;' +
                'flex-grow: 0;' +
                'flex-shrink: 1;' +
                'flex-basis: auto;'; 
           
       var toolbar = document.querySelector(toolbarNewButton);
       var outer_div = document.createElement('div');
       outer_div.classList.add('button-toolbar', 'mod-ButtonPanel');
       outer_div.title = titleNewButton;
       outer_div.id = 'ButtonModPanel';
       var button = document.createElement('button');
       button.onclick = openClick;
       button.onmouseover = openonmouseover;
       button.onmouseout = openonmouseout;
       button.innerHTML = svgNewButton;
       outer_div.appendChild(button);
       outer_div.style.cssText = ButtoncssText;
       button.style.cssText = ButtoncssText;
       toolbar.appendChild(outer_div);
       var ModPanel = document.createElement('div');
       ModPanel.id = 'ModPanel';
       if (orientationNewPanel == "vertically") {
           ModPanelcssText = ModPanelcssText + 'display: table;';
       }; 
       ModPanel.style.cssText = ModPanelcssText;
       outer_div.appendChild(ModPanel);
       ModPanel.onmouseover = openonmouseover;
       ModPanel.onmouseout = openonmouseout;
   }
      
   setTimeout(function wait() {
       var toolbar = document.querySelector(toolbarNewButton);
       if (toolbar) {
           NewButton();
       } else {
           setTimeout(wait, 300);
       }
   }, 300);
}


function CreateNewButton(KEYPRESS_NewButton, classNewButton, toolbarNewButton, titleNewButton, svgNewButton) {
   
 	function openClick() {
 	    var OLD_title = document.title;
    	document.title = 'VIVALDI_EMULATE_KEYPRESS ' + KEYPRESS_NewButton;
    	setTimeout(
  				() => {
    				document.title = OLD_title;
  				}, 50);
 	    ModPanelHidden();
    }

    function NewButton () {
        ButtoncssText = '' +
                 'display: inline-flex;' +
                 'justify-content: center;' +
                 'align-items: center;' +
                 'background-color: var(--colorBg);' +
                 'background-repeat: no-repeat;' +
                 'background-position: 50% 50%;' +
                 'border: 0 solid rgba(0, 0, 0, 0);' +
                 'border-radius: 0;' +
                 'min-width: 34px;' +
                 'color: inherit;' +
                 'padding: 0;' +
                 'max-width: 34px;' +
                 'border-style: unset;';
        var toolbar = document.querySelector(toolbarNewButton);
        var outer_div = document.createElement('div');
        outer_div.classList.add('button-toolbar', classNewButton);
        outer_div.title = titleNewButton;
        var button = document.createElement('button');
        button.onclick = openClick;
        button.innerHTML = svgNewButton;
        button.style.cssText = ButtoncssText + 'height: 34px;';
        outer_div.appendChild(button);
        toolbar.appendChild(outer_div);
    }
        
    setTimeout(function wait() {
        var toolbar = document.querySelector(toolbarNewButton);
        if (toolbar) {
            NewButton();
        } else {
            setTimeout(wait, 300);
        }
    }, 300);
}

///////////////////////////////////////////// Завершение неизменяемой части /  The completion of the unchanged parts //////////////////////////////////////////////////////////////////////


///////////////////////////////////////////// Изменяемая пользователем часть / User-modifiable part ///////////////////////////////////////////////////////////////////////////////////////
 
/* Кнопка открытия новой панели / Button for opening a new panel */ 

var NewButtonToolbar = '.toolbar-addressbar.toolbar > .toolbar.toolbar-droptarget.toolbar-mainbar';
//var NewButtonToolbar = '.toolbar.toolbar-mainbar.toolbar-extensions.toolbar-large'; 
//var NewButtonToolbar = '.toolbar.toolbar-droptarget.toolbar-statusbar.toolbar-medium';
var NewButtonTitle = 'Panel Vivaldi_RUN';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="transform: scale(1) rotate(90deg);" fill="#0f0aee"><path d="M12 0c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12-12-5.373-12-12-12zm-3 18v-12l9 6-9 6z"/></svg>';
var NewPanelOrientation = 'horizontally';
//var NewPanelOrientation = 'vertically';
CreateNewButtonPanel(NewButtonToolbar, NewButtonTitle, NewButtonSvg, NewPanelOrientation);
 
///////////////////////////////////////////// Кнопки на новой панели / Buttons on the new panel ///////////////////////////////////////////////////////////////////////////////////////////

/* Кнопка "Перезагрузка VIVALDI" / Button "Restart VIVALDI" */
var NewButton_KEYPRESS = '"0"'; 
var NewButtonClass = 'mod-ReloadVIVALDI';
var NewButtonToolbar = 'div#ModPanel';
var NewButtonTitle = 'Перезагрузка VIVALDI / Restart VIVALDI';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="red"><path d="M14 12h-4v-12h4v12zm4.213-10.246l-1.213 1.599c2.984 1.732 5 4.955 5 8.647 0 5.514-4.486 10-10 10s-10-4.486-10-10c0-1.915.553-3.694 1.496-5.211l2.166 2.167 1.353-7.014-7.015 1.35 2.042 2.042c-1.287 1.904-2.042 4.193-2.042 6.666 0 6.627 5.373 12 12 12s12-5.373 12-12c0-4.349-2.322-8.143-5.787-10.246z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/* Кнопка  "DevTools для интерфейса VIVALDI" / Button "DevTools for Vivaldi interface" */
var NewButton_KEYPRESS = '"07"'; 
var NewButtonClass = 'mod-DevTools_VIVALDI';
var NewButtonToolbar = 'div#ModPanel';
var NewButtonTitle = 'DevTools для интерфейса VIVALDI / DevTools for Vivaldi interface';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="indigo"><path d="M0 0c2.799 1.2 8.683.955 8.307 6.371l-2.143 2.186c-5.338.093-5.239-5.605-6.164-8.557zm10.884 15.402c2.708 2.048 11.824 8.451 11.824 8.451.754.513 1.662-.417 1.136-1.162 0 0-6.607-8.964-8.719-11.619-1.668-2.101-2.502-2.175-5.46-3.046l-1.953 1.997c.936 2.931 1.033 3.76 3.172 5.379zm-4.877 3.332l2.62-2.626c-.26-.244-.489-.485-.69-.724l-2.637 2.643.707.707zm8.244-11.162l4.804-4.814 2.154 2.155-4.696 4.706c.438.525.813 1.021 1.246 1.584l6.241-6.253-4.949-4.95-6.721 6.733c.705.229 1.328.483 1.921.839zm4.837-3.366l-3.972 3.981c.24.199.484.423.732.681l3.946-3.956-.706-.706zm-9.701 12.554l-3.6 3.607-2.979.825.824-2.979 3.677-3.685c-.356-.583-.617-1.203-.859-1.904l-4.626 4.635-1.824 6.741 6.773-1.791 4.227-4.234c-1-.728-1.03-.749-1.613-1.215z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg); 
 
/* Кнопка Fullscreen / Button Fullscreen */
var NewButton_KEYPRESS = '"122"'; 
var NewButtonClass = 'mod-Fullscreen';
var NewButtonToolbar = 'div#ModPanel';
var NewButtonTitle = 'Fullscreen';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="brown"><path d="M24 9h-2v-5h-7v-2h9v7zm-9 13v-2h7v-5h2v7h-9zm-15-7h2v5h7v2h-9v-7zm9-13v2h-7v5h-2v-7h9zm11 4h-16v12h16v-12z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/* Кнопка настроек браузера / Browser settings button */
var NewButton_KEYPRESS = '"17" "123"'; 
var NewButtonClass = 'mod-open-settings';
var NewButtonToolbar = 'div#ModPanel';
var NewButtonTitle = 'Настройки браузера / Browser settings';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="darkblue"><path d="M24 14v-4h-3.23c-.229-1.003-.624-1.94-1.156-2.785l2.286-2.286-2.83-2.829-2.286 2.286c-.845-.532-1.781-.928-2.784-1.156v-3.23h-4v3.23c-1.003.228-1.94.625-2.785 1.157l-2.286-2.286-2.829 2.828 2.287 2.287c-.533.845-.928 1.781-1.157 2.784h-3.23v4h3.23c.229 1.003.624 1.939 1.156 2.784l-2.286 2.287 2.829 2.829 2.286-2.286c.845.531 1.782.928 2.785 1.156v3.23h4v-3.23c1.003-.228 1.939-.624 2.784-1.156l2.286 2.286 2.828-2.829-2.285-2.286c.532-.845.928-1.782 1.156-2.785h3.231zm-12 2c-2.209 0-4-1.791-4-4s1.791-4 4-4 4 1.791 4 4-1.791 4-4 4z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/* Кнопка "Блокнот" / Button "Notepad" */ 
var NewButton_KEYPRESS = '"11" |C:/Windows/notepad.exe| ';
var NewButtonClass = 'mod-notepad';
var NewButtonToolbar = 'div#ModPanel';
var NewButtonTitle = 'Блокнот / Notepad';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M9 19h-4v-2h4v2zm2.946-4.036l3.107 3.105-4.112.931 1.005-4.036zm12.054-5.839l-7.898 7.996-3.202-3.202 7.898-7.995 3.202 3.201zm-6 8.92v3.955h-16v-20h7.362c4.156 0 2.638 6 2.638 6s2.313-.635 4.067-.133l1.952-1.976c-2.214-2.807-5.762-5.891-7.83-5.891h-10.189v24h20v-7.98l-2 2.025z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/* Кнопка "Калькулятор" / Button "Calculator"*/ 
var NewButton_KEYPRESS = '"11" |C:/Windows/System32/calc1.exe| ';
var NewButtonClass = 'mod-calculator';
var NewButtonToolbar = 'div#ModPanel';
var NewButtonTitle = 'Калькулятор / Calculator';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M3 0v24h18v-24h-18zm6 22h-4v-3h4v3zm0-4h-4v-3h4v3zm0-4h-4v-3h4v3zm5 8h-4v-3h4v3zm0-4h-4v-3h4v3zm0-4h-4v-3h4v3zm5 8h-4v-7h4v7zm0-8h-4v-3h4v3zm0-6h-14v-6h14v6zm-1-1h-12v-4h12v4z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);


///////////////////////////////////////////// Кнопки на панели кнопок навигации (слева от адресной строки) / Buttons on the navigation button panel (to the left of the address bar) ///////////////////////////////////////////////////////////////////////////////////////////

/* Кнопка очистки данных браузера / Button for clearing browser data */ 
var NewButton_KEYPRESS = '"17" "16" "46"'; 
var NewButtonClass = 'mod-clear-histori';
var NewButtonToolbar = '.toolbar-addressbar.toolbar > .toolbar.toolbar-droptarget.toolbar-mainbar';
var NewButtonTitle = 'Очистка данных браузера / Clearing browser data';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="chocolate"><path d="M18.58 0c-1.234 0-2.377.616-3.056 1.649-.897 1.37-.854 3.261-1.368 4.444-.741 1.708-3.873.343-5.532-.524-2.909 5.647-5.025 8.211-6.845 10.448 6.579 4.318 1.823 1.193 12.19 7.983 2.075-3.991 4.334-7.367 6.825-10.46-1.539-1.241-4.019-3.546-2.614-4.945 1-1 2.545-1.578 3.442-2.95 1.589-2.426-.174-5.645-3.042-5.645zm-5.348 21.138l-1.201-.763c0-.656.157-1.298.422-1.874-.609.202-1.074.482-1.618 1.043l-3.355-2.231c.531-.703.934-1.55.859-2.688-.482.824-1.521 1.621-2.331 1.745l-1.302-.815c1.136-1.467 2.241-3.086 3.257-4.728l8.299 5.462c-1.099 1.614-2.197 3.363-3.03 4.849zm6.724-16.584c-.457.7-2.445 1.894-3.184 2.632-.681.68-1.014 1.561-.961 2.548.071 1.354.852 2.781 2.218 4.085-.201.265-.408.543-.618.833l-8.428-5.548.504-.883c1.065.445 2.1.678 3.032.678 1.646 0 2.908-.733 3.464-2.012.459-1.058.751-3.448 1.206-4.145 1.206-1.833 3.964-.017 2.767 1.812zm-.644-.424c-.265.41-.813.523-1.22.257-.409-.267-.522-.814-.255-1.223.267-.409.813-.524 1.222-.257.408.266.521.817.253 1.223z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/* Кнопка "Поиск на странице" / Button "Search in page"*/
var NewButton_KEYPRESS = '"114"'; 
var NewButtonClass = 'mod-search-on-page';
var NewButtonToolbar = '.toolbar-addressbar.toolbar > .toolbar.toolbar-droptarget.toolbar-mainbar';
var NewButtonTitle = 'Поиск на странице / Search on a page';
var NewButtonSvg = '<svg width="24" height="24" viewBox="0 0 24 24" fill="green" xmlns="http://www.w3.org/2000/svg" fill-rule="evenodd" clip-rule="evenodd"><path d="M17.825 24h-15.825v-24h10.189c3.162 0 9.811 7.223 9.811 9.614v10.071l-2-2v-7.228c0-4.107-6-2.457-6-2.457s1.517-6-2.638-6h-7.362v20h11.825l2 2zm-2.026-4.858c-.799.542-1.762.858-2.799.858-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5c0 1-.294 1.932-.801 2.714l4.801 4.872-1.414 1.414-4.787-4.858zm-2.799-7.142c1.656 0 3 1.344 3 3s-1.344 3-3 3-3-1.344-3-3 1.344-3 3-3z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/* Кнопка переход на Экспресс-панель / Button "go to Express panel" */
var NewButton_KEYPRESS = '"10"'; 
var NewButtonClass = 'mod-open-startpage';
var NewButtonToolbar = '.toolbar-addressbar.toolbar > .toolbar.toolbar-droptarget.toolbar-mainbar';
var NewButtonTitle = 'Перейти на Экспресс-панель / Go to Express panel';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="mediumvioletred"><path d="M20 19h-4v-4h4v4zm-6-10h-4v4h4v-4zm6 0h-4v4h4v-4zm-12 6h-4v4h4v-4zm16-14v22h-24v-22h24zm-2 6h-20v14h20v-14zm-8 8h-4v4h4v-4zm-6-6h-4v4h4v-4z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);






