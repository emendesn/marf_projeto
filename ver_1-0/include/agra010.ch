#ifdef SPANISH
	#define STR0001 "Archivo de parcelas"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Leyenda"
	#define STR0008 "Parcela abierta"
	#define STR0009 "Parcela finalizada"
	#define STR0010 "La suma de las cantidades por variedad no puede ser diferente del total de la parcela."
	#define STR0011 "No se permite dividir la misma parcela con la misma variedad."
	#define STR0012 "Variedad inexistente o Produco definido en la Variedad es divergente al Producto definido en el encanbezado del talon."
#else
	#ifdef ENGLISH
		#define STR0001 "Plots of Land"
		#define STR0002 "Search "
		#define STR0003 "View "
		#define STR0004 "Add "
		#define STR0005 "Edit "
		#define STR0006 "Delete "
		#define STR0007 "Caption"
		#define STR0008 "Open plot "
		#define STR0009 "Closed plot "
		#define STR0010 "The addition of quantities by variety cannot difer from the plot total. "
		#define STR0011 "No plot is allowed to be shared with the same variety. "
		#define STR0012 "Non existent variety or Product defined in the Variety different from the Product defined in the cultivated land header."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Talh�es", "Talhoes" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 "Legenda"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Terreno De Cultivo Aberto", "Talhao Aberto" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Terreno De Cultivo Fechado", "Talhao Fechado" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "A soma das quantidades por variedade n�o pode ser diferente do total do terreno de cultivo.", "A soma das quantidades por variedade n�o pode ser diferente do total do talhao." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "N�o � permitido dividir o mesmo terreno de cultivo com a mesma variedade.", "Nao � permitido dividir o mesmo talhao com a mesma variedade." )
		#define STR0012 "Variedade inexistente ou Produto definido na Variedade est� divergente ao Produto definido no cabe�alho do talh�o."
	#endif
#endif
