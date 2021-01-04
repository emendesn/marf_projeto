#ifdef SPANISH
	#define STR0001 "�Usuario sin permiso para esta rutina!"
	#define STR0002 "Atencion"
	#define STR0003 "Idiomas"
	#define STR0004 "Idiomas / Palabras Reservadas"
	#define STR0005 "Idiomas"
	#define STR0006 "Palabras Reservadas"
	#define STR0007 "ApSxWordReserved"
	#define STR0008 "No se permite el caracter ',' . Retire este caracter de la palabra."
	#define STR0009 "Buscar"
	#define STR0010 "Incluir"
	#define STR0011 "Borrar   "
	#define STR0012 "Visualizar"
	#define STR0013 "Modificar"
	#define STR0014 "Imprimir"
	#define STR0015 "No se permiten espacios. Informe una palabra por linea, sin espacios."
	#define STR0016 "Help"
#else
	#ifdef ENGLISH
		#define STR0001 "User not allowed to access this routine!"
		#define STR0002 "Attention"
		#define STR0003 "Languages"
		#define STR0004 "Languages/Reserved Words"
		#define STR0005 "Languages"
		#define STR0006 "Reserved Words"
		#define STR0007 "ApSxWordReserved"
		#define STR0008 "The ',' (comma) character is not allowed. Remove it."
		#define STR0009 "Search"
		#define STR0010 "Add"
		#define STR0011 "Delete   "
		#define STR0012 "View"
		#define STR0013 "Change"
		#define STR0014 "Print"
		#define STR0015 "Spaces are not allowed. Enter one word per line, without spaces."
		#define STR0016 "Help"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Utilizador sem permiss�o para este procedimento.", "Usu�rio sem permiss�o a esta rotina!" )
		#define STR0002 "Aten��o"
		#define STR0003 "Idiomas"
		#define STR0004 "Idiomas / Palavras Reservadas"
		#define STR0005 "Idiomas"
		#define STR0006 "Palavras Reservadas"
		#define STR0007 "ApSxWordReserved"
		#define STR0008 "N�o � permitido o caracter ','. Retire esse caracter da palavra."
		#define STR0009 "Pesquisar"
		#define STR0010 "Incluir"
		#define STR0011 "Excluir   "
		#define STR0012 "Visualizar"
		#define STR0013 "Alterar"
		#define STR0014 "Imprimir"
		#define STR0015 "N�o s�o permitidos espa�os. Informe uma palavra por linha, sem espa�os."
		#define STR0016 "Help"
	#endif
#endif