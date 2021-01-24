#ifdef SPANISH
	#define STR0001 "Asiento por Tabla"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Generar CP"
	#define STR0008 "Imprimir"
	#define STR0009 "Modelo de Datos - Asiento por Tabla"
	#define STR0010 "Asiento por Tabla Facturacion"
	#define STR0011 "Facturacion"
	#define STR0012 "El Cliente debe ser informado antes del caso"
	#define STR0013 "Caso no localizado"
	#define STR0014 "Caso no permite Asiento controlado"
	#define STR0015 "Caso encerrado, no permite Asiento controlado"
	#define STR0016 "Tabla de historial valores de servicio no localizada"
	#define STR0017 "Historial de las tablas de no localizado"
	#define STR0018 "Historial del caso no localizado"
	#define STR0019 "Fecha de asiento debe rellenarse anteriormente"
	#define STR0020 "�Valor de la Tasa debe ser mayor que cero!"
	#define STR0021 "Asiento debe estar pendiente para que pueda generar CP"
	#define STR0022 "�Desea generar el financiero?"
	#define STR0023 "�Operacion anulada!"
	#define STR0024 "Error en la Ejecucion Automatica"
	#define STR0025 "El log de error esta en [ROOTPATH]\SYSTEM\"
	#define STR0026 "�Financiero generado con exito!"
	#define STR0027 "No se permite vincular este codigo de Servicio controlado para este Cliente/Tienda/Caso"
	#define STR0028 "No se permite vincular este Cliente para este Grupo"
	#define STR0029 "Cliente/Tienda no registrado"
	#define STR0030 "Cliente no registrado"
	#define STR0031 "�No fue posible realizar las modificaciones, el asiento posee prefactura!"
	#define STR0032 "Los parametros para creacion del compromiso por pagar no se definieron correctamente"
	#define STR0033 "No Puede borrarse - Situacion concluida"
	#define STR0034 "�Financiero borrado con exito!"
	#define STR0035 "�Financiero modificado con exito!"
	#define STR0036 "�Financiero ya generado para este asiento controlado!"
	#define STR0037 "�No fue posible efectuar la modificacion en el Financiero!"
	#define STR0038 "�No fue posible borrar el titulo Financiero!"
	#define STR0039 "Oper. en Lote"
	#define STR0040 "�No hay datos marcados para ejecucion en lote!"
	#define STR0041 "Es preciso que haya valor de Honorarios y de Tasa para incluir el asiento Controlado"
	#define STR0042 "�Generar Cuentas por Pagar esta como 'No'!"
	#define STR0043 "�Financiero no se genero nuevamente!"
	#define STR0044 "�Necesario informar la moneda de la Tasa!"
	#define STR0045 "Cuentas por Pagar - Asiento controlado"
	#define STR0046 "Titulo dado de baja"
	#define STR0047 "Dado de baja Parcialmente"
	#define STR0048 "Titulo pendiente"
	#define STR0049 "Estatus"
	#define STR0050 "Visualizar"
	#define STR0051 "Leyenda"
	#define STR0052 "Cuentas por pagar"
	#define STR0053 "Visualizar CP"
	#define STR0054 "�Titulo no encontrado para visualizacion!"
	#define STR0055 "El asiento controlado no puede ser borrado, pues existe facturacion/ WO"
	#define STR0056 "�No fue posible realizar las modificaciones, el asiento posee Minuta!"
	#define STR0057 "�No fue posible realizar las modificaciones, el asiento posee prefactura en Definitivo!"
	#define STR0058 "No fue posible vincular el participante a este registro pues el se encuentra despedido."
	#define STR0059 "No hay registro relacionado con este codigo o si se informo no responde a las siguientes restricciones:"
	#define STR0060 " - El caso no permite registros de Controlado;"
	#define STR0061 " - El caso esta finalizado y no se permite su modificacion."
	#define STR0062 "�El usuario que inicio sesion no esta relacionado con ningun participante! Verifique."
	#define STR0063 "El participante no tiene permiso para modificar el Controlado ocn Prefacturas."
	#define STR0064 "La prefactura #1 se cancelo por no contener mas asientos."
	#define STR0065 "No fue posible sugerir la Fecha de Conclusion, pues el participante del asiento fue despedido."
	#define STR0066 "�Perfil del cliente no es Cliente/Pagador!"
	#define STR0067 "O preenchimento da 'Data de Conclus�o' � obrigat�rio para lan�amentos tabelados conclu�dos."
	#define STR0068 "Debe rellenarse el participante. �Verifique!"
#else
	#ifdef ENGLISH
		#define STR0001 "Fixed Entry"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Add"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "Generate CP"
		#define STR0008 "Print"
		#define STR0009 "Data Model - Fixed Entry"
		#define STR0010 "Fixed Entry Invoicing"
		#define STR0011 "Invoicing"
		#define STR0012 "Customer must be informed before the case"
		#define STR0013 "Case not found"
		#define STR0014 "Case does not allow Fixed Entry"
		#define STR0015 "Case closed, Fixed Entry is not allowed"
		#define STR0016 "Table of service value history not found"
		#define STR0017 "Table history not found"
		#define STR0018 "Case history not found"
		#define STR0019 "Entry date must be previously filled"
		#define STR0020 "Rate value must be higher than zero!"
		#define STR0021 "Entry must be pending to generate CP"
		#define STR0022 "Generate financial?"
		#define STR0023 "Operation canceled!"
		#define STR0024 "Error in Automatic Execution"
		#define STR0025 "The error log is in [ROOTPATH]\SYSTEM\"
		#define STR0026 "Financial successfully generated!"
		#define STR0027 "This code of Fixed Service cannot be associated with this Customer/Store/Case"
		#define STR0028 "Customer cannot be associated with this Group"
		#define STR0029 "Customer/Store not registered"
		#define STR0030 "Customer not registered"
		#define STR0031 "Changes could not be made, the entry has a pre-invoice!"
		#define STR0032 "The parameters to create the liability payable were not properly defined"
		#define STR0033 "Cannot be deleted - Concluded situation"
		#define STR0034 "Financial successfully deleted!"
		#define STR0035 "Financial successfully changed!"
		#define STR0036 "Financial already generated for this Fixed Entry!"
		#define STR0037 "Could not perform change in Financial!"
		#define STR0038 "Financial bill could not be deleted!"
		#define STR0039 "Batch Oper."
		#define STR0040 "There is not data for batch execution!"
		#define STR0041 "A value of Fees and Rate is necessary to include the Fixed entry"
		#define STR0042 "Generate Accounts Payable is set to No!"
		#define STR0043 "Financial was not generated again!"
		#define STR0044 "Enter the currency of the Rate!"
		#define STR0045 "Accounts Payable - Fixed Entry"
		#define STR0046 "Bill Written Off"
		#define STR0047 "Partially written-off"
		#define STR0048 "Pending Bill"
		#define STR0049 "Status"
		#define STR0050 "View"
		#define STR0051 "Caption"
		#define STR0052 "Accounts Payable"
		#define STR0053 "View CP"
		#define STR0054 "Bill not found for viewing!"
		#define STR0055 "The Fixed Entry cannot be deleted because there is invoicing/WO"
		#define STR0056 "Changes could not be made, the entry has Draft!"
		#define STR0057 "Changes could not be made, the entry has a Definite pro forma invoice!"
		#define STR0058 "Associating the participant to this entry is not possible as he or she was dismissed."
		#define STR0059 "There is no register related to this code or the case informed does not comply with the following restrictions:"
		#define STR0060 " - The case does not allow tabled entries;"
		#define STR0061 " - The case is closed and you cannot change it."
		#define STR0062 "The logged user is not related to a participant! Check it."
		#define STR0063 "The participant has no permission to edit Fixed values with Proforma invoices."
		#define STR0064 "The proforma invoice #1 was canceled because it had no transactions."
		#define STR0065 "It was not possible to suggest a Termination Date because the transaction participant is dismissed."
		#define STR0066 "Customer profile is not Customer/Payer!"
		#define STR0067 "Completing Conclusion Date is mandatory for concluded tabled entries."
		#define STR0068 "The Employee must be completed. Check it!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Lan�amento tabelado", "Lan�amento Tabelado" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0007 "Gerar CP"
		#define STR0008 "Imprimir"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Modelo de dados - Lan�amento tabelado", "Modelo de Dados - Lan�amento Tabelado" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Lan�amento tabelado factura��o", "Lan�amento Tabelado Faturamento" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Factura��o", "Faturamento" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "O cliente deve ser informado antes do caso", "O Cliente deve ser informado antes do caso" )
		#define STR0013 "Caso n�o localizado"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "O caso n�o permite lan�amento tabelado", "Caso n�o permite Lan�amento Tabelado" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Caso encerrado, n�o permite lan�amento tabelado", "Caso encerrado, n�o permite Lan�amento Tabelado" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Tabela de hist�rico valores de servi�o n�o localizada", "Tabela de historico valores de servi�o n�o localizada" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Hist�rico das tabelas de n�o localizado", "Historico das tabelas de n�o localizado" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Hist�rico do caso n�o localizado", "Historico do caso n�o localizado" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Data de lan�amento deve ser preenchida anteriormente", "Data de lancamento deve ser preenchida anteriormente" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Valor da taxa deve ser maior que zero.", "Valor da Taxa deve ser maior que zero!" )
		#define STR0021 "Lan�amento deve estar pendente para que possa gerar CP"
		#define STR0022 "Deseja gerar o financeiro?"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Opera�ao cancelada.", "Opera�ao cancelada!" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Erro na execu��o autom�tica", "Erro na Execu��o Autom�tica" )
		#define STR0025 "O log de erro est� em [ROOTPATH]\SYSTEM\"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Financeiro gerado com sucesso.", "Financeiro gerado com sucesso!" )
		#define STR0027 "N�o � permitido vincular este c�digo de Servi�o Tabelado para este Cliente/Loja/Caso"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "N�o � permitido vincular este cliente para este grupo", "N�o � permitido vincular este Cliente para este Grupo" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Cliente/Loja n�o registado", "Cliente/Loja n�o cadastrado" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Cliente n�o registado", "Cliente n�o cadastrado" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel realizar as altera��es, o lan�amento possui pr�-factura.", "N�o foi poss�vel realizar as altera��es, o lan�amento possui pr�-fatura!" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Os par�metros para cria��o do compromisso a pagar n�o foram definidos correctamente", "Os par�metros para cria��o do compromisso a pagar n�o foram definidos corretamente" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "N�o pode ser exclu�da - Situa��o conclu�da", "Nao Pode Ser Excluida - Situacao concluida" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Financeiro exclu�do com sucesso.", "Financeiro excluido com sucesso!" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Financeiro alterado com sucesso.", "Financeiro alterado com sucesso!" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Financeiro j� gerado para este lan�amento tabelado.", "Financeiro j� gerado para este Lan�amento Tabelado!" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel efectuar a altera��o no Financeiro.", "N�o foi poss�vel efetuar a altera��o no Financeiro!" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel excluir o t�tulo Financeiro.", "N�o foi poss�vel excluir o t�tulo Financeiro!" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Oper. em lote", "Oper. em Lote" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "N�o h� dados marcados para execu��o em lote.", "N�o h� dados marcados para execu��o em lote!" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "� preciso haver valor de honor�rios e de taxa para incluir o lan�amento tabelado", "� preciso haver valor de Honor�rios e de Taxa para incluir o lan�amento Tabelado" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "O gerar contas a pagar est� como 'N�o'.", "O Gerar Contas a Pagar est� como 'N�o'!" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "O Financeiro n�o foi gerado novamente.", "O Financeiro n�o foi gerado novamente!" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "� preciso informar a moeda da taxa.", "� preciso informar a moeda da Taxa!" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Contas a pagar - Lan�. tabelado", "Contas a Pagar - Lanc. Tabelado" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "T�tulo liquidado", "Titulo Baixado" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Liquidado parcialmente", "Baixado Parcialmente" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "T�tulo em aberto", "Titulo em Aberto" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Estado", "Status" )
		#define STR0050 "Visualizar"
		#define STR0051 "Legenda"
		#define STR0052 If( cPaisLoc $ "ANG|PTG", "Contas a pagar", "Contas a Pagar" )
		#define STR0053 "Visualizar CP"
		#define STR0054 If( cPaisLoc $ "ANG|PTG", "T�tulo n�o encontrado para visualiza��o.", "Titulo n�o encontrado para visualiza��o!" )
		#define STR0055 If( cPaisLoc $ "ANG|PTG", "O Lan�amento tabelado n�o pode ser eliminado, pois existe factura��o/ WO", "O Lan�amento Tabelado n�o pode ser exclu�do, pois existe faturamento/ WO" )
		#define STR0056 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel realizar as altera��es pois o lan�amento possui minuta.", "N�o foi poss�vel realizar as altera��es, o lan�amento possui minuta!" )
		#define STR0057 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel realizar as altera��es pois o lan�amento possui pr�-factura em definifivo.", "N�o foi poss�vel realizar as altera��es, o lan�amento possui pr�-fatura em Definifivo!" )
		#define STR0058 "N�o foi poss�vel vincular o participante a este lan�amento pois ele encontra-se demitido."
		#define STR0059 "N�o h� registo relacionado a este c�digo ou o caso informado n�o atende �s seguintes restri��es:"
		#define STR0060 " - O caso n�o permite lan�amentos de Tabelado;"
		#define STR0061 " - O caso est� encerrado e n�o � permitida sua altera��o."
		#define STR0062 "O usu�rio logado n�o esta relacionado a nenhum participante! Verifique."
		#define STR0063 "O participante n�o tem permiss�o para alterar Tabelado com Pr�-faturas."
		#define STR0064 "A pr�-fatura #1 foi cancelada por n�o conter mais lan�amentos."
		#define STR0065 "N�o foi poss�vel sugerir a Data de Conclus�o, pois o participante do lan�amento encontra-se demitido."
		#define STR0066 "Perfil do cliente n�o � Cliente/Pagador!"
		#define STR0067 "O preenchimento da 'Data de Conclus�o' � obrigat�rio para lan�amentos tabelados conclu�dos."
		#define STR0068 "O Participante deve ser preenchido. Verifique!"
	#endif
#endif
