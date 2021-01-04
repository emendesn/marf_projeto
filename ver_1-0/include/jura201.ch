#ifdef SPANISH
	#define STR0001 "Impresora"
	#define STR0002 "Pantalla"
	#define STR0003 "1 = Conferência"
	#define STR0004 "2 = Análise"
	#define STR0005 "3 = Emitir Fatura"
	#define STR0006 "4 = Emitir Minuta"
	#define STR0007 "Solo verificacion"
	#define STR0008 "Generacion de Factura previa"
	#define STR0009 "Emision de Factura previa"
	#define STR0010 "(Time-Sheet)"
	#define STR0011 "Activar"
	#define STR0012 "Fecha inicial"
	#define STR0013 "¡La fecha inicial no puede ser mayor que la fecha final!"
	#define STR0014 "Fecha final"
	#define STR0015 "¡La fecha final no puede ser menor que la fecha inicial!"
	#define STR0016 " Gastos "
	#define STR0017 " Asiento Controlado "
	#define STR0018 " Demais Casos"
	#define STR0019 " Facturacion Adicional "
	#define STR0020 " Exito "
	#define STR0021 " Filtro "
	#define STR0022 "Socio"
	#define STR0023 "Moneda"
	#define STR0024 "Cliente"
	#define STR0025 "Caso"
	#define STR0026 "Grupo de clientes"
	#define STR0027 "Contrato"
	#define STR0028 "Excepto Clientes"
	#define STR0029 "Oficina"
	#define STR0030 "Tipo de Gastos"
	#define STR0031 "Emitir todo pendiente"
	#define STR0032 " Gastos /  Verificacion "
	#define STR0033 "Hora"
	#define STR0034 " "
	#define STR0035 "No Cobrar"
	#define STR0036 "Tipo de Honorarios"
	#define STR0037 "Resultado"
	#define STR0038 "Situacion de Prefactura"
	#define STR0039 "Tipo de Informe"
	#define STR0040 "No imprimir observacion de los casos en el informe"
	#define STR0041 "Borrar/Sustituir prefacturas existentes en este(os) caso(s) "
	#define STR0042 "¿Salir?"
	#define STR0043 "Espere"
	#define STR0044 "Emitiendo prefacturas ..."
	#define STR0045 "Emision terminada."
	#define STR0046 "Emision terminada con problemas."
	#define STR0047 "Para emision de un cliente especifico no se permite informar excepciones"
	#define STR0048 "Debe haber al menos un filtro seleccionado."
	#define STR0049 "Debe haber al menos un tipo de cobranza seleccionado."
	#define STR0050 "¿Confirma la emision de las prefacturas ?"
	#define STR0051 "Error en la ejecucion procedure JUR201."
	#define STR0052 "Informe de Facturacion"
	#define STR0053 "Esta rutina solo puede ejecutarse una vez por usuario."
	#define STR0054 "Rellenar correctamente las informaciones"
	#define STR0055 "Archivo no localizado en: "
	#define STR0056 "PDF"
	#define STR0057 "Excel"
	#define STR0058 "Word"
	#define STR0059 "Ninguno"
	#define STR0060 "Para emitir prefactura de factura adicional es necesario desmarcar los otros tipos"
	#define STR0061 "El valor de la cuota del contrato "
	#define STR0062 " no esta actualizado. ¿Desea hacer la correccion?"
	#define STR0063 "Como la secuencia de los codigos de los casos es por cliente, es necesario informar el cliente."
	#define STR0064 "¡Informe solamente casos validos!"
	#define STR0065 "No se encontraron datos para emision de Prefactura."
	#define STR0066 "¿Confirma la Emision del Informe de verificacion ?"
	#define STR0067 "Honorarios"
	#define STR0068 "Todos"
	#define STR0069 "Los periodos de "
	#define STR0070 "(Hora y Fijo) deben ser iguales, verifique."
	#define STR0071 "(Cuotas)"
	#define STR0072 "Existen participantes sin valor en la tabla de honorarios, ¿desea continuar emitiendo la(s) prefactura(s)?"
	#define STR0073 "La emision se efectuara en segundo plano, siendo posible acompanarla por la pantalla del Event Viewer."
	#define STR0074 "¡Contrato seleccionado ya se esta emitiendo! Verifique."
	#define STR0075 "La emision en segundo plano esta: "
	#define STR0076 "El log de emision esta: "
	#define STR0077 "prendido"
	#define STR0078 "apagado"
	#define STR0079 "prendido"
	#define STR0080 "apagado"
	#define STR0081 "El informe no se imprimio pues la prefactura se sustituyo, ¡Verifique!"
	#define STR0082 "Impresion de Prefactura"
	#define STR0083 "El contrato "
	#define STR0084 "Ya se esta emitiendo para Time-Sheet, ¡Verifique!"
	#define STR0085 "ya se estan emitiendo cuotas de fijo, ¡Verifique!"
	#define STR0086 "Ya se esta emitiendo para Gastos, ¡Verifique!"
	#define STR0087 "ya se estan emitiendo Gastos de contratos fijos, ¡Verifique!"
	#define STR0088 "Ya se esta emitiendo para Controlado, ¡Verifique!"
	#define STR0089 "ya se estan emitiendo Controlados de contratos fijos, ¡Verifique!"
	#define STR0090 "Ya se esta emitiendo para Factura adicional, ¡Verifique!"
	#define STR0091 "Debe haber al menos un campo rellenado, ¡Verifique!"
	#define STR0092 "¿Confirma la emision de las prefacturas de TODO PENDIENTE?"
	#define STR0093 "Existen Casos en esta prefactura que fueron remanejados, pero aun no fueron revisados.  ¿Desea continuar de cualquier modo?"
	#define STR0094 "Algun contrato del filtro seleccionado ya se esta procesando por otra rutina, intente nuevamente en algunos instantes."
	#define STR0095 "¡Informe solamente contratos validos!"
	#define STR0096 "Codigo de cliente invalido. ¡Verifique!"
#else
	#ifdef ENGLISH
		#define STR0001 "Printer"
		#define STR0002 "Screen"
		#define STR0003 "Checking"
		#define STR0004 "Analysis"
		#define STR0005 "Issue Invoice"
		#define STR0006 "Issue Draft"
		#define STR0007 "Check Only"
		#define STR0008 "Pre-invoice Generation"
		#define STR0009 "Issue Pre-Invoice"
		#define STR0010 "(Time-Sheet)"
		#define STR0011 "Activate"
		#define STR0012 "Start Date"
		#define STR0013 "Start Date cannot be later than end date."
		#define STR0014 "End Date"
		#define STR0015 "End date cannot be earlier than initial date."
		#define STR0016 " Expenses "
		#define STR0017 " Fixed Entry "
		#define STR0018 "Other Cases"
		#define STR0019 " Additional Invoicing "
		#define STR0020 " Success "
		#define STR0021 " Filter "
		#define STR0022 "Partner"
		#define STR0023 "Currency"
		#define STR0024 "Customer"
		#define STR0025 "Case"
		#define STR0026 "Customer Group"
		#define STR0027 "Contract"
		#define STR0028 "Except Customers"
		#define STR0029 "Firm"
		#define STR0030 "Expense Type"
		#define STR0031 "Issue pending"
		#define STR0032 " Expenses / Check  "
		#define STR0033 "Time"
		#define STR0034 ""
		#define STR0035 "Do not collect"
		#define STR0036 "Fee Types"
		#define STR0037 "Result"
		#define STR0038 "Pre Invoice Status"
		#define STR0039 "Report Type"
		#define STR0040 "Do not print note of report cases"
		#define STR0041 "Delete/Replace pre-invoices existing in this/these case(s) "
		#define STR0042 "Quit?"
		#define STR0043 "Wait"
		#define STR0044 "Issuing pre-invoices..."
		#define STR0045 "Issue finished."
		#define STR0046 "Issue finished with problems."
		#define STR0047 "To issue a specific customer, exceptions cannot  be entered"
		#define STR0048 "At least one filter must be selected."
		#define STR0049 "At least one collection type must be selected."
		#define STR0050 "Confirm pre-invoice issue?"
		#define STR0051 "Error executing procedure JUR201."
		#define STR0052 "Invoicing Report"
		#define STR0053 "This routine can be executed only once per user."
		#define STR0054 "Enter data properly"
		#define STR0055 "File not found in: "
		#define STR0056 "PDF"
		#define STR0057 "Excel"
		#define STR0058 "Word"
		#define STR0059 "None"
		#define STR0060 "To issue additional pre-invoice, clear the other types"
		#define STR0061 "The installment value of the contract "
		#define STR0062 " is not updated. Correct it?"
		#define STR0063 "As the case code sequence is per customer, you must indicate the customer."
		#define STR0064 "Enter valid cases only!"
		#define STR0065 "No data was found to issue the pre-invoice."
		#define STR0066 "Confirm the issuance of Checking Report?"
		#define STR0067 "Fees"
		#define STR0068 "All"
		#define STR0069 "The fields from "
		#define STR0070 "(Time and Fixed) must be the same, check it."
		#define STR0071 "(Installments)"
		#define STR0072 "There are participants without value in fee table, continue to issue the pre-invoice(s)?"
		#define STR0073 "The issuance will be performed in background. It can be view on Event Viewer Screen."
		#define STR0074 "Selected contract is already being issued! Check it."
		#define STR0075 "The background issuances: "
		#define STR0076 "The issuance log is: "
		#define STR0077 "on"
		#define STR0078 "off"
		#define STR0079 "on"
		#define STR0080 "off"
		#define STR0081 "Report could not be printed because the pre-invoice was replaced, check it!"
		#define STR0082 "Pre-invoice Printing"
		#define STR0083 "The contract "
		#define STR0084 "is already being issued for Time-Sheet, check it!"
		#define STR0085 "is already being issued for fixed installments, check it!"
		#define STR0086 "is already being issued for Expenses, check it!"
		#define STR0087 "is already being issued for Expenses of fixed contracts, check it!"
		#define STR0088 "is already being issued for Fixed, check it!"
		#define STR0089 "is already being issued for Fixed of fixed contracts, check it!"
		#define STR0090 "is already being issued for Additional Invoice, check it!"
		#define STR0091 "At least one field must be filled, check it!"
		#define STR0092 "Confirm issuance of pre-invoices of ALL PENDING?"
		#define STR0093 "There are Cases in this pre-invoice that were Relocated but not reviewed yet. Continue anyway?"
		#define STR0094 "Some contract of the selected filter is already being processed by another routine, try again in a few minutes."
		#define STR0095 "Enter valid contracts only!"
		#define STR0096 "Customer code not valid. Check it!"
	#else
		#define STR0001 "Impressora"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Ecrã", "Tela" )
		#define STR0003 "Conferência"
		#define STR0004 "Análise"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Emitir factura", "Emitir Fatura" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Emitir minuta", "Emitir Minuta" )
		#define STR0007 "Somente conferência"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Geração da pré-factura", "Geração da Pré-Fatura" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Emissão de pré-factura", "Emissão de Pré Fatura" )
		#define STR0010 "( Time-Sheet )"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Activar", "Ativar" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Data inicial", "Data Inicial" )
		#define STR0013 "Data inicial não pode ser maior que data inicial."
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Data final", "Data Final" )
		#define STR0015 "Data final não pode ser menor que data inicial."
		#define STR0016 " Despesas "
		#define STR0017 If( cPaisLoc $ "ANG|PTG", " Lanc. tabelado ", " Lanc. Tabelado " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Demais casos", "Demais Casos" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", " Facturação adicional ", " Faturamento Adicional " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", " Êxito ", " Exito " )
		#define STR0021 " Filtro "
		#define STR0022 "Sócio"
		#define STR0023 "Moeda"
		#define STR0024 "Cliente"
		#define STR0025 "Caso"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Grupo de clientes", "Grupo de Clientes" )
		#define STR0027 "Contrato"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Excepto clientes", "Exceto Clientes" )
		#define STR0029 "Escritório"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Tipo de despesas", "Tipo de Despesas" )
		#define STR0031 "Emitir tudo pendente"
		#define STR0032 " Despesas /  Conferência "
		#define STR0033 "Hora"
		#define STR0034 If( cPaisLoc $ "ANG|PTG", " ", "" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Não cobrar", "Não Cobrar" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Tipo de honorários", "Tipo de Honorários" )
		#define STR0037 "Resultado"
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Situação da pré-factura", "Situação da Pré Fatura" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Tipo de relatório", "Tipo de Relatório" )
		#define STR0040 "Não imprimir observação dos casos no relátorio"
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Apagar/Substituir pré-facturas existentes neste(s) caso(s) ", "Apagar/Substituir pré-faturas existentes neste(s) caso(s) " )
		#define STR0042 "Sair ?"
		#define STR0043 "Aguarde"
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Emitindo pré-facturas ...", "Emitindo pré-faturas ..." )
		#define STR0045 "Emissão terminada."
		#define STR0046 "Emissão terminada com problemas."
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Para emissão de um cliente específico não é permitido informar exceções", "Para emissão de um cliente especifico não é permitido informar exceções" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Deve haver pelo menos um filtro seleccionado.", "Deve haver pelo menos um filtro selecionado." )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Deve haver pelo menos um tipo de cobrança seleccionado.", "Deve haver pelo menos um tipo de cobrança selecionado." )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", "Confirma a emissão das pré-facturas ?", "Confirma a emissão das pré-faturas ?" )
		#define STR0051 "Erro na execução procedure JUR201."
		#define STR0052 If( cPaisLoc $ "ANG|PTG", "Relatório de Fatcturação", "Relatorio de Faturamento" )
		#define STR0053 If( cPaisLoc $ "ANG|PTG", "Este procedimento só pode ser executado uma vez por utilizador.", "Esta rotina so pode ser executada apenas uma vez por usuário." )
		#define STR0054 If( cPaisLoc $ "ANG|PTG", "Preencher correctamente as informações", "Preencher corretamente as informações" )
		#define STR0055 If( cPaisLoc $ "ANG|PTG", "Ficheiro não localizado em: ", "Arquivo não localizado em: " )
		#define STR0056 "PDF"
		#define STR0057 "Excel"
		#define STR0058 "Word"
		#define STR0059 "Nenhum"
		#define STR0060 If( cPaisLoc $ "ANG|PTG", "Para emitir pré-factura de factura adicional, desmarque os outros tipos", "Para emitir pré-fatura de fatura adicional é necessário desmarcar os outros tipos" )
		#define STR0061 "O valor da parcela do contrato "
		#define STR0062 If( cPaisLoc $ "ANG|PTG", " não está actualizado. Deseja fazer a correcção?", " não está atualizado. Deseja fazer a correção?" )
		#define STR0063 "Como a sequência dos códigos dos casos é por cliente, é necessário informar o cliente."
		#define STR0064 "Informe apenas casos válidos!"
		#define STR0065 If( cPaisLoc $ "ANG|PTG", "Não foram encontrados dados para emissão da pré-factura.", "Não foram encontrados dados para emissão da Pré-Fatura." )
		#define STR0066 If( cPaisLoc $ "ANG|PTG", "Confirma a emissão do relatório de conferência ?", "Confirma a Emissão do Relatório de Conferência ?" )
		#define STR0067 "Honorários"
		#define STR0068 "Todos"
		#define STR0069 "Os períodos de "
		#define STR0070 If( cPaisLoc $ "ANG|PTG", "(Hora e Fixo) devem ser iguais. Verifique.", "(Hora e Fixo) devem ser iguais, verifique." )
		#define STR0071 "( Parcelas )"
		#define STR0072 If( cPaisLoc $ "ANG|PTG", "Existem participantes sem valor na tabela de honorários. Deseja continuar a emitir a(s) pré-factura(s)?", "Existem participantes sem valor na tabela de honorários, deseja continuar a emitir a(s) pré-fatura(s)?" )
		#define STR0073 If( cPaisLoc $ "ANG|PTG", "A emissão será efectuada em segundo plano, sendo possível acompanhá-la pelo ecrã do Event Viewer.", "A emissão será efetuada em segundo plano, sendo possível acompanha-la pela tela do Event Viewer." )
		#define STR0074 If( cPaisLoc $ "ANG|PTG", "O contrato seleccionado já está a ser emitido. Verifique.", "Contrato selecionado já esta sendo emitido! Verifique." )
		#define STR0075 If( cPaisLoc $ "ANG|PTG", "A emissão em segundo plano está: ", "A emissão em segundo plano esta: " )
		#define STR0076 If( cPaisLoc $ "ANG|PTG", "O log de emissão está: ", "O log de emissão esta: " )
		#define STR0077 "ligada"
		#define STR0078 "desligada"
		#define STR0079 "ligado"
		#define STR0080 "desligado"
		#define STR0081 If( cPaisLoc $ "ANG|PTG", "O relatório não foi impresso pois a pré-factura foi substituída. Verifique.", "O relatório não foi impresso pois a pré-fatura foi substituida, Verifique!" )
		#define STR0082 If( cPaisLoc $ "ANG|PTG", "Impressão de pré-factura", "Impressão de Pré-Fatura" )
		#define STR0083 "O contrato "
		#define STR0084 If( cPaisLoc $ "ANG|PTG", "já está a ser emitido para Time-sheet. Verifique.", "já esta sendo emitido para Time-Sheet, Verifique!" )
		#define STR0085 If( cPaisLoc $ "ANG|PTG", "já está a ser emitido parcelas de fixo. Verifique.", "já esta sendo emitido parcelas de fixo, Verifique!" )
		#define STR0086 If( cPaisLoc $ "ANG|PTG", "já está a ser emitido para despesas. Verifique.", "já esta sendo emitido para Despesas, Verifique!" )
		#define STR0087 If( cPaisLoc $ "ANG|PTG", "já está a ser emitido despesas de contratos fixos. Verifique.", "já esta sendo emitido Despesas de contratos fixos, Verifique!" )
		#define STR0088 If( cPaisLoc $ "ANG|PTG", "já está a ser emitido para Tabelado. Verifique.", "já esta sendo emitido para Tabelado, Verifique!" )
		#define STR0089 If( cPaisLoc $ "ANG|PTG", "já estão a ser emitidos tabelados de contratos fixos. Verifique.", "já esta sendo emitido Tabelados de contratos fixos, Verifique!" )
		#define STR0090 If( cPaisLoc $ "ANG|PTG", "já está a ser emitido para Factura Adicional. Verifique.", "já esta sendo emitido para Fatura Adicional, Verifique!" )
		#define STR0091 If( cPaisLoc $ "ANG|PTG", "Deve haver pelo menos um campo preenchido. Verifique.", "Deve haver pelo menos um campo preenchido, Verifique!" )
		#define STR0092 If( cPaisLoc $ "ANG|PTG", "Confirma a emissão das pré-facturas de TUDO PENDENTE?", "Confirma a emissão das pré-faturas de TUDO PENDENTE?" )
		#define STR0093 If( cPaisLoc $ "ANG|PTG", "Existem casos nesta pré-factura que foram remanejados, mas ainda não foram revisados. Deseja prosseguir assim mesmo?", "Existem Casos nesta pré-fatura que foram Remanejados, mas ainda não foram revisados. Deseja prosseguir assim mesmo?" )
		#define STR0094 If( cPaisLoc $ "ANG|PTG", "Algum contrato do filtro seleccionado já está a ser processado por outro procedimento. Tente novamente em alguns instantes.", "Algum contrato do filtro selecionado já está sendo processado por outra rotina, tente novamente em alguns instantes." )
		#define STR0095 "Informe apenas contratos válidos!"
		#define STR0096 "Código de Cliente inválido, Verifique!"
	#endif
#endif
