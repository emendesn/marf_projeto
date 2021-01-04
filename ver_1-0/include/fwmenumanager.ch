#ifdef SPANISH
	#define STR0001 "Espere ... Copiando items ..."
	#define STR0002 "Espere ... Moviendo items ..."
	#define STR0003 "Espere ... Generando menu ..."
	#define STR0004 "Espere ... Borrando items ..."
#else
	#ifdef ENGLISH
		#define STR0001 "Please, wait. Copying items ..."
		#define STR0002 "Please, wait. Moving items ..."
		#define STR0003 "Please, wait. Generating menus ..."
		#define STR0004 "Please, wait. Deleting items ..."
	#else
		#define STR0001  "Aguarde... Copiando Itens..."
		Static STR0002 := "Aguarde... Movendo Itens..."
		Static STR0003 := "Aguarde... Gerando Menu..."
		Static STR0004 := "Aguarde... Deletando Itens..."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "Aguarde... A Mover Itens..."
			STR0003 := "Aguarde... A Criar Menu..."
			STR0004 := "Aguarde... A Apagar Itens..."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
