#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa.:              MGFEIC09
Autor....:              Renato Junior
Data.....:              17/06/2020
Descricao / Objetivo:   Fonte chamado de Pontos de Entrada para tratar o PC das despesas
Doc. Origem:            RTASK0011180 / RITM0034502
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de entrada padrão MVC EICDI500 (INCLUSAO DO PC)                  
                        Ponto de entrada padrão MVC MT120FIM (EXCLUSAO DO PC)                  
=====================================================================================
*/
User Function EIC09INC()
	Local cRet := ""
	Local aArea := {}
	Local aAreaSWD := {}
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb1,If(Type("ParamIxb") = "C",ParamIxb,""))
	Local cQuery	:= ""

	If cParam == "ALTERA_DESP"//"DESP_ALTERA2"//"DESPESA_OK" .AND. nOpcao    == 3 //1 // Verifica campos obrigatorios para o PC
	
		If M->WD_BASEADI == '2'	.AND. M->WD_GERFIN = '2'	// Valida se é financeiro = N e Adto = N
			//MSGALERT(cParam)
	        If Empty(M->WD_FORN)    .OR. Empty(M->WD_LOJA)
		        MsgInfo("Campos obrigatórios : Fornecedor, Loja", "Aviso")
        	EndIf
		Endif
    EndIF

	If cParam == "INCLUI_DESP"	//"CONFIRMA_DESPESA".AND. nOpcao    == 2 //1
		//MSGALERT(cParam)
		If SWD->WD_BASEADI == '2'	.AND. SWD->WD_GERFIN = '2'	// Valida se é financeiro = N e Adto = N
	        If Empty(SWD->WD_FORN)    .OR. Empty(SWD->WD_LOJA)
	        	MsgInfo("Pedido de Compra não será gerado", "Aviso")
			ElseIf ! Empty(SWD->WD_ZNUMPC)
		        MsgInfo("Campos obrigatórios : Fornecedor, Loja","PC não será gerado")
			Else
    			aArea := GetArea()
	    		aAreaSWD := SWD->(GetArea())
				Processa({|| GravaSC7()()},"Aguarde...","Incluindo Pedido de Compras...",.F.)
			    RestArea(aAreaSWD)
		    	RestArea(aArea)
        	Endif
		Endif
    EndIF
return cRet


//------------------------------------------------------
// inclui o Pedido de Compras por Msexecauto
//------------------------------------------------------
Static Function GravaSC7

Local aSC7Cab		:= {}
Local aSC7Itens		:= {}
Local aSC7Aux		:= {}
Local cItemSC7		:= ""
Local nStackSX8		:= getSx8Len()
Local aErro			:= {}
Local cErro			:= ""
Local cCCdoPC		:=	""
Local cCCdoPC		:= GetMV("MGF_EIC09A",.F.,'2212')	//Centro de Custo
Local cZITEMD	    := GetMV('MGF_EIC09B',.F.,"12")		//Item Contabil
Local cCondPg	    := GetMV('MGF_EIC09C',.F.,"004")	//Condicao de Pagamento

Private lGradeSC7		:= .F.
Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T. 

/*/
//Centro de Custo do PC
	If !ExisteSx6("MGF_EIC09A")
		CriarSX6("MGF_EIC09A", "C", "Centro de Custo do PC", '2212')
	EndIf

	cCCdoPC := superGetMV("MGF_EIC09A", , '2212')
/*/

	aSC7Cab		:= {}
	aSC7Aux		:= {}
	aSC7Itens	:= {}
	AAdd( aSC7Cab , { "C7_EMISSAO"		, dDataBase		, Nil } )
	AAdd( aSC7Cab , { "C7_FORNECE"		, SWD->WD_FORN	, Nil } )
	AAdd( aSC7Cab , { "C7_LOJA"			, SWD->WD_LOJA	, Nil } )
	AAdd( aSC7Cab , { "C7_COND"			, cCondPg		, Nil } )
	AAdd( aSC7Cab , { "C7_FILENT"		, cFilAnt		, Nil } )
	AAdd( aSC7Cab , { "C7_FILIAL"		, cFilAnt		, Nil } )
	cItemSC7 := ""
	cItemSC7 := strZero ( 0 , tamSX3("C7_ITEM")[1] )
	aSC7Aux		:= {}
	cItemSC7	:= soma1( cItemSC7 )
	AAdd( aSC7Aux , { "C7_ITEM"		, cItemSC7					  , Nil } )
	AAdd( aSC7Aux , { "C7_PRODUTO"	, RetCodB1(SWD->WD_DESPESA)   , Nil } )
	AAdd( aSC7Aux , { "C7_QUANT"	, SWD->WD_VALOR_R             , Nil } )
	AAdd( aSC7Aux , { "C7_PRECO"	, 1				              , Nil } )
	AAdd( aSC7Aux , { "C7_CC"		, cCCdoPC					  , Nil } )
	AAdd( aSC7Aux , { "C7_SEQUEN"	, cItemSC7					  , Nil } )
	AAdd( aSC7Aux , { "C7_ORIGEM"	, "SIGAEIC"					  , Nil } )
	AAdd( aSC7Aux , { "C7_FLUXO"	, "S"						  , Nil } )
	AAdd( aSC7Aux , { "C7_QTDSOL"	, SWD->WD_VALOR_R			  , Nil } )
	AAdd( aSC7Aux , { "C7_ZNATURE"	, SYB->YB_NATURE			  , Nil } )
	AAdd( aSC7Aux , { "C7_ITEMCTA"	, cZITEMD					  , Nil } )
	// Grava Relacionamento com a Despesa do Embarque
	AAdd( aSC7Aux , { "C7_ZHAWB"	, SWD->WD_HAWB 				  , Nil } )
	AAdd( aSC7Itens , aSC7Aux )

	varInfo( "aSC7Cab"		, aSC7Cab	)
	varInfo( "aSC7Itens"	, aSC7Itens	)
	lMsErroAuto := .F.
	msExecAuto( { | v , w , x , y , z | mata120( v , w , x , y , z ) } , 1 , aSC7Cab , aSC7Itens , 3 , .f. )
	If lMsErroAuto
		while getSX8Len() > nStackSX8
			ROLLBACKSX8()
		Enddo
		aErro := GetAutoGRLog() // Retorna erro em array
		cErro += ""
		For nX := 1 To len(aErro)
			cErro += aErro[nX] + CRLF  //estava ni
		next nX
		MSGALERT( " MGFEIC09 - MATA120 " + cErro )
	Else
		while getSX8Len() > nStackSX8
			CONFIRMSX8()
		Enddo
        // Grava na SWD o numero do PC
		RECLOCK("SWD",.F.)
        SWD->WD_ZNUMPC  :=  SC7->C7_NUM 
        SWD->(MSUNLOCK())
    EndIf
Return 

//------------------------------------------------------
// Exclui o Pedido de Compras e desmarca campo Flag WD_ZNUMPC
//------------------------------------------------------
User Function EIC09EXC( cPed , nOpx , nOpca )
Local aArea	:= 	GetArea ()
Local cHawb	:=	""

If nOpx == 5 .and. nOpca == 1	// Confirmou a exclusao
	cHawb	:= xFilial("SWD")+SC7->C7_ZHAWB
	SWD->(DBSETORDER(1))
	SWD->(DBSEEK(cHawb))
	While ! SWD->( Eof() ) .AND. cHawb == SWD->(WD_FILIAL+WD_HAWB)
		If SWD->WD_ZNUMPC	==	cPed
			RecLock("SWD", .F.)
			SWD->WD_ZNUMPC := ""
			SWD->(MsUnlock()) 
		EndIf
		SWD->(DBSKIP())
	EndDo
	RestArea( aArea )
Endif
Return()

//-------------------------------------------------------
// Retorna o Codigo do SB1 de acordo com a despesa do SWD
//
//-------------------------------------------------------
Static Function RetCodB1(cWDDESPESA)
Return(Posicione("SYB",1,xFilial("SYB")+cWDDESPESA,"YB_PRODUTO") )
