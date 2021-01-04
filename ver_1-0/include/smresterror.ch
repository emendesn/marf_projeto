#IFDEF SPANISH
	#define STR0001 "entidade '" + ::model +"' não encontrada ou operação não suportada para ela"
	#define STR0002 "Erro interno do servidor"
	#define STR0003 "Registro não encontrado"
#ELSE
	#IFDEF ENGLISH
		#define STR0001 "entidade '" + ::model +"' não encontrada ou operação não suportada para ela"
		#define STR0002 "Erro interno do servidor"
		#define STR0003 "Registro não encontrado"
	#ELSE
		#define STR0001 "entidade '" + ::model +"' não encontrada ou operação não suportada para ela"
		#define STR0002 "Erro interno do servidor"
		#define STR0003 "Registro não encontrado"
	#ENDIF
#ENDIF
