; A program that prints "Congrats!". Yep, that's all it does.

start:
	nand text_addr, print_input
	nand print_input
	nand text_addr + 1, print_input + 1
	nand print_input + 1

	nand endaddr, print_reta
	nand print_reta
	nand endaddr + 1, print_reta + 1
	nand print_reta + 1

	bnand 0, zero
	br print

endaddr:
	rawa end
end:
	bnand 0, zero
	br 0xFFFF
	; If not branched, it was 1. Again.
	bnand 0, zero
	br 0xFFFF

print:
	; Refresh time.
	bnand 0, print_reta
	bnand 0, print_reta
	bnand 0, print_input
	bnand 0, print_input
	; Is character zero?
	nandi print_input
	nandi print_input
	br print_notzero
	; It is zero. We're done.
	bnand 0, zero
	ibr print_reta
	bnand 0, zero
	ibr print_reta
	; That will not return.

	print_notzero:
	; Make buffer 0xFF.
	nand usable_zero, 0xFFFF
	; Move the char there.
	nandid print_input, 0xFFFF
	nand 0xFFFF
	; Write.
	bnand 0, 0xFFFE
	; Go to the next.
	nand print_input_addr, inc_input
	nand inc_input
	nand print_input_addr + 1, inc_input + 1
	nand inc_input + 1

	nand cleanup_addr, inc_reta
	nand inc_reta
	nand cleanup_addr + 1, inc_reta + 1
	nand inc_reta + 1

	; Refresh time.
	bnand 0, print_reta
	bnand 0, print_reta
	bnand 0, print_input
	bnand 0, print_input

	; Increment now.
	bnand 0, zero
	br print_flagUP
	bnand 0, zero
	print_flagUP:
	br inc

	cleanup_addr: rawa cleanup
	cleanup:
	; Make sure inc_reta and inc_input are left at 1.
	nand usable_zero, inc_reta
	nand usable_zero, inc_input

	; Jump back
	bnand 0, zero
	br print
	bnand 0, zero
	br print
	; Won't continue.

	print_input_addr: rawa print_input
	print_input: rawa 0xFFFF
	print_reta: rawa 0xFFFF


zero: rawd 0
usable_zero: rawd 0
text_addr: rawa text
text: rawd 0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x57, 0x6f, 0x72, 0x6c, 0x64, 0x21, 0x0a, 0x00

; Increment function of one byte, then overflows. Just adds one lmao.
inc:
	bnandi 0, inc_input
	ibr inc_reta
	bnandi 1, inc_input
	ibr inc_reta
	bnandi 2, inc_input
	ibr inc_reta
	bnandi 3, inc_input
	ibr inc_reta
	bnandi 4, inc_input
	ibr inc_reta
	bnandi 5, inc_input
	ibr inc_reta
	bnandi 6, inc_input
	ibr inc_reta
	bnandi 7, inc_input
	ibr inc_reta

	; In case of overflow.
	bnand 0, zero
	ibr inc_reta
	bnand 0, zero
	ibr inc_reta

	inc_input: rawa 0xFFFF
	inc_reta: rawa 0xFFFF

; Easy, right? No. Totally not. I've created a monster.
