#include <avr/io.h>

char x;

int main() {
	DDRA = 0xFF;	//A as output
	DDRC = 0x00;	//C as input
	
	x = 1;
	
	while(1) {
		if((PINC & 0x01) == 1) {	//Push SW0
			while((PINC & 0x01) == 1); //Release SW0
			if(x == 128) {	//If overflow
				x = 1;		//go back to LSB
			}
			else {
				x = x << 1;	//else rotate left
			}
		}
		if((PINC & 0x02) == 2) {	//Push SW1
			while((PINC & 0x02) == 2); //Release SW1
			if(x == 1) {
				x = 128;	//go back to MSB
			}
			else {
				x = x >> 1;// else rotate right
			}
		}
		if((PINC & 0x04) == 4) {	//Push SW2
			while((PINC & 0x04) == 4); //Release SW2
			x = 128;
		}
		if((PINC & 0x08) == 8) {	//Push SW3
			while((PINC & 0x08) == 8);	//Release SW3
			x = 1;
		}
		PORTA = x;
	}
	return 0;
}
