#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "FWMVCDEF.CH"
/*
=====================================================================================
Programa.:              MGFGFE48	
Autor....:              Rafael Garcia
Data.....:              04/06/2018
Descricao / Objetivo:   WS Integracao PROTHEUS x MultiEmbarcador - Recebimento ND - 
simula integração do cte, libera Romaneio, execAuto liberação de Romaneio e processamento
Doc. Origem:            Especificacao de Processos_Emissao_CT-e - EF - 01_v2
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS  Recebimento ND
=====================================================================================
*/

WSSTRUCT NotasFiscais
	WSDATA Sequencial	as String
	WSDATA FilialDoc    as String
	WSDATA EmissorDc    as string
	WSDATA SerieDc		as string
	WSDATA NrDocCarga   as string
	WSDATA ChaveNfe		as string

ENDWSSTRUCT

WSSTRUCT Ocorrencia

	WSDATA OCORRENCIAMULTIEMBARCADOR	as String
	WSDATA Descricao	as String
	WSDATA Tipo		    as String
	WSDATA Motivo	    as string
	WSDATA Problema		as string
	WSDATA Solucao		as string
	WSDATA DtOcorren	AS date
	WSDATA HrOcorren	as string
	wsdata UsrCriacao 	as string
	wsdata UsrBaixa		as string
	Wsdata ValorEsp 	as float
	wsdata QtServicos	as float


ENDWSSTRUCT

WSSTRUCT MGFGFE48REC

	WSDATA Acao		 	AS string
	WSDATA NrLinha		AS STRING
	WSDATA Alterado		AS string
	WSDATA SitEdi		AS string
	WSDATA FilialDoc	AS string
	WSDATA Especie		AS string
	WSDATA Transportador     as string
	WSDATA Serie 		as string
	WSDATA Origem 		as string
	WSDATA NrDocto		as string
	WSDATA DataEmissao	as date
	WSDATA CodRemet		as string
	WSDATA TipoDocto	as string
	WSDATA Tributacao	as string
	wsdata ValorDocto	as float
	WSDATA TipoCte 		as string
	WSDATA QtdeDoctos	as float
	WSDATA ValorCarga	as float
	WSDATA NotasFiscais as array of NotasFiscais
	WSDATA Ocorrencia   as array of Ocorrencia


ENDWSSTRUCT

WSSTRUCT MGFGFE48Ret
	WSDATA status   		AS string
	WSDATA Msg				AS String
ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Retorno OE multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFGFE48 DESCRIPTION "Integracao Protheus x Multiembarcador - ND" NameSpace "http://totvs.com.br/MGFGFE48.apw"

	// Passagem dos parametros de entrada
	WSDATA MGFGFE48RECEBER AS MGFGFE48REC
	// Retorno (array)
	WSDATA MGFGFE48RETORNO   AS MGFGFE48Ret

	WSMETHOD RetND DESCRIPTION "Integracao Protheus x Multiembarcador - Retorno ND"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoCarga
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetND WSRECEIVE MGFGFE48RECEBER WSSEND MGFGFE48RETORNO WSSERVICE MGFGFE48

	Local aRetFuncao := {}
	local aItens	:= {}
	local aOcor		:= {}
	Local lReturn	:= .T.
	local ni:=1
	for ni:=1 to len(::MGFGFE48RECEBER:NotasFiscais)
		AADD( aItens,{ ::MGFGFE48RECEBER:NotasFiscais[ni]:Sequencial,; 
		::MGFGFE48RECEBER:NotasFiscais[ni]:FilialDoc,;
		::MGFGFE48RECEBER:NotasFiscais[ni]:EmissorDc,;
		::MGFGFE48RECEBER:NotasFiscais[ni]:SerieDc,;
		::MGFGFE48RECEBER:NotasFiscais[ni]:NrDocCarga,;
		::MGFGFE48RECEBER:NotasFiscais[ni]:ChaveNfe})
	NEXT
	for ni:=1 to len(::MGFGFE48RECEBER:Ocorrencia)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:OCORRENCIAMULTIEMBARCADOR 	)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:Descricao 	)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:Tipo			)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:Motivo		)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:Problema		)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:Solucao		)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:DtOcorren		)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:HrOcorren		)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:UsrCriacao 	)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:UsrBaixa		)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:ValorEsp 		)
		AADD( aOcor, ::MGFGFE48RECEBER:Ocorrencia[ni]:QtServicos	)
	NEXT
	aRetFuncao	:= u_MGFGFE48(	{	;
	::MGFGFE48RECEBER:Acao		 	,;
	::MGFGFE48RECEBER:NrLinha		,;
	::MGFGFE48RECEBER:Alterado		,;
	::MGFGFE48RECEBER:SitEdi		,;
	::MGFGFE48RECEBER:FilialDoc		,;
	::MGFGFE48RECEBER:Especie		,;
	::MGFGFE48RECEBER:Transportador ,;
	::MGFGFE48RECEBER:Serie 		,;
	::MGFGFE48RECEBER:Origem		,;
	::MGFGFE48RECEBER:NrDocto		,;
	::MGFGFE48RECEBER:DataEmissao 	,;
	::MGFGFE48RECEBER:CodRemet		,;
	::MGFGFE48RECEBER:TipoDocto 	,;
	::MGFGFE48RECEBER:Tributacao	,;
	::MGFGFE48RECEBER:ValorDocto	,;
	::MGFGFE48RECEBER:TipoCte 		,;
	::MGFGFE48RECEBER:QtdeDoctos	,;
	::MGFGFE48RECEBER:ValorCarga	},;
	{aItens},{aOcor})	// Passagem de parametros para rotina


	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFGFE48RETORNO 				:=  WSClassNew( "MGFGFE48Ret" )
	::MGFGFE48RETORNO:status		:= aRetFuncao[1][1]
	::MGFGFE48RETORNO:Msg			:= aRetFuncao[1][2]

Return lReturn


user function MGFGFE48( aEmb, aItens,aOcor )
	LOCAL aRet:={}
	local cFil:=""		
	Local aArea	   := GetArea()
	Local aAreaGXG := GXG->(GetArea())
	Local aAreaGXH := GXH->(GetArea())
	Local aAreaGW1 := GW1->(GetArea())

	cFil:=ALLTRIM(QFIL(aEmb[5]))
	if alltrim(cFil)==""
		aadd(aRet,{"2","CNPJ DOCORIGEM INVALIDO"})
		RETURN(aRet)
	else
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL cFil MODULO "GFE"

		IF SELECT("cGWD") > 0
			cGWD->( dbCloseArea() )
		ENDIF

		cQuery := " SELECT GWD_ZOCMUL FROM " + RetSQLName("GWD") 
		cQuery += " WHERE GWD_FILIAL 	= '" + cFil 		+ "'"
		cQuery += " AND GWD_ZOCMUL 		= '" + aOcor[1][1] 	+ "'"
		cQuery += " AND D_E_L_E_T_		<> '*' "


		TcQuery changeQuery(cQuery) New Alias "cGWD"
		IF !cGWD->(EOF())
			aadd(aRet,{"1","Ocorrencia Multiembarcador ja processada"})
		else
			aRet:=GFEA117(aEmb, aItens,cFil,aOcor) //Execauto para inclusao do frete combinado
			if aRet[1][1]=="1"
				cNRIMP := GFE118ChSq()
				DBSELECTAREA("GXG")
				RecLock("GXG",.T.)
				GXG->GXG_FILIAL := xFilial("GXG")
				GXG->GXG_NRIMP  := cNRIMP
				GXG->GXG_ACAO  	:= aEmb[1]
				GXG->GXG_EDINRL	:= val(aEmb[2])
				GXG->GXG_EDIARQ	:= "INTEGRACAO-ND"
				GXG->GXG_DTIMP	:= DATE(  )
				GXG->GXG_ALTER  := aEmb[3]
				GXG->GXG_EDISIT  := aEmb[4]
				GXG->GXG_FILDOC := xFilial("GXG")
				GXG->GXG_CDESP	:= aEmb[6]
				GXG->GXG_EMISDF := aEmb[7]
				GXG->GXG_SERDF 	:= aEmb[8]
				GXG->GXG_ORIGEM := aEmb[9]
				GXG->GXG_NRDF   := aEmb[10]
				GXG->GXG_DTEMIS := aEmb[11]
				GXG->GXG_CDREM  := aEmb[12]
				GXG->GXG_TPDF   := aEmb[13]
				GXG->GXG_DTENT  := DATE(  )
				GXG->GXG_TRBIMP := aEmb[14]
				GXG->GXG_VLDF   := aEmb[15]
				GXG->GXG_TPCTE  := aEmb[16]
				GXG->GXG_QTDCS  := aEmb[17]
				GXG->GXG_VLCARG := aEmb[18]
				GXG->GXG_USUIMP := "INTEGRACAO"
				MsUnlock("GXG")
				FOR I:=1 TO LEN(aItens[1])

					DBSELECTAREA("GW1")
					DBSETORDER(12)
					IF DBSEEK(alltrim(aItens[1][I][6]))
						cTipoDC:=GW1->GW1_CDTPDC	
					endif

					DBSELECTAREA("GXH")
					RecLock("GXH", .T.)
					GXH->GXH_FILIAL := xFilial("GXH")
					GXH->GXH_NRIMP	:= cNRIMP
					GXH->GXH_SEQ  	:= alltrim(aItens[1][I][1])
					GXH->GXH_FILDC  := xFilial("GXG")
					GXH->GXH_EMISDC	:= alltrim(aItens[1][I][3])
					GXH->GXH_SERDC 	:= alltrim(aItens[1][I][4])
					GXH->GXH_NRDC  	:= alltrim(aItens[1][I][5])
					GXH->GXH_TPDC  	:= cTipoDC
					GXH->GXH_DANFE 	:= alltrim(aItens[1][I][6])

					MsUnlock("GXH")

				NEXT
				xGFEA115PR('3',.t.,GXG->GXG_NRIMP) //processamento		
			ENDIF
		ENDIF
	endif
	
	IF SELECT("cGWD") > 0
		cGWD->( dbCloseArea() )
	ENDIF	
	RestArea(aAreaGW1)
	RestArea(aAreaGXG)
	RestArea(aAreaGXH)
	RestArea(aArea)		
RETURN aRet


static FUNCTION GFEA117(aEmb, aItens,cFil,aOcor)
	local a      :=	0	
	local i		 := 0
	Local oModel := NIL
	Local nOpc   := 3
	LOCAL aRet   := {}		
	local cMsg	 :=""	
	local aErro  :={}  
	Local aArea	   := GetArea()
	Local aAreaGWF := GWF->(GetArea())
	Local aAreaGWD := GWD->(GetArea())
	Local aAreaGWL := GWL->(GetArea())
	Local aAreaGW1 := GW1->(GetArea())
	Local aAreaGWN := GWN->(GetArea())
	local cTipoDC  :=""
	Private INCLUI      := .T.
	Private lMsErroAuto := .F.
	PRIVATE ILOGPROC:= 0

	// PREPARACAO DO AMBIENTE (CASO ESTEJA NO SMARTCLIENT, REMOVER ESTA CHAMADA)
	cfilant:=cFil
	for i:=1 to len(aOcor)
		DBSELECTAREA("GW1")
		DBSETORDER(12)
		IF DBSEEK(alltrim(aItens[1][1][6]))
			DBSELECTAREA("GWN")
			DBSETORDER( 1 )
			IF DBSEEK( GW1->GW1_FILIAL+GW1->GW1_NRROM )
				cTipoDC:= GW1->GW1_CDTPDC	
				if GWN->GWN_SIT <> "3"
					GFEA050LIB(.T.,"",DDATABASE,SubStr(Time(), 1, 5)) //CHAMADA ROTINA PADRAO PARA LIBERAR O ROMANEIO					
				ENDIF
			ENDIF
		ENDIF
		If oModel == NIL
			oModel := FwLoadModel("GFEA032") // ABERTURA DO MODELO DE DADOS
			oModel:SetOperation(nOpc) // INFORMA A OPERAÇÃO
			oModel:Activate() // ATIVA O MODELO
		EndIf

		If (oModel:GetOperation() == 3)
			// TABELA GWD	
			// ATRIBUINDO VALORES AOS CAMPOS (OMODEL:SETVALUE("ID_TABELA", "CAMPO", "VALOR"))
                                                                                                  
			oModel:SetValue("GFEA032_GWD",    "GWD_DSOCOR",     aOcor[i][2])
			oModel:SetValue("GFEA032_GWD",    "GWD_CDTIPO",     aOcor[i][3])
			oModel:SetValue("GFEA032_GWD",    "GWD_CDMOT",      aOcor[i][4])
			oModel:SetValue("GFEA032_GWD",    "GWD_DSPROB",     aOcor[i][5])
			oModel:SetValue("GFEA032_GWD",    "GWD_DSSOLU",     aOcor[i][6])
			oModel:SetValue("GFEA032_GWD",    "GWD_DTOCOR",     aOcor[i][7])
			oModel:SetValue("GFEA032_GWD",    "GWD_HROCOR",     aOcor[i][8])
			oModel:SetValue("GFEA032_GWD",    "GWD_SIT",        "2")
			oModel:SetValue("GFEA032_GWD",    "GWD_USUCRI",     aOcor[i][9])
			oModel:SetValue("GFEA032_GWD",    "GWD_CDTRP",      aEmb[7])
			oModel:SetValue("GFEA032_GWD",    "GWD_ACAODC",     "2")
			oModel:SetValue("GFEA032_GWD",    "GWD_ACAODF",     "1")
			oModel:SetValue("GFEA032_GWD",    "GWD_ORIGEM",     "2")
			oModel:SetValue("GFEA032_GWD",    "GWD_SITTMS",     "0")
			oModel:SetValue("GFEA032_GWD",    "GWD_QTPERN",     aOcor[i][12])
			oModel:SetValue("GFEA032_GWD",    "GWD_ZVAL",  		aOcor[i][11])
			oModel:SetValue("GFEA032_GWD",	  "GWD_ZOCMUL",		aOcor[i][1] )

			// TABELA GWL
			for a:=1 to len(aItens[1])
				if a>1
					oModel:GetModel('GFEA032_GWL'):ADDLINE()
				endif
				oModel:SetValue("GFEA032_GWL",    "GWL_FILIAL",      xfilial("GWL") )
				oModel:SetValue("GFEA032_GWL",    "GWL_NRDC",        alltrim(aItens[1][a][5]))
				oModel:SetValue("GFEA032_GWL",    "GWL_FILDC",       xfilial("GWL") )
				oModel:SetValue("GFEA032_GWL",    "GWL_EMITDC",      alltrim(aItens[1][a][3]))
				oModel:SetValue("GFEA032_GWL",    "GWL_SERDC",       alltrim(aItens[1][a][4]))
				oModel:SetValue("GFEA032_GWL",    "GWL_TPDC",        cTipoDC)
				oModel:SetValue("GFEA032_GWL",    "GWL_SDOCDC",      alltrim(aItens[1][a][4]))
			next
		EndIf

		// VALIDA AS INFORMAÇÕES
		If oModel:VldData()
			oModel:CommitData() // GRAVA AS INFORMACOES
			aadd(aRet,{"1","sucesso"})
			DBSELECTAREA("GWF")
			DBSETORDER(5)
			IF DBSEEK(XFILIAL("GWF")+GWD->GWD_NROCO)
				RECLOCK("GWF",.F.)			//informacao diferente, forcar conforme xml multiembarcador
				GWF_PCICMS:=0
				GWF_VLICMS:=0
				GWF_PCISS:=0
				GWF_VLISS:=0

				GWF->( msUnlock() )	
			ENDIF
		Else
			aErro   := oModel:GetErrorMessage()

			// A estrutura do vetor com erro :
			//  [1] Id do formulario de origem
			//  [2] Id do campo de origem
			//  [3] Id do formulario de erro
			//  [4] Id do campo de erro
			//  [5] Id do erro
			//  [6] mensagem do erro
			//  [7] mensagem da solucao
			//  [8] Valor atribuido
			//  [9] Valor anterior

			cMsg:="Id do formulario de origem:" + ' [' + AllToChar( aErro[1] ) + ']' + chr(13)+chr(10) 
			cMsg+="Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']'+ chr(13)+chr(10) 
			cMsg+="Id do formulario de erro: " + ' [' + AllToChar( aErro[3] ) + ']'+ chr(13)+chr(10) 
			cMsg+="Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']'+ chr(13)+chr(10) 
			cMsg+="Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']'+ chr(13)+chr(10) 
			cMsg+="Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' + chr(13)+chr(10)
			cMsg+="Mensagem da solucao: " + ' [' + AllToChar( aErro[7] ) + ']' + chr(13)+chr(10)
			cMsg+="Valor atribuido: " + ' [' + AllToChar( aErro[8] ) + ']' + chr(13)+chr(10)
			cMsg+="Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']'+ chr(13)+chr(10) 		
			aadd(aRet,{"2",cMsg})


		EndIf

		oModel:DeActivate() // DESATIVA O MODELO
		oModel:Destroy() // APOS DESATIVADO, DESTROI O MESMO (EVITA PROBLEMAS DE REFERENCE COUNTER OVERFLOW)
	next
	RestArea(aAreaGWF)
	RestArea(aAreaGWD)
	RestArea(aAreaGWL)
	RestArea(aAreaGW1)
	RestArea(aAreaGWN)
	RestArea(aArea)
RETURN aRet

static function QFIL(cCnpj)

	Local cQuery
	LOCAL cFIL:=""

	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF

	cQuery := " SELECT M0_CODFIL FROM SYS_COMPANY "
	cQuery += "  WHERE M0_CGC = '" + cCnpj + "'"
	cQuery += "  AND SYS_COMPANY.D_E_L_E_T_<> '*' "

	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF
	TcQuery changeQuery(cQuery) New Alias "cSM0"
	cFIL:=cSM0->M0_CODFIL

	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF

Return (cFIL)

//processamento padrao do GFE tratado para atendender a necessidade Marfrig
static function xGFEA115PR(cOrigem, lSchedule,cNRIMP)
	Local lRet
	Local lRetGW4 		:= .F.
	Local cMsgPreVal 		:= ""
	Local nCount 			:= 0
	Local nTotal 			:= 0
	Local lProc  			:= .F.
	Local lOk    			:= .F.
	Local oModelGW4
	Local nCountDC		:= 0
	Local lDCUsoCons		:= .F.
	Local cCredPC
	Local aAreaGW1 		:= GW1->( GetArea() )
	Local cLogOption		:= SuperGetMV('MV_GFEEDIL',,'1')
	Local cFilTemp 		:= cFilAnt
	Local nCountZerosNF 	:= 0
	Local lNrDf			:= .F.
	Local cNumeroNF     	:= ""  	// Numero da Nota Fiscal do arquivo
	Local nI		    	:= 0
	Local cNRDF
	Local aArray    		:= {}
	local nCont
	Local lMsgErr 		:= .F.
	Local cCont			:= 0
	Local cContDel 		:= 0
	Local cNum 			:= ""
	Local cSer 			:= ""
	Local cEmi 			:= ""
	//	Local lSchedule		:= IsBlind()
	Local cDtEmiss
	Local aSDOC
	Local cNumDFRed 		:= ""
	Local cGXGPro 		:= GetNextAlias()
	Local cLock 			:= ''
	Local cLockTime
	Local aDcChave 		:= {}
	Local nPosDcEsc 		:= 0
	Local nX
	Local aErroLinha 		:= {}
	Local lPriErro
	Local cMsgErro			:= ''
	Local lValDC := .F.
	Local cFilAtu := cFilAnt
	Local s_GFEA1151 := ExistBlock("GFEA1151")
	Local s_GFEA1154 := ExistBlock("GFEA1154")
	Local s_GFEA1155 := ExistBlock("GFEA1155")
	Local s_GFEA1157 := ExistBlock("GFEA1157")
	Local s_GFECRIC  := SuperGetMv("MV_GFECRIC", .F., "1", GXG->GXG_FILDOC)
	local __nTamNrDC := TamSX3("GW1_NRDC" )[1]
	local __nTamSrDC := TamSx3(SerieNfId("GW1",3,"GW1_SERDC"))[1]
	local __lCpoSr   := TamSX3("GW1_SERDC")[1] == 14
	local __lCpoSDoc := Len(TamSX3("GW4_SDOCDC")) > 0
	// Início Ponto de Entrada Procomp
	If s_GFEA1151
		lValDC := ExecBlock("GFEA1151",.f.,.f.,{})
	EndIf
	// Fim Ponto de Entrada Procomp	

	Private GFELog115		:= GFELog():New("EDI_Conemb_Processamento", "EDI Conemb - Processamento", cLogOption)
	Private lRetMsg 		:= .F.
	Private lRetRedes		:= .F.
	Private nContMsg		:= 0

	Default cOrigem 		:= "1"

	If FindFunction("GFEA517SVW") == .T.
		GFEA517SVW(.F.) // Para que não exiba a tela de seleção
	EndIf

	If !lSchedule
		ProcRegua(0)
	EndIf

	cQuery := "SELECT R_E_C_N_O_ FROM " + RetSQLName("GXG") + " GXG "
	cQuery += " WHERE GXG.D_E_L_E_T_ = ' ' "
	//	If lSchedule // Se estiver sendo executado por Schedule, verifica se é diferente de processado com sucesso
	//		cQuery += "   AND GXG.GXG_EDISIT != '" + '4' + "'"
	//	else // se for manual, somente os diferente de 4 e marcados para serem processados.
	cQuery += "   AND (GXG.GXG_EDISIT != '" + '4' + "' AND GXG.GXG_NRIMP = '" + cNRIMP + "' )"
	//	EndIf
	cQuery += " ORDER BY R_E_C_N_O_ "
	cQuery := ChangeQuery(cQuery)
	conout(cquery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cGXGPro, .F., .T.)

	dbSelectArea(cGXGPro)
	(cGXGPro)->( dbGoTop() )

	DbSelectArea('GXG')
	GXG->( dbSetOrder(01) )
	GXG->( dBGoTop() )
	// Aqui ocorre o instanciamento do modelo de dados (Model)
	oModel    := FWLoadModel( "GFEA065" )
	oModelGW4 := oModel:getModel("GFEA065_GW4")

	While !(cGXGPro)->( Eof() )
		GXG->(DBGoTo((cGXGPro)->R_E_C_N_O_) )

		// CHAVE DE TRAVA DO DOCUMENTO DE FRETE,
		cLock := 'GFE_DOCFRETE_' +	AllTrim(GXG->GXG_FILDOC) + ;
		AllTrim(GXG->GXG_CDESP)  + ;
		ALLTRIM(GXG->GXG_EMISDF) + ;
		ALLTRIM(GXG->GXG_SERDF)  + ;
		ALLTRIM(GXG->GXG_NRDF)   + ;
		ALLTRIM(DTOS(GXG->GXG_DTEMIS))

		ClearGlbValue('GFE_DOCFRETE_*', 20) //Limpa todas as variáveis criadas por esta rotina que foram acessadas pela última vez há mais de 20s.

		cLockTime := GetGlbValue(cLock)
		If Vazio(cLockTime) .Or. Val(GFENow(.T.,,'','','')) - Val(cLockTime) > 10000
			PutGlbValue(cLock, GFENow(.T.,,'','',''))
			GFELog115:Add(GFENOW(.F.,,,':','.') + ' - Criação de variável de controle de processamento. Chave:' + cLock + '.')
		Else
			//2 de 2 pontos desta função em que o log é encerrado e retorna sem continuar até o fim da função.
			GFELog115:Add(GFENOW(.F.,,,':','.') + ' - Chave ' + cLock + ' em processamento por outro usuário.')
			GFELog115:Save()
			(cGXGPro)->( dbSkip() )
			Loop
		EndIf

		lProc := .T.
		lDCUsoCons := .F.
		lRet := .T.
		nTotal++

		GFELog115:Add("[" + cValToChar(nTotal) + "] Processando registro: " + cValToChar(GXG->GXG_NRIMP))
		GFELog115:Add("> Filial.: " + GXG->GXG_FILDOC, 1)
		GFELog115:Add("> Espécie: " + GXG->GXG_CDESP, 1)
		GFELog115:Add("> Emissor: " + GXG->GXG_EMISDF, 1)
		GFELog115:Add("> Série..: " + GXG->GXG_SERDF, 1)
		GFELog115:Add("> Número.: " + GXG->GXG_NRDF, 1)
		GFELog115:Add("> Dt.Emis: " + DTOS(GXG->GXG_DTEMIS), 1)
		GFELog115:Save()

		/*
		4) GFEA115A; na função de processamento os registros com GXG_EDISIT = 5 não poderão ser processados. 
		*/
		If GXG->GXG_EDISIT == '5'
			GFELog115:Add("** " + "Registros com a situação '5' (Erro Impeditivo) não podem ser processados.", 1)
			GFELog115:Save()

			If !('Erro Impeditivo' $ GXG->GXG_EDIMSG)
				RecLock("GXG",.F.)
				GXG->GXG_EDIMSG += "- " + "Registros com a situação '5' (Erro Impeditivo) não podem ser processados."
				MsUnLock("GXG")
			EndIf
			(cGXGPro)->( dbSkip() )
			Loop
		EndIf

		If GXG->GXG_ACAO != "E"
			RecLock("GXG",.F.)

			If !(Len(alltrim(str(GXG->GXG_FRPESO))) < (TamSX3("GW3_FRPESO")[1]))
				GXG->GXG_EDIMSG := "** Valor do campo Frete Peso do arquivo incompativel com o tamanho Frete Peso do Documento de Frete"
				GFELog115:Add("** Valor do campo Frete Peso do arquivo incompativel com o tamanho Frete Peso do Documento de Frete", 2)
				GFELog115:Save()
				GXG->GXG_EDISIT := '3'
				(cGXGPro)->( dbSkip() )
				Loop
			EndIf
			// Verifica se o conhecimento já está cadastrado
			dbSelectArea("GW3")
			dbSetOrder(1)
			If dbSeek(PadR(GXG->GXG_FILDOC, TamSX3("GW3_FILIAL")[1]) + ;
			PadR(GXG->GXG_CDESP,  TamSX3("GW3_CDESP")[1])  + ;
			PadR(GXG->GXG_EMISDF, TamSX3("GW3_EMISDF")[1]) + ;
			PadR(GXG->GXG_SERDF,  TamSX3("GW3_SERDF")[1])  + ;
			PadR(GXG->GXG_NRDF,   TamSX3("GW3_NRDF")[1])   + ;
			DTOS(GXG->GXG_DTEMIS))

				If GXG->GXG_ORIGEM != "2" .Or. ( Empty(GXG->GXG_ORINR) .And. Empty(GXG->GXG_ORISER))
					GFELog115:Add("** " + "Conhecimento já cadastrado.", 1)
					GFELog115:Save()

					GXG->GXG_EDIMSG := "- " + "Conhecimento já cadastrado."
					GXG->GXG_EDISIT := '3'
				Else
					GFELog115:Add("** " + "Não é possível importar documento de frete substituto " +;
					"pois o documento de frete substituído ainda existe na base. " +;
					"Filial Docto: " + AllTrim(GXG->GXG_FILDOC) +;
					" Especie Docto: " + AllTrim(GXG->GXG_CDESP) +;
					" Emis Docto: " + AllTrim(GXG->GXG_EMISDF) +;
					" Serie Docto: " + AllTrim(GXG->GXG_SERDF) +;
					" Nr Docto: X." + AllTrim(GXG->GXG_NRDF), 1)
					GFELog115:Save()

					GXG->GXG_EDIMSG := "- " + "Não é possível importar documento de frete substituto " +;
					"pois o documento de frete substituído ainda existe na base. " +;
					"Filial Docto: " + AllTrim(GXG->GXG_FILDOC) +;
					" Especie Docto: " + AllTrim(GXG->GXG_CDESP) +;
					" Emis Docto: " + AllTrim(GXG->GXG_EMISDF) +;
					" Serie Docto: " + AllTrim(GXG->GXG_SERDF) +;
					" Nr Docto: X." + AllTrim(GXG->GXG_NRDF)
					GXG->GXG_EDISIT := '3'
				EndIf
				MsUnLock("GXG")
				dbSelectArea('GXG')
				(cGXGPro)->( dbSkip() )
				Loop
			EndIf

		Endif
		// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
		If GXG->GXG_ACAO == "E"
			dbSelectArea("GVT")
			aGVTStruct := GVT->( dbStruct() )

			//Número do Documento de Frete
			cNRDF := GXG->GXG_NRDF

			If AScan(aGVTStruct, {|x| x[1] == "GVT_FORMNM"}) != 0

				dbSelectArea("GVT")
				GVT->( dbSetOrder(1) )
				If GVT->( dbSeek(xFilial("GVT") + GXG->GXG_CDESP) )

					If GVT->GVT_ZEROS == "2"
						cNRDF := GFEZapZero(AllTrim(GXG->GXG_NRDF))
					ElseIf GVT->GVT_ZEROS == "3"
						cNRDF := PadL(AllTrim(GFEZapZero(GXG->GXG_NRDF)), IIf(GVT->GVT_QTALG == 0, TamSX3("GW3_NRDF")[1], GVT->GVT_QTALG), "0")
					EndIf

					If Len(AllTrim(cNRDF)) > GVT->GVT_QTALG .And. GVT->GVT_QTALG != 0
						GFELog115:Add("** " + "A quantidade de caracteres no Número do Documento de Frete ultrapassa o delimitado no cadastro da Espécie.", 1)
						GFELog115:Save()
						dbSelectArea('GXG')
						(cGXGPro)->( dbSkip() )
						Loop
					EndIf

					If GVT->GVT_FORMNM == "1" .And. !GFEVldFor1(AllTrim(cNRDF), "IsDigit")
						GFELog115:Add("** " + "O Número do Documento de Frete deve possuir apenas algarismos conforme parametrizado no cadastro da Espécie.", 1)
						GFELog115:Save()
						dbSelectArea('GXG')
						(cGXGPro)->( dbSkip() )
						Loop
					ElseIf GVT->GVT_FORMNM == "2" .And. !GFEVldFor1(AllTrim(cNRDF), "LetterOrNum")
						GFELog115:Add("** " + "O Número do Documento de Frete deve possuir apenas algarismos ou letras conforme parametrizado no cadastro da Espécie.", 1)
						GFELog115:Save()
						dbSelectArea('GXG')
						(cGXGPro)->( dbSkip() )
						Loop
					EndIf
				else
					cEsp := GXG->GXG_CDESP
					GFELog115:Add("** " + cEsp + "- Espécie não encontrada para o documento.", 1)
					GFELog115:Save()
					dbSelectArea('GXG')
					(cGXGPro)->( dbSkip() )
					Loop

				EndIf

				dbSelectArea("GW3")
				dbSetOrder(1)
				If dbSeek(PadR(GXG->GXG_FILDOC, TamSX3("GW3_FILIAL")[1]) + ;
				PadR(GXG->GXG_CDESP,  TamSX3("GW3_CDESP")[1])  + ;
				PadR(GXG->GXG_EMISDF, TamSX3("GW3_EMISDF")[1]) + ;
				PadR(GXG->GXG_SERDF,  TamSX3("GW3_SERDF")[1])  + ;
				PadR(cNRDF,           TamSX3("GW3_NRDF")[1])   + ;
				DTOS(GXG->GXG_DTEMIS))
					GFELog115:Add("** Documento de Frete" + PadR(cNRDF,TamSX3("GW3_NRDF")[1]) + " - Encontrado para exclusão.", 1)
				Else
					GFELog115:Add("** Documento de Frete" + PadR(cNRDF,TamSX3("GW3_NRDF")[1]) + " - Não encontrado para exclusão.", 1)
					RecLock("GXG",.F.)
					GXG->GXG_EDIMSG := STR0006 //"Não foi encontrado o Documento de Frete para ser excluído."
					GXG->GXG_EDISIT := '3'
					MsUnLock("GXG")
					(cGXGPro)->( dbSkip() )
					Loop
				EndIf

			EndIf

			// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
			GFELog115:Add("> Exclusão")
			oModel:SetOperation( 5 )
		Else
			oModel:SetOperation( 3 )
		EndIf

		// Antes de atribuirmos os valores dos campos temos que ativar o modelo
		DbSelectArea('GXH')
		GXH->( dbSetOrder(1) )
		GXH->( dbSeek(GXG->GXG_FILIAL + GXG->GXG_NRIMP) )
		If !empty(GXH->GXH_FILDC)
			cFilAnt := GXH->GXH_FILDC
		else
			cFilAnt := GXG->GXG_FILDOC
		Endif
		oModel:Activate()

		If GXG->GXG_ACAO != "E"

			//Quando a rotina é chamada via Schedule não se sabe se a origem
			//é EDI ou CT-e, por isso deve verificar a GXG_ORIGEM
			If lSchedule .And. GXG->GXG_ORIGEM == '2'
				cOrigem := '3'
			EndIf

			DbSelectArea('GXH')
			GXH->( dbSetOrder(1) )
			GXH->( dbSeek(GXG->GXG_FILIAL + GXG->GXG_NRIMP) )
			If Empty(GXH->GXH_TPDC)
				ReprocessDoctoCarga(GXG->GXG_FILIAL, GXG->GXG_NRIMP, )
			EndIf

			// Carrega os dados do documento de frete no model
			oModel:SetValue("GFEA065_GW3",'GW3_CDESP'  ,ALLTRIM(GXG->GXG_CDESP ) )
			IF !oModel:SetValue("GFEA065_GW3",'GW3_EMISDF' ,ALLTRIM(GXG->GXG_EMISDF) )

				cMsgErro := GU3Valid(GXG->GXG_EMISDF, 'Campo GXG_EMISDF: ')
				RecLock("GXG",.F.)
				GFELog115:NewLine()
				GFELog115:Add( cMsgErro )

				GXG->GXG_EDIMSG := cMsgErro
				GXG->GXG_EDISIT := '3'
				MsUnLock("GXG")

				lRet := .F.
			EndIf
			oModel:SetValue("GFEA065_GW3",'GW3_SERDF'  ,ALLTRIM(GXG->GXG_SERDF) )
			oModel:SetValue("GFEA065_GW3",'GW3_NRDF'   ,ALLTRIM(GXG->GXG_NRDF)  )
			oModel:SetValue("GFEA065_GW3",'GW3_DTEMIS' ,GXG->GXG_DTEMIS )
			oModel:SetValue("GFEA065_GW3",'GW3_DTENT ' ,GXG->GXG_DTENT  )
			IF !oModel:SetValue("GFEA065_GW3",'GW3_CDREM'  ,ALLTRIM(GXG->GXG_CDREM))
				cMsgErro := GU3Valid(GXG->GXG_CDREM, 'Campo GXG_CDREM: ')
				RecLock("GXG",.F.)
				GFELog115:NewLine()
				GFELog115:Add( cMsgErro )

				GXG->GXG_EDIMSG := cMsgErro
				GXG->GXG_EDISIT := '3'
				MsUnLock("GXG")

				lRet := .F.
			EndIf
			If !oModel:SetValue("GFEA065_GW3",'GW3_CDDEST' ,ALLTRIM(GXG->GXG_CDDEST) )
				cMsgErro := GU3Valid(GXG->GXG_CDDEST, 'Campo GXG_CDDEST: ')
				RecLock("GXG",.F.)
				GFELog115:NewLine()
				GFELog115:Add( cMsgErro )

				GXG->GXG_EDIMSG := cMsgErro
				GXG->GXG_EDISIT := '3'
				MsUnLock("GXG")

				lRet := .F.
			EndIf
			oModel:SetValue("GFEA065_GW3",'GW3_TPDF'   ,ALLTRIM(GXG->GXG_TPDF) )
			oModel:SetValue("GFEA065_GW3",'GW3_PESOR'  ,GXG->GXG_PESOR  )
			oModel:SetValue("GFEA065_GW3",'GW3_PESOC'  ,GXG->GXG_PESOC  )
			oModel:SetValue("GFEA065_GW3",'GW3_FRPESO' ,GXG->GXG_FRPESO )
			oModel:SetValue("GFEA065_GW3",'GW3_FRVAL'  ,GXG->GXG_FRVAL  )
			oModel:SetValue("GFEA065_GW3",'GW3_TAXAS'  ,GXG->GXG_TAXAS  )
			oModel:SetValue("GFEA065_GW3",'GW3_PEDAG'  ,GXG->GXG_PEDAG  )
			oModel:SetValue("GFEA065_GW3",'GW3_VLDF'   ,GXG->GXG_VLDF   )
			oModel:SetValue("GFEA065_GW3",'GW3_CFOP'   ,GXG->GXG_CFOP)
			oModel:SetValue("GFEA065_GW3",'GW3_ORIGEM' ,cOrigem)
			oModel:SetValue("GFEA065_GW3",'GW3_QTDCS'  ,GXG->GXG_QTDCS)
			oModel:SetValue("GFEA065_GW3",'GW3_VOLUM'  ,GXG->GXG_VOLUM)
			oModel:SetValue("GFEA065_GW3",'GW3_VLCARG' ,GXG->GXG_VLCARG)
			oModel:SetValue("GFEA065_GW3",'GW3_QTVOL'  ,GXG->GXG_QTVOL)
			If GXG->GXG_TPDF == '7' .And. GFXCP12117("GXG_CDTPSE")
				oModel:SetValue("GFEA065_GW3",'GW3_CDTPSE' ,GXG->GXG_CDTPSE )
			EndIf

			If GXG->GXG_TPDF != '3' .And. Abs(GXG->GXG_BASIMP - GXG->GXG_VLDF) > GXG->GXG_PEDAG .And. GXG->GXG_TRBIMP == "1"
				oModel:LoadValue("GFEA065_GW3",'GW3_TRBIMP',"5")
			Else
				oModel:LoadValue("GFEA065_GW3",'GW3_TRBIMP',GXG->GXG_TRBIMP )
			EndIf

			oModel:LoadValue("GFEA065_GW3",'GW3_PCIMP' ,GXG->GXG_PCIMP  )
			oModel:LoadValue("GFEA065_GW3",'GW3_BASIMP',GXG->GXG_BASIMP )
			oModel:LoadValue("GFEA065_GW3",'GW3_VLIMP' ,GXG->GXG_VLIMP )

			oModel:LoadValue("GFEA065_GW3",'GW3_IMPRET',GXG->GXG_IMPRET )
			oModel:LoadValue("GFEA065_GW3",'GW3_PCRET',GXG->GXG_PCRET )

			oModel:SetValue("GFEA065_GW3",'GW3_ORINR' ,ALLTRIM(GXG->GXG_ORINR ) )
			oModel:SetValue("GFEA065_GW3",'GW3_ORISER',ALLTRIM(GXG->GXG_ORISER) )
			oModel:LoadValue("GFEA065_GW3",'GW3_CTE'  ,AllTrim(GXG->GXG_CTE) )

			If GFXCP12116("GXG","GXG_OBS")
				oModel:SetValue("GFEA065_GW3",'GW3_OBS' ,ALLTRIM(GXG->GXG_OBS ) )
			EndIf

			If Empty(GXG->GXG_CTE)
				oModel:LoadValue("GFEA065_GW3",'GW3_TPCTE'   , " ")
			ElseIf !Empty(GXG->GXG_CTE) .and. (GXG->GXG_TPCTE)<> '0'
				oModel:LoadValue("GFEA065_GW3",'GW3_TPCTE'   ,AllTrim(GXG->GXG_TPCTE) )
			Else
				oModel:LoadValue("GFEA065_GW3",'GW3_TPCTE'   , "0")
			EndIf

			// Início Ponto de Entrada Procomp
			If s_GFEA1157
				ExecBlock("GFEA1157",.f.,.f.,{oModel})
			EndIf
			// Fim Ponto de Entrada Procomp

			nCountDC := 0
			GFELog115:Add("  - Documentos de Cargas")

			DbSelectArea('GXH')
			GXH->( dbSetOrder(1) )
			GXH->( msSeek(GXG->GXG_FILIAL + GXG->GXG_NRIMP) )
			aErroLinha := {}
			While !GXH->(Eof()) .AND. ;
			GXH->GXH_FILIAL == GXG->GXG_FILIAL .AND. ;
			GXH->GXH_NRIMP  == GXG->GXG_NRIMP

				If GXH->GXH_FILDC != GXG->GXG_FILDOC
					RecLock("GXG",.F.)
					GFELog115:NewLine()
					GFELog115:Add("** " + " Filiais Diferentes entre Documento de Carga: " + GXH->GXH_FILDC + " e Documento de Frete:  " + GXG->GXG_FILDOC, 1)
					GXG->GXG_EDIMSG := "** Filiais Diferentes entre Documento de Carga: " + GXH->GXH_FILDC + " e Documento de Frete:  " + GXG->GXG_FILDOC
					GXG->GXG_EDISIT := '3'
					MsUnLock("GXG")

					lRet := .F.
					Exit
				EndIf


				nCountDC++

				GFELog115:Add(" #" + cValToChar(nCountDC) + " - Filial: " + GXH->GXH_FILDC + ", Emissor: " + GXH->GXH_EMISDC + ", Série: " + GXH->GXH_SERDC + ", Número: " + GXH->GXH_NRDC + ", Tipo DC: " + GXH->GXH_TPDC, 2)

				If nCountDC > 1
					oModelGW4:addLine()
				EndIf

				If !lDCUsoCons
					dbSelectArea("GW1")
					GW1->( dbSetOrder(If(__lCpoSr,15,1)) ) //Índice muda quando funcionalidade de chave única protheus estiver habilitada
					If GW1->( dbSeek(GXH->GXH_FILDC + GXH->GXH_TPDC + GXH->GXH_EMISDC + PadR(GXH->GXH_SERDC,__nTamSrDC) + GXH->GXH_NRDC) )
						If __lCpoSr // Quando novo conceito de chave única, utiliza o último documento de carga
							While GW1->(!Eof()) .And. ;
							GW1->GW1_FILIAL == GXH->GXH_FILDC .And. ;
							GW1->GW1_CDTPDC == GXH->GXH_TPDC .And. ;
							GW1->GW1_EMISDC == GXH->GXH_EMISDC .And. ;
							GW1->GW1_SERDC == PadR(GXH->GXH_SERDC,__nTamSrDC) .And. ;
							GW1->GW1_NRDC == GXH->GXH_NRDC
								GW1->(dbSkip())
							EndDo

							GW1->(dbSkip(-1))
						EndIf

						If GW1->GW1_USO == "2"
							GFELog115:Add("# Uso e Consumo", 2)
							lDCUsoCons := .T.
						EndIf
					EndIf
				EndIf

				// Se o campo emissor estiver em branco, procura um documento de carga com a filial, serie e número
				If Empty(GXH->GXH_EMISDC)
					GFELog115:Add("** Emissor em branco", 2)
				EndIf

				If Empty(GXH->GXH_TPDC)
					GFELog115:Add("** Tipo de Documento de Carga em branco", 2)
				EndIf

				// Valida se o documento de carga existe
				//Considera documentos com ou sem zeros a esquerda
				nCountZerosNF := 0
				lNrDf := .F.
				dbSelectArea("GW1")
				dbSetOrder(If(__lCpoSr,15,1))
				While nCountZerosNF <= 6
					cNumeroNF := Replicate("0",nCountZerosNF) + GXH->GXH_NRDC
					If GW1->(dbSeek(GXH->GXH_FILDC + GXH->GXH_TPDC + GXH->GXH_EMISDC + PadR(GXH->GXH_SERDC,__nTamSrDC) + AllTrim(cNumeroNF)))
						lNrDf := .T.
						Exit
					EndIf
					nCountZerosNF++
				EndDo

				// Início Ponto de Entrada Procomp
				If s_GFEA1155
					lNrDf := ExecBlock("GFEA1155",.f.,.f.,{lNrDf})
					If lNrDf
						cNumeroNF := GXH->GXH_NRDC
					EndIf
				EndIf
				// Fim Ponto de Entrada Procomp


				if !lNrDf // Não encontrou a NF

					IF lValDC  //Não realiza validação do DF sem NF
						oModelGW4:deleteLine()
					Else
						nCountDC--
						GFELog115:Add("** Documento de Carga não existe. Filial: " + GXH->GXH_FILDC + ", Tipo: " + GXH->GXH_TPDC + ", Emissor: " + GXH->GXH_EMISDC + ", Serie: " + GXH->GXH_SERDC + ", Nr: " + GXH->GXH_NRDC, 2)
						cNumeroNF := GXH->GXH_NRDC // evita o estouro de tamanho devido aos zeros do for
					ENDIF
				endif

				if lNrDf .or. !lValDC


					// Carrega os dados do documento de carga relacionado ao documetno de frete
					oModelGW4:SetValue('GW4_FILIAL', GXH->GXH_FILDC)
					oModelGW4:SetValue('GW4_EMISDF', GXG->GXG_EMISDF)
					oModelGW4:SetValue('GW4_CDESP ', GXG->GXG_CDESP )
					oModelGW4:SetValue('GW4_SERDF' , GXG->GXG_SERDF )
					oModelGW4:SetValue('GW4_NRDF'  , GXG->GXG_NRDF  )
					oModelGW4:SetValue('GW4_DTEMIS', GXG->GXG_DTEMIS)

					If __lCpoSr

						If FindFunction("GFEA517SDC") == .T.
							aDcChave := GFEA517SDC(PadR(cNumeroNF,Len(GW1->GW1_NRDC)), GXH->GXH_TPDC, GXH->GXH_EMISDC, GXH->GXH_SERDC)
						EndIf
						If Len(aDcChave) == 0

							oModelGW4:SetValue('GW4_EMISDC', GXH->GXH_EMISDC)
							If TamSX3("GW4_SERDC")[1] >= TamSX3("GXH_SERDC")[1]	// Verifica tamanhos para nao ocorrer erro ???
								oModelGW4:SetValue('GW4_SERDC' , GXH->GXH_SERDC )
							Else
								MsgInfo( "** O campo Série da tabela 'Doc. Carga dos Doc. Frete' está com o tamanho diferente do campo Série da tabela 'EDI - Doc. Carga do Doc. Frete'" )
							EndIf
							oModelGW4:SetValue('GW4_NRDC'  , Alltrim(cNumeroNF ))
							oModelGW4:SetValue('GW4_TPDC'  , GXH->GXH_TPDC  )

							If !oModelGW4:VldLineData()
								lRet := .F.
								aAdd(aErroLinha,oModel:GetErrorMessage())
								lRetGW4 := .T.
								Exit
							EndIf

						Else
							nPosDcEsc := 0

							oModelGW4:SetValue('GW4_TPDC'  , aDcChave[1,6])
							oModelGW4:SetValue('GW4_EMISDC', aDcChave[1,2])
							oModelGW4:SetValue('GW4_SERDC' , aDcChave[1,4] )
							oModelGW4:SetValue('GW4_NRDC'  , aDcChave[1,5] )

							If __lCpoSDoc
								oModelGW4:SetValue('GW4_SDOCDC', Transform(aDcChave[1,4], "!!!") )
							EndIf

							if !oModelGW4:VldLineData() == .T.
								lRet := .F.
								aAdd(aErroLinha,oModel:GetErrorMessage())
								lRetGW4 := .T.
								Exit
							EndIf

						EndIf
					Else
						oModelGW4:SetValue('GW4_EMISDC', GXH->GXH_EMISDC)
						If TamSX3("GW4_SERDC")[1] >= TamSX3("GXH_SERDC")[1]	// Verifica tamanhos para nao ocorrer erro ???
							oModelGW4:SetValue('GW4_SERDC' , GXH->GXH_SERDC )
						Else
							MsgInfo( "** O campo Série da tabela 'Doc. Carga dos Doc. Frete' está com o tamanho diferente do campo Série da tabela 'EDI - Doc. Carga do Doc. Frete'" )
						EndIf
						oModelGW4:SetValue('GW4_NRDC'  , Alltrim(cNumeroNF ))
						oModelGW4:SetValue('GW4_TPDC'  , GXH->GXH_TPDC  )

						If !oModelGW4:VldLineData()
							lRet := .F.
							aAdd(aErroLinha,oModel:GetErrorMessage())
							lRetGW4 := .T.
							Exit
						EndIf

					EndIf

				endif
				DbSelectArea('GXH')
				GXH->( dbSkip() )
			EndDo

			If !lRet .And. !lRetGW4
				(cGXGPro)->( dbSkip() )
				oModel:DeActivate()
				Loop
			EndIf

			If nCountDC == 0
				GFELog115:Add("** Nenhuma Nota Fiscal importada encontrada para este Documento de Frete. Filial: " + GXG->GXG_FILDOC + ", Seq. Import:" + GXG->GXG_NRIMP, 2)
			EndIf

			GFELog115:Save()

			IF GXG->GXG_TPIMP == "1"
				// Crédito ICMS
				GFELog115:Add("# Verificando crédito ICMS.", 2)
				GFELog115:Add("> Parâmetro MV_GFECRIC: " + If(!Empty(GetNewPar("MV_GFECRIC", "1", cFilAnt)), GetNewPar("MV_GFECRIC", "1", cFilAnt), " < Parâmetro em branco >" ), 2)
				GFELog115:Add("> Tipo de tributação..: " + oModel:GetValue("GFEA065_GW3", "GW3_TRBIMP"), 2)
				GFELog115:Add("> Uso e Consumo.......: " + If(lDCUsoCons, "Sim", "Não"), 2)
				If s_GFECRIC == "2"	// Sem direito a crédito
					IF (!Empty(GXG->GXG_BASIMP))
						GFELog115:Add("- Tipo de tributação alterada para Outros (pelo parâmetro MV_GFECRIC)", 2)
						oModel:LoadValue("GFEA065_GW3", "GW3_TRBIMP", "6")	// Só muda para a tributação para Outros, se não tiver base de imposto.
					Endif
				EndIf

				If !lDCUsoCons .And. oModel:GetValue("GFEA065_GW3", "GW3_TRBIMP") $ "1;3;4;5;7"
					oModel:LoadValue("GFEA065_GW3", "GW3_CRDICM", "1")
					GFELog115:Add("- Com direito a crédito ICMS.", 2)
				Else
					oModel:LoadValue("GFEA065_GW3", "GW3_CRDICM", "2")
					GFELog115:Add("- Sem direito a crédito ICMS.", 2)
				EndIf
			Else
				GFELog115:Add("# Imposto ISS, não verifica Credito ICMS.",2)
			EndIf

			GFELog115:Save()

			// Crédito PIS/COFINS
			GFELog115:Add("# Verificando crédito PIC/COFINS.", 2)
			GFELog115:Add("- Parâmetro MV_GFEPC..: " + If(!Empty(GetNewPar("MV_GFEPC", "1", cFilAnt)), GetNewPar("MV_GFEPC", "1", cFilAnt), " < Parâmetro em branco >" ), 2)
			cCredPC := GetNewPar("MV_GFEPC", "1", cFilAnt)
			If Empty(cCredPC)
				cCredPC := "1"
			EndIf
			GFELog115:Add("- " + If(cCredPC == "1", "com", "sem") + " direito a crédito PIS/COFINS." , 2)

			If cCredPC == "1" .And. !lDCUsoCons .And. (!Posicione("GU3", 1, xFilial("GU3") + oModel:GetValue("GFEA065_GW3", "GW3_CDREM"), "GU3->GU3_EMFIL") == "1" .Or. ;
			!Posicione("GU3", 1, xFilial("GU3") + oModel:GetValue("GFEA065_GW3", "GW3_CDDEST"), "GU3->GU3_EMFIL") == "1")
				oModel:LoadValue("GFEA065_GW3", "GW3_CRDPC", "1")
			Else
				oModel:LoadValue("GFEA065_GW3", "GW3_CRDPC", "2")
			EndIf
		Else
			lRet := .T.
		EndIf

		// INI - Verifica tamanhos para nao ocorrer erro ???
		If TamSX3("GW4_SERDC")[1] != TamSX3("GXH_SERDC")[1]

			RecLock("GXG",.F.)
			GFELog115:NewLine()
			GFELog115:Add( "** O campo Série da tabela 'Doc. Carga dos Doc. Frete' está com o tamanho diferente do campo Série da tabela 'EDI - Doc. Carga do Doc. Frete'" )

			GXG->GXG_EDIMSG := "** O campo Série da tabela 'Doc. Carga dos Doc. Frete' está com o tamanho diferente do campo Série da tabela 'EDI - Doc. Carga do Doc. Frete'"
			GXG->GXG_EDISIT := '3'
			MsUnLock("GXG")

			lRet := .F.
		EndIf
		// FIM - Verifica tamanhos para nao ocorrer erro ???

		// Existem um delay entre a gravação dos dados no Banco de Dados e a consulta se o registro existe.
		// para ter um tempo para o proximo registro realizar consulta, é gravado o tempo novamente para que o proximo registro localize o registro
		// alterado no banco de dados.
		PutGlbValue(cLock, GFENow(.T.,,'','','')) // Atualiza o tempo para que o proximo processo aguarde

		If lRet
			lRet := oModel:VldData()
		EndIf

		If (lRet) // Validou o modelo para exclusão

			If GXG->GXG_ACAO == "E"

				dbSelectArea('GXH')
				GXH->( dbSetOrder(1) )
				GXH->( dbSeek(GXG->GXG_FILIAL + GXG->GXG_NRIMP) )

				cCont:= 0
				cContDel := 0
				// Valida se existem diferenças de documentos
				// do registro intermediário para o documento de frete eliminado
				While !Eof() .And. GXG->GXG_FILIAL + GXG->GXG_NRIMP == GXH->GXH_FILIAL + GXH->GXH_NRIMP
					cCont:= cCont +1

					GW4->( dbSetOrder( If(__lCpoSr,3,1) ) )
					If GW4->( dbSeek(GXG->GXG_FILDOC;
					+PadR(GXG->GXG_EMISDF, TamSx3("GW4_EMISDF")[1]);
					+PadR(GXG->GXG_CDESP, TamSx3("GW4_CDESP")[1]);
					+PadR(GXG->GXG_SERDF,TamSX3("GW4_SERDF")[1]);
					+PadR(cNRDF,TamSx3("GW4_NRDF")[1]);
					+DTOS(GXG->GXG_DTEMIS);
					+PadR(GXH->GXH_EMISDC, TamSx3("GW4_EMISDC")[1]);
					+PadR(GXH->GXH_SERDC,__nTamSrDC);
					+PadR(GXH->GXH_NRDC,TamSx3("GW4_NRDC")[1]);
					+PadR(GXH->GXH_TPDC,TamSx3("GW4_TPDC")[1])) )

						cContDel := cContDel + 1
					Else
						cNum := GXH->GXH_NRDC
						cSer := GXH->GXH_SERDC
						cEmi := GXH->GXH_EMISDC
						Exit
					EndIf
					DbSelectArea('GXH')
					GXH->( dbSkip() )
				EndDo

				If cContDel == cCont .And. cCont > 0
					dbSelectArea('GW3')
					GW3->( dbSetOrder(1) )

					If GW3->( dbSeek(GXG->GXG_FILDOC;
					+PadR(GXG->GXG_CDESP,TamSx3("GW3_CDESP")[1]);
					+PadR(GXG->GXG_EMISDF, TamSx3("GW3_EMISDF")[1]);
					+PadR(GXG->GXG_SERDF,TamSX3("GW3_SERDF")[1]);
					+PadR(cNRDF,TamSx3("GW3_NRDF")[1]);
					+DTOS(GXG->GXG_DTEMIS)) )
						lOk := .T.
						oModel:CommitData()
					EndIf
				Else
					lMsgErr := .T.
				EndIf

			ElseIf GXG->GXG_ACAO $ "IC"

				// Início Ponto de Entrada Procomp
				If s_GFEA1154
					cFilAtu := cFilAnt
					cFilAnt := GXG->GXG_FILDOC
				EndIF
				// Fim Ponto de Entrada Procomp

				oModel:CommitData()

				// Início Ponto de Entrada Procomp
				If s_GFEA1154
					cFilAnt = cFilAtu
				EndIf
				// Fim Ponto de Entrada Procomp

				lOk := .T.
			EndIf

			//Validou os registros intermediários
			If lOk
				nCount++
				RecLock("GXG",.F.)
				GXG->GXG_EDIMSG := ""
				GXG->GXG_EDISIT := '4'
				If lRetMsg
					GXG->GXG_EDIMSG := "Documento de Carga possui ocorrência!"
				EndIf
				MsUnLock("GXG")
			Else
				RecLock("GXG",.F.)
				If lMsgErr
					// STR0006 //"Não foi encontrado o Documento de Frete para ser excluído."
					GXG->GXG_EDISIT := '3'
					GXG->GXG_EDIMSG := STR0006 + "   Erro no Documento de Carga -  Série: " + cSer +" Número: "+cNum+" Emissor: "+ cEmi
				EndIf
				MsUnLock("GXG")
			EndIf
		Else

			//  A estrutura do vetor aErro com erro é:
			//  [1] Id do formulário de origem
			//  [2] Id do campo de origem
			//  [3] Id do formulário de erro
			//  [4] Id do campo de erro
			//  [5] Id do erro
			//  [6] mensagem do erro
			//  [7] mensagem da solução
			//  [8] Valor atribuido
			//  [9] Valor anterior
			dbSelectArea('GXH')
			GXH->( dbSetOrder(1) )
			If(GXH->( dbSeek(GXG->GXG_FILIAL + GXG->GXG_NRIMP) ))
				cEmi  		:= PadR(GXH->GXH_EMISDC, TamSx3("GW4_EMISDC")[1])
				cSer  		:= PadR(GXH->GXH_SERDC, TamSx3("GW4_SERDC")[1])
				cNum  		:= PadR(GXH->GXH_NRDC, TamSx3("GW4_NRDC")[1])
				cNumDFRed 	:= ""
				GW4->(dbSetOrder(2))
				GW4->(dbSeek(GXH->GXH_FILDC;
				+ PadR(cEmi, TamSx3("GW4_EMISDC")[1]);
				+ PadR(cSer, TamSx3("GW4_SERDC")[1]);
				+ PadR(cNum, TamSx3("GW4_NRDC")[1])))
				While !Eof() .And. GXH->GXH_FILDC + cEmi + cSer + cNum == ;
				GW4->GW4_FILIAL + GW4->GW4_EMISDC + GW4->GW4_SERDC + GW4->GW4_NRDC
					dbSelectArea("GW3")
					dbSetOrder(1)
					If(dbSeek(GW4->GW4_FILIAL + GW4->GW4_CDESP + GW4->GW4_EMISDF + GW4->GW4_SERDF + GW4->GW4_NRDF)) .And. GW3->GW3_TPDF == "6"
						cNumDFRed := GW3->GW3_NRDF
					EndIf
					GW4->(dbSkip())
				EndDo
			EndIf

			// Recupera as mensagens de erro
			aErro := oModel:GetErrorMessage()

			RecLock("GXG",.F.)
			GFELog115:NewLine()
			GFELog115:Add("** " + "Erro na inclusão do registro. Campo: " + aErro[4] + ". Motivo: " + aErro[6], 1)
			lPriErro := .T.
			For nX := 1 To Len(aErroLinha)
				//aErro := aErroLinha[nX]
				If !Empty( aErroLinha[nX][4]) .Or. !Empty( aErroLinha[nX][6] )
					If lPriErro
						lPriErro := .F.
						GXG->GXG_EDIMSG += CRLF + "Ocorreu um ou mais erros na inclusão de documentos: " + CRLF
					EndIf
					GXG->GXG_EDIMSG += "Campo: " + aErroLinha[nX][4] + '. Motivo: ' + aErroLinha[nX][6]
				EndIf
			Next nX
			GXG->GXG_EDIMSG += "Campo: " + aErro[4] + '. Motivo: ' + aErro[6]
			GXG->GXG_EDISIT := '3'
			If lRetRedes
				GXG->GXG_EDIMSG := "** Erro na inclusão do registro."+ CRLF +"O Documento de Carga " + Trim(cNum) + " já está vinculado em outro Documento de Frete (" + Trim(cNumDFRed) + ") do tipo redespacho para este emissor."
			EndIf
			MsUnLock("GXG")
		EndIf

		If s_GFEA1154
			cFilAnt = cFilAtu
		EndIf

		oModel:DeActivate()

		GFELog115:NewLine()
		GFELog115:Add(Replicate(".", 120))
		GFELog115:NewLine()
		GFELog115:Save()

		// Existem um delay entre a gravação dos dados no Banco de Dados e a consulta se o registro existe.
		// para ter um tempo para o proximo registro realizar consulta, é gravado o tempo novamente para que o proximo registro localize o registro
		// alterado no banco de dados.
		PutGlbValue(cLock, GFENow(.T.,,'','','')) // Atualiza o tempo para que o proximo processo aguarde

		dbSelectArea('GXG')
		(cGXGPro)->( dbSkip() )
	EndDo

	RestArea(aAreaGW1)
	(cGXGPro)->( dbCloseArea() )

	If nCount == 0 .And. lProc
		GFELog115:Add("Nenhum Registros processados com sucesso.")
		GFELog115:Add("Total de registros processados: " + cValToChar(nTotal))
		If !lSchedule
			MessageBox ("Nenhum registro processado com sucesso. Total de registros processados: " + cValToChar(nTotal) + CRLF + "Verifique o campo 'Mensagens' dos registros para a descrição dos erros ocorridos.", "Processamento", 48)
		EndIf
	ElseIf nCount == 0 .And. !lProc
		//		GFELog115:Add("** " + STR0009)
		If !lSchedule .and. !(SuperGetMV('MV_IMPPRO',,'1') == '2')
			MessageBox ( "Processamento", 48) 	// "Não há registros para processar."
		EndIf
	ElseIf nCount > 0 .And. lProc
		//		GFELog115:Add(STR0007)
		//		GFELog115:Add(STR0010 + AllTrim(Str(nCount)) + STR0011 + AllTrim(Str(nTotal)))
		If !lSchedule
			MsgInfo(STR0007 + CRLF + STR0010 + AllTrim(Str(nCount)) + STR0011 + AllTrim(Str(nTotal)) + "." + CRLF + ; //"Processo concluído. " ### "Processado(s) " ### " fatura(s) do total de "
			If(nCount != nTotal, "Verifique o campo 'Mensagens' dos registros para a descrição dos erros ocorridos.","") + CRLF + ;
			If(nContMsg != 0, "Documento(s) processados com sucesso, mas a integração com o fiscal não foi executada, pois não há fatura de frete relacionado ao(s) documento(s) de frete para definir a data de transação. Verificar o parâmetro 'Data de Transação do Documento Fiscal' na aba 'Integrações Datasul'.","") ;
			,"")//"Processo concluído. " ### "Processada(s) " ### " ocorrências(s) do total de "
		EndIf
	EndIf
	cFilAnt := cFilTemp
	GFELog115:EndLog()
	If FindFunction("GFEA517SVW") == .T.
		GFEA517SVW(.T.)
	EndIf
Return