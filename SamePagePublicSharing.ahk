;===================================================
;====Global Variable Definition=======
;===================================================
scrolcount := 0

X = 0
Y = 0
Path = %A_WorkingDir%\images\
Current_Window_Title = ''
Close_Window_Title = ''
Team_Page_Name = ''


;===================================================
;==== Main Area ====================================
;===================================================
;URL = "https://samepage.io/app/#!/0f86323939f7cf92b91dba5b86926961fdae11e8/page-599581876390291951"

Array := ["https://samepage.io/app/#!/0f86323939f7cf92b91dba5b86926961fdae11e8/page-599582628009568906", "https://samepage.io/app/#!/0f86323939f7cf92b91dba5b86926961fdae11e8/page-599582679549176464"]

;Array.Push(URL)

for index, element in Array
{
	PublicSharingOn(element)
    ;MsgBox % "Element number " . index . " is " . element
	;ExitApp
}





;===================================================
;==== Calling Main Function=========================
;===================================================
PublicSharingOn(URL)
{

	;===================================================
	;====Run Chrome in Maximize Mode and Open URL=======
	;===================================================
	Run chrome.exe %URL%
	WinMaximize ahk_exe chrome.exe

	;while (A_Cursor = "AppStarting")
	;	continue

	;Wait a bit
	sleep 5000

	;===================================================
	;====Search Team Page Name and save it.=============
	;===================================================
	Path = %A_WorkingDir%\images\Seladigital_icon.png
	imageFound := FoundImage(Path,X,Y)
	if imageFound = true
	{
		MouseClickDrag, left, X+120, Y, X+470, Y, 5
		Clipboard =
		Send, ^c
		ClipWait, 0.1
		Sleep, 100
		Team_Page_Name = %Clipboard%
		;MsgBox, %Team_Page_Name%
		;ExitApp
	}
	;===================================================
	;====Search and Move to First Loc image=============
	;===================================================
	Path = %A_WorkingDir%\images\lock_blue.png
	imageFound := FoundImage(Path,X,Y)


	if imageFound = true
	{
		MouseMove, X, Y, 10
		MouseClick, left, X, Y
		sleep 1000
		;send {WheelDown 1}

		;Get Current Window Title for saving along URL
		WinGetTitle, Current_Window_Title, A
		Close_Window_Title = %Current_Window_Title%
		StringSplit, word_array, Current_Window_Title, "-"
		Current_Window_Title = %word_array1%
		;MsgBox, The active window is "%word_array1%".
	}
	else
	{
		ExitApp
	}

	;Wait a bit
	sleep 2000

	;===================================================
	;====If already Public Shared Exit=========
	;===================================================

	Path = %A_WorkingDir%\images\alreadyshared.png
	imageFound := FoundPublicShareImage(Path,X,Y)

	if imageFound = true
	{
		; No need for execution of public sharing activity
		;MsgBox Already Publically Shared
		
		;TODO: Just Save Public URL
		MouseMove, X, Y, 10
		MouseClick, left, X+10, Y+10
		sleep 1000

		;Copy the Link to URL.txt File and Close Window
		CopySharedLink(Close_Window_Title,Current_Window_Title,Team_Page_Name)
		
		return
		;Goto, MyLabel
	}


	;===================================================
	;====Search and Move to page settings image=========
	;===================================================

	Path = %A_WorkingDir%\images\settings.png

	imageFound := FoundImage(Path,X,Y)

	if imageFound = true
	{
		MouseMove, X, Y, 10
		MouseClick, left, X+70, Y+15
	}
	else
	{
		ExitApp
	}


	;========================================
	; Search and Move to share ...
	;========================================
	;Wait a bit
	sleep 2000

	Path = %A_WorkingDir%\images\share.png

	imageFound := FoundImage(Path,X,Y)

	if imageFound = true
	{
		MouseMove, X, Y, 10
		MouseClick, left, X+70, Y+15
	}
	else
	{
		ExitApp
	}

	;========================================
	;Search and Move to with specific people
	;========================================
	;Wait a bit
	sleep 1000


	Path = %A_WorkingDir%\images\withspecificpeople.png

	imageFound := FoundImage(Path,X,Y)

	if imageFound = true
	{
		MouseMove, X, Y, 10
	}
	else
	{
		ExitApp
	}

	;========================================
	;Search and Move to via public click
	;========================================

	Path = %A_WorkingDir%\images\viapubliclink.png

	imageFound := FoundImage(Path,X,Y)

	if imageFound = true
	{
		MouseMove, X, Y, 10
		MouseClick, left, X+70, Y+15
	}
	else
	{
		ExitApp
	}

	;==================================================
	;Search and Move to via public share off/on button
	;==================================================

	;Wait a bit
	sleep 1000

	Path = %A_WorkingDir%\images\publicshare.png

	imageFound := FoundImage(Path,X,Y)

	if imageFound = true
	{
		MouseMove, X, Y, 10
		MouseClick, left, X+50, Y+15
	}
	else
	{
		ExitApp
	}

	CopySharedLink(Close_Window_Title,Current_Window_Title,Team_Page_Name)

	return

	;MyLabel:
	;	MsgBox Done
	;	ExitApp
}

CopySharedLink(Close_Window_Title,Current_Window_Title,Team_Page_Name)
{
	;================================
	;Search and Move to URL
	;================================

	;Wait a bit
	sleep 1000

	Path = %A_WorkingDir%\images\urlshare.png

	imageFound := FoundImage(Path,X,Y)

	if imageFound = true
	{
		MouseMove, X, Y, 10
		MouseClick, left, X, Y+50
		; Copy Selected Text and Save in URLs.txt
		Clipboard =
		Send, ^c
		ClipWait, 0.1
		Sleep, 100

		;Save URL in File 'URLs.txt'
		FileAppend, %Team_Page_Name%|%Current_Window_Title%|%Clipboard%`n, %A_WorkingDir%\images\URLs.txt
	}
	else
	{
		ExitApp
	}

	;================================
	;Search and Move to Close Image
	;================================

	Path = %A_WorkingDir%\images\close.png

	imageFound := FoundImage(Path,X,Y)

	if imageFound = true
	{
		MouseMove, X, Y, 10
		MouseClick, left, X+5, Y+5
	}
	else
	{
		ExitApp
	}

	;WinGetTitle, Close_Window_Title, A
	sleep 2000

	IfWinExist, %Close_Window_Title%
	{
		WinActivate, %Close_Window_Title%
		Send {ctrl down}w{ctrl up}
	}
}

FoundImage(Path, ByRef X, ByRef Y)
{
	;reset X and Y
	X = 0
	Y = 0
	result = true

	ImageSearch, X, Y, 0,0, A_ScreenWidth, A_ScreenHeight, %Path%
	; On Error
	if ErrorLevel = 1
	{
	  result = false
	  MsgBox Image not Found
	}
	else if ErrorLevel = 2
	{
	  result = false
	  MsgBox Could not conduct the search.
	}

	return result
}

FoundPublicShareImage(Path, ByRef X, ByRef Y)
{
	;reset X and Y
	X = 0
	Y = 0
	result = true

	ImageSearch, X, Y, 0,0, A_ScreenWidth, A_ScreenHeight, %Path%
	; On Error
	if ErrorLevel = 1
	{
	  result = false
	}
	else if ErrorLevel = 2
	{
	  result = false
	  MsgBox Could not conduct the search.
	}

	return result
}
