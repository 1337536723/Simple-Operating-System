    org 0a700h					; ������ص�100h������������COM
start:
	xor ax,ax					; AX = 0   ������ص�0000��100h������ȷִ��
    mov ax,cs					; ������Щ�Ĵ�����Ϊ0
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; �ı������Դ���ʼ��ַ
	mov	gs,ax					; GS = B800h
	
	mov cx,11					;��ʾ����
	mov ax, str0
	mov si,ax
	mov bp,2160					;2���ֽ�
row1:
	push cx
	mov cx,40					;һ�е��ַ���
	
char1:	
	mov ah,4Fh					;
	mov al,[si]					;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov word[gs:bp],ax
	inc si
	add bp,2
	loop char1
	
	add bp,80			;(80-�ַ���)*2
	pop cx
	loop row1
	
	mov ah,86h
    mov cx,2ah
    mov dx,4240h     
    int 15h

	jmp 7C00h
	
datadef:
str0 db "                  _oo0oo_               "                  
str1 db "                 o8888888o              "                 
str2 db "  17341189       88' . '88              "                 
str3 db "    Yao         (|  - -  |)             "             
str4 db "    Sen          0\  =  /0              "
str5 db "    Jian       ___/`---'\___            "
str6 db "             .' \\|  :  |// '.          "
str8 db "           / _||||| /:\ |||||- \        "
strq db "          | \_|  ''\---/''  |_/ |       "
stri db "                                        "
strp db " ~~The buddha bless you away from bugs~~"         
times 510-($-$$) db 0
    db 0x00,0x00
    
