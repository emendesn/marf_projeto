#ifdef SPANISH
	#define STR0001 'Ventas > Pago'
	#define STR0002 'Seleccione la forma de pago'
	#define STR0003 'Restan '
	#define STR0004 ' para pago'
	#define STR0005 'Seleccione la forma de pago anterior para proseguir.'
	#define STR0006 "Pago"
	#define STR0007 "Sucursal"
	#define STR0008 "Cond. Pgto."
	#define STR0009 "Cuotas"
	#define STR0010 ' - Condicion de pago'
	#define STR0011 "Por tratarse de recarga de tarjeta fidelidad, esta opcion no esta disponible."
	#define STR0012 "No es posible finalizar la venta, ese presupuesto se finalizo por otro PDV."
	#define STR0013 "Resumen del pago"
	#define STR0014 "Forma"
	#define STR0015 "Valor"
	#define STR0016 "Cuotas"
	#define STR0017 "Saldo Restante"
	#define STR0018 "Vuelto"
	#define STR0019 "Finalizar pago"
	#define STR0020 "Limpiar Pago(s)."
	#define STR0021 "Maximo de 2 tarjetas utilizadas en la venta"
	#define STR0022 "Por tratarse de recarga de tarjeta fidelidad, esa opcion esta indisponible."
	#define STR0023 "Saldo de la venta mayor que el valor pagado."
	#define STR0024 "Multi Negociacion"
	#define STR0025 'Valor invalido. '
	#define STR0026 "Factura de Credito Cod. Barras"
	#define STR0027 "Saldo cupon de regalo"
	#define STR0028 "Saldo por pagar"
	#define STR0029 "Sin autorización para Modificar cuotas"
#else
	#ifdef ENGLISH
		#define STR0001 'Sales > Payment'
		#define STR0002 'Select payment condition'
		#define STR0003 'Remain '
		#define STR0004 ' for payment'
		#define STR0005 'Select payment conditions above to continue.'
		#define STR0006 "Payment"
		#define STR0007 "Branch"
		#define STR0008 "Payment mode"
		#define STR0009 "Installments"
		#define STR0010 ' - Payment mode'
		#define STR0011 "This option is unavailable because it is a recharge of a loyalty card."
		#define STR0012 "Sale could not be closed, as this estimate is already finalized by another POS."
		#define STR0013 "Payment summary"
		#define STR0014 "Term"
		#define STR0015 "Value"
		#define STR0016 "Installments"
		#define STR0017 "Remaining Balance"
		#define STR0018 "Change"
		#define STR0019 "Finish payment"
		#define STR0020 "Clear Payment(s)."
		#define STR0021 "Maximum of 2 cards used in sale"
		#define STR0022 "This option is unavailable because it is a recharge of a loyalty card."
		#define STR0023 "Sale balance is greater than the paid value!"
		#define STR0024 "Multi Negotiation"
		#define STR0025 'Value not valid. '
		#define STR0026 "Barcode Credit Note"
		#define STR0027 "Gift Certificate Balance"
		#define STR0028 "Balance Payable"
		#define STR0029 "Without permit to Edit Installments"
	#else
		#define STR0001 'Vendas > Pagamento'
		#define STR0002 If( cPaisLoc $ "ANG|PTG", 'Seleccione a forma de pagamento', 'Selecione a forma de pagamento' )
		#define STR0003 'Restam '
		#define STR0004 ' para pagamento'
		#define STR0005 If( cPaisLoc $ "ANG|PTG", 'Seleccione a forma de pagamento acima para prosseguir.', 'Selecione a forma de pagamento acima para prosseguir.' )
		#define STR0006 "Pagamento"
		#define STR0007 "Filial"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Cond. pgt.", "Cond. Pgto." )
		#define STR0009 "Parcelas"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", ' - Condição de pagamento', ' - Condicao de pagamento' )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Por tratar-se de recarga de cartão fidelidade, esta opção está indisponível.", "Por se tratar de recarga de cartão fidelidade, essa opção está indisponível." )
		#define STR0012 "Não é possível finalizar a venda, este orçamento já foi finalizado por outro PDV."
		#define STR0013 "Resumo do pagamento"
		#define STR0014 "Forma"
		#define STR0015 "Valor"
		#define STR0016 "Parcelas"
		#define STR0017 "Saldo Restante"
		#define STR0018 "Troco"
		#define STR0019 "Finalizar pagamento"
		#define STR0020 "Limpar Pagto(s)."
		#define STR0021 "Maximo de 2 cartoes utilizados na venda"
		#define STR0022 "Por se tratar de recarga de cartão fidelidade, essa opção está indisponível."
		#define STR0023 "Saldo da venda maior que o valor pago!"
		#define STR0024 "Multi Negociação"
		#define STR0025 'Valor inválido. '
		#define STR0026 "Nota de Crédito Cód. Barras"
		#define STR0027 "Saldo Vale Presente"
		#define STR0028 "Saldo a Pagar"
		#define STR0029 "Sem permissão para Alterar Parcelas"
	#endif
#endif
