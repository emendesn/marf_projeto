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
	#define STR0020 "¡Valor de la Tasa debe ser mayor que cero!"
	#define STR0021 "Asiento debe estar pendiente para que pueda generar CP"
	#define STR0022 "¿Desea generar el financiero?"
	#define STR0023 "¡Operacion anulada!"
	#define STR0024 "Error en la Ejecucion Automatica"
	#define STR0025 "El log de error esta en [ROOTPATH]\SYSTEM\"
	#define STR0026 "¡Financiero generado con exito!"
	#define STR0027 "No se permite vincular este codigo de Servicio controlado para este Cliente/Tienda/Caso"
	#define STR0028 "No se permite vincular este Cliente para este Grupo"
	#define STR0029 "Cliente/Tienda no registrado"
	#define STR0030 "Cliente no registrado"
	#define STR0031 "¡No fue posible realizar las modificaciones, el asiento posee prefactura!"
	#define STR0032 "Los parametros para creacion del compromiso por pagar no se definieron correctamente"
	#define STR0033 "No Puede borrarse - Situacion concluida"
	#define STR0034 "¡Financiero borrado con exito!"
	#define STR0035 "¡Financiero modificado con exito!"
	#define STR0036 "¡Financiero ya generado para este asiento controlado!"
	#define STR0037 "¡No fue posible efectuar la modificacion en el Financiero!"
	#define STR0038 "¡No fue posible borrar el titulo Financiero!"
	#define STR0039 "Oper. en Lote"
	#define STR0040 "¡No hay datos marcados para ejecucion en lote!"
	#define STR0041 "Es preciso que haya valor de Honorarios y de Tasa para incluir el asiento Controlado"
	#define STR0042 "¡Generar Cuentas por Pagar esta como 'No'!"
	#define STR0043 "¡Financiero no se genero nuevamente!"
	#define STR0044 "¡Necesario informar la moneda de la Tasa!"
	#define STR0045 "Cuentas por Pagar - Asiento controlado"
	#define STR0046 "Titulo dado de baja"
	#define STR0047 "Dado de baja Parcialmente"
	#define STR0048 "Titulo pendiente"
	#define STR0049 "Estatus"
	#define STR0050 "Visualizar"
	#define STR0051 "Leyenda"
	#define STR0052 "Cuentas por pagar"
	#define STR0053 "Visualizar CP"
	#define STR0054 "¡Titulo no encontrado para visualizacion!"
	#define STR0055 "El asiento controlado no puede ser borrado, pues existe facturacion/ WO"
	#define STR0056 "¡No fue posible realizar las modificaciones, el asiento posee Minuta!"
	#define STR0057 "¡No fue posible realizar las modificaciones, el asiento posee prefactura en Definitivo!"
	#define STR0058 "No fue posible vincular el participante a este registro pues el se encuentra despedido."
	#define STR0059 "No hay registro relacionado con este codigo o si se informo no responde a las siguientes restricciones:"
	#define STR0060 " - El caso no permite registros de Controlado;"
	#define STR0061 " - El caso esta finalizado y no se permite su modificacion."
	#define STR0062 "¡El usuario que inicio sesion no esta relacionado con ningun participante! Verifique."
	#define STR0063 "El participante no tiene permiso para modificar el Controlado ocn Prefacturas."
	#define STR0064 "La prefactura #1 se cancelo por no contener mas asientos."
	#define STR0065 "No fue posible sugerir la Fecha de Conclusion, pues el participante del asiento fue despedido."
	#define STR0066 "¡Perfil del cliente no es Cliente/Pagador!"
	#define STR0067 "O preenchimento da 'Data de Conclusão' é obrigatório para lançamentos tabelados concluídos."
	#define STR0068 "Debe rellenarse el participante. ¡Verifique!"
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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Lançamento tabelado", "Lançamento Tabelado" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0007 "Gerar CP"
		#define STR0008 "Imprimir"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Modelo de dados - Lançamento tabelado", "Modelo de Dados - Lançamento Tabelado" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Lançamento tabelado facturação", "Lançamento Tabelado Faturamento" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Facturação", "Faturamento" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "O cliente deve ser informado antes do caso", "O Cliente deve ser informado antes do caso" )
		#define STR0013 "Caso não localizado"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "O caso não permite lançamento tabelado", "Caso não permite Lançamento Tabelado" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Caso encerrado, não permite lançamento tabelado", "Caso encerrado, não permite Lançamento Tabelado" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Tabela de histórico valores de serviço não localizada", "Tabela de historico valores de serviço não localizada" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Histórico das tabelas de não localizado", "Historico das tabelas de não localizado" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Histórico do caso não localizado", "Historico do caso não localizado" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Data de lançamento deve ser preenchida anteriormente", "Data de lancamento deve ser preenchida anteriormente" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Valor da taxa deve ser maior que zero.", "Valor da Taxa deve ser maior que zero!" )
		#define STR0021 "Lançamento deve estar pendente para que possa gerar CP"
		#define STR0022 "Deseja gerar o financeiro?"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Operaçao cancelada.", "Operaçao cancelada!" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Erro na execução automática", "Erro na Execução Automática" )
		#define STR0025 "O log de erro está em [ROOTPATH]\SYSTEM\"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Financeiro gerado com sucesso.", "Financeiro gerado com sucesso!" )
		#define STR0027 "Não é permitido vincular este código de Serviço Tabelado para este Cliente/Loja/Caso"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Não é permitido vincular este cliente para este grupo", "Não é permitido vincular este Cliente para este Grupo" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Cliente/Loja não registado", "Cliente/Loja não cadastrado" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Cliente não registado", "Cliente não cadastrado" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Não foi possível realizar as alterações, o lançamento possui pré-factura.", "Não foi possível realizar as alterações, o lançamento possui pré-fatura!" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Os parâmetros para criação do compromisso a pagar não foram definidos correctamente", "Os parâmetros para criação do compromisso a pagar não foram definidos corretamente" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Não pode ser excluída - Situação concluída", "Nao Pode Ser Excluida - Situacao concluida" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Financeiro excluído com sucesso.", "Financeiro excluido com sucesso!" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Financeiro alterado com sucesso.", "Financeiro alterado com sucesso!" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Financeiro já gerado para este lançamento tabelado.", "Financeiro já gerado para este Lançamento Tabelado!" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Não foi possível efectuar a alteração no Financeiro.", "Não foi possível efetuar a alteração no Financeiro!" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Não foi possível excluir o título Financeiro.", "Não foi possível excluir o título Financeiro!" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Oper. em lote", "Oper. em Lote" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Não há dados marcados para execução em lote.", "Não há dados marcados para execução em lote!" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "É preciso haver valor de honorários e de taxa para incluir o lançamento tabelado", "É preciso haver valor de Honorários e de Taxa para incluir o lançamento Tabelado" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "O gerar contas a pagar está como 'Não'.", "O Gerar Contas a Pagar está como 'Não'!" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "O Financeiro não foi gerado novamente.", "O Financeiro não foi gerado novamente!" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "É preciso informar a moeda da taxa.", "É preciso informar a moeda da Taxa!" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Contas a pagar - Lanç. tabelado", "Contas a Pagar - Lanc. Tabelado" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Título liquidado", "Titulo Baixado" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Liquidado parcialmente", "Baixado Parcialmente" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Título em aberto", "Titulo em Aberto" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Estado", "Status" )
		#define STR0050 "Visualizar"
		#define STR0051 "Legenda"
		#define STR0052 If( cPaisLoc $ "ANG|PTG", "Contas a pagar", "Contas a Pagar" )
		#define STR0053 "Visualizar CP"
		#define STR0054 If( cPaisLoc $ "ANG|PTG", "Título não encontrado para visualização.", "Titulo não encontrado para visualização!" )
		#define STR0055 If( cPaisLoc $ "ANG|PTG", "O Lançamento tabelado não pode ser eliminado, pois existe facturação/ WO", "O Lançamento Tabelado não pode ser excluído, pois existe faturamento/ WO" )
		#define STR0056 If( cPaisLoc $ "ANG|PTG", "Não foi possível realizar as alterações pois o lançamento possui minuta.", "Não foi possível realizar as alterações, o lançamento possui minuta!" )
		#define STR0057 If( cPaisLoc $ "ANG|PTG", "Não foi possível realizar as alterações pois o lançamento possui pré-factura em definifivo.", "Não foi possível realizar as alterações, o lançamento possui pré-fatura em Definifivo!" )
		#define STR0058 "Não foi possível vincular o participante a este lançamento pois ele encontra-se demitido."
		#define STR0059 "Não há registo relacionado a este código ou o caso informado não atende às seguintes restrições:"
		#define STR0060 " - O caso não permite lançamentos de Tabelado;"
		#define STR0061 " - O caso está encerrado e não é permitida sua alteração."
		#define STR0062 "O usuário logado não esta relacionado a nenhum participante! Verifique."
		#define STR0063 "O participante não tem permissão para alterar Tabelado com Pré-faturas."
		#define STR0064 "A pré-fatura #1 foi cancelada por não conter mais lançamentos."
		#define STR0065 "Não foi possível sugerir a Data de Conclusão, pois o participante do lançamento encontra-se demitido."
		#define STR0066 "Perfil do cliente não é Cliente/Pagador!"
		#define STR0067 "O preenchimento da 'Data de Conclusão' é obrigatório para lançamentos tabelados concluídos."
		#define STR0068 "O Participante deve ser preenchido. Verifique!"
	#endif
#endif
