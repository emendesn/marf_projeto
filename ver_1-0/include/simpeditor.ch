#ifdef SPANISH
	#define STR0001 "Editor"
	#define STR0002 "Negrita"
	#define STR0003 "Cursiva"
	#define STR0004 "Subrayada"
	#define STR0005 "Izquierda"
	#define STR0006 "Derecha"
	#define STR0007 "Centro"
	#define STR0008 "Justificado"
	#define STR0009 "Colores"
	#define STR0010 "NORMAL"
	#define STR0011 "OK"
	#define STR0012 "Anular"
	#define STR0013 "Fuentes"
	#define STR0014 "DISCO"
	#define STR0015 "CIRCULADO"
	#define STR0016 "CUADRADO"
	#define STR0017 "DECIMAL"
	#define STR0018 "ALFA MIN"
	#define STR0019 "ALFA MAX"
	#define STR0020 "Parrafo"
#else
	#ifdef ENGLISH
		#define STR0001 "Editor"
		#define STR0002 "Boldface"
		#define STR0003 "Italics"
		#define STR0004 "Underlined"
		#define STR0005 "Left "
		#define STR0006 "Right "
		#define STR0007 "Center"
		#define STR0008 "Fair "
		#define STR0009 "Colors"
		#define STR0010 "NORMAL"
		#define STR0011 "OK"
		#define STR0012 "Cancel "
		#define STR0013 "Fonts "
		#define STR0014 "DISC "
		#define STR0015 "CIRCLED "
		#define STR0016 "SQUARE "
		#define STR0017 "DECIMAL"
		#define STR0018 "ALFA MIN"
		#define STR0019 "ALFA MOTHER"
		#define STR0020 "Paragraph"
	#else
		#define STR0001  "Editor"
		#define STR0002  "Negrito"
		Static STR0003 := "Italico"
		#define STR0004  "Sublinhado"
		#define STR0005  "Esquerda"
		#define STR0006  "Direita"
		Static STR0007 := "Centro"
		#define STR0008  "Justo"
		#define STR0009  "Cores"
		Static STR0010 := "NORMAL"
		Static STR0011 := "OK"
		#define STR0012  "Cancelar"
		#define STR0013  "Fontes"
		Static STR0014 := "DISCO"
		Static STR0015 := "CIRCULADO"
		Static STR0016 := "QUADRADO"
		Static STR0017 := "DECIMAL"
		Static STR0018 := "ALFA MIN"
		Static STR0019 := "ALFA MAI"
		Static STR0020 := "Paragrafo"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0003 := "Itálico"
			STR0007 := "Centrado"
			STR0010 := "Normal"
			STR0011 := "Ok"
			STR0014 := "Disco"
			STR0015 := "Circulado"
			STR0016 := "Quadrado"
			STR0017 := "Decimal"
			STR0018 := "Alfa Min"
			STR0019 := "Alfa Mai"
			STR0020 := "Parágrafo"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
