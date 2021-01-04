#IFDEF SPANISH
	#DEFINE STR0001 ": Não é possível encontrar o elemento pai '"+cParent+"' para '"+cCode+"'"+CRLF
	#DEFINE STR0002 ": Elemento pai '"+cParent+"' inválido para '"+cCode+CRLF+"'"
	#DEFINE STR0003 ": Elemento pai não informado para '"+cCode+"'"+CRLF
	#DEFINE STR0004 ": Elemento "+cCode+" duplicado. "+CRLF
	#DEFINE STR0005 "Linha "
	#DEFINE STR0006 ": VALUE não é do tipo caracter!"+CRLF
	#DEFINE STR0007 ": Campo "+aLine[nI]+" duplicado!"+CRLF
	#DEFINE STR0008 ": Campo "+aLine[nI]+" inválido!"+CRLF
	#DEFINE STR0009 ": Campos insuficientes!"+CRLF
	#DEFINE STR0010 ": Tipo "+cType+" inválido!"+CRLF
	#DEFINE STR0011 "Erro! Modelo "+Alltrim(cCSVModel)+" não existe!"+CRLF
#ELSE
	#IFDEF ENGLISH
		#DEFINE STR0001 ": Não é possível encontrar o elemento pai '"+cParent+"' para '"+cCode+"'"+CRLF
		#DEFINE STR0002 ": Elemento pai '"+cParent+"' inválido para '"+cCode+CRLF+"'"
		#DEFINE STR0003 ": Elemento pai não informado para '"+cCode+"'"+CRLF
		#DEFINE STR0004 ": Elemento "+cCode+" duplicado. "+CRLF
		#DEFINE STR0005 "Linha "
		#DEFINE STR0006 ": VALUE não é do tipo caracter!"+CRLF
		#DEFINE STR0007 ": Campo "+aLine[nI]+" duplicado!"+CRLF
		#DEFINE STR0008 ": Campo "+aLine[nI]+" inválido!"+CRLF
		#DEFINE STR0009 ": Campos insuficientes!"+CRLF
		#DEFINE STR0010 ": Tipo "+cType+" inválido!"+CRLF
		#DEFINE STR0011 "Erro! Modelo "+Alltrim(cCSVModel)+" não existe!"+CRLF
	#ELSE
		#DEFINE STR0001 ": Não é possível encontrar o elemento pai '"+cParent+"' para '"+cCode+"'"+CRLF
		#DEFINE STR0002 ": Elemento pai '"+cParent+"' inválido para '"+cCode+CRLF+"'"
		#DEFINE STR0003 ": Elemento pai não informado para '"+cCode+"'"+CRLF
		#DEFINE STR0004 ": Elemento "+cCode+" duplicado. "+CRLF
		#DEFINE STR0005 "Linha "
		#DEFINE STR0006 ": VALUE não é do tipo caracter!"+CRLF
		#DEFINE STR0007 ": Campo "+aLine[nI]+" duplicado!"+CRLF
		#DEFINE STR0008 ": Campo "+aLine[nI]+" inválido!"+CRLF
		#DEFINE STR0009 ": Campos insuficientes!"+CRLF
		#DEFINE STR0010 ": Tipo "+cType+" inválido!"+CRLF
		#DEFINE STR0011 "Erro! Modelo "+Alltrim(cCSVModel)+" não existe!"+CRLF
	#ENDIF
#ENDIF