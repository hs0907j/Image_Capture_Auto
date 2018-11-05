#SingleInstance force
;#Include OCR.ahk
#Include captureScreen.ahk

s1path=%A_Temp%\j_s1.PNG
s2path=%A_Temp%\j_s2.PNG
s3path=%A_Temp%\j_s3.PNG
s4path=%A_Temp%\j_s4.PNG

FileInstall, s1.PNG, %s1path%, 1
FileInstall, s2.PNG, %s2path%, 1
FileInstall, s3.PNG, %s3path%, 1
FileInstall, s4.PNG, %s4path%, 1

Gui, add, Text, x30 y15 w100 h42, ������ ��� = F1
Gui, add, Text, x200 y15 w80 h20, ���� ��ǥ �Է�
Gui, add, Text, x200 y33 w80 h20, ���� ��� = F5
Gui, add, Text, x200 y46 w80 h20, ���� �ϴ� = F6
Gui, add, Text, x188 y59 w100 h20, ���� ������ = F7
Gui, add, Text, x212 y72 w70 h20, ���� ȭ = F8

Gui, add, Text, x188 y100 w95 h20, ������ ���� = F9
Gui, add, Text, x30 y45 w100 h20, ��ǥ ��Ī = F2
Gui, add, Text, x30 y75 w100 h20, �ܱ� ���� = F3
Gui, add, Text, x30 y107 w100 h20, ���� �� ȭ�� :
Gui, add, Edit, x120 y105 w30 h20 vwanna_chap, 0
Gui, add, Text, x30 y137 w100 h20, �۵� �ӵ�     :
Gui, add, Edit, x120 y135 w30 h20 vwanna_speed, 100
Gui, add, Button, x225 y165 w50 h20 gEnd, ����
Gui, add, Text, x200 y195 w75 h20, �Ͻ����� = F4
Gui, add, Text, x5 y210 w120 h15, �۾� �Ϸ� ���� ���     
GUI, add, Checkbox, x5 y225 w10 h20 vsound1,
Gui, add, Button, x25 y222 w100 h20 gDir, ������ġ
Gui, add, Text, x205 y220 w70 h20, made by JHS
Gui, show

IniRead, soundDir, preset.ini, preset, soundDir
return

GuiClose:
 ExitApp


f1:: ; ������ ���.

IniRead, next_page_x, preset.ini, preset, next_page_x
IniRead, next_page_y, preset.ini, preset, next_page_y
IniRead, next_chapter_x, preset.ini, preset, next_chapter_x
IniRead, next_chapter_y, preset.ini, preset, next_chapter_y
IniRead, luX, preset.ini, preset, luX
IniRead, luY, preset.ini, preset, luY
IniRead, rdX, preset.ini, preset, rdX
IniRead, rdY, preset.ini, preset, rdY

if ((next_page_x = "ERROR") 
    |(next_page_y = "ERROR")
    |(next_chapter_x = "ERROR")
    |(next_chapter_y = "ERROR")
    |(luX = "ERROR")
    |(luY = "ERROR")
    |(rdX = "ERROR")
    |(rdY = "ERROR")) {
 MsgBox, ������ ���� �� ������ �������մϴ�. ���� ��ǥ�� ��Ī���ּ���.
}
else {
 MsgBox, ������ �б� ����
}

return

f2:: ; ��ǥ ��Ī.

ImageSearch,next_page_x,next_page_y, 0,0, A_ScreenWidth, A_ScreenHeight, *50 %s1path% ; ���� ��
IF ErrorLevel = 0
{
 next_page_x:=next_page_x+20
 next_page_y:=next_page_y+20
}
IF ErrorLevel = 1
{
 Msgbox, Fail
 return
}

ImageSearch,next_chapter_x,next_chapter_y, 0,0, A_ScreenWidth, A_ScreenHeight, *50 %s2path% ; ���� ȭ
IF ErrorLevel = 0
{
 next_chapter_x:=next_chapter_x+20
 next_chapter_y:=next_chapter_y+20
}
IF ErrorLevel = 1
{
 Msgbox, Fail
 return
}

ImageSearch,luX,luY, 0,0, A_ScreenWidth, A_ScreenHeight, *50 %s3path% ; �ؽ�Ʈ �»�� ��ǥ
IF ErrorLevel = 1
{
 Msgbox, Fail
 return
}
IF ErrorLevel = 0 
{
 luX:=luX+10
 luY:=luY+20
}
ImageSearch,rdX,rdY, 0,0, A_ScreenWidth, A_ScreenHeight, *50 %s4path% ; �ؽ�Ʈ ���ϴ� ��ǥ
IF ErrorLevel = 1
{
 Msgbox, Fail
 return
}

 Msgbox, ��ǥ ��Ī �Ϸ�.
 IniWrite, %next_page_x%, preset.ini, preset, next_page_x
 IniWrite, %next_page_y%, preset.ini, preset, next_page_y
 IniWrite, %next_chapter_x%, preset.ini, preset, next_chapter_x
 IniWrite, %next_chapter_y%, preset.ini, preset, next_chapter_y
 IniWrite, %luX%, preset.ini, preset, luX
 IniWrite, %luY%, preset.ini, preset, luY
 IniWrite, %rdX%, preset.ini, preset, rdX
 IniWrite, %rdY%, preset.ini, preset, rdY
Return




f3:: ; ����

Gui, Submit, NoHide

if (wanna_speed > 10000)
 wanna_speed:=100

FileCreateDir, %A_ScriptDir%\captured\

num_chapter=1
num_page=0

Sleep 100
Loop, %wanna_chap%
{
    sleep 1000
    Loop, 500
    {
        ImageSearch,vx,vy, luX-10, luY-10, rdX+10, rdY+10, *50 %sFileTo%
        IF ErrorLevel = 0
        {
          num_page=0
          break
        }
        sleep wanna_speed
        
        sFileTo=%A_ScriptDir%\captured\
        sFileTo2=%num_chapter%_%num_page%
        sFileTo3=.jpg
        sFileTo=%sFileto%%sFileTo2%%sFileTo3%
        num_page++
        
        CaptureScreen(luX "," luY "," rdX "," rdY , 0, sFileTo, "100") 
        ;Sleep 100

        MouseClick, Left, %next_page_x%, %next_page_y%, 1
        Sleep wanna_speed
    }
    sleep 50
    MouseClick, Left, %next_chapter_x%, %next_chapter_y%, 1
    num_chapter++
}

if (sound1)
 SoundPlay, %soundDir%

else
 SoundBeep, 2000, 1000

MsgBox, ���� �Ϸ�.
return

f4::Pause

return

f5::
MouseGetPos, luX, luY
return

f6::
MouseGetPos, rdX, rdY
rdX:=rdX-20
rdY:=rdY-20
return

f7::
MouseGetPos, next_page_x, next_page_y
return

f8::
MouseGetPos, next_chapter_x, next_chapter_y
return

f9::
 if ((next_page_x = "") 
    |(next_page_y = "")
    |(next_chapter_x = "")
    |(next_chapter_y = "")
    |(luX = "")
    |(luY = "")
    |(rdX = "")
    |(rdY = "")) {
 MsgBox, ��ǥ ������ ���� ���� �ʾҽ��ϴ�.
}
else {
 MsgBox, ������ ���� ����
}

 IniWrite, %next_page_x%, preset.ini, preset, next_page_x
 IniWrite, %next_page_y%, preset.ini, preset, next_page_y
 IniWrite, %next_chapter_x%, preset.ini, preset, next_chapter_x
 IniWrite, %next_chapter_y%, preset.ini, preset, next_chapter_y
 IniWrite, %luX%, preset.ini, preset, luX
 IniWrite, %luY%, preset.ini, preset, luY
 IniWrite, %rdX%, preset.ini, preset, rdX
 IniWrite, %rdY%, preset.ini, preset, rdY

return
/*
f5::
 widthToScan=200
 heightToScan=50

 MouseGetPos, mouseX, mouseY
 topLeftX := mouseX
 topLeftY := mouseY

 ;MsgBox, %topLeftY%
 options:=""
 options.=" numeric"

 ;NOTE: this is where the magical OCR function is called
 ;magicalText := GetOCR(topLeftX, topLeftY, widthToScan, heightToScan, options)
 magicalText := GetOCR(0, 0, 10, 10)

 MsgBox, ���
 MsgBox, %magicalText%
 ;MsgBox, test
 sleep, 100
 
return
*/


Shift::
 ExitApp
  
Dir:
 fileselectfile, soundDir
 IniWrite, %soundDir%, preset.ini, preset, soundDir
 
 return
End:
 ExitApp