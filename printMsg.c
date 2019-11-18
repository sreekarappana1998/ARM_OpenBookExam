#include "stm32f4xx.h"
#include <string.h>
#include <stdio.h>
void printMsg2p(const int a, const int b)
{
	 float c=*((float*)&a);
	 float d=*((float*)&b);
		 
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "%f", c);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 ITM_SendChar(',');
	 
	 char Msg1[100];
	 	  
	 sprintf(Msg1, "%f", d);
	 ptr = Msg1 ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 ITM_SendChar('\n');
}