#ifdef SPANISH
	#define STR0001 "Fact Entrada - Conferencia de Items"
	#define STR0002 "Fact Entrada:"
	#define STR0003 "Grupo"
	#define STR0004 "Cod. Item"
	#define STR0005 "Descripcion"
	#define STR0006 "Ctd. Conferencia"
	#define STR0007 "Ctd.:"
	#define STR0008 "Cod. Barra:"
	#define STR0009 "Atencion"
	#define STR0010 "Proveedor:"
	#define STR0011 "¡Fact / Proveedor no encontrado!"
	#define STR0012 "Item no encontrado en la Fact: "
	#define STR0013 "SALIR"
	#define STR0014 "¡Divergencia en la conferencia! ¿Desea comprobar nuevamente?"
	#define STR0015 "<<< BUSCAR >>>"
	#define STR0016 "Filtro"
	#define STR0017 "Fact."
	#define STR0018 "Fecha"
	#define STR0019 "Proveedor"
	#define STR0020 "Dias:"
	#define STR0021 "Alquiler"
	#define STR0022 "No Seleccionado"
	#define STR0023 "Seleccionado"
	#define STR0024 "Verificado"
	#define STR0025 "No Verificado"
#else
	#ifdef ENGLISH
		#define STR0001 "Inflow invoice - Checking of items"
		#define STR0002 "Inflow invoice:"
		#define STR0003 "Group"
		#define STR0004 "Item code"
		#define STR0005 "Description"
		#define STR0006 "Qty. for checking"
		#define STR0007 "Qty.:"
		#define STR0008 "Barcode:"
		#define STR0009 "Attention"
		#define STR0010 "Vendor:"
		#define STR0011 "Invoice/Vendor not found!"
		#define STR0012 "Item not found in invoice: "
		#define STR0013 "EXIT"
		#define STR0014 "Divergence while checking! Check again?"
		#define STR0015 "<<<  SEARCH   >>>"
		#define STR0016 "Filter"
		#define STR0017 "Inv."
		#define STR0018 "Date"
		#define STR0019 "Supplier"
		#define STR0020 "Days"
		#define STR0021 "Renting"
		#define STR0022 "Not Selected"
		#define STR0023 "Selected"
		#define STR0024 "Checked"
		#define STR0025 "Not Checked"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Factura Entrada - Acordo De Itens", "NF Entrada - Conferencia de Itens" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Factura De Entrada:", "NF Entrada:" )
		#define STR0003 "Grupo"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Cod.item", "Cod.Item" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Descrição", "Descricao" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Qtd.acordo", "Qtd.Conferencia" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Qtd.:", "Qtde.:" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Cód.barra:", "Cod.Barra:" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atencao" )
		#define STR0010 "Fornecedor:"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Factura/fornecedor não encontrado!", "NF/Fornecedor nao encontrado!" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Item não encontrado na factura: ", "Item nao encontrado na NF: " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Sair", "SAIR" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Divergência no acordo! deseja conferir novamente?", "Divergencia na conferencia! Deseja conferir novamente?" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "<<< pesquisar >>>", "<<< PESQUISAR >>>" )
		#define STR0016 "Filtro"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Factura", "NF" )
		#define STR0018 "Data"
		#define STR0019 "Fornecedor"
		#define STR0020 "Dias:"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Aluguer", "Locacao" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Não seleccionado", "Não Selecionado" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Seleccionado", "Selecionado" )
		#define STR0024 "Conferido"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Não conferido", "Não Conferido" )
	#endif
#endif
