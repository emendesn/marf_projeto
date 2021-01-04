#ifdef SPANISH
	#define STR0001 "Total de la Seccion "
	#define STR0002 "Espere"
	#define STR0003 "La configuracion de este informe no permite la inclusion de campos del usuario. Estos campos no se consideraran."
	#define STR0004 "Atencion"
	#define STR0005 "�Anulado por el Operador!"
#else
	#ifdef ENGLISH
		#define STR0001 "Section total  "
		#define STR0002 "Wait   "
		#define STR0003 "The configuration of this report does not allow addition of user fields. These fields will be disregarded.     "
		#define STR0004 "Attention"
		#define STR0005 "Cancelled by the Operator!"
	#else
		Static STR0001 := "Total da Secao "
		#define STR0002  "Aguarde"
		Static STR0003 := "A configura��o deste relatorio n�o permite a inclus�o de campos do usu�rio. Esses campos ser�o desconsiderados."
		#define STR0004  "Aten��o"
		Static STR0005 := "Cancelado pelo Operador !!!"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Total da sec��o "
			STR0003 := "A configura��o deste relat�rio n�o permite a inser��o de campos do utilizador. estes campos n�o ser�o considerados."
			STR0005 := "Anulado pelo operador !!!"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
