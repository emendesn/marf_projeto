
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "DBSTRUCT.CH" 
 
  
#define CRLF chr(13) + chr(10)
/*
=====================================================================================
Programa.:              MGFJUR03
Autor....:              Marcelo Carneiro
Data.....:              15/03/2019
Descricao / Objetivo:   Integração Grade de Aprovação SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Aprovação, Reprovação e Historico de uma Garantia/Despesa
=====================================================================================
*/

User Function MGFJUR03(nTipo,xTab)

	Local _cUser	:= RetCodUsr()
	Private cTab 	:= xTab

	dbSelectArea("RD0")
	RD0->(DbOrderNickName("USER"))
	RD0->(dbSeek(_cUser))

	If RD0->RD0_TIPO == "3"
		IF nTipo == 1 .OR. nTipo == 2 //Aprovar ou Reprovar
			JUR03APR(nTipo,cTab)
		Else
			JUR03HIST(cTab) // Historico
		EndIf
	Else
		JurMsgErro("Usuário não tem permissão para utilizar esta rotina.")
	EndIf

Return 
******************************************************************************************************************************
Static Function JUR03HIST(cTab)

Private aIndexNF   := {}
Private cFiltro    := ''
Private bFiltraBrw := ''

Private cCadastro := 'Historico da Grade de Aprovação'
Private aRotina := {}
AADD(aRotina, { 'Pesquisar', 'AxPesqui', 0, 1 })

dbSelectArea('ZJ1')
ZJ1->(dbSetOrder(1))

cFiltro  += " ZJ1_RECNO == "+Alltrim(STR(&(cTab+'->(Recno())'))) 

bFiltraBrw  := {|| FilBrowse('ZJ1',@aIndexNF,@cFiltro) }
Eval(bFiltraBrw)     

mBrowse(6, 1, 22, 75, 'ZJ1')

EndFilBrw('ZJ1',aIndexNF)  


Return                                  
******************************************************************************************************************************
Static Function JUR03APR(nTipo,cTab)

Local aTipo   := U_JUR02_TIPO()                   
Local cSeq    := ''
Local bPassou := .F.
Private aParamBox := {}                                        
Private aRet      := {}

 
IF !aTipo[01]
	MsgAlert('Usuario não configurado como participante/tipo !!')
    Return     
EndIF               
IF !(&(cTab+'->'+cTab+'_XAPROV') $ '12')
	MsgAlert('Situação da Garantia/Despesa não permite a aprovação!!')
	Return
EndIF
IF &(cTab+'->'+cTab+'_XAPROV') == '1' .And. aTipo[02] <> '1'
	MsgAlert('Para Aprovação/Reprovação Juridica o participante tem que ser do tipo Interno !!')
	Return
EndIF
IF &(cTab+'->'+cTab+'_XAPROV') == '2' .And. aTipo[02] <> '3'
	MsgAlert('Para Aprovação/Reprovação do CAP o participante tem que ser do tipo CAP !!')
	Return
EndIF
IF nTipo == 1 // Aprovação
	IF &(cTab+'->'+cTab+'_XAPROV') == '1'
		IF MsgYESNO('Deseja Aprovar esta Garantia/despesa?')
			GravaZJ1(cTab,'2','Aprovação Parte Jurídica')
		EndIF
	Else
		IF MsgYESNO('Deseja Aprovar esta Garantia/Despesa ? será gerado financeiro após aprovado')
			AlteraDesp(cTab)
			/*IF cTab == 'NT2' .AND. &(cTab+'->NT2_MOVFIN') == '1'
				Reclock(cTab,.F.)
				//&(cTab+'->NT2_MOVFIN')  := '1'
				&(cTab+'->NT2_INTFIN')  := '1'
				&(cTab+'->(MsUnlock())')
			EndIF
			Processa( {|| Proc_Jur(@bPassou,cTab) },'Aguarde...', 'Gerando Financeiro',.F. )
			If bPassou
				GravaZJ1(cTab,'5','Aprovado CAP - Gerado o Titulo')
			Else
			    DbSelectArea("NV3")
				NV3->(DbSetOrder(2))
				NV3->(DbGoTop())
				If NV3->(DbSeek(xFilial("NV3")+&(cTab+'->'+cTab+'_CAJURI')+&(cTab+'->'+cTab+'_COD')+'2'))
					Reclock( 'NV3', .F. )
					dbDelete()
					MsUnlock()
				EndIf
				IF cTab == 'NT2'
					Reclock(cTab,.F.)
					&(cTab+'->NT2_INTFIN')  := '2'
					&(cTab+'->(MsUnlock())')
			    EndIF
			    MsgAlert('Problema na geração do Titulo !')
			EndIf*/
		EndIF
	EndIF
Else
	AAdd(aParamBox, {1, "Motivo:"   ,Space(tamSx3("ZJ1_MOTIVO")[1])   , "@!",  ,,, 90	, .T.	})
	IF ParamBox(aParambox, "Informe o Motivo da Rejeição"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
		IF EMpty(MV_PAR01)
			MsgAlert('Motivo em Branco !')
			Return
		Else
			GravaZJ1(cTab,IIF(&(cTab+'->'+cTab+'_XAPROV') == '1', '3', '4'),MV_PAR01)
		EndIf
	EndIf
EndIF
Return                
******************************************************************************************************************************
Static Function GravaZJ1(cTab,cStatus,cMotivo)
                                              
dbSelectArea('ZJ1')
cSeq := U_JUR02_SEQ(cTab,&(cTab+"->(Recno())"))
Reclock("ZJ1",.T.)
ZJ1->ZJ1_FILIAL    := xFilial('SZ1')
ZJ1->ZJ1_TAB       := cTab
ZJ1->ZJ1_RECNO     := &(cTab+"->(Recno())")
ZJ1->ZJ1_SEQ       := cSeq
ZJ1->ZJ1_STATUS    := cStatus
ZJ1->ZJ1_USER      := RetCodUsr()
ZJ1->ZJ1_NOME      := USRRETNAME(RetCodUsr())
ZJ1->ZJ1_DATA      := Date()
ZJ1->ZJ1_HORA      := Time()
ZJ1->ZJ1_MOTIVO    := cMotivo
ZJ1->ZJ1_EMAIL     := 'S'
ZJ1->(MsUnlock())
Reclock(cTab,.F.)
&(cTab+'->'+cTab+'_XAPROV') := cStatus
&(cTab+'->(MsUnlock())')

Return                                         
/*
***********************************************************************************************************************************************************
User Function JUR03PAG(aPar,nCont,lCtb,cTipoM,cCodNV3)
Local nOper     := aPar[1]
Local cTabela   := aPar[2]
Local nValor    := aPar[3]
Local cCajuri   := aPar[4]
Local cCodlan   := aPar[5]
Local cTipoL    := aPar[6]
Local cPrefix   := aPar[7]                      

Local cFilBk     := cFilAnt
Local aArea      := GetArea()
Local lRetFun    := .T.
Local cMsgErr    := ""
Local cSQL       := ""
Local cCod       := ""
Local cRet       := ""
Local aCabSE2    := {}
Local aCampos    := {}
Local lAlcada    := .F. 
Local cE2FILIAL  := ""
Local cE2FORNECE := ""
Local cE2LOJA    := ""
Local cE2PREFIXO := ""
Local cE2NUM     := ""
Local cE2PARCELA := ""
Local cE2TIPO    := ""
Local cE2NATUREZ := ""
Local dE2EMISSAO := CtoD("")
Local dE2VENCTO  := CtoD("")
Local dE2VENCREA := CtoD("")
Local nE2VALOR   := 0
Local nE2MOEDA   := 0
Local nE2SALDO   := 0
Local cE2ORIGEM  := ""
Local cE2BANCO   := ""
Local cE2AGENCIA := ""
Local cE2CONTA   := ""
Local cE2HIST    := ""
Local cE2LA      := ""
Local aParcela   := {}
Local cCondic    := ""
Local nI         := 0
Local nParc      := 0
Local cFilDES    := ''    
//Local cCCusto    := ''

Private lMsErroAuto := .T.
Private lMsHelpAuto := .T.

Default nOper    := 3
Default cPrefix  := 'NV3'
Default nCont    := 0
Default lCtb     := .F.
Default cTipoM   := ""
Default cCodNV3  := ""

If lRetFun .And. nValor == 0
	cMsgErr := 'Valor deve ser maior que zero'
	lRetFun := .F.
EndIf

If lRetFun
	
	//Query que pega o ID no historico para que seja gerado CP daquele registro.
	cSQL := "SELECT MIN(NV3_COD) MENOR, NV3_FORNEC FORNEC, NV3_LOJA LOJA, NV3_TIPO TIPO, NV3_NUM NUM, NV3_PREFIX PREFIX, NV3_PARC PARC "+ CRLF
	cSQL += "  FROM "+RetSqlName("NV3") +" NV3"+ CRLF
	cSQL += "  		WHERE NV3_CAJURI = '"+cCajuri+"'"+ CRLF
	cSQL += "  			AND NV3_CODLAN = '"+cCodlan+"'"+ CRLF
	cSQL += "  			AND NV3_TIPOL = '"+cTipoL+"'"+ CRLF
	cSQL += "  			AND NV3_TIPOM = '1'"+ CRLF
	cSQL += "  	 AND NV3.NV3_FILIAL = '"+xFilial("NV3")+"' " + CRLF
	cSQL += "  	 AND NV3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "		 GROUP BY NV3_FORNEC, NV3_LOJA, NV3_TIPO, NV3_NUM, NV3_PREFIX, NV3_PARC"
	
	
	While !(cRet)->( EOF() )
		If !Empty(cCodNV3) .And. cTipoM > '1' .And. (cTipoL == '9' .Or. cTipoL == 'B') 
			cCod := cCodNV3
		Else
			cCod := (cRet)->MENOR //codigo do primeiro cadastro no historico desse registro
		EndIf
		If nOper == 5
			cE2FORNECE := AVKey( (cRet)->FORNEC,	"E2_FORNECE" )
			cE2LOJA    := AVKey( (cRet)->LOJA,		"E2_LOJA"    )
			cE2TIPO    := AVKey( (cRet)->TIPO,		"E2_TIPO"    )
			cE2PREFIXO := AVKey( (cRet)->PREFIX,	"E2_PREFIXO" )
			cE2NUM     := AVKey( (cRet)->NUM,			"E2_NUM"     )
			cE2PARCELA := AVKey( (cRet)->PARC,		"E2_PARCELA" )
		EndIf
		(cRet)->(dbSkip())
	EndDo
	(cRet)->( dbCloseArea() )
	
	
	If (!IsInCallStack('JURA002') .And. !IsInCallStack('A097PROCLIB')) .Or. (nOper == 5) // IsInCallStack('MATA097') - MATA097 é o nome do programa. O correto é utilizar o nome da função A097PROCLIB.
		//Ajusta a quantidade de digitos utilizada na numeracao do titulo
		If nOper <> 5
			cE2FORNECE := AVKey( &(cTabela+"->"+cTabela+"_CFORNT"),				"E2_FORNECE" )
			cE2LOJA    := AVKey( &(cTabela+"->"+cTabela+"_LFORNT"),				"E2_LOJA"    )
			cE2TIPO    := AVKey( &(cTabela+"->"+cTabela+"_CTIPOT"),				"E2_TIPO"    )
			cE2PREFIXO := AVKey( &(cTabela+"->"+cTabela+"_PREFIX"),		 		"E2_PREFIXO" )
		EndIf
		
		cE2NATUREZ := AVKey( &(cTabela+"->"+cTabela+"_CNATUT"),				"E2_NATUREZ" )
		dE2EMISSAO := &(cTabela+"->"+cTabela+"_DATA")
		nE2VALOR   := &(cTabela+"->"+cTabela+"_VALOR")
		nE2MOEDA   := Val(&(cTabela+"->"+cTabela+"_CMOEDA"))
		
		If cTabela == 'NT2'
			cE2ORIGEM  := AVKey( "JURA098",   "E2_ORIGEM"  )
			cE2BANCO   := &(cTabela+"->"+cTabela+"_CBANCO")
			cE2AGENCIA := &(cTabela+"->"+cTabela+"_CAGENC")
			cE2CONTA   := &(cTabela+"->"+cTabela+"_CCONTA")
			cFilDES    := &(cTabela+"->"+cTabela+"_FILDES")
			//cCCusto    := &(cTabela+"->"+cTabela+"_XCCUST")
			If cTipoM > '1'
				cE2HIST    := AVKey( "JURI ALVARÁ " + cCodlan ,   "E2_HIST"  )
			Else
				cE2HIST    := AVKey( "JURI GARANTIA " + cCodlan , "E2_HIST" )
			EndIf
			
		Else
			cE2ORIGEM  := AVKey( "JURA099",   "E2_ORIGEM"  )
			cE2HIST	   := AVKey( "JURI DESPESA " + cCodlan ,   "E2_HIST"  )
			cCondic    := &(cTabela+"->"+cTabela+"_CONDPG")
			cFilDES    := &(cTabela+"->"+cTabela+"_FILDES")
			//cCCusto    := &(cTabela+"->"+cTabela+"_XCCUST")
		EndIf
		
	ElseIf cTabela == 'NT2'
		//Ajusta a quantidade de digitos utilizada na numeracao do titulo
		cE2FORNECE := AVKey( JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_CFORNT'),				"E2_FORNECE" )
		cE2LOJA    := AVKey( JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_LFORNT'),				"E2_LOJA"    )
		cE2TIPO    := AVKey( JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_CTIPOT'),				"E2_TIPO"    )
		cE2NATUREZ := AVKey( JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_CNATUT'),				"E2_NATUREZ" )
		cE2PREFIXO := AVKey( JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_PREFIX'),				"E2_PREFIXO" )
		dE2EMISSAO := JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_DATA')
		nE2VALOR   := JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_VALOR')
		cE2BANCO   := JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_CBANCO')
		cE2AGENCIA := JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_CAGENC')
		cE2CONTA   := JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_CCONTA')
		cE2ORIGEM  := AVKey( "JURA098",   "E2_ORIGEM"  )
		If cTipoM > '1'
			cE2HIST    := AVKey( "JURI ALVARÁ " + cCodlan ,   "E2_HIST"  )
		Else
			cE2HIST    := AVKey( "JURI GARANTIA " + cCodlan ,   "E2_HIST"  )
		EndIf
		nE2MOEDA   := Val(JurGetDados ('NT2', 5, xFilial('NT2') + cCodlan + cCajuri, 'NT2_CMOEDA'))
	EndIf
	
	If nOper <> 5
		cE2NUM     := StrZero( Val(cCod), TamSX3("E2_NUM")[1] )
		cE2NUM     := AVKey( cE2NUM,			"E2_NUM"     )
		cE2PARCELA := AVKey( "1",				"E2_PARCELA" )
	EndIf
	
	IF Empty(cFilDES)
 	    cE2FILIAL  := xFilial("SE2")
	Else 
 	    cFilAnt    := cFilDES
 	    cE2FILIAL  := cFilDES
	EndIF
	dE2VENCTO  := dE2EMISSAO
	dE2VENCREA := dE2EMISSAO
	nE2SALDO   := nE2VALOR
	
	If Empty(Alltrim(cE2FORNECE)) .OR. Empty(Alltrim(cE2LOJA)) .OR. Empty(Alltrim(cE2TIPO)) .OR. Empty(Alltrim(cE2NATUREZ)) //Campos obrigatorios para integracao
		cMsgErr := "Os parametros para criacao do compromisso a pagar nao foram preenchidos corretamente. Verifique. " + CRLF
		lRetFun := .F.
	Else
		If lRetFun
			aCampos := JurVerPag(,cE2NATUREZ,cE2FORNECE,cE2LOJA,cE2TIPO,cE2NUM,cE2PREFIXO) //Verifica se existe CP e se esta em aberto
			If aCampos[1] .And. nOper == 3 //Nao ha CP quando se inclui          //aCampos[2] : Está ¥m aberto
				lRetFun := .F.
			EndIf
			
		EndIf
	EndIf
	
	If !Empty(cCodNV3) .And. cTipoM > '1' .And. (cTipoL = '9' .Or.  cTipoL == 'B')
		nE2VALOR := nValor
		nE2SALDO := nE2VALOR
	EndIf
	
	If lRetFun
		//Alimenta o array para geracao do titulo a pagar
		AAdd(aCabSE2, {"E2_FILIAL"  , cE2FILIAL  , Nil})
		AAdd(aCabSE2, {"E2_FORNECE" , cE2FORNECE , Nil})
		AAdd(aCabSE2, {"E2_LOJA"    , cE2LOJA    , Nil})
		AAdd(aCabSE2, {"E2_PREFIXO" , cE2PREFIXO , Nil})
		AAdd(aCabSE2, {"E2_NUM"     , cE2NUM     , Nil})
		AAdd(aCabSE2, {"E2_PARCELA" , cE2PARCELA , Nil})
		AAdd(aCabSE2, {"E2_TIPO"    , cE2TIPO    , Nil})
		AAdd(aCabSE2, {"E2_NATUREZ" , cE2NATUREZ , Nil})
		AAdd(aCabSE2, {"E2_EMISSAO" , dE2EMISSAO , Nil}) //data emissão
		AAdd(aCabSE2, {"E2_VENCTO"  , dE2VENCTO  , Nil}) //vencimento
		AAdd(aCabSE2, {"E2_VENCREA" , dE2VENCREA , Nil}) //vencimento
		AAdd(aCabSE2, {"E2_VALOR"   , nE2VALOR   , Nil}) //valor
		AAdd(aCabSE2, {"E2_SALDO"   , nE2SALDO   , Nil}) //valor
		AAdd(aCabSE2, {"E2_MOEDA"   , nE2MOEDA   , Nil}) //valor
		AAdd(aCabSE2, {"E2_ORIGEM"  , cE2ORIGEM  , Nil})
		AAdd(aCabSE2, {"E2_HIST"	, cE2HIST	 , Nil})
		//AAdd(aCabSE2, {"E2_CCUSTO"	, cCCusto    , Nil})
		
		//Grade de aprovação entrando liberado
		// Não Necessita mais
		//AAdd(aCabSE2, {"E2_ZCODGRD"	, 'ZZZZZZZZZZ'   , Nil})
		//AAdd(aCabSE2, {"E2_ZBLQFLG"	, 'S'            , Nil})       
		//AAdd(aCabSE2, {"E2_DATALIB"	, dDataBase      , Nil})
		//AAdd(aCabSE2, {"E2_ZIDINTE"	, 'ZZZZZZZZZ'    , Nil})
		//AAdd(aCabSE2, {"E2_ZIDGRD"	, 'ZZZZZZZZZ'    , Nil})
		//AAdd(aCabSE2, {"E2_ZNEXGRD"	, ''             , Nil})
        
        If cTabela == 'NT2' .And. lCtb .And. cTipoM > '1'
			AAdd(aCabSE2, {"E2_LA"  , "S" , Nil})
		EndIf

		If cTabela == 'NT2'
			AAdd(aCabSE2, {"AUTBANCO"  , cE2BANCO 	 , Nil})
			AAdd(aCabSE2, {"AUTAGENCIA", cE2AGENCIA  , Nil})
			AAdd(aCabSE2, {"AUTCONTA"  , cE2CONTA 	 , Nil})
		EndIf
		
		If !Empty(cCondic) //trata as parcelas das Despesas
			aParcela := JurParcPg(aCabSE2, cCondic, nE2VALOR, dE2EMISSAO)
		Else
			aParcela := {aCabSE2}
		EndIf
		
		
		If nOper == 3 .OR. (nOper == 5 .AND. aCampos[2]) .OR. (nOper == 4 .AND. aCampos[2])
			
			Begin Transaction
				For nI := 1 to Len(aParcela )
					lMsErroAuto := .F.
					
					aCabSE2 := aParcela[nI]
					
					MSExecAuto({|x,y,z| FINA050(x,y,z)}, aCabSE2, Nil, nOper) //Efetua a operacao
					
					If lMsErroAuto
						DisarmTransaction()
						lRetFun := .F.
						MostraErro()
						Exit
					Else
						nParc := aScan( aCabSE2, { |x| x[1] == "E2_PARCELA" } )
						If nParc > 0
							cE2PARCELA := aCabSE2[nParc][2]
						EndIf
						
						dbSelectArea( "SE2" )
						SE2->( dbSetOrder( 1 ) ) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

						//Define a chave de pesquisa na tabela de titulos a pagar (SE2)
						cChave := xFilial( "SE2" )
						cChave += AVKey(cE2PREFIXO, "E2_PREFIXO" )
						cChave += AVKey(cE2NUM    , "E2_NUM"     )
						cChave += AVKey(cE2PARCELA, "E2_PARCELA" )
						cChave += AVKey(cE2TIPO   , "E2_TIPO"    )
						cChave += AVKey(cE2FORNECE, "E2_FORNECE" )
						cChave += AVKey(cE2LOJA   , "E2_LOJA"    )

						//Verifica se existe Contas a Pagar para este lancamento
						If SE2->( dbSeek( cChave ) )
							If cTabela == 'NT2' .And. lCtb .And. cTipoM > '1'
								Reclock( 'SE2', .F. )
								SE2->E2_LA := "S" //Quando a contabilização é feita via contábil (lCtb = .T.), o título gerado deve estar como contabilizado (E2_LA = "S"). Está sendo feito via Reclock pois a rotina FINA050 não permite o preenchimento do campo E2_LA via MSExecAuto.
								MsUnlock()
							EndIf                    
							//Reclock( 'SE2', .F. )
							//SE2->E2_ZCODGRD := 'ZZZZZZZZZZ'  
							//SE2->E2_ZBLQFLG := 'S'           
							//SE2->E2_DATALIB := dDataBase     
							//SE2->E2_ZIDINTE := 'ZZZZZZZZZ'   
							//SE2->E2_ZIDGRD  := 'ZZZZZZZZZ'   
							//SE2->E2_ZNEXGRD := ''            
							//SE2->(MsUnlock()) 
							If FWHasEAI("FINA050",.T.,,.T.)
								FwIntegDef( 'FINA050' )
							Endif
							
						EndIf
					EndIf
				Next
				
			End Transaction
			
		Else
			If nOper == 5 .And. nCont == 1
				cMsgErr += 'Financeiro já gerado, não é possivel remover lançamento. ' +CRLF
			ElseIf nOper == 4 .And. nCont == 1
				cMsgErr += 'Financeiro já gerado, não é possivel alterar lançamento. ' +CRLF
			EndIf
			lRetFun := .F.
			
		EndIf
		
	EndIf
	
	If	lRetFun
		If nOper <> 5
			DbSelectArea("NV3")
			NV3->(DbSetOrder(1))
			NV3->(DbGoTop())
			If NV3->(DbSeek(xFilial("NV3")+cCod))
				RecLock('NV3', .F.)
				NV3->NV3_PREFIX := SE2->E2_PREFIXO
				NV3->NV3_NUM 	 	:= SE2->E2_NUM
				NV3->NV3_PARC 	:= SE2->E2_PARCELA
				NV3->NV3_TIPO 	:= SE2->E2_TIPO
				NV3->NV3_FORNEC := SE2->E2_FORNECE
				NV3->NV3_LOJA 	:= SE2->E2_LOJA
				NV3->(MsUnlock())
			EndIf
		EndIf
	EndIf
	
	
EndIf

If !lRetFun .And. nCont == 1 .And. !Empty(cMsgErr)
	JurMsgErro(cMsgErr)
EndIf

RestArea(aArea)
cFilAnt := cFilBk 
                  
Return lRetFun
****************************************************************************************************************
Static Function Proc_Jur(bPassou,cTab)

bPassou := JurHisCont(&(cTab+'->'+cTab+'_CAJURI'),&(cTab+'->'+cTab+'_COD'),&(cTab+'->'+cTab+'_DATA'),&(cTab+'->'+cTab+'_VALOR'),'1',IIF(cTab='NT2','2','3'),cTab, 3, '')
          
Return bPassou

*****************************************************************************************************************
Static Function JurParcPg(aCabSE2, cCondic, nValor, dEmite)
Local aParCond   := {}
Local aParcela   := {}
Local nPosParc   := aScan( aCabSE2, { |aX| AllTrim(aX[1]) == "E2_PARCELA" } )
Local nPosVenc   := aScan( aCabSE2, { |aX| AllTrim(aX[1]) == "E2_VENCTO"  } )
Local nPosVencR  := aScan( aCabSE2, { |aX| AllTrim(aX[1]) == "E2_VENCREA" } )
Local nPosValor  := aScan( aCabSE2, { |aX| AllTrim(aX[1]) == "E2_VALOR"   } )
Local nPosSaldo  := aScan( aCabSE2, { |aX| AllTrim(aX[1]) == "E2_SALDO"   } )
Local nI         := 0
Local aTempSE2   := {}

aParCond := Condicao( nValor , cCondic, , dEmite )

For nI := 1 to Len(aParCond)

	aTempSE2 := aClone( aCabSE2)

	Iif(nPosParc >  0, aTempSE2[nPosParc][2]  := AVKey( AllTrim(str(nI)),"E2_PARCELA" ), Nil )

	Iif(nPosVenc >  0, aTempSE2[nPosVenc][2]  := aParCond[nI][1], Nil )
	Iif(nPosVencR > 0, aTempSE2[nPosVencR][2] := aParCond[nI][1], Nil )

	Iif(nPosValor > 0, aTempSE2[nPosValor][2] := aParCond[nI][2], Nil )
	Iif(nPosSaldo > 0, aTempSE2[nPosSaldo][2] := aParCond[nI][2], Nil )

	Aadd(aParcela, aTempSE2)

Next nI


Return aParcela
*/
****************************************************************************************************************
Static Function AlteraDesp(cTab)
Local  lRet     := .T.
Local cChave    :=  ''
Local aDados    := {}
//Local cCCusto   := ''
Local aErro     := {}
Local cErro     := ''
Local cDesc     := ''
Local cProcesso := POSICIONE('NUQ',2,xFilial('NUQ')+&(cTab+'->'+cTab+'_CAJURI')+'1','NUQ_NUMPRO')                                   
Local cPolo     := POSICIONE('NT9',3,XFILIAL('NT9')+&(cTab+'->'+cTab+'_CAJURI')+'1'+'1','NT9_NOME')                                 

Private oModel      

IF cTab == 'NT3'
	oModel  := FWLoadModel('JURA099')
	oModel:SetOperation(MODEL_OPERATION_UPDATE)
	oModel:Activate()
	oModel:SetValue("NT3MASTER","NT3_XAPROV","5")
Else
	oModel  := FWLoadModel('JURA098')                
	oModel:SetOperation(MODEL_OPERATION_UPDATE)
	oModel:Activate()
	oModel:SetValue("NT2MASTER","NT2_INTFIN","1")
	M->E2_FCTADV := ''
	M->E2_FORCTA := ''
	M->E2_FAGEDV := ''
	M->E2_FORAGE := ''
	M->E2_FORBCO := ''
EndIF		 
If oModel:VldData()
    oModel:CommitData()
	
	GravaZJ1(cTab,'5','Aprovado CAP - Gerado o Titulo/Contabil')
	
	//cCCusto := FwFldGet(cTab+'_XCCUST',,oModel)
	cFILDES := FwFldGet(cTab+'_FILDES',,oModel)
	cFilDes := IIF(Empty(cFILDES),xFilial('SE2') ,cFILDES)
	cDesc   := FwFldGet(cTab+'_DESC',,oModel)  

	aDados := JurQryAlc(cTab, FwFldGet(cTab+'_CAJURI',,oModel), FwFldGet(cTab+'_COD',,oModel), IIF(cTab == 'NT2','2','3'),.T.)
	
	If ValType(aDados) == "A"
		
		SE2->( dbSetOrder( 1 ) ) 
		
		cQuery := "SELECT R_E_C_N_O_ SE2RECNO "
		cQuery += "  FROM " + RetSqlName( "SE2" ) + " SE2 "
		cQuery += "  WHERE SE2.E2_FILIAL	= '" +cFilDes+ "' "
		cQuery += "	AND SE2.E2_PREFIXO	= '" + aDados[5] + "' "
		cQuery += "	AND SE2.E2_NUM IN ('" + aDados[4] + "') "
		cQuery += "	AND SE2.E2_TIPO		= '" + aDados[7] + "' "
		cQuery += "	AND SE2.E2_FORNECE	= '" + aDados[8] + "' "
		cQuery += "	AND SE2.E2_LOJA		= '" + aDados[9] + "' "
		cQuery += "	AND SE2.D_E_L_E_T_	= ' ' "

		If Select("QRYE2") > 0
			QRYE2->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYE2",.T.,.F.)
		dbSelectArea("QRYE2")
		QRYE2->(dbGoTop())
	
		While !QRYE2->( EOF() )
				SE2->( dbGoTo( QRYE2->SE2RECNO ) )
				RecLock( 'SE2', .F. )
				//SE2->E2_CCUSTO   := cCCusto
				SE2->E2_ZNUMPRO := Padr(cProcesso,TamSx3("E2_ZNUMPRO")[1])
				SE2->E2_XOBS    := cDesc
				SE2->E2_ZPOLO   := cPolo
				SE2->(MsUnLock())
	
				QRYE2->( dbSkip() )
		EndDo		
	EndIF 
Else
    aErro   := oModel:GetErrorMessage()
    IF ValType(aErro) == "A"
		cErro +=  "Id do formulário de origem:" + ' [' + AllToChar( aErro[1]  ) + ']'+CRLF 
		cErro +=  "Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']'+CRLF
		cErro +=  "Id do formulário de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']'+CRLF
		cErro +=  "Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']'+CRLF
		cErro +=  "Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']'+CRLF
		cErro +=  "Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']'+CRLF
		cErro +=  "Mensagem da solução:       " + ' [' + AllToChar( aErro[7]  ) + ']'+CRLF
		cErro +=  "Valor atribuido:           " + ' [' + AllToChar( aErro[8]  ) + ']'+CRLF
		cErro +=  "Valor anterior:            " + ' [' + AllToChar( aErro[9]  ) + ']'+CRLF
	    MsgAlert(cErro)
    EndIF
EndIf

oModel:DeActivate()
		
Return lRet


