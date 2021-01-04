#ifdef SPANISH
	#define STR0001 "Vínculo Bloques vs. Volúmenes"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Separar en bloques"
	#define STR0005 "Imprimir"
	#define STR0006 "Leyenda"
	#define STR0007 "Espere"
	#define STR0008 "Actualizando datos"
	#define STR0009 "Creando Interface"
	#define STR0010 "Volúmenes para Bloque"
	#define STR0011 "Cod. Bloque:"
	#define STR0012 "Ctd. Máxima"
	#define STR0013 "Ctd. Seleccionada"
	#define STR0014 "Marca/Desmarca Todos"
	#define STR0015 "Atención"
	#define STR0016 "Seleccione un bloque antes de seleccionar la lista de volúmenes"
	#define STR0017 "OK"
	#define STR0018 "Al seleccionar todas las líneas, se sobrepasará la capacidad máxima del bloque."
	#define STR0019 " Seleccione manualmente los volúmenes"
	#define STR0020 "Alcanzada la capacidad máxima del bloque."
	#define STR0021 "Está seguro que los volúmenes seleccionados deben adicionarse al bloque: "
	#define STR0022 "Salvando alteraciones"
	#define STR0023 "Se excluyeron los volúmenes al bloque que se está visualizando."
	#define STR0024 "¿Desea salvar estas informaciones?"
#else
	#ifdef ENGLISH
		#define STR0001 "Blocks x Packages Binding"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Organize in blocks"
		#define STR0005 "Print"
		#define STR0006 "Caption"
		#define STR0007 "Wait"
		#define STR0008 "Updating data"
		#define STR0009 "Creating Interface"
		#define STR0010 "Packages for Block"
		#define STR0011 "Block Code:"
		#define STR0012 "Max. Qty."
		#define STR0013 "Selected Qty."
		#define STR0014 "Mark/Unmark All"
		#define STR0015 "Attention"
		#define STR0016 "Select a block before selecting list of packages"
		#define STR0017 "OK"
		#define STR0018 "If all lines are selected, the maximum capacity of block is exceeded."
		#define STR0019 "Select packages manually"
		#define STR0020 "Maximum capacity of block has been reached"
		#define STR0021 "Are you sure selected packages must be added to block: "
		#define STR0022 "Saving changes"
		#define STR0023 "Some packages were deleted from displayed block."
		#define STR0024 "Do you wish to save this information?"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Amarração Blocos x Fardos", "Amarracao Blocos x Fardos" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Blocar"
		#define STR0005 "Imprimir"
		#define STR0006 "Legenda"
		#define STR0007 "Aguarde"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "A actualizar dados", "Atualizando dados" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A criar Interface", "Criando Interface" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Fardos para bloco", "Fardos para Bloco" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Cód. Bloco:", "Cod. Bloco:" )
		#define STR0012 "Qtd. Máxima"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Qtd. Seleccionada", "Qtd. Selecionada" )
		#define STR0014 "Marca/Desmarca Todos"
		#define STR0015 "Atenção"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Seleccione um bloco antes de escolher a lista de fardos", "Selecione um bloco antes de selecionar a lista de fardos" )
		#define STR0017 "OK"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Se todas as linhas forem seleccionadas, excederá a capacidade máxima do bloco.", "Se todas as linhas forem selecionadas, irá exceder a capacidade máxima do bloco." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", " Seleccione os fardos manualmente", " Selecione os fardos manualmente" )
		#define STR0020 "A capacidade máxima do bloco já foi atingida"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Tem certeza que os fardos seleccionados devem ser adicionados ao bloco: ", "Tem certeza que os fardos selecionados deve ser adicionado ao bloco: " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "A  gravar alterações", "Salvando alterações" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Foram excluídos alguns fardos do bloco que está a ser visualizado.", "Foram excluidos alguns fardos do bloco que está sendo visualizado." )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Deseja gravar estas informações?", "Deseja salvar estas informações?" )
	#endif
#endif
