#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

static _aErr

user function MGFFAT74(cProduto,cTabprec,nLin,nQtde,cCliente,cLoja,cLoteCtl,cNumLote,lLote,lExecb,lPrcTab,cOpcional)

Local aArea     := GetArea()
Local aContrato := {}
Local aOpcional := {}

Local cOpc      := ""
Local cGrade	:= ""
Local cPoder3   := ""
Local cAliasADA := "ADA"
Local cAliasADB := "ADB"

Local nPrcVen	:=0
Local lOpcPadrao:= SuperGetMv("MV_REPGOPC",.F.,"N") == "N"
Local nPosOpc   := aScan(aHeader,{|x| AllTrim(x[2])==IIf(lOpcPadrao,"C6_OPC","C6_MOPC")})
Local nPosTes   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPItem    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local nPContrat := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CONTRAT"})
Local nPItemCon := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMCON"})
Local nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nX        := 0
Local nY        := 0
Local nAux		:= 0
Local nUsado    := Len(aHeader)
Local nFator    := 1
Local nZ        := 0
Local lGrade	:= MaGrade()
Local lRet  	:= .T.
Local lValido   := .F.
Local lContrat  := SuperGetMV("MV_PRCCTR")
Local lPrcPod3  := ( GetNewPar( "MV_PRCPOD3", "1" ) == "2" )                    
Local lUsaVenc  := .F.
Local lAgricola	:= .F.

Local cLocal    := Iif(nPLocal > 0, aCols[n][nPLocal],Space(Len(SC6->C6_LOCAL)))
Local cCondPag  := M->C5_CONDPAG

DEFAULT nQtde    := 0
DEFAULT cCliente := M->C5_CLIENTE
DEFAULT cLoja    := M->C5_LOJACLI
DEFAULT cLoteCtl := ""
DEFAULT cNumLote := If(cNumLote == NIL .Or. Empty(cNumLote) .Or. Rastro(cProduto,"L"),"",cNumLote)
DEFAULT lLote    := .F.
DEFAULT lExecb   := .T.
DEFAULT lPrcTab  := .F.
DEFAULT cOpcional:= If(nPosOpc==0,"",AllTrim(aCols[nLin][nPosOpc]))

lUsaVenc  := If(!Empty(cLoteCtl+cNumLote),.T.,(SuperGetMv('MV_LOTVENC')=='S'))

	//*************************************************************************
	//*	Trecho especifico para as funcionalidade do modulo SIGAAGR.	  	   	   *
	//*	Sempre considera o contrato da rotina automatica.					   *
	//**************************************************************************
	If IsIncallStack("AGRA900") .Or. IsIncallStack("AGRA750")
		If ( Type("l410Auto") != "U" .And. l410Auto .And. Type("aAutoItens[n]") !=  "U") .And. Type("aAutoCab") != "U"  
			nPCtrAuto := aScan(aAutoItens[n], {|x| Alltrim(x[1]) == "C6_CONTRAT" })
			nPItemCon := aScan(aAutoItens[n], {|x| Alltrim(x[1]) == "C6_ITEMCON" })
			If nPCtrAuto > 0 .And. nPItemCon > 0
				aCols[n][nPContrat] := aAutoItens[n,nPCtrAuto,2]
				aCols[n][nPItemCon] := aAutoItens[n,nPItemCon,2]
				lAgricola := .T.
			EndIf	                  
		EndIf
	EndIf 
	
	//*******************************************************
	//* Verifica se ha contrato de parceria                  *
	//********************************************************
	If lContrat .And. nPContrat<>0 .And. nPItemCon<>0 .And. !Empty(cProduto)
		If !lAgricola .And. !(FunName() $ "FATA400")
			dbSelectArea("ADA")
			dbSetOrder(1)		
			dbSelectArea("ADB")
			dbSetOrder(2)

			aStruADB := ADB->(dbStruct())

			cAliasADA := getNextAlias()
			cAliasADB := getNextAlias()

			cQuery := "SELECT * "
			cQuery += "FROM "+RetSqlName("ADB")+" ADB, "
			cQuery += RetSqlName("ADA")+" ADA "
			cQuery += "WHERE ADB.ADB_FILIAL='"+xFilial("ADB")+"' AND "
			cQuery += "ADB.ADB_CODCLI='"+cCliente+"' AND "
			cQuery += "ADB.ADB_LOJCLI='"+cLoja+"' AND "
			cQuery += "ADB.ADB_CODPRO='"+cProduto+"' AND "
			cQuery += "ADB.D_E_L_E_T_=' ' AND "
			cQuery += "ADA.ADA_FILIAL='"+xFilial("ADA")+"' AND "
			cQuery += "ADA.ADA_NUMCTR=ADB.ADB_NUMCTR AND "
			cQuery += "ADA.ADA_STATUS IN ('B','C') AND "
			cQuery += "ADA.ADA_CONDPG='"+cCondPag+"' AND "
			If !Empty(SC6->C6_CONTRAT)
				cQuery += "ADB.ADB_NUMCTR='"+SC6->C6_CONTRAT+"' AND "
			EndIf			
			cQuery += "ADA.D_E_L_E_T_=' '  "		
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasADB)
			
			For nX := 1 To Len(aStruADB)
				If aStruADB[nX][2] <> "C"

					if !(select(cAliasADB) > 0)
						cAliasADB := getNextAlias()
					endif

					TcSetField(cAliasADB,aStruADB[nX][1],aStruADB[nX][2],aStruADB[nX][3],aStruADB[nX][4])
				EndIf
			Next nX
	
		Else 
			dbSelectArea("ADA")
			dbSetOrder(1)		
			dbSelectArea("ADB")
			dbSetOrder(1)                                      
			MsSeek(xFilial("ADB")+aCols[n][nPContrat]+aCols[n][nPItemCon])
		EndIf	        
		
		While ( !Eof() .And. xFilial("ADB") == (cAliasADB)->ADB_FILIAL .And.;
				(cAliasADB)->ADB_CODCLI == cCliente .And.;
				(cAliasADB)->ADB_LOJCLI == cLoja .And.;
				(cAliasADB)->ADB_CODPRO == cProduto )
			
			lValido := .T.
			
			If lValido
				//*******************************************************
				//* Verifica o saldo de contratos deste orcamento        *
				//********************************************************		
				If Empty(aContrato)
					For nY := 1 To Len(aCols)
						If !aCols[nY][nUsado+1] .And. N <> nY .And. !Empty(aCols[nY][nPContrat])
							nX := aScan(aContrato,{|x| x[1] == aCols[nY][nPContrat] .And. x[2] == aCols[nY][nPItemCon]})
							If nX == 0
								aadd(aContrato,{aCols[nY][nPContrat],aCols[nY][nPItemCon],aCols[nY][nPQtdVen]})
								nX := Len(aContrato)
							Else
								aContrato[nX][3] += aCols[nY][nPQtdVen]
							EndIf
						EndIf
						dbSelectArea("SC6")
						dbSetOrder(1)
						If MsSeek(xFilial("SC6")+M->C5_NUM+aCols[nY][nPItem]) .And. !Empty(SC6->C6_CONTRAT)
							nX := aScan(aContrato,{|x| x[1] == SC6->C6_CONTRAT .And. x[2] == SC6->C6_ITEMCON})
							If nX == 0
								aadd(aContrato,{SC6->C6_CONTRAT,SC6->C6_ITEMCON,0})
								nX := Len(aContrato)
							EndIf
							aContrato[nX][3] -= SC6->C6_QTDVEN
						EndIf
						If lAgricola
							Exit
						EndIf
					Next nY
				EndIf
				nX := aScan(aContrato,{|x| x[1] == (cAliasADB)->ADB_NUMCTR .And. x[2] == (cAliasADB)->ADB_ITEM})
				If (cAliasADB)->ADB_QUANT > (cAliasADB)->ADB_QTDEMP+IIf(nX>0,aContrato[nX][3],0)
					If lPrcTab
						nPrcVen := xMoeda((cAliasADB)->ADB_PRUNIT,(cAliasADA)->ADA_MOEDA,M->C5_MOEDA,dDataBase,TamSx3("C6_PRCVEN")[2])
					Else
						nPrcVen := xMoeda((cAliasADB)->ADB_PRCVEN,(cAliasADA)->ADA_MOEDA,M->C5_MOEDA,dDataBase,TamSx3("C6_PRCVEN")[2])
					EndIf
					If aCols[n][nPQtdVen] > (cAliasADB)->ADB_QUANT-(cAliasADB)->ADB_QTDEMP
						aCols[n][nPQtdVen] := (cAliasADB)->ADB_QUANT-(cAliasADB)->ADB_QTDEMP - IIf(nX>0,aContrato[nX][3],0)
						a410MultT("C6_QTDVEN",aCols[n][nPQtdVen])
					EndIf
					If Len(aContrato) >= n
						For nZ := 1 To Len(aContrato)
							aCols[nZ][nPContrat] := aContrato[nZ][1]
						Next nZ
					Else
						aCols[n][nPContrat] := (cAliasADB)->ADB_NUMCTR
						aCols[n][nPItemCon]  := (cAliasADB)->ADB_ITEM
					EndIf	
					Exit
				EndIf
			EndIf
			dbSelectArea(cAliasADB)
			dbSkip()
		EndDo

		dbSelectArea(cAliasADB)
		dbCloseArea()
		dbSelectArea("ADB")
	EndIf


	//***************************************************************
	//*Verifica se existe preco para o lote caso tenha sido informado*
	//****************************************************************
    
	If !Empty(cLoteCtl) .And. nPrcVen == 0
		//***************************************************************
		//*Busca o preco do SB8 quando o lote for informado no pedido de *
		//*venda                                                         *
		//****************************************************************

		SB8->(dbSetOrder(3))
		If SB8->(MsSeek(xFilial("SB8")+cProduto+cLocal+cLoteCtl+Alltrim(cNumLote)))		
			If lUsaVenc 
				If  dDataBase <= SB8->B8_DTVALID
					nPrcVen := SB8->B8_PRCLOT 
				Endif
			Else		                     
				nPrcVen := SB8->B8_PRCLOT
			Endif	
		Endif				

		//*****************************************************************
		//*Calcula o preco somente se o preco do lote no SB8 for informado *
		//******************************************************************
		
		If nPrcVen <> 0
			//***************************************************************
			//*Verifica o fator de acrescimo ou desconto de acordo com os    *
			//*dados informados para calculo sobre o preco do SB8            *
			//****************************************************************
			nFator := MaTabPrVen(cTabPrec,cProduto,nQtde,cCliente,cLoja,M->C5_MOEDA,M->C5_EMISSAO,2)
			nPrcVen := nPrcVen * nFator
		Endif	
	Endif	
	
	If nPrcVen == 0 .And. !lLote	
		//***************************************************************
		//* Verifica se a grade esta ativa, e se o produto digitado e'   *
		//* uma referencia                                               *
		//****************************************************************
		If ( lGrade )
			MatGrdPrrf(@cProduto)
		EndIf
		
		If nLin > 0 .And. nPosTes > 0
			dbSelectArea("SF4")
			dbSetOrder(1)
			If MsSeek(xFilial("SF4")+aCols[nLin][nPosTes])
				cPoder3 := SF4->F4_PODER3
			Else
				cPoder3 := "N"
			Endif
		Else
			cPoder3 := "N"
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If ( !Empty(cProduto) .And. MsSeek(xFilial("SB1")+cProduto,.F.) .And. ( ( M->C5_TIPO=="N" .And. cPoder3 == "N" ) .Or. (lPrcPod3 .And. !(IsInCallStack("A410Devol"))) ) ) 
			nPrcVen := MaTabPrVen(cTabPrec,cProduto,nQtde,cCliente,cLoja,M->C5_MOEDA,M->C5_EMISSAO)
			A410RvPlan(cTabPrec,cProduto)
		EndIf
	EndIf

	If !lOpcPadrao
		aOpcional := STR2ARRAY(cOpcional,.F.)
		If ValType(aOpcional)=="A" .And. Len(aOpcional) > 0
			For nAux := 1 To Len(aOpcional)
				cOpcional += aOpcional[nAux][2]
			Next nAux
		EndIf	
	EndIf
	//***************************************************************
	//* Aqui * efetuado o tratamento diferencial de Precos para os   *
	//* Opcionais do Produto.                                        *
	//**************************************************************** 
	If nPosOpc > 0
		If AllTrim(aCols[n][nPosOpc]) =='A' 
			aCols[n][nPosOpc] 	:= ""
			cOpcional			:= ""
		EndIf	
	EndIf
	While !Empty(cOpcional)
		cOpc      := SubStr(cOpcional,1,At("/",cOpcional)-1)
		cOpcional := SubStr(cOpcional,At("/",cOpcional)+1)
		dbSelectArea("SGA")
		dbSetOrder(1)
		If ( MsSeek(xFilial("SGA")+cOpc) )
			nPrcVen += SGA->GA_PRCVEN
		EndIf
	EndDo

	if select(cAliasADA) > 0
		(cAliasADA)->(DBCloseArea())
	endif

	if select(cAliasADB) > 0
		(cAliasADB)->(DBCloseArea())
	endif

RestArea(aArea)

Return(nPrcVen)  
