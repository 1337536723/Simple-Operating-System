﻿
extern  macro %1    ;统一用extern导入外部标识符
	extrn %1
endm


extern _cmain:near

.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
DGROUP group _TEXT,_DATA,_BSS
org 100h


start:
		
	mov word ptr [es:20h], offset Timer		        ; int 8H定时器
	mov ax,cs 
	mov word ptr [es:22h],ax		
		
		mov ax,cs
		mov ds,ax; DS = CS
		mov es,ax; ES = CS
		mov ss,ax; SS = cs
		
		mov sp, 100h    
		
		call near ptr _cmain
    	jmp $	


		include setint.asm	
		include syscll.asm
	
		



_TEXT ends

_DATA segment word public 'DATA'

_DATA ends

_BSS	segment word public 'BSS'
_BSS ends

end start
