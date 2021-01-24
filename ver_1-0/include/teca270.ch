#ifdef SPANISH
	#define STR0001 "Inspeccion Tecnica"
	#define STR0002 "Pendiente"
	#define STR0003 "Agendado"
	#define STR0004 "Concluido"
	#define STR0005 "Anulado"
	#define STR0006 "Buscar"
	#define STR0007 "Visualizar"
	#define STR0008 "Incluir"
	#define STR0009 "Modificar"
	#define STR0010 "Borrar"
	#define STR0013 "Categoria"
	#define STR0014 "Importar Propuesta"
	#define STR0015 "Visualizar Propuesta"
	#define STR0016 "CRM Simulador"
	#define STR0017 "Producto(s)"
	#define STR0018 "Accesorio(s)"
	#define STR0019 "Valor Total de Items Inspeccionados"
	#define STR0020 "Atencion"
	#define STR0021 "�Desea visualizar la propuesta comercial antes de la importacion?"
	#define STR0022 "�Desea importar los productos / accesorios de la propuesta comercial para al inspeccion tecnica?"
	#define STR0023 "( A ) - Producto(s)"
	#define STR0024 "( B ) - Accesorio(s)"
	#define STR0025 "( A+B )"
	#define STR0026 "�Propuesta Comercial importada con exito!"
	#define STR0027 "Agendar / Reagendar"
	#define STR0028 "Imprimir Modelo"
	#define STR0029 "�Desea agendar esta inspeccion tecnica ahora?"
	#define STR0030 "El Tecnico ya posee asignacion en el periodo escogido."
	#define STR0031 "Conocimiento"
	#define STR0032 "Imprime Inspeccion"
	#define STR0033 "No se pueden borrar Inspecciones Tecnicas de oportunidades que no esten pendientes."
	#define STR0034 "No se pueden modificar Inspecciones Tecnicas de oportunidades que no esten pendientes."
	#define STR0035 "Vis. Presup. Serv."
	#define STR0036 "Actualiza Presup. Servicios"
	#define STR0037 "Remover Presup. Servicios"
	#define STR0038 "Visualizar propuesta"
#else
	#ifdef ENGLISH
		#define STR0001 "Technical Inspection"
		#define STR0002 "Open"
		#define STR0003 "Scheduled"
		#define STR0004 "Completed"
		#define STR0005 "Canceled"
		#define STR0006 "Search"
		#define STR0007 "View"
		#define STR0008 "Add"
		#define STR0009 "Change"
		#define STR0010 "Delete"
		#define STR0013 "Category"
		#define STR0014 "Import Proposal"
		#define STR0015 "View Proposal"
		#define STR0016 "CRM - Simulator"
		#define STR0017 "Product(s)"
		#define STR0018 "Accessory(ies)"
		#define STR0019 "Total Value of Inspected Items"
		#define STR0020 "Attention"
		#define STR0021 "Do you want to view the business proposal before import?"
		#define STR0022 "Do you want to import products/accessories from the business proposal to the technical inspection?"
		#define STR0023 "( A ) - Product(s)"
		#define STR0024 "( B ) - Accessory(ies)"
		#define STR0025 "( A+B )"
		#define STR0026 "Business Proposal successfully imported!"
		#define STR0027 "Schedule/Reschedule"
		#define STR0028 "Print Model"
		#define STR0029 "Want to schedule a technical inspection now?"
		#define STR0030 "The Technician is already allocated in this period."
		#define STR0031 "Knowledge"
		#define STR0032 "Prints Inspection"
		#define STR0033 "You cannot delete Technical Inspections of opportunities not open."
		#define STR0034 "You cannot change Technical Inspections of opportunities not open."
		#define STR0035 "View Serv. Quot."
		#define STR0036 "Update Budg. Services"
		#define STR0037 "Remove Budg. Services"
		#define STR0038 "View proposal"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Inspec��o T�cnica", "Vistoria T�cnica" )
		#define STR0002 "Aberto"
		#define STR0003 "Agendado"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Conclu�do", "Concluido" )
		#define STR0005 "Cancelado"
		#define STR0006 "Pesquisar"
		#define STR0007 "Visualizar"
		#define STR0008 "Incluir"
		#define STR0009 "Alterar"
		#define STR0010 "Excluir"
		#define STR0013 "Categoria"
		#define STR0014 "Importar Proposta"
		#define STR0015 "Visualizar Proposta"
		#define STR0016 "CRM Simulador"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Artigo(s)", "Produto(s)" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Acess�rio(s)", "Acessorio(s)" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Valor total dos itens inspeccionados", "Valor Total dos Itens Vistoriados" )
		#define STR0020 "Aten��o"
		#define STR0021 "Deseja visualizar a proposta comercial antes da importa��o?"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Deseja importar os artigos / acess�rios da proposta comercial para a inspec��o t�cnica?", "Deseja importar os produtos / acess�rios da proposta comercial para a vistoria t�cnica?" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "( A ) - Artigo(s)", "( A ) - Produto(s)" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "( B ) - Acess�rio(s)", "( B ) - Acessorio(s)" )
		#define STR0025 "( A+B )"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Proposta comercial importada com sucesso.", "Proposta Comercial importada com sucesso!" )
		#define STR0027 "Agendar / Reagendar"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Imprimir modelo", "Imprimir Modelo" )
		#define STR0029 "Deseja agendar esta vistoria t�cnica agora?"
		#define STR0030 "O T�cnico j� possui aloca��o no per�odo escolhido."
		#define STR0031 "Conhecimento"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Imprime vistoria", "Imprime Vistoria" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "N�o � poss�vel eliminar Vistorias t�cnicas de oportunidades que n�o estejam abertas.", "N�o � poss�vel excluir Vistorias T�cnicas de oportunidades que n�o estejam abertas." )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "N�o � poss�vel alterar Vistorias t�cnicas de oportunidades que n�o estejam abertas.", "N�o � poss�vel alterar Vistorias T�cnicas de oportunidades que n�o estejam abertas." )
		#define STR0035 "Vis. Or�am. Serv."
		#define STR0036 "Atualiza Orc. Servi�os"
		#define STR0037 "Remover Orc. Servi�os"
		#define STR0038 "Visualizar proposta"
	#endif
#endif
