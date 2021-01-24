#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Imprimir"
	#define STR0007 "Control de Anticipos"
	#define STR0008 "Gen. Financiero"
	#define STR0009 "No se puede borrar este anticipo. El titulo ya se genero y esta en proceso de movimiento. Utilizar la operacion de Reversion."
	#define STR0010 "Este anticipo no puede anularse, pues ya se genero titulo para el mismo y este ya se movio."
	#define STR0011 "Error en la Generacion del Titulo por Cobrar, Prefijo "
	#define STR0012 "¡Financiero generado con exito!"
	#define STR0013 "El titulo ya se genero"
	#define STR0014 "¡Esta cuenta esta bloqueada!"
	#define STR0015 "El registro esta anulado."
	#define STR0016 "Revertir"
	#define STR0017 "¿Realmente desea revertir el titulo?"
	#define STR0018 "¡Este anticipo no posee titulo generado!"
	#define STR0019 "Este titulo ya contiene movimientos de baja y no se puede revertir."
	#define STR0020 "¡Revertido!"
	#define STR0021 "¡Titulo no encontrado!"
	#define STR0022 "Recibo de Anticipo"
	#define STR0023 "Recibo"
	#define STR0024 "Ya existe un titulo provisorio para este anticipo"
	#define STR0025 "¿Desea generar un titulo provisorio para este anticipo?"
	#define STR0026 "Operacion anulada."
	#define STR0027 "La fecha de vencimiento no puede ser menor a la fecha base"
	#define STR0028 "La fecha de inclusion no puede ser mayor a la fecha base"
	#define STR0029 "No fue posible generar el titulo de cuentas a cobrar pues la modalidad informada en el parametro MV_JADTNAT no es valida."
	#define STR0030 "No fue posible generar el titulo provisorio de cuentas a cobrar pues la modalidad informada en el parametro MV_JADTNAT no es valida."
	#define STR0031 "No sera posible efectuar la generacion de titulos de cuentas a cobrar pues el parametro MV_JADTNAT esta completado incorrectamente. Operacion no realizada."
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Print"
		#define STR0007 "Advance Control"
		#define STR0008 "Financial Man."
		#define STR0009 "This advance cannot be deleted. The bill was generated and is on movement process. Use the reversal operation."
		#define STR0010 "This advance cannot be canceled as a bill was already generated for it and it was already moved."
		#define STR0011 "Error generating Bill Receivable, Prefix "
		#define STR0012 "Financial successfully generated!"
		#define STR0013 "Bill was already generated"
		#define STR0014 "This account is blocked!"
		#define STR0015 "The register is canceled."
		#define STR0016 "Reverse"
		#define STR0017 "Reverse the bill?"
		#define STR0018 "This advance has no generated bill!"
		#define STR0019 "This bill already has write-off  transactions and cannot be reversed."
		#define STR0020 "Reversed!"
		#define STR0021 "Bill not found!"
		#define STR0022 "Receipt of Advance"
		#define STR0023 "Receipt"
		#define STR0024 "A temporary bill already exists for this advance"
		#define STR0025 "Generate a temporary bill for this advance?"
		#define STR0026 "Cancelled operation."
		#define STR0027 "Due date cannot be earlier than reference date"
		#define STR0028 "Inclusion date cannot be later than reference date"
		#define STR0029 "It was not possible to generate the accounts receivable bill because the nature entered in parameter MV_JADTNAT is not valid."
		#define STR0030 "It was not possible to generate the accounts receivable provisional bill because the nature entered in parameter MV_JADTNAT is not valid."
		#define STR0031 "Impossible to generate accounts receivable bills because the parameter MV_JADTNAT is filled incorrectly. Operation not done."
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 "Imprimir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Controlo de adiantamentos", "Controle de Adiantamentos" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Ges. Financeiro", "Ger. Financeiro" )
		#define STR0009 "Não é possível excluir este adiantamento. O título já foi gerado e esta em processo de movimentação. Utilizar a operação de Estorno."
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Este adiantamento não pode ser cancelado pois foi-lhe gerado título e já foi movimentado.", "Este adiantamento não pode ser cancelado, pois já foi gerado título para o mesmo e este já foi movimentado." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Erro na geração do título a receber, prefixo ", "Erro na Geração do Título a Receber, Prefixo " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Financeiro gerado com sucesso.", "Financeiro gerado com sucesso!" )
		#define STR0013 "O título já foi gerado"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Esta conta está bloqueada.", "Esta conta esta bloqueada!" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "O registo está cancelado.", "O registro está cancelado." )
		#define STR0016 "Estornar"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Realmente deseja estornar o título?", "Realmente deseja estornar o titulo?" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Este adiantamento não possui título gerado.", "Este adiantamento não possui título gerado!" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Este título já contém movimentações de liquidação e não pode ser estornado.", "Este título já contém movimentações de baixa e não pode ser estornado." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Estornado.", "Estornado!" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Título não encontrado.", "Titulo não encontrado!" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Recibo de adiantamento", "Recibo de Adiantamento" )
		#define STR0023 "Recibo"
		#define STR0024 "Já existe um título provisório para esse adiantamento"
		#define STR0025 "Deseja gerar um título provisório para esse adiantamento?"
		#define STR0026 "Operação cancelada."
		#define STR0027 "Data de vencimento não pode ser menor que a data base"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "A data de inclusão não pode ser maior que a data base", "Data de inclusão não pode ser maior que a data base" )
		#define STR0029 "Não foi possível gerar o título de contas a receber pois a natureza informada no parametro MV_JADTNAT não é válida."
		#define STR0030 "Não foi possível gerar o título provisório de contas a receber pois a natureza informada no parametro MV_JADTNAT não é válida."
		#define STR0031 "Não será possível efetuar a geração de títulos de contas a receber pois o parâmetro MV_JADTNAT está preenchido incorretamente. Operação não realizada."
	#endif
#endif
