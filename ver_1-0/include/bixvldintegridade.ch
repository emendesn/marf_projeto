#ifdef SPANISH
	#define STR0001 'No fue posible abrir la tabla que se verificará: '
	#define STR0002 'Parametro recibido por la funcion en formato invalido o vacio.'
#else
	#ifdef ENGLISH
		#define STR0001 'Não foi possível abrir a tabela a ser verificada: '
		#define STR0002 'Parâmetro recebido pela funcao em formato invalido ou vazio.'
	#else
		#define STR0001 'Não foi possível abrir a tabela a ser verificada: '
		#define STR0002 If( cPaisLoc $ "ANG|PTG", 'Parâmetro recebido pela função em formato inválido ou vazio.', 'Parâmetro recebido pela funcao em formato invalido ou vazio.' )
	#endif
#endif
