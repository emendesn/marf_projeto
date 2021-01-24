#ifdef SPANISH
	#define STR0001 "Arch.ya Existe ¿Crea uno Nuevo?"
	#define STR0002 "Probs on File "
	#define STR0003 "File Opened By GetSpfTXT"
	#define STR0004 "Probs on Write Of "
	#define STR0005 "Probs On GetSPFTxt In File "
	#define STR0006 "File Opened By PutSpfTXT"
#else
	#ifdef ENGLISH
		#define STR0001 "File already exists.Create new"
		#define STR0002 "Probs on File "
		#define STR0003 "File Opened By GetSpfTXT"
		#define STR0004 "Probs on Write Of "
		#define STR0005 "Probs On GetSPFTxt In File "
		#define STR0006 "File Opened By PutSpfTXT"
	#else
		Static STR0001 := "Arq.Ja Existe, Cria um Novo ?"
		Static STR0002 := "Probs on File "
		Static STR0003 := "File Opened By GetSpfTXT"
		Static STR0004 := "Probs on Write Of "
		Static STR0005 := "Probs On GetSPFTxt In File "
		Static STR0006 := "File Opened By PutSpfTXT"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Fich.já existe, cria um novo ?"
			STR0002 := "Probs no ficheiro "
			STR0003 := "Ficheiro Aberto Por Getspftxt"
			STR0004 := "Probs na escrita de "
			STR0005 := "Probs no getspftxt no ficheiro "
			STR0006 := "Ficheiro Aberto Por Putspftxt"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
