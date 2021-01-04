#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "EPI"
	#define STR0004 "EPI Listados por Centro de Costo"
	#define STR0005 "Centro de Costo"
	#define STR0006 "Descripc."
	#define STR0007 "No fue posible grabar el EPI para este centro de costo"
	#define STR0008 "Aviso"
	#define STR0009 "&EPI"
	#define STR0010 "No fue posible grabar el EPI para este centro de costo"
	#define STR0011 "Aviso"
	#define STR0012 "Codigo"
	#define STR0013 "Descripcion del Epi"
	#define STR0014 "No existen EPI registrados."
	#define STR0015 "ATENCION"
	#define STR0016 "Estos son los EPI registrados en el sistema."
	#define STR0017 "Seleccione aquellos que son necesarios para este centro de costo."
	#define STR0018 "Esta informacion no se puede borrar, el EPI consta como "
	#define STR0019 "entregado para algun empleado que pertenece a este centro de costo."
	#define STR0020 "ATENCION"
	#define STR0021 "Clientes"
	#define STR0022 "Centros de Costo"
	#define STR0023 "Buscando requisitos..."
	#define STR0024 "Espere"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "IPE"
		#define STR0004 "IPEs sorted by Cost Center"
		#define STR0005 "Cost Center"
		#define STR0006 "Description"
		#define STR0007 "Unable to save IPE for this cost center."
		#define STR0008 "Warning"
		#define STR0009 "&IPE"
		#define STR0010 "Unable to save IPE for this cost center"
		#define STR0011 "Notice"
		#define STR0012 "Code"
		#define STR0013 "EPI description"
		#define STR0014 "There is no IPE registered."
		#define STR0015 "ATTENTION"
		#define STR0016 "These are IPEs registered in the system."
		#define STR0017 "Select the employees needed for this cost center."
		#define STR0018 "This information cannot be deleted, the PPE appears as "
		#define STR0019 "delivered to one employee that belongs to this cost center."
		#define STR0020 "ATTENTION"
		#define STR0021 "Customers"
		#define STR0022 "Cost centers"
		#define STR0023 "Searching for Requisites..."
		#define STR0024 "Wait"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Epis", "EPIs" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Epis Relacionados Por Centro De Custo", "EPIs Relacionados por Centro de Custo" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Centro De Custo", "Centro de Custo" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Descrição", "Descricao" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Não foi possível gravar o epi para este centro de custo", "Näo foi possivel gravar o EPI para esse centro de custo" )
		#define STR0008 "Aviso"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "&epis", "&EPIs" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Não foi possível gravar o epi para este centro de custo", "Não foi possivel gravar o EPI para esse centro de custo" )
		#define STR0011 "Aviso"
		#define STR0012 "Código"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Descrição Do Epi", "Descrição do Epi" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Não existem epis registados.", "Não existem EPIs cadastrados." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Atenção", "ATENÇÃO" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Estes são os epis registados no sistema.", "Estes são os EPIs cadastrados no sistema." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Seleccione aqueles que são necessários a este centro de custo.", "Selecione aqueles que são necessários a este centro de custo." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Esta informação não poderá ser excluída. O EPI consta como ", "Esta informação não poderá ser excluída, o EPI consta como " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "entregue para algum colaborador que pertence a este centro de custo.", "entregue para algum funcionário que pertence a este centro de custo." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Atenção", "ATENÇÃO" )
		#define STR0021 "Clientes"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Centros De Custo", "Centros de Custo" )
		#define STR0023 "Buscando Requisitos..."
		#define STR0024 "Espere"
	#endif
#endif
