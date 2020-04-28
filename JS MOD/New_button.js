/* Мод для браузера VIVALDI / Mod for the VIVALDI browser
 * Используется совместно с утилитой "Vivaldi_RUN" / Used in conjunction with the "Vivaldi_RUN" utility.
 * Репозиторий / Repository: https://github.com/kichrot/VIVALDI_RUN
 * Обсуждение / Discussion: https://forum.vivaldi.net/topic/43971/vivaldi_run-utility-windows-only
 * Назначение / Appointment:
 * Создание панели для размещения кнопок / Creating a panel for placing buttons
 * Создание новых кнопок / Create new buttons
 * Read the description of this JS mod in the User's guide for the "Vivaldi_RUN" utility version 0.1.6.0 and higher.
 * Описание данного JS-мода читать в Руководстве пользователя для утилиты "Vivaldi_RUN" версии 0.1.6.0 и выше.
 * автор / author: kichrot
 * 2020 г. / year 
 */

//////////////////////////////////////////  Неизменяемая часть / The unchanging part  //////////////////////////////////////////////////////////////////////////////////////////////////////
// The JS script code in this part does not require changes from the user.
// The user can change the code at their own risk if they understand what goals they want to achieve and how they want to achieve them.
// Код JS-скрипта в данной части не требует изменний со стороны пользователя.
// Пользователь может изменять код, на свой страх и риск, если понимает, какие цели и как желает достигнуть.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

var ModPanelcssText = '' +
    'position: absolute;' +
    'top: 37px;' +
    'left:0px;' +
    'background-color: var(--colorBg);' +
    'flex-shrink: 2;' +
    'box-shadow: 0 0 0 1px var(--colorBorder), 0 2px 6px rgba(0, 0, 0, 0.25);' +
    'border-radius: var(--radiusHalf);' +
    'display: inline-flex;' +
    'padding: 3px;' +
    'order: -1;' +
    'float: left;' +
    'zoom: 105%;' +
    'visibility: hidden;';

ModPanelHidden = function (e) {
    ModPanel.style.cssText = ModPanelcssText;
    browser.removeEventListener('mousedown', ModPanelHidden);
    browser.removeEventListener('click', ModPanelHidden);
    browser.removeEventListener('contextmenu', ModPanelHidden);
    document.querySelector("#ButtonModPanel > button > svg").style.transform = "scale(1)";
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
            var ModPanelOffsetHeight = 0 - (ModPanel.offsetHeight - ButtonModPanel.offsetHeight) - 30;
            ModPanelcssText = ModPanelcssText + ('top: ' + String(ModPanelOffsetHeight) + 'px;');
        }
        if (document.documentElement.clientWidth < (ModPanel.getBoundingClientRect().left + ModPanel.offsetWidth)) {
            var ModPanelOffsetWidth = 0 - (ModPanel.offsetWidth - ButtonModPanel.offsetWidth);
            ModPanelcssText = ModPanelcssText + ('left: ' + String(ModPanelOffsetWidth) + 'px;');
        }
        if (ModPanel.style.visibility == "hidden") {
            ModPanel.style.cssText = ModPanelcssText + 'visibility: visible;';
            document.querySelector("#ButtonModPanel > button > svg").style.transform = "scale(0.7)";
        } else {
            ModPanelHidden();
        }
    }

    function NewButton() {

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
        document.title = 'VIVALDI_EMULATE_KEYPRESS ' + KEYPRESS_NewButton; setTimeout(
            () => {
                document.title = OLD_title;
            }, 50);
        ModPanelHidden();
    }

    function NewButton() {
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
// In this part of the JS mod, the user, in accordance with the examples given, enters the code for creating new buttons that they need.
// В данной части JS-мода пользователь, в соответствии с приведенными примерами, вносит код создания новых кнопок, котрые ему нужны.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* Кнопка создания и открытия новой панели / Button for creating and opening a new panel */
// ATTENTION!!!
// This button must be a single instance.
// Adding another such button can lead to various violations in the Vivaldi browser.
// Read the rules for changing variables for this button in The User's guide to the "Vivaldi_RUN" utility.
// ВНИМАНИЕ!!!
// Данная кнопка должна быть в единственном экземпляре. 
// Добавление еще одной такой кнопки может привести к различным нарушениям в работе браузера VIVALDI.
// Правила изменения переменных данной кнопки читайте в Руководстве пользователя к утилите "Vivaldi_RUN".

var NewButtonToolbar = '.toolbar-addressbar.toolbar > .toolbar.toolbar-droptarget.toolbar-mainbar';
//var NewButtonToolbar = '.toolbar.toolbar-mainbar.toolbar-extensions.toolbar-large'; 
//var NewButtonToolbar = '.toolbar.toolbar-droptarget.toolbar-statusbar.toolbar-medium';
var NewButtonTitle = 'Panel Vivaldi_RUN';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="#0f0aee"><path transform="rotate(90 12,12) " id="svg_1" d="m12,0c-6.627,0 -12,5.373 -12,12s5.373,12 12,12s12,-5.373 12,-12s-5.373,-12 -12,-12zm-3,18l0,-12l9,6l-9,6z"/></svg>';
var NewPanelOrientation = 'horizontally';
//var NewPanelOrientation = 'vertically';
CreateNewButtonPanel(NewButtonToolbar, NewButtonTitle, NewButtonSvg, NewPanelOrientation);

///////////////////////////////////////////// Кнопки на новой панели созданной в данном JS-моде / Buttons on the new panel ///////////////////////////////////////////////////////////////////////////////////////////

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

/* Кнопка "Блокнот" / The Button "Notepad" */
var NewButton_KEYPRESS = '"11" |C:/Windows/notepad.exe| ';
var NewButtonClass = 'mod-notepad';
var NewButtonToolbar = 'div#ModPanel';
var NewButtonTitle = 'Блокнот / Notepad';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="mediumblue"><path d="M9 19h-4v-2h4v2zm2.946-4.036l3.107 3.105-4.112.931 1.005-4.036zm12.054-5.839l-7.898 7.996-3.202-3.202 7.898-7.995 3.202 3.201zm-6 8.92v3.955h-16v-20h7.362c4.156 0 2.638 6 2.638 6s2.313-.635 4.067-.133l1.952-1.976c-2.214-2.807-5.762-5.891-7.83-5.891h-10.189v24h20v-7.98l-2 2.025z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/* Кнопка "Калькулятор" / Button "Calculator" */
var NewButton_KEYPRESS = '"11" |C:/Windows/System32/calc.exe| ';
/*var NewButton_KEYPRESS = '"11" |C:/Program Files/qBittorrent/qbittorrent.exe| ';*/
var NewButtonClass = 'mod-calculator';
var NewButtonToolbar = 'div#ModPanel';
var NewButtonTitle = 'Калькулятор / Calculator';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="indigo"><path d="M3 0v24h18v-24h-18zm6 22h-4v-3h4v3zm0-4h-4v-3h4v3zm0-4h-4v-3h4v3zm5 8h-4v-3h4v3zm0-4h-4v-3h4v3zm0-4h-4v-3h4v3zm5 8h-4v-7h4v7zm0-8h-4v-3h4v3zm0-6h-14v-6h14v6zm-1-1h-12v-4h12v4z"/></svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/* Кнопка открытия "GOOGLE" в текущей вкладке / GOOGLE open button in the current tab */
var NewButton_KEYPRESS = '"14" |https://www.google.com/| ';
var NewButtonClass = 'mod-GOOGLE';
var NewButtonToolbar = 'div#ModPanel';
var NewButtonTitle = 'GOOGLE в текущей вкладке / GOOGLE in the current tab';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="24px" height="24"> <path style="fill:#FBBB00;" d="M113.47,309.408L95.648,375.94l-65.139,1.378C11.042,341.211,0,299.9,0,256 c0-42.451,10.324-82.483,28.624-117.732h0.014l57.992,10.632l25.404,57.644c-5.317,15.501-8.215,32.141-8.215,49.456 C103.821,274.792,107.225,292.797,113.47,309.408z"/> <path style="fill:#518EF8;" d="M507.527,208.176C510.467,223.662,512,239.655,512,256c0,18.328-1.927,36.206-5.598,53.451 c-12.462,58.683-45.025,109.925-90.134,146.187l-0.014-0.014l-73.044-3.727l-10.338-64.535 c29.932-17.554,53.324-45.025,65.646-77.911h-136.89V208.176h138.887L507.527,208.176L507.527,208.176z"/> <path style="fill:#28B446;" d="M416.253,455.624l0.014,0.014C372.396,490.901,316.666,512,256,512 c-97.491,0-182.252-54.491-225.491-134.681l82.961-67.91c21.619,57.698,77.278,98.771,142.53,98.771 c28.047,0,54.323-7.582,76.87-20.818L416.253,455.624z"/> <path style="fill:#F14336;" d="M419.404,58.936l-82.933,67.896c-23.335-14.586-50.919-23.012-80.471-23.012 c-66.729,0-123.429,42.957-143.965,102.724l-83.397-68.276h-0.014C71.23,56.123,157.06,0,256,0 C318.115,0,375.068,22.126,419.404,58.936z"/> </g> </svg>';
CreateNewButton(NewButton_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/* Кнопка открытия "YANDEX" в новой вкладке / Button for opening YANDEX in a new tab */
var NewButton_KEYPRESS = '"15" |https://yandex.com/| ';
var NewButtonClass = 'mod-YANDEX';
var NewButtonToolbar = 'div#ModPanel';
var NewButtonTitle = 'YANDEX в новой вкладке / YANDEX in a new tab';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32"><rect width="28" height="28" x="-31" y="-30" rx="14" ry="14" transform="matrix(0,-1,-1,0,0,0)" style="opacity:0.2"/><rect style="fill:#e4e4e4" width="28" height="28" x="-30" y="-30" rx="14" ry="14" transform="matrix(0,-1,-1,0,0,0)"/><path style="fill:#ffffff;opacity:0.2" d="M 16 2 C 8.244 2 2 8.244 2 16 C 2 16.168842 2.0195214 16.33264 2.0253906 16.5 C 2.2891326 8.9794325 8.4128418 3 16 3 C 23.587158 3 29.710867 8.9794325 29.974609 16.5 C 29.980479 16.33264 30 16.168842 30 16 C 30 8.244 23.756 2 16 2 z"/><path d="M 16,28.957273 16,17.437 M 6,7.9572725 16,17.437 26,7.9572725" style="opacity:0.2;fill:none;stroke:#000000;stroke-width:6;stroke-linecap:round;stroke-linejoin:round"/><path style="fill:none;stroke:#e34241;stroke-width:6;stroke-linecap:round;stroke-linejoin:round" d="M 16,28 16,16.48 M 6,7 16,16.48 26,7"/></svg>';
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
