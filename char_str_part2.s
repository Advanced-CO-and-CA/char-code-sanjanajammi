


/******************************************************************************
* File: char_str_part2.s
* Author: Sanjana Jammi
* Roll number: CS18M522
* TA: G S Nitesh Narayana
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Assignment 4
  PART 2 - To determine the if one string is a substring of the other and to store the index of occurrence
	
  */

  @ BSS section
      .bss

  @ DATA SECTION
	.data
	Input:	
		STRING: String1: .word 0x43 ,0x53, 0x36, 0x36, 0x32, 0x30  @'C','S','6','6','2','0'
		SUBSTR: String2: .word 0x36, 0x32, 0x30   @'6','2','0'
	
	Output:	
		PRESENT: .word 0
	Length_string: .word(String2 - String1) /4    @length of STRING
	Length_substr: .word(Output - String2) / 4    @length of SUBSTR
	
	
  @ TEXT section
      .text

.globl _main


_main:
	   EOR r0, r0, r0;         @ Register r0 to hold substr index value, initialized to 0
	   
	   LDR r4, =Length_string; @ Load length of string, if length is 0, stop execution
	   LDR r1, [r4];           @ Storing effective length of string in r1
	   LDR r4, =Length_substr; @ Load length of substr, if length is 0, stop execution
	   LDR r2, [r4];           @ Storing length of substr in r2
	   	   
	   CMP r1, #0;
	   BEQ not_present;	       @ Break if there are no elements i.e. length of string is 0, substr is not present in string
	   
	   CMP r2, #0;
	   BEQ not_present;	       @ Break if there are no elements i.e. length of substr is 0, substr is not present in string
	   
	   MOV r8, #4; 	           @ Using r8 to store value of 4. This is used to calculate the current index of string
	   EOR r5,r5,r5;           @ Using r5 as a counter	

reset:	   	                   @ This loop resets the starting positions for string and substr based on the comparisons already performed
	   LDR r3, =STRING;        @ Load starting address of string into register r3	
	   LDR r4, =SUBSTR;        @ Load starting address of substr into register r4	 
	   MLA r3, r0, r8, r3;     @ Calculate effective starting address of string by performing r3 <- (r0*r8) + r3
	   CMP r1, r2;             @ Check if effective string length is lesser than substr length, if so, substr is not present in string
	   BLT not_present;
	   
loop:         				   @ This loop checks each character of string and substr and repeats till length of substr is reached
	   LDR r6, [r3], #4;       @ Fetching the characters of string	   
	   LDR r7, [r4], #4;       @ Fetching the characters of substr
	   
	   ADD r5, r5, #1;         @ Incrementing the loop counter -> This loop repeats for the length of substr
	   CMP r6, r7;             @ Compare both the characters read
	   BNE not_equal;          @ If not equal, increment the index and reset counters
	   
	   CMP r5, r2;             @ If read characters are equal, check if the complete substr is read or not
	   BLT loop;               @ Continue  to read the next characters in both the string and substr if the entire substr is not read
	   BEQ present;            @ If substr is read completely, it means the substr is present in the string
	   
not_equal:					   @ Perform these operations when the characters in string and substr do not match
	   EOR r5, r5, r5;         @ Reset the loop counter r5 as the substr needs to be rechecked
	   ADD r0, r0, #1;         @ Increment the substr index
	   SUB r1, r1, #1;	       @ Decrement the effective length of string to be compared
	   B reset;                @ Repeat all the steps for the new effective string and substr
	   

not_present:          		   @ substr is not present in the string
	   EOR r0, r0, r0;         @ Reset value of result to 0
	   LDR r4, =PRESENT;       @ Stop the pgm, store results in memory
	   STR r0, [r4];         
	   SWI 0x11;		

present:                       @ substr is present in the string
	   ADD r0, r0, #1;         @ Add 1 to the calculated index as it starts from 1 (calculations in the program start from index 0)
	   LDR r4, =PRESENT;       @ Stop the pgm, store results in memory
	   STR r0, [r4];    
	   SWI 0x11;
	   