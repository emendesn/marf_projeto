#ifdef SPANISH
	#define STR0001 "Imposible abrir archivo de Log"
	#define STR0002 "El compr. fiscal no fue anulado, pues no fue el ultimo que sera impreso"
	#define STR0003 "Caja      : "
	#define STR0004 "AP5 Punto de Ventas - Archivo de log"
	#define STR0005 "Venta Mostrador"
	#define STR0006 "Venta Rapida"
	#define STR0007 "Fecha     : "
	#define STR0008 "Hora      : "
	#define STR0009 "Impresora : "
	#define STR0010 "Cupon/Fact: "
	#define STR0011 " ** Presup.   ** "
	#define STR0012 "Presupuest: "
	#define STR0013 "Mensaje : Tuvo modificac.en aCols"
	#define STR0014 "Valor     : "
	#define STR0015 "Mensaje : Diferencia en el valor total"
	#define STR0016 "Mensaje : Diferencia en el numero de itemes"
	#define STR0017 "Mensaje : Diferencia en el valor item"
	#define STR0018 "Atencion"
	#define STR0019 "Ocurrio un error con el presupuesto/pedido "
	#define STR0020 ". �Desea proseguir la anulacion?"
	#define STR0021 "�Desea Recuperar itemes anulados en esta venta?"
	#define STR0022 "(Valor neto)"
	#define STR0023 "(Valor bruto)"
	#define STR0024 "Imposible crear archivo de Asociacion"
	#define STR0025 "Anulando Cupon Fiscal..."
	#define STR0026 "Recuperando Cupon Fiscal... No se puede anular por estar vinculado a una transaccion TEF"
	#define STR0027 "Transaccion confirmada, si el Cupon TEF se imprimio con problemas utilice la reimpresion en RUTINAS TEF"
	#define STR0028 "Venta Asistida"
	#define STR0029 "Presupuesto borrado."
	#define STR0030 "No fue posible borrar este presupuesto."
	#define STR0031 "Anulacion no efectuada, pues el cajero es diferente del Operador."
	#define STR0032 "Recuperando Items..."
	#define STR0033 "Efectuando la anulalcion del TEF "
	#define STR0034 "Transaccion no realizada, por favor retenga el comprobante"
	#define STR0035 "�Realmente desea anular la recuperacion de la ultima venta ?"
	#define STR0036 "Anulando reservas generadas para este presupuesto..."
	#define STR0037 "Transaccion TEF no efectuada, favor retener el comprobante."
	#define STR0038 "Rutina de cambio"
	#define STR0039 "Registro(s) del alias "
	#define STR0040 " borrado(s)"
	#define STR0041 "no borrado(s)"
	#define STR0042 " (secundario)"
#else
	#ifdef ENGLISH
		#define STR0001 "Unable to open the log file"
		#define STR0002 "The fiscal voucher was not cancelled as it was not the last one to be printed."
		#define STR0003 "Cash     : "
		#define STR0004 "SigaLoja - Monitoring File"
		#define STR0005 "Counter Sale"
		#define STR0006 "Quick Sale"
		#define STR0007 "Date     : "
		#define STR0008 "Time      : "
		#define STR0009 "Printer"
		#define STR0010 "Voucher/Inv.: "
		#define STR0011 " ** Quotation ** "
		#define STR0012 "Quotation: "
		#define STR0013 "Message: There was change in aCols"
		#define STR0014 "Value     : "
		#define STR0015 "Message: Difference in total value"
		#define STR0016 "Message: Difference in items number"
		#define STR0017 "Message: Difference in item value"
		#define STR0018 "Attention"
		#define STR0019 "An error on the quotation/order occurred"
		#define STR0020 ". Are you sure you want to cancel ?"
		#define STR0021 "Do you want to restore aborted items in this Sale ?"
		#define STR0022 "(Net Value)"
		#define STR0023 "(Gross Value)"
		#define STR0024 "Unable to create Monitoring file"
		#define STR0025 "Cancelled Fiscal Voucher..."
		#define STR0026 "Recovering Fiscal Voucher... Unable to cancel it since it is linked to an EFT transaction."
		#define STR0027 "Transaction confirmed, if the EFT Voucher was printed with problems, use the reprinting in the EFT ROUTINES"
		#define STR0028 "Assisted Sales"
		#define STR0029 "Quotation deleted."
		#define STR0030 "Unable to delete this quotation. "
		#define STR0031 "Cancellation not performed because cashier is different from Operator."
		#define STR0032 "Recovering items ..."
		#define STR0033 "Executing TIO cancellation "
		#define STR0034 "Operation not executed. Please, retain voucher"
		#define STR0035 "Do you really want to cancel the recovery of last sales?"
		#define STR0036 "Canceling reservations generated for this quotation..."
		#define STR0037 "EFT transaction not performed. Please retain voucher."
		#define STR0038 "Exchange routine"
		#define STR0039 "Alias record(s) "
		#define STR0040 " deleted "
		#define STR0041 "not deleted"
		#define STR0042 " (son)  "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "N�o Foi Poss�vel Abrir Ficheiro De Monitoragem", "Nao foi possivel abrir arquivo de Monitoramento" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "A factura n�o foi cancelada, pois n�o foi a �ltima a ser impressa", "O cupom fiscal nao foi cancelado, pois nao foi o ultimo a ser impresso" )
		#define STR0003 "Caixa     : "
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Sigaloja - Ficheiro De Monitoriza��o", "SigaLoja - Arquivo de Monitoramento" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Venda Do Balc�o", "Venda Balcao" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Venda R�pida", "Venda Rapida" )
		#define STR0007 "Data      : "
		#define STR0008 "Hora      : "
		#define STR0009 "Impressora: "
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Cart�o/factura : ", "Cupom/NF. : " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", " ** or�amento ** ", " ** Orcamento ** " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Or�amento : ", "Orcamento : " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Mensagem: houve altera��o no acols", "Mensagem: Houve alteracao no aCols" )
		#define STR0014 "Valor     : "
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Mensagem: diferen�a no valor total", "Mensagem: Diferenca no valor total" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Mensagem: diferen�a no n�mero de itens", "Mensagem: Diferenca no numero de itens" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Mensagem: diferen�a no valor do item", "Mensagem: Diferenca no valor item" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Atencao" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Ocorreu uma inconsist�ncia com o or�amento/pedido ", "Ocorreu uma inconsistencia com o orcamento/pedido " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", ". deseja prosseguir e cancelar ?", ". Deseja prosseguir com o cancelamento ?" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Deseja recuperar itens abortados, nesta venda ?", "Deseja Recuperar itens abortados, nesta Venda ?" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "(valor l�quido)", "(Valor liquido)" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "(valor bruto)", "(Valor bruto)" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "N�o Foi Poss�vel Criar Ficheiro De Monitoragem", "Nao foi possivel criar arquivo de Monitoramento" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "A Cancelar Tal�o Fiscal...", "Cancelando Cupom Fiscal..." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "A Recuperar Tal�o Fiscal... N�o Foi Poss�vel Cancel�-lo Por Estar Vinculado A Uma Transac��o Tel.", "Recuperando Cupom Fiscal... N�o foi possivel cancela-lo por estar vinculado a uma transac�o TEF" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "A Transa��o Foi Confirmada, Caso O Tal�o Tef Tenha Sido Impresso Com Problemas Utilize A Reimpress�o Em Rotinas Tef", "A transac�o foi confirmada, caso o Cupom TEF tenha sido impresso com problemas utilize a reimpress�o em ROTINAS TEF" )
		#define STR0028 "Venda Assistida"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Or�amento exclu�do.", "Orcamento excluido." )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel excluir este or�amento.", "N�o foi possivel excluir este orcamento." )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Cancelamento N�o Efectuado, Pois O Caixa � Diferente Do Operador.", "Cancelamento n�o efetuado, pois o caixa � diferente do Operador." )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "A Recuperar Itens...", "Recuperando Itens..." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "A efectuar a anula��o do tel. ", "Efetuando o cancelamento do TEF " )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Transac��o n�o efectuada, por favor guarde o tal�o", "Transa��o n�o efetuada, favor reter o cupom" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Deseja realmente anular a recupera��o da �ltima venda ?", "Deseja realmente cancelar a recupera��o da ultima venda ?" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "A cancelar reservas criadas para este or�amento...", "Cancelando reservas geradas para este or�amento..." )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Transac��o tef n�o efectuada, � favor reter o tal�o.", "Transa��o TEF n�o efetuada, favor reter o cupom." )
		#define STR0038 "Rotina de troca"
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Registo(s) do alias ", "Registro(s) do alias " )
		#define STR0040 " exclu�do(s)"
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "N�o exclu�do(s)", "n�o exclu�do(s)" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "(filho)", " (filho)" )
	#endif
#endif
