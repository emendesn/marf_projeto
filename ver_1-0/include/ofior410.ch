#ifdef SPANISH
	#define STR0001 "Lista de Ventas Perdidas"
	#define STR0002 "A rayas"
	#define STR0003 "Administracion"
	#define STR0004 "Creando Archivo de Trabajo"
	#define STR0005 "Total General............................................................."
	#define STR0006 "...............G R U P O  D E  P A R T E S................................"
	#define STR0007 "......................U S U A R I O....................................."
	#define STR0008 "..............C E N T R O  D E  C O S T O..............................."
	#define STR0009 "......................M O T I V O......................................."
	#define STR0010 "........................F E C H A........................................."
	#define STR0011 "Lista de Solicitud de Compras"
	#define STR0012 "     Grupo  C�d. Pe�a              Descri��o            Qt.Item Qt.Est Qt.Ped     Valor   CLiente                    Fone       Obs.       Data"
	#define STR0013 "Data Inicial ?"
	#define STR0014 "Data Final ?"
	#define STR0015 "Formula p/preco de pecas ?"
	#define STR0016 "Agrupar por ?"
	#define STR0017 "Grupo de Pe�as"
	#define STR0018 "Usu�rio"
	#define STR0019 "Centro de Custo"
	#define STR0020 "Motivo"
	#define STR0021 "Data"
	#define STR0022 "Tipo ?"
	#define STR0023 "Req. de Compras"
	#define STR0024 "Vendas Perdidas"
	#define STR0025 "Forma de C�lculo?"
	#define STR0026 "F�rmula"
	#define STR0027 "Valor Gravado"
	#define STR0028 "Motivos n�o considerados"
#else
	#ifdef ENGLISH
		#define STR0001 "Lost Sales Relation"
		#define STR0002 "Z-Form "
		#define STR0003 "Management   "
		#define STR0004 "Creating Work File         "
		#define STR0005 "Grand Total............................................................."
		#define STR0006 "...............P A R T S  G R O U P........................................."
		#define STR0007 "......................U S E R..........................................."
		#define STR0008 "..............C O S T  C E N T E R......................................"
		#define STR0009 "......................R E A S O N......................................."
		#define STR0010 "........................D A T E........................................."
		#define STR0011 "Purchase Request Relation"
		#define STR0012 "     Group Code Part              Description            Qty Item St.Qty Order Qty     Value   Customer                    Phone       Note       Date"
		#define STR0013 "Start Date?"
		#define STR0014 "End Date?"
		#define STR0015 "Formula for spare parts price?"
		#define STR0016 "Group by?"
		#define STR0017 "Spare parts group"
		#define STR0018 "User"
		#define STR0019 "Cost Center"
		#define STR0020 "Reason"
		#define STR0021 "Date"
		#define STR0022 "Type  ?"
		#define STR0023 "Purchase Order"
		#define STR0024 "Lost Sales"
		#define STR0025 "Calculation Method?"
		#define STR0026 "Formula"
		#define STR0027 "Value saved"
		#define STR0028 "Reasons not considered"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Rela��o de Vendas Perdidas", "Relacao de Vendas Perdidas" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Criando Arquivo De Trabalho", "Criando Arquivo de Trabalho" )
		#define STR0005 "Total Geral............................................................."
		#define STR0006 "...............G R U P O  D E  P E C A S................................"
		#define STR0007 "......................U S U A R I O....................................."
		#define STR0008 "..............C E N T R O  D E  C U S T O..............................."
		#define STR0009 "......................M O T I V O......................................."
		#define STR0010 "........................D A T A........................................."
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Rela��o de Requisi��o de Compras", "Relacao de Requisicao de Compras" )
		#define STR0012 "     Grupo  C�d. Pe�a              Descri��o            Qt.Item Qt.Est Qt.Ped     Valor   CLiente                    Fone       Obs.       Data"
		#define STR0013 "Data Inicial ?"
		#define STR0014 "Data Final ?"
		#define STR0015 "Formula p/preco de pecas ?"
		#define STR0016 "Agrupar por ?"
		#define STR0017 "Grupo de Pe�as"
		#define STR0018 "Usu�rio"
		#define STR0019 "Centro de Custo"
		#define STR0020 "Motivo"
		#define STR0021 "Data"
		#define STR0022 "Tipo ?"
		#define STR0023 "Req. de Compras"
		#define STR0024 "Vendas Perdidas"
		#define STR0025 "Forma de C�lculo?"
		#define STR0026 "F�rmula"
		#define STR0027 "Valor Gravado"
		#define STR0028 "Motivos n�o considerados"
	#endif
#endif
