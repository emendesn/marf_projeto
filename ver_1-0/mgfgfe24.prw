#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFFAT44
Autor....:              Flavio Dentello
Data.....:              19/01/2018
Descricao / Objetivo:   Integração Trecho de itinerário
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS Server para trecho de transpote
Componentes da integração:
=====================================================================================
*/

// Movimentos de Produção - Estrutura de dados. Retorno de RCTRC
WSSTRUCT MGFGFE24RequisItiner
	WSDATA Filial  				AS string
	WSDATA NumeroOrdemEmbarque 	AS string
	WSDATA CodigoCidadeOrigem	AS string
	WSDATA CodigoCidadeDestino	AS string 
	WSDATA PlacaVeiculoTracao	AS string 
	WSDATA PlacaVeiculoReboque	AS string 
	WSDATA CodigoTransportadora	AS string 
	WSDATA NomeMotorista		AS string 
	WSDATA CPFMotorista			AS string 
	WSDATA KmRodado				AS string 
	WSDATA GrupoSeparacao		AS array of GFE24Grupo
ENDWSSTRUCT

WSSTRUCT GFE24Grupo
	WSDATA CodigoCidadeOrigem 	AS string
	WSDATA CodigoCidadeDestino	AS string
	WSDATA PlacaVeiculoTracao	AS string 
	WSDATA PlacaVeiculoReboque	AS string 
	WSDATA CodigoTransportadora	AS string 
	WSDATA NomeMotorista		AS string 
	WSDATA CPFMotorista			AS string 
	WSDATA KmRodado				AS string
	WSDATA Pedido				AS array of GFE24Pedido   
ENDWSSTRUCT

WSSTRUCT GFE24Pedido
	WSDATA NumeroPedido  		AS string
	WSDATA NumeroNotaFiscal 	AS string
	WSDATA SerieNotaFiscal		AS string  
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados.  Retorno de RCTRC
WSSTRUCT MGFGFE24RetornoItiner
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Itinerário.				                       *
***************************************************************************/
WSSERVICE MGFGFE24 DESCRIPTION "Integração Itinerário" NameSpace "http://totvs.com.br/MGFGFE24.apw"

	// Passagem dos parâmetros de entrada. Bloqueio de Estoque
	WSDATA MGFGFE24ReqItiner AS MGFGFE24RequisItiner
	// Estoque - Retorno (array). Bloqueio de Estoque
	WSDATA MGFGFE24RetItiner AS MGFGFE24RetornoItiner

	WSMETHOD RetornoItiner DESCRIPTION "Integração Itinerário"

ENDWSSERVICE

/************************************************************************************
** Grava dados de retorno da integração Itinerário
************************************************************************************/
WSMETHOD RetornoItiner WSRECEIVE	MGFGFE24ReqItiner WSSEND MGFGFE24RetItiner WSSERVICE MGFGFE24

	Local cOrdem	 := ""
	Local nOE		 := 0
	Local nPed		 := 0
	Local nPedGRP	 := 0
	Local nPesoGrp	 := 0
	Local cCiddest	 := ""
	Local cTPVEIC	 := ""
	Local cAlias1	 := ""
	Local cAlias2	 := ""
	Local cAlias3	 := ""
	Local aRet		 := {}
	Local cPeso		 := ""
	Local cQuery	 := ""
	Local lFor		 := .T.
	Local lReturn	 := .T.
	Local cCodTaura := ""

	//tratamentos de gravação
	cOrdem := ::MGFGFE24ReqItiner:NumeroOrdemEmbarque
	cOrdem := Stuff( Space( TamSX3("DAK_COD ")[1] ) , 1 , Len(AllTrim(cOrdem)) , AllTrim(cOrdem) )+"01" 	

	GWN->(DbSelectArea('GWN'))
	GWN->(DbSetOrder(1)) 
	If GWN->(dbSeek(SELF:MGFGFE24ReqItiner:FILIAL + cOrdem ))
		
		cTPVEIC := GWN->GWN_CDTPVC
		/*
		cAlias1	:= GetNextAlias()

		cQuery := " SELECT SUM(GW8_PESOR) PESO "
		cQuery += " FROM " +RetSqlName("GWN") + " GWN " +", " +RetSqlName("GW1") + " GW1 " + ", " +RetSqlName("GW8") + " GW8 "
		cQuery += " WHERE GWN.GWN_FILIAL = '" + self:MGFGFE24ReqItiner:filial + "' "
		cQuery += " AND GW1.GW1_FILIAL = GWN.GWN_FILIAL "
		cQuery += " AND GW8.GW8_FILIAL = GWN.GWN_FILIAL "
		cQuery += " AND GWN.GWN_NRROM = '" + GWN->GWN_NRROM + "'
		cQuery += " AND GWN.GWN_NRROM = GW1.GW1_NRROM "
		cQuery += " AND GW1.GW1_NRDC = GW8.GW8_NRDC "
		cQuery += " AND GW1.GW1_SERDC = GW8.GW8_SERDC "
		cQuery += " AND GW1.GW1_CDTPDC = GW8.GW8_CDTPDC "
		cQuery += " AND GW1.GW1_EMISDC = GW8.GW8_EMISDC "
		cQuery += " AND GWN.D_E_L_E_T_=''
		cQuery += " AND GW1.D_E_L_E_T_=''
		cQuery += " AND GW8.D_E_L_E_T_=''

		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

		cPeso := (cAlias1)->PESO
		*/
		
		If !empty(cOrdem)

			/// Verifica os Grupos de Separação nOE
			For nOE := 1 to len(self:MGFGFE24ReqItiner:gruposeparacao) //.AND. lFor

				If lFor
					If len(self:MGFGFE24ReqItiner:gruposeparacao) <= 1
						lFor := .F.
					EndIf	

					/// Verifica as Notas da Ordem de Separação nPed
					nPedGRP := 0
					nPesoGrp := 0
					For nPed := 1 to len(self:MGFGFE24ReqItiner:gruposeparacao[nOE]:PEDIDO)

						GW1->(DbSelectArea('GW1'))
						GW1->(DbSetOrder(11)) //GW1_FILIAL+GW1_SERDC+GW1_NRDC
						If GW1->(dbSeek(self:MGFGFE24ReqItiner:filial + STRZERO(VAL(self:MGFGFE24ReqItiner:gruposeparacao[nOE]:pedido[nPed]:SERIENOTAFISCAL),3) + STRZERO(VAL(self:MGFGFE24ReqItiner:gruposeparacao[nOE]:pedido[nPed]:NUMERONOTAFISCAL),9)  ))

							GWU->(DbSelectArea('GWU'))
							GWU->(DbSetOrder(1)) //GWU_FILIAL+GWU_CDTPDC+GWU_EMISDC+GWU_SERDC+GWU_NRDC+GWU_SEQ
							If GWU->(dbSeek(GW1->GW1_FILIAL + GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC + "01" ))
								cCiddest := GWU->GWU_NRCIDD 
								cCodTaura := self:MGFGFE24ReqItiner:gruposeparacao[nOE]:CODIGOTRANSPORTADORA
								cTransp := xTransp(cCodTaura)

								GU3->(DbSelectArea('GU3'))
								GU3->(DbSetOrder(1)) //GU3_FILIAL+GU3_CDEMIT
								//If GU3->(dbSeek(XFILIAL("GU3") + self:MGFGFE24ReqItiner:gruposeparacao[nOE]:CODIGOTRANSPORTADORA ))
								//If GU3->(dbSeek(XFILIAL("GU3") + GW1->GW1_CDDEST ))
								If GU3->(dbSeek(XFILIAL("GU3") + cTransp ))

									DA3->(DbSelectArea('DA3'))
									DA3->(DbSetOrder(3)) //DA3_FILIAL+DA3_PLACA
									
									cPlaca := AllTrim(self:MGFGFE24ReqItiner:gruposeparacao[nOE]:PlacaVeiculoTracao)
									cPlaca := Stuff( Space( TamSX3("DA3_PLACA ")[1] ) , 1 , Len(cPlaca) , cPlaca )
										 
									If DA3->( dbSeek(XFILIAL("DA3") + cPlaca ))


										GWU->(DbSelectArea('GWU'))
										GWU->(DbSetOrder(1)) //GWU_FILIAL+GWU_CDTPDC+GWU_EMISDC+GWU_SERDC+GWU_NRDC+GWU_SEQ	 
										If !GWU->(dbSeek(SELF:MGFGFE24ReqItiner:FILIAL + GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC + '02' ))
											
											nPedGRP := 0
											nPesoGrp := 0
											
											For nPedGRP := 1 to len(self:MGFGFE24ReqItiner:gruposeparacao[nOE]:PEDIDO)

												cAlias3	:= GetNextAlias()
	
												cQuery := " SELECT SUM(GW8_PESOR) PESO "
												cQuery += " FROM " +RetSqlName("GWN") + " GWN " +", " +RetSqlName("GW1") + " GW1 " + ", " +RetSqlName("GW8") + " GW8 "
												cQuery += " WHERE GWN.GWN_FILIAL = '" + self:MGFGFE24ReqItiner:filial + "' "
												cQuery += " AND GW1.GW1_FILIAL = GWN.GWN_FILIAL "
												cQuery += " AND GW8.GW8_FILIAL = GWN.GWN_FILIAL "
												cQuery += " AND GWN.GWN_NRROM = '" + GWN->GWN_NRROM + "'
												cQuery += " AND GW1.GW1_NRDC = '"   + STRZERO(VAL(self:MGFGFE24ReqItiner:gruposeparacao[nOE]:pedido[nPedGRP]:NUMERONOTAFISCAL),9)+ "'
												cQuery += " AND GW1.GW1_SERDC = '"  + STRZERO(VAL(self:MGFGFE24ReqItiner:gruposeparacao[nOE]:pedido[nPedGRP]:SERIENOTAFISCAL) ,3) + "'
												cQuery += " AND GW1.GW1_CDTPDC = '" + GW1->GW1_CDTPDC + "'
												cQuery += " AND GWN.GWN_NRROM = GW1.GW1_NRROM "
												cQuery += " AND GW1.GW1_NRDC = GW8.GW8_NRDC "
												cQuery += " AND GW1.GW1_SERDC = GW8.GW8_SERDC "
												cQuery += " AND GW1.GW1_CDTPDC = GW8.GW8_CDTPDC "
												cQuery += " AND GW1.GW1_EMISDC = GW8.GW8_EMISDC "
												cQuery += " AND GWN.D_E_L_E_T_=''
												cQuery += " AND GW1.D_E_L_E_T_=''
												cQuery += " AND GW8.D_E_L_E_T_=''
	
												cQuery := ChangeQuery(cQuery)
												DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias3, .F., .T.)
											
												If (cAlias3)->(!eof())
													nPesoGrp += (cAlias3)->PESO
												EndIf
											Next


											cAlias2	:= GetNextAlias()

											cQuery := " SELECT SUM(GW8_PESOR) PESO "
											cQuery += " FROM " +RetSqlName("GWN") + " GWN " +", " +RetSqlName("GW1") + " GW1 " + ", " +RetSqlName("GW8") + " GW8 "
											cQuery += " WHERE GWN.GWN_FILIAL = '" + self:MGFGFE24ReqItiner:filial + "' "
											cQuery += " AND GW1.GW1_FILIAL = GWN.GWN_FILIAL "
											cQuery += " AND GW8.GW8_FILIAL = GWN.GWN_FILIAL "
											cQuery += " AND GWN.GWN_NRROM = '" + GWN->GWN_NRROM + "'
											cQuery += " AND GW1.GW1_NRDC = '" + GW1->GW1_NRDC + "'
											cQuery += " AND GW1.GW1_SERDC = '" + GW1->GW1_SERDC + "'
											cQuery += " AND GW1.GW1_CDTPDC = '" + GW1->GW1_CDTPDC + "'
											cQuery += " AND GWN.GWN_NRROM = GW1.GW1_NRROM "
											cQuery += " AND GW1.GW1_NRDC = GW8.GW8_NRDC "
											cQuery += " AND GW1.GW1_SERDC = GW8.GW8_SERDC "
											cQuery += " AND GW1.GW1_CDTPDC = GW8.GW8_CDTPDC "
											cQuery += " AND GW1.GW1_EMISDC = GW8.GW8_EMISDC "
											cQuery += " AND GWN.D_E_L_E_T_=''
											cQuery += " AND GW1.D_E_L_E_T_=''
											cQuery += " AND GW8.D_E_L_E_T_=''

											cQuery := ChangeQuery(cQuery)
											DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias2, .F., .T.)

											/// Altera cidade do primeiro trecho
											GWU->(DbSelectArea('GWU'))
											GWU->(DbSetOrder(1)) //GWU_FILIAL+GWU_CDTPDC+GWU_EMISDC+GWU_SERDC+GWU_NRDC+GWU_SEQ	 
											GWU->(dbSeek(SELF:MGFGFE24ReqItiner:FILIAL + GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC + '01' ))

								 			if empty(cTPVEIC)
												
												cTPVEIC := xGettpv()

											endif

											RecLock('GWU',.F.)
											GWU->GWU_NRCIDD := self:MGFGFE24ReqItiner:gruposeparacao[nOE]:CodigoCidadeOrigem
											GWU->GWU_CDTPVC := cTPVEIC // PALIATIVO
											GWU->(MsUnlock())

											//Cria segundo trecho de transporte
											RecLock('GWU',.T.)
											GWU->GWU_FILIAL := GW1->GW1_FILIAL 
											GWU->GWU_CDTPDC := GW1->GW1_CDTPDC 
											GWU->GWU_EMISDC := GW1->GW1_EMISDC 
											GWU->GWU_SEQ 	:= "02" 
											GWU->GWU_SERDC 	:= GW1->GW1_SERDC 	 
											GWU->GWU_NRDC 	:= GW1->GW1_NRDC 	 
											GWU->GWU_CDTRP 	:= cTransp
											GWU->GWU_NRCIDD := cCiddest
											GWU->GWU_CDTPVC := IIF(Empty(DA3->DA3_TIPVEI),GetAdvFVal("DA3","DA3_TIPVEI",xFilial("DA3")+cPlaca,3,""),DA3->DA3_TIPVEI)
											GWU->GWU_PAGAR 	:= "1" 
											GWU->GWU_SDOC 	:= GW1->GW1_SERDC
											GWU->GWU_ZORDEM := alltrim(str(nOE))//self:MGFGFE24ReqItiner:gruposeparacao[nOE] 
											GWU->GWU_ZKM2TR := val(self:MGFGFE24ReqItiner:gruposeparacao[nOE]:KmRodado) / nPesoGrp * (cAlias2)->PESO
											GWU->GWU_NRCIDO := self:MGFGFE24ReqItiner:gruposeparacao[nOE]:CodigoCidadeOrigem //GU3->GU3_NRCID // 30/07/18, gravado como cidade de origem a cidade da transportadora, pois se campo ficar em branco ocorre erro no padrao do mata521, ao se excluir a nota de saida
											 
											GWU->(MsUnlock())
											
											aRet := {"1", "Processado!"}
											
											RecLock('GWN',.F.)
											GWN->GWN_CDTPVC := " "
											GWN->(MsUnlock())
											
										Else
											//aRet := {"0", "Nota já possui segundo trecho de Transporte!"}
											aRet := {"1", "Processado!"}
										EndIf
									Else
										aRet := {"0", "Veículo não encontrado!"}
									EndIf
								Else
									aRet := {"0", "Transportador não encontrado!"}
								EndIf
							Else
								aRet := {"0", "Nota sem trecho de Transporte!"}
							EndIf
						Else
							aRet := {"0", "Nota não encontrada!"}
						EndIf	
					Next
				EndIf
			Next
		Else
			aRet := {"0", "Ordem de Embarque Inválida!"}
		EndIf	
	Else
		aRet := {"0", "Ordem de Embarque Inválida!"}
	EndIf

	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFGFE24RetItiner :=  WSClassNew( "MGFGFE24RetornoItiner" )
	::MGFGFE24RetItiner:STATUS	:= aRet[1]
	::MGFGFE24RetItiner:MSG		:= aRet[2]
	
	// executa rotina para calculo da regra de operacao e calculo do romaneio do frete
	If Len(aRet) > 0 .and. aRet[1] == "1"
		StartJob("U_MGFGFE36",GetEnvServer(),.F.,::MGFGFE24ReqItiner:FILIAL,::MGFGFE24ReqItiner:NumeroOrdemEmbarque)
	Endif	

	//::MGFFAT44ReqRCTRC := Nil
	//DelClassINTF()

Return lReturn

////Retorna CNPJ da Transportadora

Static Function xTransp(cCodTaura)

	Local cCNPJ := ""

	Local cQuery 	:= ""
	Local cAliasSA4 := ""
	Local cAliasSA41 := ""
	Local aArea		:= GetArea()
	
	//conout('[MGFGFE24] - Inclusão de Trechos de Transporte' )
	//conout('codigo Transportadora' + 'Cod Taura' + cCodTaura )
	cAliasSA4 := GetNextAlias()	

	cQuery := " SELECT A4_CGC FROM "
	cQuery +=  RetSqlName("SA4")+" SA4 "
	cQuery += " WHERE A4_ZCODMGF = '" + Alltrim(cCodTaura) + "'"
	cQuery += " AND SA4.D_E_L_E_T_ <> '*' "

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSA4, .F., .T.)

	If (cAliasSA4)->(!eof())

		cCNPJ := (cAliasSA4)->A4_CGC
		//conout('codigo Transportadora' + 'Cod Protheus' + cCNPJ )

	Else // cCodTaura = CNPJ

		// pesquisa por cod. da transportadora	
		cAliasSA41 := GetNextAlias()	

		cQuery := " SELECT A4_CGC FROM "
		cQuery +=  RetSqlName("SA4")+" SA4 "
		cQuery += " WHERE A4_COD = '" + Alltrim(cCodTaura) + "'"
		cQuery += " AND SA4.D_E_L_E_T_ <> '*' "
	
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSA41, .F., .T.)
	
		If (cAliasSA41)->(!eof())
			cCNPJ := (cAliasSA41)->A4_CGC
		Else
			cCNPJ	:= Stuff( Space( TamSX3("A4_CGC")[1] ) , 1 , Len(AllTrim(cCodTaura)) , AllTrim(cCodTaura) )
		
			If cCNPJ # GetAdvFVal("SA4","A4_CGC",xFilial("SA4")+cCNPJ,3,"")
		
				cCNPJ	:= ""
			
			EndIf 
		Endif	
		(cAliasSA41)->(dbCloseArea())
	EndIf
	
	dbSelectArea(cAliasSA4)
	(cAliasSA4)->(dbCloseArea())

	RestArea( aArea )
	
Return cCNPJ

//-------------------------------------------------------------------
//-------------------------------------------------------------------
Static function xGettpv()

	local cQuery    := ""
	local cTipveic  := ""
	Local cAliasGWU := ""	
	
	cAliasGWU := GetNextAlias()	
	
	cQuery := "SELECT GWU_CDTPVC "
	cQuery += " FROM " + RetSqlName("GW1") + " GW1"
	cQuery += " INNER JOIN " + RetSqlName("GWU") + " GWU" + " ON GWU.D_E_L_E_T_= ' '"
	
	cQuery += "  AND GW1.GW1_EMISDC	=	GWU.GWU_EMISDC "
	cQuery += "  AND GW1.GW1_SERDC	=	GWU.GWU_SERDC  "
	cQuery += "	 AND	GW1.GW1_NRDC	=	GWU.GWU_NRDC "	 
	cQuery += "	 AND GW1.GW1_FILIAL	=	GWU.GWU_FILIAL   "	 
	cQuery += "	 AND GW1_NRROM		=	'" + GW1->GW1_NRROM	+ "'"
	cQuery += "	 AND GWU_SEQ		=	'01' "
	cQuery += "	 AND GWU_CDTPVC		<>	' ' "
	
	
	cQuery += "	WHERE GW1.D_E_L_E_T_	<>	'*'"

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasGWU, .F., .T.)
	
	If (cAliasGWU)->(!eof())
		cTipveic := (cAliasGWU)->GWU_CDTPVC
	Endif
	
return cTipveic