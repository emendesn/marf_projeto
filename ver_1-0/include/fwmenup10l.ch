#ifdef SPANISH
	#define STR0001 "No se pudo montar el menu. ¡La cantidad de items excede el limite máximo que se permite!"
	#define STR0002 "Contacte el Administrador para verificar la estructura del menu."
#else
	#ifdef ENGLISH
		#define STR0001 "Menu elaboration was not possible. Amount of items exceeds maximum limit allowed!"
		#define STR0002 "Contact Administrator to check menu structure."
	#else
		Static STR0001 := "Não foi possível realizar a montagem do menu. A quantidade de itens excede o limite máximo permitido!"
		Static STR0002 := "Entre em contato com o Adminsitrador para verificar a estrutura do menu."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Não foi possível realizar a montagem do menu. A quantidade de elementos excede o limite máximo permitido!"
			STR0002 := "Entre em contacto com o Administrador para verificar a estrutura do menu."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
