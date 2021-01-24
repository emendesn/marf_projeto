#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFFIN46
Autor....:              Atilio Amarilla
Data.....:              07/03/2017
Descricao / Objetivo:   Impressão de Dados FIDC (Geração de Planilhas)
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamado pelo browse MVC MGFFIN43
=====================================================================================
*/
User Function MGFFIN46(cOpc)
	
	Processa({|| MGFFIN4601(cOpc) },"Aguarde - Gerando Arquivo...")
	
Return

Static Function MGFFIN4601(cOpc)
	
	Local cTitulo, cStatus, aCliente, cArqExc, cAlias
	
	Local aArea	:= GetArea() 
	Local aItens	:= {}
	
	dbSelectArea("SEB")
	dbSetOrder(1)

	dbSelectArea("ZA8")
	dbSetOrder(1)
	
	If cOpc == "1"
		
		If ZA7->ZA7_TIPO == "1"
			aCabRem	:= {"Status","Filial","Remessa","Prefixo","Número","Parcela","Tipo","Cliente","Loja","Nome","Emissão","Vencimento","Valor","Motivo Rejeição"}
		Else
			aCabRem	:= {"Status","Filial","Remessa","Prefixo","Número","Parcela","Tipo","Cliente","Loja","Nome","Emissão","Vencimento","Valor","Motivo Recompra","Motivo Rejeição"}
		EndIf


		cArqExc := FunName()+Right( cEmpAnt+cFilAnt , 6 )+ZA7->ZA7_CODREM+"F"+Subs(DTOS(Date()),3,6)+StrTran(Time(),":")
		
		cTitulo	:= IIF(ZA7->ZA7_TIPO=="2","Recompra ","")+"FIDC: - Remessa: "+ZA7->ZA7_CODREM+" ("+IIF(Empty(ZA7->ZA7_DATA),"Pendente de Envio","Enviado "+DTOC(ZA7->ZA7_DATA))+")"
		
		ZA8->( dbSeek( xFilial("ZA8")+ZA7->ZA7_CODREM ) )
		
		While !ZA8->( eof() ) .And. ZA8->(ZA8_FILIAL+ZA8_CODREM) == xFilial("ZA8")+ZA7->ZA7_CODREM
			
			cStatus	:= " "
			If ZA8->ZA8_STATUS	== "1"
				cStatus := "Ativo"
			ElseIf ZA8->ZA8_STATUS	== "2"
				cStatus := "Confirmado"
			ElseIf ZA8->ZA8_STATUS	== "3"
				cStatus := "Recomprado"
			ElseIf ZA8->ZA8_STATUS	== "4"
				cStatus := "Rejeitado"
			EndIf
			
			aCliente	:= GetAdvFVal("SE1",{"E1_CLIENTE","E1_LOJA","E1_NOMCLI","E1_EMISSAO"},xFilial("SE1")+ZA8->(ZA8_PREFIX+ZA8_NUM+ZA8_PARCEL+ZA8_TIPO),1,{" "," "," ",CTOD("")})


			If ZA7->ZA7_TIPO == "1"
			
				aAdd( aItens , { 	cStatus				,;
					ZA8->ZA8_CODREM 	,;
					ZA8->ZA8_FILIAL		,;
					ZA8->ZA8_PREFIX		,;
					ZA8->ZA8_NUM		,;
					ZA8->ZA8_PARCEL		,;
					ZA8->ZA8_TIPO 		,;
					aCliente[1]			,;
					aCliente[2]			,;
					aCliente[3]			,;
					DTOC( aCliente[4] )	,;
					DTOC(ZA8->ZA8_VENCRE)	,;
					Tran( ZA8->ZA8_VALOR , PesqPict("SE1","E1_VALOR") )	,;
					IIF(Empty(ZA8->ZA8_MOTREJ)," ",GetAdvFVal("SEB","EB_DESCMOT",xFilial("SEB")+ZA8->ZA8_BANCO+"03 R"+ZA8->ZA8_MOTREJ,1," ") )	} )
			
			Else
			
				aAdd( aItens , { 	cStatus				,;
					ZA8->ZA8_CODREM 	,;
					ZA8->ZA8_FILIAL		,;
					ZA8->ZA8_PREFIX		,;
					ZA8->ZA8_NUM		,;
					ZA8->ZA8_PARCEL		,;
					ZA8->ZA8_TIPO 		,;
					aCliente[1]			,;
					aCliente[2]			,;
					aCliente[3]			,;
					DTOC( aCliente[4] )	,;
					DTOC(ZA8->ZA8_VENCRE)	,;
					Tran( ZA8->ZA8_VALOR , PesqPict("SE1","E1_VALOR") )	,;
					Tabela(IIF(Subs(ZA8->ZA8_MOTREC,1,1)=="9",cRecAut,cRecMan),ZA8->ZA8_MOTREC,.F.)	,;
					IIF(Empty(ZA8->ZA8_MOTREJ)," ",GetAdvFVal("SEB","EB_DESCMOT",xFilial("SEB")+ZA8->ZA8_BANCO+"15 R"+ZA8->ZA8_MOTREJ,1," ") )	} )

			EndIf
			ZA8->( dbSkip() )
		EndDo
		
	Else
		
		aCabRem	:= {"Tipo","Status","Remessa","Filial","Prefixo","Número","Parcela","Tipo","Cliente","Loja","Nome","Emissão","Vencimento","Valor","Motivo Recommpra","Motivo Rejeição","Data Rejeição"}
		
		dRejIni	:= dRejFim	:= dDataBase
		aRet	:= {}
		aPergs	:= {}
		
		aAdd( aPergs ,{1,"Data Rejeição De : ",dRejIni,"@!",'.T.'	,		,'.T.',50,.T.})
		aAdd( aPergs ,{1,"Data Rejeição Até : ",dRejFim,"@!",'.T.'	,		,'.T.',50,.T.})
		
		If !ParamBox(aPergs ,"Parametros FIDC - Títulos Rejeitados",aRet)
			Aviso("FIDC - Impressão Rejeitados","Processamento Cancelado!",{'Ok'})
		Else
			
			cArqExc := FunName()+Right( cEmpAnt+cFilAnt , 6 )+"REJEITADOS"+Subs(DTOS(Date()),3,6)+StrTran(Time(),":")
			
			cTitulo	:= "FIDC: - Títulos Rejeitados - Período: "+DTOC(aRet[1])+" a "+DTOC(aRet[2])
			
			cAlias	:= GetNextAlias()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se último do título ativo                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			BeginSQL Alias cAlias
			
				SELECT *
				FROM %table:ZA8% ZA8
				INNER JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
					AND ZA7_FILIAL = ZA8_FILIAL
					AND ZA7_CODREM = ZA8_CODREM
				WHERE ZA8.%notDel%
					AND ZA8_FILIAL = %xFilial:ZA8%
					AND ZA8_STATUS = '4'
					AND ZA8_DATREJ BETWEEN %Exp:DTOS(aRet[1])% AND %Exp:DTOS(aRet[2])% 
					
				ORDER BY ZA8_DATREJ, ZA8_CODREM, ZA8_PREFIX, ZA8_NUM, ZA8_PARCEL, ZA8_TIPO
			
			EndSQL
			
			aQuery := GetLastQuery()
		
			MemoWrit( FunName()+"-QueryImpRejeitados-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )
			
			While !(cAlias)->( eof() )
				
				cStatus	:= " "
				If (cAlias)->ZA8_STATUS	== "1"
					cStatus := "Ativo"
				ElseIf (cAlias)->ZA8_STATUS	== "2"
					cStatus := "Confirmado"
				ElseIf (cAlias)->ZA8_STATUS	== "3"
					cStatus := "Recomprado"
				ElseIf (cAlias)->ZA8_STATUS	== "4"
					cStatus := "Rejeitado"
				EndIf
				
				aCliente	:= GetAdvFVal("SE1",{"E1_CLIENTE","E1_LOJA","E1_NOMCLI","E1_EMISSAO"},xFilial("SE1")+(cAlias)->(ZA8_PREFIX+ZA8_NUM+ZA8_PARCEL+ZA8_TIPO),1,{" "," "," ",CTOD("")})
				aAdd( aItens , { 	IIF((cAlias)->ZA7_TIPO=="1","FIDC","Recompra")	,;
									cStatus				,;
									(cAlias)->ZA8_CODREM 	,;
									(cAlias)->ZA8_FILIAL		,;
									(cAlias)->ZA8_PREFIX		,;
									(cAlias)->ZA8_NUM		,;
									(cAlias)->ZA8_PARCEL		,;
									(cAlias)->ZA8_TIPO 		,;
									aCliente[1]			,;
									aCliente[2]			,;
									aCliente[3]			,;
									DTOC( aCliente[4] )	,;
									DTOC(STOD((cAlias)->ZA8_VENCRE))	,;
									Tran( (cAlias)->ZA8_VALOR , PesqPict("SE1","E1_VALOR") )	,;
									IIF((cAlias)->ZA7_TIPO=="1"," ",Tabela(IIF(Subs(( cAlias )->ZA8_MOTREC,1,1)=="9",cRecAut,cRecMan),( cAlias )->ZA8_MOTREC,.F.) )	,;
									IIF(Empty((cAlias)->ZA8_MOTREJ)," ",GetAdvFVal("SEB","EB_DESCMOT",xFilial("SEB")+(cAlias)->ZA8_BANCO+IIF((cAlias)->ZA7_TIPO=="1","03 R","15 R")+(cAlias)->ZA8_MOTREJ,1," ") )	,;
									DTOC(STOD( (cAlias)->ZA8_DATREJ ))		} )
				
				(cAlias)->( dbSkip() )
			EndDo
			
			dbSelectArea( cAlias )
			dbCloseArea()
			
		EndIf
		
	EndIf
	
	If Len( aItens ) > 0
		U_zGeraExc(aCabRem,aItens,cArqExc,cPatRem,cPatLoc,cTitulo)
	EndIf
	
	RestArea( aArea )
	
Return