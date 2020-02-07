The Program &quot;Vivaldi\_Run&quot;. User manual.

Author: kichrot

2020 y.

This Manual has been translated into English from the original in Russian using a translator at: [https://translate.yandex.ru/](https://translate.yandex.ru/)



ATTENTION!!!

The program &quot;Vivaldi\_Run&quot; is distributed free of charge, along with the source code, on an &quot;as is&quot; basis. The author informs users that he did not embed any directed destructive code in the program and generally considers himself a good and kind being. However, the author refuses to accept any responsibility for data loss, damage caused, loss of profit, sexual deviations, violations of the physical and mental health of people and animals, crimes, wars, natural disasters, heat death of the Universe and any other negative effects associated with the use or non-use of this software product.

The &quot;Vivaldi\_Run&quot; program is a 32-bit Windows application that runs in the background and does not require user intervention, except for the initial settings described later in this guide. The program is characterized by low consumption of PC resources, below the level of most extensions for the Google Chrome browser with similar functionality.

Table of CONTENTS:

I. purpose of the program &quot;Vivaldi\_Run&quot;.

II. The composition of the &quot;Vivaldi\_Run&quot; program delivery and the purpose of the files.

III. Description of the main algorithm of the program &quot;Vivaldi\_Run&quot;

IV. Installation and preparation for work programme &quot;Vivaldi\_Run&quot;.

V. Preparing the &quot;VIVALDI&quot; browser to work with the &quot;Vivaldi\_Run&quot; program.

VI. JS-mod for creating new buttons.

VII. Implementation of &quot;non-standard&quot; buttons.

Appendix 1. Virtual key codes.

Appendix 2. PCRE library license

## I. Purpose of the &quot;Vivaldi\_Run&quot; program.

1) Launch the &quot;VIVALDI&quot; browser with the command-line parameters set by the user in the &quot;VIVALDI\_COMMAND\_LINE.txt&quot;.

2) Ensuring the functionality of buttons created by the user in the corresponding JS-mod on the &quot;VIVALDI&quot;  browser panels.

Providing the functionality of the buttons created by the user, the program &quot;Vivaldi\_Run&quot;, based on the commands given by the corresponding JS-mod, in fact emits user actions by pressing the keyboard shortcuts registered in the browser &quot;VIVALDI&quot; to call the corresponding functions of the browser &quot;VIVALDI&quot;. The procedure for creating and using a JS mod will be described later in this Guide, in section IV.



## II. The composition of the &quot;Vivaldi\_Run&quot; program delivery and the purpose of the files.

The software package includes the following files and directories:

1) file &quot;Vivaldi\_Run.exe&quot;- executable file of the program &quot;Vivaldi\_Run&quot;

2) the file &quot;VIVALDI\_COMMAND\_LINE.txt &quot; - a file containing command-line parameters for launching the &quot;VIVALDI&quot; browser. By default, the file is empty and filled in by the user, according to their needs.

3) files &quot;–уководство пользовател€.doc&quot; and &quot;User manual.doc&quot; - files containing this Manual, respectively in Russian and English.

4) the &quot;JS MOD&quot; directory - the directory with the &quot;New\_button.js &quot; containing an example of a JavaScript mod that creates the necessary buttons for the user on the &quot;VIVALDI&quot; browser panels.

_5) &quot;source&quot; directory - the directory with the source code files of the program &quot;Vivaldi\_Run&quot; in the programming language &quot;Purebasic 5.70&quot; (_[_https://www.purebasic.com/_](https://www.purebasic.com/)_) using the PCRE library. For the PCRE library license, see Appendix 2 of this Guide._

III. Description of the main algorithm of the program &quot;Vivaldi\_Run&quot;

1) the &quot;Vivaldi\_Run&quot; program is launched directly by the &quot;Vivaldi\_Run.exe&quot; or through the corresponding shortcut of this file created by the user.

2) after starting the program &quot;Vivaldi\_Run&quot; checks for the file &quot;VIVALDI\_COMMAND\_LINE.txt&quot; containing command-line parameters for the &quot;VIVALDI&quot; browser. If the file is &quot;VIVALDI\_COMMAND\_LINE.txt&quot; is missing, then the program &quot;Vivaldi\_Run&quot; creates an empty file &quot;VIVALDI\_COMMAND\_LINE.txt&quot; automatically.

3) the program &quot;Vivaldi\_Run&quot; reads the contents of the file &quot;VIVALDI\_COMMAND\_LINE.txt&quot;.

4) the program &quot;Vivaldi\_Run&quot; checks the presence of the browser launch file &quot;VIVALDI&quot; - &quot;vivaldi.exe&quot;:

a) in the absence of the file &quot;vivaldi.exe&quot; the program &quot;Vivaldi\_Run&quot; displays the appropriate message for the user and completes its work. The user must check for the &quot;vivaldi.exe&quot; and after eliminating possible violations, re-run the program &quot;Vivaldi\_Run&quot;.

b) in the presence of the file &quot;vivaldi.exe&quot; program &quot;Vivaldi\_Run&quot; starts the browser &quot;VIVALDI&quot; and translates to it the command-line parameters obtained earlier from the file &quot; VIVALDI\_COMMAND\_LINE.txt&quot;.

5) the &quot;Vivaldi\_Run&quot; program waits for the &quot;VIVALDI&quot; browser window to appear within 60 seconds:

a) if there is no &quot;VIVALDI&quot; browser window for 60 seconds, the &quot;Vivaldi\_Run&quot; program stops working.

b) when the &quot;VIVALDI&quot; browser window appears within 60 seconds, the &quot;Vivaldi\_Run&quot; program begins its normal operation in the background, waiting for commands from the &quot;VIVALDI&quot; browser.

6) during normal operation, once every 10 seconds, the program&quot; Vivaldi\_Run &quot;checks the presence of the browser window&quot; VIVALDI&quot;

7) if the &quot;VIVALDI&quot; browser window disappears, the &quot;Vivaldi\_Run&quot; program is put into the &quot;VIVALDI&quot; browser window standby mode for 60 seconds:

a) when the &quot;VIVALDI&quot; browser window appears within 60 seconds, the &quot;Vivaldi\_Run&quot; program goes into normal operation mode and waits for commands from the &quot;VIVALDI&quot; browser&quot;

b) if there is no &quot;VIVALDI&quot; browser window for 60 seconds, the &quot;Vivaldi\_Run&quot; program stops working

8) during normal operation, when a command is received from the &quot;VIVALDI&quot; browser, the &quot;Vivaldi\_Run&quot; program executes this command, emulating the keystrokes specified in the command, by sending system messages to the address of the active browser window &quot;VIVALDI&quot;.

9) after executing the &quot;VIVALDI&quot; browser command, the &quot;Vivaldi\_Run&quot; program goes into normal operation mode and waits for the following &quot;VIVALDI&quot; browser commands.

The &quot;Vivaldi\_Run&quot; program always runs in a single instance and serves any number of &quot;VIVALDI&quot; browser Windows.

When you try to run the second instance of the &quot;Vivaldi\_Run&quot; program, it starts the second instance of the &quot;VIVALDI&quot; browser and stops its second instance.



## IV. Installation and preparation for work programme &quot;Vivaldi\_Run&quot;.

1) unpack the archive with the program &quot;Vivaldi\_Run&quot; in a separate directory.

2) copy the &quot;Vivaldi\_Run.exe&quot; and &quot;VIVALDI\_COMMAND\_LINE.txt&quot; to the directory with the file &quot;vivaldi.exe&quot;. In the standard installation of the &quot;VIVALDI&quot; browser, these are the directories: &quot;C:\Program Files\Vivaldi\Application&quot; or &quot;C:\Program Files (x86)\Vivaldi\Application&quot;, depending on the installed version of the &quot;VIVALDI&quot; browser and the version of the WINDOWS operating system.

3) fill in the &quot;VIVALDI\_COMMAND\_LINE.txt&quot; command-line parameters for the &quot;VIVALDI&quot; browser.

The user determines the number and composition of command-line parameters for the &quot;VIVALDI&quot; browser independently, based on their needs and views. Empty file &quot;VIVALDI\_COMMAND\_LINE.txt&quot; will mean launching the &quot;VIVALDI&quot; browser without command-line parameters.

A list of command-line parameters that can be used for the &quot;VIVALDI&quot; browser can be found at:  [https://peter.sh/experiments/chromium-command-line-switches/#reduce-security-for-testing](https://peter.sh/experiments/chromium-command-line-switches/#reduce-security-for-testing) .

In the file &quot;VIVALDI\_COMMAND\_LINE.txt&quot; command-line parameters for the &quot;VIVALDI&quot; browser can be placed in the same line or in different ones. For example:

--user-data-dir=&quot;D:\Profile\Vivaldi&quot;

--disk-cache-dir=NUL

--media-cache-size=NUL

--process-per-site

--enable-native-gpu-memory-buffers

--enable-features=&quot;CheckerImaging&quot;

--enable-checker-imaging

The user must control whether the command-line parameters for the &quot;VIVALDI&quot; browser are written correctly.

If there is no file &quot;VIVALDI\_COMMAND\_LINE.txt&quot;, in the same directory as the file &quot;Vivaldi\_Run.exe&quot;, it will be created automatically when you run the file &quot;Vivaldi\_Run.exe&quot;.

4) create a shortcut on the Windows desktop for the file &quot;Vivaldi\_Run.exe&quot;.

After performing these actions, the &quot;Vivaldi\_Run&quot; program is ready to work.



## V. Preparing the &quot;VIVALDI&quot; browser to work with the &quot;Vivaldi\_Run&quot; program.

Preparing the &quot;VIVALDI&quot; browser to work with the &quot;Vivaldi\_Run&quot; program consists in preparing and connecting the corresponding JavaScript mod to the browser.

An example of the mod is included in the delivery of the program &quot;Vivaldi\_Run&quot;, in the form of the file &quot; New\_button.js&quot; in the &quot;JS MOD&quot; directory. The mod&#39;s composition is discussed in section **VI** of this Guide.

1) open the &quot;New\_button.js&quot; file in any text editor from the &quot;JS MOD&quot; directory.

2) change, in the mod&#39;s changeable part, the composition and parameters of the buttons created by the mod.

3) save the mod

4) connect the mod to the browser &quot;VIVALDI&quot; according to the method specified on the link:

[https://forum.vivaldi.net/topic/10549/modding-vivaldi](https://forum.vivaldi.net/topic/10549/modding-vivaldi)

According to the author&#39;s opinion and experience, it is more convenient to use the &quot;Vivaldi Mod Manager&quot; program to create and connect mods:  [https://forum.vivaldi.net/topic/30984/windows-vivaldi-mod-manager](https://forum.vivaldi.net/topic/30984/windows-vivaldi-mod-manager)

5) restart the &quot;VIVALDI&quot; browser. If you have completed all the items, new buttons will appear with the functions you set.

6) adjust the visual style of the buttons you created using CSS scripts. Rules for writing and using CSS scripts in the &quot;VIVALDI&quot; browser are not included in this Guide and are studied by the user on their own.



VI. JS-mod for creating new buttons.

JS-mod, presented in the file &quot;New\_button.js&quot; is written in JavaScript. The user must learn the rules for writing scripts and the syntax of the JavaScript language on their own.

An example of a JS mod presented in the &quot;New\_button&quot; file.js&quot;, contains unchanging part (highlighted in red font) and a modifiable  part (highlighted in green font):



/\* ћод дл€ браузера VIVALDI / Mod for the VIVALDI browser

** **** \* —оздание новых кнопок / Create new buttons**

** **** \* автор: kichrot / author: kichrot**

** **** \* 2020 г. / 2020 year**

** **** \* »спользуетс€ совместно с утилитой &quot;Vivaldi\_RUN&quot; / Used in conjunction with the &quot;Vivaldi\_run&quot; utility.**

** **** \*/**

////////////////////////////////////////////////////////////////////  Ќеизмен€ема€ часть / The unchanging part  ///////////////////////////////////////////////////////////////////////

function CreateNewButton(KEYPRESS\_NewButton, classNewButton, toolbarNewButton, titleNewButton, svgNewButton) {

** ****         function openClick() {**

** ****                 var OLD\_title = document.title;**

**   **  **        document.title = &#39;VIVALDI\_EMULATE\_KEYPRESS &#39; + KEYPRESS\_NewButton;**

**   ** **        setTimeout(**

** ** **                                () =\&gt; {**

**   **  **                                document.title = OLD\_title;**

** ** **                                }, 50);**

**   **  **}**

**   ** **function NewButton () {**

**       ** **var toolbar = document.querySelector(toolbarNewButton);**

**       ** **var outer\_div = document.createElement(&#39;div&#39;);**

**       ** **outer\_div.classList.add(&#39;button-toolbar&#39;, classNewButton);**

**       **  **outer\_div.title = titleNewButton;**

**       ** **var button = document.createElement(&#39;button&#39;);**

**       **  **button.onclick = openClick;**

**       **  **button.innerHTML = svgNewButton;**

**       ** **outer\_div.appendChild(button);**

**       ** **toolbar.appendChild(outer\_div);**

**   **  **}**

**   ** **setTimeout(function wait() {**

**       ** **var toolbar = document.querySelector(toolbarNewButton);**

**       ** **if (toolbar) {**

**           **** NewButton();**

**       **  **} else {**

**           ** **setTimeout(wait, 300);**

**       **  **}**

**   ** **}, 300);**

}

/////////////////////////////////// «авершение неизмен€емой части /  The completion of the unchanged parts ////////////////////////////////////////////////////////

/////////////////////////////////// »змен€ема€ пользователем часть / User-modifiable part /////////////////////////////////////////////////////////////////////////////////

/\*  нопка удалить данные просмотра  / Button to remove browsing data  \*/

var NewButton\_KEYPRESS = &#39; &quot;17&quot; &quot;16&quot; &quot;46&quot;&#39;;

var NewButtonClass = &#39;mod-clear-histori&#39;;

var NewButtonToolbar = &#39;.toolbar-addressbar.toolbar \&gt; .toolbar.toolbar-droptarget.toolbar-mainbar&#39;;

var NewButtonTitle = &#39;ќчистка данных браузера / Clearing browser data&#39;;

var NewButtonSvg = &#39;\&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;24&quot; height=&quot;24&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;chocolate&quot;\&gt;\&lt;path d=&quot;M18.58 0c-1.234 0-2.377.616-3.056 1.649-.897 1.37-.854 3.261-1.368 4.444-.741 1.708-3.873.343-5.532-.524-2.909 5.647-5.025 8.211-6.845 10.448 6.579 4.318 1.823 1.193 12.19 7.983 2.075-3.991 4.334-7.367 6.825-10.46-1.539-1.241-4.019-3.546-2.614-4.945 1-1 2.545-1.578 3.442-2.95 1.589-2.426-.174-5.645-3.042-5.645zm-5.348 21.138l-1.201-.763c0-.656.157-1.298.422-1.874-.609.202-1.074.482-1.618 1.043l-3.355-2.231c.531-.703.934-1.55.859-2.688-.482.824-1.521 1.621-2.331 1.745l-1.302-.815c1.136-1.467 2.241-3.086 3.257-4.728l8.299 5.462c-1.099 1.614-2.197 3.363-3.03 4.849zm6.724-16.584c-.457.7-2.445 1.894-3.184 2.632-.681.68-1.014 1.561-.961 2.548.071 1.354.852 2.781 2.218 4.085-.201.265-.408.543-.618.833l-8.428-5.548.504-.883c1.065.445 2.1.678 3.032.678 1.646 0 2.908-.733 3.464-2.012.459-1.058.751-3.448 1.206-4.145 1.206-1.833 3.964-.017 2.767 1.812zm-.644-.424c-.265.41-.813.523-1.22.257-.409-.267-.522-.814-.255-1.223.267-.409.813-.524 1.222-.257.408.266.521.817.253 1.223z&quot;/\&gt;\&lt;/svg\&gt;&#39;;

CreateNewButton(NewButton\_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/\*  нопка настроек браузера / Browser settings button  \*/

var NewButton\_KEYPRESS = &#39; &quot;17&quot; &quot;123&quot;&#39;;

var NewButtonClass = &#39;mod-open-settings&#39;;

var NewButtonToolbar = &#39;.toolbar-addressbar.toolbar \&gt; .toolbar.toolbar-droptarget.toolbar-mainbar&#39;;

var NewButtonTitle = &#39;Ќастройки браузера / Your browser settings&#39;;

var NewButtonSvg = &#39;\&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;24&quot; height=&quot;24&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;darkblue&quot;\&gt;\&lt;path d=&quot;M24 14v-4h-3.23c-.229-1.003-.624-1.94-1.156-2.785l2.286-2.286-2.83-2.829-2.286 2.286c-.845-.532-1.781-.928-2.784-1.156v-3.23h-4v3.23c-1.003.228-1.94.625-2.785 1.157l-2.286-2.286-2.829 2.828 2.287 2.287c-.533.845-.928 1.781-1.157 2.784h-3.23v4h3.23c.229 1.003.624 1.939 1.156 2.784l-2.286 2.287 2.829 2.829 2.286-2.286c.845.531 1.782.928 2.785 1.156v3.23h4v-3.23c1.003-.228 1.939-.624 2.784-1.156l2.286 2.286 2.828-2.829-2.285-2.286c.532-.845.928-1.782 1.156-2.785h3.231zm-12 2c-2.209 0-4-1.791-4-4s1.791-4 4-4 4 1.791 4 4-1.791 4-4 4z&quot;/\&gt;\&lt;/svg\&gt;&#39;;

CreateNewButton(NewButton\_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/\*  нопка полноэкранный режим / Full screen mode button \*/

var NewButton\_KEYPRESS = &#39;&quot;122&quot;&#39;;

var NewButtonClass = &#39;mod-Fullscreen&#39;;

var NewButtonToolbar = &#39;.toolbar-addressbar.toolbar \&gt; .toolbar.toolbar-droptarget.toolbar-mainbar&#39;;

var NewButtonTitle = &#39;ѕолноэкранный режим / Full screen mode&#39;;

var NewButtonSvg = &#39;\&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;24&quot; height=&quot;24&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;brown&quot;\&gt;\&lt;path d=&quot;M24 9h-2v-5h-7v-2h9v7zm-9 13v-2h7v-5h2v7h-9zm-15-7h2v5h7v2h-9v-7zm9-13v2h-7v5h-2v-7h9zm11 4h-16v12h16v-12z&quot;/\&gt;\&lt;/svg\&gt;&#39;;

CreateNewButton(NewButton\_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/\*  нопка поиск на странице / Search button on the page \*/

var NewButton\_KEYPRESS = &#39;&quot;114&quot;&#39;;

var NewButtonClass = &#39;mod-search-on-page&#39;;

var NewButtonToolbar = &#39;.toolbar-addressbar.toolbar \&gt; .toolbar.toolbar-droptarget.toolbar-mainbar&#39;;

var NewButtonTitle = &#39;ѕоиск на странице / Search on a page&#39;;

var NewButtonSvg = &#39;\&lt;svg width=&quot;24&quot; height=&quot;24&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;green&quot; xmlns=&quot;http://www.w3.org/2000/svg&quot; fill-rule=&quot;evenodd&quot; clip-rule=&quot;evenodd&quot;\&gt;\&lt;path d=&quot;M17.825 24h-15.825v-24h10.189c3.162 0 9.811 7.223 9.811 9.614v10.071l-2-2v-7.228c0-4.107-6-2.457-6-2.457s1.517-6-2.638-6h-7.362v20h11.825l2 2zm-2.026-4.858c-.799.542-1.762.858-2.799.858-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5c0 1-.294 1.932-.801 2.714l4.801 4.872-1.414 1.414-4.787-4.858zm-2.799-7.142c1.656 0 3 1.344 3 3s-1.344 3-3 3-3-1.344-3-3 1.344-3 3-3z&quot;/\&gt;\&lt;/svg\&gt;&#39;;

CreateNewButton(NewButton\_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/\*  нопка перезагрузка VIVALDI  / Restart VIVALDI button\*/

var NewButton\_KEYPRESS = &#39;&quot;0&quot;&#39;;

var NewButtonClass = &#39;mod-ReloadVIVALDI&#39;;

var NewButtonToolbar = &#39;.toolbar-addressbar.toolbar \&gt; .toolbar.toolbar-droptarget.toolbar-mainbar&#39;;

var NewButtonTitle = &#39;ѕерезагрузка VIVALDI /  Restart VIVALDI &#39;;

var NewButtonSvg = &#39;\&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;24&quot; height=&quot;24&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;red&quot;\&gt;\&lt;path d=&quot;M14 12h-4v-12h4v12zm4.213-10.246l-1.213 1.599c2.984 1.732 5 4.955 5 8.647 0 5.514-4.486 10-10 10s-10-4.486-10-10c0-1.915.553-3.694 1.496-5.211l2.166 2.167 1.353-7.014-7.015 1.35 2.042 2.042c-1.287 1.904-2.042 4.193-2.042 6.666 0 6.627 5.373 12 12 12s12-5.373 12-12c0-4.349-2.322-8.143-5.787-10.246z&quot;/\&gt;\&lt;/svg\&gt;&#39;;

CreateNewButton(NewButton\_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/\*  нопка  DevTools дл€ интерфейса VIVALDI / DevTools button for the VIVALDI interface \*/

var NewButton\_KEYPRESS = &#39; &quot;07&quot;&#39;;

var NewButtonClass = &#39;mod-DevTools\_VIVALDI&#39;;

var NewButtonToolbar = &#39;.toolbar-addressbar.toolbar \&gt; .toolbar.toolbar-droptarget.toolbar-mainbar&#39;;

var NewButtonTitle = &#39;DevTools дл€ интерфейса VIVALDI / DevTools for the VIVALDI interface&#39;;

var NewButtonSvg = &#39;\&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;16&quot; height=&quot;16&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;indigo&quot;\&gt;\&lt;path d=&quot;M0 0c2.799 1.2 8.683.955 8.307 6.371l-2.143 2.186c-5.338.093-5.239-5.605-6.164-8.557zm10.884 15.402c2.708 2.048 11.824 8.451 11.824 8.451.754.513 1.662-.417 1.136-1.162 0 0-6.607-8.964-8.719-11.619-1.668-2.101-2.502-2.175-5.46-3.046l-1.953 1.997c.936 2.931 1.033 3.76 3.172 5.379zm-4.877 3.332l2.62-2.626c-.26-.244-.489-.485-.69-.724l-2.637 2.643.707.707zm8.244-11.162l4.804-4.814 2.154 2.155-4.696 4.706c.438.525.813 1.021 1.246 1.584l6.241-6.253-4.949-4.95-6.721 6.733c.705.229 1.328.483 1.921.839zm4.837-3.366l-3.972 3.981c.24.199.484.423.732.681l3.946-3.956-.706-.706zm-9.701 12.554l-3.6 3.607-2.979.825.824-2.979 3.677-3.685c-.356-.583-.617-1.203-.859-1.904l-4.626 4.635-1.824 6.741 6.773-1.791 4.227-4.234c-1-.728-1.03-.749-1.613-1.215z&quot;/\&gt;\&lt;/svg\&gt;&#39;;

CreateNewButton(NewButton\_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

/\*  нопка восстановить закрытую вкладку / Restore closed tab button\*/

var NewButton\_KEYPRESS = &#39; &quot;17&quot; &quot;90&quot;&#39;;

var NewButtonClass = &#39;mod-restore-closed-tab&#39;;

var NewButtonToolbar = &#39;.toolbar.toolbar-tabbar.toolbar-noflex.sync-and-trash-container&#39;;

var NewButtonTitle = &#39;¬осстановить закрытую вкладку / Restore a closed tab&#39;;

var NewButtonSvg = &#39;\&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;24&quot; height=&quot;24&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;greenyellow&quot;\&gt;\&lt;path d=&quot;M13.5 2c-5.621 0-10.211 4.443-10.475 10h-3.025l5 6.625 5-6.625h-2.975c.257-3.351 3.06-6 6.475-6 3.584 0 6.5 2.916 6.5 6.5s-2.916 6.5-6.5 6.5c-1.863 0-3.542-.793-4.728-2.053l-2.427 3.216c1.877 1.754 4.389 2.837 7.155 2.837 5.79 0 10.5-4.71 10.5-10.5s-4.71-10.5-10.5-10.5z&quot;/\&gt;\&lt;/svg\&gt;&#39;;

CreateNewButton(NewButton\_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);

_The mod&#39;s unchanging part is_ _a_ _JavaScript function that creates buttons with parameters set by the user in the mod&#39;s modifiable part._

_The modifiable part of the mod consists of a set of parameter values set by the user and a call to the button creation function with these parameters for each created button._

_ **Composition and assignment of parameters for created buttons:** _

_1._ _ **New Button\_KEYPRESS** _ _variable Ч codes of virtual keys, in decimal format, that correspond to keys from the keyboard shortcut, for calling the desired browser function &quot;VIVALDI&quot;. Virtual key codes, in decimal format, can be taken from the table in Appendix 1 to this Manual, from the column_ _**&quot;Value (decimal)&quot;**__. Each virtual key code must be enclosed in double quotes, with a space between the codes. All code combinations must be enclosed in single quotes._

_Example:_

_ **var NewButton\_KEYPRESS =&#39; &quot;17&quot; &quot;16&quot; &quot;46&quot; &#39;** _

_In this example, the parameter value is set for the button that is being created_ _ **NewButton\_KEYPRESS** __, corresponding to the keyboard shortcut Ctrl+Shift+DELETE, which displays the &quot;Delete browsing data&quot; panel in the browser._

_2. The_ _ **NewButtonClass** _ _variable is the name of the class of the button being created. The class name must be unique for your &quot;VIVALDI&quot; browser instance._

_Example:_

_ **var NewButtonClass = &#39;mod-clear-histori&#39;** _

_In this example, the parameter value is set for the button that is being created   __**NewButtonClass**__ , specifies a unique class name._

_3._ _Variable   __**NewButtonToolbar -**__ ID of the &quot;VIVALDI&quot; browser panel where the created button will be placed. The ID of the &quot;VIVALDI&quot; browser panel you need can be found using the DevTools tool that is included with the &quot;VIVALDI&quot; browser._

_Example:_

_ **var NewButtonToolbar =&#39;.toolbar-addressbar.toolbar \&gt; .toolbar.toolbar-droptarget.toolbar-mainbar&#39;** _

_In this example, the parameter value is set for the button that is being created   __**NewButtonToolbar**__ ,  specifies the ID of the navigation buttons panel located to the left of the address bar, where the created button will be located._

_4. Variable_ _ **NewButtonTitle -** _ _tooltip for the button that is being created that appears when the mouse pointer is hovering over the button._

_Example:_

_ **var NewButtonTitle = &#39;Clearing browser data&#39;** _

_In this example, the parameter value is set for the button that is being created   __**NewButtonTitle**__ , sets the hint text._

_5. Variable_ _ **NewButtonSvg** _ _Ч SVG code of the icon on the created button. Collections of SVG icon codes can be found on the Internet. One of the best sites is:_ [_https://iconmonstr.com/_](https://iconmonstr.com/)

_Example:_

_ **var NewButtonSvg = &#39;\&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;24&quot; height=&quot;24&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;red&quot;\&gt;\&lt;path d=&quot;M14 12h-4v-12h4v12zm4.213-10.246l-1.213 1.599c2.984 1.732 5 4.955 5 8.647 0 5.514-4.486 10-10 10s-10-4.486-10-10c0-1.915.553-3.694 1.496-5.211l2.166 2.167 1.353-7.014-7.015 1.35 2.042 2.042c-1.287 1.904-2.042 4.193-2.042 6.666 0 6.627 5.373 12 12 12s12-5.373 12-12c0-4.349-2.322-8.143-5.787-10.246z&quot;/\&gt;\&lt;/svg\&gt;&#39;;** _

_In this example, the value of the_ _ **NewButtonSvg** _ _parameter that specifies the icon&#39;s SVG code is set for the button that is being created._

_ **The function call to create a new button:** _

_After setting the values of the parameters of the created button, it is necessary to call the function for creating a new button, which has a standard appearance in the considered JS-mode, and does not require editing by the user._

_ѕример:_

_**CreateNewButton(NewButton\_KEYPRESS, NewButtonClass, NewButtonToolbar, NewButtonTitle, NewButtonSvg);**_



VII. Implementation of &quot;non-standard&quot; buttons

The author conditionally divides the buttons implemented using the program &quot;Vivaldi\_Run&quot; into &quot;standard&quot; and &quot;non-standard&quot;.

&quot;Standard&quot; buttons pass commands to the program &quot;Vivaldi\_Run&quot; to emulate keyboard shortcuts registered in the browser &quot;VIVALDI&quot;.

&quot;Non-standard&quot; buttons are buttons that send commands to the &quot;Vivaldi\_Run&quot; program to emulate keyboard shortcuts and other actions that cannot be registered in the &quot;VIVALDI&quot; browser for various reasons.

For each &quot;non-standard&quot; button, the author assigned a parameter value _ **NewButton\_KEYPRESS** _, which is not subject to change.

The current version of the Vivaldi\_Run program provides functionality for the following &quot;non-standard&quot; buttons:

1) the reload button of the browser &quot;VIVALDI&quot;.

The assigned value _ **NewButton\_KEYPRESS=&#39; &quot;0&quot; &#39;** _

2) button to open the &quot;DevTools&quot; developer tool window for the &quot;VIVALDI&quot; browser interface.

The assigned value _ **NewButton\_KEYPRESS=&#39; &quot;0** __**7**__ **&quot; &#39;** _

_ **ATTENTION!** _

_ **To ensure the functioning of &quot;non-standard&quot; buttons, you cannot change the keyboard shortcuts for the following functions in the &quot;VIVALDI&quot; browser:** _

_ **- Insert and go** _

_ **- New tab** _

_ **- Close the tab** _



_ **Appendix 1** _

# Virtual key codes.

The following table shows the character names of constants, decimal values, and mouse or keyboard equivalents for the virtual key codes used by the system. Codes are listed in numerical order.

| Symbolic name of the constant | Value (decimal)  | Equivalent to a mouse or keyboard |
| --- | --- | --- |
| VK\_LBUTTON | 1 | Left mouse button |
| VK\_RBUTTON | 2 | Right mouse button |
| VK\_CANCEL | 3 | Control-break processing |
| VK\_MBUTTON | 4 | Middle mouse button (three-button mouse) |
| VK\_XBUTTON1 | 5 | **Windows 2000:**  X1 mouse button |
| VK\_XBUTTON2 | 6 | **Windows 2000:**  X2 mouse button |
| Ч | 7 | Undefined |
| VK\_BACK | 8 | BACKSPACE key |
| VK\_TAB | 9 | TAB key |
| Ч | 10Ц11 | Reserved |
| VK\_CLEAR | 12 | CLEAR key |
| VK\_RETURN | 13 | ENTER key |
| Ч | 14Ц15 | Undefined |
| VK\_SHIFT | 16 | SHIFT key |
| VK\_CONTROL | 17 | CTRL key |
| VK\_MENU | 18 | ALT key |
| VK\_PAUSE | 19 | PAUSE key |
| VK\_CAPITAL | 20 | CAPS LOCK key |
| VK\_KANA | 21 | IME Kana mode |
| VK\_HANGUEL | 21 | IME Hanguel mode (maintained for compatibility; use  **VK\_HANGUL** ) |
| VK\_HANGUL | 21 | IME Hangul mode |
| Ч | 22 | Undefined |
| VK\_JUNJA | 23 | IME Junja mode |
| VK\_FINAL | 24 | IME final mode |
| VK\_HANJA | 25 | IME Hanja mode |
| VK\_KANJI | 25 | IME Kanji mode |
| Ч | 26 | Undefined |
| VK\_ESCAPE | 27 | ESC key |
| VK\_CONVERT | 28 | IME convert |
| VK\_NONCONVERT | 29 | IME nonconvert |
| VK\_ACCEPT | 30 | IME accept |
| VK\_MODECHANGE | 31 | IME mode change request |
| VK\_SPACE | 32 | SPACEBAR |
| VK\_PRIOR | 33 | PAGE UP key |
| VK\_NEXT | 34 | PAGE DOWN key |
| VK\_END | 35 | END key |
| VK\_HOME | 36 | HOME key |
| VK\_LEFT | 37 | LEFT ARROW key |
| VK\_UP | 38 | UP ARROW key |
| VK\_RIGHT | 39 | RIGHT ARROW key |
| VK\_DOWN | 40 | DOWN ARROW key |
| VK\_SELECT | 41 | SELECT key |
| VK\_PRINT | 42 | PRINT key |
| VK\_EXECUTE | 43 | EXECUTE key |
| VK\_SNAPSHOT | 44 | PRINT SCREEN key |
| VK\_INSERT | 45 | INS key |
| VK\_DELETE | 46 | DEL key |
| VK\_HELP | 47 | HELP key |
|   | 48 | 0 key |
|   | 49 | 1 key |
|   | 50 | 2 key |
|   | 51 | 3 key |
|   | 52 | 4 key |
|   | 53 | 5 key |
|   | 54 | 6 key |
|   | 55 | 7 key |
|   | 56 | 8 key |
|   | 57 | 9 key |
| Ч | 58Ц64 | Undefined |
|   | 65 | A key |
|   | 66 | B key |
|   | 67 | C key |
|   | 68 | D key |
|   | 69 | E key |
|   | 70 | F key |
|   | 71 | G key |
|   | 72 | H key |
|   | 73 | I key |
|   | 74 | J key |
|   | 75 | K key |
|   | 76 | L key |
|   | 77 | M key |
|   | 78 | N key |
|   | 79 | O key |
|   | 80 | P key |
|   | 81 | Q key |
|   | 82 | R key |
|   | 83 | S key |
|   | 84 | T key |
|   | 85 | U key |
|   | 86 | V key |
|   | 87 | W key |
|   | 88 | X key |
|   | 89 | Y key |
|   | 90 | Z key |
| VK\_LWIN | 91 | Left Windows key (MicrosoftЃ NaturalЃ keyboard) |
| VK\_RWIN | 92 | Right Windows key (Natural keyboard) |
| VK\_APPS | 93 | Applications key (Natural keyboard) |
| Ч | 94 | Reserved |
| VK\_SLEEP | 95 | Computer Sleep key |
| VK\_NUMPAD0 | 96 | Numeric keypad 0 key |
| VK\_NUMPAD1 | 97 | Numeric keypad 1 key |
| VK\_NUMPAD2 | 98 | Numeric keypad 2 key |
| VK\_NUMPAD3 | 99 | Numeric keypad 3 key |
| VK\_NUMPAD4 | 100 | Numeric keypad 4 key |
| VK\_NUMPAD5 | 101 | Numeric keypad 5 key |
| VK\_NUMPAD6 | 102 | Numeric keypad 6 key |
| VK\_NUMPAD7 | 103 | Numeric keypad 7 key |
| VK\_NUMPAD8 | 104 | Numeric keypad 8 key |
| VK\_NUMPAD9 | 105 | Numeric keypad 9 key |
| VK\_MULTIPLY | 106 | Multiply key |
| VK\_ADD | 107 | Add key |
| VK\_SEPARATOR | 108 | Separator key |
| VK\_SUBTRACT | 109 | Subtract key |
| VK\_DECIMAL | 110 | Decimal key |
| VK\_DIVIDE | 111 | Divide key |
| VK\_F1 | 112 | F1 key |
| VK\_F2 | 113 | F2 key |
| VK\_F3 | 114 | F3 key |
| VK\_F4 | 115 | F4 key |
| VK\_F5 | 116 | F5 key |
| VK\_F6 | 117 | F6 key |
| VK\_F7 | 118 | F7 key |
| VK\_F8 | 119 | F8 key |
| VK\_F9 | 120 | F9 key |
| VK\_F10 | 121 | F10 key |
| VK\_F11 | 122 | F11 key |
| VK\_F12 | 123 | F12 key |
| VK\_F13 | 124 | F13 key |
| VK\_F14 | 125 | F14 key |
| VK\_F15 | 126 | F15 key |
| VK\_F16 | 127 | F16 key |
| VK\_F17 | 128H | F17 key |
| VK\_F18 | 129H | F18 key |
| VK\_F19 | 130H | F19 key |
| VK\_F20 | 131H | F20 key |
| VK\_F21 | 132H | F21 key |
| VK\_F22 | 133H | F22 key |
| VK\_F23 | 134H | F23 key |
| VK\_F24 | 135H | F24 key |
| Ч | 136Ц143 | Unassigned |
| VK\_NUMLOCK | 144 | NUM LOCK key |
| VK\_SCROLL | 145 | SCROLL LOCK key |
|   | 146Ц150 | OEM specific |
| Ч | 151Ц159 | Unassigned |
| VK\_LSHIFT | 160 | Left SHIFT key |
| VK\_RSHIFT | 161 | Right SHIFT key |
| VK\_LCONTROL | 162 | Left CONTROL key |
| VK\_RCONTROL | 163 | Right CONTROL key |
| VK\_LMENU | 164 | Left MENU key |
| VK\_RMENU | 165 | Right MENU key |
| VK\_BROWSER\_BACK | 166 | **Windows 2000:**  Browser Back key |
| VK\_BROWSER\_FORWARD | 167 | **Windows 2000:**  Browser Forward key |
| VK\_BROWSER\_REFRESH | 168 | **Windows 2000:**  Browser Refresh key |
| VK\_BROWSER\_STOP | 169 | **Windows 2000:**  Browser Stop key |
| VK\_BROWSER\_SEARCH | 170 | **Windows 2000:**  Browser Search key |
| VK\_BROWSER\_FAVORITES | 171 | **Windows 2000:**  Browser Favorites key |
| VK\_BROWSER\_HOME | 172 | **Windows 2000:**  Browser Start and Home key |
| VK\_VOLUME\_MUTE | 173 | **Windows 2000:**  Volume Mute key |
| VK\_VOLUME\_DOWN | 174 | **Windows 2000:**  Volume Down key |
| VK\_VOLUME\_UP | 175 | **Windows 2000:**  Volume Up key |
| VK\_MEDIA\_NEXT\_TRACK | 176 | **Windows 2000:**  Next Track key |
| VK\_MEDIA\_PREV\_TRACK | 177 | **Windows 2000:**  Previous Track key |
| VK\_MEDIA\_STOP | 178 | **Windows 2000:**  Stop Media key |
| VK\_MEDIA\_PLAY\_PAUSE | 179 | **Windows 2000:**  Play/Pause Media key |
| VK\_LAUNCH\_MAIL | 180 | **Windows 2000:**  Start Mail key |
| VK\_LAUNCH\_MEDIA\_SELECT | 181 | **Windows 2000:**  Select Media key |
| VK\_LAUNCH\_APP1 | 182 | **Windows 2000:**  Start Application 1 key |
| VK\_LAUNCH\_APP2 | 183 | **Windows 2000:**  Start Application 2 key |
| Ч | 184-185 | Reserved |
| VK\_OEM\_1 | 186 | **Windows 2000:**  For the US standard keyboard, the &#39;;:&#39; key |
| VK\_OEM\_PLUS | 187 | **Windows 2000:**  For any country/region, the &#39;+&#39; key |
| VK\_OEM\_COMMA | 188 | **Windows 2000:**  For any country/region, the &#39;,&#39; key |
| VK\_OEM\_MINUS | 189 | **Windows 2000:**  For any country/region, the &#39;-&#39; key |
| VK\_OEM\_PERIOD | 190 | **Windows 2000:**  For any country/region, the &#39;.&#39; key |
| VK\_OEM\_2 | 191 | **Windows 2000:**  For the US standard keyboard, the &#39;/?&#39; key |
| VK\_OEM\_3 | 192 | **Windows 2000:**  For the US standard keyboard, the &#39;`~&#39; key |
| Ч | 193Ц215 | Reserved |
| Ч | 216Ц218 | Unassigned |
| VK\_OEM\_4 | 219 | **Windows 2000:**  For the US standard keyboard, the &#39;[{&#39; key |
| VK\_OEM\_5 | 220 | **Windows 2000:**  For the US standard keyboard, the &#39;\|&#39; key |
| VK\_OEM\_6 | 221 | **Windows 2000:**  For the US standard keyboard, the &#39;]}&#39; key |
| VK\_OEM\_7 | 222 | **Windows 2000:**  For the US standard keyboard, the &#39;single-quote/double-quote&#39; key |
| VK\_OEM\_8 | 223 |   |
| Ч | 224 | Reserved |
|   | 225 | OEM specific |
| VK\_OEM\_102 | 226 | **Windows 2000:**  Either the angle bracket key or the backslash key on the RT 102-key keyboard |
|   | 227Ц228 | OEM specific |
| VK\_PROCESSKEY | 229 | **Windows 95/98, Windows NT 4.0, Windows 2000:**  IME PROCESS key |
|   | 230 | OEM specific |
| VK\_PACKET | 231 | **Windows 2000:**  Used to pass Unicode characters as if they were keystrokes. The VK\_PACKET key is the low word of a 32-bit Virtual Key value used for non-keyboard input methods. For more information, see Remark in  **KEYBDINPUT** ,  **SendInput** ,  **WM\_KEYDOWN** , and  **WM\_KEYUP** |
| Ч | 232 | Unassigned |
|   | 233Ц245 | OEM specific |
| VK\_ATTN | 246 | Attn key |
| VK\_CRSEL | 247 | CrSel key |
| VK\_EXSEL | 248 | ExSel key |
| VK\_EREOF | 249 | Erase EOF key |
| VK\_PLAY | 250 | Play key |
| VK\_ZOOM | 251 | Zoom key |
| VK\_NONAME | 252 | Reserved for future use |
| VK\_PA1 | 253 | PA1 key |
| VK\_OEM\_CLEAR | 254 | Clear key |



























_ **Appendix 2** _

PCRE library license

PCRE LICENCE

------------

PCRE is a library of functions to support regular expressions whose syntax and semantics are as close as possible to those of the Perl 5 language.

Release 7 of PCRE is distributed under the terms of the &amp;quot;BSD&amp;quot; licence, as specified below. The documentation for PCRE, supplied in the &amp;quot;doc&amp;quot; directory, is distributed under the same terms as the software itself. The basic library functions are written in C and are freestanding. Also included in the distribution is a set of C++ wrapper functions.

THE BASIC LIBRARY FUNCTIONS

---------------------------

Written by:       Philip Hazel

Email local part: ph10

Email domain:     cam.ac.uk

University of Cambridge Computing Service,

Cambridge, England.

Copyright (c) 1997-2007 University of Cambridge

All rights reserved.



THE C++ WRAPPER FUNCTIONS

-------------------------

Contributed by:   Google Inc.

Copyright (c) 2007, Google Inc.

All rights reserved.



THE &amp;quot;BSD&amp;quot; LICENCE

-----------------

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    \* Redistributions of source code must retain the above copyright notice,

      this list of conditions and the following disclaimer.

    \* Redistributions in binary form must reproduce the above copyright

      notice, this list of conditions and the following disclaimer in the

      documentation and/or other materials provided with the distribution.

    \* Neither the name of the University of Cambridge nor the name of Google

      Inc. nor the names of their contributors may be used to endorse or

      promote products derived from this software without specific prior

      written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS &amp;quot;AS IS&amp;quot;

AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE

IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE

ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE

LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR

CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF

SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS

INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN

CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)

ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE

POSSIBILITY OF SUCH DAMAGE.

End