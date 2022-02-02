#include <avr/io.h>

//Initialize variables
char F0,F1,A,B,C,D;

int main(void)
{
	//Set Port A as Input
	DDRA = 0X00;
	//Set Port B as Output
	DDRB = 0XFF;
	
    while (1) 
    {
		//We get the input variables by taking into
		//account only the required bit and shifting
		//as necessary
		A = PINA & 0x01;	      //Get A = PA0
		B = (PINA & 0x02) >> 1;	  //Get B = PA1
		C = (PINA & 0x04) >> 2;	  //Get C = PA2
		D = (PINA & 0x08) >> 3;	  //Get D = PA3
		
		//We do the bitwise operation for F0
		F0 = ~(A & B & (~C) | C & D);
		//We only keep the first bit and ignore the rest
		F0 = F0 & 0x01;
		
		//We do the bitwise operation for F1
		F1 = (A | B) & (C | D);
		//We keep the first bit and we shift it to
		//the 2nd position in the byte
		F1 = F1 & 0x01;
		F1 = F1 << 1;
		
		//We take the combination of F0 and F1. F0 has the
		//result stored in the first position of the byte and
		//F1 in the second from the previous operations. Bytes
		//2-7 will all be 0. We output the result in Port B
		PORTB = F0 | F1;
    }
}

