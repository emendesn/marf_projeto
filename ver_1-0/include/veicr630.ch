#ifdef SPANISH
	#define STR0001 "Flota de Clientes CEV "
	#define STR0002 "Cliente                             Segmento        Cidade-UF                    Vendedor Veículo            Vendedor Peça               Vendedor Serviço"
	#define STR0003 "R  E  S  U  M  E N"
	#define STR0004 " [Otras]  TOTAL"
	#define STR0005 "Cliente                   Cant.IMd Cant.IMd Cant.IMd Cant.IMd Cant.IMd Cant.IMd Cant.IMd Cant.IMd Cant.IMd Cant.IMd Cant.IMd"
	#define STR0006 "Marca/Modelo              Categoría       Operac.        Fab./Mod.  Cant. Fch.Actualiz"
	#define STR0007 "Edad Prom."
	#define STR0008 " anos      Total...:"
	#define STR0009 "T O T A L   G E N E R A L"
	#define STR0010 "¿Marca 6a Columna?"
	#define STR0011 "¿Marca 7a Columna?"
	#define STR0012 "A rayas"
	#define STR0013 "Administracion"
	#define STR0014 "¿Marca 8a Columna?"
	#define STR0015 "¿Marca 9a Columna?"
	#define STR0016 "Vendedor Piezas"
	#define STR0017 "Vendedor Vehiculos"
	#define STR0018 "Vendedor Servicios"
#else
	#ifdef ENGLISH
		#define STR0001 "CEV customer fleet    "
		#define STR0002 "Customer                             Segment        City-UF                    Vehicle Sales Rep            Part Sales Rep               Service Sales Rep"
		#define STR0003 "S U M M A R Y"
		#define STR0004 " [Other ]  TOTAL"
		#define STR0005 "Customer                   Amt.IMd Amt.IMd Amt.IMd Amt.IMd Amt.IMd Amt.IMd Amt.IMd Amt.IMd Amt.IMd Amt.IMd Amt.IMd"
		#define STR0006 "Label/Model              Category       Operation        Manuf./Mod.  Update Qty Days"
		#define STR0007 "Average Age:"
		#define STR0008 "           Total...:"
		#define STR0009 "G R A N D   T O T A L"
		#define STR0010 "Select 6th column?"
		#define STR0011 "Select 7th column?"
		#define STR0012 "Z-form"
		#define STR0013 "Management"
		#define STR0014 "Select 8th column?"
		#define STR0015 "Select 9th column?"
		#define STR0016 "Part Seller"
		#define STR0017 "Vehicle Seller"
		#define STR0018 "Service Seller"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Frota Dos Clientes Cev", "Frota dos Clientes CEV" )
		#define STR0002 "Cliente                             Segmento        Cidade-UF                    Vendedor Veículo            Vendedor Peça               Vendedor Serviço"
		#define STR0003 "R  E  S  U  M  O"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", " [outras]  Total", " [Outras]  TOTAL" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Cliente                   Qtd.IMd Qtd.IMd Qtd.IMd Qtd.IMd Qtd.IMd Qtd.IMd Qtd.IMd Qtd.IMd Qtd.IMd Qtd.IMd Qtd.IMd", "Cliente                   Qtde.IMd Qtde.IMd Qtde.IMd Qtde.IMd Qtde.IMd Qtde.IMd Qtde.IMd Qtde.IMd Qtde.IMd Qtde.IMd Qtde.IMd" )
		#define STR0006 "Marca/Modelo              Categoria       Operacao        Fab./Mod.  Qtde Dt.Atualiz"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Idade Média:", "Idade Media:" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", " Anos      Total...:", " anos      Total...:" )
		#define STR0009 "T O T A L   G E R A L"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Marca 6a.Coluna ?", "Marca 6a Coluna ?" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Marca 7a.Coluna ?", "Marca 7a Coluna ?" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Código de Barras", "Zebrado" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Marca 8a.Coluna ?", "Marca 8a Coluna ?" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Marca 9a.Coluna ?", "Marca 9a Coluna ?" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Vendedor peças", "Vendedor Peças" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Vendedor veículos", "Vendedor Veiculos" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Vendedor serviços", "Vendedor Serviços" )
	#endif
#endif
