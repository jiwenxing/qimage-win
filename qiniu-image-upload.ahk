/*
qiniu-image-tool.ahk

when writing markdown, an easier way to upload local image or screenshot to qiniu cloud and get the markdown-style 
url in clipboard as well as your current editor. actually you can upload any file by this
script.

github: https://github.com/jiwenxing/qiniu-image-tool
blog: http://jverson.com/2016/08/30/autohotkey-markdown-uploadImage/

CHANGE LOG
 2.0 -- 2017/04 -- screenshot & image copy from web both supported
 1.0 -- 2016/08 -- basic function realized, only local files supported.

powershell 脚本可以实现 https://github.com/octan3/img-clipboard-dump
修改本机powershell执行权限  http://www.cnblogs.com/zhaozhan/archive/2012/06/01/2529384.html

*/




^!L::
; config start
ACCESS_KEY = G4T2TrlRFLf2-Da-IUrHJKSbVYbJTGpcwBVFbz3D
SECRET_KEY = 0wgbpmquurY_BndFuPvDGqzlnfWHCdL8YHjz_fHJ
BUCKET_NAME = fortest  ;qiniu bucket name
BUCKET_DOMAIN = http://7xry05.com1.z0.glb.clouddn.com/  ;qiniu domain for the image
WORKING_DIR = E:\TOOLS\qiniu\  ;directory that you put the qshell.exe 
; config end

;;;;; datetime+randomNum as file name prefix
Random, rand, 1, 1000
filePrefix =  %A_yyyy%%A_MM%%A_DD%%A_Hour%%A_Min%_%rand%

MsgBox %clipboard%

if(clipboard){
    MsgBox, probably file in clipboard
	;;;;; get file type by extension
	clipboardStr = %clipboard%
	StringSplit, ColorArray, clipboardStr, `.  ;split by '.'
	maxIndex := ColorArray0  ;get array lenth
	str = ColorArray%maxIndex%  
	fileType := ColorArray%maxIndex%  ;get last element of array, namely file type or file extension
    filename = %filePrefix%.%fileType%
	; To run multiple commands consecutively, use "&&" between each
	SetWorkingDir, %WORKING_DIR% 
	RunWait, %comspec% /c qshell account %ACCESS_KEY% %SECRET_KEY% && qshell fput %BUCKET_NAME% %filename% %clipboard%
	
}else{
    MsgBox, probably binary image in clipboard
	filename = %filePrefix%.png
	fileType := "png"
	pathAndName = %WORKING_DIR%%filename%
	MsgBox, %pathAndName%
	SetWorkingDir, %WORKING_DIR%
	RunWait, %comspec% /c powershell -sta -f dump-clipboard-png.ps1 %pathAndName%  && qshell fput %BUCKET_NAME% %filename% %pathAndName% && del %pathAndName%
}

;;;;; paste markdown format url to current editor
resourceUrl = %BUCKET_DOMAIN%%filename%
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





^!K::
send hello
return
