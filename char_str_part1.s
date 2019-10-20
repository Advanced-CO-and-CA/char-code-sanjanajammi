


/******************************************************************************
* File: char_str_part1.s
* Author: Sanjana Jammi
* Roll number: CS18M522
* TA: G S Nitesh Narayana
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Assignment 4 
  PART 1 - To determine the larger string provided two ASCII char strings of the same length
	
  */

  @ BSS section
      .bss

  
  @ DATA SECTION
	.data
	Input:	
		LENGTH:	.word 3
		START1: String1: .word 0x43 ,0x41, 0x54   @'C','A','T'
		START2: String2: .word 0x43 ,0x55, 0x54   @'C','U','T'
	Output:	
		GREATER: .word 0x00000000 

  @ TEXT section
      .text

.globl _main


_main:
	   EOR r0, r0, r0;         @ Register r0 to hold result, initialized to 0   
	   
	   LDR r4, =LENGTH;        @ Load length, if length is 0, stop execution
	   LDR r1, [r4];           @ Storing length in r1
	   EOR r6,r6,r6;           @ Using r6 as a counter	
	   
	   CMP r1, #0;
	   BEQ equal;	           @ Break if there are no elements i.e. length is 0, result is 0
	   	 
	   LDR r4, =START1;        @ Load starting address of string1 into register r4	
	   LDR r5, =START2;        @ Load starting address of string2 into register r5   	  
	   
loop:  
	   LDR r2, [r4], #4;       @ Fetching the characters of string1	   
	   LDR r3, [r5], #4;       @ Fetching the characters of string2
	   
	   ADD r6, r6, #1;         @ Incrementing the counter
	   CMP r2, r3;             @ Compare both the characters read
	   BNE not_equal;          @ If not equal, stop execution and store result
	   
	   CMP r6, r1;             @ Check if the complete string is read or not
	   BEQ equal;              @ Stop execution and store result if the comparison is done -> strings are equal	and result is 0
	   B loop;  
	   
not_equal:                     @ The strings are unequal in this case
	   MOVMI r0, #0xFFFFFFFF;  @ If string 1 is less than string 2, update result to 0xFFFFFFFF, else result is 0	   

equal:                         @ Stop the pgm, store results in memory
	   LDR r4, =GREATER;      
	   STR r0, [r4];    
	   SWI 0x11;

