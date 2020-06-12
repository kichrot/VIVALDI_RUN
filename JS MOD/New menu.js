/* Мод для браузера VIVALDI / Mod for the VIVALDI browser
 * Используется совместно с утилитой "Vivaldi_RUN" / Used in conjunction with the "Vivaldi_RUN" utility.
 * Репозиторий / Repository: https://github.com/kichrot/VIVALDI_RUN
 * Обсуждение / Discussion: https://forum.vivaldi.net/topic/43971/vivaldi_run-utility-windows-only
 * Назначение / Appointment:
 * Создание настраиваемого меню / Creating a custom menu
 * автор / author: kichrot
 * 2020 г. / 2020 year 
 */

//////////////////////////////////////////  Неизменяемая часть / The unchanging part  //////////////////////////////////////////////////////////////////////////////////////////////////////
// The JS script code in this part does not require changes from the user.
// The user can change the code at their own risk if they understand what goals they want to achieve and how they want to achieve them.
// Код JS-скрипта в данной части не требует изменний со стороны пользователя.
// Пользователь может изменять код, на свой страх и риск, если понимает, какие цели и как желает достигнуть.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

var ModMenucssText = '' +
    'position: absolute;' +
    'top: 37px;' +
    'left:0px;' +
    'background-color: var(--colorBg);' +
    'flex-shrink: 2;' +
    'box-shadow: 0 0 0 1px var(--colorBorder), 0 2px 6px rgba(0, 0, 0, 0.25);' +
    'border-radius: var(--radiusHalf);' +
    'display: table;' +
    'order: -1;' +
    'float: left;' +
    'zoom: 105%;' +
    'min-width: 50px;' +
    'visibility: hidden;';

ModMenuHidden = function (e) {
    ModMenu.style.cssText = ModMenucssText; //Скрываем панель
    browser.removeEventListener('mousedown', ModMenuHidden);
    browser.removeEventListener('click', ModMenuHidden);
    browser.removeEventListener('contextmenu', ModMenuHidden);
    document.querySelector("#ButtonModMenu > button > svg").style.transform = "scale(1)";
};

function CreateNewButtonMenu(toolbarNewButton, titleNewButton, svgNewButton) {

    function openonmouseover() {
        browser.removeEventListener('mousedown', ModMenuHidden);
        browser.removeEventListener('click', ModMenuHidden);
        browser.removeEventListener('contextmenu', ModMenuHidden);
    }

    function openonmouseout() {
        browser.addEventListener('mousedown', ModMenuHidden);
        browser.addEventListener('click', ModMenuHidden);
        browser.addEventListener('contextmenu', ModMenuHidden);
    }

    function openClick() {
        if (document.documentElement.clientHeight < (ModMenu.getBoundingClientRect().top + ModMenu.offsetHeight)) {
            var ModMenuOffsetHeight = 0 - (ModMenu.offsetHeight - ButtonModMenu.offsetHeight) - 30;
            ModMenucssText = ModMenucssText + ('top: ' + String(ModMenuOffsetHeight) + 'px;');
        }
        if (document.documentElement.clientWidth < (ModMenu.getBoundingClientRect().left + ModMenu.offsetWidth)) {
            var ModMenuOffsetWidth = 0 - (ModMenu.offsetWidth - ButtonModMenu.offsetWidth);
            ModMenucssText = ModMenucssText + ('left: ' + String(ModMenuOffsetWidth) + 'px;');
        }
        if (ModMenu.style.visibility == "hidden") {
            ModMenu.style.cssText = ModMenucssText + 'visibility: visible;'; //Показываем панель
            document.querySelector("#ButtonModMenu > button > svg").style.transform = "scale(0.7)";
        } else {
            ModMenuHidden();
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
            'border-style: unset;' +
            'max-width: 34px;' +
            'max-height: -webkit-fill-available;' +
            'flex: 0 1 auto;' +
            'flex-grow: 0;' +
            'flex-shrink: 1;' +
            'flex-basis: auto;';

        var toolbar = document.querySelector(toolbarNewButton);
        var outer_div = document.createElement('div');
        outer_div.classList.add('button-toolbar', 'mod-ButtonMenu');
        outer_div.title = titleNewButton;
        outer_div.id = 'ButtonModMenu';
        var button = document.createElement('button');
        button.onclick = openClick;
        button.onmouseover = openonmouseover;
        button.onmouseout = openonmouseout;
        button.innerHTML = svgNewButton;
        outer_div.appendChild(button);
        outer_div.style.cssText = ButtoncssText;
        button.style.cssText = ButtoncssText;
        toolbar.appendChild(outer_div);
        var ModMenu = document.createElement('div');
        ModMenu.id = 'ModMenu';
        ModMenu.style.cssText = ModMenucssText;
        outer_div.appendChild(ModMenu);
        ModMenu.onmouseover = openonmouseover;
        ModMenu.onmouseout = openonmouseout;
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


function CreateNewItem(KEYPRESS_NewItem, classNewItem, toolbarNewItem, svgNewItem, textNewItem, separatorNewItem) {

    function openClick() {
        var OLD_title = document.title;
        document.title = 'VIVALDI_EMULATE_KEYPRESS ' + KEYPRESS_NewItem;
        setTimeout(
            () => {
                document.title = OLD_title;
            }, 50);
        ModMenuHidden();
    }

    function NewItem() {
        ItemcssText = '' +
            'display: inline-flex;' +
            'justify-content: left;' +
            'align-items: center;' +
            'background-color: var(--colorBg);' +
            'background-repeat: no-repeat;' +
            'background-position: 50% 50%;' +
            'border: 0 solid rgba(0, 0, 0, 0);' +
            'border-radius: 0;' +
            'min-width: 34px;' +
            'color: inherit;' +
            'padding: 0;' +
            'border-style: unset;';
        var toolbar = document.querySelector(toolbarNewItem);
        var outer_div = document.createElement('div');
        outer_div.classList.add('button-toolbar', classNewItem);
        outer_div.title = '';
        outer_div.style.cssText = outer_div.style.cssText + 'padding: 10px;' + 'padding-bottom: 0px;' + 'padding-top: 0px;';
        if (separatorNewItem == "Y") {
            outer_div.style.cssText = outer_div.style.cssText + 'border: 1.2px darkgray;' + 'border-bottom-style: solid;' + 'padding-bottom: 6px;' + 'margin-bottom: 6px;';
        }
        var Item = document.createElement('button');
        Item.onclick = openClick;
        if (svgNewItem == "") {
            svgNewItem = '<svg width="24" height="24" viewBox="0 0 24 24" transform="scale(0.5)" xmlns="http://www.w3.org/2000/svg" xmlns:serif="http://www.serif.com/" fill-rule="evenodd" clip-rule="evenodd"><circle serif:id="shape 19" cx="12" cy="12" r="12"/></svg>';
        }
        Item.innerHTML = svgNewItem + '<div style="margin-left: 18px; font-size: 110%; color: black;" >' + textNewItem + '</div>';
        Item.style.cssText = ItemcssText + 'height: 34px;';
        outer_div.appendChild(Item);
        toolbar.appendChild(outer_div);
    }

    setTimeout(function wait() {
        var toolbar = document.querySelector(toolbarNewItem);
        if (toolbar) {
            NewItem();
        } else {
            setTimeout(wait, 300);
        }
    }, 300);
}


///////////////////////////////////////////// Завершение неизменяемой части /  The completion of the unchanged parts //////////////////////////////////////////////////////////////////////


///////////////////////////////////////////// Изменяемая пользователем часть / User-modifiable part ///////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////Кнопка открытия нового меню /Button for opening a new menu ////////////////////////////////////////////////////////////////////////////////////
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
var NewButtonTitle = 'Меню Vivaldi_RUN';
var NewButtonSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="#205AFC"><path d="M4 22h-4v-4h4v4zm0-12h-4v4h4v-4zm0-8h-4v4h4v-4zm3 0v4h17v-4h-17zm0 12h17v-4h-17v4zm0 8h17v-4h-17v4z"/></svg>';
CreateNewButtonMenu(NewButtonToolbar, NewButtonTitle, NewButtonSvg);


///////////////////////////////////////////// Пункты нового меню / New menu items ////////////////////////////////////////////////////////////////////////////////////////////////////////
// In this part of the JS mod, the user, in accordance with the examples given, enters the code for creating new menu items that they need.
// В данной части JS-мода пользователь, в соответствии с приведенными примерами, вносит код создания новых пунктов меню, котрые ему нужны.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* Пункт меню "GOOGLE" / The menu item "GOOGLE" */
var NewItem_KEYPRESS = '"14" |https://www.google.com/| ';
var NewItemClass = 'mod_menu-GOOGLE-current_tab';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="24px" height="24"> <path style="fill:#FBBB00;" d="M113.47,309.408L95.648,375.94l-65.139,1.378C11.042,341.211,0,299.9,0,256 c0-42.451,10.324-82.483,28.624-117.732h0.014l57.992,10.632l25.404,57.644c-5.317,15.501-8.215,32.141-8.215,49.456 C103.821,274.792,107.225,292.797,113.47,309.408z"/> <path style="fill:#518EF8;" d="M507.527,208.176C510.467,223.662,512,239.655,512,256c0,18.328-1.927,36.206-5.598,53.451 c-12.462,58.683-45.025,109.925-90.134,146.187l-0.014-0.014l-73.044-3.727l-10.338-64.535 c29.932-17.554,53.324-45.025,65.646-77.911h-136.89V208.176h138.887L507.527,208.176L507.527,208.176z"/> <path style="fill:#28B446;" d="M416.253,455.624l0.014,0.014C372.396,490.901,316.666,512,256,512 c-97.491,0-182.252-54.491-225.491-134.681l82.961-67.91c21.619,57.698,77.278,98.771,142.53,98.771 c28.047,0,54.323-7.582,76.87-20.818L416.253,455.624z"/> <path style="fill:#F14336;" d="M419.404,58.936l-82.933,67.896c-23.335-14.586-50.919-23.012-80.471-23.012 c-66.729,0-123.429,42.957-143.965,102.724l-83.397-68.276h-0.014C71.23,56.123,157.06,0,256,0 C318.115,0,375.068,22.126,419.404,58.936z"/> </g> </svg>';
var NewItemText = 'GOOGLE in current tab';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "YANDEX" / The menu item  "YANDEX"*/
var NewItem_KEYPRESS = '"14" |https://yandex.com/| ';
var NewItemClass = 'mod_menu-yandex-current_tab';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32"><rect width="28" height="28" x="-31" y="-30" rx="14" ry="14" transform="matrix(0,-1,-1,0,0,0)" style="opacity:0.2"/><rect style="fill:#e4e4e4" width="28" height="28" x="-30" y="-30" rx="14" ry="14" transform="matrix(0,-1,-1,0,0,0)"/><path style="fill:#ffffff;opacity:0.2" d="M 16 2 C 8.244 2 2 8.244 2 16 C 2 16.168842 2.0195214 16.33264 2.0253906 16.5 C 2.2891326 8.9794325 8.4128418 3 16 3 C 23.587158 3 29.710867 8.9794325 29.974609 16.5 C 29.980479 16.33264 30 16.168842 30 16 C 30 8.244 23.756 2 16 2 z"/><path d="M 16,28.957273 16,17.437 M 6,7.9572725 16,17.437 26,7.9572725" style="opacity:0.2;fill:none;stroke:#000000;stroke-width:6;stroke-linecap:round;stroke-linejoin:round"/><path style="fill:none;stroke:#e34241;stroke-width:6;stroke-linecap:round;stroke-linejoin:round" d="M 16,28 16,16.48 M 6,7 16,16.48 26,7"/></svg>';
var NewItemText = 'YANDEX in current tab';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "DuckDuckGo" / The menu item "DuckDuckGo" */
var NewItem_KEYPRESS = '"14" |https://duckduckgo.com/| ';
var NewItemClass = 'mod_menu-DuckDuckGo-current_tab';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg  xmlns="http://www.w3.org/2000/svg" viewBox="0 0 50 50" width="32px" height="32px" fill="#BD4B2B"><path d="M 25 2 C 12.308594 2 2 12.308594 2 25 C 2 37.691406 12.308594 48 25 48 C 37.691406 48 48 37.691406 48 25 C 48 12.308594 37.691406 2 25 2 Z M 15.6875 9.3125 C 17.085938 9.3125 18.605469 9.695313 20.40625 10.59375 C 22.207031 11.492188 23.511719 12.398438 24.3125 13.5 C 25.613281 13.800781 26.699219 14.300781 27.5 15 C 28.5 15.898438 29.292969 17.292969 30.09375 19.09375 C 30.792969 20.894531 31.1875 22.601563 31.1875 24 C 31.1875 24.398438 31.101563 24.804688 31 25.40625 C 31.300781 25.304688 32 25.113281 33 24.8125 C 34 24.511719 34.886719 24.199219 35.6875 24 C 36.488281 23.800781 37.09375 23.6875 37.59375 23.6875 C 38.09375 23.6875 38.59375 23.804688 39.09375 23.90625 C 39.59375 24.007813 39.90625 24.289063 39.90625 24.6875 C 39.90625 25.289063 38.492188 26.085938 35.59375 27.1875 C 32.695313 28.289063 30.898438 28.8125 30 28.8125 C 29.800781 28.8125 29.40625 28.789063 28.90625 28.6875 C 28.40625 28.585938 27.988281 28.59375 27.6875 28.59375 L 26.59375 28.59375 C 26.492188 28.59375 26.40625 28.6875 26.40625 28.6875 C 26.40625 28.789063 26.3125 28.898438 26.3125 29 C 26.3125 29.699219 26.789063 30.289063 27.6875 30.6875 C 28.585938 31.085938 29.511719 31.3125 30.3125 31.3125 C 31.113281 31.3125 32.195313 31.199219 33.59375 31 C 34.992188 30.800781 36.207031 30.6875 36.90625 30.6875 C 37.40625 30.6875 37.6875 30.914063 37.6875 31.3125 C 37.6875 31.914063 36.804688 32.5 34.90625 33 C 33.105469 33.5 31.710938 33.8125 30.8125 33.8125 C 29.113281 33.8125 26.988281 33.113281 24.1875 31.8125 C 24.085938 32.210938 24.09375 32.695313 24.09375 33.09375 C 24.09375 34.695313 24.511719 36.492188 25.3125 38.59375 L 25.5 38.59375 C 25.898438 38.492188 26.1875 38.695313 26.1875 39.09375 C 28.289063 37.492188 29.800781 36.6875 30.5 36.6875 C 31 36.6875 31.3125 38.113281 31.3125 40.8125 C 31.3125 42.3125 31.09375 43 30.59375 43 C 29.894531 43 28.710938 42.613281 26.8125 41.8125 C 27.113281 42.414063 27.613281 43.210938 28.3125 44.3125 C 28.65625 44.804688 28.953125 45.203125 29.1875 45.5625 C 27.835938 45.835938 26.429688 46 25 46 C 22.410156 46 19.945313 45.511719 17.65625 44.65625 C 17.382813 43.378906 17.042969 41.667969 16.5 39.1875 C 14.898438 32.1875 13.8125 26.914063 13.3125 23.3125 C 13.210938 22.613281 13.09375 21.894531 13.09375 21.09375 C 13.09375 18.792969 13.707031 16.988281 14.90625 15.6875 C 16.105469 14.386719 17.886719 13.613281 20.1875 13.3125 C 19.488281 13.113281 18.699219 13 17.5 13 C 16.699219 13 15.414063 13.113281 13.8125 13.3125 C 13.8125 13.113281 13.894531 12.914063 14.09375 12.8125 L 14.6875 12.5 C 14.886719 12.5 15.199219 12.40625 15.5 12.40625 C 15.800781 12.40625 15.992188 12.3125 16.09375 12.3125 C 16.695313 12.210938 17.414063 11.898438 18.3125 11.5 C 17.011719 11.101563 15.8125 10.90625 14.8125 10.90625 C 14.613281 10.90625 14.3125 10.898438 13.8125 11 C 13.414063 11.101563 13.113281 11.09375 12.8125 11.09375 L 12.5 11.09375 L 13.5 9.6875 C 13.601563 9.6875 14 9.601563 14.5 9.5 C 15 9.398438 15.488281 9.3125 15.6875 9.3125 Z M 27.8125 17.40625 C 26.914063 17.40625 26.386719 17.800781 26.1875 18.5 C 26.386719 18.101563 27.011719 17.90625 27.8125 17.90625 C 28.210938 17.90625 28.710938 18.011719 29.3125 18.3125 C 29.113281 17.8125 28.511719 17.40625 27.8125 17.40625 Z M 17.3125 17.90625 C 16.941406 17.949219 16.613281 18.085938 16.3125 18.3125 C 15.8125 18.613281 15.59375 19 15.59375 19.5 C 15.59375 19.699219 15.585938 19.898438 15.6875 20 C 15.6875 19.5 15.898438 19.113281 16.5 18.8125 C 17.101563 18.414063 17.59375 18.3125 18.09375 18.3125 C 18.292969 18.3125 18.601563 18.398438 19 18.5 C 18.699219 18.101563 18.289063 17.90625 17.6875 17.90625 C 17.5625 17.90625 17.4375 17.890625 17.3125 17.90625 Z M 28.59375 20.6875 C 28.292969 20.6875 27.988281 20.792969 27.6875 21.09375 C 27.386719 21.394531 27.3125 21.699219 27.3125 22 C 27.3125 22.300781 27.386719 22.605469 27.6875 22.90625 C 27.988281 23.207031 28.292969 23.3125 28.59375 23.3125 C 28.992188 23.3125 29.300781 23.207031 29.5 22.90625 C 29.800781 22.605469 29.90625 22.300781 29.90625 22 C 29.90625 21.601563 29.800781 21.292969 29.5 21.09375 C 29.199219 20.792969 28.894531 20.6875 28.59375 20.6875 Z M 29.09375 21.3125 C 29.292969 21.3125 29.5 21.394531 29.5 21.59375 C 29.5 21.792969 29.394531 22 29.09375 22 C 28.894531 22 28.8125 21.894531 28.8125 21.59375 C 28.8125 21.394531 28.894531 21.3125 29.09375 21.3125 Z M 18.5 21.40625 C 18.101563 21.40625 17.800781 21.605469 17.5 21.90625 C 17.199219 22.207031 17 22.605469 17 22.90625 C 17 23.304688 17.199219 23.605469 17.5 23.90625 C 17.800781 24.207031 18.101563 24.40625 18.5 24.40625 C 18.898438 24.40625 19.199219 24.207031 19.5 23.90625 C 19.800781 23.605469 20 23.207031 20 22.90625 C 20 22.507813 19.800781 22.207031 19.5 21.90625 C 19.199219 21.605469 18.800781 21.40625 18.5 21.40625 Z M 19.1875 22 C 19.488281 22 19.59375 22.105469 19.59375 22.40625 C 19.59375 22.605469 19.488281 22.8125 19.1875 22.8125 C 18.886719 22.8125 18.8125 22.707031 18.8125 22.40625 C 18.8125 22.105469 18.886719 22 19.1875 22 Z"/></svg>';
var NewItemText = 'DuckDuckGo in current tab';
//var NewItemSeparator = 'N';
var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);


/* Пункт меню "GOOGLE" / The menu item "GOOGLE" */
var NewItem_KEYPRESS = '"15" |https://www.google.com/| ';
var NewItemClass = 'mod_menu-GOOGLE-new_tab';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="24px" height="24"> <path style="fill:#FBBB00;" d="M113.47,309.408L95.648,375.94l-65.139,1.378C11.042,341.211,0,299.9,0,256 c0-42.451,10.324-82.483,28.624-117.732h0.014l57.992,10.632l25.404,57.644c-5.317,15.501-8.215,32.141-8.215,49.456 C103.821,274.792,107.225,292.797,113.47,309.408z"/> <path style="fill:#518EF8;" d="M507.527,208.176C510.467,223.662,512,239.655,512,256c0,18.328-1.927,36.206-5.598,53.451 c-12.462,58.683-45.025,109.925-90.134,146.187l-0.014-0.014l-73.044-3.727l-10.338-64.535 c29.932-17.554,53.324-45.025,65.646-77.911h-136.89V208.176h138.887L507.527,208.176L507.527,208.176z"/> <path style="fill:#28B446;" d="M416.253,455.624l0.014,0.014C372.396,490.901,316.666,512,256,512 c-97.491,0-182.252-54.491-225.491-134.681l82.961-67.91c21.619,57.698,77.278,98.771,142.53,98.771 c28.047,0,54.323-7.582,76.87-20.818L416.253,455.624z"/> <path style="fill:#F14336;" d="M419.404,58.936l-82.933,67.896c-23.335-14.586-50.919-23.012-80.471-23.012 c-66.729,0-123.429,42.957-143.965,102.724l-83.397-68.276h-0.014C71.23,56.123,157.06,0,256,0 C318.115,0,375.068,22.126,419.404,58.936z"/> </g> </svg>';
var NewItemText = 'GOOGLE in new tab';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "YANDEX" / The menu item "YANDEX" */
var NewItem_KEYPRESS = '"15" |https://yandex.com/| ';
var NewItemClass = 'mod_menu-yandex-new_tab';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32"><rect width="28" height="28" x="-31" y="-30" rx="14" ry="14" transform="matrix(0,-1,-1,0,0,0)" style="opacity:0.2"/><rect style="fill:#e4e4e4" width="28" height="28" x="-30" y="-30" rx="14" ry="14" transform="matrix(0,-1,-1,0,0,0)"/><path style="fill:#ffffff;opacity:0.2" d="M 16 2 C 8.244 2 2 8.244 2 16 C 2 16.168842 2.0195214 16.33264 2.0253906 16.5 C 2.2891326 8.9794325 8.4128418 3 16 3 C 23.587158 3 29.710867 8.9794325 29.974609 16.5 C 29.980479 16.33264 30 16.168842 30 16 C 30 8.244 23.756 2 16 2 z"/><path d="M 16,28.957273 16,17.437 M 6,7.9572725 16,17.437 26,7.9572725" style="opacity:0.2;fill:none;stroke:#000000;stroke-width:6;stroke-linecap:round;stroke-linejoin:round"/><path style="fill:none;stroke:#e34241;stroke-width:6;stroke-linecap:round;stroke-linejoin:round" d="M 16,28 16,16.48 M 6,7 16,16.48 26,7"/></svg>';
var NewItemText = 'YANDEX in new tab';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "DuckDuckGo" / The menu item "DuckDuckGo" */
var NewItem_KEYPRESS = '"15" |https://duckduckgo.com| ';
var NewItemClass = 'mod_menu-DuckDuckGo-new_tab';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 50 50" width="32px" height="32px" fill="#BD4B2B"><path d="M 25 2 C 12.308594 2 2 12.308594 2 25 C 2 37.691406 12.308594 48 25 48 C 37.691406 48 48 37.691406 48 25 C 48 12.308594 37.691406 2 25 2 Z M 15.6875 9.3125 C 17.085938 9.3125 18.605469 9.695313 20.40625 10.59375 C 22.207031 11.492188 23.511719 12.398438 24.3125 13.5 C 25.613281 13.800781 26.699219 14.300781 27.5 15 C 28.5 15.898438 29.292969 17.292969 30.09375 19.09375 C 30.792969 20.894531 31.1875 22.601563 31.1875 24 C 31.1875 24.398438 31.101563 24.804688 31 25.40625 C 31.300781 25.304688 32 25.113281 33 24.8125 C 34 24.511719 34.886719 24.199219 35.6875 24 C 36.488281 23.800781 37.09375 23.6875 37.59375 23.6875 C 38.09375 23.6875 38.59375 23.804688 39.09375 23.90625 C 39.59375 24.007813 39.90625 24.289063 39.90625 24.6875 C 39.90625 25.289063 38.492188 26.085938 35.59375 27.1875 C 32.695313 28.289063 30.898438 28.8125 30 28.8125 C 29.800781 28.8125 29.40625 28.789063 28.90625 28.6875 C 28.40625 28.585938 27.988281 28.59375 27.6875 28.59375 L 26.59375 28.59375 C 26.492188 28.59375 26.40625 28.6875 26.40625 28.6875 C 26.40625 28.789063 26.3125 28.898438 26.3125 29 C 26.3125 29.699219 26.789063 30.289063 27.6875 30.6875 C 28.585938 31.085938 29.511719 31.3125 30.3125 31.3125 C 31.113281 31.3125 32.195313 31.199219 33.59375 31 C 34.992188 30.800781 36.207031 30.6875 36.90625 30.6875 C 37.40625 30.6875 37.6875 30.914063 37.6875 31.3125 C 37.6875 31.914063 36.804688 32.5 34.90625 33 C 33.105469 33.5 31.710938 33.8125 30.8125 33.8125 C 29.113281 33.8125 26.988281 33.113281 24.1875 31.8125 C 24.085938 32.210938 24.09375 32.695313 24.09375 33.09375 C 24.09375 34.695313 24.511719 36.492188 25.3125 38.59375 L 25.5 38.59375 C 25.898438 38.492188 26.1875 38.695313 26.1875 39.09375 C 28.289063 37.492188 29.800781 36.6875 30.5 36.6875 C 31 36.6875 31.3125 38.113281 31.3125 40.8125 C 31.3125 42.3125 31.09375 43 30.59375 43 C 29.894531 43 28.710938 42.613281 26.8125 41.8125 C 27.113281 42.414063 27.613281 43.210938 28.3125 44.3125 C 28.65625 44.804688 28.953125 45.203125 29.1875 45.5625 C 27.835938 45.835938 26.429688 46 25 46 C 22.410156 46 19.945313 45.511719 17.65625 44.65625 C 17.382813 43.378906 17.042969 41.667969 16.5 39.1875 C 14.898438 32.1875 13.8125 26.914063 13.3125 23.3125 C 13.210938 22.613281 13.09375 21.894531 13.09375 21.09375 C 13.09375 18.792969 13.707031 16.988281 14.90625 15.6875 C 16.105469 14.386719 17.886719 13.613281 20.1875 13.3125 C 19.488281 13.113281 18.699219 13 17.5 13 C 16.699219 13 15.414063 13.113281 13.8125 13.3125 C 13.8125 13.113281 13.894531 12.914063 14.09375 12.8125 L 14.6875 12.5 C 14.886719 12.5 15.199219 12.40625 15.5 12.40625 C 15.800781 12.40625 15.992188 12.3125 16.09375 12.3125 C 16.695313 12.210938 17.414063 11.898438 18.3125 11.5 C 17.011719 11.101563 15.8125 10.90625 14.8125 10.90625 C 14.613281 10.90625 14.3125 10.898438 13.8125 11 C 13.414063 11.101563 13.113281 11.09375 12.8125 11.09375 L 12.5 11.09375 L 13.5 9.6875 C 13.601563 9.6875 14 9.601563 14.5 9.5 C 15 9.398438 15.488281 9.3125 15.6875 9.3125 Z M 27.8125 17.40625 C 26.914063 17.40625 26.386719 17.800781 26.1875 18.5 C 26.386719 18.101563 27.011719 17.90625 27.8125 17.90625 C 28.210938 17.90625 28.710938 18.011719 29.3125 18.3125 C 29.113281 17.8125 28.511719 17.40625 27.8125 17.40625 Z M 17.3125 17.90625 C 16.941406 17.949219 16.613281 18.085938 16.3125 18.3125 C 15.8125 18.613281 15.59375 19 15.59375 19.5 C 15.59375 19.699219 15.585938 19.898438 15.6875 20 C 15.6875 19.5 15.898438 19.113281 16.5 18.8125 C 17.101563 18.414063 17.59375 18.3125 18.09375 18.3125 C 18.292969 18.3125 18.601563 18.398438 19 18.5 C 18.699219 18.101563 18.289063 17.90625 17.6875 17.90625 C 17.5625 17.90625 17.4375 17.890625 17.3125 17.90625 Z M 28.59375 20.6875 C 28.292969 20.6875 27.988281 20.792969 27.6875 21.09375 C 27.386719 21.394531 27.3125 21.699219 27.3125 22 C 27.3125 22.300781 27.386719 22.605469 27.6875 22.90625 C 27.988281 23.207031 28.292969 23.3125 28.59375 23.3125 C 28.992188 23.3125 29.300781 23.207031 29.5 22.90625 C 29.800781 22.605469 29.90625 22.300781 29.90625 22 C 29.90625 21.601563 29.800781 21.292969 29.5 21.09375 C 29.199219 20.792969 28.894531 20.6875 28.59375 20.6875 Z M 29.09375 21.3125 C 29.292969 21.3125 29.5 21.394531 29.5 21.59375 C 29.5 21.792969 29.394531 22 29.09375 22 C 28.894531 22 28.8125 21.894531 28.8125 21.59375 C 28.8125 21.394531 28.894531 21.3125 29.09375 21.3125 Z M 18.5 21.40625 C 18.101563 21.40625 17.800781 21.605469 17.5 21.90625 C 17.199219 22.207031 17 22.605469 17 22.90625 C 17 23.304688 17.199219 23.605469 17.5 23.90625 C 17.800781 24.207031 18.101563 24.40625 18.5 24.40625 C 18.898438 24.40625 19.199219 24.207031 19.5 23.90625 C 19.800781 23.605469 20 23.207031 20 22.90625 C 20 22.507813 19.800781 22.207031 19.5 21.90625 C 19.199219 21.605469 18.800781 21.40625 18.5 21.40625 Z M 19.1875 22 C 19.488281 22 19.59375 22.105469 19.59375 22.40625 C 19.59375 22.605469 19.488281 22.8125 19.1875 22.8125 C 18.886719 22.8125 18.8125 22.707031 18.8125 22.40625 C 18.8125 22.105469 18.886719 22 19.1875 22 Z"/></svg>';
var NewItemText = 'DuckDuckGo in new tab';
//var NewItemSeparator = 'N';
var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "startpage" / The menu item "startpage" */
var NewItem_KEYPRESS = '"15" |vivaldi://startpage| ';
var NewItemClass = 'mod_menu-startpage';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M20 19h-4v-4h4v4zm-6-10h-4v4h4v-4zm6 0h-4v4h4v-4zm-12 6h-4v4h4v-4zm16-14v22h-24v-22h24zm-2 6h-20v14h20v-14zm-8 8h-4v4h4v-4zm-6-6h-4v4h4v-4z"/></svg>';
var NewItemText = 'Startpage';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "downloads" / The menu item "downloads" */
var NewItem_KEYPRESS = '"15" |vivaldi://downloads| ';
var NewItemClass = 'mod_menu-downloads';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M16 11h5l-9 10-9-10h5v-11h8v11zm3 8v3h-14v-3h-2v5h18v-5h-2z"/></svg>';
var NewItemText = 'Downloads';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "extensions" / The menu item "extensions" */
var NewItem_KEYPRESS = '"15" |vivaldi://extensions| ';
var NewItemClass = 'mod_menu-extensions';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 448" style="enable-background:new 0 0 26 26;" xml:space="preserve"><g><g><path d="M394.667,213.333h-32V128c0-23.573-19.093-42.667-42.667-42.667h-85.333v-32C234.667,23.893,210.773,0,181.333,0 S128,23.893,128,53.333v32H42.667c-23.573,0-42.453,19.093-42.453,42.667l-0.107,81.067H32c31.787,0,57.6,25.813,57.6,57.6 s-25.813,57.6-57.6,57.6H0.107L0,405.333C0,428.907,19.093,448,42.667,448h81.067v-32c0-31.787,25.813-57.6,57.6-57.6 s57.6,25.813,57.6,57.6v32H320c23.573,0,42.667-19.093,42.667-42.667V320h32c29.44,0,53.333-23.893,53.333-53.333 S424.107,213.333,394.667,213.333z"/></svg>';
var NewItemText = 'Extensions';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "bookmarks" / The menu item "bookmarks" */
var NewItem_KEYPRESS = '"15" |vivaldi://bookmarks| ';
var NewItemClass = 'mod_menu-bookmarks';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M24 24l-6-5.269-6 5.269v-24h12v24zm-14-23h-10v2h10v-2zm0 5h-10v2h10v-2zm0 5h-10v2h10v-2zm0 5h-10v2h10v-2z"/></svg>';
var NewItemText = 'Bookmarks';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "history" / The menu item "history" */
var NewItem_KEYPRESS = '"15" |vivaldi://history| ';
var NewItemClass = 'mod_menu-history';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M12 2c5.514 0 10 4.486 10 10s-4.486 10-10 10-10-4.486-10-10 4.486-10 10-10zm0-2c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12-12-5.373-12-12-12zm5.848 12.459c.202.038.202.333.001.372-1.907.361-6.045 1.111-6.547 1.111-.719 0-1.301-.582-1.301-1.301 0-.512.77-5.447 1.125-7.445.034-.192.312-.181.343.014l.985 6.238 5.394 1.011z"/></svg>';
var NewItemText = 'History';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "notes" / The menu item "notes" */
var NewItem_KEYPRESS = '"15" |vivaldi://notes| ';
var NewItemClass = 'mod_menu-notes';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M12.37 5.379l-5.64 5.64c-.655.655-1.515.982-2.374.982-1.855 0-3.356-1.498-3.356-3.356 0-.86.327-1.721.981-2.375l5.54-5.539c.487-.487 1.125-.731 1.765-.731 2.206 0 3.338 2.686 1.765 4.259l-4.919 4.919c-.634.634-1.665.634-2.298 0-.634-.633-.634-1.664 0-2.298l3.97-3.97.828.828-3.97 3.97c-.178.177-.178.465 0 .642.177.178.465.178.642 0l4.919-4.918c1.239-1.243-.636-3.112-1.873-1.874l-5.54 5.54c-.853.853-.853 2.24 0 3.094.854.852 2.24.852 3.093 0l5.64-5.64.827.827zm.637-5.379c.409.609.635 1.17.729 2h7.264v11.543c0 4.107-6 2.457-6 2.457s1.518 6-2.638 6h-7.362v-8.062c-.63.075-1 .13-2-.133v10.195h10.189c3.163 0 9.811-7.223 9.811-9.614v-14.386h-9.993zm4.993 6h-3.423l-.793.793-.207.207h4.423v-1zm0 3h-6.423l-1 1h7.423v-1zm0 3h-9.423l-.433.433c-.212.213-.449.395-.689.567h10.545v-1z"/></svg>';
var NewItemText = 'Notes';
//var NewItemSeparator = 'N';
var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);



/* Пункт меню "experiments" / The menu item "experiments" */
var NewItem_KEYPRESS = '"15" |vivaldi://experiments| ';
var NewItemClass = 'mod_menu-experiments';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M15.794 2.707c-.634-.634-.174-1.707.707-1.707.256 0 .512.098.707.293l4.243 4.242c.391.391.391 1.023 0 1.414s-1.023.391-1.414 0l-4.243-4.242zm-1.811 9.293h-11.42l-.445-.445c-.212-.213-.129-.609.188-.721 6.171-1.357 9.375-1.261 13.573-5.414l-1.414-1.414c-3.784 3.794-7.231 3.712-12.827 4.944-1.029.366-1.638 1.317-1.638 2.322 0 .605.224 1.217.705 1.697l9.301 9.301c.48.48 1.091.73 1.696.73 1 0 1.955-.629 2.323-1.664 1.235-5.617.884-9.288 4.683-13.086l-1.414-1.414c-1.732 1.732-2.689 3.398-3.311 5.164zm10.017 1.517c0 1.363-1.106 2.483-2.47 2.483-2.991 0-4.06-4.22.912-8-.058 2.365 1.558 3.302 1.558 5.517zm-2.371-3.466c-.346.189-.856.698-.934 1.333-.115.95.867 1.23.953-.044.04-.537 0-.794-.019-1.289z"/></svg>';
var NewItemText = 'Experiments';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "flags" / The menu item "flags" */
var NewItem_KEYPRESS = '"15" |vivaldi://flags| ';
var NewItemClass = 'mod_menu-flags';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M4 24h-2v-24h2v24zm18-21.387s-1.621 1.43-3.754 1.43c-3.36 0-3.436-2.895-7.337-2.895-2.108 0-4.075.98-4.909 1.694v12.085c1.184-.819 2.979-1.681 4.923-1.681 3.684 0 4.201 2.754 7.484 2.754 2.122 0 3.593-1.359 3.593-1.359v-12.028z"/></svg>';
var NewItemText = 'VIVALDI flags';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "themecolors" / The menu item "themecolors" */
var NewItem_KEYPRESS = '"15" |vivaldi://themecolors| ';
var NewItemClass = 'mod_menu-themecolors';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M4 21.832c4.587.38 2.944-4.493 7.188-4.538l1.838 1.534c.458 5.538-6.315 6.773-9.026 3.004zm14.065-7.115c1.427-2.239 5.847-9.749 5.847-9.749.352-.623-.43-1.273-.976-.813 0 0-6.572 5.714-8.511 7.525-1.532 1.432-1.539 2.086-2.035 4.447l1.68 1.4c2.227-.915 2.868-1.039 3.995-2.81zm-11.999 3.876c.666-1.134 1.748-2.977 4.447-3.262.434-2.087.607-3.3 2.547-5.112 1.373-1.282 4.938-4.409 7.021-6.229-1-2.208-4.141-4.023-8.178-3.99-6.624.055-11.956 5.465-11.903 12.092.023 2.911 1.081 5.571 2.82 7.635 1.618.429 2.376.348 3.246-1.134zm6.952-15.835c1.102-.006 2.005.881 2.016 1.983.004 1.103-.882 2.009-1.986 2.016-1.105.009-2.008-.88-2.014-1.984-.013-1.106.876-2.006 1.984-2.015zm-5.997 2.001c1.102-.01 2.008.877 2.012 1.983.012 1.106-.88 2.005-1.98 2.016-1.106.007-2.009-.881-2.016-1.988-.009-1.103.877-2.004 1.984-2.011zm-2.003 5.998c1.106-.007 2.01.882 2.016 1.985.01 1.104-.88 2.008-1.986 2.015-1.105.008-2.005-.88-2.011-1.985-.011-1.105.879-2.004 1.981-2.015zm10.031 8.532c.021 2.239-.882 3.718-1.682 4.587l-.046.044c5.255-.591 9.062-4.304 6.266-7.889-1.373 2.047-2.534 2.442-4.538 3.258z"/></svg>';
var NewItemText = 'VIVALDI themecolors';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "vivaldi://settings" / The menu item "vivaldi://settings" */
var NewItem_KEYPRESS = '"15" |vivaldi://settings| ';
var NewItemClass = 'mod_menu-vivaldisettings';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M24 14v-4h-3.23c-.229-1.003-.624-1.94-1.156-2.785l2.286-2.286-2.83-2.829-2.286 2.286c-.845-.532-1.781-.928-2.784-1.156v-3.23h-4v3.23c-1.003.228-1.94.625-2.785 1.157l-2.286-2.286-2.829 2.828 2.287 2.287c-.533.845-.928 1.781-1.157 2.784h-3.23v4h3.23c.229 1.003.624 1.939 1.156 2.784l-2.286 2.287 2.829 2.829 2.286-2.286c.845.531 1.782.928 2.785 1.156v3.23h4v-3.23c1.003-.228 1.939-.624 2.784-1.156l2.286 2.286 2.828-2.829-2.285-2.286c.532-.845.928-1.782 1.156-2.785h3.231zm-12 2c-2.209 0-4-1.791-4-4s1.791-4 4-4 4 1.791 4 4-1.791 4-4 4z"/></svg>';
var NewItemText = 'VIVALDI settings';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "chrome://settings" / The menu item "chrome://settings" */
var NewItem_KEYPRESS = '"15" |chrome://settings| ';
var NewItemClass = 'mod_menu-chromesettings';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M13.895 10.623l1.37-2.054c.35-.525 1.06-.667 1.585-.317.524.35.667 1.06.316 1.585l-1.369 2.054c-.35.525-1.06.667-1.585.317s-.667-1.06-.317-1.585zm-1.881-.684c.525.351 1.236.208 1.587-.317l1.383-2.074c.352-.526.209-1.237-.317-1.588-.525-.351-1.236-.208-1.587.318l-1.383 2.074c-.352.526-.21 1.237.317 1.587zm7.007 3.949l-1.212 1.817c-.322.483-.191 1.136.292 1.458s1.136.191 1.458-.292l1.211-1.817c.323-.483.192-1.136-.291-1.458-.483-.322-1.136-.192-1.458.292zm-3.071-.84c-.35.523-.208 1.231.315 1.58.524.349 1.231.208 1.58-.316l1.312-1.968c.35-.524.208-1.231-.316-1.58-.523-.349-1.23-.208-1.579.316l-1.312 1.968zm5.665 10.952c-.609 0-1.22-.232-1.686-.698l-7.022-7.144c1.088-1.203.56-3.279-1.182-3.588l-3.074-.546-1.058-1.058c-.601-.6-1.427-.916-2.273-.871-1.382.074-2.787-.417-3.842-1.472-.986-.987-1.478-2.279-1.478-3.572 0-.56.092-1.12.277-1.655l3.214 3.214c1.253.074 3.192-1.865 3.118-3.119l-3.213-3.214c.535-.185 1.094-.277 1.654-.277 1.293 0 2.586.493 3.572 1.479 1.055 1.055 1.545 2.46 1.472 3.842-.045.846.271 1.674.871 2.273l.027.027c-1.243 2.083.433 3.51 1.806 3.457-.247 1.181 1.017 2.411 2.102 2.411-.269 1.04.536 2.125 1.789 2.371-.505 1.822 2.258 3.767 3.857 1.315l2.756 2.755c.466.466.698 1.076.698 1.686 0 1.316-1.066 2.384-2.385 2.384zm.885-2.5c0-.552-.448-1-1.001-1-.552 0-1 .448-1 1s.448 1 1 1c.553 0 1.001-.448 1.001-1zm-9.631-3.939c-.667-.688-1.701-.739-3.584-.864-.286-.019-.462.165-.485.443l-.458 4.208s2.794 1.888 3.94 2.652c1.064-1.921 2.699-2.037 3.921-3.002l-3.334-3.437zm-1.622-1.692c1.457 0 1.678-2.064.303-2.308-5.171-.919-4.899-.889-5.069-.889-.635 0-1.186.453-1.309 1.078l-.446 3.946c-.061.631.145 1.176.633 1.532.487.354 2.026 1.449 2.026 1.449s.328-2.835.42-3.651c.093-.815.551-1.378 1.424-1.335.092.004 1.859.178 2.018.178z"/></svg>';
var NewItemText = 'Chrome settings';
//var NewItemSeparator = 'N';
var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);


/* Пункт меню "Task Manager VIVALDI" / The menu item "Task Manager VIVALDI" */
var NewItem_KEYPRESS = '"16" "27"';
var NewItemClass = 'mod_menu-TaskManagerVIVALDI';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M22 2v20h-20v-20h20zm2-2h-24v24h24v-24zm-4 7h-8v1h8v-1zm0 5h-8v1h8v-1zm0 5h-8v1h8v-1zm-10.516-11.304l-.71-.696-2.553 2.607-1.539-1.452-.698.71 2.25 2.135 3.25-3.304zm0 5l-.71-.696-2.552 2.607-1.539-1.452-.698.709 2.249 2.136 3.25-3.304zm0 5l-.71-.696-2.552 2.607-1.539-1.452-.698.709 2.249 2.136 3.25-3.304z"/></svg>';
var NewItemText = 'Task Manager VIVALDI';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);

/* Пункт меню "Task Manager WINDOWS" / The menu item "Task Manager WINDOWS" */
var NewItem_KEYPRESS = '"11" |taskmgr.exe| ';
var NewItemClass = 'mod_menu-TaskManagerWINDOWS';
var NewItemToolbar = 'div#ModMenu';
var NewItemSvg = '<svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M20 24h-20v-22h3c1.229 0 2.18-1.084 3-2h8c.82.916 1.771 2 3 2h3v9h-2v-7h-4l-2 2h-3.898l-2.102-2h-4v18h16v-5h2v7zm-10-4h-6v-1h6v1zm0-2h-6v-1h6v1zm6-5h8v2h-8v3l-5-4 5-4v3zm-6 3h-6v-1h6v1zm0-2h-6v-1h6v1zm0-2h-6v-1h6v1zm0-2h-6v-1h6v1zm-1-7c0 .552.448 1 1 1s1-.448 1-1-.448-1-1-1-1 .448-1 1z"/></svg>';
var NewItemText = 'Task Manager WINDOWS';
var NewItemSeparator = 'N';
//var NewItemSeparator = 'Y';
CreateNewItem(NewItem_KEYPRESS, NewItemClass, NewItemToolbar, NewItemSvg, NewItemText, NewItemSeparator);