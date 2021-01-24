#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Archivo de Modelos de Vehiculos"
	#define STR0007 "&Garantia"
	#define STR0008 "&Opcionales de Fabrica"
	#define STR0009 "&Precios"
	#define STR0010 "&Bonus"
	#define STR0011 "-> Carpeta Garantia"
	#define STR0012 "Kits"
	#define STR0013 "Items &Entrega"
	#define STR0014 "Necesario informar la fecha de validad - Solapa Precios"
	#define STR0015 "¡Atencion!"
	#define STR0016 "% Venta Directa"
	#define STR0017 "Componentes del Modelo"
	#define STR0018 "Modelo ya registrado"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Vehicles Models File"
		#define STR0007 "&Warranty"
		#define STR0008 "&Optional Items"
		#define STR0009 "&Prices"
		#define STR0010 "&Bonus"
		#define STR0011 "->Guarantee folder"
		#define STR0012 "Kits"
		#define STR0013 "Items &Delivery"
		#define STR0014 "You must enter maturity date - folder Prices"
		#define STR0015 "Attention"
		#define STR0016 "Direct Sale %"
		#define STR0017 "Model Components"
		#define STR0018 "Model already registered."
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Registo De Modelos De Veiculos", "Cadastro de Modelos de Veiculos" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "&garantia", "&Garantia" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "&opcionais De Fabrica", "&Opcionais de Fabrica" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "&preços", "&Precos" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "&bônus", "&Bonus" )
		#define STR0011 "-> Pasta Garantia"
		#define STR0012 "Kits"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Elementos &Entrega", "Itens &Entrega" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "É necessário informar a data de validade - Aba Preços", "Necessário informar a data de validade - Aba Preços" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atencao" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "% Venda Directa", "% Venda Direta" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Componentes do modelo", "Componentes do Modelo" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Modelo já registado", "Modelo já cadastrado" )
	#endif
#endif
