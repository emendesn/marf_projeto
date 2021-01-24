#INCLUDE "rwmake.ch"
#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
#include "msmgadd.ch"

#define DMPAPER_A4 9
#define CRLF chr(13) + chr(10)
Static aStackTMP


/*
=====================================================================================
Programa.:              MGFFAT87
Autor....:              Marcelo Carneiro         
Data.....:              16/02/2018 
Descricao / Objetivo:   GAP 315 : Pré Pedido
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              PE : 1 - MA415MNU - Colocar os itens de Menu
						     2 - MA415LEG - Mudar a Legenda do Orçamento
						     3 - MA415COR - Mudar as Cores do Orçamento
						     4 - MT415BRW - Filtrar somente com o campo CJ_ZMESTRE em Branco 
				        *não*5 - MTA416PV - Para setar os campos especificos da SC5 antes de gerar o PV    
					    *não*6 - MT415EFT - Para setar as lojas do cliente.
						Mais rotinas especificas chamadas pelo menu
						Campos Criados  : CJ_ZIDEND CJ_ZTIPPED CJ_ZMESTRE CJ_ZMOTIVO CJ_ZCODMOT CJ_ZDESMOT
                              Alterados : CJ_VEND1  CJ_TABELA  CJ_TPFRETE
                              			  CJ_NOMCLI  para colocar no Browse e na efetivação.
                              			  CK igual ao fiscal. 	
						Indices Criados : CJ_FILIAL+CJ_STATUS  Status
										  CJ_FILIAL+CJ_ZMESTRE Mestre
						Consulta Padrão : FAT87A
						Parametros 		: MV_FATTEPO = F           
										  MV_ORCLIPD = em branco	
                        Pergunta 		: MTA416  2 = Nao 2 = Nao 1= Sim
                        Tabela Generica : ZB
						Gatilho         : CJ_LOJA Seção 03
=====================================================================================
*/

User Function MGFFAT87(nTipo,aRet)
	Local nI       := 0
	Local nPosMax  := 0
	Local nPosMin  := 0
	Local nPosProd := 0
	Local nPos     := 0
	Local nPosOrca := 0
	Local cPerg              := "MGFFAT87"

	Default aRet := {}

	IF nTipo == 1
		Aadd(aRotina,{'Efetiva'            ,'U_FAT87(1)',  0 , 5,0,NIL})
		Aadd(aRotina,{'Pedidos Gerados'    ,'U_FAT87(2)' , 0 , 2,0,NIL})
		Aadd(aRotina,{'Encerrar Orçamento' ,'U_FAT87(3)' , 0 , 5,0,NIL})
		Aadd(aRotina,{'Consulta Orçamentos','U_FAT87(5)' , 0 , 2,0,NIL})
		/*/
		// RVBJ
		//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
		If !ExisteSx6("MGF_FAT87A")
			CriarSX6("MGF_FAT87A", "C", "Usuario c/acesso a Parametros da efetivacao do Orçamento. Ex:t1005060"	, 'mmcrodr1' )	
		EndIf

		If !ExisteSx6("MGF_FAT87B")
			CriarSX6("MGF_FAT87B", "N", "Numero de dias que define o atraso em Orçamentos. Ex: 15"	, '15' )	
		EndIf
		/*/

	ElseIF nTipo == 2
		aRet := {	{ 'ENABLE'    , 'Orçamento em Aberto'       },; //
		{ 'DISABLE'   , 'Orçamento em Movimentação' },; //'Orcamento Baixado'
		{ 'BR_PRETO'  , 'Orçamento Cancelado'       },; //'Orcamento Cancelado'
		{ 'BR_AMARELO', 'Orçamento não Orçado'      },; //'Orcamento nao Orcado'
		{ 'BR_AZUL'   , 'Orçamento Expirado'		},;
		{ 'BR_MARROM' , 'Encerrado'                 }}  //'Orcamento bloqueado'
	ElseIF nTipo == 3
		// RVBJ
		aRet := {	{ 'SCJ->CJ_STATUS=="A" .AND. SCJ->(DTOS(CJ_EMISSAO)) <= "'+ ;
				DTOS(dDataBase-SuperGetMV("MGF_FAT87B",.F.,'15'))+'"' , 'BR_AZUL'},;
		{ 'SCJ->CJ_STATUS=="A"' , 'ENABLE' },; 	//Orcamento em Aberto
		{ 'SCJ->CJ_STATUS=="B"' , 'DISABLE'},;					//Orcamento Baixado
		{ 'SCJ->CJ_STATUS=="C"' , 'BR_PRETO'},;					//Orcamento Cancelado
		{ 'SCJ->CJ_STATUS=="D"' , 'BR_AMARELO'},;				//Orcamento nao Orcado
		{ 'SCJ->CJ_STATUS=="E"' , 'BR_MARROM' }}				//Orcamento bloqueado
	ElseIF  nTipo == 4
		aRet := "CJ_ZMESTRE = '      ' "
	EndIF
Return aRet


/*/
	{Protheus.doc} FAT87
	Monta a Tela para efetivar o orçamento.

	Rotina baseada no padrão

	@author Marcelo Carneiro
	@since 16/02/2018

	@type Function
	@param
	@return _lRet
/*/
User Function FAT87(nAcao)
	Local nI          := 0
	Local nOpcAux     := 0
	Local cAreaSCJ    := SCJ->(GetArea())
	Local cAreaSC5    := SC5->(GetArea())
	Local cChave      := ''
	Local nPos        := 0
	Local nStack      := 0
	Local cArqSCL     := ""
	Local cArqSCK     := ""
	Local ACPOSCOPY   := {}
	Local nPosQtd     := 0
	Local bTemSaldo   := .F.
	Local bGrava      := .F.
	Local cPedido     := ''
	Local cStatus     := ''
	Local cQuery      := ''
	Local bEncerrado  := .F.
	Local bPedido     := .T.
	Local oEnch
	Local lMemoria 	  := .T.
	Local lCreate	  := .T.
	Local aField	  := {}
	Local aFolder	  := {}
	Local aRec        := {}
	Local nX          := 0
	Local cClasFis    := ''
	Local cTes        := ''
	Local nPrecoLista := 0
	Local nPrecoOrca  := 0
	Local nQtdOrca    := 0
	Local cFilSCJ 	  := cFilAnt
	Local aParametros := {}
	Local cNome       := ''
	Local cLine       := ''
	Local nRecno      := 0
	Local _cFilial    := ''

	Private aParamBox := {}
	Private aRet      := {}
	Private oDlg
	Private oGet
	Private oBtn
	Private aListItens  := {}
	Private aSaldo      := {}
	Private aAlter      := {'CK_QUANT','CK_ZDTMAX','CK_ZDTMIN'}
	Private aCabDados   := {}
	Private aCampos     :=  {'CK_ITEM','CK_PRODUTO','CK_DESCRI', 'CK_UM', 'CK_PRUNIT','CK_PRCVEN','CK_QTDVEN','CK_QTDVEN','C6_ZDTMIN','C6_ZDTMAX'}
	Private aHeaderSCL	:= {}
	Private aHeaderSCK	:= {}
	Private aHeadC6     := {}
	Private aHeadD4     := {}
	Private l416Auto    := .T.
	Private aListPV     := {}
	Private bCampo  	:= { | nField | FieldName(nField) }
	Private aSize   	:= {}
	Private aOBJ    	:= {}
	Private aInfo   	:= {}
	Private aPObj   	:= {}
	Private aButtons   	:= {}
	Private aCpoEnch	:= {'C5_FILIAL', 'C5_CLIENTE', 'C5_LOJACLI', 'C5_XNOMECL', 'C5_ZIDEND', 'C5_ZTPOPER', 'C5_ZDTEMBA', 'C5_FECENT', 'C5_MENNOTA', 'C5_XACONDC', 'C5_XDSCARG', 'C5_XVLDESC', 'C5_XAGENDA', 'C5_XTPROD', 'C5_XOBSPED', 'C5_ZOBS'}	//campos que serão mostrados na enchoice
	Private aValorCpo   := {}
	Private aAlterEnch  := {'C5_FILIAL', 'C5_CLIENTE', 'C5_LOJACLI', 'C5_ZIDEND', 'C5_ZTPOPER', 'C5_ZDTEMBA', 'C5_FECENT', 'C5_MENNOTA', 'C5_XACONDC', 'C5_XDSCARG', 'C5_XVLDESC', 'C5_XOBSPED', 'C5_XAGENDA', 'C5_XTPROD', 'C5_ZOBS'} 	//habilita estes campos para edição
	Private dDtMax      := CTOD('  /  /  ')
	Private dDtMin      := CTOD('  /  /  ')
	Private aDatas      := {}
	
//1= Efetiva 2= Pedidos Gerados 3= Encerrar Orçamento 4= Atualiza Status 5= Relatório Orçamento 
	IF nAcao == 1
		IF SCJ->CJ_STATUS <> 'A' .AND. SCJ->CJ_STATUS <> 'B'
			MsgAlert('Situação do Orçamento não permite Efetivação !!')
			Return
		EndIF

		// RVBJ
		IF SCJ->CJ_STATUS=="A" .AND. SCJ->(DTOS(CJ_EMISSAO)) <= DTOS(dDataBase-SuperGetMV("MGF_FAT87B",.F.,'15')) 
			If ! cusername $ ALLTRIM(SuperGetMV("MGF_FAT87A",.F.,"mmcrodr1"))
				MsgAlert('Orçamento com data de emissão expirada !!')
				Return
			ENDIF
		ENDIF
		// Monta aCols
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		dbSelectArea('SC5')
		SC5->(dbSetOrder(1))

		dbSelectArea('SCK')
		SCK->(dbSetOrder(1))
		SCK->(dbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
		While SCK->(!EOF()) .AND. SCJ->(CJ_FILIAL+CJ_NUM)  == SCK->(CK_FILIAL+CK_NUM)
			SB1->( DbSeek( xFilial("SB1") + SCK->CK_PRODUTO ) )
			dDtMax := dDATABASE+10000
			dDtMin := dDATABASE-10000

			dbSelectArea('SZJ')
			SZJ->(dbSetOrder(1))
			SZJ->(dbSeek(xFilial('SZJ')+SCJ->CJ_ZTIPPED))
			If SZJ->ZJ_FEFO=="S"
				dDtMin	:=	dDataBase + SZJ->ZJ_MINIMO
				dDtMax	:=	dDataBase + SZJ->ZJ_MAXIMO
			Else
				DbSelectArea("SA1")
				SA1->(DbSetOrder(1))
				If SA1->( DbSeek(xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA   ) )
					If SA1->A1_ZVIDAUT > 0
						dDtMin	:=	dDataBase + ( SA1->A1_ZVIDAUT * SB1->B1_ZVLDPR )
						dDtMax	:=	dDataBase + ( SB1->B1_ZVLDPR )
					EndIF
				Endif
			Endif
			AAdd(aListItens,{SCK->CK_ITEM, SCK->CK_PRODUTO, SCK->CK_DESCRI ,SCK->CK_UM,SCK->CK_PRUNIT,SCK->CK_PRCVEN, 0 ,0,dDtMin,dDtMax, .F.  })
			AAdd(aSaldo,{SCK->CK_ITEM+SCK->CK_PRODUTO, SCK->CK_QTDVEN, 0 })

			SCK->(dbSkip())
		END

		cChave  := SCJ->CJ_FILIAL+SCJ->CJ_NUM

		//Atualiza Saldo do Orçamento
		SCJ->(DbOrderNickName('MESTRE'))
		SCJ->(dbSeek(cChave))
		While SCJ->(!EOF()) .AND. SCJ->(CJ_FILIAL+CJ_ZMESTRE)  == cChave
			IF SCK->(dbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
				IF SC5->(dbSeek(SCK->CK_FILVEN+SCK->CK_NUMPV))
					While SCK->(!EOF()) .AND. SCJ->(CJ_FILIAL+CJ_NUM)  == SCK->(CK_FILIAL+CK_NUM)
						nPos := AScan(aSaldo,{|x|  x[1] == SCK->CK_ITEM+SCK->CK_PRODUTO })
						IF nPos <> 0
							aSaldo[nPos,3] += SCK->CK_QTDVEN
						EndIF
						SCK->(dbSkip())
					END
				EndIF
			EndIF
			SCJ->(dbSkip())
		END

		//Verifica se o Orçamento ainda possui saldo
		For nI := 1 To Len(aSaldo)
			IF aSaldo[nI,2] - aSaldo[nI,3] > 0
				bTemSaldo := .T.
			EndIF
		Next nI
		For nI := 1 To Len(aSaldo)
			aListItens[nI,07] := aSaldo[nI,2] - aSaldo[nI,3]
		Next nI

		//Monta aHeads
		dbSelectArea("SX3")
		SX3->(dbSetOrder(2))
		For nI := 1 To Len(aCampos)
			IF SX3->(dbSeek(aCampos[nI]))
				AADD( aCabDados, { Trim( X3Titulo() ),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					'',;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					'',;
					SX3->X3_CONTEXT})
			Endif
		Next nI
		aCabDados[07,01]  := 'Saldo Orçamento'
		aCabDados[07,02] := 'CK_SALDO'
		aCabDados[08,02] := 'CK_QUANT'
		aCabDados[09,02] := 'CK_ZDTMIN'
		aCabDados[10,02] := 'CK_ZDTMAX'
		aCabDados[10,03] := '@D'

		SCJ->(dbSetOrder(1))
		SCJ->(dbSeek(cChave))

		aSize := MsAdvSize()
		AAdd(aOBJ,{100,120,.T.,.F.})
		AAdd(aOBJ,{100,50,.T.,.T.})  //75
		aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 2, 2 }
		aPObj := MsObjSize( aInfo, aObj )

		//Montando o cabeçalho
		DbSelectArea("SX3")
		SX3->(DbSetOrder(1))
		SX3->(DbSeek('SC5'))
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == 'SC5'
			IF AScan(aCpoEnch,{ |x| x == Alltrim(SX3->X3_CAMPO) }) <> 0
				aRec       := {}
				Aadd(aRec, X3TITULO())
				Aadd(aRec, SX3->X3_CAMPO)
				Aadd(aRec, SX3->X3_TIPO)
				Aadd(aRec, SX3->X3_TAMANHO)
				Aadd(aRec, SX3->X3_DECIMAL)
				Aadd(aRec, SX3->X3_PICTURE)
				Aadd(aRec, '') 	//Valid	
//				Paulo Henrique - 21/11/2019 - feita a troca da condição abaixo, para busca por cliente				
//				IF Alltrim(SX3->X3_CAMPO) $ 'C5_FILIAL#C5_CLIENTE#C5_LOJACLI'
				IF Alltrim(SX3->X3_CAMPO) $ 'C5_FILIAL#C5_CLIENTE'
					Aadd(aRec, .T.)	//Obrigatorio	8
				Else
					Aadd(aRec, .F.)	//Obrigatorio	8
				EndIF
				Aadd(aRec, SX3->X3_NIVEL)
				Aadd(aRec, SX3->X3_RELACAO)
				IF Alltrim(SX3->X3_CAMPO) == 'C5_FILIAL'
					Aadd(aRec, 'SM0')
//              Paulo Henrique - 21/11/2019 - Troca da condição, para a busca por cliente
				ElseIf Alltrim(SX3->X3_CAMPO) == 'C5_CLIENTE'
					Aadd(aRec, 'FAT87A') 	//F3
//				ELSEIF Alltrim(SX3->X3_CAMPO) == 'C5_LOJACLI'
//					Aadd(aRec, 'FAT87A') 	//F3
				ELSEIF Alltrim(SX3->X3_CAMPO) == 'C5_ZTPOPER'
					Aadd(aRec, 'DJ') 	//F3
				ElSEIF Alltrim(SX3->X3_CAMPO) == 'C5_ZIDEND'
					Aadd(aRec, 'SZ9SC5')
				Else
					Aadd(aRec, '')		// 11	F3
				EndIF
				Aadd(aRec, SX3->X3_WHEN)
				Aadd(aRec, .F.)
				Aadd(aRec, .F.)
				Aadd(aRec, SX3->X3_CBOX)
				Aadd(aRec, Val(SX3->X3_FOLDER))
				Aadd(aRec, .F.)
				Aadd(aRec, SX3->X3_PICTVAR)
				Aadd(aRec, '' )//Trigger	    19
				Aadd(aField, aRec)
			EndIf
			SX3->(DbSkip())
		End

		DEFINE MSDIALOG oDlg TITLE "Efetiva Orçamento" FROM aSize[7],aSize[1] TO aSize[6],aSize[5] Pixel

		RegToMemory('SC5', .T.)
		M->C5_ZTPOPER	:=	SCJ->CJ_ZTPOPER //'BJ'
		M->C5_ZDTEMBA	:=	SCJ->CJ_ZDTEMBA
		M->C5_FECENT	:=	SCJ->CJ_XFECENT
		M->C5_CLIENTE	:=	SCJ->CJ_CLIENTE
		M->C5_LOJACLI	:=	SCJ->CJ_LOJA
		M->C5_XNOMECL	:=	GetAdvFVal( "SA1", "A1_NOME", xFilial('SA1')+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA, 1, "" )
		M->C5_ZIDEND	:=	SCJ->CJ_ZIDEND
		M->C5_TIPO		:=	"N"
		M->C5_TABELA	:=	SCJ->CJ_TABELA
		M->C5_ZTIPPED	:=	SCJ->CJ_ZTIPPED
		M->C5_XTPROD	:=	SCJ->CJ_XTPROD
		M->C5_XACONDC	:=	SCJ->CJ_XACONDC
		M->C5_XDSCARG	:=	SCJ->CJ_XDSCARG
		M->C5_XVLDESC	:=	SCJ->CJ_XVLDESC
		M->C5_XAGENDA	:=	SCJ->CJ_XAGENDA


		oEnch := MsmGet():New(,,3,/*aCRA*/,/*cLetras*/,/*cTexto*/,aCpoEnch,aPObj[1],aAlterEnch,/*nModelo*/,;
						  /*nColMens*/,/*cMensagem*/, /*cTudoOk*/,oDlg,/*lF3*/,lMemoria,/*lColumn*/,/*caTela*/,;         
					      /*lNoFolder*/,/*lProperty*/,aField,aFolder,lCreate,/*lNoMDIStretch*/,/*cTela*/)   
			oGet := MsNewGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4],GD_UPDATE ,"AllwaysTrue","AllwaysTrue",,aAlter,0,999 ,"U_FAT87VAL" ,"","AllwaysTrue",oDlg,aCabDados,aListItens)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
			{||  IF( Val_dados(), nOpcAux := 1,nOpcAux := 0) , IF(nOpcAux == 1 ,oDlg:End() ,NIL ) },;
			{|| oDlg:End() },,@aButtons)
		IF nOpcAux == 1
			cPedido := ''
			// copiar orçamento inicial para o novo orçamento
			dbSelectArea("SCJ")
			SCJ->(dbSetOrder(1))
			SCJ->(dbSeek(cChave))
			For nX:= 1 To FCount()
				If Ascan(aCposCopy, EVAL(bCampo,nX) ) == 0
					M->&(EVAL(bCampo,nX)) := FieldGet(nX)
				Else
					M->&(EVAL(bCampo,nX)) := CriaVar(EVAL(bCampo,nX),.T.)
				Endif
			Next nX
			M->CJ_NUM			:=	CriaVar("CJ_NUM",.T.)
			M->CJ_EMISSAO		:=	dDataBase
			M->CJ_VALIDA		:=	CriaVar("CJ_VALIDA",.T.)
			M->CJ_ZMESTRE		:=	SCJ->CJ_NUM
			M->CJ_CLIENTE		:=	M->C5_CLIENTE
			M->CJ_LOJA			:=	M->C5_LOJACLI
			M->CJ_CLIENT		:=	M->C5_CLIENTE
			M->CJ_LOJAENT		:=	M->C5_LOJACLI
			M->CJ_FILENT		:=	M->C5_FILIAL
			M->CJ_FILVEN		:=	M->C5_FILIAL
			IF M->C5_LOJACLI == SCJ->CJ_LOJA
				M->C5_ZIDEND	:=	M->C5_ZIDEND
			ENDIF
			aValorCpo := {}
			For nI := 1 To Len(aCpoEnch)
				AADD(aValorCpo, &('M->'+aCpoEnch[nI]))
			Next nI
			nStack    := GetSX8Len()
			Processa( {|| A415Monta(@cArqSCK,@cArqSCL,.F., , ,.T.) },'Aguarde...', 'Montando arquivo para efetivação',.F. )
			aHeader := aHeaderSCK
			cQuery := " Delete from MP_SYSTEM_PROFILE  Where P_PROG ='MTA416'  AND P_TASK = 'PERGUNTE' "
			IF (TcSQLExec(cQuery) < 0)
				MsgAlert(TcSQLError())
			EndIF
			dbSelectArea('SA1')
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial('SA1')+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA	))
			Processa( {|| bGrava    := A415Grava(1) },'Aguarde...', 'Gerando Orçamento Filho',.F. )
			If !bGrava
				MsgAlert('Problema para gerar Orçamento Filho !!')
			Else
				EvalTrigger()
				While GetSX8Len() > nStack
					ConfirmSX8()
				EndDo

				// alterar orçamento filial e quantidade
				nPosQtd  := aScan( aCabDados, { |x| Alltrim(x[2]) == 'CK_QUANT' })
				SCK->(dbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
				While SCK->(!EOF()) .AND. SCJ->(CJ_FILIAL+CJ_NUM)  == SCK->(CK_FILIAL+CK_NUM)
					nPos := AScan(oGet:aCols,{|x|  x[1]+x[2] == SCK->CK_ITEM+SCK->CK_PRODUTO })
					IF nPos <> 0
						IF oGet:aCols[nPos,nPosQtd] == 0
							Reclock("SCK",.F.)
							SCK->(dbDelete())
							SCK->(MsUnlock())
						Else
							Reclock("SCK",.F.)
							SCK->CK_QTDVEN := oGet:aCols[nPos,nPosQtd]
							SCK->CK_VALOR  := SCK->CK_PRCVEN * oGet:aCols[nPos,nPosQtd]
							SCK->CK_FILVEN := M->C5_FILIAL
							SCK->CK_FILENT := M->C5_FILIAL
							SCK->CK_ENTREG := IIF(EMpty(M->C5_FECENT),dDATABASE+1,M->C5_FECENT)
							AAdd(aDatas,{SCK->CK_PRODUTO,oGet:aCols[nPos,9],oGet:aCols[nPos,10]})
							SCK->(MsUnlock())
						EndIF
					EndIF
					SCK->(dbSkip())
				END
				Processa( {|| A415DesMonta(@cArqSCK,@cArqSCL) },'Aguarde...', 'Efetivando Orçamento...Construindo a base',.F. )

				nRecno  := SCJ->(Recno())
				cFilant := M->C5_FILIAL
				aParametros := {;
					M->C5_FILIAL,;
					SCJ->(Recno()),;
					M->C5_ZTPOPER,;
					M->C5_ZDTEMBA,;
					M->C5_FECENT,;
					M->C5_MENNOTA,;
					M->C5_XACONDC,;
					M->C5_XDSCARG,;
					M->C5_XVLDESC,;
					M->C5_XOBSPED,;
					M->C5_ZIDEND,;
					aDatas,;
					M->C5_CLIENTE,;
					M->C5_LOJACLI,;
					M->C5_ZOBS,;
					M->C5_XAGENDA,;
					M->C5_XTPROD,;
					cChave }	// RVBJ - orçamento Principal
				Processa( {|| StartJob("u_xFAT87PED",GetEnvServer(),.T.,aParametros) },'Aguarde...' , 'Efetivando Orçamento... Criando o Pedido',.F. )

				// alterar status do orçamento origem
				cPedido  := ''
				_cFilial := ''
				SCJ->(dbGoTop())
				SCJ->(dbGoTo(nRecno))
				IF SCK->(dbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
					cPedido := Alltrim(SCK->CK_NUMPV)
					_cFilial := Alltrim(SCK->CK_FILVEN)
				EndIF
				IF cPedido == ''
					cQuery := " Delete from "+RetSQLName("SCJ")+"  Where CJ_NUM ='"+SCJ->CJ_NUM+"'"
					IF (TcSQLExec(cQuery) < 0)
						MsgAlert(TcSQLError())
					EndIF
					cQuery := " Delete from "+RetSQLName("SCK")+"  Where CK_NUM ='"+SCJ->CJ_NUM+"'"
					IF (TcSQLExec(cQuery) < 0)
						MsgAlert(TcSQLError())
					EndIF
				EndIF
				SCJ->(dbSetOrder(1))
				IF SCJ->(dbSeek(cChave))
					Reclock("SCJ",.F.)
					If Empty(cPedido)	//RVBJ
						cNome := Alltrim(SCJ->CJ_ZMOTIVO)
						SCJ->CJ_ZMOTIVO := ''
						IF FT_FUse(cNome) <> -1
							FT_FGoTop()
							While !FT_FEOF()
								cLine  += FT_FReadLn() +CRLF
								FT_FSKIP()
							End
							Alert('Problema para gerar o Pedido: '+CRLF+cLine)
							FT_FUSE()
							If FERASE(cNome) == -1
								MsgStop('Falha do exclusão do arquivo de erro !!')
							Endif
						Endif
					Else	//If !Empty(cPedido)
						IF TemSaldo(SCJ->CJ_FILIAL,SCJ->CJ_NUM)
							SCJ->CJ_STATUS ='B'
						Else
							SCJ->CJ_STATUS    := 'E'
							SCJ->CJ_ZMOTIVO   := 'Encerrado Automaticamente, gerou todo saldo'
						EndIF
					EndIF
					SCJ->(MsUnlock())
				EndIF
			EndIF
			IF !Empty(cPedido)
				cFilAnt := _cFilial
				SC5->(dbSeek(_cFilial+cPedido))
				U_MGFFAT17(cPedido)
				MsgAlert('Orçamento Efetivado, Pedido Gerado : '+Alltrim(cPedido))
			EndIF
		EndIF
		cFilAnt := cFilSCJ
	ElseIF nAcao == 2 //2= Pedidos Gerados
		cChave  := SCJ->CJ_FILIAL+SCJ->CJ_NUM

		SCK->(dbSetOrder(1))
		dbSelectArea('SC5')
		SC5->(dbSetOrder(1))

		SCJ->(DbOrderNickName('MESTRE'))
		SCJ->(dbSeek(cChave))
		While SCJ->(!EOF()) .AND. SCJ->(CJ_FILIAL+CJ_ZMESTRE)  == cChave
			IF SCK->(dbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
				nRecno  := 0
				cStatus := 'Pedido Excluído'
				IF SC5->(dbSeek(SCK->CK_FILVEN+SCK->CK_NUMPV))
					IF Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ) .And. (Empty(SC5->C5_ZBLQRGA) .or. SC5->C5_ZBLQRGA=="L")
						cStatus := 'Pedido Aberto'
					ElseIF !Empty(SC5->C5_NOTA) .Or. SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ) .And. (Empty(SC5->C5_ZBLQRGA) .or. SC5->C5_ZBLQRGA=="L")
						cStatus := 'Pedido Encerrado'
					ElseIF !Empty(SC5->C5_LIBEROK) .And. Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ).And. (Empty(SC5->C5_ZBLQRGA) .or. SC5->C5_ZBLQRGA=="L")
						cStatus := 'Pedido Liberado'
					Else
						cStatus := 'Pedido Bloqueado'
					EndIF
					nRecno := SC5->(Recno())
				EndIF
				AADD(aListPV,{SCK->CK_FILVEN, SCJ->CJ_CLIENTE, SCJ->CJ_LOJA,SCJ->CJ_ZIDEND,SCK->CK_NUMPV,cStatus,nRecno})
			EndIF
			SCJ->(dbSkip())
		END

		SCJ->(RestArea(cAreaSCJ))
		SCJ->(dbSetOrder(1))

		IF Len(aListPV) == 0
			MsgAlert('Orçamento ainda não efetivado !!')
			Return
		EndIF                                                         '

		DEFINE MSDIALOG oDlg TITLE "Pedidos Gerados" FROM 000, 000  TO 320, 650 COLORS 0, 16777215 PIXEL
		oBrowse := TWBrowse():New( 020, 003,  320, 120,,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
		oBrowse:SetArray(aListPV)
		oBrowse:nAt := 1
		oBrowse:bLine := { || {aListPV[oBrowse:nAt,1], ;
			aListPV[oBrowse:nAt,2],;
			aListPV[oBrowse:nAt,3],;
			aListPV[oBrowse:nAt,4],;
			aListPV[oBrowse:nAt,5],;
			aListPV[oBrowse:nAt,6]}}
		oBrowse:addColumn(TCColumn():new("Filial"  ,{||aListPV[oBrowse:nAt][01]},"@!" ,,,"LEFT"  ,30 ,.F.,.F.,,,,,))
		oBrowse:addColumn(TCColumn():new("Cliente" ,{||aListPV[oBrowse:nAt][02]},"@!" ,,,"LEFT"  ,40 ,.F.,.F.,,,,,))
		oBrowse:addColumn(TCColumn():new("Loja"    ,{||aListPV[oBrowse:nAt][03]},"@!" ,,,"LEFT"  ,20 ,.F.,.F.,,,,,))
		oBrowse:addColumn(TCColumn():new("ID End." ,{||aListPV[oBrowse:nAt][04]},"@!" ,,,"LEFT"  ,40 ,.F.,.F.,,,,,))
		oBrowse:addColumn(TCColumn():new("Pedido"  ,{||aListPV[oBrowse:nAt][05]},"@!" ,,,"LEFT"  ,50 ,.F.,.F.,,,,,))
		oBrowse:addColumn(TCColumn():new("Status"  ,{||aListPV[oBrowse:nAt][06]},"@!" ,,,"LEFT"  ,80 ,.F.,.F.,,,,,))

		oBtn := TButton():New( 145, 270, "Dados do Pedido"  ,oDlg,{|| 		Processa( {|| Con_SC5() },'Aguarde...', 'Consulta Pedido',.F. )	}   ,050,011,,,,.T.,,"",,,,.F. )
		oBtn := TButton():New( 003, 270, "Sair"             ,oDlg,{|| oDlg:End()}   ,050,011,,,,.T.,,"",,,,.F. )

		ACTIVATE MSDIALOG oDlg CENTERED

	ElseIF nAcao == 3 // 3=Encerrar Orçamento
		IF SCJ->CJ_STATUS <> 'B'
			MsgAlert('É possivel encerrar somente Orçamentos Em Movimentação !!')
			Return
		EndIF
		AAdd(aParamBox, {1, "Motivo do Encerramento:"   ,Space(2)     , "@!", ' NaoVazio() .AND. ExistCpo("SX5","ZB"+MV_PAR01)',"ZB",, 20	, .T.	})
		AAdd(aParamBox, {1, "Observação:"   			,Space(100)   , "@!", ' NaoVazio()'  ,,, 100	, .T.	})
		IF ParamBox(aParambox, "Informe o Motivo"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .F. /*lCanSave*/, .F. /*lUserSave*/)
			IF Empty(MV_PAR01) .OR. Empty(MV_PAR02)
				MsgAlert('Motivo ou Observação deve ser preenchido !!')
				Return
			EndIF
			Reclock("SCJ",.F.)
			SCJ->CJ_STATUS  := 'E'
			SCJ->CJ_ZCODMOT	:= MV_PAR01
			SCJ->CJ_ZMOTIVO	:= MV_PAR02
			SCJ->(MsUnlock())
		EndIF
	ElseIF nAcao == 4 //4= Atualiza Status
		Processa( {|| Atu_Status() },'Aguarde...', 'Atualizando Status',.F. )
	ElseIF nAcao == 5 // Relatorio
		AAdd(aParamBox, {1, "Filial de:"       	,Space(tamSx3("A1_FILIAL")[1])        , "@!",                           ,"XM0" ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Filial Até:"      	,Space(tamSx3("A1_FILIAL")[1])        , "@!",                           ,"XM0" ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Orçamento de:"     ,Space(tamSx3("C5_NUM")[1])           , "@!",                           ,"SCJ" ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Orçamento Até:"    ,Space(tamSx3("C5_NUM")[1])           , "@!",                           ,"SCJ" ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Cod. Cliente de:"  ,Space(tamSx3("A1_COD")[1])           , "@!",                           ,"SA1" ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Cod. Cliente Até:" ,Space(tamSx3("A1_COD")[1])           , "@!",                           ,"SA1" ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Loja de:"			,Space(tamSx3("A1_LOJA")[1])          , "@!",                           ,      ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Loja Até:"      	,Space(tamSx3("A1_LOJA")[1])          , "@!",                           ,      ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Dt. Emissão de:"	,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Dt. Emissão Até:"  ,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Produto:"          ,Space(tamSx3("B1_COD")[1])           , "@!",                           ,"SB1" ,, 070	, .F.	})
		AAdd(aParamBox, {1, "Produto Até:"      ,Space(tamSx3("B1_COD")[1])           , "@!",                           ,"SB1" ,, 070	, .F.	})
		IF ParamBox(aParambox, "Filtro para Selecionar os Pedidos"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
			dbSelectArea('SCK')
			SCK->(dbSetOrder(3))
			cQuery := " Select *                                                                                    "
			cQuery += " from  SC5010 SC5, SC6010 SC6 , (Select CK_FILVEN, CK_NUMPV, CK_CLIENTE,CK_LOJA, SCJ.CJ_NUM  "
			cQuery += "                                 from SCJ010 SCJ, SCJ010 SCJ2, SCK010 SCK                    "
			cQuery += "                                 Where SCJ.D_E_L_E_T_  = ' '                                 "
			cQuery += "                                   AND SCK.D_E_L_E_T_  = ' '                                 "
			cQuery += "                                   AND SCJ2.D_E_L_E_T_ = ' '                                 "
			cQuery += "                                   AND SCJ.CJ_ZMESTRE  = '      '                            "
			cQuery += "                                   AND SCJ2.CJ_FILIAL  = SCJ.CJ_FILIAL                       "
			cQuery += "                                   AND SCJ2.CJ_ZMESTRE = SCJ.CJ_NUM                          "
			cQuery += "                                   AND SCK.CK_FILIAL   = SCJ2.CJ_FILIAL                      "
			cQuery += "                                   AND SCK.CK_NUM      = SCJ2.CJ_NUM                         "
			cQuery += "                                 GROUP BY CK_FILVEN, CK_NUMPV, CK_CLIENTE,CK_LOJA, SCJ.CJ_NUM) ORCA      "
			cQuery += "                                                                                             "
			cQuery += "  Where SC5.D_E_L_E_T_  = ' '                                                                "
			cQuery += "    AND SC6.D_E_L_E_T_  = ' '                                                                "
			cQuery += "    AND C5_FILIAL       = C6_FILIAL                                                          "
			cQuery += "    AND C5_NUM          = C6_NUM                                                             "
			cQuery += "    AND C5_CLIENTE      = C6_CLI                                                             "
			cQuery += "    AND C5_LOJACLI      = C6_LOJA                                                            "
			cQuery += "    AND C5_FILIAL       = CK_FILVEN                                                          "
			cQuery += "    AND C5_NUM          = CK_NUMPV                                                           "
			cQuery += IIF( !Empty(MV_PAR01)," AND C5_FILIAL  >= '"+MV_PAR01+"'","")
			cQuery += IIF( !Empty(MV_PAR02)," AND C5_FILIAL  <= '"+MV_PAR02+"'","")
			cQuery += IIF( !Empty(MV_PAR03)," AND CJ_NUM     >= '"+MV_PAR03+"'","")
			cQuery += IIF( !Empty(MV_PAR04)," AND CJ_NUM     <= '"+MV_PAR04+"'","")
			cQuery += IIF( !Empty(MV_PAR05)," AND C5_CLIENTE >= '"+MV_PAR05+"'","")
			cQuery += IIF( !Empty(MV_PAR06)," AND C5_CLIENTE <= '"+MV_PAR06+"'","")
			cQuery += IIF( !Empty(MV_PAR07)," AND C5_LOJACLI >= '"+MV_PAR07+"'","")
			cQuery += IIF( !Empty(MV_PAR08)," AND C5_LOJACLI <= '"+MV_PAR08+"'","")
			cQuery += IIF( !Empty(MV_PAR09)," AND C5_EMISSAO >= '"+DTOS(MV_PAR09)+"'","")
			cQuery += IIF( !Empty(MV_PAR10)," AND C5_EMISSAO <= '"+DTOS(MV_PAR10)+"'","")
			cQuery += IIF( !Empty(MV_PAR11)," AND C6_PRODUTO >= '"+MV_PAR11+"'","")
			cQuery += IIF( !Empty(MV_PAR12)," AND C6_PRODUTO <= '"+MV_PAR12+"'","")

			If Select("QRY_PED") > 0
				QRY_PED->(dbCloseArea())
			EndIf
			cQuery  := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PED",.T.,.F.)
			dbSelectArea("QRY_PED")
			QRY_PED->(dbGoTop())
			bEncerrado := .T.
			While !QRY_PED->(EOF())
				nPrecoLista := 0
				nPrecoOrca  := 0
				nQtdOrca    := 0
				IF SCK->(dbSeek(xFilial('SCK')+QRY_PED->C6_PRODUTO+QRY_PED->CJ_NUM))
					nPrecoLista := SCK->CK_PRUNIT
					nPrecoOrca  := SCK->CK_PRCVEN
					nQtdOrca    := SCK->CK_QTDVEN
				EndIF
				AADD(aListPV,{QRY_PED->C5_FILIAL,;
					QRY_PED->CJ_NUM,;
					QRY_PED->C5_CLIENTE,;
					QRY_PED->C5_LOJACLI,;
					GetAdvFVal( "SA1", "A1_NOME", xFilial('SA1')+QRY_PED->C5_CLIENTE+QRY_PED->C5_LOJACLI, 1, "" ),;
					GetAdvFVal( "SA1", "A1_CGC", xFilial('SA1')+QRY_PED->C5_CLIENTE+QRY_PED->C5_LOJACLI, 1, "" ),;
					QRY_PED->C5_ZIDEND,;
					QRY_PED->C5_VEND1,;
					GetAdvFVal( "SA3", "A3_NOME", xFilial('SA3')+QRY_PED->C5_VEND1, 1, "" ),;
					STOD(QRY_PED->C5_EMISSAO),;
					QRY_PED->C5_NUM,;
					QRY_PED->C6_ITEM,;
					QRY_PED->C6_PRODUTO,;
					QRY_PED->C6_DESCRI,;
					QRY_PED->C6_UM,;
					nQtdOrca,;
					QRY_PED->C6_QTDVEN,;
					QRY_PED->C6_QTDENT,;
					nPrecoOrca ,;
					nPrecoLista ,;
					QRY_PED->C6_PRCVEN,;
					QRY_PED->C6_VALOR,;
					QRY_PED->C6_NOTA,;
					QRY_PED->C6_SERIE,;
					STOD(QRY_PED->C6_DATFAT)})
				QRY_PED->(dbSkip())
			END

			IF Len(aListPV) == 0
				MsgAlert('Sem dados para a consulta !!')
				Return
			EndIF

			DEFINE MSDIALOG oDlg TITLE "Consulta de Pedidos" FROM 000, 000  TO 520, 1300 COLORS 0, 16777215 PIXEL
			oBrowse := TWBrowse():New( 020, 003,  645, 220,,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
			oBrowse:SetArray(aListPV)
			oBrowse:nAt := 1
			oBrowse:bLine := { || {aListPV[oBrowse:nAt,01], ;
				aListPV[oBrowse:nAt,02],;
				aListPV[oBrowse:nAt,03],;
				aListPV[oBrowse:nAt,04],;
				aListPV[oBrowse:nAt,05],;
				aListPV[oBrowse:nAt,06],;
				aListPV[oBrowse:nAt,07],;
				aListPV[oBrowse:nAt,08],;
				aListPV[oBrowse:nAt,09],;
				aListPV[oBrowse:nAt,10],;
				aListPV[oBrowse:nAt,11],;
				aListPV[oBrowse:nAt,12],;
				aListPV[oBrowse:nAt,13],;
				aListPV[oBrowse:nAt,14],;
				aListPV[oBrowse:nAt,15],;
				aListPV[oBrowse:nAt,16],;
				aListPV[oBrowse:nAt,17],;
				aListPV[oBrowse:nAt,18],;
				aListPV[oBrowse:nAt,19],;
				aListPV[oBrowse:nAt,20],;
				aListPV[oBrowse:nAt,21],;
				aListPV[oBrowse:nAt,22],;
				aListPV[oBrowse:nAt,23],;
				aListPV[oBrowse:nAt,24],;
				aListPV[oBrowse:nAt,25]}}
			oBrowse:addColumn(TCColumn():new("Filial"      ,{||aListPV[oBrowse:nAt][01]},"@!" ,,,"LEFT"  ,25 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Orçamento"   ,{||aListPV[oBrowse:nAt][02]},"@!" ,,,"LEFT"  ,35 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Cliente"     ,{||aListPV[oBrowse:nAt][03]},"@!" ,,,"LEFT"  ,25 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Loja"        ,{||aListPV[oBrowse:nAt][04]},"@!" ,,,"LEFT"  ,15 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Nome"        ,{||aListPV[oBrowse:nAt][05]},"@!" ,,,"LEFT"  ,50 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("CNPJ"        ,{||aListPV[oBrowse:nAt][06]},"@!" ,,,"LEFT"  ,18 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("ID END"      ,{||aListPV[oBrowse:nAt][07]},"@!" ,,,"LEFT"  ,18 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Vendedor"    ,{||aListPV[oBrowse:nAt][08]},"@!" ,,,"LEFT"  ,18 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Nome"        ,{||aListPV[oBrowse:nAt][09]},"@!" ,,,"LEFT"  ,30 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Emissão"     ,{||aListPV[oBrowse:nAt][10]},"@!" ,,,"LEFT"  ,20 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Pedido"      ,{||aListPV[oBrowse:nAt][11]},"@!" ,,,"LEFT"  ,25 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Item"        ,{||aListPV[oBrowse:nAt][12]},"@!" ,,,"LEFT"  ,15,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Produto"     ,{||aListPV[oBrowse:nAt][13]},"@!" ,,,"LEFT"  ,30 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Descrição"   ,{||aListPV[oBrowse:nAt][14]},"@!" ,,,"LEFT"  ,80 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("UM"          ,{||aListPV[oBrowse:nAt][15]},"@!" ,,,"LEFT"  ,15 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Qtd.Orça"    ,{||aListPV[oBrowse:nAt][16]},"@E 999,999,999.99" ,,,"RIGHT",40 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Qtd.Pedido"  ,{||aListPV[oBrowse:nAt][17]},"@E 999,999,999.99" ,,,"RIGHT",40 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Qtd.Entregue",{||aListPV[oBrowse:nAt][18]},"@E 999,999,999.99" ,,,"RIGHT",40 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Preço Orça." ,{||aListPV[oBrowse:nAt][19]},"@E 999,999,999.99" ,,,"RIGHT",40 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Preço Lista" ,{||aListPV[oBrowse:nAt][20]},"@E 999,999,999.99" ,,,"RIGHT",40 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Preço Pedido",{||aListPV[oBrowse:nAt][21]},"@E 999,999,999.99" ,,,"RIGHT",40 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Total"       ,{||aListPV[oBrowse:nAt][22]},"@E 999,999,999.99" ,,,"RIGHT",40 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Nota Fiscal" ,{||aListPV[oBrowse:nAt][23]},"@!" ,,,"LEFT"  ,30 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Serie"       ,{||aListPV[oBrowse:nAt][24]},"@!" ,,,"LEFT"  ,20 ,.F.,.F.,,,,,))
			oBrowse:addColumn(TCColumn():new("Data"        ,{||aListPV[oBrowse:nAt][25]},"@!" ,,,"LEFT"  ,20 ,.F.,.F.,,,,,))

			oBtn := TButton():New( 003, 595, "Sair"  ,oDlg,{|| oDlg:End()}   ,050,011,,,,.T.,,"",,,,.F. )
			oBtn := TButton():New( 245, 595, "Excel"  ,oDlg,{|| Processa( {|| GeraExcel()  },'Aguarde...', 'Exportando para Excel',.F. )	}   ,050,011,,,,.T.,,"",,,,.F. )

			ACTIVATE MSDIALOG oDlg CENTERED
		EndIF
		SCJ->(RestArea(cAreaSCJ))
		SCJ->(dbSetOrder(1))
	EndIF
Return


/*/
	{Protheus.doc} Val_dados
	Validar os dados da tela de efetivação do Orçamento.

	Rotina baseada no padrão

	@author Marcelo Carneiro
	@since 16/02/2018

	@type Function
	@param
	@return _lRet
/*/

Static Function Val_dados
	Local nPosQtd    := aScan( aCabDados, { |x| Alltrim(x[2]) == 'CK_QUANT' })
	Local nPosSaldo  := aScan( aCabDados, { |x| Alltrim(x[2]) == 'CK_SALDO' })
	Local nX         := 0
	Local bQuantZero := .T.
	Local bRet       := .T.

	For nX := 1 To Len( oGet:aCols )
		IF (oGet:aCols[nX,nPosQtd]  <> 0 )
			bQuantZero := .F.
		Endif
		IF Empty(oGet:aCols[nX,9]) .OR. Empty(oGet:aCols[nX,10])
			MsgAlert('Data não pode estar em branco !!')
			Return .F.
		EndIF
	Next nX
	IF bQuantZero
		MsgAlert('A Quantidade tem que ser maior que zero !!')
		Return .F.
	EndIF

	IF Empty(M->C5_FILIAL) .OR. !ExistCpo('SM0',cEmpAnt+M->C5_FILIAL)
		MsgAlert('Filial em Branco ou não cadastrada  !!')
		Return .F.
	Endif

	IF Empty(M->C5_LOJACLI) .OR. !ExistCpo( "SA1", M->C5_CLIENTE +	M->C5_LOJACLI , 1 )
		MsgAlert('Loja em Branco ou não cadastrada para o Cliente  !!')
		Return .F.
	Endif

	IF Empty(M->C5_ZTPOPER) .OR. !ExistCpo("SX5","DJ"+M->C5_ZTPOPER)
		MsgAlert('Operação em Branco ou não cadastrada  !!')
		Return .F.
	EndIF

	IF !Empty(C5_ZIDEND) .AND. !ExistCPO("SZ9",M->C5_CLIENTE +	M->C5_LOJACLI +M->C5_ZIDEND)
		MsgAlert('Endereço de Entrega Não cadastrado  !!')
		Return .F.
	EndIF

	cFilAnt := M->C5_FILIAL
	bRet := U_MGFFAT05(SCJ->CJ_VEND1, M->C5_CLIENTE, M->C5_LOJACLI, SCJ->CJ_ZTIPPED,.T.)

Return bRet



/*/
	{Protheus.doc} Con_SC5
	Pega a Filial da SC5.

	Rotina baseada no padrão

	@author Marcelo Carneiro
	@since 16/02/2018

	@type Function
	@param
	@return
/*/
Static Function Con_SC5

	Local cArea  := GetArea()
	Local cFilSCJ := cFilAnt

	Private Inclui    := .F.
	Private Altera    := .T.
	Private nOpca     := 1
	Private cCadastro := "Pedido de Vendas"
	Private aRotina   := {}

	IF aListPV[oBrowse:nAt,07] <> 0
		SC5->(dbGoTo(aListPV[oBrowse:nAt,07]))
		cFilAnt := SC5->C5_FILIAL

		MatA410(Nil, Nil, Nil, Nil, "A410Visual")
	EndIF

	cFilAnt := cFilSCJ
	RestArea(cArea)

Return


/*/
	{Protheus.doc} Atu_Status
	Atualização do Status.

	Rotina baseada no padrão

	@author Marcelo Carneiro
	@since 16/02/2018

	@type Function
	@param
	@return
/*/
Static Function Atu_Status

	Local cAreaSCJ   := SCJ->(GetArea())
	Local cQuery     := ''
	Local bEncerrado := .F.


	SCJ->(DbOrderNickName('STATUS'))
	SCJ->(dbSeek('B'))
	While SCJ->(!EOF()) .AND. SCJ->CJ_STATUS  == 'B'
		IF Empty(SCJ->CJ_ZMESTRE) .AND. TemSaldo(SCJ->CJ_FILIAL,SCJ->CJ_NUM)
			cQuery := " SELECT CK_FILVEN, CK_NUMPV  "
			cQuery += " FROM "+RetSQLName("SCJ")+" SCJ, "+RetSQLName("SCK")+" SCK"
			cQuery += " WHERE CJ_FILIAL      = '" + SCJ->CJ_FILIAL + "' "
			cQuery += "   AND CJ_ZMESTRE     = '" + SCJ->CJ_NUM + "' "
			cQuery += "   AND CJ_FILIAL 	 = CK_FILIAL "
			cQuery += "   AND CJ_NUM 		 = CK_NUM "
			cQuery += "   AND SCJ.D_E_L_E_T_ = ' ' "
			cQuery += "   AND SCK.D_E_L_E_T_ = ' ' "
			cQuery += " GROUP BY CK_FILVEN, CK_NUMPV "
			If Select("QRY_PED") > 0
				QRY_PED->(dbCloseArea())
			EndIf
			cQuery  := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PED",.T.,.F.)
			dbSelectArea("QRY_PED")
			QRY_PED->(dbGoTop())
			bEncerrado := .T.
			While !QRY_PED->(EOF())
				IF SC5->(dbSeek(QRY_PED->CK_FILVEN+QRY_PED->CK_NUMPV))
					IF !(!Empty(SC5->C5_NOTA) .Or. SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ) .And. (Empty(SC5->C5_ZBLQRGA) .or. SC5->C5_ZBLQRGA=="L"))
						bEncerrado := .F.
					EndIF
				EndIF
				QRY_PED->(dbSkip())
			End
			IF bEncerrado
				Reclock("SCJ",.F.)
				SCJ->CJ_STATUS :='E'
				SCJ->(MsUnlock())
			EndIF
		EndIF
		SCJ->(dbSkip())
	END
	SCJ->(RestArea(cAreaSCJ))


Return


/*/
	{Protheus.doc} TemSaldo
	Verifica se tem saldo no orçamento para geração do pedido.

	Rotina baseada no padrão

	@author Marcelo Carneiro
	@since 16/02/2018

	@type Function
	@param
	@return
/*/
Static Function TemSaldo(cCJ_FILIAL,cCJ_NUM)

	Local cAreaSCJ  := SCJ->(GetArea())
	local aSaldo    := {}
	Local bTemSaldo := .F.
	Local nI        := 0

	dbSelectArea('SCK')
	SCK->(dbSetOrder(1))
	SCK->(dbSeek(cCJ_FILIAL+cCJ_NUM))
	While SCK->(!EOF()) .AND. cCJ_FILIAL+cCJ_NUM  == SCK->(CK_FILIAL+CK_NUM)
		AAdd(aSaldo,{SCK->CK_ITEM+SCK->CK_PRODUTO, SCK->CK_QTDVEN, 0 })
		SCK->(dbSkip())
	END

	cChave  := SCJ->CJ_FILIAL+SCJ->CJ_NUM

//Atualiza Saldo do Orçamento
	SCJ->(DbOrderNickName('MESTRE'))
	SCJ->(dbSeek(cChave))
	While SCJ->(!EOF()) .AND. SCJ->(CJ_FILIAL+CJ_ZMESTRE)  == cChave
		SCK->(dbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
		While SCK->(!EOF()) .AND. SCJ->(CJ_FILIAL+CJ_NUM)  == SCK->(CK_FILIAL+CK_NUM)
			nPos := AScan(aSaldo,{|x|  x[1] == SCK->CK_ITEM+SCK->CK_PRODUTO })
			IF nPos <> 0
				aSaldo[nPos,3] += SCK->CK_QTDVEN
			EndIF
			SCK->(dbSkip())
		END
		SCJ->(dbSkip())
	END
	For nI := 1 To Len(aSaldo)
		IF aSaldo[nI,2] - aSaldo[nI,3] > 0
			bTemSaldo := .T.
		EndIF
	Next nI
	SCJ->(RestArea(cAreaSCJ))

Return bTemSaldo



/*/
	{Protheus.doc} GeraExcel
	Gera Excel do Orçamento.

	Rotina baseada no padrão

	@author Marcelo Carneiro
	@since 16/02/2018

	@type Function
	@param
	@return
/*/
Static Function GeraExcel()

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return
	EndIf

	aCabDados := {  "Filial"      ,;
		"Orçamento"   ,;
		"Cliente"     ,;
		"Loja"        ,;
		"Nome"        ,;
		"CNPJ"        ,;
		"ID END"      ,;
		"Vendedor"    ,;
		"Nome"        ,;
		"Emissão"     ,;
		"Pedido"      ,;
		"Item"        ,;
		"Produto"     ,;
		"Descrição"   ,;
		"UM"          ,;
		"Qtd.Orça"    ,;
		"Qtd.Pedido"  ,;
		"Qtd.Entregue",;
		"Preço Orça." ,;
		"Preço Lista" ,;
		"Preço Pedido",;
		"Total"       ,;
		"Nota Fiscal" ,;
		"Serie"       ,;
		"Data"        }
	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({ {"ARRAY", 'Consulta', aCabDados, aListPV} }) })

Return



/*/
	{Protheus.doc} FAT87VAL
	Validação do Orçamento para geração dop pedido.

	Rotina baseada no padrão

	@author Marcelo Carneiro
	@since 16/02/2018

	@type Function
	@param
	@return
/*/
User Function FAT87VAL
	Local bRet       := .T.
	Local nX         := 0
	Local nPos       := oGet:oBrowse:nColPos
	Local nPosMin    := aScan( aCabDados, { |x| Alltrim(x[2]) == 'CK_ZDTMIN' })
	Local nPosMax    := aScan( aCabDados, { |x| Alltrim(x[2]) == 'CK_ZDTMAX' })


	IF oGet:oBrowse:nColPos == nPosMin .OR. oGet:oBrowse:nColPos == nPosMax
		IF MsgNOYES('Replicar alteração para todos os itens ?')
			For nX := 1 To Len( oGet:aCols )
				IF nPos  == nPosMin
					oGet:aCols[nX][nPos] := M->CK_ZDTMIN
				Else
					oGet:aCols[nX][nPos] := M->CK_ZDTMAX
				EndIF
			Next nX
			oGet:ForceRefresh()
		EndIf
	EndIF

Return bRet



/*/
	{Protheus.doc} xFAT87PED
	Carrrega os valores do orçamento para o pedido.

	Rotina baseada no padrão

	@author Marcelo Carneiro
	@since 16/02/2018

	@type Function
	@param
	@return
/*/
User Function xFAT87PED(aParametros)
	Local cNome             := ''
	Local _cFilial          := aParametros[1]
	Local _nRecno           := aParametros[2]
	Local _ZTPOPER          := aParametros[3]
	Local _ZDTEMBA          := aParametros[4]
	Local _FECENT           := aParametros[5]
	Local _MENNOTA          := aParametros[6]
	Local _XACONDC          := aParametros[7]
	Local _XDSCARG          := aParametros[8]
	Local _XVLDESC          := aParametros[09]
	Local _XOBSPED          := aParametros[10]
	Local _ZIDEND           := aParametros[11]
	Local _aDatas           := aParametros[12]
	Local _Cliente          := aParametros[13]
	Local _Loja             := aParametros[14]
	Local _Zobs             := aParametros[15]
	Local _Xagenda			:= aParametros[16]
	Local _Xtprod			:= aParametros[17]
	Local _cKeyOrc			:= aParametros[18]	// RVBJ

	Local nI				:= 0
	Local aSC5				:= {}
	Local aSC6				:= {}
	Local aErro				:= {}
	Local cErro				:= ""
	Local aLine				:= {}
	Local nStackSX8         := 0
	Local cItemSC6			:= ""
	Local bRet              := .T.
	Local nPos              := 0

	Private lMsHelpAuto     := .T.
	Private lMsErroAuto     := .F.
	Private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros
	Private _aMatriz   := {"01","010001"}
	Private lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"

	RpcSetType(3)
	RpcSetEnv('01',_cFilial)

	dbSelectArea('SCK')
	SCK->(dbSetOrder(1))

	dbSelectArea('SCJ')
	SCJ->(dbSetOrder(1))
	SCJ->(dbGoTo(_nRecno))

	nStackSX8 := GetSx8Len()

	aSC5 := {}
	AAdd(aSC5, {'C5_FILIAL'   	, _cFilial						, NIL})
	AAdd(aSC5, {'C5_TIPO'   	, "N"							, NIL})
	AAdd(aSC5, {'C5_CLIENTE'	, _Cliente				     	, NIL})
	AAdd(aSC5, {'C5_LOJACLI'	, _Loja						    , NIL})
	AAdd(aSC5, {'C5_ZTIPPED'	, SCJ->CJ_ZTIPPED				, NIL})
	AAdd(aSC5, {'C5_TABELA'		, SCJ->CJ_TABELA				, NIL})
	AAdd(aSC5, {'C5_TIPOCLI'	, "R"							, NIL})
	AAdd(aSC5, {'C5_CONDPAG'	, SCJ->CJ_CONDPAG				, NIL})
	AAdd(aSC5, {'C5_ZTPOPER'	, _ZTPOPER						, NIL})
	AAdd(aSC5, {'C5_VEND1'		, SCJ->CJ_VEND1					, NIL})
	AAdd(aSC5, {'C5_ZDTEMBA'    , _ZDTEMBA						, NIL})
	AAdd(aSC5, {'C5_FECENT'		, _FECENT						, NIL})
	AAdd(aSC5, {'C5_XTPROD'		, _Xtprod						, NIL})
	AAdd(aSC5, {'C5_XAGENDA'	, _Xagenda						, NIL})
	AAdd(aSC5, {'C5_ZOBS'		, _Zobs							, NIL})
	AAdd(aSC5, {'C5_ZORCAME'	, SCJ->CJ_ZMESTRE				, NIL})
	IF !EMPTY(_MENNOTA)
		AAdd(aSC5, {'C5_MENNOTA'	, _MENNOTA					, NIL})
	EndIF
	IF !EMPTY(_XACONDC)
		AAdd(aSC5, {'C5_XACONDC'	, _XACONDC	   				, NIL})
	EndIF
	IF !EMPTY(_XDSCARG)
		AAdd(aSC5, {'C5_XDSCARG'	, _XDSCARG	  				, NIL})
	EndIF

	IF !EMPTY(_XVLDESC)
		AAdd(aSC5, {'C5_XVLDESC'	,_XVLDESC	  				, NIL})
	EndIF
	IF !EMPTY(_XOBSPED)
		AAdd(aSC5, {'C5_XOBSPED'	,_XOBSPED	  				, NIL})
	EndIF
	IF !Empty(_ZIDEND )
		AAdd(aSC5, {'C5_ZIDEND'		,_ZIDEND					, NIL})
	EndIF
	AAdd(aSC5, {'C5_TPFRETE'	, SCJ->CJ_TPFRET , NIL})

	aSC6 := {}

	cItemSC6 := ""
	cItemSC6 := StrZero ( 0 , TamSX3("C6_ITEM")[1] )


	SCK->(dbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
	While SCK->(!EOF()) .AND. SCJ->(CJ_FILIAL+CJ_NUM)  == SCK->(CK_FILIAL+CK_NUM)
		cItemSC6 := Soma1(cItemSC6)
		aLine := {}
		AAdd(aLine, {'C6_ITEM'		, cItemSC6			, NIL})
		// RVBJ
		AAdd(aLine, {'C6_PRODUTO'	, SCK->CK_PRODUTO  	, NIL})
		AAdd(aLine, {'C6_QTDVEN'	, SCK->CK_QTDVEN	, NIL})
		AAdd(aLine, {'C6_PRCVEN'	, SCK->CK_PRCVEN	, NIL})
		AAdd(aLine, {'C6_PRUNIT'	, SCK->CK_PRUNIT    , NIL})
//		AAdd(aLine, {'C6_OPER'		, _ZTPOPER		, NIL})
		nPos := aScan( _aDatas, { |x| x[1] == SCK->CK_PRODUTO })
		IF nPos <> 0
			AAdd(aLine, {'C6_ZDTMIN'	, _aDatas[nPos,02]	, NIL})
			AAdd(aLine, {'C6_ZDTMAX'	, _aDatas[nPos,03]	, NIL})
			AAdd(aLine, {'C6_NUMORC'	, SCJ->CJ_ZMESTRE  	, NIL})
		EndIF
		AAdd( aSC6, aLine )
		SCK->(dbSkip())
	EndDo
	aCols   := {}
	aHeader := {}
	msExecAuto({|x,y,z|MATA410(x,y,z)}, aSC5, aSC6, 3)
	IF lMsErroAuto
		While GetSX8Len() > nStackSX8
			ROLLBACKSX8()
		EndDo

		aErro := GetAutoGRLog() // Retorna erro em array
		cErro := ""

		for nI := 1 to len(aErro)
			cErro += aErro[nI] + CRLF
		next nI
		//ConOut(cErro)
		// RVBJ - Vai gravar no orçamento Principal
		IF SCJ->(dbSeek(_cKeyOrc))
			cNome := Alltrim(_cKeyOrc+StrTran(Time(),":","")+".txt")
			Reclock("SCJ",.F.)
			SCJ->CJ_ZMOTIVO := cNome
			SCJ->(MsUnlock())
			MemoWrite(cNome,cErro)
		Endif
		bRet:= .F.
	Else

		While GetSX8Len() > nStackSX8
			CONFIRMSX8()
		Enddo
		SCK->(dbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
		While SCK->(!EOF()) .AND. SCJ->(CJ_FILIAL+CJ_NUM)  == SCK->(CK_FILIAL+CK_NUM)
			Reclock("SCK",.F.)
			SCK->CK_NUMPV := SC5->C5_NUM
			SCK->(MsUnlock())
			SCK->(dbSkip())
		END
		bRet := .T.
	EndIF

Return bRet



/*/
	{Protheus.doc} FAT87DTVL
	Validar a Data de Validade do Orçamento,
	caso esteja vencida e o usuário não tiver permissão,
	o campo fica desabilitado.

	Rotina baseada no padrão

	@author Cláudio Alves
	@since 30/10/2019

	@type Function
	@param
	@return _lRet
/*/
User Function FAT87DTVL()
	local _lRet		:=	.F.
	local _cUsers	:=	SuperGetMv("MGF_ORCVAL",,"004697|004710|004699|004692|004693|004694|004695|004696|004703|004705|004708|004697|004701")

	if dDataBase <= SCJ->CJ_VALIDA
		_lRet := .T.
	endif

	if !_lRet .and. __cUserId $ _cUsers
		_lRet := .T.
	endif

Return _lRet
