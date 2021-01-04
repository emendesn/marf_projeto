#ifdef SPANISH
	#define STR0001 "Procesamiento de cotizaciones"
	#define STR0002 "No hay Proveedores por consultar."
	#define STR0003 "Item invalido PWSF065"
	#define STR0004 "Parametro invalido PWSF065"
	#define STR0005 "Cotizacion numero: "
	#define STR0006 " grabada con exito."
	#define STR0007 "Error"
	#define STR0008 "Resultado busqueda"
	#define STR0009 " - Propuestas"
	#define STR0010 "Propuesta numero : "
	#define STR0011 "No se encontro propuesta."
	#define STR0012 "Modificacion cotizacion"
	#define STR0013 "Incluir propuesta"
	#define STR0014 "CONTACTO"
	#define STR0015 "Atencion"
	#define STR0016 " �registrado con EXITO!"
	#define STR0017 "Fecha de vigencia"
	#define STR0018 "De:"
	#define STR0019 "A:"
	#define STR0020 "Estatus de las cotizaciones:"
	#define STR0021 "Todos"
	#define STR0022 "Abiertos"
	#define STR0023 "Cerrados"
	#define STR0024 "Buscar"
	#define STR0025 "Volver"
	#define STR0026 "Periodo de vigencia:"
	#define STR0027 " - Estatus:"
	#define STR0028 "Busqueda avanzada:"
	#define STR0029 "Numero de cotizacion"
	#define STR0030 "ESTATUS"
	#define STR0031 "ABIERTO"
	#define STR0032 "Incluir_Propuesta"
	#define STR0033 "Modificar_Cotizacion"
	#define STR0034 "Calcular_Cotizacion"
	#define STR0035 "Grabar_Cotizacion"
	#define STR0036 "Valor total de la cotizacion"
	#define STR0037 "Finalizar"
	#define STR0038 "Items"
#else
	#ifdef ENGLISH
		#define STR0001 "Quotation processing     "
		#define STR0002 "No suppliers to search.         "
		#define STR0003 "Invalid item PWSF065"
		#define STR0004 "Invalid parameter PWSF065"
		#define STR0005 "Quotation number"
		#define STR0006 " saved successfully. "
		#define STR0007 "Error"
		#define STR0008 "Search result  "
		#define STR0009 " - Proposals"
		#define STR0010 "Proposal Number : "
		#define STR0011 "Proposal not found."
		#define STR0012 "Quote Alteration"
		#define STR0013 "Include Proposal"
		#define STR0014 "CONTACT"
		#define STR0015 "Note"
		#define STR0016 "recorded SUCCESSFULLY!"
		#define STR0017 "Validity date"
		#define STR0018 "From:"
		#define STR0019 "To:"
		#define STR0020 "Quotations status:"
		#define STR0021 "All"
		#define STR0022 "Open"
		#define STR0023 "Closed"
		#define STR0024 "Search"
		#define STR0025 "Return"
		#define STR0026 "Validity Period:"
		#define STR0027 " - Status :"
		#define STR0028 "Advanced search:"
		#define STR0029 "Quotation number"
		#define STR0030 "STATUS"
		#define STR0031 "OPEN"
		#define STR0032 "Add_Proposal"
		#define STR0033 "Change_Quotation"
		#define STR0034 "Calculate_Quotation"
		#define STR0035 "Save_Quotation"
		#define STR0036 "Total quotation value"
		#define STR0037 "Close"
		#define STR0038 "Items"
	#else
		#define STR0001 "Processamento de cota��es"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "N�o h� fornecedores a consultar.", "N�o h� Fornecedores a consultar." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Elemento Inv�lido Pwsf065", "Item invalido PWSF065" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Par�metro Inv�lido Pwsf065", "Parametro invalido PWSF065" )
		#define STR0005 "Cota��o n�mero: "
		#define STR0006 " gravada com sucesso."
		#define STR0007 "Erro"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Resultado Da Busca", "Resultado Busca" )
		#define STR0009 " - Propostas"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Proposta n�mero : ", "Proposta Numero : " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Proposta n�o encontrada.", "Proposta n�o encontrada." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Altera��o Da Cota��o", "Alterac�o Cotac�o" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Inclus�o Da Proposta", "Inclus�o Proposta" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Contacto", "CONTATO" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Atenc�o" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", " Registado Com Sucesso!", " cadastrado com SUCESSO!" )
		#define STR0017 "Data de Validade"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "De:", "De  :" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "At�:", "At� :" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Estado das cota��es:", "Status das Cota��es :" )
		#define STR0021 "Todos"
		#define STR0022 "Abertos"
		#define STR0023 "Fechados"
		#define STR0024 "Buscar"
		#define STR0025 "Voltar"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Per�odo de Validade:", "Per�odo de Validade :" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", " - Estado:", " - Status :" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Busca avan�ada:", "Busca Avan�ada :" )
		#define STR0029 "N�mero da Cota��o"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "ESTADO", "STATUS" )
		#define STR0031 "ABERTO"
		#define STR0032 "Incluir_Proposta"
		#define STR0033 "Alterar_Cota��o"
		#define STR0034 "Calcular_Cota��o"
		#define STR0035 "Gravar_Cota��o"
		#define STR0036 "Valor Total da Cota��o"
		#define STR0037 "Fechar"
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Elementos", "Itens" )
	#endif
#endif
