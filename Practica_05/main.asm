   //configurar el pin como salida
   //al pin darle salida como pwm con tccr0b
   //configurar el timer con 1<<WGM01 en fast pwm
   //OCR0A comparador tiempo en alto
   //TCNT0 contador
   //ciclos para ir de lo maximo a lo minimo

.def temp = r16

.def retraso_0 = r17
.def retraso_1 = r18

.def contador = r19

.org 0X00       ;empieza a escribir codigo en la menoria 0 del microprocesador

rjmp inicio     ;Salto hacia la etiqueta //// Tiempo que se tarda en hacer la instruccion 
inicio:

ldi r16,low(RAMEND)			;cada imnediatamente un valor (RAMEND) en el registro (r16)
out SPL,r16					;mueve el valor del registro a la pila (spl)
ldi r16,high(RAMEND)
out SPH,r16

ciclo:
	ldi temp, 0xFF
	out DDRD, temp

	ldi temp, 1<<COM0A1 | 1<<WGM00 | 1<<WGM01
	out TCCR0A, temp

	ldi temp, 1<<CS01
	out TCCR0B, temp

	ldi contador, 0x00

loop:
	maximo:
		ldi retraso_0, 255
		ldi retraso_1, 250

		out OCR0A, contador
		inc contador

		rcall retraso

		cpi contador, 0x64
		brne maximo

	minimo:
		ldi retraso_0, 255
		ldi retraso_1, 250

		out OCR0A, contador
		dec contador

		rcall retraso

		cpi contador, 0x0
		brne minimo

   rjmp loop

retraso:
	dec retraso_0
	brne retraso

	dec retraso_1
	brne retraso
ret 
  