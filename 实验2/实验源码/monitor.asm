;����Դ���루myos1.asm��
org  7c00h		
OffSetOfUserPrg1 equ 0A100h

start:
	mov	ax, cs	       ; �������μĴ���ֵ��CS��ͬ
	mov	ds, ax	       ; ���ݶ�
	
	mov ax,0600h				;�崰��
    mov ch,0					;���Ͻ���					
    mov cl,0					;���Ͻ���	
    mov dh,24					;������		
    mov dl,79					;������
    mov bx,0007h				;�ڵװ�
    int 10h
	
	
	; ; pop cx				;��ʱ������
	; push cx
	; mov ah,86h
    ; mov cx,10h
    ; mov dx,0x8480     
    ; int 15h 
	; pop cx 
	
	mov	bp, Message		 	; BP=��ǰ����ƫ�Ƶ�ַ
	mov	ax, ds		  		; ES:BP = ����ַ
	mov	es, ax		 		; ��ES=DS
	
	mov	cx, MessageLength   ; CX = ����
	mov	ax, 1301h		 	; AH = 13h�����ܺţ���AL = 01h��������ڴ�β��
	mov	bx, 0007h		 	; ҳ��Ϊ0(BH = 0) �ڵװ���(BL = 07h)
    mov dh, 0		        ; �к�=0
	mov	dl, 0			 	; �к�=0
	int	10h			 		; BIOS��10h���ܣ���ʾһ���ַ�
		  
	mov	dx,0B800h				; �ı������Դ���ʼ��ַ
	mov	gs,dx					; GS = B800h

	
	mov cx,4				;��ʾ����
	mov ax, mess1
	mov si,ax
	mov bp,2400+84			;2���ֽ�
row1:
	push cx
	mov cx,8				;һ�е��ַ���
	
char1:	
	mov ah,07h				
	mov al,[si]				; AL=��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov word[gs:bp],ax
	inc si
	add bp,2
	loop char1
	
	add bp,144				;(80-�ַ���)*2
	pop cx
	loop row1
	
LoadnEx:
      
	mov ax,0
loop1:	  
	mov ah,00h 					;������	
    int 16h  					;�ַ���al
	cmp al,0
	jz loop1     				;�ַ���al
	
	mov bp,152	
	mov ah,07h					;
	mov word[gs:bp],ax
	add bp,2
	sub al,48
	mov bx, OffSetOfUserPrg1    ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
	cmp al,1
	jz read
	cmp al,2
	jz p2
	cmp al,3
	jz p3
	cmp al,4
	jz p4
p2:
	add bx,200h
	jmp read
p3:
	add bx,400h
	jmp read	
p4:
	add bx,600h
	jmp read
	
read:		
	mov cl,al
	inc cl
	mov ah,2              ; ���ܺ�
	mov al,1              ;������
	mov dl,0              ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
	mov dh,0              ;��ͷ�� ; ��ʼ���Ϊ0
	mov ch,0              ;����� ; ��ʼ���Ϊ0
	;mov cl,2             ;��ʼ������ ; ��ʼ���Ϊ1
	int 13H ;             ���ö�����BIOS��13h����
						; �û�����a.com�Ѽ��ص�ָ���ڴ�������
AfterRun:
    jmp bx

Message db "Press 1,2,3 or 4 to show you my OS. It will jump back automatically."
MessageLength  equ ($-Message)
mess1 db "17341189"
mess2 db "  Yao   "
mess3 db "  Sen   "
mess4 db "  Jian  "
      times 510-($-$$) db 0
      db 0x55,0xaa

