#IFDEF SPANISH
	#DEFINE STR0001 ": N�o � poss�vel encontrar o elemento pai '"+cParent+"' para '"+cCode+"'"+CRLF
	#DEFINE STR0002 ": Elemento pai '"+cParent+"' inv�lido para '"+cCode+CRLF+"'"
	#DEFINE STR0003 ": Elemento pai n�o informado para '"+cCode+"'"+CRLF
	#DEFINE STR0004 ": Elemento "+cCode+" duplicado. "+CRLF
	#DEFINE STR0005 "Linha "
	#DEFINE STR0006 ": VALUE n�o � do tipo caracter!"+CRLF
	#DEFINE STR0007 ": Campo "+aLine[nI]+" duplicado!"+CRLF
	#DEFINE STR0008 ": Campo "+aLine[nI]+" inv�lido!"+CRLF
	#DEFINE STR0009 ": Campos insuficientes!"+CRLF
	#DEFINE STR0010 ": Tipo "+cType+" inv�lido!"+CRLF
	#DEFINE STR0011 "Erro! Modelo "+Alltrim(cCSVModel)+" n�o existe!"+CRLF
#ELSE
	#IFDEF ENGLISH
		#DEFINE STR0001 ": N�o � poss�vel encontrar o elemento pai '"+cParent+"' para '"+cCode+"'"+CRLF
		#DEFINE STR0002 ": Elemento pai '"+cParent+"' inv�lido para '"+cCode+CRLF+"'"
		#DEFINE STR0003 ": Elemento pai n�o informado para '"+cCode+"'"+CRLF
		#DEFINE STR0004 ": Elemento "+cCode+" duplicado. "+CRLF
		#DEFINE STR0005 "Linha "
		#DEFINE STR0006 ": VALUE n�o � do tipo caracter!"+CRLF
		#DEFINE STR0007 ": Campo "+aLine[nI]+" duplicado!"+CRLF
		#DEFINE STR0008 ": Campo "+aLine[nI]+" inv�lido!"+CRLF
		#DEFINE STR0009 ": Campos insuficientes!"+CRLF
		#DEFINE STR0010 ": Tipo "+cType+" inv�lido!"+CRLF
		#DEFINE STR0011 "Erro! Modelo "+Alltrim(cCSVModel)+" n�o existe!"+CRLF
	#ELSE
		#DEFINE STR0001 ": N�o � poss�vel encontrar o elemento pai '"+cParent+"' para '"+cCode+"'"+CRLF
		#DEFINE STR0002 ": Elemento pai '"+cParent+"' inv�lido para '"+cCode+CRLF+"'"
		#DEFINE STR0003 ": Elemento pai n�o informado para '"+cCode+"'"+CRLF
		#DEFINE STR0004 ": Elemento "+cCode+" duplicado. "+CRLF
		#DEFINE STR0005 "Linha "
		#DEFINE STR0006 ": VALUE n�o � do tipo caracter!"+CRLF
		#DEFINE STR0007 ": Campo "+aLine[nI]+" duplicado!"+CRLF
		#DEFINE STR0008 ": Campo "+aLine[nI]+" inv�lido!"+CRLF
		#DEFINE STR0009 ": Campos insuficientes!"+CRLF
		#DEFINE STR0010 ": Tipo "+cType+" inv�lido!"+CRLF
		#DEFINE STR0011 "Erro! Modelo "+Alltrim(cCSVModel)+" n�o existe!"+CRLF
	#ENDIF
#ENDIF