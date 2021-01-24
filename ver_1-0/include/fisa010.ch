#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Actualizacion de la tabla de municipios"
	#define STR0007 "La suma de los valores de los campos '%Ded. Mat.' e '%Ded. Ser.' no podra exceder el 100% "
	#define STR0008 "Atencion"
	#define STR0009 "Inconsistencia con el Flete Embarcador (SIGAGFE): "
#else
	#ifdef ENGLISH
		#define STR0001 "Search   "
		#define STR0002 "View      "
		#define STR0003 "Insert "
		#define STR0004 "Edit   "
		#define STR0005 "Delete "
		#define STR0006 "City table update"
		#define STR0007 "The sum of values of fields 'Mat. Ded.%' and 'Ser. Ded.%' cannot exceed 100% "
		#define STR0008 "Attention"
		#define STR0009 "Inconsistency with Shipper Freight (SIGAGFE): "
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Actualizaçäo da tabela de concelho", "Atualizacao da tabela de municipios" )
		#define STR0007 "A soma dos valores dos campos '%Ded. Mat.' e '%Ded. Ser.' não poderá ultrapassar o valor de 100% "
		#define STR0008 "Atenção"
		#define STR0009 "Inconsistência com o Frete Embarcador (SIGAGFE): "
	#endif
#endif
