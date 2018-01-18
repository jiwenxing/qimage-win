/*
qiniu-image-tool.ahk

a small tool that help you upload local image or screenshot to qiniu cloud and get the markdown-style 
url in clipboard as well as your current editor. actually you can upload any file by this script.

github: https://github.com/jiwenxing/qimage-win

CHANGE LOG
 2.1 -- 2018/01 -- add an optional config to support user-defined qiniu image style
 2.0 -- 2017/04 -- screenshot & image copy from web both supported
 1.0 -- 2016/08 -- basic function realized, only local files supported.

*/



^!V::

	IfExist, .\settings.ini
	 {
	 IniRead, ACCESS_KEY, .\settings.ini, settings, ACCESS_KEY
	 IniRead, SECRET_KEY, .\settings.ini, settings, SECRET_KEY
	 IniRead, BUCKET_NAME, .\settings.ini, settings, BUCKET_NAME
	 IniRead, BUCKET_DOMAIN, .\settings.ini, settings, BUCKET_DOMAIN
	 IniRead, UP_HOST, .\settings.ini, settings, UP_HOST
	 IniRead, DEBUG_MODE, .\settings.ini, settings, DEBUG_MODE
	 IniRead, STYLE_SUFFIX, .\settings.ini, settings, STYLE_SUFFIX
	 }
	else 
	 {
	 MsgBox settings.ini not found.
     return
     }

    BUCKET_DOMAIN = %BUCKET_DOMAIN%/
    WORKING_DIR = %A_ScriptDir%\
    if(STYLE_SUFFIX!="")
        STYLE_SUFFIX = ?%STYLE_SUFFIX%


	;;;; datetime+randomNum as file name prefix
	Random, rand, 1, 1000
	filePrefix =  %A_yyyy%%A_MM%%A_DD%%A_Hour%%A_Min%_%rand%
    isDebug = /c
    if(DEBUG_MODE="true")
        isDebug = /k

	;MsgBox %clipboard%
    

	if(clipboard){
	    ;MsgBox, probably file in clipboard
		;;;;; get file type by extension
		clipboardStr = %clipboard%
		StringSplit, ColorArray, clipboardStr, `.  ;split by '.'
		maxIndex := ColorArray0  ;get array lenth
		str = ColorArray%maxIndex%  
		fileType := ColorArray%maxIndex%  ;get last element of array, namely file type or file extension
	    filename = %filePrefix%.%fileType%
		; To run multiple commands consecutively, use "&&" between each
		SetWorkingDir, %WORKING_DIR% 
		RunWait, %comspec% %isDebug% qshell account %ACCESS_KEY% %SECRET_KEY% && qshell fput %BUCKET_NAME% %filename% %clipboard% %UP_HOST%
		
	}else{
	    ;MsgBox, probably binary image in clipboard
		filename = %filePrefix%.png
		fileType := "png"
		pathAndName = %WORKING_DIR%%filename%
		;MsgBox, %pathAndName%
		SetWorkingDir, %WORKING_DIR%
		; here, thanks for https://github.com/octan3/img-clipboard-dump
		RunWait, %comspec% %isDebug% powershell set-executionpolicy remotesigned && powershell -sta -f dump-clipboard-png.ps1 %pathAndName%  && qshell account %ACCESS_KEY% %SECRET_KEY% && qshell fput %BUCKET_NAME% %filename% %pathAndName% %UP_HOST% && del %pathAndName%
	}

	;;;; paste markdown format url to current editor
	resourceUrl = %BUCKET_DOMAIN%%filename%%STYLE_SUFFIX%
	;MsgBox, %resourceUrl%
	; if image file
	if(fileType="jpg" or fileType="png" or fileType="gif" or fileType="bmp" or fileType="jpeg"){
		resourceUrl = ![](%resourceUrl%)
	}
	;MsgBox, %resourceUrl%
	clipboard =  ; Empty the clipboard.
	clipboard = %resourceUrl%

	;MsgBox %clipboard%
	Send ^v

return



