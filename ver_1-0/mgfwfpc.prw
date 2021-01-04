#include "Protheus.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "RPTDEF.CH"
#include "FWPrintSetup.ch"
#include "totvs.ch"
#define CRLF chr(13) + chr(10)    
/*
=====================================================================================
Programa............: MGFWFPC
Autor...............: Roberto Sidney
Data................: 27/09/2016
Descricao / Objetivo: WF - 	Workflow Pedido de compras aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Envio de Workflow de Pedido aos fornecedores
=====================================================================================
*/
User Function MGFWFPC(cFornece,cLoja,cNum)
Local aCond:={}, aFrete:= {}, aSubst:={}, nTotal := 0
Local _cC7_NUM, _cC7_FORNECE, _cC7_LOJA, _cC7_PRODUTO, _cB1_TIPO
Local cAttach 	  := ""
Local cDirLayout  := "WORKFLOW\HTML\"
Local cEmailBody  := ""
Local cTipoFrete  := ""
Local nTotalFrete := 0
Local nTotalDesc  := 0
Local nTotalIPI   := 0
Local nTotalPRD   := 0

local cCotFor  := ""
local _cDescri := ""
Local _cMarca := ""
Local cNComprador := ''
Local cTEL        := ''
Local cEmail      := ''
Local cNCompFrete := ''
Local cTELCFree   := ''
Local cEmailCFret := ''

Local aEmailNFE := FWGetSX5("ZA")
Local cCtaReceb := Lower(GetMv("MGF_RECEBE")) // Email para recebimento
Local cCtaAgend := Lower(GetMv("MGF_AGENTR")) // E-mail para agendamento de entregas
Local cCompFret := Lower(GetMv("MGF_COMFRE")) // Comprador de frete

// Informeções do e-mail da UF
Local _cUFEMP := ''
Local nPosUF := 0
Local _cEMAILUF := ''

// Informações do fornecedor de frete
Local _cDescCom:= ""
Local _cDescFone:= ""
Local cDesEmail:= ""

Local aProdProc := {}
Local cArqProdProc := ""
Local lAchouSY1 := .F.

Private _cEmlFor := ""
Private _aEmail	 := {}
Private cContato := ""

IF LEN(aEmailNFE) = 0
	msgalert("Tabela ZA - Email para NF-e não cadastrada")
	Return(.F.)
Endif
// workflow de envio Pedido de Compras.

dbSelectArea("SC7")
dbSetOrder(3)
dbSeek(xFilial("SC7")+cFornece+cLoja+cNum)
while SC7->(!eof()) .and. (cFornece == SC7->C7_FORNECE) .AND. (cLoja == SC7->C7_LOJA) .AND. (cNum = SC7->C7_NUM)
	
	cNComprador := ''
	cTEL        := ''
	cEmail      := ''
	
	cNCompFrete := ''
	cTELCFree   := ''
	cEmailCFret := ''
	
	_cDescCom:= ""
	_cDescFone:= ""
	cDesEmail:= ""
	
	DbSelectArea("SY1")
	SY1->(dbSetOrder(3))

	lAchouSY1 := .F.
	If !Empty(SC7->C7_COMPRA)
		SY1->(dbSetOrder(1))
		If SY1->(dbSeek(xFilial("SY1")+SC7->C7_COMPRA))
			lAchouSY1 := .T.
		Endif	
	Else
		SY1->(dbSetOrder(1))
		SC1->(dbSetOrder(1))
		If SC1->(dbSeek(SC7->C7_FILIAL+SC7->C7_NUMSC+SC7->C7_ITEMSC))
			If !Empty(SC1->C1_CODCOMP)
				If SY1->(dbSeek(xFilial("SY1")+SC1->C1_CODCOMP))
					lAchouSY1 := .T.
				Endif
			Endif
		Endif
	Endif				
		
	//IF SY1->(dbSeek(xFilial("SY1")+RetCodUsr()))
	If lAchouSY1
		cNComprador := SY1->Y1_NOME
		cTEL        := SY1->Y1_TEL
		cEmail      := SY1->Y1_EMAIL
	ENDIF

	DbSelectArea("SY1")
	SY1->(dbSetOrder(3))
	
	// se o tipo de frete for FOB Busca informações do comprador
	if SC7->C7_TPFRETE = 'F'
		SY1->(dbSetOrder(3))
		IF SY1->(dbSeek(xFilial("SY1")+cCompFret))
			cNCompFrete := SY1->Y1_NOME
			cTELCFree   := SY1->Y1_TEL
			cEmailCFret := SY1->Y1_EMAIL
		ENDIF
		
		_cDescCom:= "COMPRADOR DE FRETE: "
		_cDescFone:= "TELEFONE:"
		cDesEmail:= "EMAIL:"
		
	Endif
	
	_cC7_NUM     	:= SC7->C7_NUM
	_cC7_FORNECE 	:= SC7->C7_FORNECE
	_cC7_LOJA    	:= SC7->C7_LOJA
	_cEmlFor		:= ""
	
	cCotFor := ''
	dbSelectArea("SC8")
	dbSetOrder(1)
	dbSeek(xFilial("SC8") + PadR(SC7->C7_NUMCOT,TamSX3("C8_NUM")[1] )	+ PadR(_cC7_FORNECE, TamSX3("C8_FORNECE")[1] ) + PadR(_cC7_LOJA, TamSX3("C8_LOJA")[1] )    )
	While SC8->(!EOF()) ;
		.AND. SC7->C7_NUMCOT   == SC8->C8_NUM ;
		.AND. SC7->C7_FORNECE  == SC8->C8_FORNECE;
		.AND. SC7->C7_NUMCOT   == SC8->C8_NUM
		IF !(Alltrim(SC8->C8_ZCOTF) $ cCotFor )
			cCotFor += Alltrim(SC8->C8_ZCOTF)+'/'
		ENDIF
		SC8->(dbSkip())
	ENDDO
	
	dbSelectArea('SA2')  // Tabela de Fornecedores
	dbSetOrder(1)
	dbSeek( xFilial('SA2') + _cC7_FORNECE + _cC7_LOJA )
	
	_cEmlFor := SA2->A2_EMAIL
	cContato := SA2->A2_CONTATO
	
	if ! Empty(_cEmlFor)
		
		oProcess := TWFProcess():New( "000002", "Pedido de Compra" )
		oProcess :NewTask( "Fluxo de Compras", cDirLayout+"PEDIDO_" + cEmpAnt + ".HTML" )
		oProcess:cTo		:= "000000"	// Administrador
		oProcess:bReturn	:= "U_RETPED(1)"
		oProcess:cSubject	:= "Processo de geração de Pedido de Compra " + _cC7_NUM
		oProcess:UserSiga	:= "000000"
		oProcess:NewVersion(.T.)
		
		oHtml    := oProcess:oHTML
		
		PswOrder(1)
		if PswSeek(cUsuario,.t.)
			aInfo    := PswRet(1)
			_cUser   := aInfo[1,2]
		endIf
		
		_cUser := "000000"
		
		/*** Preenche os dados do cabecalho ***/
		oHtml:ValByname("EMPRESA", SM0->M0_NOMECOM	)
		oHtml:ValByname("ENDER",	Alltrim(SM0->M0_ENDCOB) + " - " + SM0->M0_CIDCOB + " - CEP:" + Transform(SM0->M0_CEPCOB,"@R 99999-999")		)
		
		// Roberto - 14/10/16
		// Endereço de entrega
		oHtml:ValByName( "M0_ENDENT"   , SM0->M0_ENDENT )
		oHtml:ValByName( "M0_BAIRENT"  , SM0->M0_BAIRENT  )
		oHtml:ValByName( "M0_CIDENT"   , SM0->M0_CIDENT )
		oHtml:ValByName( "M0_CEPENT"   , SM0->M0_CEPENT )
		oHtml:ValByName( "M0_ESTENT"   , SM0->M0_ESTENT )
		
		// Endereço de cobrança
		oHtml:ValByName( "M0_ENDCOB"   , SM0->M0_ENDCOB )
		oHtml:ValByName( "M0_CEPCOB"   , SM0->M0_CEPCOB  )
		oHtml:ValByName( "M0_CIDCOB"   , SM0->M0_CIDCOB )
		oHtml:ValByName( "M0_ESTCOB"   , SM0->M0_ESTCOB )
		
		// Verifica o e-mail da U.F de faturamento
		_cUFEMP := alltrim(SM0->M0_ESTCOB)
		nPosUF := aScan(aEmailNFE,{|x| Alltrim(x[3]) == _cUFEMP})
		if nPosUF = 0
			nPosUF := 1
		Endif
		_cEMAILUF := lower(alltrim(aEmailNFE[nPosUF,4]))
		
		// Descrição
		oHtml:ValByname("CDESCOM",_cDescCom)
		oHtml:ValByname("CDESCFONE",_cDescFone )
		oHtml:ValByname("CDESCMAIL",cDesEmail)
		
		// Campos
		oHtml:ValByname("UFMAIL",_cUFEMP)
		oHtml:ValByname("EMAILNFE",_cEMAILUF )
		oHtml:ValByname("RECEBENFE",cCtaReceb)
		oHtml:ValByname("AGENDAALMOX",cCtaAgend )
		oHtml:ValByname("FONE",	cTEL		)
		oHtml:ValByname("COMPR",cNComprador		)
		oHtml:ValByname("EMAIL",cEmail	)
		
		// Comprador de FRETE
		oHtml:ValByname("FONECFRET",cTELCFree		)
		oHtml:ValByname("COMFRET",cNCompFrete		)
		oHtml:ValByname("EMAILCFRET",cEmailCFret	)
		
		oHtml:ValByName( "C7_NUM"    , SC7->C7_NUM )
		oHtml:ValByName( "C8_ZCOTF"    , cCotFor  )
		oHtml:ValByName( "C7_CONTATO" , cContato  )
		//oHtml:ValByName( "C7_VALIDA" , SC7->C7_VALIDA  )
		oHtml:ValByName( "C7_FORNECE", SC7->C7_FORNECE )
		oHtml:ValByName( "C7_LOJA"   , SC7->C7_LOJA    )
		oHtml:ValByName( "C7_OBS"    , /* SC7->C7_OBS */""     )
		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		//³ Inicializar campos de Observacoes Específicas.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_nTamOBS := LEN(RTRIM(SC7->C7_ZCODOBS))    //XCODOBS
		_nCt     := 01
		_nCtPos  := 06               
		_nObsCom := 00  
		_nLin2   := 00
		_cText1  := ""
		_aObsEsp := {}

   		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   		//³ Inicializacao da Observacao do Pedido.                       ³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ        		   			
		FOR _nCt := _nCt TO _nTamOBS 
	        _cCod := SUBSTR(SC7->C7_ZCODOBS,_nCt,_nCtPos)  //XCODOBS
	        _nCt := _nCt + 6          
	        
		    dbSelectArea("ZAO")  // Cadastro de observações
		    ZAO->(DBSETORDER(1))		        
	        ZAO->( DBGoTop() )
		    if ZAO->( dbSeek( space(06) + _cCod ) )   //FWxFilial( "ZAO" )    Compartilhada   space(06)
			   _nObsCom++
			   cVar:="cObs"+StrZero(_nObsCom,2)
			   //_cTexto:=Eval(MemVarBlock(cVar),ZAO->ZAO_DESCRIC)
				   
			   nLin2 := mlcount(cVar,,165,.T.)
             
               For i := 1 to nLin2
                   IF _cText1 = ""
                      _cText1 += memoline(ZAO->ZAO_DESCRIC,132,i,,.F.)
                   ELSE    
                      _cText1 += CRLF+memoline(ZAO->ZAO_DESCRIC,132,i,,.F.)
                   ENDIF
                   oHtml:ValByName( "cTexto",_cText1 )                    
               Next
               
	        ELSE
               oHtml:ValByName( "cTexto",_cText1 ) 
	        Endif

		NEXT
		dbSelectArea('SA2')  // Tabela de Fornecedores
		dbSetOrder(1)
		dbSeek( xFilial('SA2') + _cC7_FORNECE + _cC7_LOJA )
		
		oHtml:ValByName( "A2_NOME"   , SA2->A2_NOME   )
		oHtml:ValByName( "A2_END"    , SA2->A2_END    )
		oHtml:ValByName( "A2_MUN"    , SA2->A2_MUN    )
		oHtml:ValByName( "A2_BAIRRO" , SA2->A2_BAIRRO )
		oHtml:ValByName( "A2_TEL"    , SA2->A2_TEL    )
		oHtml:ValByName( "A2_FAX"    , SA2->A2_FAX    )

		// transportadora
		oHtml:ValByName( "cTransp", getTransp() )

		dbSelectArea('SC7')  // Pedido
		dbSetOrder(3)
		dbSeek( xFilial('SC7') + _cC7_FORNECE + _cC7_LOJA + _cC7_NUM)
		
		dbSelectArea("SE4")
		dbSetOrder(1)
		if dbSeek(xFilial("SE4") + SC7->C7_COND )
			oHtml:ValByName( "Pagamento", SE4->E4_Codigo + " - " + SE4->E4_Descri  )
		endif
		
		
		oHtml:ValByName( "SOLIC"   , GetAdvFVal("SC1","C1_SOLICIT",xFilial("SC1")+SC7->(C7_NUMSC+C7_ITEMSC),1,"") )
		oHtml:ValByName( "A2_CGC"  , Transform(SA2->A2_CGC,IIf(Len(Alltrim(SA2->A2_CGC))==14,"@R 99.999.999/9999-99","@R 999.999.999-99")) )
		oHtml:ValByName( "M0_CGC"  , Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") )
		oHtml:ValByName( "A2_CONTATO"  , SA2->A2_CONTATO )		

		nTotalFrete := 0
		nTotalDesc  := 0
		nTotalIPI   := 0
		nTotalPRD   := 0
		
		aAttach		:= {}
		_cChave		:= SC7->C7_FILIAL+SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA
		
		while SC7->(!eof()) .and. SC7->C7_FILIAL = xFilial("SC7")  ;
			.and. SC7->C7_NUM     = _cC7_NUM ;
			.and. SC7->C7_FORNECE = _cC7_FORNECE ;
			.and. SC7->C7_LOJA    = _cC7_LOJA
			
			// Busca descricao do SA5
			_cDescri := ""
			_cMarca := ""
			// se nao encontrou no SA5 busca do SB1.
			If Empty(_cDescri)
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1") + SC7->C7_PRODUTO ))
				_cDescri := SB1->B1_DESC
				_cMarca  := SB1->B1_ZMARCA
				If !Empty(SB1->B1_CODPROC)
					If aScan(aProdProc,{|x| x[1]==SB1->B1_COD}) == 0
						aAdd(aProdProc,{SB1->B1_COD,SB1->B1_CODPROC})
					Endif	
				Endif
			EndIf
			
			aAdd( (oHtml:ValByName( "it.item"    )), SC7->C7_ITEM    )
			aAdd( (oHtml:ValByName( "it.produto" )), SC7->C7_PRODUTO )
			aAdd( (oHtml:ValByName( "it.descri"  )), _cDescri   )
			aAdd( (oHtml:ValByName( "it.marca"  )), _cMarca   )
			aAdd( (oHtml:ValByName( "it.quant"   )), TRANSFORM( SC7->C7_QUANT, PesqPict( 'SC7', 'C7_QUANT' ) ) )
			aAdd( (oHtml:ValByName( "it.um"      )), SC7->C7_UM      )
			aAdd( (oHtml:ValByName( "it.preco"   )), TRANSFORM( SC7->C7_PRECO, PesqPict( 'SC7', 'C7_PRECO' ) ) )
			aAdd( (oHtml:ValByName( "it.valor"   )), TRANSFORM( SC7->C7_TOTAL,PesqPict( 'SC7', 'C7_TOTAL' ) ) )
//			aAdd( (oHtml:ValByName( "it.moeda"   )), SC7->C7_MOEDA )
			aAdd( (oHtml:ValByName( "it.moeda"   )), GetMV("MV_MOEDA"+alltrim(str(SC7->C7_MOEDA))) ) 
			//aAdd( (oHtml:ValByName( "it.icms"   )),  SC7->C7_PICM )
			aAdd( (oHtml:ValByName( "it.datprf"  )), DTOC(SC7->C7_DATPRF) )
			
			dbSelectArea("SC7")
			RecLock('SC7',.F.)
			SC7->C7_XWFID := oProcess:fProcessID
			SC7->C7_XWFENV := 'S' // Workflow enviado
			MsUnlock()
			
			nTotalFrete += SC7->C7_VALFRE
			nTotalDesc  += SC7->C7_VLDESC
			nTotalIPI   += SC7->C7_VALIPI
			nTotalPRD   += SC7->C7_TOTAL
			if  SC7->C7_TPFRETE = 'C'
				cTipoFrete  := 'CIF'
			Elseif  SC7->C7_TPFRETE = 'F'
				cTipoFrete  := 'FOB'
			Elseif SC7->C7_TPFRETE = 'S'
				cTipoFrete  := 'SEM'
			Elseif  SC7->C7_TPFRETE = 'T'
				cTipoFrete  := 'TER'
			Endif
			
			SC7->(dbSkip())
		enddo
		
		If Len(aProdProc) > 0
			aProdProc := aSort(aProdProc,,,{|x,y| x[1] < y[1]})
			cArqProdProc := RelProdProc(aProdProc)
		Endif
		//   oHtml:ValByName( "c8.filent" , Alltrim(SM0->M0_ENDCOB) + " - " + SM0->M0_CIDCOB + " - CEP:" + Transform(SM0->M0_CEPCOB,"@R 99999-999"))
		//	oHtml:ValByName( "c8.filent2", Alltrim(SM0->M0_ENDCOB) + " - " + SM0->M0_CIDCOB + " - CEP:" + Transform(SM0->M0_CEPCOB,"@R 99999-999"))
		//	oHtml:ValByName( "it.filent" , 'teste 1')
		//	oHtml:ValByName( "it.filent2", 'teste 2')
		
		oHtml:ValByName( "Frete"    , cTipoFrete   )
		oHtml:ValByName( "subtot"   , TRANSFORM( nTotalPRD		, PesqPict( 'SC7', 'C7_TOTAL' ) ) )
		oHtml:ValByName( "vldesc"   , TRANSFORM( nTotalDesc		, PesqPict( 'SC7', 'C7_VLDESC' ) ) )
		oHtml:ValByName( "aliipi"   , TRANSFORM( nTotalIPI		, PesqPict( 'SC7', 'C7_VALIPI' ) ) )
		oHtml:ValByName( "valfre"   , TRANSFORM( nTotalFrete	, PesqPict( 'SC7', 'C7_VALFRE' ) ) )
		nTotalFrete := IIF(cTipoFrete=='CIF',nTotalFrete,0)
		oHtml:ValByName( "totped"   , TRANSFORM( nTotalPRD-nTotalDesc+nTotalIPI+nTotalFrete ,'@E 999,999.99' ) )
		
		_aReturn := {}
		
		AADD(_aReturn, oProcess:fProcessId)
		aAdd( oProcess:aParams, _cChave)
		
		oProcess:nEncodeMime := 0
		
		//garante que o arquivo esteja na pasta onde o arquivo será carregado.
		IF !File("\workflow\messenger\emp" +cEmpAnt  + "\" + _cUser + "\Marfrig.gif")
			__CopyFile(cDirLayout+"Marfrig.gif","\workflow\messenger\emp" +cEmpAnt  + "\" + _cUser + "\Marfrig.gif" )
		endif
		
		cProcess := oProcess:Start("\workflow\messenger\emp" +cEmpAnt  + "\" + _cUser + "\")
		
		chtmlfile  := cProcess + ".htm"
		cmailto    := "mailto:" + AllTrim( GetMV('MV_WFMAIL') )
		
		chtmltexto := wfloadfile("\workflow\messenger\emp" +cEmpAnt  + "\" + _cUser + "\" + chtmlfile )
		chtmltexto := strtran( chtmltexto, cmailto, "WFHTTPRET.APL" )
		
		wfsavefile("\workflow\messenger\emp" +cEmpAnt  + "\" + _cUser + "\" + chtmlfile+"l", chtmltexto)
		fErase("\workflow\messenger\emp" +cEmpAnt  + "\" + _cUser + "\" + chtmlfile)
		
		IF !"@" $ oProcess:cTO
			
			aMsg := {}
			aAdd(aMsg, "Sr.(a) " + cContato )
			AADD(aMsg, "</BR>")
			AADD(aMsg, " Nós da Marfrig S/A através do Departamento de Suprimentos, temos um pedido para sua empresa.")
			AADD(aMsg, " O número do pedido de compra é <b>" + _cC7_NUM + "</b> e para visualiza-lo clique no link abaixo")
			If Len(aProdProc) > 0 .and. File(cArqProdProc)
				AADD(aMsg, "</BR>")
				AADD(aMsg, " Em anexo encontra-se o arquivo em .PDF, com as descrições dos produtos constantes no Pedido.")
				aAdd(aAttach,cArqProdProc)
			Endif	
			AADD(aMsg, "</BR>")
			AADD(aMsg, "</BR>")
			AADD(aMsg, "Atenciosamente ")
			AADD(aMsg, "</BR>")
			AADD(aMsg, "Marfrig ")
			AADD(aMsg, "</BR>")
			aAdd(aMsg, '<p><a href="' +GetNewPar("MGF_WFHTTP","http://172.16.1.236:87/workflow")+'/messenger/emp' +cEmpAnt  + '/' + _cUser + '/' + alltrim(cProcess) + '.html">Clique aqui para visualizar o pedido de compra </a></p>')
			AADD(aMsg, "</BR>")
			AADD(aMsg, "</BR>")

			AADD(aMsg, "</BR>")
			AADD(aMsg, "</BR>")
			AADD(aMsg, "Observação ")
			AADD(aMsg, "</BR>")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao específica do Pedido.            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//If !Empty(SC7->C7_XCODOBS) //.And. nLinObs < 17
			//	SZ5->(dbSetOrder(1))
			//	SZ5->(dbSeek( xFilial("SZ5") + SC7->C7_XCODOBS ))
			//	Eval(MemVarBlock(cVar),SZ5->Z5_DESCRIC)
			//Endif

			//aAdd(aMsg, '<p><a href="' + Eval(MemVarBlock(cVar),SZ5->Z5_DESCRIC) )

			AADD(aMsg, "</BR>")
			AADD(aMsg, "</BR>")

			U_fEnviaLink( _cEmlFor, oProcess:cSubject , aMsg, aAttach )
			MsgInfo("Workflow Enviado","WorFlow")
			If File(cArqProdProc)
				fErase(cArqProdProc)
			Endif
			If File(Subs(cArqProdProc,1,Len(cArqProdProc)-3)+"REL")
				fErase(Subs(cArqProdProc,1,Len(cArqProdProc)-3)+"REL")
			Endif	
		ENDIF
	else
		// Atualizar SC7 para nao processar novamente
		dbSelectArea("SC7")
		RecLock('SC7',.F.)
		SC7->C7_XWFID := "WF9999"
		SC7->C7_XWFENV:= "S"
		MsUnlock()
		dbSkip()
	endif
enddo

Return(.T.)

/*
=====================================================================================
Programa............: MT130B
Autor...............: Roberto Sidney
Data................: 27/09/2016
Descricao / Objetivo: WF - 	Envio da resposta aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina de Retorno no Processo de WorkFlow
=====================================================================================
*/

User Function MT130B()

Return("Sua resposta foi enviada aos servidores do sistema para processamento.")

/*
=====================================================================================
Programa............: RETPED
Autor...............: Roberto Sidney
Data................: 27/09/2016
Descricao / Objetivo: WF - 	Função de retorno do WorkFlow de Pedido de Compras.
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/

User Function RETPED(aOpcao, oProcess)
Local	_cC7_NUM     := oProcess:oHtml:RetByName("C7_NUM"     )
Local	_cC7_FORNECE := oProcess:oHtml:RetByName("C7_FORNECE" )
Local	_cC7_LOJA    := oProcess:oHtml:RetByName("C7_LOJA"    )
Local _cC7_NUMCOT	:= ""
Local nX := 0
dbSelectArea("SC7")
dbSetOrder(3)
if dbSeek( xFilial("SC7") + Padr(_cC7_FORNECE,6) + _cC7_LOJA + Padr(_cC7_NUM,6) )
	RecLock("SC7",.f.)
	SC7->C7_XOK := oProcess:oHtml:RetByName("Aprovacao")
	SC7->C7_OBS := Alltrim(oProcess:oHtml:RetByName("C7_OBS"))
	_cC7_NUMCOT :=  SC7->C7_NUMCOT
	MsUnlock()
	
	for nX := 1 to len(oProcess:oHtml:RetByName("it.produto"))
		_cProd := oProcess:oHtml:RetByName("it.produto")[nX]
	next nX
endif
Return


// funcao para gerar relatorio em .pdf do campo de processos do produto
Static Function RelProdProc(aProdProc)

Local aDevice := {}
Local cDevice := ""
Local cRelName := GetNextAlias()
Local cSession := GetPrinterSession()
Local lAdjustToLegacy := .F.
Local lDisableSetup := .T.
Local nFlags := 0
Local nLocal := 1
Local nOrient := 1
Local nPrintType := 6
Local oPrinter := Nil
Local oSetup := Nil
Local lRet := .F.
Local cLocal := "c:\temp\" //Upper(GetSrvProfString("StartPath",""))+"spool\" //"c:\"
Local cTemp := GetTempPath(.t.) //pega caminho do temp do client
Local lMail := .T.
Local cRet := ""
Local cLocalS := Upper(GetSrvProfString("StartPath",""))+"spool\"

Private nMaxLin	:= 0
Private nMaxCol	:= 0

MakeDir(cLocal)
MakeDir(cLocalS)

nFlags := PD_ISTOTVSPRINTER+PD_DISABLEPAPERSIZE+PD_DISABLEORIENTATION+PD_DISABLEMARGIN

aAdd(aDevice,"DISCO") // 1
aAdd(aDevice,"SPOOL") // 2
aAdd(aDevice,"EMAIL") // 3
aAdd(aDevice,"EXCEL") // 4
aAdd(aDevice,"HTML") // 5
aAdd(aDevice,"PDF") // 6

cSession := GetPrinterSession()
// Obtem ultima configuracao de tipo de impressão (spool ou pdf) gravada no arquivo de configuracao
cDevice := If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
// Obtem ultima configuracao de orientacao de papel (retrato ou paisagem) gravada no arquivo de configuracao
nOrient	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,1)
// Obtem ultima configuracao de destino (cliente ou servidor) gravada no arquivo de configuracao
nLocal := If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2)
nPrintType := 6//aScan(aDevice,{|x| x == cDevice})

If File(cLocal+cRelName+".PDF")
	fErase(cLocal+cRelName+".PDF")
EndIf
If File(cLocal+cRelName+".REL")
	fErase(cLocal+cRelName+".REL")
EndIf
If File(cTemp+cRelName+".PDF")
	fErase(cTemp+cRelName+".PDF")
EndIf
If File(cTemp+cRelName+".REL")
	fErase(cTemp+cRelName+".REL")
EndIf

if !lMail
	oPrinter := FWMSPrinter():New(cRelName,IIf(!lMail,nPrintType,IMP_PDF),lAdjustToLegacy,IIf(!lMail,Nil/*cPathDest*/,cLocal),lDisableSetup,,,,,,,)
Else
	//FWMSPrinter():New(cRelName,IMP_PDF,.F./*lAdjustToLegacy*/,cLocal,.T./*lDisabeSetup*/,/*lTReport*/,@oPrinter,/*cPrinter*/,.F./*lServer*/,/*lPDFAsPNG*/,/*lRaw*/,.F./*lViewPDF*/,/*nQtdCopy*/)
	oPrinter := FWMSPrinter():New(cRelName,IIf(!lMail,nPrintType,IMP_PDF),lAdjustToLegacy,cLocal,lDisableSetup,,,,.F.,,,.F.,)
Endif

oSetup := FWPrintSetup():New(nFlags,cRelName)

oSetup:SetPropert(PD_PRINTTYPE,nPrintType)
oSetup:SetPropert(PD_ORIENTATION,nOrient)
oSetup:SetPropert(PD_DESTINATION,nLocal)
oSetup:SetPropert(PD_MARGIN,{0,0,0,0})
oSetup:SetPropert(PD_PAPERSIZE,1)
//oSetup:SetOrderParms(aOrdem,@nOrdem)

If (!lMail .and. oSetup:Activate() == PD_OK) .or. lMail
	// Grava ultima configuracao de destino (cliente ou servidor) no arquivo de configuracao
	fwWriteProfString(cSession,"LOCAL",If(oSetup:GetProperty(PD_DESTINATION)==1,"SERVER","CLIENT"),.T.)
	// Grava ultima configuracao de tipo e impressao (spool ou pdf) no arquivo de configuracao
	fwWriteProfString(cSession,"PRINTTYPE",If(oSetup:GetProperty(PD_PRINTTYPE)==2,"SPOOL","PDF"),.T.)
	// Grava ultima configuracao de orientacao de papel (retrato ou paisagem) no arquivo de configuracao
	fwWriteProfString(cSession,"ORIENTATION",If(oSetup:GetProperty(PD_ORIENTATION)==1,"PORTRAIT","LANDSCAPE"),.T.)
	// Atribui configuracao de destino (cliente ou servidor) ao objeto FwMsPrinter
	oPrinter:lServer := oSetup:GetProperty(PD_DESTINATION) == AMB_SERVER
	// Atribui configuracao de tipo de impressao (spool ou pdf) ao objeto FwMsPrinter
	oPrinter:SetDevice(oSetup:GetProperty(PD_PRINTTYPE))
	// Atribui configuracao de orientacao de papel (retrato ou paisagem) ao objeto FwMsPrinter
	If oSetup:GetProperty(PD_ORIENTATION) == 1
		oPrinter:SetPortrait()
		nMaxLin	:= 790
		nMaxCol	:= 610
	Endif
	// Atribui configuracao de tamanho de papel ao objeto FwMsPrinter
	oPrinter:SetPaperSize(oSetup:GetProperty(PD_PAPERSIZE))
	oPrinter:SetCopies(Val(oSetup:cQtdCopia))
	If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
		oPrinter:nDevice := IMP_SPOOL
		fwWriteProfString(GetPrinterSession(),"DEFAULT",oSetup:aOptions[PD_VALUETYPE],.T.)
		oPrinter:cPrinter := oSetup:aOptions[PD_VALUETYPE]
	Else
		oPrinter:nDevice := IMP_PDF
		if !lMail
			oPrinter:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
		Else
			oPrinter:cPathPDF := cTemp
		Endif
		//oPrinter:SetViewPDF(.T.)
	Endif
	
	ProdProcImp(@oPrinter,aProdProc)
	
Else
	MsgInfo("Relatório cancelado pelo usuário.")
	oPrinter:Cancel()
EndIf

If lMail
	//Exclui o arquivo antigo (se existir)
	If File(cLocal+cRelName+".PDF")
		fErase(cLocal+cRelName+".PDF")
	EndIf
	File2Printer(cLocal+cRelName+".REL","PDF")
	If CpyT2S(cLocal+cRelName+".PDF",cLocalS)
		cRet := cLocalS+cRelName+".PDF"
	Endif	
Endif

oSetup := Nil
oPrinter := Nil

Return(cRet)


Static Function ProdProcImp(oPrinter,aProdProc)

Local oBox
Local nCol := 30
Local nLin := 30
Local nPag := 1
Local nPulo := 10
Local nCnt := 0
Local nLinIni := 0
Local oFont1
Local cMemo := ""
Local aMemo := {}
Local nCnt1 := 0

oFont1 := TFont():New('Courier new',,10,.T.)

oPrinter:StartPage()
oPrinter:Say(nLin,0500,"Página: "+Alltrim(Str(nPag)),oFont1,,,)

For nCnt:=1 To Len(aProdProc)
	PulaLinha(oPrinter,@nLin,nLinIni,nCol,oBox,@nPag,nPulo*2,.F.,oFont1)
	oPrinter:Say(nLin,nCol,"Cod. Produto: ",oFont1,,,)
	oPrinter:Say(nLin,0100,aProdProc[nCnt][1],oFont1,,,)
	//PulaLinha(oPrinter,@nLin,nLinIni,nCol,oBox,@nPag,nPulo,.F.,oFont1)
	//nLinIni := nLin
	cMemo := MSMM(aProdProc[nCnt][2])
	aMemo := QuebraTexto(cMemo)
	For nCnt1:=1 To Len(aMemo)
		PulaLinha(oPrinter,@nLin,nLinIni,nCol,oBox,@nPag,nPulo,.F.,oFont1)
		If nCnt1==1
			oPrinter:Say(nLin,nCol,"Descrição: ",oFont1,,,)
		Endif	
		oPrinter:Say(nLin,0100,aMemo[nCnt1][1],oFont1,,,)
	Next
	//PulaLinha(oPrinter,@nLin,nLinIni,nCol,oBox,@nPag,nPulo,.T.,oFont1)
Next

oPrinter:EndPage()
oPrinter:Print()

Return()


Static Function PulaLinha(oPrinter,nLin,nLinIni,nCol,oBox,nPag,nPulo,lFechaBox,oFont1)

nLin += nPulo
If nLin > 730 .or. lFechaBox
	If lFechaBox
		//oPrinter:Box(nLinIni,nCol,nLin+0020,nCol+1850,oBox)
	Endif
	oPrinter:EndPage()
	oPrinter:StartPage()
	nPag++
	nLin := 30
	oPrinter:Say(nLin,0500,"Página: "+Alltrim(Str(nPag)),oFont1,,,)
Endif

Return()


Static Function QuebraTexto(cDescAcao)

Local nPosQuebra := 0
Local nDet := 90
Local nCountDesc := 0
Local aObs := {}

While .t.
	nPosQuebra := 0
	If At(chr(13)+Chr(10),AllTrim(SubStr(cDescAcao,1))) < nDet .and. At(chr(13)+Chr(10),AllTrim(SubStr(cDescAcao,1))) <> 0
		nPosQuebra := At(chr(13)+Chr(10),AllTrim(SubStr(cDescAcao,1)))-1
		aAdd(aObs,{SubStr(cDescAcao,1,At(chr(13)+Chr(10),AllTrim(SubStr(cDescAcao,1)))-1)})
		cDescAcao := Alltrim(Subs(cDescAcao,At(chr(13)+Chr(10),AllTrim(SubStr(cDescAcao,1)))+2))
	Else
		If Len(Alltrim(cDescAcao)) > nDet
			If SubStr(cDescAcao,nDet,1) <> " "
				nPosQuebra := rAt(" ",Subs(cDescAcao,1,nDet))
				If Empty(nPosQuebra) // tratamento para quando o usuario informa uma string sem espacos em brancos
					nPosQuebra := nDet
				Endif
			Else
				nPosQuebra := nDet
			Endif
		Else
			nPosQuebra := Len(cDescAcao)
		Endif
		aAdd(aObs,{SubStr(cDescAcao,1,nPosQuebra)})
		cDescAcao := Alltrim(Subs(cDescAcao,nPosQuebra+1))
	EndIf
	nCountDesc++
	If Empty(AllTrim(cDescAcao)) .or. ;
		(Len(AllTrim(cDescAcao))==1 .and. cDescAcao==Chr(10)) .or. (Len(AllTrim(cDescAcao))==1 .and. cDescAcao==Chr(13)) .or. (Len(AllTrim(cDescAcao))==2 .and. cDescAcao==Chr(13)+Chr(10)) .or. ;
		nCountDesc > 50 /*evitar que rotina fique em loop por algum motivo*/
		Exit
	EndIf
EndDo

Return(aObs)

//----------------------------------------------
// Retorna a transportadora
//----------------------------------------------
static function getTransp()
	local cRetTransp	:= ""
	local cQrySC8		:= ""

	cQrySC8 := "SELECT C8_ZTRANSP, A4_NOME"
	cQrySC8 += " FROM "			+ retSQLName( "SC8" ) + " SC8"
	cQrySC8 += " INNER JOIN "	+ retSQLName( "SA4" ) + " SA4"
	cQrySC8 += " ON"
	cQrySC8 += " 		SA4.A4_COD		=	SC8.C8_ZTRANSP"
	cQrySC8 += " 	AND	SA4.A4_FILIAL	=	'" + xFilial( "SA4" )	+ "'"
	cQrySC8 += " 	AND	SA4.D_E_L_E_T_	<>	'*'"
	cQrySC8 += " WHERE"
	cQrySC8 += " 		SC8.C8_NUMPED	=	'" + SC7->C7_NUM		+ "'"
	cQrySC8 += " 	AND	SC8.C8_FILIAL	=	'" + xFilial( "SC8" )	+ "'"
	cQrySC8 += " 	AND	SC8.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySC8 New Alias "QRYSC8"

	if !QRYSC8->( EOF() )
		cRetTransp := "Transportadora: " + allTrim( QRYSC8->A4_NOME )
	endif

	QRYSC8->(DBCloseArea())
return cRetTransp
