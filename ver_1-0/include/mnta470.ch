#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Movimientos"
	#define STR0007 "Archivo de Bienes"
	#define STR0008 "Archivo de Movimientos"
	#define STR0009 "Bien.....:"
	#define STR0010 "Familia.:"
	#define STR0011 "C.Costo"
	#define STR0012 "C.Trabajo"
	#define STR0013 "Datos Actuales del Bien"
	#define STR0014 "Datos del Movimiento Anterior"
	#define STR0015 "Fecha"
	#define STR0016 "Hora"
	#define STR0017 "Datos del Movimiento Posterior"
	#define STR0018 "Datos del Movimiento"
	#define STR0019 "Fecha debera ser menor o igual a fecha actual"
	#define STR0020 "NO CONFORMIDAD"
	#define STR0021 "Utilizacion"
	#define STR0022 "Contador 1"
	#define STR0023 "Contador 2"
	#define STR0024 "Observacion"
	#define STR0025 "Procesando Archivo"
	#define STR0026 "Centro de costo informado debera ser diferente"
	#define STR0027 "del centro de costo anterior y/o posterior"
	#define STR0028 "Centro de costo informado..:  "
	#define STR0029 "Centro de costo anterior......:  "
	#define STR0030 "Centro de costo posterior....:  "
	#define STR0031 "Utilizado"
	#define STR0032 "Parado"
	#define STR0033 "Desplazamiento"
	#define STR0034 "Fch. Ult. Seguim."
	#define STR0035 "Contador"
	#define STR0036 "Variacion Dia"
	#define STR0037 "Acumulado"
	#define STR0038 "El primer movimiento del bien no puede borrarse."
	#define STR0039 "Desea seleccionar ordenes de servicio para"
	#define STR0040 "tranferirse de centro de costo tambien."
	#define STR0041 "�Confirma?"
	#define STR0042 "ATENCION"
	#define STR0043 "�Desea que se compruebe la existencia de O.S. automatica por contador?"
	#define STR0044 "Confirma (Si/No)"
	#define STR0045 "Centro de trabajo informado.:  "
	#define STR0046 "Centro de trabajo anterior..:  "
	#define STR0047 "Centro de trabajo posterior.:  "
	#define STR0048 "Centro de trabajo informado deber� ser diferente"
	#define STR0049 "del centro de trabajo anterior y/o posterior"
	#define STR0050 "o"
	#define STR0051 "Tag"
	#define STR0052 "El Bien contiene orden de servicio con insumo aplicado y no puede borrarse."
	#define STR0053 "El Bien contiene solicitud de compra para el producto y no puede borrarse."
	#define STR0054 "El Bien contiene cotizacion para el producto y no puede borrarse."
	#define STR0055 "La fecha inicio de la movimentacion del bien debe estar en el mes igual o superior de la fecha informada en el parametro MV_ULTDEPR = "
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Transactions"
		#define STR0007 "Assets file "
		#define STR0008 "Asset Transactions"
		#define STR0009 "Asset...:"
		#define STR0010 "Family..:"
		#define STR0011 "Cost Center"
		#define STR0012 "Work Center"
		#define STR0013 "Current asset info"
		#define STR0014 "Previous transaction info"
		#define STR0015 "Date"
		#define STR0016 "Time"
		#define STR0017 "Later transaction information"
		#define STR0018 "Transaction information"
		#define STR0019 "Date must be lower than or equal to current date"
		#define STR0020 "NON-CONFORMANCE"
		#define STR0021 "Use"
		#define STR0022 "Counter 1"
		#define STR0023 "Counter 2"
		#define STR0024 "Notes"
		#define STR0025 "Processing file"
		#define STR0026 "Cost center entered must be different"
		#define STR0027 "from prior and/or later cost center"
		#define STR0028 "Cost center entered........:  "
		#define STR0029 "Prior cost center.............:  "
		#define STR0030 "Later cost center............:  "
		#define STR0031 "Used"
		#define STR0032 "Stopped"
		#define STR0033 "Relocation"
		#define STR0034 "Dt. Lst. Fll-up"
		#define STR0035 "Counter"
		#define STR0036 "Day variation"
		#define STR0037 "Accumulated"
		#define STR0038 "The first asset transaction cannot be deleted."
		#define STR0039 "Will you select service orders to be "
		#define STR0040 "tranferred from the cost center, too. "
		#define STR0041 "Confirm? "
		#define STR0042 "ATTENTION"
		#define STR0043 "Will you check existence of automatic S.O. per counter? "
		#define STR0044 "Confirm (Yes/No)"
		#define STR0045 "Work Center entered.:  "
		#define STR0046 "Prior Work Center..:  "
		#define STR0047 "Later Work Center.:  "
		#define STR0048 "Work center entered must be different"
		#define STR0049 "from the prior/later work center"
		#define STR0050 "or"
		#define STR0051 "Tag"
		#define STR0052 "The asset has service order with applied input and cannot be deleted."
		#define STR0053 "The asset has purchase request for the product and cannot be deleted."
		#define STR0054 "The asset has product quotation and cannot be deleted."
		#define STR0055 "Start date of asset movement must be in the month equal to or later than date entered in parameter MV_ULTDEPR = "
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Movimento", "Movimentacao" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Registo De Bens", "Cadastro de Bens" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Registo De Movimenta��o", "Cadastro de Movimentacao" )
		#define STR0009 "Bem"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Fam�lia", "Familia" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "C.custo", "C.Custo" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "C.trabalho", "C.Trabalho" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Dados Actuais Do Artigo", "Dados Atuais Do Bem" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Dados Da Movimenta��o Anterior", "Dados Da Movimentacao Anterior" )
		#define STR0015 "Data"
		#define STR0016 "Hora"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Dados Da Movimenta��o Posterior", "Dados Da Movimentacao Posterior" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Dados Da Movimenta��o", "Dados Da Movimentacao" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Data dever� ser menor ou igual � data actual", "Data devera ser menor ou igual a data atual" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "N�o Conformidade", "NAO CONFORMIDADE" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Utiliza��o", "Utilizacao" )
		#define STR0022 "Contador 1"
		#define STR0023 "Contador 2"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Observa��o", "Observacao" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "A Processar Ficheiro", "Processando Arquivo" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Centro de custo indicado devera ser diferente", "Centro de custo informado devera ser diferente" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Do centro de custo anterior e/ou posterior", "do centro de custo anterior e/ou posterior" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Centro de custo indicado..:  ", "Centro de custo informado..:  " )
		#define STR0029 "Centro de custo anterior......:  "
		#define STR0030 "Centro de custo posterior....:  "
		#define STR0031 "Utilizado"
		#define STR0032 "Parado"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Desloca��o", "Deslocamento" )
		#define STR0034 "Dt. Ult. Acomp."
		#define STR0035 "Contador"
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Varia��o Dia", "Variacao Dia" )
		#define STR0037 "Acumulado"
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "A primeira movimenta��o do bem n�o pode ser eliminada.", "A primeira movimenta��o do bem, n�o pode ser exclu�da." )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Deseja seleccionar ordens de servi�o para serem", "Deseja selecionar ordens de servico para serem" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Tranferidas de centro de custo tamb�m.", "tranferidas de centro de custo tambem." )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Confirmar ?", "Confirma ?" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Aten��o", "ATEN��O" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Deseja que seja verificada a exist�ncia autom�tica de ordens de servi�o por contabilista?", "Deseja que seja verificado a exist�ncia de o.s autom�tica por contador?" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Confirmar (sim/n�o)", "Confirma (Sim/N�o)" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Centro de trabalho introduzido.:  ", "Centro de trabalho informado.:  " )
		#define STR0046 "Centro de trabalho anterior..:  "
		#define STR0047 "Centro de trabalho posterior.:  "
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Centro de trabalho introduzido dever� ser diferente", "Centro de trabalho informado dever� ser diferente" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Do centro de trabalho anterior e/ou posterior", "do centro de trabalho anterior e/ou posterior" )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", "Ou", "ou" )
		#define STR0051 "Tag"
		#define STR0052 If( cPaisLoc $ "ANG|PTG", "O bem cont�m ordem de servi�o com insumo aplicado e n�o pode ser eliminado.", "O Bem cont�m ordem de servi�o com insumo aplicado e n�o pode ser exclu�do." )
		#define STR0053 If( cPaisLoc $ "ANG|PTG", "O bem cont�m solicita��o de compra para o artigo e n�o pode ser eliminado.", "O Bem cont�m solicita��o de compra para o produto e n�o pode ser exclu�do." )
		#define STR0054 If( cPaisLoc $ "ANG|PTG", "O bem cont�m conta��o para o artigo e n�o pode ser eliminado.", "O Bem cont�m conta��o para o produto e n�o pode ser exclu�do." )
		#define STR0055 "A data in�cio da movimenta��o do bem deve estar no m�s igual ou superior da data informada no par�metro MV_ULTDEPR = "
	#endif
#endif
