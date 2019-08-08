extrn _Current_Process
extrn _Save_Process
extrn _Schedule
extrn _Have_Program
extrn _special
extrn _Program_Num
extrn _CurrentPCBno
extrn _Segment


Finite dw 0
Timer:
;*****************************************
;*                Save                   *
; ****************************************
    cmp word ptr[_Program_Num],0	; ����Ƿ��г���Ҫ����
	jnz Save						; ����У��ͱ��������ݣ�����Ӧ�Ĳ���
	jmp No_Progress					; ���û�У���ȥִ�з���ֳ���
Save:
	inc word ptr[Finite]			; ����Ƿ��Ѵﵽ���д���������
	cmp word ptr[Finite],120		;
	jnz Pass_agru 					; û�оʹ��Σ�����PCB.H�е�save��������������
    mov word ptr[_CurrentPCBno],0	; ��1600�ε�����ɺ󣬽�_CurrentPCBno��0�������ں˳���
	mov word ptr[Finite],0			; ���¼���
	mov word ptr[_Program_Num],0	; ��ǰ�����Ϊ0
	mov word ptr[_Segment],1000h	; ����ȷ��˳����ȷ
	jmp Pre							; ׼�����ݣ�׼���ָ�����
Pass_agru:							; ����
    push ss
	push ax
	push bx
	push cx
	push dx
	push sp	 	;sp�Ѿ����ı䣬�����sp����
				;cs��ip��flags + ǰ5��push������Ҫ+16��������ջ�����������
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process		;����timerʱ��ԭcs��ip��flag����ջ�У�����save()����
	call near ptr _Schedule 		;���������ݣ�����schedule()����
	
Pre:
	mov ax, cs						
	mov ds, ax
	mov es, ax
	
	call near ptr _Current_Process	; �õ����ڽ�Ҫ���еĽ��̵�PCB��ַ
	mov bp, ax						; Current_Process����ʼ��ַ

	mov ss,word ptr ds:[bp+0]  		; Current_Process��ջ      
	mov sp,word ptr ds:[bp+16]		; Current_Process��sp

	cmp word ptr ds:[bp+32],0 		; new?
	jnz No_First_Time				; ������ǵ�һ�����У���Ҫ����sp

;*****************************************
;*                Restart                *
; ****************************************
Restart:
    call near ptr _special
	
	push word ptr ds:[bp+30]		;flag
	push word ptr ds:[bp+28]		;cs
	push word ptr ds:[bp+26]		;ip
	
									;ss   	��ǰ���Ѿ����⴦����
	push word ptr ds:[bp+2]			;gs
	push word ptr ds:[bp+4]			;fs
	push word ptr ds:[bp+6]			;es
	push word ptr ds:[bp+8]			;ds
	push word ptr ds:[bp+10]		;di
	push word ptr ds:[bp+12]		;si
	push word ptr ds:[bp+14]		;bp		
									;sp		��ǰ����ˣ�������Ҫ��������������
	push word ptr ds:[bp+18]		;dx
	push word ptr ds:[bp+20]		;cx
	push word ptr ds:[bp+22]		;bx
	push word ptr ds:[bp+24]		;ax

	pop ax
	pop bx
	pop cx
	pop dx
	pop bp
	pop si
	pop di
	pop ds
	pop es
	.386
	pop fs
	pop gs
	.8086

	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret

No_First_Time:	
	add sp,16 		;����
	jmp Restart
	
No_Progress:
    call another_Timer
	
	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret
	

another_Timer:
    push ax
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
	mov ax,cs
	mov ds,ax

	cmp byte ptr [ds:count],0
	jz case1
	cmp byte ptr [ds:count],1
	jz case2
	cmp byte ptr [ds:count],2
	jz case3
	
case1:	
    inc byte ptr [ds:count]
	mov al,'/'
	jmp show
case2:	
    inc byte ptr [ds:count]
	mov al,'\'
	jmp show
case3:	
    mov byte ptr [ds:count],0
	mov al,'|'
	jmp show
	
show:
    mov bx,0b800h
	mov es,bx
	mov ah,0ah
	mov es:[((80*24+78)*2)],ax
	
	pop ax
	mov ds,ax
	pop ax
	mov es,ax
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	ret

	count db 0




public _setMyInt
_setMyInt proc

	push ax		
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
	xor ax,ax
	mov es,ax
	push [es:9*4]									;�����жϣ���������ָ�
	pop [es:24*4]
	push [es:9*4+2]
	pop [es:24*4+2]
	
	push [es:33*4]	
	pop [es:25*4]
	push [es:33*4+2]
	pop [es:25*4+2]
	
	
	mov word ptr [es:33*4], offset myint_21		       ;װ���ж������� 
	mov ax,cs 
	mov word ptr [es:33*4+2],ax
	
	
	mov word ptr [es:9*4], offset myint_09		       ;װ���ж������� 
	mov ax,cs 
	mov word ptr [es:9*4+2],ax



	pop ds
	pop es 
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	ret

_setMyInt endp


public _resetInt
_resetInt proc

	push ax		
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
	xor ax,ax
	mov es,ax
	push [es:24*4]			; �ָ����޸ĵ��ж�
	pop [es:9*4]
	push [es:24*4+2]
	pop [es:9*4+2]
	
	push [es:33*4]	
	pop [es:25*4]
	push [es:33*4+2]
	pop [es:25*4+2]

	pop ds
	pop es 
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	ret

_resetInt endp


myint_09:
    mov ah,4
	int 21h
	iret

	
myint_21:
	
	STI
	cmp ah,0
	jz helpJumpFun0
	
	cmp ah,1
	jz helpJumpFun1

	cmp ah,2
	jz helpJumpFun2

	cmp ah,3
	jz helpJumpFun3
	
	cmp ah,4
	jz helpJumpFun4
	
	cmp ah,5
	jz helpJumpFun5
	
	cmp ah,6
	jz helpJumpFun6

	cmp ah,7
	jz helpJumpFun7
	
	cmp ah,8
	jz helpJumpFun8
	
helpJumpFun0:
	jmp fun0
	
helpJumpFun1:
	jmp fun1
	
helpJumpFun2:
	jmp fun2

helpJumpFun3:
	jmp fun3

helpJumpFun4:
	jmp fun4
	
helpJumpFun5:
	jmp fun5

helpJumpFun6:
	jmp fun6

helpJumpFun7:
	jmp fun7

helpJumpFun8:
	jmp fun8

fun0:
	push ax								
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	
    mov ah,13h 	                        ; ���ܺ�
	mov al,0                     		; ��귵����ʼλ��
	mov bl,0Eh 	                        ; 0000���ڵס�1111��������
	mov bh,0 	                    	; 
	mov dh,6 	                        ; ��
	mov dl,10 	                        ; ��
	mov cx,25 	                        ; ����
	mov bp,offset hello0
	int 10h

	mov cx,60000
loop01:
	mov dx,60000				;��ʱ
	
loop02:	
	dec dx
	jnz loop02

	dec cx
	jnz loop01


	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

hello0 db "OS OS OS!!!! AH=0 int 21h"

	
fun1:
	push ax								
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	
    mov ah,13h 	                        ; ���ܺ�
	mov al,0                     		; ��귵����ʼλ��
	mov bl,0Eh 	                        ; 0000���ڵס�1111��������
	mov bh,0 	                    	; 
	mov dh,6 	                        ; ��
	mov dl,50 	                        ; ��
	mov cx,27 	                        ; ����
	mov bp,offset hello1
	int 10h
	
	mov cx,60000
loop11:
	mov dx,60000				;��ʱ
	
loop12:	
	dec dx
	jnz loop12

	dec cx
	jnz loop11


	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

hello1 db "HELLO! WELCOME! 1st int 21h"

	
fun2:
	
	push ax								
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	
    mov ah,13h 	                        ; ���ܺ�
	mov al,0                     		; ��귵����ʼλ��
	mov bl,0Eh 	                        ; 0000���ڵס�1111��������
	mov bh,0 	                    	; 
	mov dh,18	                        ; ��
	mov dl,10 	                        ; ��
	mov cx,24 	                        ; ����
	mov bp,offset hello2
	int 10h

	mov cx,60000
loop21:
	mov dx,60000				;��ʱ
	
loop22:	
	dec dx
	jnz loop22

	dec cx
	jnz loop21
	

	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

hello2 db "OS SUCKS!!!! 2ed int 21h"

	
fun3:
	
		
	push ax								
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	
    mov ah,13h 	                        ; ���ܺ�
	mov al,0                     		; ��귵����ʼλ��
	mov bl,0Eh 	                        ; 0000���ڵס�1111��������
	mov bh,0 	                    	; 
	mov dh,18 	                        ; ��
	mov dl,50 	                        ; ��
	mov cx,22 	                        ; ����
	mov bp,offset hello3
	int 10h

	mov cx,60000
loop31:
	mov dx,60000				;��ʱ
	
loop32:	
	dec dx
	jnz loop32

	dec cx
	jnz loop31
	

	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

hello3 db "TEST TEST! 3rd int 21h"

fun4:

	;int 09ʵ��
	;�����ֳ�
    push ax								
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	
    mov ah,13h 	                        ; ���ܺ�
	mov al,0                     		; ��귵����ʼλ��
	mov bl,0Eh 	                        ; 0000���ڵס�1111��������
	mov bh,0 	                    	; 
	mov dh,23 	                        ; ��
	mov dl,50 	                        ; ��
	mov cx,23	                        ; ����
	mov bp,offset ouch
	int 10h

	
	mov cx,20000
loop1:
	mov dx,12000				;��ʱ
	
loop2:	
	dec dx
	jnz loop2

	dec cx
	jnz loop1

	;�����ouchλ�õ��ַ���
	mov ah,6
    mov al,0
	mov ch,23				;
	mov cl,50				;��ʼ��
	mov dh,23
	mov dl,73				;�����
	mov bh,7
	int 10H
    
	
    in al,60h
	mov al,20h					    ; AL = EOI
	out 20h,al						; ����EOI����8529A
	out 0A0h,al					    ; ����EOI����8529A

	
;��ԭ�ֳ�
	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

ouch db "OUCH! OUCH! From int21h"
clearchar db "xxxxxxxxxxx"


fun5:
	call _cls
	iret

fun6:
	call _printChar
	iret

fun7:
	call _getChar
	iret

fun8:			;shutdown
    mov        ax, 2001h
    mov        dx, 1004h
    out        dx,ax
    iret