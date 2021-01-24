#ifdef SPANISH
	#define STR0001 "Configura��o de Balan�a"
	#define STR0002 'Retorno de comunica��o com a balan�a'
	#define STR0003 'Aten��o:'
	#define STR0004 "Caracteres de retorno"
	#define STR0005 "Ajuste o campo Script, para retornar somente os caracteres ref. ao peso;"
	#define STR0006 "-Para isso identifique o Caracter que indica o inicio do envio dos dados;"
	#define STR0007 "-Inclua uma formula no Campo Script Ex: Substr(cConteudo,at(Chr(002),cConteudo)+3,7);"
	#define STR0008 "-� importante que utilize at() para identificar onde se inicia o peso, pois isto torna o retorno mais dinamico."
	#define STR0009 'N�o foi poss�vel Capturar o Retorno'
#else
	#ifdef ENGLISH
		#define STR0001 "Scale Configuration"
		#define STR0002 'Scale communication return'
		#define STR0003 'Attention:'
		#define STR0004 "Return characters"
		#define STR0005 "Adjust the Script field, to retrieve only the characters regarding weight;"
		#define STR0006 "-For this, identify the Character that indicates the start of data sending;"
		#define STR0007 "-Include a formula on the Script field Ex: Substr(cConteudo,at(Chr(002),cConteudo)+3,7);"
		#define STR0008 "-It is important to use at() to identify where the weight starts, because it makes return more dynamic."
		#define STR0009 'Return could not be Collected'
	#else
		#define STR0001 "Configura��o de Balan�a"
		#define STR0002 'Retorno de comunica��o com a balan�a'
		#define STR0003 'Aten��o:'
		#define STR0004 "Caracteres de retorno"
		#define STR0005 "Ajuste o campo Script, para retornar somente os caracteres ref. ao peso;"
		#define STR0006 "-Para isso identifique o Caracter que indica o inicio do envio dos dados;"
		#define STR0007 "-Inclua uma formula no Campo Script Ex: Substr(cConteudo,at(Chr(002),cConteudo)+3,7);"
		#define STR0008 "-� importante que utilize at() para identificar onde se inicia o peso, pois isto torna o retorno mais dinamico."
		#define STR0009 'N�o foi poss�vel Capturar o Retorno'
	#endif
#endif
