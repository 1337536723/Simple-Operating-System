   org 0a500h
message db ' SYSU' 

start:
	xor ax,ax					; AX = 0   ������ص�0000��100h������ȷִ��
    mov ax,cs					; ������Щ�Ĵ�����Ϊ0
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; �ı������Դ���ʼ��ַ
	mov	gs,ax					; GS = B800h
 
    mov bp,message  ;
    mov ah,13h      ;��teletypeģʽ����ʾ�ַ���
    mov al,1   		;��ʾ�ַ����н������ַ������������ԣ�������BL�У��ƶ����
    mov bl,0   		;���Գ�ʼֵ
    mov bh,0  		;ҳ��
    mov dh,12   	;��12�п�ʼ


    mov cx,12   	;ѭ��12��

loop1: 			    ;���ѭ��

    push cx   		;����
    mov dl,0  		;���ԣ���
    mov cx,8  		;ѭ��8��
	
	push cx
	push dx
	push ax			;int 13h
	mov ah,86h
    mov cx,01h
    mov dx,0x8480     
    int 15h 
	pop ax		
	pop dx
	pop cx
	
loop2:        	    ;�ڲ�ѭ��
    push cx   		;����
    mov cx,5  		;�ַ�������
    int 10h  		;BIOS�жϵ���
    inc bl    		;����ֵ����1
    add dl,5  		;��ֵ����5 
    pop cx
    loop loop2 	    ;�ڲ�ѭ��

    pop cx
    inc dh    		;�ı��У�������1  
    loop loop1  	;���ѭ��


	mov ah,86h
    mov cx,10h
    mov dx,0x8480     
    int 15h 

	
	jmp 7c00h
	
times 510-($-$$) db 0
    db 0x00,0x00