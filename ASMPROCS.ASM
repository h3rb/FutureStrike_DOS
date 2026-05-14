            title   junk


sseg        segment stack
            db      32 dup ("stack---")
sseg        ends


dseg        segment
x           dd       23232323h
y           dd       12121212h
dseg        ends






cseg        segment 'code'
assume      cs:cseg, ss:sseg, ds:dseg

main        proc    far
            push    ds
            push    0

            mov     ax,dseg
            mov     ds,ax

            mov     ax,sseg
            mov     ss,ax


            .386
; do stuff
            mov     eax,x
            mov     ebx,y
            inc     x
            inc     y
            sar     x,4
            sar     y,4
            add     x, 0aah
            add     y, 55h
            add     x, eax
            add     y, ebx
            add     x, ecx
            add     y, edx
            sub     x, 0aah

            ret

main        endp


cseg        ends

            end     main