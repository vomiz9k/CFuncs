.model tiny
.code
.386
org 100h

start:

	mov di, offset str1
	mov al, 'e'
	mov cx, 7d
	call memchr
	cmp al, [di]	
	jne exit

	
	mov di, offset str3
	mov al, 'b'
	mov cx, 5d
	call memset
	cmp [str3 + 4], 'b'
	jne exit
	cmp [str3 + 5], 'a'
	jne exit
	
	
	mov di, offset str1
	mov si, offset str2
	mov cx, 6d
	call memcmp
	cmp al, 'w' - 'h'
	jne exit
	
	
	mov di, offset str3
	mov si, offset str1
	mov cx, 10d
	call memcpy
	mov di, offset str3
	mov si, offset str1
	mov cx, 10d
	call memcmp
	cmp al, 0
	jne exit
	
	
	
	mov di, offset str1
	call strlen
	cmp cx, 10d
	jne exit
	
	
	
	mov di, offset str1
	mov al, 'w'
	call strchr
	cmp [si], al
	jne exit
	
	
	
	mov di, offset str1
	mov al, 'e'
	call strrchr
	cmp [si], al
	jne exit
	

	
	mov di, offset str1
	mov si, offset str2
	call strcmp
	cmp cx, 'w' - 'h'
	jne exit
	

	mov ah, 02h
    mov dl, 'o'
    int 21h
	mov ah, 02h
    mov dl, 'k'
    int 21h
	mov ax, 4c00h
	int 21h	
	

	exit:
	mov ah, 02h
    mov dl, 'n'
    int 21h
	mov ah, 02h
    mov dl, 'o'
    int 21h
	mov ax, 4c00h
	int 21h

;------------------------------------------
;memchr
;	di - offset of memory
;	al - searching char
; 	cx - count of searching symbols
;Returns : di - pointer of sym
;Destroyed: di
;------------------------------------------
memchr:
	cld
	repne scasb
	dec di
	ret
	

;------------------------------------------
;memset
;Parameters:
;	bx - offset of mem
;	al - char
; 	cx - count
;Returns: bx - offset of mem
;Destroyed: cx, di, bx
;------------------------------------------	
memset:	
	cld
	mov bx, di
	rep stosb
	
	ret

;------------------------------------------
;memcpy
;Parameters:
;	di - offset of dest
;	si - offset of src
; 	cx - count
;Returns: di - dest
;Destroyed: cx, di, si

;------------------------------------------	
memcpy:
	cld
	rep movsb
	ret
	
		

;------------------------------------------
;memcmp
;Parameters:
;	di - offset of mem1
;	si - offset of mem2
; 	cx - count
;Destroyed: cx, di, si
;Returns: al: first [di] - [bi] != 0 (0 if all symbols are equal)
;------------------------------------------	
memcmp:
		cld
		repe cmpsb
		je equal
		
		
		mov al, [di - 1]
		mov bl, [si - 1]
		sub al, bl
		ret
		
	equal:
		xor ax, ax
		ret	


;------------------------------------------
;Counts length of string
;Parameters:
;	di - offset of string
;Returns:
;	cx - length of string
;Destroyed: ax, di
;------------------------------------------	
strlen:
		xor cx, cx
		not cx
		xor ax, ax
		cld
		repne scasb
		not ax
		sub ax, cx
		mov cx, ax
		dec cx
		ret
		
;------------------------------------------
;Finds first char in string same as given
;Parameters:
;	di - offset of string, al - char
;Returns:
;	si - pointer of searching char(nullptr if not found)
;Destroyed: di, ax, bx
;------------------------------------------	
strchr:
		mov bl, al
		mov si, di
		call strlen
		mov al, bl
		mov di, si

		
		cld
		repne scasb
		jne not_found
		
		
		mov si, di
		dec si
		ret

		
	not_found:
		xor si, si
		ret
		
;------------------------------------------
;Finds last char in string same as given
;Parameters:
;	di - offset of string, al - char
;Returns:
;	si - pointer of searching char(nullptr if not found)
;Destroyed: di, ax, bx
;------------------------------------------	
strrchr:
		mov bl, al
		mov si, di
		call strlen
		mov al, bl
		mov di, si
		
		add di, cx
		
		std
		repne scasb
		jne rnot_found
		
		add di, 1
		mov si, di
		ret
		
	rnot_found:
		xor si, si
		ret
		
;------------------------------------------
;Compares two strings
;Parameters:
;	di - offset of string1, si - offset of string2
;Returns:
;	cx - difference between two different symbols in strings(0 if both equal)
;Destroyed: di, si, ax, bx
;------------------------------------------	
strcmp:
		mov al, [si]
	strcmp_loop:
		cmp [di], al
		jne strcmp_end
		inc si
		inc di
		mov al, [si]
		cmp al, 0
		jne strcmp_loop
	
	strcmp_end:
		xor ch, ch
		mov cl, [di]
		sub cl, [si]
		ret
;-------------------------------------------

.data
str1 db 'helloworld', 0h
str2 db 'hellohello', 0h
str3 db 'aaaaaaaaaa', 0h
str_len equ 10d
	
end start

