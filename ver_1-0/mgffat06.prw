#Include "Protheus.ch"
#Include "topconn.ch"

/*
=====================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade         
Data................: 04/10/2016 
Descricao / Objetivo: Aplicar desconconto progressivo no pedido de venda
Doc. Origem.........: Contrato - GAP MGFFAT05
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function MGFFAT06(xProduto, xTab, xValor, xQtde)
	Local aArea			:= GetArea()
	Local nPosPROD		:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_PRODUTO"	})
	Local nPosQTDE		:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_QTDVEN"		})     
	Local nPosPrcUnit	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_PRCVEN"		})     
	Local nPosTotal		:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_VALOR"		})     
	Local nPosPerDesc	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_DESCONT"	})      
	Local nPosValDesc	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_VALDESC"	})      
	Local nPosPrcList	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_PRUNIT"		})              
	Local nTotItem		:= Len(aCols)
    Local cEspeciePed  	:= SuperGetMV("MGF_FAT16F",.F.,'TP|EX|TI|DV|RB|MI|IM|TE')  //Codigos da especie de pedido que nao passar�o pela regra
	Local lEspecie		:= !(M->C5_ZTIPPED $ cEspeciePed) //.T.
	Local nDescProg 	:= 0
	Local nValProd		:= 0
	Local nQdtSKU		:= 0 
	Local nVolume		:= 0  
	Local cNumPed		:= SC5->C5_NUM
	Local nxcont		:= 0
	Local lDesP			:= .T.
	Local lRet			:= .T.
	Local lContinua		:= .T.


	DEFAULT xQtde		:= 1                                                               
	
	If IsInCallStack("EECFATCP") .OR. !Empty(alltrim(SC5->C5_PEDEXP)) .OR. IsInCallStack("U_MGFEEC24") .OR. u_IsExport(SC5->C5_NUM)
		lContinua := .F.
	Endif	
	
	nUsado2 := Len(aHeader)                                       

	// rotina especifica de transferencia entre filiais nao deve avaliar as regras
	If IsInCallStack("U_MGFEST01")
		lContinua := .F.
	Endif	
	
	// pedidos do EEC nao deve avaliar as regras
	If IsInCallStack("EECAP100")
		lContinua := .F.
	Endif	
	
	// rotina especifica de copia de pedidos
	If IsInCallStack("U_TSTCOPIA")
		lContinua := .F.
	Endif	
	
	// inclusao de Carga Taura
	If IsInCallStack("GravarCarga") .or. IsInCallStack("U_TAS02EECPA100") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("U_xGravarCarga") .or. IsInCallStack("U_xTAS02EECPA100") 
		lContinua := .F.
	Endif	

	// rotina de exclusao de nota de saida, desfaz fis45
	If (IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
		lContinua := .F.
	Endif	

	If Alltrim(M->C5_TIPO) == "N" .AND. lEspecie .AND. M->C5_TIPOCLI <> 'X'

		//------------------------------------------------------------
		//Verificar se o Pedido tem que aplicar o desconto progressivo
		//------------------------------------------------------------
		/*For nCont := 1 to nTotItem
		If !aCols[nCont,nUsado2+1]
		If aCols[nCont,nPosPerDesc] > 0 
		lRet	:= .F.
		EndIf
		EndIf
		Next*/                             
		//------------------------------------------------------------------------------	
		//Busca a quantidade de SKU e VOLUME do pedido
		//------------------------------------------------------------------------------			
		u_T06SKU(cNumPed, @nQdtSKU, @nVolume)    
		 

		//------------------------------------------------------------------------------	
		//Busca o % de maior desconto progressivo, por quantidade de SKU ou por Volume
		//------------------------------------------------------------------------------	



		nDescProg	:= u_T06DESC(SC5->C5_TABELA, nQdtSKU, nVolume)     

		For nCont := 1 to nTotItem
			If !aCols[nCont,nUsado2+1]
				If aCols[nCont,nPosPrcUnit] <> aCols[nCont,nPosPrcList]//round(xValProd(aCols[nCont,nPosPROD],nDescProg,SC5->C5_TABELA),6) 
					lRet	:= .F.
					Exit
				EndIf
			EndIf
		Next

		If lRet 

			If nDescProg > 0 
				
				lRet := APMsgYesNo("Deseja Aplicar o Desconto Progressivo da Tabela de Preco neste pedido?")
				
				lDesP := .T.

				/*For nCont := 1 to nTotItem
					If !aCols[nCont,nUsado2+1]
						if chkSZL( SC5->C5_TABELA, aCols[nCont, nPosQTDE] ) .and. ACOLS[nCont][6] == ACOLS[nCont][7]
							lDesP := .T.
						endif
					EndIf
				Next

				If lDesP*/
				
				
				
				/*EndIf	*/

			If lDesP = .T.	
				If lRet 
					U_T06UPDC6() //Descomentado
					

					//------------------------------------------------------------------------------	
					//Atualiza o Pedido com o desconto progressivo
					//------------------------------------------------------------------------------	
					DbSelectArea("SC6")
					DbSetOrder(1)                       
					If DbSeek(xFilial("SC6") + cNumPed)     	

						/*For nI := 1 TO len(acols)                
						IF SC6->C6_PRCVEN = ACOLS[nI][5]					
						lRet := APMsgYesNo("Deseja Aplicar o Desconto Progressivo da Tabela de Preco neste pedido?")            
						Exit  	
						EndIf
						Next nI*/	 
						If lRet 
							While 	SC6->(!EOF()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM 	== cNumPed

								//nValProd	:= SC6->C6_PRCVEN - (SC6->C6_PRCVEN * (nDescProg/100))
								//nValProd	:= SC6->C6_PRCVEN - (SC6->C6_PRCVEN / ((100-nDescProg)/100))
								//nValProd	:= SC6->C6_PRCVEN / ((100-nDescProg)/100)
								nValProd	:= SC6->C6_PRCVEN * ((100-nDescProg)/100)
								aArea		:= GetArea()
								aAreaC6		:= SC6->(GetArea())
                                
								RecLock("SC6",.F.)
								//							SC6->C6_ZPREORI		:= SC6->C6_PRCVEN voltar
								SC6->C6_PRCVEN		:= 	nValProd	 //Preco de Venda j� com o desconto progressivo
								SC6->C6_VALOR		:=	nValProd * SC6->C6_QTDVEN 	 //Valor Total do Pedido	
								//SC6->C6_PRUNIT		:=	nValProd //Preco de Lista
								SC6->(MsUnlock())

								RestArea(aAreaC6)
								RestArea(aArea)
								SC6->(DbSkip())
							End
						Endif					
					Endif
				ENDIF	
			EndIf	
				//  Next
			EndIf
		Endif
	Endif	
//	RestArea(aAreaC6)
//	RestArea(aArea)

Return                                                                    

/*
=====================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade         
Data................: 04/10/2016 
Descricao / Objetivo: Aplicar desconconto progressivo no pedido de venda
Doc. Origem.........: Contrato - GAP MGFFAT05
Solicitante.........: Cliente
Uso.................: 
Obs.................: Retorna a quantidade de SKU do Pedido para filtro do desconto 
=====================================================================================
*/
User Function T06SKU(xPedido, xQdtSKU, xVolume)
	Local cQuery		:= ""
	Local _cAlias		:= GetNextAlias()

	xQdtSKU	:=0  
	xVolume	:=0     

	cQuery := " SELECT C6_PRODUTO, SUM(C6_QTDVEN) QTDE, COUNT(*) SKU " 
	cQuery += " FROM " + RetSqlName("SC6") + " SC6 "
	cQuery += " WHERE C6_FILIAL = '" 	+xFilial("SC6") + "' " 
	cQuery += " AND C6_NUM = '" 		+xPedido 		+ "' "
	cQuery += " AND SC6.D_E_L_E_T_ <> '*' "
	cQuery += " GROUP BY C6_PRODUTO "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), _cAlias)

	If !(_cAlias)->(Eof()) 
		While (_cAlias)->(!Eof())
			xQdtSKU	+= (_cAlias)->SKU 
			xVolume	+= (_cAlias)->QTDE
			(_cAlias)->(DbSkip())	
		End	
	EndIf

	(_cAlias)->(DbCloseArea())

Return

/*
=====================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade         
Data................: 04/10/2016 
Descricao / Objetivo: Aplicar desconconto progressivo no pedido de venda
Doc. Origem.........: Contrato - GAP MGFFAT05
Solicitante.........: Cliente
Uso.................: 
Obs.................: Retorna a quantidade de SKU do Pedido para filtro do desconto 
=====================================================================================
*/

User Function T06DESC(xTab, nQdtSKU, nVolume)     
	Local aArea			:= GetArea()
	Local cQuery		:= ""
	Local _cAlias		:= GetNextAlias()
	Local nDesc			:= 0                                         
	Local nDescProg		:= 0    
	DEFAULT nQdtSKU		:= 0 
	DEFAULT nVolume 	:= 0	

	cQuery := " SELECT MAX(TABAUX.DESCONTO) AS DESCONTO" 
	cQuery += " FROM "
	cQuery += " ( "

	//------------------------------------------------------
	//Verifica qual � o maior desconto por Volume
	//------------------------------------------------------
	cQuery += " SELECT MAX(ZL_PERDESC) AS DESCONTO " 
	cQuery += " FROM "  + RetSqlName("SZL") + " SZL "                  
	cQuery += " WHERE SZL.ZL_FILIAL = '" 	+ xFilial("SZL") 	+ "' "
	//cQuery += " AND ROWNUM = 1"   		
	cQuery += " AND SZL.ZL_CODTAB = '" 		+ xTab 				+ "' "
	cQuery += " AND SZL.ZL_VOLUME <= " 		+ STR(nVolume) 		//descomentado
//	cQuery += " AND " + STR(nVolume) + " >= SZL.ZL_VOLUME"  
	cQuery += " AND SZL.D_E_L_E_T_ <> '*' "
	//cQuery += " ORDER BY ZL_PERDESC "

	cQuery += " UNION ALL "

	//------------------------------------------------------
	//Verifica qual � o maior desconto por Quantidade
	//------------------------------------------------------	
	cQuery += " SELECT MAX(ZM_PERDESC)  AS DESCONTO " 
	cQuery += " FROM "  + RetSqlName("SZM") + " SZM "
	cQuery += " WHERE SZM.ZM_FILIAL = '" 	+ xFilial("SZM") 	+ "' " 
	//cQuery += " AND ROWNUM = 1"   		
	cQuery += " AND SZM.ZM_CODTAB = '" 		+ xTab 				+ "' " 
	//cQuery += " AND SZM.ZM_QTDE	  <= " 		+ STR(nQdtSKU) 		+ " "//descomentado
	cQuery += " AND SZM.ZM_QTDE <= " +  STR(nQdtSKU)   
	cQuery += " AND SZM.D_E_L_E_T_ <> '*' "
	//cQuery += " ORDER BY ZM_PERDESC "

	cQuery += " ) TABAUX "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), _cAlias)

	If !(_cAlias)->( Eof() )
		nDescProg	:= (_cAlias)->DESCONTO
	Endif

	(_cAlias)->(DbCloseArea())

	RestArea(aArea)   

Return(nDescProg)



/*
=====================================================================================
Programa............: MGFFAT06
Autor...............: Marcos Andrade         
Data................: 04/10/2016 
Descricao / Objetivo: Voltar o preco base dos produtos
Doc. Origem.........: Contrato - GAP MGFFAT05
Solicitante.........: Cliente
Uso.................: 
Obs.................: Gravar o valor de tabela dos produtos na alteracao
=====================================================================================
*/

User Function T06UPDC6(xOpc)
	Local aArea			:= GetArea()
	Local _cAlias		:= GetNextAlias()
	Local _cAlias2		:= GetNextAlias()
	Local lRet			:= .T.
	Local nPreco		:= 0
	Local nValProd		:= 0                           
	Local nAcres		:= 0
	Local nReg			:= SC5->(Recno())
	

	If xOpc == 4 .and. !IsInCallStack("EECFATCP") .AND. Empty(alltrim(SC5->C5_PEDEXP))	.AND. IsInCallStack("U_MGFEEC24")//Alteracao

		//------------------------------------------------------
		//Se tiver desconto manual nao atualiza o pedido
		//------------------------------------------------------	
		cQuery := " SELECT SUM(C6_DESCONT) DESCONTO " 
		cQuery += " FROM "  + RetSqlName("SC6") + " SC6 "
		cQuery += " WHERE SC6.C6_FILIAL = '" 	+ xFilial("SC6") 	+ "' " 
		cQuery += " AND SC6.C6_NUM = '" 		+ SC5->C5_NUM		+ "' " 
		cQuery += " AND SC6.D_E_L_E_T_ <> '*' "

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), _cAlias)

		If !(_cAlias)->( Eof() )	
			If (_cAlias)->DESCONTO > 0
				lRet:= .F.
			Endif
		Endif
		If lRet
			//------------------------------------------------------------------------------
			//Busca o maior desconto para jogar como acrescimo
			//------------------------------------------------------------------------------		
			nAcres	:= u_T05Preco(SC5->C5_TABELA)

			//------------------------------------------------------
			//Se tiver desconto manual nao atualiza o pedido
			//------------------------------------------------------	
			cQuery := " SELECT C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO " 
			cQuery += " FROM "  + RetSqlName("SC6") + " SC6 "
			cQuery += " WHERE SC6.C6_FILIAL = '" 	+ xFilial("SC6") 	+ "' " 
			cQuery += " AND SC6.C6_NUM = '" 		+ SC5->C5_NUM		+ "' " 
			cQuery += " AND SC6.D_E_L_E_T_ <> '*' "

			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), _cAlias2)

			//----------------------------------------------------------------------------------------------------	
			//Atualiza o Pedido com acrescimo do maior desconto progressivo
			//----------------------------------------------------------------------------------------------------	

			(_cAlias2)->(DbGotop())
			//If !(_cAlias2)->(Eof()) 
			While (_cAlias2)->(!Eof())	    

				DbSelectArea("SC6")
				DbSetOrder(1)                       
				If DbSeek((_cAlias2)->C6_FILIAL + (_cAlias2)->C6_NUM + (_cAlias2)->C6_ITEM + (_cAlias2)->C6_PRODUTO )     	
					//----------------------------------------------------------------------------------------	
					//Atualiza o Pedido com acrescimo do maior desconto progressivo
					//----------------------------------------------------------------------------------------					        

					DbSelectArea("DA1")
					DbSetOrder(1) 
					If DbSeek(xFilial("DA1")+SC5->C5_TABELA+SC6->C6_PRODUTO)
						//nPreco 		:= DA1->DA1_PRCVEN + (DA1->DA1_PRCVEN * (nAcres/100))
						nPreco 		:= DA1->DA1_PRCVEN / ((100-nAcres)/100)  			              	            		
						RecLock("SC6",.F.)
						SC6->C6_ZPREORI		:=  nPreco 
						SC6->C6_PRCVEN		:= 	nPreco						//Preco de Venda j� com o desconto progressivo
						SC6->C6_ZTABELA 	:= 	SC5->C5_TABELA
						SC6->C6_VALOR		:=	nPreco * SC6->C6_QTDVEN		//Valor Total do Pedido	
						SC6->C6_PRUNIT		:=	nPreco               		//Preco de Lista
						SC6->(MsUnlock())             
					Endif			
				Endif 
				(_cAlias2)->(DbSkip())
			End
			//Endif
		Endif
	Endif        
	DbCloseArea(_cAlias)
	DbCloseArea(_cAlias2)

	RestArea(aArea)     

	SC5->(DbGoto(nReg))

Return(.T.)


/*
=====================================================================================
Programa............: MGFFAT06
Autor...............: Marcos Andrade         
Data................: 04/10/2016 
Descricao / Objetivo: 
Doc. Origem.........: Contrato - GAP MGFFAT05
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/

User Function T06Altera()
	Local aArea			:= GetArea()
	Local nPosProd		:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_PRODUTO"		})     
	Local nPosQTDE		:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_QTDVEN"		})     
	Local nPosPrcUnit	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_PRCVEN"		})     
	Local nPosTotal		:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_VALOR"		})     
	Local nPosPerDesc	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_DESCONT"	})      
	Local nPosValDesc	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_VALDESC"	})      
	Local nPosPrcList	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_PRUNIT"		})              
	Local nTotItem		:= Len(aCols)
    Local cEspeciePed  	:= SuperGetMV("MGF_FAT16F",.F.,'TP|EX|TI|DV|RB|MI|IM|TE')  //Codigos da especie de pedido que nao passar�o pela regra
	Local lEspecie		:= !(M->C5_ZTIPPED $ cEspeciePed) //.T.
	Local nDescProg 	:= 0
	Local nValProd		:= 0
	Local nQdtSKU		:= 0 
	Local nVolume		:= 0  
	Local cNumPed		:= SC5->C5_NUM
	Local lRet			:= .T.
	Local nBack			:= n                                       

	DEFAULT xQtde		:= 1                                                               


	If M->C5_TIPO <> "N" .OR. !lEspecie .OR. M->C5_TIPOCLI == 'X'
		Return(lRet)
	Endif

	nUsado2 := Len(aHeader)

	//-----------------------------------------------------------------------
	//Verificar se o Pedido tem que aplicar o desconto progressivo
	//-----------------------------------------------------------------------
	For nCont := 1 to nTotItem
		If !aCols[nCont,nUsado2+1] 
			n := nCont
			If !Empty(aCols[nCont,nPosProd])

				U_T05Desconto(	aCols[nCont,nPosProd]	,;	//Produto 
				M->C5_TABELA			,;	//Tabela de Preco 
				aCols[nCont,nPosPrcUnit],;	//Preco Unitario 
				aCols[nCont,nPosQTDE]	,;	//Quantidade
				.T.						,;	//Identifica que � alteracao
				nCont					)	//Numero da Linha			
			EndIf
		Endif
	Next    

	//-----------------------------------------------------------------------
	//Atualiza o rodape do titulo
	//-----------------------------------------------------------------------
	n	:= nBack
	Ma410Rodap()

Return(lRet)

/*
=====================================================================================
Programa............: T06Valid
Autor...............: Marcos Andrade         
Data................: 29/09/2016 
Descricao / Objetivo: Busca tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT06
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/

User Function T06Valid(xTab, xProduto, lAteracao)
	Local nPreco		:= 0
	Local lRet			:= .T.                          
	DEFAULT lAlteracao	:= .F.

	If !Empty(xTab+xProduto)
		DbSelectArea("DA1")
		DbSetOrder(1) 
		If DbSeek(xFilial("DA1")+xTab+xProduto)
			nPreco := DA1->DA1_PRCVEN
		Else      
			nPreco	:= 0
			lRet	:= .F.		
			If !Alteracao
				APMsgInfo("Produto nao encontrado na tabela de preco informada!","Atencao")
			Endif
		Endif
	Endif

Return(lRet)



User Function FAT06LIOK()
	Local lRet	:= .T.

Return(lRet)

/*
|
|
*/
Static Function xValProd(cProd,nPerc,xTab)

	Local aArea     := GetArea()
	Local aAreaDA1  := DA1->(GetArea()) 
	Local nPreco	:= 0

	DbSelectArea("DA1")
	DbSetOrder(1) 
	If DbSeek(xFilial("DA1")+xTab+cProd)
		nPreco 		:= DA1->DA1_PRCVEN / ((100-nPerc)/100)  			              	            		
	Endif

	RestArea(aAreaDA1)
	RestArea(aArea)

Return nPreco

//-------------------------------------------------------
// Verifica se o item atingiu a faixa de desconto
//-------------------------------------------------------
static function chkSZL( cTab, nVol )
	local lRet		:= .F.
	local cQrySZL	:= ""

	cQrySZL := " SELECT ZL_VOLUME, ZL_PERDESC "
	cQrySZL += " FROM " + RetSQLName("SZL") + " SZL  "
	cQrySZL += " WHERE
	cQrySZL += " 		SZL.ZL_FILIAL					=	'" + xFilial("SZL")			+ "' " 
	cQrySZL += " 	AND	" + allTrim( str( nVol ) )	+ " >= SZL.ZL_VOLUME"
	cQrySZL += " 	AND	SZL.ZL_CODTAB					=	'" + cTab					+ "' " 
	cQrySZL += " 	AND	SZL.D_E_L_E_T_					=	' ' "
	//cQrySZL += " ORDER BY SZL.ZL_VOLUME "

	cQrySZL := ChangeQuery(cQrySZL)

	TcQuery cQrySZL New Alias "QRYSZL"

	if !QRYSZL->(EOF())
		lRet := .T.
	endif

	QRYSZL->(DBCloseArea())
return lRet