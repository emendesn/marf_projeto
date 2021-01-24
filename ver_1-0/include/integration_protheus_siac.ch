//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                          E S T R U T U R A S                      		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                          C L I E N T E S                          		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSStruct ReturnCustomer
	WSData Retorno			As StructRetorno OPTIONAL
	WSData Customer			As StructCustomer OPTIONAL
EndWSStruct	
                       
WSStruct StructCustomer
	WSData CGC					As String	OPTIONAL
	WSData Nome					As String	OPTIONAL
	WSData Endereco				As String	OPTIONAL
	WSData Bairro				As String	OPTIONAL
	WSData Municipo				As String	OPTIONAL
	WSData Estado				As String	OPTIONAL
	WSData CEP					As Integer	OPTIONAL
	WSData DDD					As Integer	OPTIONAL
	WSData Fone					As Integer	OPTIONAL
	WSData Contato				As String	OPTIONAL
	WSData InscrMun				As String	OPTIONAL
	WSData InscrEst				As String	OPTIONAL
	WSData Parcelamento			As String	OPTIONAL
	WSData QtdMaxParc			As Integer	OPTIONAL
	WSData ValorMinParc			As Float	OPTIONAL
	WSData Tipo					As STring	OPTIONAL
	WSData LibCompra			As String	OPTIONAL
	WSData MensBloq				As String	OPTIONAL
	WSData Categoria			As String	OPTIONAL
	WSData Senha				As String	OPTIONAL
	WSData LimiteCredito		As Float	OPTIONAL
	WSData LimitePeriodo		As Float	OPTIONAL
	WSData SaldoPeriodo			As Float	OPTIONAL
	WSData PercEstouro			As Integer	OPTIONAL
	WSData PercCobertura		As Integer	OPTIONAL
	WSData ValorAcumuladoMes	As Float	OPTIONAL
	WSData TipoMens1			As String	OPTIONAL
	WSData Mensagem1			As String	OPTIONAL
	WSData TipoMens2			As String	OPTIONAL
	WSData Mensagem2			As String	OPTIONAL
	WSData TipoMens3			As String	OPTIONAL
	WSData Mensagem3			As String	OPTIONAL
	WSData TipoMens4			As String	OPTIONAL
	WSData Mensagem4			As String	OPTIONAL
	WSData EmpConveniada		As String	OPTIONAL
EndWSStruct


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³          P R E - V E N D A S  / B A I X A   P R E - V E N D A             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSStruct StructPreSale
	WSData Empresa		As Integer	OPTIONAL
	WSData Loja			As Integer	OPTIONAL
	WSData DataMov		As String	OPTIONAL
	WSData Orcamento	As Integer	OPTIONAL
	WSData PDV			As Integer	OPTIONAL
	WSData COO			As Integer	OPTIONAL
EndWSStruct	
	
WSStruct RetPreSales
	WSData Retorno					As StructRetorno OPTIONAL
	WSData Detalhe					As StructDetalhePreSales OPTIONAL
	WSData Cliente					As StructCustomerPreSales OPTIONAL
EndWSStruct	

WSStruct StructDetalhePreSales
	WSData Loja						As Integer	OPTIONAL	
	WSData TipoPedido				As Integer	OPTIONAL	
	WSData OrigemPedido				As Integer	OPTIONAL	
	WSData ConsisteData				As String	OPTIONAL	
	WSData CodProdDelivery			As Integer	OPTIONAL	
	WSData PrecoTaxaDelivery		As Integer	OPTIONAL	
	WSData PreVendacomFinalizadora	As String	OPTIONAL
	WSData IndicadorFinalizacao		As String	OPTIONAL
	WSData ListaFinalizadoras		As Array Of StructFinalizadora OPTIONAL
	WSData ListaProdutos			As Array of StructItemPreSale OPTIONAL
EndWSStruct	
	
WSStruct StructCustomerPreSales
	WSData CGC					As String	OPTIONAL
	WSData Nome					As String	OPTIONAL
	WSData Endereco				As String	OPTIONAL
	WSData Bairro				As String	OPTIONAL
	WSData Municipo				As String	OPTIONAL
	WSData CategoriaCliente		As Integer   OPTIONAL
	WSData Estado				As String	OPTIONAL
	WSData CEP					As Integer	OPTIONAL
	WSData DDD					As Integer	OPTIONAL
	WSData Fone					As Integer	OPTIONAL
	WSData InscrMun				As String	OPTIONAL
	WSData InscrEst				As String	OPTIONAL
	WSData TipoMens1			As String	OPTIONAL
	WSData Mensagem1			As String	OPTIONAL
	WSData TipoMens2			As String	OPTIONAL
	WSData Mensagem2			As String	OPTIONAL
	WSData TipoMens3			As String	OPTIONAL
	WSData Mensagem3			As String	OPTIONAL
	WSData TipoMens4			As String	OPTIONAL
	WSData Mensagem4			As String	OPTIONAL
	WSData EmpConveniada		As String	OPTIONAL
EndWSStruct	
	
WSStruct StructFinalizadora
	WSData CodigoFinalizadora	As Integer	OPTIONAL
	WSData ValorFinalizadora	As Float	OPTIONAL
EndWSStruct


WSStruct StructItemPreSale
	WSData Produto			As Integer	OPTIONAL
	WSData Quantidade		As Float	OPTIONAL
	WSData PrcUnitario		As Float	OPTIONAL
	WSData PrcPromo			As Float	OPTIONAL
	WSData Descricao		As String	OPTIONAL
	WSData Vendedor			As Integer	OPTIONAL
	WSData TpEntrega		As Integer	OPTIONAL
	WSData Reserva			As Integer	OPTIONAL
	WSData CRM				As Integer	OPTIONAL
	WSData VlrDesconto		As Float	OPTIONAL
	WSData TpDesconto		As Integer	OPTIONAL
	WSData CodPromocao		As Integer	OPTIONAL
	WSData NivelPromocao	As Integer	OPTIONAL
	WSData PercDesconto		As Float	OPTIONAL
	WSData Categoria		As Integer	OPTIONAL
EndWSStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                            V E N D A S                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSStruct Sales
	WSData Sale As Array Of StructSales
EndWSStruct
                 
WSStruct StructSales
	WSData DtMovimento		As String	OPTIONAL
	WSData Loja				As Integer	OPTIONAL
	WSData Terminal			As Integer	OPTIONAL
	WSData Contador			As Integer	OPTIONAL
	WSData COO_Entrada		As Integer	OPTIONAL
	WSData COO				As Integer	OPTIONAL
	WSData NumeroTalao		As Integer	OPTIONAL
	WSData TipoCupom		As Integer	OPTIONAL
	WSData TipoVenda		As Integer	OPTIONAL
	WSData InicioVenda		As String	OPTIONAL
	WSData FimVenda			As String	OPTIONAL
	WSData CategCliente		As Integer	OPTIONAL
	WSData IDPrimariaCli	As String	OPTIONAL
	WSData IDSecundariaCli	As String	OPTIONAL
	WSData EmpConv			As Integer	OPTIONAL
	WSData TipoPBM			As Integer	OPTIONAL
	WSData CodCliPBM		As String	OPTIONAL
	WSData NomeCliPBM		As String	OPTIONAL
	WSData OrigemPedido		As Integer	OPTIONAL
	WSData QtdeItem			As Integer	OPTIONAL
	WSData ValorVenda		As Integer	OPTIONAL
	WSData QtdeItemCanc		As Integer	OPTIONAL
	WSData ValorCancelado	As Integer	OPTIONAL
	WSData VlrDesconto		As Integer	OPTIONAL
	WSData VlrDescSubTot	As Integer	OPTIONAL
	WSData VlrEncargo		As Integer	OPTIONAL
	WSData VlrTroco			As Integer	OPTIONAL
	WSData QtdePontos		As Integer	OPTIONAL
	WSData StatusPontos		As Integer	OPTIONAL
	WSData GTVenda			As Integer	OPTIONAL
	WSData GTCancelamento	As Integer	OPTIONAL
	WSData GTDesconto		As Integer	OPTIONAL
	WSData ItensVenda		As Array of StructItensVenda OPTIONAL
	WSData ListaPagamentos	As Array of StructListaPagamentos OPTIONAL
EndWSStruct


WSStruct StructItensVenda
	WSData NumSeq			As Integer	OPTIONAL
	WSData TpOperacao		As Integer	OPTIONAL
	WSData TpProduto		As Integer	OPTIONAL
	WSData CodProduto		As Integer	OPTIONAL
	WSData CodVenda			As String	OPTIONAL
	WSData CodSecao			As Integer	OPTIONAL
	WSData QtdeItem			As Integer	OPTIONAL
	WSData PrUnit			As Integer	OPTIONAL
	WSData Valor			As Integer	OPTIONAL
	WSData VlrCusto			As Integer	OPTIONAL
	WSData VlrDesconto		As Integer	OPTIONAL
	WSData CodTrib			As Integer	OPTIONAL
	WSData LegendaTrib		As String	OPTIONAL
	WSData AliqTrib			As Integer	OPTIONAL
	WSData ProdTemAssociado	As String	OPTIONAL
	WSData ProdAssociado	As String	OPTIONAL
	WSData MarcaPropria		As String	OPTIONAL
	WSData QtdObrigat		As String	OPTIONAL
	WSData QtdAutorizada	As String	OPTIONAL
	WSData PermiteDesc		As String	OPTIONAL
	WSData PisCofins		As String	OPTIONAL
	WSData PermitePreco		As String	OPTIONAL
	WSData Vendedor			As Integer	OPTIONAL
	WSData Reserva			As Integer	OPTIONAL
	WSData MododeVenda		As Integer	OPTIONAL
	WSData CategPromocao	As Integer	OPTIONAL
	WSData TipoEntrega		As Integer	OPTIONAL
	WSData NumCRM  			As Integer	OPTIONAL
	WSData AutorizadoraPBM	As String	OPTIONAL
EndWSStruct

WSStruct StructListaPagamentos
	WSData NumSeqFinalizacao	As Integer		OPTIONAL
	WSData OrigemFinalizacao	As Integer		OPTIONAL
	WSData TipoFinalizacao		As Integer		OPTIONAL
	WSData CodFinalizacao		As Integer		OPTIONAL
	WSData ValorFinalizacao		As Integer		OPTIONAL
	WSData VlrEncargo			As Integer		OPTIONAL
	WSData Cheque  				As StructCheque	OPTIONAL
	WSData TEF					As StructTEF	OPTIONAL
	WSData Vale					As StructVale	OPTIONAL
EndWSStruct

WSStruct StructCheque
	WSData Banco			As Integer		OPTIONAL
	WSData Agencia			As Integer		OPTIONAL
	WSData ContaCorrente	As Integer		OPTIONAL
	WSData NumCheque		As Integer		OPTIONAL
	WSData DACCheque		As Integer		OPTIONAL
	WSData NumCMC7			As String		OPTIONAL
	WSData QtdParcelas		As Integer		OPTIONAL
	WSData NumParcela		As Integer		OPTIONAL
	WSData VlrParcela		As Integer		OPTIONAL
	WSData DtDeposito		As String		OPTIONAL
	WSData CodigoDDD		As Integer		OPTIONAL
	WSData Telefone			As Integer		OPTIONAL
EndWSStruct    

WSStruct StructTEF
	WSData Cartao				As String		OPTIONAL
	WSData CartaoProvisorio		As String		OPTIONAL
	WSData TpTransacao			As Integer		OPTIONAL
	WSData DtHrTransacao		As String		OPTIONAL
	WSData ModoTransacao		As Integer		OPTIONAL
	WSData Bandeira				As Integer		OPTIONAL
	WSData Rede					As Integer		OPTIONAL
	WSData TipoJuros			As Integer		OPTIONAL
	WSData PlanoTEF				As String		OPTIONAL
	WSData StatusMulticheque	As Integer		OPTIONAL
	WSData Supervisor			As Integer		OPTIONAL
	WSData CodAutorizacao		As String		OPTIONAL
	WSData QtdeCiclos			As Integer		OPTIONAL
	WSData NSU_PDV				As Integer		OPTIONAL
	WSData NSU_Host				As String		OPTIONAL
	WSData NumControle			As String		OPTIONAL
	WSData NumParcela			As Integer		OPTIONAL
	WSData QtdeParcelas			As Integer		OPTIONAL
	WSData VlrParcela			As Integer		OPTIONAL
	WSData DtDeposito			As String		OPTIONAL
EndWSStruct 

WSStruct StructVale   
	WSData TipoDocFinalizacao	As Integer OPTIONAL
	WSData NumdocFinalziacao	As Integer OPTIONAL
EndWSStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                        R E C E B I M E N T O                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSStruct Recebimentos
	Wsdata Recebimento As Array of StructRecebimento 
EndWSStruct

WSStruct StructRecebimento
	WSData DataMovimento			As String	OPTIONAL
	WSData Loja						As String	OPTIONAL
	WSData NumeroTerminal			As Integer	OPTIONAL
	WSData Contador					As Integer	OPTIONAL
	WSData COO_Entrada				As Integer	OPTIONAL
	WSData COO						As Integer	OPTIONAL
	WSData DataHoraRecebimento		As String	OPTIONAL
	WSData VlrTotalRecebimento		As Integer	OPTIONAL
	WSData VlrTrocoRecebimento		As Integer	OPTIONAL
	WSData IDPrimariaCli			As String	OPTIONAL
	WSData EmpresaConveniada		As String 	OPTIONAL
	WSData ListaItensRecebimento	As Array Of StructItemRecebimento OPTIONAL
	WSData ListaPagamentos 			As Array of StructListaPagamentos
EndWSStruct

WSStruct StructItemRecebimento
	WSData NumeroSequencial		As Integer	OPTIONAL
	WSData TipoRecebimento		As Integer	OPTIONAL
	WSData CodigoRecebimento	As Integer	OPTIONAL
	WSData NumeroDocumento		As String	OPTIONAL
	WSData NumeroParcela		As Integer	OPTIONAL
	WSData ValorDocumento		As Integer	OPTIONAL
	WSData ValorDesconto		As Integer	OPTIONAL
	WSData ValorJuros			As Integer	OPTIONAL
	WSData ValorMulta			As Integer	OPTIONAL
	WSData DataContabil			As String	OPTIONAL
	WSData DataVencimento		As String	OPTIONAL
	WSData DataHoraTransacao	As String	OPTIONAL
	WSData NSU_PDV				As Integer	OPTIONAL
	WSData NSU_HOST				As String	OPTIONAL
	WSData COO_VendaAssociada	As Integer	OPTIONAL
	WSData ConvenioCedente		As String	OPTIONAL
	WSData ChaveJ				As String	OPTIONAL
	WSData SequenciaChaveJ		As String	OPTIONAL
	WSData AgenciaReceptora		As Integer	OPTIONAL
EndWSStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                E S T O R N O   R E C E B I M E N T O                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
WSStruct aEstornoRecebimento
	WSData aEstornoRecebimento As Array Of EstornoRecebimento
EndWSStruct

WSStruct EstornoRecebimento
	Wsdata EstornoRecebimento As Array Of StructEstornoRecebimento 
EndWSStruct

WSStruct StructEstornoRecebimento
	WSData DataMovimento			As String	OPTIONAL
	WSData Loja						As String	OPTIONAL
	WSData NumeroTerminal			As Integer	OPTIONAL
	WSData Contador					As Integer	OPTIONAL
	WSData COO_Entrada				As Integer	OPTIONAL
	WSData COO						As Integer	OPTIONAL
	WSData DataHoraEstorno			As String	OPTIONAL
	WSData Supervidor				As Integer	OPTIONAL
	WSData VlrTotalEstorno			As Integer	OPTIONAL
	WSData IDPrimariaCli			As String	OPTIONAL
	WSData EmpresaConveniada		As String 	OPTIONAL
	WSData ItensEstornoRecebimento	As Array Of StructItemEstornoRecebimento OPTIONAL
EndWSStruct
             
WSStruct StructItemEstornoRecebimento
	WSData NumeroSequencial		As Integer	OPTIONAL
	WSData DataHoraTransacao	As String	OPTIONAL
	WSData NSU_PDV				As Integer	OPTIONAL	
	WSData NSU_HOST				As String	OPTIONAL	
	WSData NSU_PDVOrigem		As Integer	OPTIONAL	
	WSData NSU_HOSTOrigem		As String	OPTIONAL	
	WSData PDVOrigem			As Integer	OPTIONAL		
	WSData COOOrigem			As Integer	OPTIONAL		
	WSData TipoRecebimento		As Integer	OPTIONAL
	WSData CodigoRecebimento	As Integer	OPTIONAL
	WSData NumeroDocumento		As String	OPTIONAL
	WSData NumeroParcela		As Integer	OPTIONAL
	WSData ValorDocumento		As Integer	OPTIONAL
EndWSStruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                    R E C A R G A   C E L U L A R                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSStruct RegargaCelular
	WSData RecargaCelular	As Array Of StructRecargaCelular
EndWSStruct                  

WSStruct StructRecargaCelular
	WSData DataMovimento			As String	OPTIONAL
	WSData Loja						As String	OPTIONAL
	WSData NumeroTerminal			As Integer	OPTIONAL
	WSData Contador					As Integer	OPTIONAL
	WSData COO_Entrada				As Integer	OPTIONAL
	WSData COO						As Integer	OPTIONAL
	WSData TipoRecarga				As Integer	OPTIONAL
	WSData DataHoraRecarga			As String	OPTIONAL
	WSData ValorRecarga				As Integer	OPTIONAL	
	WSData ValorTrocoRecarga		As Integer	OPTIONAL	
	WSData Supervidor				As Integer	OPTIONAL
	WSData DataHoraTransacao		As String	OPTIONAL	
	WSData NSU_PDV					As Integer	OPTIONAL	
	WSData NSU_HOST					As String	OPTIONAL	
	WSData CodigoAutorizadora		As Integer	OPTIONAL		
	WSData CodigoOperadora			As Integer	OPTIONAL		
	WSData CodigoCredito			As Integer	OPTIONAL		
	WSData CodigoDDD				As Integer	OPTIONAL		
	WSData Telefone					As String	OPTIONAL		
	WSData CodigoDAC				As String	OPTIONAL		
	WSData FilialRegional			As String	OPTIONAL		
	WSData ListaPagamentos 			As Array of StructListaPagamentos
EndWSStruct    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                           R E T O R N O                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSStruct StructRetorno
	WSData Codigo		As Integer OPTIONAL
	WSData Descricao	As String OPTIONAL
	WSData Trace		As String OPTIONAL
	WSData Loja			As Integer OPTIONAL
	WSData IPServidor	As String OPTIONAL
	WSData DataHora		As String OPTIONAL
	WSData Detalhes		As String OPTIONAL
EndWsStruct                      

//WSStruct tDetRetorno
//	WSData Codigo		As Integer OPTIONAL
//	WSData Descricao	As String OPTIONAL
//	WSData Trace		As String OPTIONAL
//	WSData Loja			As Integer OPTIONAL
//	WSData IPServidor	As String OPTIONAL
//	WSData DataHora		As String OPTIONAL
//	WSData Detalhes		As String
//EndWSStruct

WSStruct tColecaoFechoZ
	WSData aFechoZ 		As Array Of tFechoZ
EndWSStruct

WSStruct tFechoZ
	WSData DataMovimento			As String OPTIONAL
	WSData CodigoLoja				As Integer OPTIONAL
	WSData NumeroTerminal			As Integer OPTIONAL
	WSData ContadorReinicio			As Integer OPTIONAL
	WSData COOAbertura				As Integer OPTIONAL
	WSData COOFechoZ				As Integer OPTIONAL
	WSData ValPisCofinsZero			As Integer OPTIONAL
	WSData GTVendaInicial			As Integer OPTIONAL
	WSData GTVendaFinal				As Integer OPTIONAL
	WSData GTCancelamentoFinal		As Integer OPTIONAL
	WSData GTDescontoFinal			As Integer OPTIONAL
	WSData ClientesHierarquia		As Array Of tClientesHierarquia OPTIONAL
	WSData DadosPorSecao			As Array Of tDadosPorSecao OPTIONAL
	WSData NumUni					As String OPTIONAL
	WSData Cancelamentos			As Integer
	WSData Descontos				As Integer
EndWSStruct

WSStruct tClientesHierarquia
	WSData CodigoElemento			As Integer OPTIONAL
	WSData QtdeClientes				As Integer OPTIONAL
EndWSStruct

WSStruct tDadosPorSecao
	WSData CodigoSecao				As Integer OPTIONAL
	WSData QtdeItemVenda			As Integer OPTIONAL
	WSData ValorVenda				As Integer OPTIONAL
	WSData QtdItemCancelado			As Integer OPTIONAL
	WSData ValorCancelado			As Integer OPTIONAL
	WSData QtdItemAnulado			As Integer OPTIONAL
	WSData ValorAnulado				As Integer OPTIONAL
	WSData ValorCusto				As Integer OPTIONAL
	WSData ValorDesconto			As Integer OPTIONAL
	WSData ValorICMS				As Integer OPTIONAL
	WSData ValorISS					As Integer OPTIONAL
	WSData ValorPisCofinsZero		As Integer OPTIONAL
EndWSStruct

WSStruct tColecaoDevolucaoVenda
	WSData DevolucaoVenda			As Array Of tDevolucaoVenda
EndWSStruct

WSStruct tDevolucaoVenda
	WSData DataDevolucao			As String OPTIONAL
	WSData Loja						As Integer OPTIONAL
	WSData CodTipoDevolucao			As String OPTIONAL
	WSData NumeroComprovante		As Integer OPTIONAL
	WSData DataCupomVenda			As String OPTIONAL
	WSData LojaCupomVenda			As Integer OPTIONAL
	WSData NumeroTerminalVenda		As Integer OPTIONAL
	WSData COOCupomVenda			As Integer OPTIONAL
	WSData ItensDevolvidoas			As Array Of tItensDevolvidos OPTIONAL
EndWSStruct

WSStruct tItensDevolvidos
	WSData NumeroItem				As Integer OPTIONAL
	WSData CodInternoProduto		As Integer OPTIONAL
	WSData CodigoVenda				As String OPTIONAL
	WSData CodigoSecao				As Integer OPTIONAL
	WSData QtdItem					As Integer OPTIONAL
	WSData PrecoUnitario			As Integer OPTIONAL
	WSData TotalItem				As Integer OPTIONAL
	WSData ValorCusto				As Integer OPTIONAL
	WSData ValorDesconto			As Integer OPTIONAL
	WSData CodTributacao			As Integer OPTIONAL
	WSData LegendaTributacao		As String OPTIONAL
	WSData AliquotaTributacao		As Integer OPTIONAL
	WSData Vendedor					As Integer OPTIONAL
	WSData Reserva					As Integer OPTIONAL
EndWSStruct