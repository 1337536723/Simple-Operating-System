;   NASM����ʽ
    Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
    delay equ 2000
									; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�


    org 7C00h					
start:
	xor ax,ax					; AX = 0   ������ص�0000��100h������ȷִ��
    mov ax,cs					; ������Щ�Ĵ�����Ϊ0
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; �ı������Դ���ʼ��ַ
	mov	gs,ax					; GS = B800h
	
	mov cx,6					;��ʾ6��
	mov ax, str0				;�׵�ַ
	mov si,ax	
	mov bp,860					;��һ���ַ����Դ��е�λ��
	row1:
		push cx						;����
		mov cx,19					;һ�е��ַ���
		
	char1:	
		mov ah,4Fh					;�ַ�����
		mov al,[si]					;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
		mov word[gs:bp],ax			;�Դ�
		inc si						;�ַ���ƫ����
		add bp,2					;һ���ַ���Ҫ2���ֽڲ������Դ�����ʾ
		loop char1					
		add bp,122					;(80-�ַ���)*2 ����
		pop cx
		loop row1
	
loop1:			;Ӧ�ý���ʱ����Ӧ��loop1�����ø���
	push cx		;����
	mov cx,word[count]	;loop2 ѭ��count��
loop2:
	push cx		;����
	
	mov cx,word[count]
loop3:
    loop loop3
	
	pop cx
	loop loop2
	pop cx

    mov al,1
      cmp al,byte[rdul]			
	jz  DnRt
      mov al,2
      cmp al,byte[rdul]
	jz  UpRt
      mov al,3
      cmp al,byte[rdul]
	jz  UpLt
      mov al,4
      cmp al,byte[rdul]
	jz  DnLt
      jmp 7C00H	

DnRt:
	inc word[x]
	inc word[y]
	mov bx,word[x]
	mov ax,25					
	sub ax,bx				;�����ˣ�Ҳ����25��
      jz  dr2ur
	mov bx,word[y]
	mov ax,80
	sub ax,bx				;�����ұߣ�Ҳ����80��
      jz  dr2dl				;���·�������
	jmp show
dr2ur:						;�����ˣ�Ҳ����25�У���͵�24����23 24 23
      mov word[x],23
      mov byte[rdul],Up_Rt	;���·�������
      jmp show
dr2dl:
      mov word[y],78		;���·������£����ҵ�79���� 78 79 78
      mov byte[rdul],Dn_Lt	
      jmp show
	  
	  

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[x]				;x�ж���ǰ
	mov ax,12					;����Ϊ0�� 0 1 0
	sub ax,bx
      jz  ur2dr
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  ur2ul

	jmp show
ur2ul:
      mov word[y],78
      mov byte[rdul],Up_Lt	
      jmp show
ur2dr:
      mov word[x],14
      mov byte[rdul],Dn_Rt	
      jmp show

	
	
UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,12
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,-1				;Y
	sub ax,bx
      jz  ul2ur
	jmp show

ul2dl:
      mov word[x],14
      mov byte[rdul],Dn_Lt	
      jmp show
ul2ur:
      mov word[y],1
      mov byte[rdul],Up_Rt	
      jmp show

	
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,25
	sub ax,bx
      jz  dl2ul
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  dl2dr

	jmp show

dl2dr:
      mov word[y],1
      mov byte[rdul],Dn_Rt	
      jmp show
	
dl2ul:
      mov word[x],23
      mov byte[rdul],Up_Lt	
      jmp show
	
show:	
    xor ax,ax                 ; �����Դ��ַ
    mov ax,word[x]			  ; (80*x+y)*2Byte   x��row��y��column
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	mov ah,2Fh					;  
	mov al,byte[char]			;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov word[gs:bp],ax  		;  ��ʾ�ַ���ASCII��ֵ
	jmp loop1
	

	

	
end:
    jmp $                   ; ֹͣ��������ѭ�� 
	
datadef:	
	count dw delay
    rdul db Dn_Rt         ; ��ʼΪ1
    x    dw 13			
    y    dw 0
    char db '#'				
	str0 db  "17341189 YaoSenjian"
	str1 db  " welcome to my OS! "
	str6 db  "        ** **      "
	str7 db  "       *******     "
	str2 db  "        *****      "
	str8 db  "          *        "


	

