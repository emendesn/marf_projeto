#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)


/*
=====================================================================================
Programa............: MGFTAS06
Autor...............: Marcelo Carneiro
Data................: 06/05/2017
Descricao / Objetivo: Integração Protheus-Taura, Validação do Pedido de Venda
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: xTipo 3-Inclusão, 4-Alteração, converte memo p/caracter cObs
=====================================================================================
*/

User Function MGFTAS06(xTipo)

Local bRet     := .T.
Local cQuery   := ''
Local bTaura   := .F.
Local aRet     := {}
Local cTamErro := TAMSX3("C5_ZERRO")[1]
Local bKey	   := .F.

local cUpdSC6	:= ""

Private cSC5     := ''
Private lIsBlind :=  IsBlind() .OR. Type("__LocalDriver") == "U"
Private bSFA     := ( lIsBlind .OR. isInCallStack("U_MGFFAT53")  .OR. isInCallStack("U_runFAT53") .OR. isInCallStack("U_runFATA5") )

// rotina de importacao de ordem de embarque
If IsInCallStack("GravarCarga") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("EECFATCP") .or. IsInCallStack("INCPEDEXP") .or. IsInCallStack("U_INCPEDEXP")
	Return(.T.)
Endif

// rotina de exclusao de nota de saida, desfaz fis45
If (IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
	Return(.T.)
Endif

// alteracao do pedido de exportacao, somente alteracao de campos permitidos
// nao envia pedido para o taura
If IsInCallStack("EECAP100") //.and. IsBlind()
	If Type("nOpcAux") != "U" .and. nOpcAux == 4 //ALTERAR
		If Type("__lRetStatPV") != "U" .and. !__lRetStatPV .and. SC5->C5_ZTAUINT == "S"
			Return(.T.)
		Endif
	Endif
Endif

/*
IF xTipo == 4 .or. xTipo == 5 // 4 = Alteração  - 5 = exclusão
	cSC5    := 'M'
Else
	cSC5    := 'SC5'
EndIF
*/
// TRECHO ACIMA COMENTADO POIS FONTE SERA CHAMADO SEMPRE PELO M410STTS
cSC5    := 'SC5'

dbSelectArea('SZJ')
SZJ->(dbSetOrder(1))
IF SZJ->(dbSeek(xFilial('SZJ')+&(cSC5+'->C5_ZTIPPED')))

	if &(cSC5+'->C5_XRESERV') == 'N'
		// SE PEDIDO NAO RESERVAR ESTOQUE NAO ENVIA PARA O TAURA
		bTaura	:= .F.
		bKey	:= .F.
	else
		IF SZJ->ZJ_TAURA == 'S'
			bTaura := .T.
		EndIF
		IF SZJ->ZJ_KEYCONS == 'S'
			bKey := .T.
		EndIF
	endif
EndIF
u_TAS06_DelRegra(&(cSC5+'->C5_FILIAL'),&(cSC5+'->C5_NUM'))
IF bTaura .or. bKey
    aRet   := U_TAS06EnviaPV(xTipo)
     // Erro de Comunicação
    IF aRet[01] == 3
  	
	  	IF xTipo == 3 //Inclusão
  	
	  		If bTaura
		    	u_TAS06_GRV(&(cSC5+'->C5_FILIAL'),&(cSC5+'->C5_NUM'),'01','000088')
		    Endif
	
		    Reclock("SC5",.F.)
 			SC5->C5_ZBLQTAU := 'S'
 			SC5->C5_ZERRO   := 'Não foi possível integrar com o Taura.!!'
 			SC5->C5_ZTAUINT := "E" // erro
			SC5->(MsUnlock())
	  
	    ElseIF xTipo == 4 //Alteração
	  
	    	if isInCallStack("U_MGFFAT53") .or. isInCallStack("U_runFAT53") .or. isInCallStack("U_runFATA5")
	    		conout('[MGFTAS06] [SFA] Não foi possível integrar com o Taura.!!.!!')
	    	else
	    		MsgAlert('não foi possível integrar com o Taura.!!')
				If IsInCallStack("U_MGFFATBW")
					AutoGrLog('não foi possível integrar com o Taura.!!' +  chr(13) + chr(10) + " Alteração não realizada." +  chr(13) + chr(10)  )
				EndIf 
	    	endif
	  
	        bRet := .F.
	  
	    EndIF
    EndIF
    
	// Erro no Taura
    IF aRet[01] == 2
    
		 If	bTaura
         	u_TAS06_GRV(&(cSC5+'->C5_FILIAL'),&(cSC5+'->C5_NUM'),'01','000089')// Cria uma regra de bloqueio TAURA
         Endif
    
	     IF !bSFA
         	If bTaura
         		MsgAlert('O Pedido criou uma Regra de Bloqueio Taura : '+aRet[02])
				If IsInCallStack("U_MGFFATBW")
					AutoGrLog('O Pedido criou uma Regra de Bloqueio Taura : ' +aRet[02] +  chr(13) + chr(10) + " Alteração não realizada." +  chr(13) + chr(10) )
				EndIf 
         	Endif	
	     else
	     	If bTaura
	     		conout('[MGFTAS06] [SFA] O Pedido criou uma Regra de Bloqueio Taura : '+aRet[02])
	     	Endif
	   	 EndIF
	
		/*
	   	 IF xTipo == 3
	   	 	Reclock("SC5",.F.)
 			SC5->C5_ZBLQTAU := 'N'
 			SC5->C5_ZERRO   := SUBSTR(aRet[02],1,cTamErro)
 			SC5->C5_ZTAUINT := "E" // erro
			SC5->(MsUnlock())
	   	 Else
	   	 	M->C5_ZBLQTAU := 'N'
	   	 	M->C5_ZERRO   := SUBSTR(aRet[02],1,cTamErro)
	   	 EndIF
		*/
	
		// TRECHO ACIMA COMENTADO POIS FONTE SERA CHAMADO SEMPRE PELO M410STTS
	   	 IF xTipo == 3 // Inclusão
	   	 	Reclock("SC5",.F.)
 			SC5->C5_ZBLQTAU := 'N'
 			SC5->C5_ZERRO   := SUBSTR(aRet[02],1,cTamErro)
 			SC5->C5_ZTAUINT := "E" // erro
			SC5->(MsUnlock())
	   	 Else
	   	 	SC5->C5_ZBLQTAU := 'N'
	   	 	SC5->C5_ZERRO   := SUBSTR(aRet[02],1,cTamErro)
	   	 EndIF
    
	EndIF

    // Conseguiu integrar com o Taura.
    IF aRet[01] == 1
		/*
         IF xTipo == 3
	   	 	Reclock("SC5",.F.)
 			SC5->C5_ZBLQTAU := 'N'
 			SC5->C5_ZERRO   := ' '
 			SC5->C5_ZTAUREE := 'N'
			SC5->C5_ZTAUINT := 'S'
			SC5->C5_ZLIBENV := 'N'
			SC5->(MsUnlock())
	   	 Else
	   	 	M->C5_ZBLQTAU := 'N'
	   	 	M->C5_ZERRO   := ''
	   	 	M->C5_ZTAUREE := 'N'
			M->C5_ZTAUINT := 'S'
			M->C5_ZLIBENV := 'N'
	   	 EndIF
		*/
		// TRECHO ACIMA COMENTADO POIS FONTE SERA CHAMADO SEMPRE PELO M410STTS
		reclock("SC5",.F.)
		SC5->C5_ZBLQTAU	:= 'N'
		SC5->C5_ZERRO	:= ' '
		SC5->C5_ZTAUREE	:= 'N'
		SC5->C5_ZTAUINT	:= 'S'
		SC5->C5_ZLIBENV	:= 'N'
		SC5->(MsUnlock())

		cUpdSC6 := ""
		cUpdSC6 += "UPDATE " + retSQLName("SC6")												+ chr(13) + chr(10)
		cUpdSC6 += " SET"																		+ chr(13) + chr(10)
		cUpdSC6 += " 	C6_XULTQTD = C6_QTDVEN"													+ chr(13) + chr(10)
		cUpdSC6 += " WHERE"																		+ chr(13) + chr(10)
		cUpdSC6 += " 	R_E_C_N_O_ IN"															+ chr(13) + chr(10)
		cUpdSC6 += " 	("																		+ chr(13) + chr(10)
		cUpdSC6 += " 		SELECT SUBSC6.R_E_C_N_O_"											+ chr(13) + chr(10)
		cUpdSC6 += " 		FROM "			+ retSQLName("SC5") + " SUBSC5"						+ chr(13) + chr(10)
		cUpdSC6 += " 		INNER JOIN " 	+ retSQLName("SC6") + " SUBSC6"						+ chr(13) + chr(10)
		cUpdSC6 += " 		ON"																	+ chr(13) + chr(10)
		cUpdSC6 += " 			SUBSC6.C6_NUM		=	SUBSC5.C5_NUM"							+ chr(13) + chr(10)
		cUpdSC6 += " 		AND	SUBSC6.C6_FILIAL	=	SUBSC5.C5_FILIAL"						+ chr(13) + chr(10)
		cUpdSC6 += " 		AND	SUBSC6.D_E_L_E_T_	<>	'*'"									+ chr(13) + chr(10)
		cUpdSC6 += " 		WHERE"																+ chr(13) + chr(10)
		cUpdSC6 += "			SUBSC5.R_E_C_N_O_	=	" + allTrim( str( SC5->( recno() ) ) )	+ chr(13) + chr(10)
		cUpdSC6 += " 		AND	SUBSC5.D_E_L_E_T_	<>	'*'"									+ chr(13) + chr(10)
		cUpdSC6 += " 	)"																		+ chr(13) + chr(10)

		if tcSQLExec( cUpdSC6 ) < 0
			conout( "não foi possível executar UPDATE." + chr(13) + chr(10) + tcSqlError() )
		endif
    EndIF

EndIF

Return bRet

****************************************************************************************************************************
User Function TAS06EnviaPV(nTipo)

Local cURLPost := Alltrim(GetMv("MGF_URLTPV"))
Local cPV      := &(cSC5+'->C5_NUM')
Local oItens   := Nil
Local lRet     := .F.
Local nCnt     := 0
Local cChave   := cPV
Local aRet     := {}

Private nX       := 0
Private oPV      := Nil
Private oWSPV    := Nil
Private cStatus  := ''
Private bUsaCols := IIF(nTipo == 3 , .T., .F.) //IIF((nTipo == 3 .or. nTipo == 4) , .T., .F.) //IIF(nTipo == 3 , .T., .F.)
//Private bUsaCols := .T.//IIF(nTipo == 4 .or. nTipo == 5 , .T., .F.)

IF 		nTipo == 3
    	cStatus := '1' // Inclusão
ElseIf 	nTipo == 5
		cStatus := '3' // Exclusão
Else
    	cStatus := '2' // Alteração
EndIF

oPV := Nil
oPV := T06_GRAVARPV():New()
oPV:GravarPVCab(cStatus)

IF bUsaCols
	For nX := 1 to Len(aCols)
		If !gdDeleted(nX)
			oItens := Nil
			oItens := TAS06_ItensPV():New()
			oPV:GravarPVItens(oItens)
		Endif
	Next nX
Else
	SC6->(dbSetorder(1))
	SC6->(dbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
	While SC6->(!Eof()) .and. SC5->C5_FILIAL+SC5->C5_NUM == SC6->C6_FILIAL+SC6->C6_NUM
		oItens := Nil
		oItens := TAS06_ItensPV():New()
		oPV:GravarPVItens(oItens)
		SC6->(dbSkip())
	End
EndIF

oWSPV := MGFINT53():New(cURLPost,oPV/*oObjToJson*/,/*nKeyRecord*/,/*"SC5"/*cTblUpd*/,/*"C5_ZTAUFLA"/*cFieldUpd*/,AllTrim(GetMv("MGF_MONI01"))/*cCodint*/,AllTrim(GetMv("MGF_MONT08")),cChave/*cChave*/,.F./*lDeserialize*/,.F.,.T.)

StaticCall(MGFTAC01,ForcaIsBlind,oWSPV)

If 		!(oWSPV:lOk )
		aRet := {3, ''}
ElseIf 	oWSPV:nStatus == 1
		aRet := {1, 'Integrado Taura'}
ElseIf 	oWSPV:nStatus == 2
		aRet := {2, oWSPV:cDetailInt}
Endif

Return aRet
*********************************************************************************************************************************************************
Class T06_GRAVARPV

	Data Acao					as String
	Data Filial					as String
	Data Pedido					as String
	Data TipoPedidoERP			as String
	Data TipoPedido	   			as String
	Data Cliente				as String
	Data ClienteLoja			as String
	Data DataEmissao			as String
	Data DataEmbarque			as String
	Data DataEntrega			as String
	Data Status					as String
	Data TipoFrete				as String
	Data Observacao				as String
	Data CodigoBarras			as String
	Data EnderecoEntrega		as String
	Data PedidoCliente			as String
	Data ApplicationArea		as ApplicationArea
	Data Documento				as String
	Data Inscricao_Estadual		as String
	Data UF						as String
	Data Data_Nascimento		as String
	Data Inscricao_Suframa		as String
	Data Validade_Suframa		as String
	Data Consulta_Hab			as String
	Data Taura					as String
	Data Produtor_Rural			as String
	Data NumeroExp    			as String	// Paulo da Mata - RTASK0011075 - 19/05/2020
	Data ClienteEtiqueta        as String	// Paulo da Mata - RTASK0011075 - 19/05/2020

	Data Itens					as Array

	Method New()
	Method GravarPVCab()
	Method GravarPVItens()

Return
*********************************************************************************************************************************************************
Method New() Class T06_GRAVARPV

::ApplicationArea := ApplicationArea():New()

Return
*********************************************************************************************************************************************************
Method GravarPVCab(cStatus) Class T06_GRAVARPV

Local cStringTime := "T00:00:00"
Local cCliente    := ""
Local cLoja       := ""
Local cObs        := ""

If &(cSC5+'->C5_TIPO') $ ("D/B")
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+&(cSC5+'->C5_CLIENTE')+&(cSC5+'->C5_LOJACLI')))
		If !Empty(SA2->A2_ZCODMGF)
			cCliente := SA2->A2_ZCODMGF
		Else
			cCliente := SA2->A2_COD
			cLoja := SA2->A2_LOJA
		Endif
		::Documento          := SA2->A2_CGC
		::Inscricao_Estadual := SA2->A2_INSCR
		::UF                 := SA2->A2_EST
		::Data_Nascimento    := IIf(!Empty(SA2->A2_DTNASC),Subs(dTos(SA2->A2_DTNASC),1,4)+"-"+Subs(dTos(SA2->A2_DTNASC),5,2)+"-"+Subs(dTos(SA2->A2_DTNASC),7,2)+cStringTime,"")
		::Inscricao_Suframa  := ""
		::Validade_Suframa   := ""
	Endif
Else
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+&(cSC5+'->C5_CLIENTE')+&(cSC5+'->C5_LOJACLI')))
		If !Empty(SA1->A1_ZCODMGF) // campo que conterah o codigo do cliente no sistema da Marfrig. ***verificar o nome que este campo serah criado
			cCliente := SA1->A1_ZCODMGF
		Else
			cCliente := SA1->A1_COD
			cLoja    := SA1->A1_LOJA
		Endif
		::Documento          := SA1->A1_CGC
		::Inscricao_Estadual := SA1->A1_INSCR
		::UF                 := SA1->A1_EST
		::Data_Nascimento    := IIf(!Empty(SA1->A1_DTNASC),Subs(dTos(SA1->A1_DTNASC),1,4)+"-"+Subs(dTos(SA1->A1_DTNASC),5,2)+"-"+Subs(dTos(SA1->A1_DTNASC),7,2)+cStringTime,IIf(!Empty(SA1->A1_DTCAD),Subs(dTos(SA1->A1_DTCAD),1,4)+"-"+Subs(dTos(SA1->A1_DTCAD),5,2)+"-"+Subs(dTos(SA1->A1_DTCAD),7,2)+cStringTime,""))
		::Inscricao_Suframa  := SA1->A1_SUFRAMA
		::Validade_Suframa   := IIf(SA1->(FieldPos("A1_ZSUFVLD"))>0 .and. !Empty(SA1->A1_ZSUFVLD),Subs(dTos(SA1->A1_ZSUFVLD),1,4)+"-"+Subs(dTos(SA1->A1_ZSUFVLD),5,2)+"-"+Subs(dTos(SA1->A1_ZSUFVLD),7,2)+cStringTime,"")
	Endif
Endif

	//A. Carlos - Incuido chamada função para converter memo em caracter
	if M->C5_ZTIPPED == "EX"
		cObs := allTrim( M->EE7_ZOBSND ) + " -- " + allTrim( M->EE7_ZOBS )
	else
		cObs := allTrim( M->C5_ZOBS ) + " -- " + allTrim( M->C5_XOBSPED )
	endif

::Acao            := cStatus
::Filial 		  := &(cSC5+'->C5_FILIAL')
::Pedido 		  := Alltrim(&(cSC5+'->C5_NUM'))
::TipoPedidoERP   := Alltrim(&(cSC5+'->C5_TIPO')) //"VE"
::TipoPedido 	  := Alltrim(&(cSC5+'->C5_ZTIPPED')) //"VE"
::Cliente 		  := Alltrim(cCliente)
::ClienteLoja 	  := Alltrim(cLoja)
::DataEmissao 	  := IIf(!Empty(&(cSC5+'->C5_EMISSAO')),Subs(dTos(&(cSC5+'->C5_EMISSAO')),1,4)+"-"+Subs(dTos(&(cSC5+'->C5_EMISSAO')),5,2)+"-"+Subs(dTos(&(cSC5+'->C5_EMISSAO')),7,2)+cStringTime,"")
::DataEmbarque 	  := IIf(!Empty(&(cSC5+'->C5_ZDTEMBA')),Subs(dTos(&(cSC5+'->C5_ZDTEMBA')),1,4)+"-"+Subs(dTos(&(cSC5+'->C5_ZDTEMBA')),5,2)+"-"+Subs(dTos(&(cSC5+'->C5_ZDTEMBA')),7,2)+cStringTime,"")
::DataEntrega 	  := IIf(!Empty(&(cSC5+'->C5_FECENT')),Subs(dTos(&(cSC5+'->C5_FECENT')),1,4)+"-"+Subs(dTos(&(cSC5+'->C5_FECENT')),5,2)+"-"+Subs(dTos(&(cSC5+'->C5_FECENT')),7,2)+cStringTime,"")
IF FWIsInCallStack("U_MGFFATBW")
	::Status 		  := IIf(!Empty(SC5->C5_PEDEXP),"N",IIf(SC5->C5_ZBLQRGA=="B","B","N")) // B=bloqueado,N=Liberado
Else
	::Status          := IIf(!Empty(&(cSC5+'->C5_PEDEXP')),"N","B") //'B'//IIf(&(cSC5+'->C5_ZBLQRGA')=="B","B","N")
EndIf
::TipoFrete 	  := IIf(!Empty(&(cSC5+'->C5_PEDEXP')) .and. Empty(&(cSC5+'->C5_TPFRETE')),EE7->EE7_ZFREFA,&(cSC5+'->C5_TPFRETE')) // este campo quando eh alteracao via rotina automatica, vindo do modulo EEC, estah ficando em branco, sem explicacao, desta forma, foi colocado o tratamento para pegar da tabela neste caso
::Observacao 	  := cObs  //Alltrim(&(cSC5+'->C5_ZOBS'))
::CodigoBarras 	  := Alltrim(&(cSC5+'->C5_ZCODBAR'))
::EnderecoEntrega := cCliente+IIf(Empty(&(cSC5+'->C5_ZIDEND')),"0",Alltrim(Str(Val(&(cSC5+'->C5_ZIDEND')))))  //Alltrim(IIf( Empty(&(cSC5+'->C5_ZIDEND')),"0",&(cSC5+'->C5_ZIDEND')))
::PedidoCliente   := Alltrim(&(cSC5+'->C5_ZPEDCLI'))

// tratamento para forcar reenvio ao keyconsult ( conteudo "S" ), pois se o pedido teve nota emitida em 72hs e ainda tem bloqueio de regra, o campo ::Consulta_Hab vai como "N", o key consult nao reavalia as regras e o bloqueio na SZV nao eh desfeito nunca
::Consulta_Hab 	  := IIf((&(cSC5+'->C5_ZCONFIS') == "S" .or. (GetMv("MGF_TAS012",,.T.) .and. &(cSC5+'->C5_FILIAL') $ GetMv("MGF_TAS014") .and. !Empty(GetMv("MGF_TAS015")) .and. GetAdvFVal("SZJ","ZJ_KEYCONS",xFilial("SZJ")+Alltrim(&(cSC5+'->C5_ZTIPPED')),1,"")=="S" .and. StaticCall(MGFTAS01,AvalRgaKey,Alltrim(&(cSC5+'->C5_NUM'))))),"S",&(cSC5+'->C5_ZCONFIS'))
::Taura			  := IIf(GetAdvFVal("SZJ","ZJ_TAURA",xFilial("SZJ")+&(cSC5+'->C5_ZTIPPED'),1,"")=="S","S","N")
::Produtor_Rural  := IIf(&(cSC5+'->C5_TIPOCLI')=="L","S","N")

// Paulo da Mata - RTASK0011075 - 19/05/2020 - Verifica se o campo C5_ZTIPPED == "IT", Carrega o conteúdo do campo C5_ZNUMEXP
// Paulo da Mata - RTASK0011075 - 19/05/2020 - Verifica se o campo C5_ZTIPPED == "TE", Carrega o conteúdo do campo C5_ZCLIET+C5_ZLJAET
::NumeroExp		  := AllTrim(IIf(&(cSC5+'->C5_ZTIPPED')$"IT|TE",&(cSC5+'->C5_ZNUMEXP'),""))
::ClienteEtiqueta := AllTrim(IIf(&(cSC5+'->C5_ZTIPPED')$"IT|TE",&(cSC5+'->C5_ZCLIET')+&(cSC5+'->C5_ZLJAET'),""))

::Itens	:= {}

Return()
*********************************************************************************************************************************************************
Class TAS06_ItensPV

	Data Filial					as String
	Data Pedido					as String
	Data ExpPed					as String // Paulo da Mata - RTASK0011075 - 12/05/2020
	Data Item					as String
	Data Produto				as String
	Data UnidadeMedida			as String
	Data QuantidadeKGVenda		as Float
	Data PrecoVenda				as Float
	Data QuantidadeCaixa		as Float
	Data DataProducaoMinima		as String
	Data DataProducaoMaxima		as String
	Data DataPedido				as String
	Data TipoPedido				as String
	Data QuantidadeVolumes		as Integer
	Data Observacao				as String

	Method New()

Return
*********************************************************************************************************************************************************
Method New() Class TAS06_ItensPV

Local cStringTime := "T00:00:00"
Local cDataConv   := ''
Local cDtConv1    := ''
Local cDtConv2    := ''
Local cDtMin      := ''
Local cDtMax      := ''
Local cObs        := ""

IF bUsaCols
	::Filial             := &(cSC5+'->C5_FILIAL')
	::Pedido 		     := Alltrim(&(cSC5+'->C5_NUM'))

	::ExpPed             := AllTrim(&(cSC5+'->C5_ZNUMEXP')) // Paulo da Mata - RTASK0011075 - 12/05/2020

	::Item               := aCols[nX,GDFIELDPOS("C6_ITEM")]
	::Produto            := Alltrim(aCols[nX,GDFIELDPOS("C6_PRODUTO")])
	::UnidadeMedida      := Alltrim(aCols[nX,GDFIELDPOS("C6_UM")])
	::QuantidadeKGVenda  := aCols[nX,GDFIELDPOS("C6_QTDVEN")]
	::PrecoVenda         := aCols[nX,GDFIELDPOS("C6_PRCVEN")]
	::QuantidadeCaixa    := aCols[nX,GDFIELDPOS("C6_ZQTDPEC")]

   	cDtConv1    := aCols[nX,GDFIELDPOS("C6_ZDTMIN")]
	cDtConv2    := aCols[nX,GDFIELDPOS("C6_ZDTMAX")]

	IF (cDtConv1 > dDataBase - 10000) .OR. (cDtConv2  <= dDataBase + 9000)
		//Só preenche se tiver data válida
		If !(empty(alltrim(dTos(cDtConv1))))
			cDtMin      := Subs(dTos(cDtConv1),1,4)+"-"+Subs(dTos(cDtConv1),5,2)+"-"+Subs(dTos(cDtConv1),7,2)+cStringTime
		Endif
		If !(empty(alltrim(dTos(cDtConv2))))
			cDtMax      := Subs(dTos(cDtConv2),1,4)+"-"+Subs(dTos(cDtConv2),5,2)+"-"+Subs(dTos(cDtConv2),7,2)+cStringTime
		Endif
	EndIF

	IF M->C5_ZTIPPED = "EX"
		cObs := Alltrim(M->EE7_ZOBSND) + " -- " + Alltrim(M->EE7_ZOBS)
	ELSE
		cObs := Alltrim(M->EE7_ZOBS)
	ENDIF

	::DataProducaoMinima := cDtMin
	::DataProducaoMaxima := cDtMax
	::DataPedido         := IIf(!Empty(&(cSC5+'->C5_EMISSAO')),Subs(dTos(&(cSC5+'->C5_EMISSAO')),1,4)+"-"+Subs(dTos(&(cSC5+'->C5_EMISSAO')),5,2)+"-"+Subs(dTos(&(cSC5+'->C5_EMISSAO')),7,2)+cStringTime,"")
	::TipoPedido         := Alltrim(&(cSC5+'->C5_ZTIPPED')) //"VE"
	::QuantidadeVolumes  := aCols[nX,GDFIELDPOS("C6_ZVOLUME")]
	::Observacao         := cObs  //Alltrim(&(cSC5+'->C5_ZOBS'))
Else
	::Filial             := &(cSC5+'->C5_FILIAL')
	::Pedido 		     := Alltrim(&(cSC5+'->C5_NUM'))
	::ExpPed             := AllTrim(&(cSC5+'->C5_PEDEXP')) // Paulo da Mata - RTASK0011075 - 12/05/2020
	::Item               := SC6->C6_ITEM
	::Produto            := Alltrim(SC6->C6_PRODUTO)
	::UnidadeMedida      := Alltrim(SC6->C6_UM)
	::QuantidadeKGVenda  := SC6->C6_QTDVEN
	::PrecoVenda         := SC6->C6_PRCVEN
	::QuantidadeCaixa    := SC6->C6_ZQTDPEC

 	IF (SC6->C6_ZDTMIN  > dDataBase - 10000) .OR. (SC6->C6_ZDTMAX  <= dDataBase + 9000)
	 	//Só preenche se tiver data válida
		If !(empty(alltrim(dTos(SC6->C6_ZDTMIN))))
			cDtMin      := Subs(dTos(SC6->C6_ZDTMIN),1,4)+"-"+Subs(dTos(SC6->C6_ZDTMIN),5,2)+"-"+Subs(dTos(SC6->C6_ZDTMIN),7,2)+cStringTime
		Endif
		If !(empty(alltrim(dTos(SC6->C6_ZDTMAX))))
			cDtMax      := Subs(dTos(SC6->C6_ZDTMAX),1,4)+"-"+Subs(dTos(SC6->C6_ZDTMAX),5,2)+"-"+Subs(dTos(SC6->C6_ZDTMAX),7,2)+cStringTime
		Endif
	EndIF

	//A. Carlos - Incuido chamada função para converter memo em caracter
    IF M->C5_ZTIPPED = "EX"
		cObs := Alltrim(M->EE7_ZOBSND) + " -- " + Alltrim(M->EE7_ZOBS)
    ELSE
	   cObs := Alltrim(M->EE7_ZOBS)
    ENDIF

	::DataProducaoMinima := cDtMin
	::DataProducaoMaxima := cDtMax
	::DataPedido         := IIf(!Empty(&(cSC5+'->C5_EMISSAO')),Subs(dTos(&(cSC5+'->C5_EMISSAO')),1,4)+"-"+Subs(dTos(&(cSC5+'->C5_EMISSAO')),5,2)+"-"+Subs(dTos(&(cSC5+'->C5_EMISSAO')),7,2)+cStringTime,"")
	::TipoPedido         := Alltrim(&(cSC5+'->C5_ZTIPPED')) //"VE"
	::QuantidadeVolumes  := SC6->C6_ZVOLUME
	::Observacao         := cObs  //Alltrim(&(cSC5+'->C5_ZOBS'))
EndIF

Return()
*********************************************************************************************************************************************************
Method GravarPVItens(oItens) Class T06_GRAVARPV

aAdd(::Itens,oItens)

Return()
*********************************************************************************************************************************************************
User function TAS06_DelRegra(cFilPed,cPedido)
Local cQuery := ''

cQuery := " Delete From  "+RetSqlName("SZV")
cQuery += " Where ZV_FILIAL = '"+cFilPed+"'"
cQuery += "   AND ZV_PEDIDO = '"+cPedido+"'"
cQuery += "   AND ZV_CODRGA IN('000088','000089') "

IF (TcSQLExec(cQuery) < 0)
	bContinua   := .F.

	if isInCallStack("U_MGFFAT53") .or. isInCallStack("U_runFAT53") .or. isInCallStack("U_runFATA5")
		conout( '[MGFTAS06] [SFA] Erro ao Excluir: '+TcSQLError() )
	else
		MsgAlert('Erro ao Excluir: '+TcSQLError())
	endif
EndIF

Return
************************************************************************************************************************************************************
User function TAS06_GRV(cFilPed,cPedido,cITEM,cRegra)

Reclock("SZV",.T.)
SZV->ZV_FILIAL  := cFilPed
SZV->ZV_PEDIDO  := cPedido
SZV->ZV_ITEMPED := cItem
SZV->ZV_SEQ     := 0
SZV->ZV_CODRGA  := cRegra
SZV->ZV_DTBLQ   := dDataBase
SZV->ZV_HRBLQ   := LEFT(Time(),5)
SZV->(MsUnlock())

Return