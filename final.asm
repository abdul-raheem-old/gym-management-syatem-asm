.stack 100h
.data
str1 db "Enter Username: $"
str2 db 13,10,"Enter Password: $"
m1 db "*************************$"
str3 db "  Gym Management System$"
m2 db "*************************$"
m3 db 13,10,"Press 1. To login as Admin $"
m4 db 13,10,"Press 2. To login as Member $" 
m5 db 13,10,"Press 3. To quit $"
m6 db 13,10,"Enter your choice: $"
m7 db 13,10,"You have entered an Invalid choice...Please enter again $"
str4 db "=======================$"
str5 db "    Admin Portal $"
str6 db "=======================$" 
str7 db 13,10,"You have entered an invalid username or password...Try again!!! $"
str8 db 13,10,"Press 1. To Add Member $"
str9 db 13,10,"Press 2. To Search Member $"
str10 db 13,10,"Press 3. To Delete Member $"
str11 db 13,10,"Press 4. To Display Member details$"  
st12 db 13,10,"Press 5. Back to Main Menu $" 
str12 db 13,10,"Enter Member Name: $"
str15 db 13,10,"Enter Age: $"
str16 db 13,10,"Enter Contact# $"
str13 db 13,10,"Record...Not found $" 
str17 db 13,10,"Member Deleted $" 
str18 db 13,10,"Press 1. Check gym timing $"
str19 db 13,10,"Press 2. To pay fee $"
str20 db 13,10,"Press 3. View your details $"
str21 db 13,10,"Press 4. Back to Main Menu $"
str22 db "    Member Portal $"  
str23 db "Gym Timing",13,10,"$"
str24 db 13,10,"Enter Amount: $"
str25 db 13,10,"Press 1. To search by name$"
str26 db 13,10,"Press 2. To search by contact$"
str27 db 13,10,"Press 3. Back to Main Menu$"
str28 db 13,10,"Result not found.$"  
gymTiming1 db 13,10,"Mon 08:00 P.M - 10:00 P.M $"
gymTiming2 db 13,10,"Tue 07:00 P.M - 09:00 P.M $"
gymTiming3 db 13,10,"Wed 08:00 P.M - 10:00 P.M $"
gymTiming4 db 13,10,"Thu 07:00 P.M - 09:00 P.M $"
gymTiming5 db 13,10,"Fri 08:00 P.M - 10:00 P.M $"
gymTiming6 db 13,10,"Sat OFF $"
gymTiming7 db 13,10,"Sum OFF $"  
lblName db 13,10, "Name: $"
lblAge db 13,10, "Age: $"
lblContact db 13,10, "Contact: $"
success db 13,10, "Account created successfully $"
no_success db 13,10,"Invalid Account no. Enter 14 digits $"
str14 db "Member info",13,10,"$"
equal db 13,10,"You have successfully payed the gym fee. $"
less db 13,10,"You have payed less then gym fee. Please submit Rs.900$"
more db 13,10,"You have successfully payed the gym fee. Extra ammount is added to your account.$"
un db 20 dup('$')
pass db 20 dup('$')
password db "1234" 
count db ?   
Len dw $-password        
memberName db 20 dup('$') 
searchName db 20 dup('$')
memberAge db 5 dup('$')     
memberContact db 15 dup('$')
searchContact db 15 dup('$')
result dw ?

.code
main proc
mov ax,@data
mov ds,ax 

push ax              
push bx              
push cx              
push dx              
push si              
push di              
push bp              
mov bp,sp

call welcome_screen  
call main_menu        

pop bp
pop di
pop si
pop dx
pop cx
pop bx
pop ax

call exit            
endp
   
main_menu proc
again1:
lea dx,m3   
mov ah,09h           
int 21h
lea dx,m4
int 21h              
lea dx,m5
int 21h              
lea dx,m6
int 21h              
mov ah,01h
int 21h
cmp al,31h           
jnae invalid
cmp al,33h
jnbe invalid

 valid:
 cmp al,31h
 je admin            
 cmp al,32h
 je customer         
 cmp al,33h
 je quit             
 
 admin:
 call admin_login    
 jmp return1 
 
 customer:
 call member_login
 jmp return1         
 
 quit:
 call exit           
  
 invalid:  
 mov ah,09h
 lea dx,m7           
 int 21h     
 mov ah,08h          
 int 21h
 call clear_screen
 call set_registers
 call welcome_screen 
 jmp again1
 
return1:  
ret
endp                  
                      
admin_login proc      
again2:   
call clear_screen
call set_registers   
call admin_portal

lea dx,str1
mov ah,09h    
int 21h

mov ah,10
lea dx,un     
mov un,16
int 21h

lea dx,str2
mov ah,09h    
int 21h

mov bx,offset pass
mov [count],0 
while:
mov ah,08h    
int 21h
cmp al,0dh    
je end_while  
mov [bx],al   
mov ah,02h
mov dl,'*'    
int 21h
inc bx        
inc [count]   
jmp while

end_while:

lea si,password   
lea di,pass       
mov ax,[Len]     
dec al
cmp al,[count]
jne not_equal
jmp check

not_equal: 
mov dh,5          
mov dl,0          
mov ah,02         
int 10h           
                       
lea dx,str7           
mov ah,09h            
int 21h               

mov ah,08h        
int 21h
                      
call clear_screen  
jmp again2             

check:
mov ch,0
mov cl,[count]   
mov bx,offset pass
mov si,offset password
compare:          
mov al,[bx]
cmp al,[si]
jne not_equal  
inc bx
inc si
loop compare 

call clear_screen           
call set_registers 
call admin_portal  
call admin_main_menu

return:        
ret                 
admin_login endp    

clear_screen proc
mov ax,0600h 
mov cx,0     
mov dx,2479  
mov bh,7     
int 10h      
ret
clear_screen endp    

welcome_screen proc  
mov dh,1     
mov dl,29  
mov ah,2   
int 10h    

lea dx,m1
mov ah,09h   
int 21h 

mov dh,2      
mov dl,29     
mov ah,2
int 10h

lea dx,str3
mov ah,09h  
int 21h  

mov dh,3
mov dl,29
mov ah,2
int 10h

lea dx,m2
mov ah,09h  
int 21h 

ret    
welcome_screen endp

admin_portal proc 
mov dh,0
mov dl,29
mov ah,2
int 10h

lea dx,str4
mov ah,09h   
int 21h 

mov dh,1
mov dl,29
mov ah,2
int 10h

lea dx,str5
mov ah,09h 
int 21h 

mov dh,2
mov dl,29
mov ah,2
int 10h
  
lea dx,str6
mov ah,09h 
int 21h

mov dh,3
mov dl,0
mov ah,02h
int 10h
    
ret
admin_portal endp    

admin_main_menu proc  

mov dh,2   
mov dl,29   
mov ah,2    
int 10h      

lea dx,str8
mov ah,09h   
int 21h 

mov dh,3
mov dl,29   
mov ah,2
int 10h

lea dx,str9
mov ah,09h  
int 21h  

mov dh,4
mov dl,29   
mov ah,2
int 10h

lea dx,str10
mov ah,09h  
int 21h 

mov dh,5
mov dl,29
mov ah,2
int 10h

lea dx,str11
mov ah,09h   
int 21h 

lea dx,st12
mov ah,09h   
int 21h 

lea dx,m6
mov ah,09h   
int 21h 

mov ah,01h
int 21h      
mov bl,al

cmp bl,31h   
jnae invalid2
cmp bl,35h
jnbe invalid2   

valid2:
     cmp bl,31h
     je create_acc   
          
     cmp bl,32h
     je search_acc  
         
     cmp bl,33h
     je delete_acc  
     
     cmp bl,34h
     je show_userss 
     
     cmp bl,35h
     je back        
     
     create_acc:
     call create_acco
     jmp return3
     
     search_acc:
     call search_member
     jmp return3  
     
     delete_acc:
     call delete_member
     jmp return3
     
     show_userss:
     call show_users
     jmp return3
     
     back:
     call clear_screen
     call set_registers
     call welcome_screen
     call main_menu
     jmp return3
          
     invalid2:
     lea dx,m7
     mov ah,09h
     int 21h
     mov ah,08h
     int 21h  
     
     call clear_screen
     call set_registers
     call admin_portal 
     call admin_main_menu      
               
return3:
ret    
admin_main_menu endp   

create_acco proc
again4:
call clear_screen
call set_registers
call admin_portal

lea dx,str12   
mov ah,09h      
int 21h

mov ah,10
lea dx,memberName  
mov memberName, 17
int 21h              
                
lea dx,str15   
mov ah,09h      
int 21h

mov ah,10
lea dx,memberAge  
mov memberName, 3
int 21h              
                
lea dx,str16   
mov ah,09h      
int 21h

mov ah,10
lea dx,memberContact  
mov memberName, 12
int 21h              
                

lea dx,success
mov ah,09h      
int 21h   
mov ah,08h
int 21h 
jmp last

create_again:
lea dx,no_success
mov ah,09h      
int 21h
mov ah,08h
int 21h 
jmp again4

last:
call clear_screen
call set_registers
call admin_portal
call admin_main_menu   

ret
create_acco endp    

show_users proc
call clear_screen
call set_registers
call admin_portal

lea dx,str14
mov ah,09h      
int 21h        

lea dx, memberName+2    
cmp memberName+2, "$"
je empty
      
lea dx, lblName 
mov ah, 09h
int 21h 

lea dx, memberName+2
int 21h     

lea dx, lblAge
int 21h 

lea dx, memberAge+2
int 21h 

lea dx, lblContact
int 21h 

lea dx, memberContact+2
int 21h 
jmp w:

empty:
lea dx,str13
mov ah,09h      
int 21h

w:
mov ah,08h      
int 21h  

call clear_screen
call set_registers
call admin_portal 
call admin_main_menu
    
ret
show_users endp

delete_member proc 
call clear_screen
call set_registers
call admin_portal

mov cx, 18
mov bx, 2

lea dx, memberName+2    
cmp memberName+2, "$"
je empty1

for1:
     mov memberName+bx, "$"
     inc bl
loop for1
mov cx, 3
mov bx, 2
for2:
     mov memberAge+bx, "$"
     inc bl
loop for2
mov cx, 13
mov bx, 2
for3:
     mov memberContact+bx, "$"
     inc bl
loop for3
jmp deleted 

empty1:
lea dx,str13
mov ah,09h      
int 21h
jmp delete_end
          
deleted:
lea dx, str17
mov ah, 09h
int 21h

delete_end:
mov ah, 8
int 21h

call clear_screen
call set_registers
call admin_portal
call admin_main_menu
ret
delete_member endp

search_member proc
search_again:
call clear_screen
call set_registers   
call admin_portal   

lea dx, str25
mov ah, 09h
int 21h

lea dx, str26
int 21h

lea dx, str27
int 21h

lea dx, m6
int 21h

mov ah, 01h
int 21h

cmp al, 31h
jnae invalid_search
cmp al, 33h
jnbe invalid_search

valid_search:
cmp al, 31h
je search_by_name
cmp al, 32h
je search_by_contact
cmp al, 33h
je return_search

invalid_search:
lea dx, m7
mov ah, 09h
int 21h

mov ah, 01h
int 21h
jmp search_again

search_by_name:
call search_name
jmp return_search

search_by_contact:
call search_contact

return_search:
call clear_screen
call set_registers
call admin_portal
call admin_main_menu
    
ret
search_member endp

search_name proc  
call clear_screen
call set_registers   
call admin_portal

lea dx, str12
mov ah, 09h 
int 21h

mov ah, 10
lea dx, searchName
mov searchName, 16
int 21h             

call clear_screen
call set_registers
call admin_portal

mov cx, 16       
mov si, offset searchName
mov bx, offset memberName
search_name_loop:
mov ax, bx       
cmp ax, si
jne not_found_name
inc bx
inc si
loop search_name_loop

found_name:    
call clear_screen
call set_registers   
call admin_portal

lea dx, lblName
mov ah, 09h
int 21h

lea dx, memberName+2
int 21h

lea dx, lblAge
int 21h

lea dx, memberAge+2
int 21h 

lea dx, lblContact
int 21h

lea dx, memberContact+2
int 21h

jmp return_search_name   

not_found_name: 
call clear_screen
call set_registers   
call admin_portal
lea dx, str28
mov ah, 09h
int 21h

return_search_name:
mov ah, 8
int 21h
call clear_screen
call set_registers
call admin_portal
call admin_main_menu
    
ret
search_name endp

search_contact proc  
call clear_screen
call set_registers   
call admin_portal

lea dx, str16
mov ah, 09h
int 21h

mov ah, 10
lea dx, searchContact
mov searchContact, 16
int 21h             

call clear_screen
call set_registers
call admin_portal

mov cx, 18
mov bx, 2

search_contact_loop:         
mov dx, offset searchContact+bx
mov ax, offset memberContact+bx
cmp dx, ax
jne not_found_contact
inc bx
loop search_contact_loop

found_contact:    
call clear_screen
call set_registers   
call admin_portal

lea dx, lblName
mov ah, 09h
int 21h

lea dx, memberName+2
int 21h

lea dx, lblAge
int 21h

lea dx, memberAge+2
int 21h 

lea dx, lblContact
int 21h

lea dx, memberContact+2
int 21h

jmp return_search_contact   

not_found_contact: 
call clear_screen
call set_registers   
call admin_portal
lea dx, str28
mov ah, 09h
int 21h

return_search_contact:
mov ah, 8
int 21h
call clear_screen
call set_registers
call admin_portal
call admin_main_menu
    
ret
search_contact endp

member_login proc      
again6:   
call clear_screen
call set_registers   
call member_portal

lea dx,str1
mov ah,09h    
int 21h

mov ah,10
lea dx,un     
mov un,16
int 21h

lea dx,str2
mov ah,09h    
int 21h

mov bx,offset pass
mov [count],0 
while1:
mov ah,08h    
int 21h
cmp al,0dh    
je end_while1  
mov [bx],al   
mov ah,02h
mov dl,'*'    
int 21h
inc bx        
inc [count]   
jmp while1

end_while1:

lea si,password   
lea di,pass       
mov ax,[Len]     
dec al
cmp al,[count]
jne not_equal1
jmp check1

not_equal1: 
mov dh,5          
mov dl,0          
mov ah,02         
int 10h           
                       
lea dx,str7           
mov ah,09h            
int 21h               

mov ah,08h        
int 21h
                      
call clear_screen  
jmp again6             

check1:
mov ch,0
mov cl,[count]   
mov bx,offset pass
mov si,offset password
compare1:          
mov al,[bx]
cmp al,[si]
jne not_equal  
inc bx
inc si
loop compare1 

call clear_screen           
call set_registers 
call member_portal  
call member_main_menu

return6:        
ret                
member_login endp

member_portal proc 
mov dh,0
mov dl,29
mov ah,2
int 10h

lea dx,str4
mov ah,09h   
int 21h 

mov dh,1
mov dl,29
mov ah,2
int 10h

lea dx,str22
mov ah,09h 
int 21h 

mov dh,2
mov dl,29
mov ah,2
int 10h
  
lea dx,str6
mov ah,09h 
int 21h

mov dh,3
mov dl,0
mov ah,02h
int 10h
    
ret
member_portal endp

member_main_menu proc  

mov dh,2   
mov dl,29   
mov ah,2    
int 10h      

lea dx,str18
mov ah,09h   
int 21h 

mov dh,3
mov dl,29   
mov ah,2
int 10h

lea dx,str19
mov ah,09h  
int 21h  

mov dh,4
mov dl,29   
mov ah,2
int 10h

lea dx,str20
mov ah,09h  
int 21h 

mov dh,5
mov dl,29
mov ah,2
int 10h

lea dx,str21
mov ah,09h   
int 21h 

lea dx,m6
mov ah,09h   
int 21h 

mov ah,01h
int 21h      
mov bl,al

cmp bl,31h   
jnae invalid4
cmp bl,35h
jnbe invalid4   

valid4:
     cmp bl,31h
     je lblGym   
          
     cmp bl,32h
     je lblPay  
         
     cmp bl,33h
     je lblView  
     
     cmp bl,34h
     je lblBack        
     
     lblGym:
     call show_timing
     jmp return7
     
     lblPay:
     call pay_fee
     jmp return7  
     
     lblView:
     call show_details
     jmp return7
     
     lblBack:
     call clear_screen
     call set_registers
     call welcome_screen
     call main_menu
     jmp return3
          
     invalid4:
     lea dx,m7
     mov ah,09h
     int 21h
     mov ah,08h
     int 21h  
     
     call clear_screen
     call set_registers
     call member_portal 
     call member_main_menu      
               
return7:
ret    
member_main_menu endp

show_timing proc
call clear_screen
call set_registers
call member_portal

lea dx,str23
mov ah,09h      
int 21h  

lea dx, gymTiming1
int 21h

lea dx, gymTiming2
int 21h

lea dx, gymTiming3
int 21h

lea dx, gymTiming4
int 21h

lea dx, gymTiming5
int 21h

lea dx, gymTiming6
int 21h

lea dx, gymTiming7
int 21h

mov ah,08h      
int 21h  

call clear_screen
call set_registers
call member_portal 
call member_main_menu
    
ret
show_timing endp

show_details proc
call clear_screen
call set_registers
call member_portal

lea dx,str14
mov ah,09h      
int 21h        

lea dx, memberName+2    
cmp memberName+2, "$"
je empty5
      
lea dx, lblName 
mov ah, 09h
int 21h 

lea dx, memberName+2
int 21h     

lea dx, lblAge
int 21h 

lea dx, memberAge+2
int 21h 

lea dx, lblContact
int 21h 

lea dx, memberContact+2
int 21h 
jmp w1:

empty5:
lea dx,str13
mov ah,09h      
int 21h

w1:
mov ah,08h      
int 21h  

call clear_screen
call set_registers
call member_portal 
call member_main_menu
    
ret
show_details endp  

pay_fee proc   
call clear_screen
call set_registers
call member_portal

lea dx, str24
mov ah, 09h
int 21h

mov ax, 0
mov bx, 10
mov cx, 00
while_amount:
mov ah, 01h
int 21h
cmp al, 0dh
je end_while_amount
mov ah, 0
sub al, 30h
mov cx, ax
mov ax, bx
mul [result]
add ax, cx
mov [result], ax
jmp while_amount
end_while_amount:

cmp [result], 900
je payed
cmp [result], 900
jl lessAmount
cmp [result], 900
jg moreAmount

payed:
lea dx, equal
mov ah, 09h
int 21h
jmp end_fee

lessAmount:
lea dx, less
mov ah, 09h
int 21h
jmp end_fee

moreAmount:
lea dx, more
mov ah, 09h
int 21h
jmp end_fee
           
end_fee:   
mov ah,08h      
int 21h  

call clear_screen
call set_registers
call member_portal 
call member_main_menu
ret
pay_fee endp

set_registers proc
mov ax,[bp+12]        
mov bx,[bp+10]        
mov cx,[bp+8]
mov dx,[bp+6] 
mov si,[bp+4]
mov di,[bp+2] 
ret
set_registers endp

exit proc
mov ah,4ch
int 21h        
ret
exit endp

end main  