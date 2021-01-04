#ifdef SPANISH
	#define STR0001 "L.M.C"
	#define STR0002 "Registro Manual LMC"
	#define STR0003 "Registro Automatico LMC"
	#define STR0004 "Mantenimiento LMC"
	#define STR0005 "Salir"
	#define STR0006 "Finalizadores"
	#define STR0007 "Apertura / Cierre"
	#define STR0008 "Historial Finalizador"
	#define STR0009 "Mantenimiento Finalizador"
	#define STR0010 "Caixa n�o possui acesso"
#else
	#ifdef ENGLISH
		#define STR0001 "L.M.C"
		#define STR0002 "LMC Manual Release"
		#define STR0003 "LMC Automatic Release"
		#define STR0004 "LMC Maintenance"
		#define STR0005 "Exit"
		#define STR0006 "Closing-Count"
		#define STR0007 "Opening/CLosing"
		#define STR0008 "Closing-Count History"
		#define STR0009 "Closing-Count Maintenance"
		#define STR0010 "Caixa n�o possui acesso"
	#else
		#define STR0001  "L.M.C"
		#define STR0002  "Lan�amento Manual LMC"
		#define STR0003  "Lan�amento Autom�tico LMC"
		Static STR0004 := "Manuten��o LMC"
		#define STR0005  "Sair"
		#define STR0006  "Encerrantes"
		#define STR0007  "Abertura / Fechamento"
		Static STR0008 := "Hist�rico Encerrante"
		Static STR0009 := "Manuen��o Encerrante"
		#define STR0010 "Caixa n�o possui acesso"	
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0004 := "Papel LMC"
			STR0008 := "Hist�rico encerrante"
			STR0009 := "Manuten��o encerrante"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
