
	states db 0
	 char1 db '|'
	char2 db '/'
	char3 db '\'
	delay0 equ 4
	delay_count db delay0

	
Timer:
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
	dec byte ptr [delay_count]		; �ݼ���������
	
	jnz end0
	
	mov byte ptr [delay_count],delay0	; ����0֮���ٸ�ֵ
	
	inc byte ptr [states]
	
	cmp byte ptr [states],1
	jz c1
	
	cmp byte ptr [states],2
	jz c2
	
	cmp byte ptr [states],3
	jz c3
	
c1:
	mov bp,offset char1
	jmp show00
c2:
	mov bp,offset char2
	jmp show00
c3:	
	mov bp,offset char3
	mov byte ptr [states],0					; ��3��״̬�����
	jmp show00
	
show00:
    mov ah,13h 	                    	;es:bp
	mov al,0                     	
	mov bl,0Fh 	                      
	mov bh,0 	                    
	mov dh,24 	                      
	mov dl,78 	                    
	mov cx,1 	                     
	int 10h 
	
	jmp end0
	
end0:
	mov al,20h			; AL = EOI
	out 20h,al			; ����EOI����8529A
	out 0A0h,al			; ����EOI����8529A
	pop ds
	pop es 
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	iret			; ���жϷ���





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
	
	push [es:34*4]	
	pop [es:26*4]
	push [es:34*4+2]
	pop [es:26*4+2]

	push [es:35*4]	
	pop [es:27*4]
	push [es:35*4+2]
	pop [es:27*4+2]
	
	push [es:36*4]	
	pop [es:28*4]
	push [es:36*4+2]
	pop [es:28*4+2]
	
	mov word ptr [es:9*4], offset myint_09		       ;װ���ж������� 
	mov ax,cs 
	mov word ptr [es:9*4+2],ax

	mov word ptr [es:33*4], offset myint_33		       
	mov ax,cs 
	mov word ptr [es:33*4+2],ax	
	
	mov word ptr [es:34*4], offset myint_34		     
	mov ax,cs 
	mov word ptr [es:34*4+2],ax	

	mov word ptr [es:35*4], offset myint_35	        
	mov ax,cs 
	mov word ptr [es:35*4+2],ax	

	mov word ptr [es:36*4], offset myint_36		       
	mov ax,cs 
	mov word ptr [es:36*4+2],ax	

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
	
	push [es:36*4]	
	pop [es:28*4]
	push [es:36*4+2]
	pop [es:28*4+2]
	
	push [es:35*4]	
	pop [es:27*4]
	push [es:35*4+2]
	pop [es:27*4+2]
	
	push [es:34*4]	
	pop [es:26*4]
	push [es:34*4+2]
	pop [es:26*4+2]
	
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
	mov dh,24 	                        ; ��
	mov dl,50 	                        ; ��
	mov cx,11 	                        ; ����
	mov bp,offset ouch
	int 10h

    ;��ʱ  dos int 15h���ܵ���  cx �� dx��ֵ��СӰ����ʱ��ʱ��

	; mov ah,86h
    ; mov cx,10h
    ; mov dx,0E999h     
    ; int 15h
	
	mov cx,20000
loop1:
	mov dx,20000				;��ʱ
	
loop2:	
	dec dx
	jnz loop2

	dec cx
	jnz loop1

	;�����ouchλ�õ��ַ���
	mov ah,6
    mov al,0
	mov ch,24
	mov cl,50
	mov dh,24
	mov dl,60
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

ouch db "OUCH! OUCH!"
clearchar db "xxxxxxxxxxx"





myint_33:
	mov ax,1
	push ax
	call _loadp
	pop ax
	iret
myint_34:
	mov ax,2
	push ax
	call _loadp
	pop ax
	iret
myint_35:
	mov ax,3
	push ax
	call _loadp
	pop ax
	iret
myint_36:
	mov ax,4
	push ax
	call _loadp
	pop ax
	iret

	