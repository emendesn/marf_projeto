//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DEFINEs PARA RECEBIMENTO DE TITULO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE HISTORICO	1	//Historico do Recebimento
#DEFINE NUMCOO		2	//Numero Sequencia Operacao
#DEFINE NUMCRO		3	//Contador do Reinicio
#DEFINE NROPARCELA	4	//Numero da Parcela
#DEFINE NUMPDV		5	//Numero do Terminal
#DEFINE CXSIAC		6	//Cod.Operador SIAC
#DEFINE VALOR		7	//Valor do Recebimento
#DEFINE JUROS		8	//Juros
#DEFINE DESCONTO	9	//Desconto
#DEFINE MULTA		10	//Multa
#DEFINE TROCO		11	//Troco
#DEFINE DTEMISSAO	12	//Data Emissao
#DEFINE DTVENCTO	13	//Data Vencimento
#DEFINE IDPRIMARIA	14	//Identificao Primaria Cliente  
#DEFINE NSUSIAC		15	//NSUHost


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DEFINEs PARA REDUCAO Z³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE T 	1		//Tributado/Reduzido
#DEFINE S 	2		//Servico
#DEFINE F	3		//Substituicao Tributaria
#DEFINE I	4		//Isento
#DEFINE N	5		//Nao Tributado

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                          E S T R U T U R A S                      		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³					C L I E N T E S     		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WsStruct ReturnCustomer
	WsData retorno			As StRetornoTransacao OPTIONAL	
	WsData customer			As StructCustomer OPTIONAL
EndWsStruct	
                       
WsStruct StructCustomer
	WSData cgc					As String	OPTIONAL
	WSData nome					As String	OPTIONAL
	WSData endereco				As String	OPTIONAL
	WSData bairro				As String	OPTIONAL
	WSData municipo				As String	OPTIONAL
	WSData estado				As String	OPTIONAL
	WSData cep			 		As Integer	OPTIONAL
	WSData ddd					As Integer	OPTIONAL
	WSData fone					As Integer	OPTIONAL
	WSData contato				As String	OPTIONAL
	WSData inscrMun				As String	OPTIONAL
	WSData InscrEst				As String	OPTIONAL
	WSData parcelamento			As String	OPTIONAL
	WSData qtdMaxParc			As Integer	OPTIONAL
	WSData valorMinParc			As Float	OPTIONAL
	WSData tipo					As STring	OPTIONAL
	WSData libCompra			As String	OPTIONAL
	WSData mensBloq				As String	OPTIONAL
	WSData categoria			As String	OPTIONAL
	WSData senha				As String	OPTIONAL
	WSData limiteCredito		As Float	OPTIONAL
	WSData limitePeriodo		As Float	OPTIONAL
	WSData saldoPeriodo			As Float	OPTIONAL
	WSData percEstouro			As Integer	OPTIONAL
	WSData percCobertura		As Integer	OPTIONAL
	WSData valorAcumuladoMes	As Float	OPTIONAL
	WSData tipoMens1			As String	OPTIONAL
	WSData mensagem1			As String	OPTIONAL
	WSData tipoMens2			As String	OPTIONAL
	WSData mensagem2			As String	OPTIONAL
	WSData tipoMens3			As String	OPTIONAL
	WSData mensagem3			As String	OPTIONAL
	WSData tipoMens4			As String	OPTIONAL
	WSData mensagem4			As String	OPTIONAL
	WSData empConveniada		As String	OPTIONAL
EndWsStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CONSULTAPREVENDA / BAIXAPREVENDA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WsStruct StructPreSale //StPreVenda
	//novos atributos que identificam Grupo de Empresa e Filial
	WsData codEmpresa	As String
	WsData codFilial	As String
	
	WsData empresa		As Integer	OPTIONAL
	WsData loja			As Integer	OPTIONAL
	WsData orcamento	As Integer	OPTIONAL
	WsData dataMov		As String	OPTIONAL
	WsData coo			As Integer	OPTIONAL
	WsData pdv			As Integer	OPTIONAL
EndWsStruct

WsStruct RetPreSales
	WsData retorno	As StRetornoTransacao
	WsData cliente	As StructCustomerPreSales	OPTIONAL
	WsData detalhe	As StructDetalhePreSales	OPTIONAL
EndWsStruct

	WsStruct StructCustomerPreSales
		WsData bairro				As String	OPTIONAL
		WsData categoriaCliente		As Integer	OPTIONAL
		WsData cep					As Integer	OPTIONAL
		WsData cgc					As Integer	OPTIONAL
		WsData ddd					As Integer	OPTIONAL
		WsData endereco				As String	OPTIONAL
		WsData estado				As String	OPTIONAL
		WsData inscrEst				As String	OPTIONAL
		WsData inscrMun				As String	OPTIONAL
		WsData mensagem1			As String	OPTIONAL
		WsData mensagem2			As String	OPTIONAL
		WsData mensagem3			As String	OPTIONAL
		WsData mensagem4			As String	OPTIONAL
		WsData municipo				As String	OPTIONAL
		WsData nome					As String	OPTIONAL
		WsData fone					As Integer	OPTIONAL
		WsData tipoMens1			As String	OPTIONAL
		WsData tipoMens2			As String	OPTIONAL
		WsData tipoMens3			As String	OPTIONAL
		WsData tipoMens4			As String	OPTIONAL
		WsData empConveniada		As String	OPTIONAL		
        WsData tipoCliente			As String	OPTIONAL	//0-Normal	1-Cooperado
		WsData valorSaldoPeriodo	As Float	OPTIONAL
	EndWsStruct
	
	WsStruct StructDetalhePreSales
		WsData loja							As Integer 	OPTIONAL
		WsData codProdDelivery				As Integer	OPTIONAL	
		WsData consisteData					As String	OPTIONAL
		WsData indicadorFinalizacao			As String	OPTIONAL		
		WsData preVendaComFinalizadora		As String	OPTIONAL
		WsData origemPedido					As Integer	OPTIONAL
		WsData precoTaxaDelivery			As Integer	OPTIONAL
		WsData tipoPedido					As Integer	OPTIONAL
		WsData listaFinalizadoras			As Array Of StructFinalizadora	OPTIONAL
		WsData listaProdutos				As Array Of StructItemPreSale	OPTIONAL
	EndWsStruct

		WsStruct StructFinalizadora
			WsData codigoFinalizadora		As Integer
			WsData valorFinalizadora 		As Float
		EndWsStruct
		
		WsStruct StructItemPreSale //StPreVendaItem
			WsData categoria				As Integer	OPTIONAL	//categoriaClientePromocao	
			WsData produto					As Integer
			WsData codPromocao				As Integer	OPTIONAL	//Null ou com 000000
			WsData reserva					As Integer	OPTIONAL
			WsData vendedor					As Integer	OPTIONAL
			WsData crm						As Integer	OPTIONAL
			WsData descricao				As String	OPTIONAL		
			WsData nivelPromocao			As Integer	OPTIONAL 	//obrigatorio se codigoPromocao <> 000000
			WsData percDesconto				As Float	OPTIONAL
			WsData prcPromo 				As Float	OPTIONAL
			WsData prcUnitario				As Float
			WsData quantidade				As Integer
			WsData tpDesconto				As Integer	OPTIONAL
			WsData tpEntrega				As Integer
			WsData vlrDesconto				As Float	OPTIONAL
			WsData vlrTotalDesconto			As Float	OPTIONAL
		EndWsStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³						V E N D A S                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WsStruct StCupons
	//novos atributos que identificam Grupo de Empresa e Filial
	WsData codEmpresa	As String
	WsData codFilial	As String

	WsData cupons		As Array Of StCupom
EndWsStruct

WsStruct StCupom
	WsData cabCupom		As StCabCupom			OPTIONAL
	WsData itensCupom	As Array Of StItemCupom	OPTIONAL
	WsData pagamentos	As Array Of StPagamento	OPTIONAL
EndWsStruct

	WsStruct StCabCupom
		WsData dataMovto					As String	OPTIONAL
		WsData codLoja						As Integer 	OPTIONAL
		WsData numTerminal					As Integer	OPTIONAL
		WsData numContadorReinicioOperacao	As Integer	OPTIONAL
		WsData numSeqOperacaoEntrada		As Integer	OPTIONAL //COO de entrada de Operador
		WsData numSeqOperacao				As Integer	OPTIONAL
		WsData codTipoCupom					As Integer	OPTIONAL //0-Venda 1-Cancelamento
		WsData codTipoVenda					As Integer	OPTIONAL //0-Normal 1-PBM 2-Convenio
		WsData dtHrInicioVenda				As String	OPTIONAL
		WsData dtHrTotalizacao				As String	OPTIONAL
		WsData dtHrFimVenda					As String	OPTIONAL
		WsData codCategoriaCliente			As Integer	OPTIONAL
		WsData codTipoPBM					As Integer	OPTIONAL
		WsData codClientePBM				As String	OPTIONAL
		WsData nomeClientePBM				As String	OPTIONAL	
		WsData idPrimariaCliente			As String	OPTIONAL
		WsData idSecundariaCliente			As String	OPTIONAL
		WsData codEmpresaConveniada			As Integer	OPTIONAL
		WsData codOrigemPedido	   			As Integer	OPTIONAL	
		WsData codTipoAreaFiscal   			As Integer	OPTIONAL
		WsData qtdeItens		   			As Integer	OPTIONAL
		WsData qtdeItemVenda	   			As Float	OPTIONAL
		WsData valorVenda		   			As Float	OPTIONAL
		WsData qtdeItemCancel				As Float	OPTIONAL
		WsData valorCancel					As Float	OPTIONAL
		WsData valorDesc					As Float	OPTIONAL
		WsData valorDescSubTotal   			As Float	OPTIONAL
		WsData valorEncargo					As Float	OPTIONAL
		WsData valorTroco					As Float	OPTIONAL	
		WsData valorCopay					As Float	OPTIONAL
		WsData qtdePontos					As Integer	OPTIONAL
		WsData codStatusPonto	   			As Integer	OPTIONAL
		WsData gtVenda			   			As Float	OPTIONAL
		WsData gtCancel						As Float	OPTIONAL
		WsData gtDesc			   			As Float	OPTIONAL
		WsData numCEP			   			As Integer	OPTIONAL
		WsData codOperador		   			As Integer	OPTIONAL
		WsData codSupervisor	   			As Integer	OPTIONAL
		WsData numIdClienteImpressa			As String	OPTIONAL
		WsData descNomeCliente	   			As String	OPTIONAL
	EndWsStruct
	
	WsStruct StItemCupom
		WsData numSeqItem					As Integer	OPTIONAL
		WsData codTipoOperacao				As Integer	OPTIONAL //0-Venda 1-Cancelamento
		WsData codInternoProduto			As Integer	OPTIONAL
		WsData codTipoProduto				As Integer	OPTIONAL
		WsData codVenda						As Integer	OPTIONAL
		WsData codSecao						As Integer	OPTIONAL
		WsData codVendedor					As Integer	OPTIONAL
		WsData codReserva					As Integer	OPTIONAL
		WsData qtdeItemVenda				As Float	OPTIONAL
		WsData valorPrecoUnitario			As Float	OPTIONAL
		WsData valorCusto					As Float	OPTIONAL
		WsData valorVenda					As Float	OPTIONAL
		WsData valorDesc					As Float	OPTIONAL
		WsData valorCopay					As Float	OPTIONAL
		WsData codTrib						As Integer	OPTIONAL
		WsData codLegendaTrib				As String	OPTIONAL
		WsData valorAliquotaTrib			As Float	OPTIONAL
		WsData codModoVenda					As Integer	OPTIONAL
		WsData codCategoriaPromocao 		As Integer	OPTIONAL
		WsData codTipoEntrega				As Integer	OPTIONAL
		WsData numCRM						As Integer	OPTIONAL
		WsData numAutorizPBMS				As String	OPTIONAL
		WsData codSupervisor				As Integer	OPTIONAL
		WsData numRegistradorICMS			As Integer	OPTIONAL
		WsData codTipoICMSouISS				As Integer	OPTIONAL
		WsData valorDescSubTotal			As Float
	EndWsStruct

	WsStruct StPagamento
		WsData numSeqFinaliz				As Integer	OPTIONAL
		WsData codOrigemFinaliz				As Integer	OPTIONAL
		WsData codTipoFinaliz				As Integer 	OPTIONAL
		WsData codFinaliz				    As Integer	OPTIONAL
		WsData codFinalizIntegracao			As String	OPTIONAL
		WsData valorFinaliz					As Float	OPTIONAL
		WsData valorEncargo					As Float	OPTIONAL
		WsData codSupervisorAutoriz 		As Integer	OPTIONAL
		WsData descFinalizadoraECF			As String	OPTIONAL
		WsData valorSaque					As Float	OPTIONAL
		WsData codTipoConsulta				As Integer	OPTIONAL
		WsData codStatusConsulta			As Integer 	OPTIONAL
		WsData codTipoConsultaCredito		As Integer	OPTIONAL
		WsData codStatusConsultaCredito		As Integer	OPTIONAL
		WsData numDocConsulta				As String	OPTIONAL
		WsData dtHrOperacao					As String	OPTIONAL
		WsData numBanco						As Integer 	OPTIONAL
		WsData numAgencia					As Integer	OPTIONAL
		WsData numContaCorrente				As String	OPTIONAL
		WsData numCheque					As Integer	OPTIONAL
		WsData codDacCheque					As Integer	OPTIONAL
		WsData numCMC7						As String	OPTIONAL
		WsData codDDD						As String	OPTIONAL
		WsData numTelefone					As String	OPTIONAL
		WsData numCartao					As String	OPTIONAL
		WsData numCartaoProvisorio			As String	OPTIONAL
		WsData codTipoTransacao				As Integer	OPTIONAL
		WsData dtHrTransacao				As String	OPTIONAL
		WsData codModoTransacao				As Integer	OPTIONAL
		WsData codTipoJuros					As Integer	OPTIONAL
		WsData codPlanoTEF					As String	OPTIONAL
		WsData codStatusMultiCheque 		As Integer	OPTIONAL
		WsData codAutorizacao				As String	OPTIONAL
		WsData qtdeCiclosPular				As Integer	OPTIONAL
		WsData numNsuPDV					As Integer	OPTIONAL
		WsData numNsuHost					As String	OPTIONAL
		WsData numControle					As String	OPTIONAL
		WsData numParcela					As Integer	OPTIONAL
		WsData qtdeParcela					As Integer	OPTIONAL
		WsData valorParcela					As Float	OPTIONAL
		WsData dtDeposito					As String	OPTIONAL
		WsData codTabelaJuros				As Integer	OPTIONAL
		WsData taxaClienteMensal			As Float	OPTIONAL
		WsData taxaLojaEqualiza				As Float	OPTIONAL
		WsData prazoAgenciaLojista			As Integer	OPTIONAL
		WsData codTicket					As Integer	OPTIONAL
		WsData numDocFinaliz				As Integer	OPTIONAL
		WsData numBoleto					As String	OPTIONAL
		WsData codAutorizacaoAD5			As String	OPTIONAL
		WsData codBandeiraScope				As Integer	OPTIONAL
		WsData codRedeScope					As String	OPTIONAL		
		WsData codAdministradoraIntegracao	As String	OPTIONAL
	EndWsStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³				R E C E B I M E N T O			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WsStruct StRecebimentos
	//novos atributos que identificam Grupo de Empresa e Filial
	WsData codEmpresa	As String
	WsData codFilial	As String

	WsData recebimentos As Array of StRecebimento
EndWsStruct

WsStruct StRecebimento
	WsData cabRecebimento		As StCabRecebimento				OPTIONAL
	WsData itensRecebimento 	As Array Of StItemRecebimento	OPTIONAL
	WsData pagamentos			As Array Of StPagamento			OPTIONAL
EndWsStruct

	WsStruct StCabRecebimento
		WsData dataMovto					As String	OPTIONAL
		WsData codLoja						As Integer	OPTIONAL
		WsData numTerminal					As Integer	OPTIONAL
		WsData numContadorReinicioOperacao	As Integer	OPTIONAL
		WsData numSeqOperacaoEntrada		As Integer	OPTIONAL
		WsData numSeqOperacao				As Integer	OPTIONAL
		WsData dtHrRecebto					As String	OPTIONAL
		WsData qtdeItemRecebto				As Integer	OPTIONAL
		WsData valorTotalRecebto			As Float	OPTIONAL						
		WsData valorTroco					As Float	OPTIONAL			
		WsData numIdentificacaoPrimaria		As String	OPTIONAL
		WsData codEmpresaConveniada			As Integer OPTIONAL
		WsData numIdentClienteImpressa		As String	OPTIONAL
		WsData descNomeCliente				As String	OPTIONAL
		WsData codOperador		   			As Integer	OPTIONAL
	EndWsStruct
	
	WsStruct StItemRecebimento
		WsData numSeqRecbto					As Integer	OPTIONAL
		WsData codTipoRecebto				As Integer	OPTIONAL
		WsData codRecbto					As Integer	OPTIONAL
		WsData numDoc						As String	OPTIONAL
		WsData numParcela					As Integer	OPTIONAL
		WsData valorDoc						As Float	OPTIONAL
		WsData valorDesc					As Float 	OPTIONAL
		WsData valorJuros					As Float 	OPTIONAL
		WsData valorMulta					As Float 	OPTIONAL
		WsData dtContabil					As String 	OPTIONAL
		WsData dtVencimento					As String 	OPTIONAL
		WsData dtHrTransacao				As String 	OPTIONAL
		WsData numNsuPDV                    As Integer	OPTIONAL
		WsData numNsuHost                   As String	OPTIONAL
		WsData numSeqOperacaoVendaAssoc		As Integer	OPTIONAL
		WsData descNomeConvenioCedente		As String	OPTIONAL
		WsData descChaveJ					As String	OPTIONAL
		WsData numSeqChaveJ					As Integer	OPTIONAL
		WsData numAgenciaReceptora			As Integer	OPTIONAL
	EndWsStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³				ESTORNO RECEBIMENTO				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WsStruct StEstornosRecebimentos
	//novos atributos que identificam Grupo de Empresa e Filial
	WsData codEmpresa	As String
	WsData codFilial	As String
	WsData estornosRecebimentos As Array of StEstornoRecebimento	OPTIONAL
EndWsStruct

	WsStruct StEstornoRecebimento
		WsData estornoCabRecebimento	As StEstornoCabRecebimento				OPTIONAL
		WsData estornoItensRecebimento 	As Array Of StEstornoItemRecebimento	OPTIONAL
	EndWsStruct
	
		WsStruct StEstornoCabRecebimento
			WsData dataMovto					As String	OPTIONAL
			WsData codLoja						As Integer	OPTIONAL
			WsData numTerminal					As Integer	OPTIONAL
			WsData numContadorReinicioOperacao	As Integer	OPTIONAL
			WsData numSeqOperacaoEntrada		As Integer	OPTIONAL
			WsData numSeqOperacao				As Integer	OPTIONAL
			WsData codSupervisorAutoriz			As Integer	OPTIONAL
			WsData dtHrEstorno					As String	OPTIONAL
			WsData qtdeItemEstorno				As Integer	OPTIONAL
			WsData valorTotalEstorno			As Float	OPTIONAL						
			WsData numIdentificacaoPrimaria		As String	OPTIONAL
			WsData codEmpresaConveniada			As Integer	OPTIONAL			
			WsData codOperador		   			As Integer	OPTIONAL
		EndWsStruct
		
		WsStruct StEstornoItemRecebimento
			WsData numSeqEstorno				As Integer	OPTIONAL
			WsData dtHrTransacao				As String	OPTIONAL
			WsData numNsuPDV					As Integer	OPTIONAL
			WsData numNsuHost					As String	OPTIONAL
			WsData numPDVOrigem					As Integer	OPTIONAL
			WsData numSeqOperacaoOrigem			As Integer	OPTIONAL
			WsData dtHrEstorno					As String	OPTIONAL
			WsData codTipoEstornoRecebto		As Integer	OPTIONAL
			WsData codRecebto					As Integer	OPTIONAL
			WsData numDoc						As String	OPTIONAL
			WsData numParcela					As Integer	OPTIONAL
			WsData valorDoc						As Float	OPTIONAL
			WsData numNsuHostOrigem				As String 	OPTIONAL
			WsData numNsuPDVOrigem				As Integer	OPTIONAL
		EndWsStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                    R E C A R G A   C E L U L A R                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WsStruct StRecargas
	//novos atributos que identificam Grupo de Empresa e Filial
	WsData codEmpresa	As String
	WsData codFilial	As String
	
	WsData recargas	As Array Of StRecarga
EndWsStruct

	WsStruct StRecarga
		WsData recargaCelular	As StRecargaCelular		OPTIONAL
		WsData pagamentos		As Array Of StPagamento	OPTIONAL
	EndWsStruct            
	
		WsStruct StRecargaCelular	
			WsData dataMovto					As String	OPTIONAL
			WsData codLoja						As Integer	OPTIONAL
			WsData codOperador					As Integer	OPTIONAL
			WsData numTerminal					As Integer	OPTIONAL
			WsData numContadorReinicioOperacao	As Integer	OPTIONAL
			WsData numSeqOperacaoEntrada		As Integer	OPTIONAL
			WsData numSeqOperacao				As Integer	OPTIONAL
			WsData codTipoRecarga				As Integer	OPTIONAL
			WsData dtHrRecarga					As String	OPTIONAL
			WsData valorRecarga					As Float	OPTIONAL
			WsData valorTroco					As Float	OPTIONAL
			WsData codSupervisor				As Integer	OPTIONAL
			WsData dtHrTransacao				As String	OPTIONAL
			WsData numNsuPDV					As Integer	OPTIONAL
			WsData numNsuHost					As String	OPTIONAL
			WsData codAutorizador				As Integer	OPTIONAL
			WsData codOperadoraCelular			As Integer	OPTIONAL
			WsData codCredito					As Integer	OPTIONAL
			WsData codDDD						As Integer	OPTIONAL
			WsData numTelefone					As Integer	OPTIONAL
			WsData codDacTelefone				As Integer	OPTIONAL
			WsData codFilialRegional			As String	OPTIONAL
		EndWsStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³					SANGRIA						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WsStruct StSangrias
	//novos atributos que identificam Grupo de Empresa e Filial
	WsData codEmpresa	As String
	WsData codFilial	As String

	WsData sangrias	As Array Of StSangria	OPTIONAL
EndWsStruct

	WsStruct StSangria
		WsData dataMovto					As String	OPTIONAL
		WsData codLoja						As Integer 	OPTIONAL
		WsData numTerminal					As Integer	OPTIONAL
		WsData numContadorReinicioOperacao	As Integer	OPTIONAL
		WsData numSeqOperacaoEntrada		As Integer	OPTIONAL
		WsData numSeqOperacao				As Integer	OPTIONAL
		WsData codTipoSangria				As Integer	OPTIONAL
		WsData dtHrSangria					As String	OPTIONAL
		WsData codSupervisor				As Integer	OPTIONAL
		WsData codOperadorSangria			As Integer	OPTIONAL
		WsData numMaloteSangria				As Integer	OPTIONAL
		WsData listaSangriaFinalizacoes		As Array Of StSangriaFinalizacao	OPTIONAL
	EndWsStruct

		WsStruct StSangriaFinalizacao
			WsData codFinaliz			As Integer	OPTIONAL
			WsData codFinalizIntegracao	As String	OPTIONAL
			WsData numOrdemGeracao		As Integer	OPTIONAL	
			WsData valorFinaliz    		As Float	OPTIONAL
			WsData codTipoFinaliz		As Integer	OPTIONAL
			WsData qtdeFinaliz 	   		As Integer	OPTIONAL
		EndWsStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³				ENTRADA NUMERARIO				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
WsStruct StEntradasNumerarios
	//novos atributos que identificam Grupo de Empresa e Filial
	WsData codEmpresa	As String
	WsData codFilial	As String

	WsData entradasNumerarios As Array Of StEntradaNumerario
EndWsStruct

	WsStruct StEntradaNumerario
		WsData dataMovto					As String	OPTIONAL
		WsData codLoja						As Integer 	OPTIONAL
		WsData numTerminal					As Integer	OPTIONAL
		WsData numContadorReinicioOperacao	As Integer	OPTIONAL
		WsData numSeqOperacaoEntrada		As Integer	OPTIONAL
		WsData numSeqOperacao				As Integer	OPTIONAL
		WsData codOperador					As Integer	OPTIONAL
		WsData codOrigemEntrada				As Integer	OPTIONAL
		WsData valorEntradaNumerario		As Float	OPTIONAL
	EndWsStruct


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³				REDUCAO Z				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WsStruct StReducoesZ
	//novos atributos que identificam Grupo de Empresa e Filial
	WsData codEmpresa	As String
	WsData codFilial	As String

	WsData reducoesZ	As Array Of StReducaoZ
EndWsStruct

	WsStruct StReducaoZ
		WsData dataMovto					As String	OPTIONAL
		WsData codLoja						As Integer 	OPTIONAL
		WsData numTerminal					As Integer	OPTIONAL
		WsData numContadorReinicioOperacao	As Integer	OPTIONAL
		WsData numSeqOperacaoAbertura		As Integer	OPTIONAL //COO de entrada de Operador
		WsData numSeqOperacaoFechamentoZ	As Integer	OPTIONAL
		WsData numFechamentoZ				As Integer	OPTIONAL
		WsData gtVendaInicial				As Float	OPTIONAL
		WsData gtVendaFinal					As Float	OPTIONAL
		WsData gtCancelInicial				As Float	OPTIONAL
		WsData gtCancelFinal				As Float	OPTIONAL
		WsData gtDescInicial				As Float	OPTIONAL
		WsData gtDescFinal					As Float	OPTIONAL		
		WsData numVersaoFirmware			As String	OPTIONAL
		WsData numSerieImpressora			As String	OPTIONAL
		WsData codMD5						As String	OPTIONAL
		WsData valorEncargoVenda			As Float	OPTIONAL
		WsData valorRecebtoProprio			As Float	OPTIONAL
		WsData valorEstornoRecebtoProprio	As Float	OPTIONAL
		WsData valorEncargoRecebtoProprio	As Float	OPTIONAL		
		WsData valorRecebtoBanc				As Float	OPTIONAL
		WsData valorEstornoRecebtoBanc		As Float	OPTIONAL		
		WsData listaTributacao				As Array Of StTributacao	OPTIONAL
		WsData listaRegistradores			As Array Of StRegistradores	OPTIONAL
	EndWsStruct

		WsStruct StTributacao
			WsData codTrib					As Integer	OPTIONAL//EX: 	01          |02			|03      |05
			WsData codLegendaTrib			As String	OPTIONAL		//I			|F 			|Sn		 |Tn(Integral ou reduzido)
			WsData codTributacaoExterna		As String	OPTIONAL    	//0001.501	|0001.502	|0001.503|0001.504
			WsData valorAliquotaTrib		As Float	OPTIONAL    	//0.00		|0.00		|2.00    |18.00
			WsData valorBaseCalculo			As Float	OPTIONAL    	//100.00    |200.00		|20.00   |100.00
			WsData valorImposto				As Float	OPTIONAL    	//O.00      |0.00		|4.00    |18.00
		EndWsStruct
		
		WsStruct StRegistradores
			WsData codTipoRegistrador			As Integer	OPTIONAL
			WsData descRegistrador				As String	OPTIONAL
			WsData numRegistrador				As Integer	OPTIONAL
			WsData valorRegistrador				As Float	OPTIONAL
			WsData valorRegistradorNaoFiscal	As Float	OPTIONAL
		EndWsStruct		


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³					R E T O R N O				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WsStruct StRetornos
	WsData retornos 		As Array Of StRetorno
EndWsStruct

	WsStruct StRetorno
		WsData dataMovto					As String	OPTIONAL
		WsData codLoja						As Integer 	OPTIONAL
		WsData numTerminal					As Integer	OPTIONAL
		WsData numContadorReinicioOperacao	As Integer	OPTIONAL
		WsData numSeqOperacaoEntrada		As Integer	OPTIONAL
		WsData numSeqOperacao				As Integer	OPTIONAL
		WsData codRecepcao					As Integer	OPTIONAL
		WsData msgRejeicao					As String	OPTIONAL
	EndWsStruct

WsStruct StRetornoTransacao
	WsData codigo			As Integer	OPTIONAL
	WsData descricao		As String	OPTIONAL
	WsData trace			As String	OPTIONAL
	WsData loja				As Integer	OPTIONAL
	WsData ipServidor		As String	OPTIONAL
	WsData dataHora			As String	OPTIONAL
	wsdata detalhes			As Array Of StRetornoTransacao OPTIONAL
EndWsStruct                                  