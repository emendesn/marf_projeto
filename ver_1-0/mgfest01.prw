#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST01

Autom.venda e transf. do armazem central

@author Gustavo Ananias Afonso - TOTVS Campinas
@since 22/08/2016

Z4_LOCDEST

SZ4 - Cadastro de Armazens x Unidades
SZ5 - Automação de Transferências

/*/
//-------------------------------------------------------------------
user function MGFEST01()
	local aCoors		:= FWGetDialogSize( oMainWnd )

	local oSay1
	local oSay10
	local oSay2
	local oSay3
	local oSay4
	local oSay5
	local oSay6
	local oSay7
	local oSay8
	local oSay9
	local oSay11
	Local oSayTabPrc
	Local oSayVend
	Local oSayEsp
	Local oSayForn
	Local oSayNfEnt
	Local oSayTri
	Local oSayFrete

	local aArea		:= getArea()

	Local nOpcx := 1
	
	Private oGetForn
	Private cGetForn := space(tamSx3("A2_COD")[1])
	Private oGetLjForn
	Private cGetLjForn := space(tamSx3("A2_LOJA")[1])
	Private oDescForn
	Private cDescForn := space(tamSx3("A2_NOME")[1])

	Private oGetNFEnt
	Private cGetNFEnt := space(tamSx3("F1_DOC")[1])
	Private oGetNFSer
	Private cGetNFSer := space(tamSx3("F1_SERIE")[1])

	Private oGetTabPrc
	Private cGetTabPrc := space(tamSx3("DA0_CODTAB")[1])
    Private oDescTabPrc
    Private cDescTabPrc := space(tamSx3("DA0_DESCRI")[1])

	Private oGetVend
	Private cGetVend := space(tamSx3("A4_COD")[1])
    Private oDescVend
    Private cDescVend := space(tamSx3("A4_NOME")[1])
    
	Private oGetEsp
	Private cGetEsp := space(tamSx3("ZJ_COD")[1])
    Private oDescEsp
    Private cDescEsp := space(tamSx3("ZJ_NOME")[1])

	private oDlg

	private oGetCdArma
	private oDescArmaz
	private cGetCdArma := space(tamSx3("NNR_CODIGO")[1])
	private cDescArmaz := space(tamSx3("NNR_DESCRI")[1])

	private oCdArmaDes
	private oDscArmDes

	private cCdArmaDes := space(tamSx3("NNR_CODIGO")[1])
	private cDscArmDes := space(tamSx3("NNR_DESCRI")[1])

	private oCodEmpres
	private cCodEmpresa	:= space(10)

	private oGetEmpres
	private cGetEmpres	:= space(100)

	private oCodUnidad
	private cCodFilial	:= space(10)

	private oGetUnidad
	private cGetUnidad	:= space(100)

	private cComboTipo	:= "" //"Venda"
	private aCombo		:= {"","Venda","Transferência"} //{"Venda", "Transferência", "Remessa", "Retorno"}
	
	private cComboTri	:= "" //"Venda"
	private aComboTri	:= {"","Remessa","Retorno"} //{"Venda", "Transferência", "Remessa", "Retorno"}
	

	private oGetData
	private dGetData := dDataBase

	private oGetHora
	private cGetHora := left(time(), 5)

	private oGetTransp
	private cGetTransp := space(tamSx3("A4_COD")[1])
	private oDescTrans
	private cDescTrans := space(tamSx3("A4_NOME")[1])

	private oGetVeic
	private cGetVeic := space(tamSx3("C5_VEICULO")[1])//space(30)

	private oGetPlaca
	private cGetPlaca := space(30)

	private oGetMotor
	private cGetMotor := space(100)

	private oGetObser
	private cGetObser := ""

	private oBtnGeraNF
	private oBtnSair
	private oBtnSelec

	private aProd			:= {}
	private aProdMark		:= {}
	private cCodArmBKP	:= ""

	PRIVATE aCols      := {}
	PRIVATE aHeader    := {}
	PRIVATE N          := 1

	Private oChk
	Private lChk := .F.
	         
	Private oComboFrete
	Private cComboFrete := ""
	Private aComboFrete := {"","C=CIF","F=FOB","T=Por conta terceiros","S=Sem frete"}

	private cTabPrcRem := allTrim( getMv( "MGF_EST01A" ) )

	DEFINE MSDIALOG oDlg TITLE 'Automação de Transferências' FROM  000, 000  TO 520, 650 PIXEL STYLE DS_MODALFRAME
		@ 001,001 TO 040,325 LABEL 'Empresa/Filial - Origem/Destino' OF oDlg PIXEL

		@ 010, 005 SAY oSay1 PROMPT "Armazém Origem:"	SIZE 045, 007 OF oDlg 			COLORS 0, 16777215 PIXEL
		@ 010, 050 MSGET oGetCdArma VAR cGetCdArma 	SIZE 040, 010 OF oDlg F3 "XSZ4" VALID IIf(nOpcx==1,valArmazem(),.T.)	COLORS 0, 16777215 PIXEL
		@ 010, 090 MSGET oDescArmaz VAR cDescArmaz	SIZE 070, 010 OF oDlg READONLY		COLORS 0, 16777215 PIXEL

		@ 010, 170 SAY oSay1 PROMPT "Armazém Destino:"	SIZE 045, 007 OF oDlg 			COLORS 0, 16777215 PIXEL
		@ 010, 220 MSGET oCdArmaDes VAR cCdArmaDes 		SIZE 030, 010 OF oDlg READONLY	COLORS 0, 16777215 PIXEL
		@ 010, 250 MSGET oDscArmDes VAR cDscArmDes		SIZE 070, 010 OF oDlg READONLY	COLORS 0, 16777215 PIXEL

		@ 025, 005 SAY oSay2 PROMPT "Empresa Destino:" 	SIZE 045, 007 OF oDlg 			COLORS 0, 16777215 PIXEL
		@ 025, 050 MSGET oCodEmpres VAR cCodEmpresa		SIZE 030, 010 OF oDlg READONLY	COLORS 0, 16777215 PIXEL
		@ 025, 090 MSGET oGetEmpres VAR cGetEmpres		SIZE 070, 010 OF oDlg READONLY	COLORS 0, 16777215 PIXEL

		@ 025, 170 SAY oSay3 PROMPT "Unidade Destino:" 	SIZE 045, 007 OF oDlg			COLORS 0, 16777215 PIXEL
		@ 025, 220 MSGET oCodUnidad VAR cCodFilial 		SIZE 030, 010 OF oDlg READONLY	COLORS 0, 16777215 PIXEL
		@ 025, 250 MSGET oGetUnidad VAR cGetUnidad		SIZE 070, 010 OF oDlg READONLY	COLORS 0, 16777215 PIXEL

		@ 045,001 TO 130,325 LABEL 'Dados do Pedido de Venda' OF oDlg PIXEL

		@ 055, 005 SAY oSay11 PROMPT "Tipo Transf.:" 					SIZE 025, 007 OF oDlg	COLORS 0, 16777215 PIXEL
		@ 055, 050 COMBOBOX oCombo VAR cComboTipo ITEMS aCombo When .F. SIZE 055,12 PIXEL OF oDlg

		@ 055, 115 SAY oSay4 PROMPT "Data:"			SIZE 025, 007 OF oDlg			COLORS 0, 16777215 PIXEL
		@ 055, 135 MSGET oGetData VAR dGetData		PICTURE "@D" VALID valDate() SIZE 050, 010 OF oDlg	COLORS 0, 16777215 PIXEL

		@ 055, 200 SAY oSay5 PROMPT "Hora:"			SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 055, 220 MSGET oGetHora VAR cGetHora		PICTURE "99:99" VALID valHour() SIZE 035, 010 OF oDlg COLORS 0, 16777215 PIXEL

		@ 070, 005 SAY oSay6 PROMPT "Transportadora:"	SIZE 040, 007 OF oDlg			COLORS 0, 16777215 PIXEL
		@ 070, 050 MSGET oGetTransp VAR cGetTransp	PICTURE "@!" SIZE 040, 010 OF oDlg F3 "SA4" VALID valTransp() 	COLORS 0, 16777215 PIXEL
		@ 070, 090 MSGET oDescTrans VAR cDescTrans	SIZE 070, 010 OF oDlg READONLY	COLORS 0, 16777215 PIXEL

		@ 070, 170 SAY oSay7 PROMPT "Veículo:"			SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 070, 220 MSGET oGetVeic VAR cGetVeic			PICTURE "@!" F3 "DA3" VALID Vazio().Or.ExistCPO("DA3") SIZE 100, 010 OF oDlg COLORS 0, 16777215 PIXEL

		@ 085, 005 SAY oSay8 PROMPT "Placa:"			SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 085, 050 MSGET oGetPlaca VAR cGetPlaca		PICTURE "@!" SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL

		@ 085, 170 SAY oSay9 PROMPT "Motorista:"		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 085, 220 MSGET oGetMotor VAR cGetMotor		PICTURE "@!" SIZE 100, 010 OF oDlg COLORS 0, 16777215 PIXEL

		@ 100, 005 SAY oSayTabPrc PROMPT "Tabela de Preço:"		SIZE 040, 007 OF oDlg			COLORS 0, 16777215 PIXEL
		@ 100, 050 MSGET oGetTabPrc VAR cGetTabPrc				SIZE 040, 010 OF oDlg F3 "DA0" VALID valTabPrc(cGetTabPrc,@cDescTabPrc,oDescTabPrc) 	COLORS 0, 16777215 PIXEL
		@ 100, 090 MSGET oDescTabPrc VAR cDescTabPrc			PICTURE "@!" SIZE 070, 010 OF oDlg READONLY	COLORS 0, 16777215 PIXEL

		@ 100, 170 SAY oSayEsp PROMPT "Espécie Pedido:"	SIZE 040, 007 OF oDlg			COLORS 0, 16777215 PIXEL
		@ 100, 220 MSGET oGetEsp VAR cGetEsp			SIZE 030, 010 OF oDlg F3 "SZJ2" VALID valEsp(cGetEsp,@cDescEsp,oDescEsp) 	COLORS 0, 16777215 PIXEL
		@ 100, 250 MSGET oDescEsp VAR cDescEsp			PICTURE "@!" SIZE 070, 010 OF oDlg READONLY	COLORS 0, 16777215 PIXEL

		@ 115, 005 SAY oSayVend PROMPT "Vendedor:"		SIZE 040, 007 OF oDlg			COLORS 0, 16777215 PIXEL
		@ 115, 050 MSGET oGetVend VAR cGetVend			SIZE 040, 010 OF oDlg F3 "SA3" VALID valVend(cGetVend,@cDescVend,oDescVend) 	COLORS 0, 16777215 PIXEL
		@ 115, 090 MSGET oDescVend VAR cDescVend		PICTURE "@!" SIZE 070, 010 OF oDlg READONLY	COLORS 0, 16777215 PIXEL

		@ 115, 170 SAY oSayFrete PROMPT "Tipo de Frete:" SIZE 040, 007 OF oDlg			COLORS 0, 16777215 PIXEL
		@ 115, 220 COMBOBOX oComboFrete VAR cComboFrete ITEMS aComboFrete SIZE 060,12 PIXEL OF oDlg 		

		@ 135,001 TO 175,325 LABEL 'Dados para Processo de Triangulação' OF oDlg PIXEL

		@ 145, 005 SAY oSayForn PROMPT "Fornecedor/Loja: "	SIZE 045, 007 OF oDlg			COLORS 0, 16777215 PIXEL
		@ 145, 050 MSGET oGetForn VAR cGetForn			SIZE 030, 010 When .F. OF oDlg /*VALID valForn(cGetForn,"",@cDescForn,oDescForn)*/ 	COLORS 0, 16777215 PIXEL
		@ 145, 080 MSGET oGetLjForn VAR cGetLjForn		SIZE 015, 010 When .F. OF oDlg /*VALID valForn(cGetForn,cGetLjForn,@cDescForn,oDescForn)*/ 	COLORS 0, 16777215 PIXEL		
		@ 145, 095 MSGET oDescForn VAR cDescForn		SIZE 065, 010 When .F. OF oDlg READONLY	COLORS 0, 16777215 PIXEL

		@ 145, 170 CheckBox oChk Var lChk Prompt "Triangulação" Message "Processo de Triangulação" Size 60, 007 Pixel Of oDlg ;
		on Click (IIf(lChk,(cComboTipo:="",oComboTri:Enable()),(oComboTri:Disable(),cComboTri:="",oComboTri:Refresh(),IIf(cCodEmpresa==cEmpAnt,cComboTipo:="Transferência",cComboTipo:="Venda"))),oCombo:Refresh(),cGetNFEnt:=space(tamSx3("F1_DOC")[1]),oGetNFEnt:Refresh(),cGetNFSer:=space(tamSx3("F1_SERIE")[1]),oGetNFSer:Refresh(),cGetForn := space(tamSx3("A2_COD")[1]),oGetForn:Refresh(),cGetLjForn := space(tamSx3("A2_LOJA")[1]),oGetLjForn:Refresh(),cDescForn := space(tamSx3("A2_NOME")[1]),oDescForn:Refresh())

		@ 160, 005 SAY oSayNFEnt PROMPT "NF Entrada Serie/Num.: "	SIZE 070, 007 OF oDlg			COLORS 0, 16777215 PIXEL
		@ 160, 065 MSGET oGetNFSer VAR cGetNFSer		SIZE 020, 010 When .F. OF oDlg COLORS 0, 16777215 PIXEL
		@ 160, 090 MSGET oGetNFEnt VAR cGetNFEnt		SIZE 030, 010 When .F. OF oDlg COLORS 0, 16777215 PIXEL 

		@ 160, 170 SAY oSayTri PROMPT "Tipo Triangulação:" 					SIZE 050, 007 OF oDlg	COLORS 0, 16777215 PIXEL
		@ 160, 220 COMBOBOX oComboTri VAR cComboTri ITEMS aComboTri When lChk On Change (cGetNFEnt:=space(tamSx3("F1_DOC")[1]),oGetNFEnt:Refresh(),cGetNFSer:=space(tamSx3("F1_SERIE")[1]),oGetNFSer:Refresh(),cGetForn := space(tamSx3("A2_COD")[1]),oGetForn:Refresh(),cGetLjForn := space(tamSx3("A2_LOJA")[1]),oGetLjForn:Refresh(),cDescForn := space(tamSx3("A2_NOME")[1]),oDescForn:Refresh(), cGetTabPrc := cTabPrcRem, oGetTabPrc:Refresh(), valTabPrc(cGetTabPrc,@cDescTabPrc,oDescTabPrc)) SIZE 055,12 PIXEL OF oDlg 		
		//@ 160, 220 COMBOBOX oComboTri VAR cComboTri ITEMS aComboTri On Change IIf(lChk,Nil,(cComboTri:="",oComboTri:Refresh())) SIZE 055,12 PIXEL OF oDlg 				
		
		@ 180, 005 SAY oSay10 PROMPT "Observações:"	SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 180, 050 GET oGetObser VAR cGetObser OF oDlg MULTILINE SIZE 175, 044 COLORS 0, 16777215 HSCROLL PIXEL

		@ 230, 005 BUTTON oBtnSelec		PROMPT "Seleciona Itens"		SIZE 050, 012 OF oDlg PIXEL ACTION (nOpcx := 1,loadArProd())
		@ 230, 072 BUTTON oBtnGeraNF	PROMPT "Gera Pedido de Venda"	SIZE 060, 012 OF oDlg PIXEL ACTION (nOpcx := 1,fwMsgRun(, {|oSay| genSalesOr( oSay, )}, "Processando", "Aguarde. Processando Pedido..." ))
//		@ 230, 126 BUTTON oBtnGeraNF	PROMPT "Agendar"				SIZE 037, 012 OF oDlg PIXEL ACTION (nOpcx := 1,fwMsgRun(, {|oSay| genSalesOr( oSay,.T. )}, "Processando", "Aguarde. Processando Pedido..." ))
		@ 230, 150 BUTTON oBtnGeraNF	PROMPT "Nf Entrada Rem./Ret" 	SIZE 055, 012 OF oDlg PIXEL ACTION (nOpcx := 1,fwMsgRun(, {|oSay| _A410Devol( oSay )}, "Processando", "Aguarde. Associando NF Entrada..." ))
		@ 230, 230 BUTTON oBtnSair		PROMPT "Sair"					SIZE 037, 012 OF oDlg PIXEL ACTION (nOpcx := 0,oDlg:end())

	ACTIVATE MSDIALOG oDlg CENTER

	restArea(aArea)
return

//------------------------------------------------------
// Valida Data
//------------------------------------------------------
static function valDate()
	local lRetDate := .T.

	if dGetData < dDataBase
		msgAlert("Data digitada é inválida")
		lRetDate := .F.
		return lRetDate
	endif

	if empty(dGetData)
		msgAlert("Data digitada é inválida")
		lRetDate := .F.
		return lRetDate
	endif

return lRetDate

//------------------------------------------------------
// Valida Hora
//------------------------------------------------------
static function valHour()
	local lRetHour := .T.

	if !(left(cGetHora, 2) >= '00' .and. left(cGetHora,2) <= '24' .and. right(cGetHora,2) >= '00' .and. right(cGetHora,2) <= '59')
		lRetHour := .F.
		msgAlert("Hora digitada é inválida")
	endif

return lRetHour

//------------------------------------------------------
// Valida Armazem
//------------------------------------------------------
static function valArmazem()
	local cQryNNR := ""
	local lRet		:= .T.
	local aArea		:= getArea()
	local aAreaSM0	:= SM0->(getArea())

	cQryNNR := "SELECT NNR_CODIGO, NNR_DESCRI, Z4_EMPRESA, Z4_UNIDADE"	+ CRLF
	cQryNNR += " FROM "			+ retSQLName("NNR") + " NNR"	+ CRLF
	cQryNNR += " INNER JOIN "	+ retSQLName("SZ4") + " SZ4"	+ CRLF
	cQryNNR += " ON" + CRLF
	cQryNNR += " 	NNR.NNR_CODIGO = SZ4.Z4_LOCAL" + CRLF
	cQryNNR += " WHERE" + CRLF
	cQryNNR += " 		NNR.NNR_CODIGO	=	'" + cGetCdArma		+ "'" + CRLF
	cQryNNR += " 	AND	SZ4.Z4_EMPRESA	=	'" + cCodEmpresa		+ "'" + CRLF
	cQryNNR += " 	AND	SZ4.Z4_UNIDADE	=	'" + cCodFilial		+ "'" + CRLF
	cQryNNR += " 	AND	SZ4.Z4_FILIAL		=	'" + xFilial("SZ4")	+ "'" + CRLF
	cQryNNR += " 	AND	NNR.NNR_FILIAL	=	'" + xFilial("NNR")	+ "'" + CRLF
	cQryNNR += " 	AND	SZ4.D_E_L_E_T_	<>	'*'" + CRLF
	cQryNNR += " 	AND	NNR.D_E_L_E_T_	<>	'*'" + CRLF

	TcQuery ChangeQuery(cQryNNR) New Alias "QRYNNR"

	if !QRYNNR->(EOF())
		cDescArmaz := QRYNNR->NNR_DESCRI
		cDscArmDes := getAdvFVal("NNR", "NNR_DESCRI", xFilial("NNR") + cCdArmaDes, 1, "") //getAdvFVal("NNR", "NNR_DESCRI", cCodFilial + cCdArmaDes, 1, "")

		DBSelectArea("SM0")
		SM0->(DBGoTop())
		if SM0->(DBSeek( QRYNNR->(Z4_EMPRESA + Z4_UNIDADE) ))
			cGetEmpres	:= SM0->M0_NOME
			cGetUnidad	:= SM0->M0_FILIAL
			cCodEmpresa	:= SM0->M0_CODIGO
			cCodFilial	:= SM0->M0_CODFIL
		endif

		oCdArmaDes:refresh()
		oDescArmaz:refresh()
		oGetEmpres:refresh()
		oGetUnidad:refresh()
		If lChk
			cComboTipo == ""
		Else	
			If cCodEmpresa == cEmpAnt
				cComboTipo	:= "Transferência"
				oCombo:Refresh()
			Else
				cComboTipo	:= "Venda"
				oCombo:Refresh()
			Endif			
		Endif	
	else
		msgAlert("Código do Armazém informado não existe no cadastro.")
		lRet := .F.
	endif

	QRYNNR->(DBCloseArea())

	//cComboTipo	:= "Venda"
	//oCombo:refresh()

	restArea(aAreaSM0)
	restArea(aArea)
return lRet

//------------------------------------------------------
// Valida Transportadora
//------------------------------------------------------
static function valTransp()
	local cQrySA4 := ""
	local lRet		:= .T.

	cQrySA4 := "SELECT A4_COD, A4_NOME"									+ CRLF
	cQrySA4 += " FROM " + retSQLName("SA4") + " SA4"						+ CRLF
	cQrySA4 += " WHERE"														+ CRLF
	cQrySA4 += " 		SA4.A4_COD			=	'" + cGetTransp		+ "'"	+ CRLF
	cQrySA4 += " 	AND	SA4.A4_FILIAL		=	'" + xFilial("SA4")	+ "'"	+ CRLF
	cQrySA4 += " 	AND	SA4.D_E_L_E_T_	<>	'*'"							+ CRLF

	TcQuery ChangeQuery(cQrySA4) New Alias "QRYSA4"

	if !QRYSA4->(EOF())
		cDescTrans := QRYSA4->A4_NOME
		oDescTrans:refresh()
	else
		msgAlert("Código de Transportadora informado não existe no cadastro.")
		lRet := .F.
	endif

	QRYSA4->(DBCloseArea())
return lRet

//------------------------------------------------------
// Tratamento para 'salvar' os registros marcados pelo usuario
//------------------------------------------------------
static function loadArProd()
	local nI			:= 0
	local nJ			:= 0
	local aProdBKP	:= {}
	local nTamSD1		:= (tamSx3("D1_FILIAL")[1] + tamSx3("D1_DOC")[1] + tamSx3("D1_SERIE")[1] + tamSx3("D1_FORNECE")[1] + tamSx3("D1_LOJA")[1] + tamSx3("D1_ITEM")[1])
	Local dValid := cTod("")

	If lChk //!(cComboTipo == "Venda" .or. cComboTipo == "Transferência")
		MsgAlert("Para usar esta opção a caixa de seleção 'Triangulação' deve estar desmarcada. Verifique.")
		Return()
	Endif	
			
	aProdBKP	:= aClone(aProd)
	aProd		:= {}

	//fwMsgRun(, {|oSay| aProd := getProd( oSay )}, "Verificando produtos", "Aguarde. Selecionando produtos em estoque..." )
	fwMsgRun(, {|oSay| getProd( oSay )}, "Verificando produtos", "Aguarde. Selecionando produtos em estoque..." )	
    
	while !QRYSB2->(EOF())
		dValid := cTod("")
		If !Empty(QRYSB2->LOTE) .and. Empty(QRYSB2->VALIDADE)
			dValid := Posicione("SB8",3,xFilial("SB8")+QRYSB2->PRODUTO+QRYSB2->LOCAL+QRYSB2->LOTE,"B8_DTVALID")
		Endif	
		aadd(aProd, {.F., QRYSB2->ENDERECO, QRYSB2->PRODUTO, QRYSB2->DESCRI, QRYSB2->UM, QRYSB2->TIPO, QRYSB2->GRUPO, QRYSB2->LOTE, IIf(!Empty(dValid),dValid,sToD(QRYSB2->VALIDADE)), QRYSB2->SALDO, QRYSB2->SALDO, space(nTamSD1)})
		QRYSB2->(DBSkip())
	enddo

	QRYSB2->(DBCloseArea())

	// refaz marcação do usuario
	if cGetCdArma == cCodArmBKP
		for nI := 1 to len(aProdMark)
			for nJ := 1 to len(aProd)
				if aProdMark[nI, 3] == aProd[nJ, 3]
					aProd[nJ, 1]	:= .T.
					//aProd[nJ, 11]	:= aProdMark[nI, 11]
					aProd[nJ, 11]	:= aProdMark[nI, 11]
					exit
				endif
			next
		next
	endif

	aProdMark	:= {}
	cCodArmBKP	:= cGetCdArma

	if !empty(aProd)
		markProd()
	else
		msgAlert("Não foram encontrados produtos disponíveis neste armazém.")
	endif
	
	// zera dados relacionados a operacao de remessa e retorno
	cGetForn := space(tamSx3("A2_COD")[1])
	oGetForn:Refresh()
	
	cGetLjForn := space(tamSx3("A2_LOJA")[1])
	oGetLjForn:Refresh()

	cDescForn:= space(tamSx3("A2_NOME")[1])
	oDescForn:Refresh()
	
	cGetNFEnt := space(tamSx3("F1_DOC")[1])
	oGetNFEnt:Refresh()
	
	cGetNFSer := space(tamSx3("F1_SERIE")[1])
	oGetNFSer:Refresh()
	
	aHeader := {}
	aCols := {}
	
return

//------------------------------------------------------
// Marca os produtos para venda ou transferencia 
//------------------------------------------------------
static function markProd()
	local aSeek		:= {}
	local oDlgProd	:= nil
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	local bMark		:= { || iif(aProd[oMark:nAt][1], 'LBOK', 'LBNO')			}
	local bDblClick	:= { || clickMark(oMark, aProd)								}
	local bMarkAll	:= { || markAll(oMark, aProd)								}
	local bOk			:= { || retMark(oMark, aProd, aProdMark), iif( chkNFOrig(), oDlgProd:end(), ) 	}
	local bClose		:= { || iif( chkNFOrig(), oDlgProd:end(), ) }
	local nTamSD1		:= (tamSx3("D1_FILIAL")[1] + tamSx3("D1_DOC")[1] + tamSx3("D1_SERIE")[1] + tamSx3("D1_FORNECE")[1] + tamSx3("D1_LOJA")[1] + tamSx3("D1_COD")[1] + tamSx3("D1_ITEM")[1])

	private nQtdeSolic	:= 0
	private cNFOri		:= space(nTamSD1)

	//Pesquisa que sera exibido
	aadd(aSeek,{"Código"		, { {"","C",tamSx3("B1_COD")[1],0,"Codigo"		,,} }})
	aadd(aSeek,{"Descrição"	, { {"","C",tamSx3("B1_DESC")[1],0,"Descricao"	,,} }})

	//-------------------------------------------------------------
	// Tela de seleção da Oportunidade
	//-------------------------------------------------------------

	DEFINE MSDIALOG oDlgProd TITLE 'Automação de Transferências / Vendas do CD' FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL STYLE DS_MODALFRAME
		oMark := fwBrowse():New()
		oMark:setDataArray()
		oMark:setArray(aProd)
		oMark:disableConfig()
		oMark:disableReport()
		oMark:setOwner(oDlgProd)
		oMark:setSeek(, aSeek)

/*
		SetSeek
		Habilita a utilização da pesquisa de registros no Browse
		
		@param   bAction Code-Block executado para a pesquisa de registros, caso não seja informado será utilizado o padrão
		@param   aOrder  Estrutura do array
						[n,1] Título da pesquisa
						[n,2,n,1] LookUp
						[n,2,n,2] Tipo de dados
						[n,2,n,3] Tamanho
						[n,2,n,4] Decimal
						[n,2,n,5] Título do campo
						[n,2,n,6] Máscara
						[n,2,n,7] Nome Fisico do campo - Opcional - é ajustado no programa
						[n,3] Ordem da pesquisa
						[n,4] Exibe na pesquisa 
*/

		oMark:addMarkColumns(bMark, bDblClick, bMarkAll) 

		oMark:addColumn({"Endereço"			, {||aProd[oMark:nAt,2]}		, "C", pesqPict("SB2","B2_LOCALIZ")	, 1, tamSx3("B2_LOCALIZ")[1]	,, .F.})
		oMark:addColumn({"Código"			, {||aProd[oMark:nAt,3]}		, "C", pesqPict("SB1","B1_COD")		, 1, (tamSx3("B1_COD")[1]*2)	,, .F.})
		oMark:addColumn({"Descrição"		, {||aProd[oMark:nAt,4]}		, "C", pesqPict("SB1","B1_DESC")	, 1, tamSx3("B1_DESC")[1]		,, .F.})
		oMark:addColumn({"Un"				, {||aProd[oMark:nAt,5]}		, "C", pesqPict("SB1","B1_UM")		, 1, tamSx3("B1_UM")[1]			,, .F.})
		oMark:addColumn({"Tipo"				, {||aProd[oMark:nAt,6]}		, "C", pesqPict("SB1","B1_TIPO")	, 1, tamSx3("B1_TIPO")[1]		,, .F.})
		oMark:addColumn({"Grupo"			, {||aProd[oMark:nAt,7]}		, "C", pesqPict("SB1","B1_GRUPO")	, 1, tamSx3("B1_GRUPO")[1]		,, .F.})
		oMark:addColumn({"Lote"				, {||aProd[oMark:nAt,8]}		, "C", pesqPict("SB8","B8_LOTECTL")	, 1, tamSx3("B8_LOTECTL")[1]	,, .F.})
		oMark:addColumn({"Validade"			, {||aProd[oMark:nAt,9]}		, "C", pesqPict("SB8","B8_DTVALID")	, 1, tamSx3("B8_DTVALID")[1]	,, .F.})
		oMark:addColumn({"Qtde Disponível"	, {||aProd[oMark:nAt,10]} 		, "N", pesqPict("SB2","B2_QATU")	, 2, tamSx3("B2_QATU")[1]		,, .F.})
		oMark:addColumn({"Qtde Solicitada"	, {||aProd[oMark:nAt,11]} 		, "N", pesqPict("SB2","B2_QATU")	, 2	, tamSx3("B2_QATU")[1]		,2,	 .T.,, .F.,, "nQtdeSolic",, .F., .T.,})
		
		oMark:setEditCell(.T., {|| u_valFields() })
		/*
		Sintaxe
		FWBrowse(): SetEditCell ( [ lEditCell], [ bValidEdit] ) -->

		Parâmetros
		Nome		Tipo	Descrição	Obrigatório	Referência
		lEditCell	Lógico	Indica se permite a edição de células.	 	 
		bValidEdit	Bloco de código	Code-Block executado para validar a edição da célula.
		*/
		//oMark:addColumn({"NF Origem"		, {||aProd[oMark:nAt,11]}	, "C", "@!"							, 1	, nTamSD1						,,	 .T.,, .F.,, "cNFOri"		,, .F., .T.,})

		//oMark:setEditCell(.T., {|| u_valFields() })

		//oMark:aColumns[11]:XF3 := 'XSD1'

/* add(Column
[n][01] Título da coluna
[n][02] Code-Block de carga dos dados
[n][03] Tipo de dados
[n][04] Máscara
[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
[n][06] Tamanho
[n][07] Decimal
[n][08] Indica se permite a edição
[n][09] Code-Block de validação da coluna após a edição
[n][10] Indica se exibe imagem
[n][11] Code-Block de execução do duplo clique
[n][12] Variável a ser utilizada na edição (ReadVar)
[n][13] Code-Block de execução do clique no header
[n][14] Indica se a coluna está deletada
[n][15] Indica se a coluna será exibida nos detalhes do Browse
[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
[n][17] Id da coluna
[n][18] Indica se a coluna é virtual
*/

		oMark:activate(.T.)

		enchoiceBar(oDlgProd, bOk , bClose)
	ACTIVATE MSDIALOG oDlgProd CENTER
return

//------------------------------------------------------
// Verifica se foi informado a NF de origem para o Tipo RETORNO
//------------------------------------------------------
static function chkNFOrig()
	local nI			:= 0
	local lChkNFOrig	:= .T.

	if cComboTipo == "Retorno"
		for nI := 1 to len(aProdMark)
			if empty(aProdMark[nI, 12])
				lChkNFOrig := .F.
			endif
		next

		if !lChkNFOrig
			msgAlert("É necessário informar a NF de Origem para o Tipo de Retorno")
		endif
	endif

return lChkNFOrig

//------------------------------------------------------
// Direciona para a validação do campo correspodente
//------------------------------------------------------
user function valFields()
	local lRetVal	:= .T.
	Local nLinha	:= oMark:At()

	if oMark:colPos() == 11 // Quantidade Solicitada
		If nQtdeSolic <= aProd[nLinha,10] .And. nQtdeSolic > 0 // Qtde Solicitada <= Saldo
			aProd[nLinha,11] := nQtdeSolic
		Else
			lRetVal := .F.
		EndIf
	ElseIf oMark:colPos() == 12 // NF orig
		MsgStop("valFields")
		lRetVal := valNFOri()
	endif

return lRetVal

//------------------------------------------------------
// Valida NF de origem 
//------------------------------------------------------
static function valNFOri()
	local lNFOrig := .T.

	//aProd[oMark:nAt,11] := cNFOri
	aProd[oMark:nAt,12] := cNFOri
	oMark:refresh(.F.)

return lNFOrig

//------------------------------------------------------
// Seleciona produtos em estoque 
//------------------------------------------------------
static function getProd(oSay)

	local lConsPrev	:= if( SuperGetMV( 'MV_QTDPREV', .F., 'N' ) == 'S', .T., .F. )
	local cQrySB2		:= ""

	oSay:cCaption := ("Selecionando produtos do armazém " + cGetCdArma)

	cQrySB2 := "SELECT * "	+ CRLF
	cQrySB2 += "FROM "	+ CRLF
	cQrySB2 += "( "	+ CRLF
	cQrySB2 += "SELECT BF_LOCALIZ ENDERECO, BF_PRODUTO PRODUTO, B1_DESC DESCRI, B1_TIPO TIPO, B1_UM UM, B1_GRUPO GRUPO, (BF_QUANT-BF_EMPENHO) SALDO, "	+ CRLF
	cQrySB2 += "	BF_LOTECTL LOTE, ' ' VALIDADE, BF_LOCAL LOCAL "	+ CRLF
	cQrySB2 += "FROM " + RetSQLName("SBF") + " SBF"						+ CRLF
	cQrySB2 += "INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' "	+ CRLF
	cQrySB2 += "	AND B1_FILIAL = '"+xFilial("SB1")+"' "	+ CRLF
	cQrySB2 += "	AND B1_COD = BF_PRODUTO "	+ CRLF
	cQrySB2 += "	AND B1_LOCALIZ = 'S' "	+ CRLF
//	cQrySB2 += "INNER JOIN " + RetSQLName("SB8") + " SB8 ON SB8.D_E_L_E_T_ = '' "	+ CRLF
//	cQrySB2 += "	AND B8_FILIAL = '"+xFilial("SB8")+"' "	+ CRLF
//	cQrySB2 += "	AND B8_PRODUTO = BF_PRODUTO "	+ CRLF
//	cQrySB2 += "	AND B8_LOCAL = BF_LOCAL "	+ CRLF
//	cQrySB2 += "	AND B8_LOTECTL = BF_LOTECTL "	+ CRLF
	cQrySB2 += "WHERE SBF.D_E_L_E_T_ = '' "	+ CRLF
	cQrySB2 += " 	AND	BF_FILIAL =	'" + xFilial("SBF")	+ "' "	+ CRLF
	cQrySB2 += "	AND BF_LOCAL = '" + cGetCdArma	+ "' "	+ CRLF
	cQrySB2 += "	AND (BF_QUANT-BF_EMPENHO) > 0 "	+ CRLF
	cQrySB2 += "UNION "	+ CRLF
	cQrySB2 += "SELECT '' ENDERECO, B8_PRODUTO PRODUTO, B1_DESC DESCRI, B1_TIPO TIPO, B1_UM UM, B1_GRUPO GRUPO, (B8_SALDO-B8_EMPENHO) SALDO, "	+ CRLF
	cQrySB2 += "	B8_LOTECTL LOTE, B8_DTVALID VALIDADE, B8_LOCAL LOCAL "	+ CRLF
	cQrySB2 += "FROM " + RetSQLName("SB8") + " SB8"	+ CRLF
	cQrySB2 += "INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' "	+ CRLF
	cQrySB2 += "	AND B1_FILIAL = '"+xFilial("SB1")+"' "	+ CRLF
	cQrySB2 += "	AND B1_COD = B8_PRODUTO "	+ CRLF
	cQrySB2 += "	AND B1_LOCALIZ <> 'S' "	+ CRLF
	cQrySB2 += "	AND B1_RASTRO IN ('L','S') "	+ CRLF
	cQrySB2 += "WHERE SB8.D_E_L_E_T_ = '' "	+ CRLF
	cQrySB2 += " 	AND	B8_FILIAL =	'" + xFilial("SB8")	+ "' "	+ CRLF
	cQrySB2 += "	AND B8_LOCAL = '" + cGetCdArma	+ "' "	+ CRLF
	cQrySB2 += "	AND (B8_SALDO-B8_EMPENHO) > 0 "	+ CRLF
	cQrySB2 += "UNION "	+ CRLF
	cQrySB2 += "SELECT '' ENDERECO, B2_COD PRODUTO, B1_DESC DESCRI, B1_TIPO TIPO, B1_UM UM, B1_GRUPO GRUPO, "	+ CRLF
	cQrySB2 += "	 (B2_QATU-B2_RESERVA-B2_QEMP-B2_QACLASS-B2_QEMPSA"+If( lConsPrev, "-B2_QEMPPRE", "")+") SALDO, "	+ CRLF
	cQrySB2 += "	 '' LOTE, '' VALIDADE, B2_LOCAL LOCAL "	+ CRLF
	cQrySB2 += "FROM " + RetSQLName("SB2") + " SB2"	+ CRLF
	cQrySB2 += "INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' "	+ CRLF
	cQrySB2 += "	AND B1_FILIAL = '"+xFilial("SB1")+"' "	+ CRLF
	cQrySB2 += "	AND B1_COD = B2_COD "	+ CRLF
	cQrySB2 += "	AND B1_LOCALIZ <> 'S' "	+ CRLF
	cQrySB2 += "	AND B1_RASTRO NOT IN ('L','S') "	+ CRLF
	cQrySB2 += "WHERE SB2.D_E_L_E_T_ = '' "	+ CRLF
	cQrySB2 += " 	AND	B2_FILIAL =	'" + xFilial("SB2")	+ "' "	+ CRLF
	cQrySB2 += "	AND B2_LOCAL = '" + cGetCdArma	+ "' "	+ CRLF
	cQrySB2 += "	AND (B2_QATU-B2_RESERVA-B2_QEMP-B2_QACLASS-B2_QEMPSA"+If( lConsPrev, "-B2_QEMPPRE", "")+") > 0 "	+ CRLF
	cQrySB2 += ") ZZZ "	+ CRLF
	cQrySB2 += "ORDER BY PRODUTO, ENDERECO, VALIDADE, LOTE "	+ CRLF

	//memoWrite("\" + funName() + ".sql", cQrySB2)

	TcQuery ChangeQuery(cQrySB2) New Alias "QRYSB2"
	
	Return()

/*
Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local aMat := {}
Local nSaldo := 0
Local aSaldo := {}
Local nCnt := 0
local nTamSD1		:= (tamSx3("D1_FILIAL")[1] + tamSx3("D1_DOC")[1] + tamSx3("D1_SERIE")[1] + tamSx3("D1_FORNECE")[1] + tamSx3("D1_LOJA")[1] + tamSx3("D1_ITEM")[1])

cQ := "SELECT SB2.R_E_C_N_O_ SB2_RECNO,B2_COD,B2_LOCAL,B1_RASTRO,B1_LOCALIZ,B1_DESC,B1_TIPO,B1_UM,B1_GRUPO "
cQ += "FROM "+RetSqlName("SB2")+" SB2 "
cQ += "INNER JOIN "+RetSqlName("SB1")+" SB1 "
cQ += "ON SB1.D_E_L_E_T_ = ' ' "
cQ += "AND B1_COD = B2_COD "
cQ += "WHERE SB2.D_E_L_E_T_ = ' ' "
cQ += "AND B2_FILIAL = '"+xFilial("SB2")+"' "
cQ += "AND B2_QATU > 0 "
cQ += "AND B2_LOCAL = '"+cGetCdArma+"' "

TcQuery ChangeQuery(cQ) New Alias "QRYSB2"

while !QRYSB2->(EOF())
	If "LS" $ QRYSB2->B1_RASTRO .or. QRYSB2->B1_LOCALIZ == "S"
		aSaldo := SldPorLote(QRYSB2->B2_COD,QRYSB2->B2_LOCAL,9999999999,0)
		For nCnt:=1 To Len(aSaldo)
			If aSaldo[nCnt][5] > 0
				aadd(aMat,{.F.,aSaldo[nCnt][3],QRYSB2->B2_COD,QRYSB2->B1_DESC,QRYSB2->B1_UM,QRYSB2->B1_TIPO,QRYSB2->B1_GRUPO,aSaldo[nCnt][1],aSaldo[nCnt][7],aSaldo[nCnt][5],aSaldo[nCnt][5],space(nTamSD1)})
			Endif
		Next			
	Else
		SB2->(dbGoto(QRYSB2->SB2_RECNO))
		If SB2->(Recno()) == QRYSB2->SB2_RECNO
			nSaldo := SaldoSB2()
			If !Empty(nSaldo)
				aadd(aMat,{.F.,"",QRYSB2->B2_COD,QRYSB2->B1_DESC,QRYSB2->B1_UM,QRYSB2->B1_TIPO,QRYSB2->B1_GRUPO,"",cTod(""),nSaldo,nSaldo,space(nTamSD1)})
			Endif
		Endif		
	Endif	
	QRYSB2->(DBSkip())
enddo

QRYSB2->(DBCloseArea())

//PRODUTO, ENDERECO, VALIDADE, LOTE
aSort(aMat,,,{|x,y| x[3]+x[2]+dTos(x[9])+x[8] < y[3]+y[2]+dTos(y[9])+y[8]})

return(aMat)
*/


//-------------------------------------------------------------
// Função de duplo clique na coluna
//-------------------------------------------------------------
static function clickMark(oBrowse, aDados)
	local lRet := !aDados[oBrowse:At(),1]

	aDados[oBrowse:At(),1] := lRet

return lRet

//-------------------------------------------------------------
// Função de duplo clique no cabeçalho
//-------------------------------------------------------------
static function markAll(oBrowse, aDados)
	local nI := 0

	for nI := 1 to len(aDados)
		if !aDados[nI, 1]
			aDados[nI, 1] := .T.
		endif
	next

	oBrowse:refresh(.F.)
return

//-------------------------------------------------------------
// Retorna em array os itens marcados
//-------------------------------------------------------------
static function retMark(oBrowse, aDados, aMark)
	local nI	:= 0

	aMark	:= {}

	for nI := 1 to len(aDados)
		if aDados[nI, 1]
			aadd(aMark, aDados[nI])
		endif
	next
return

//-------------------------------------------------------------
// Gera o Pedido de Venda
//-------------------------------------------------------------
static function genSalesOr(oSay,lSchedule)
    Local cError     := ''
	local nI					:= 0
	local aLine 				:= {}
	local cC5Num				:= ""
	local cItemPV				:= strZero( 0 , tamSX3("C6_ITEM")[1] )
	
	local aAreaSC5 			:= SC5->(getArea())
    Local cTipoTran 		:= ""
    Local nCnt := 0
    Local cTes := ""
    Local cOper := ""
    Local cCliFor := ""
	Local cLjCliFor := ""
	Local cTpCliFor := ""
	Local lContinua := .T.
	Local cProd := ""
	Local aTes := {}
	local aPeso	:= {}

	private aSC5			:= {}
	private aSC6			:= {}
	private cSZ5Num			:= ""
	//private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	//private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	private cMsgProc			:= ""

	default lSchedule := .F.

	DBSelectArea("SC5")

	if lChk .AND. cComboTri == "Remessa"
		if chkSDA()
			msgStop("Produtos desta Nota de Entrada não estão endereçados! Não será permitido a geração do Pedido", "ATENÇÃO")
			return
		endif
	endif

	If !lChk
		If Empty(cComboTipo) .or. cComboTipo == "Venda" .or. cComboTipo == "Transferência"
			if empty(aProdMark)
				msgAlert("Nenhum produto foi selecionado!")
				return
			endif
		Endif
	Else
		If cComboTri == "Retorno"
			if empty(aProdMark)
				msgAlert("Nenhum produto foi selecionado!")
				return
			endif
		ElseIf Empty(cComboTri) .or. Empty(cGetForn) .or. Empty(cGetNFEnt) .or. Empty(aHeader) .or. Empty(aCols)
			msgAlert("Tipo de Triangulação não definida pelo usuário ou nenhum Fornecedor e Documento de entrada foi selecionado!")
			return
		endif
	Endif	
	
	If Empty(cGetTabPrc) .or. Empty(cGetVend) .or. Empty(cGetEsp) .or. Empty(cComboFrete)
		msgAlert("Verifique o preenchimento dos campos: 'Tabela de Preço','Vendedor','Espécie do Pedido','Tipo de Frete'.")
		return
	endif

	if !isBlind()
		oSay:cCaption := ("Inserindo Pedido de Venda...")
	endif

	//BEGIN TRANSACTION
		cC5Num := GETSX8NUM("SC5","C5_NUM")

		getInfoSZ4()

		if !QRYSZ4->(EOF())
			cSZ5Num := GETSX8NUM("SZ5","Z5_NUM")
			CONFIRMSX8()
            
			If !lChk
				if cComboTipo == "Venda"
					//cTes := QRYSZ4->Z4_TESVEN
					cOper := QRYSZ4->Z4_OPEVEN
					cTipoTran := "1"
				elseif cComboTipo == "Transferência"
					//cTes := QRYSZ4->Z4_TESTRAN
					cOper := QRYSZ4->Z4_OPETRAN
					cTipoTran := "2"
				endif
			Else		
				If cComboTri == "Remessa"
					//cTes := QRYSZ4->Z4_TESREM
					cOper := QRYSZ4->Z4_OPEREM
					cTipoTran := "3"
				elseif cComboTri == "Retorno"
					//cTes := QRYSZ4->Z4_TESRET
					cOper := QRYSZ4->Z4_OPERET
					cTipoTran := "4"
				endif
			Endif	

			If cTipoTran $ "1/2"
				cCliFor		:= QRYSZ4->Z4_CODCLI
				cLjCliFor	:= QRYSZ4->Z4_LOJACLI
				cTpCliFor	:= "C"
			Else
				cCliFor		:= QRYSZ4->Z4_FORRET
				cLjCliFor	:= QRYSZ4->Z4_LJFORRE
				cTpCliFor	:= "F"
			Endif

			//insertSZ5(cSZ5Num,cTipoTran,cTes)

			aSC5 := {}
			aadd(aSC5, {'C5_FILIAL' 	, xFilial("SC5")   		, NIL})
			aadd(aSC5, {'C5_NUM'    	, cC5Num	        	, NIL})
			aadd(aSC5, {'C5_ZTIPPED'	, cGetEsp				, NIL})

			if cTipoTran $ "1/2/4"
				aadd(aSC5, {'C5_TIPO'   	, "N"              		, NIL})
				aadd(aSC5, {'C5_CLIENTE'	, QRYSZ4->Z4_CODCLI		, NIL})
				aadd(aSC5, {'C5_LOJACLI'	, QRYSZ4->Z4_LOJACLI	, NIL})
			elseif cTipoTran $ "3"
				aadd(aSC5, {'C5_TIPO'   	, "B"              		, NIL})
				aadd(aSC5, {'C5_CLIENTE'	, QRYSZ4->Z4_FORRET		, NIL})
				aadd(aSC5, {'C5_LOJACLI'	, QRYSZ4->Z4_LJFORRE	, NIL})
			endif

			aadd(aSC5, {'C5_TABELA'		, cGetTabPrc			, NIL})
			aadd(aSC5, {'C5_CONDPAG'	, QRYSZ4->Z4_CONDPAG	, NIL})
			aadd(aSC5, {'C5_TRANSP'		, cGetTransp			, NIL})
			aadd(aSC5, {'C5_VEND1'		, cGetVend				, NIL})
			aadd(aSC5, {'C5_ZTPTRAN'	, cTipoTran				, NIL})
			aadd(aSC5, {'C5_TPFRETE'	, cComboFrete			, NIL})
			
			If !Empty(cGetVeic)
				aadd(aSC5, {'C5_VEICULO'	, cGetVeic			, NIL})
			EndIf
			
			aPeso := {}
			aPeso := getPeso()

			aadd(aSC5, {'C5_PBRUTO'		, aPeso[1]			, NIL})
			aadd(aSC5, {'C5_PESOL'		, aPeso[2]			, NIL})
			aadd(aSC5, {'C5_ZTPOPER'	, cOper				, NIL})

			aSC6 := {}

			If cTipoTran $ "1/2/4/"
				for nCnt := 1 to len(aProdMark)
					aLine := {}
					cItemPV := soma1(cItemPV)
					cTes := MaTesInt(2,cOper,cCliFor,cLjCliFor,cTpCliFor,aProdMark[nCnt, 3],"C6_TES")  
					If Empty(cTes)
						lContinua := .F.
						cProd := aProdMark[nCnt, 3]
						Exit
					Else
						If (nPos:=aScan(aTes,{|x| x[2]==cTes})) == 0
							aAdd(aTes,{cItemPV,cTes,1,nCnt})		
						Else
							aTes[nPos][3]++	
							aTes[nPos][4] := nCnt
						Endif	
					Endif	

					aadd(aLine, {'C6_ITEM'		, cItemPV								, NIL})
					aadd(aLine, {'C6_PRODUTO'	, aProdMark[nCnt, 3]						, NIL})
					aadd(aLine, {'C6_QTDVEN'	, aProdMark[nCnt, 11]						, NIL})
					aadd(aLine, {'C6_QTDLIB'	, aProdMark[nCnt, 11]						, NIL}) 

					if cTipoTran == "4"
						aadd(aLine, {'C6_PRCVEN'	, NOROUND( aProdMark[nCnt, 15], 6 )	, NIL})
					else
						aadd(aLine, {'C6_PRCVEN'	, getB1Prc(aProdMark[nCnt, 3],cGetTabPrc)	, NIL})
					endif

					aadd(aLine, {'C6_TES'		, cTes									, NIL})
					aadd(aLine, {'C6_LOCAL'		, QRYSZ4->Z4_LOCAL						, NIL})
					If !Empty( aProdMark[nCnt, 8] )
						aadd(aLine, {'C6_LOTECTL'	, aProdMark[nCnt, 8]						, NIL})
						aadd(aLine, {'C6_DTVALID'	, aProdMark[nCnt, 9]						, NIL})
					EndIf
					If cTipoTran == "4"
						aadd(aLine, {'C6_NFORI'		, aProdMark[nCnt, 2]				, NIL})
						aadd(aLine, {'C6_SERIORI'	, aProdMark[nCnt,13]				, NIL})
						aadd(aLine, {'C6_ITEMORI'	, aProdMark[nCnt,14]				, NIL})
						aadd(aLine, {'C6_IDENTB6'	, aProdMark[nCnt,12]				, NIL})				
					ElseIf !Empty( aProdMark[nCnt, 2] )
						aadd(aLine, {'C6_LOCALIZ'	, aProdMark[nCnt, 2]			, NIL})
					EndIf

					if cTipoTran == "3" .or. cTipoTran == "4"
						chkProdTbl( aProdMark[nCnt, 3] )
					endif

					aadd(aSC6, aLine)			
				next
			Else
				For nCnt:=1 To Len(aCols)
					aLine := {}
					cItemPV := soma1(cItemPV)
					cTes := MaTesInt(2,cOper,cCliFor,cLjCliFor,cTpCliFor,gdFieldGet("C6_PRODUTO",nCnt),"C6_TES")  
					If Empty(cTes)
						lContinua := .F.
						cProd := gdFieldGet("C6_PRODUTO",nCnt)
						Exit
					Else
						If (nPos:=aScan(aTes,{|x| x[2]==cTes})) == 0
							aAdd(aTes,{cItemPV,cTes,1,nCnt})		
						Else
							aTes[nPos][3]++	
							aTes[nPos][4] := nCnt
						Endif	
					Endif	

					aadd(aLine, {'C6_ITEM'		, cItemPV						, NIL})
					aadd(aLine, {'C6_PRODUTO'	, gdFieldGet("C6_PRODUTO",nCnt)	, NIL})
					aadd(aLine, {'C6_QTDVEN'	, gdFieldGet("C6_QTDVEN",nCnt)	, NIL})
					aadd(aLine, {'C6_PRCVEN'	, gdFieldGet("C6_PRCVEN",nCnt)	, NIL})
					aadd(aLine, {'C6_QTDLIB'	, gdFieldGet("C6_QTDVEN",nCnt)	, NIL})
					//aadd(aLine, {'C6_OPER'		, cOper							, NIL})
					aadd(aLine, {'C6_TES'		, cTes							, NIL})
					aadd(aLine, {'C6_LOCAL'		, QRYSZ4->Z4_LOCAL				, NIL})
					aadd(aLine, {'C6_LOTECTL'	, gdFieldGet("C6_LOTECTL",nCnt)	, NIL})
					aadd(aLine, {'C6_DTVALID'	, gdFieldGet("C6_DTVALID",nCnt)	, NIL})
					aadd(aLine, {'C6_IDENTB6'	, gdFieldGet("C6_IDENTB6",nCnt)	, NIL})
					If cTipoTran == "4"
						aadd(aLine, {'C6_LOCAL'		, QRYSZ4->Z4_LOCAL				, NIL}) 
						aadd(aLine, {'C6_NFORI'		, gdFieldGet("C6_NFORI",nCnt)	, NIL})
						aadd(aLine, {'C6_SERIORI'	, gdFieldGet("C6_SERIORI",nCnt)	, NIL})
						aadd(aLine, {'C6_ITEMORI'	, gdFieldGet("C6_ITEMORI",nCnt)	, NIL})					
					//Else
					//	aadd(aLine, {'C6_LOCAL'		, QRYSZ4->Z4_LOCAL				, NIL})
					Endif

					if cTipoTran == "3" .or. cTipoTran == "4"
						chkProdTbl( gdFieldGet("C6_PRODUTO", nCnt) )
					endif

					aadd(aSC6, aLine)			
				Next
			Endif		
	        
			If !lContinua
				APMsgStop("Pelas regras cadastradas de 'TES inteligente', não foi encontrado 'TES' para os dados abaixo: "+CRLF+;
				"Tipo de Operação: "+cOper+CRLF+;
				IIf(cTpCliFor=="C","Cliente: ","Fornecedor: ")+cCliFor+CRLF+;
				"Loja: "+cLjCliFor+CRLF+;
				"Produto: "+cProd) 				
				//DISARMTRANSACTION()

				Return()
			Endif	

			BEGIN TRANSACTION
            
			//For nCnt:=1 To Len(aTes)
			//	insertSZ5(cSZ5Num,cTipoTran,aTes[nCnt])
			//Next	

			if !isBlind()
				oSay:cCaption := ("Gerando pedido...")
			endif

			MSExecAuto({|x,y,z|MATA410(x,y,z)}, aSC5, aSC6, 3)

			if lMsErroAuto
				DISARMTRANSACTION()
				ROLLBACKSX8()
                /*
				aErro := GetAutoGRLog() // Retorna erro em array
				cErro := ""

				for nI := 1 to len(aErro)
					cErro += aErro[nI] + CRLF
				next nI

				cNameLog := funName() + dToS(dDataBase) + strTran(time(),":")

				memoWrite("\" + cNameLog+".txt" , cErro)

				cMsgProc += "Erro - Inclusão do Pedido de Venda" + CRLF
				//cMsgProc += "Verifique arquivo de log: " + cNameLog + CRLF
				*/
				If (!IsBlind()) // COM INTERFACE GRÁFICA
				MostraErro()
			    Else // EM ESTADO DE JOB
			        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
			
			        ConOut(PadC("Automatic routine ended with error", 80))
			        ConOut("Error: "+ cError)
			    EndIf
			else

				For nCnt:=1 To Len(aTes)
					insertSZ5(cSZ5Num,cTipoTran,aTes[nCnt])
					Exit // inserido em 14/05/18 por gresele, pois a tabela sz5 deve ser gravada somente com 1 registro, nao sendo necessaria esta gravacao com FOR, pois se a sz5 ficar com 2 registros ficarah errada, pois 1 registro ficarah em duplicidade
				Next	

				cMsgProc += "Pedido de Venda " + cC5Num + " gerado." + CRLF

				SC5->(DBGoTop())
				SC5->(DBSetOrder(1))
				if SC5->(DBSeek(xFilial("SC5") + cC5Num))
					MaLiberOk( { SC5->C5_NUM }, .T. )
				endif

				CONFIRMSX8()

				if !isBlind()
					oSay:cCaption := ("Pedido gerado...")
				endif

				u_updateSZ5(cSZ5Num, 1, cC5Num)

				//if !lSchedule
				//	u_genNF(oSay, cC5Num, cSZ5Num)
				//endif
			endif
			
			END TRANSACTION

		endif
	//END TRANSACTION

	QRYSZ4->(DBCloseArea())

	if !empty(cMsgProc) .and. !isBlind()
		msgAlert(cMsgProc)
		cleanMarks()
	endif

	if !lMsErroAuto .and. lSchedule
		msgAlert("Agendamento efetuado com sucesso!")
		cleanMarks()
	endif

	restArea(aAreaSC5)
return

//-------------------------------------------------------------
// Verifica se produtos de triangulacao estao endereçados
//-------------------------------------------------------------
static function chkSDA()
	local cQrySDA	:= ""
	local lRetSDA	:= .F.

	cQrySDA := "SELECT D1_DOC, DA_DOC"									+ CRLF
	cQrySDA += " FROM "			+ retSQLName("SD1") + " SD1"			+ CRLF
	cQrySDA += " LEFT JOIN "	+ retSQLName("SDA") + " SDA"			+ CRLF
	cQrySDA += " ON"													+ CRLF
	cQrySDA += "		SDA.DA_SALDO	=	0"							+ CRLF
	cQrySDA += "	AND SDA.DA_PRODUTO	=	SD1.D1_COD"					+ CRLF
	cQrySDA += "	AND SDA.DA_LOJA		=	SD1.D1_LOJA"				+ CRLF
	cQrySDA += "	AND SDA.DA_CLIFOR	=	SD1.D1_FORNECE"				+ CRLF
	cQrySDA += "	AND SDA.DA_SERIE	=	SD1.D1_SERIE"				+ CRLF
	cQrySDA += "	AND SDA.DA_DOC		=	SD1.D1_DOC"					+ CRLF
	cQrySDA += "	AND SDA.DA_FILIAL	=	'" + xFilial("SDA")	+ "'"	+ CRLF
	cQrySDA += "	AND SDA.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQrySDA += " WHERE"													+ CRLF
	cQrySDA += "		SD1.D1_LOJA		=	'" + cGetLjForn		+ "'"	+ CRLF
	cQrySDA += "	AND SD1.D1_FORNECE	=	'" + cGetForn		+ "'"	+ CRLF
	cQrySDA += "	AND SD1.D1_SERIE	=	'" + cGetNFSer		+ "'"	+ CRLF
	cQrySDA += "	AND SD1.D1_DOC		=	'" + cGetNFEnt		+ "'"	+ CRLF
	cQrySDA += " 	AND SD1.D1_FILIAL	=	'" + xFilial("SD1")	+ "'"	+ CRLF
	cQrySDA += " 	AND SD1.D_E_L_E_T_	<>	'*'"						+ CRLF

	memoWrite("C:\TEMP\chkSDA.sql", cQrySDA)

	tcQuery (cQrySDA) New Alias "QRYSDA"

	while !QRYSDA->(EOF())
		if empty(QRYSDA->DA_DOC)
			lRetSDA := .T.
			exit
		endif
		QRYSDA->(DBSkip())
	enddo

	QRYSDA->(DBCloseArea())
return lRetSDA

//-------------------------------------------------------------
// Retorna o Preço do Produto
//-------------------------------------------------------------
static function getB1Prc(cB1Prod,cC5Tab)
	local cQryPrc	:= ""
	local nPrcB1	:= 0

	If Empty(cC5Tab)
		nPrcB1 := Posicione("SB1",1,xFilial("SB1")+cB1Prod,"B1_PRV1")
	Else
		nPrcB1 := Posicione("DA1",1,xFilial("DA1")+cC5Tab+cB1Prod,"DA1_PRCVEN")
		If Empty( nPrcB1 )
			nPrcB1 := Posicione("SB1",1,xFilial("SB1")+cB1Prod,"B1_PRV1")
		EndIf
	EndIf	
	/*
	cQryPrc := "SELECT B1_PRV1"
	cQryPrc += " FROM " + retSQLName("SB1") + " SB1"
	cQryPrc += " WHERE"
	cQryPrc += " 		SB1.B1_COD		=	'" + cB1Prod		+ "'"
	cQryPrc += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1") + "'"
	cQryPrc += " 	AND	SB1.D_E_L_E_T_	<>	'*'"

	TcQuery ChangeQuery(cQryPrc) New Alias "QRYPRC"

	if !QRYPRC->(EOF())
		nPrcB1 := QRYPRC->B1_PRV1
	endif

	QRYPRC->(DBCloseArea())
    */
return nPrcB1

//-------------------------------------------------------------
// Retorna dados da tabela SZ4
//-------------------------------------------------------------
static function getInfoSZ4()
	local cQrySZ4 := ""

	cQrySZ4 := "SELECT * "
	cQrySZ4 += " FROM " + retSQLName("SZ4") + " SZ4"
	cQrySZ4 += " WHERE"
	cQrySZ4 += " 		SZ4.Z4_UNIDADE	=	'" + cCodFilial		+ "'"
	cQrySZ4 += " 	AND	SZ4.Z4_EMPRESA	=	'" + cCodEmpresa		+ "'"
	cQrySZ4 += " 	AND	SZ4.Z4_LOCAL		=	'" + cGetCdArma		+ "'"
	cQrySZ4 += " 	AND	SZ4.Z4_FILIAL		=	'" + xFilial("SZ4")	+ "'"
	cQrySZ4 += " 	AND	SZ4.D_E_L_E_T_	<>	'*'"

	memoWrite("C:\TEMP\" + funName() + "_SZ4.sql", cQrySZ4)

	If Select("QRYSZ4") > 0
		QRYSZ4->(dbCloseArea())
	Endif	
	TcQuery ChangeQuery(cQrySZ4) New Alias "QRYSZ4"
return

//-------------------------------------------------------------
// Insere Pedido/Transferencia na tabela SZ5
//-------------------------------------------------------------
static function insertSZ5(cSZ5Num,cTipoTran,aTes)
	local cInsertSZ5	:= ""

	recLock("SZ5", .T.)
		SZ5->Z5_FILIAL 	:= xFilial("SZ5")
		SZ5->Z5_NUM		:= cSZ5Num
		SZ5->Z5_LOCAL	:= cGetCdArma
		SZ5->Z5_EMPRESA	:= cCodEmpresa
		SZ5->Z5_UNIDADE	:= cCodFilial
		If cTipoTran $ "1/2/3"
			SZ5->Z5_CODCLI	:= QRYSZ4->Z4_CODCLI
			SZ5->Z5_LOJACLI	:= QRYSZ4->Z4_LOJACLI
			SZ5->Z5_CODFOR	:= QRYSZ4->Z4_CODFOR
			SZ5->Z5_LOJAFOR	:= QRYSZ4->Z4_LOJAFOR
		Elseif cTipoTran == "4"
			SZ5->Z5_CODCLI	:= QRYSZ4->Z4_CLIRET //QRYSZ4->Z4_CODFOR // parece estranho esta gravacao, mas eh isso mesmo, no caso de devolucao, o cliente eh a filial que estah devolvendo o produto, que no SZ4 estah cadastrado como fornecedor
			SZ5->Z5_LOJACLI	:= QRYSZ4->Z4_LJCLIRE //QRYSZ4->Z4_LOJAFOR
			SZ5->Z5_CODFOR	:= QRYSZ4->Z4_FORRET //cGetForn // o fornecedor eh o que foi escolhido pelo usuario na tela da rotina e nao o cadastrado no SZ4
			SZ5->Z5_LOJAFOR	:= QRYSZ4->Z4_LJFORRE //cGetLjForn
		Endif	
		SZ5->Z5_TESVEN	:= IIf(cTipoTran == "1",aTes[2],"")
		SZ5->Z5_TESTRAN	:= IIf(cTipoTran == "2",aTes[2],"")
		SZ5->Z5_TESREM	:= IIf(cTipoTran == "3",aTes[2],"")
		SZ5->Z5_TESRET	:= IIf(cTipoTran == "4",aTes[2],"")
		If cTipoTran $ "3/4" // remessa/retorno
			SZ5->Z5_NFREMOR	:= xFilial("SF1")+padR(cGetNFEnt,tamSx3("F1_DOC")[1])+padR(cGetNFSer,tamSx3("F1_SERIE")[1])+cGetForn+cGetLjForn
		Endif
		SZ5->Z5_TRANSF	:= IIf(cTipoTran == "2","S","")
		SZ5->Z5_VENDA	:= IIf(cTipoTran == "1","S","")
		SZ5->Z5_RETORNO	:= IIf(cTipoTran == "4","S","")
		SZ5->Z5_REMESSA	:= IIf(cTipoTran == "3","S","")
		SZ5->Z5_CONDPAG	:= QRYSZ4->Z4_CONDPAG
		SZ5->Z5_TRANSPO	:= cGetTransp
		SZ5->Z5_VEICULO	:= cGetVeic
		SZ5->Z5_PLACA	:= cGetPlaca
		SZ5->Z5_MOTORIS	:= cGetMotor
		SZ5->Z5_OBSERV	:= cGetObser
		SZ5->Z5_DATA	:= dDataBase
		SZ5->Z5_HORA	:= left(time(), 5)
		SZ5->Z5_USUARIO	:= usrFullName(retCodUsr())
		//SZ5->Z5_AGENDA	:=
		SZ5->Z5_AGDATA	:= dGetData
		SZ5->Z5_AGHORA	:= cGetHora
		SZ5->Z5_LOCDEST	:= cCdArmaDes
		// comentado em 14/05/18 por gresele, pois nao foi identificado nenhum ponto onde este campo eh usado
		//If aTes[4] > 1 .and. aTes[3] = 1 // somente grava o item se pedido teve mais de um item e tes aparece somente em 1 item
		//	SZ5->Z5_ITEM := aTes[1]
		//Endif	
	SZ5->(msUnlock())
return

//-------------------------------------------------------------
// Limpa os produtos marcados
//-------------------------------------------------------------
static function cleanMarks()
	local nI := 0
	local nTamSD1		:= (tamSx3("D1_FILIAL")[1] + tamSx3("D1_DOC")[1] + tamSx3("D1_SERIE")[1] + tamSx3("D1_FORNECE")[1] + tamSx3("D1_LOJA")[1] + tamSx3("D1_ITEM")[1])
	aProdMark := {}
	for nI := 1 to len(aProd)
		//aProd[nI, 11] := 0
		//aProd[nI, 12] := space(nTamSD1)
		aProd[nI, 11] := space(nTamSD1)
	next

return

//-------------------------------------------------------------------
/*/{Protheus.doc} genNF

Gera NF

@author Gustavo Ananias Afonso - TOTVS Campinas
@since 22/08/2016
/*/
//-------------------------------------------------------------------
user function genNF(oSay, cC5Num, cSZ5Num, lSchedule)
	local aArea 	:= getArea()
	local aAreaSC5	:= SC5->(getArea())
	local aAreaSC9	:= SC9->(getArea())
	local aAreaSC6	:= SC6->(getArea())
	local aAreaSE4	:= SE4->(getArea())
	local aAreaSB1	:= SB1->(getArea())
	local aAreaSB2	:= SB2->(getArea())
	local aAreaSF4	:= SF4->(getArea())

	local cNotaGer	:= ""
	local cSerieX	:= ""
	Local cMsgProc := ""

	default oSay		:= nil
	default lSchedule	:= .F.

	if !isBlind()
		//oSay:cCaption := ("Gerando Nota Fiscal de Saída...")
	endif

	DBSelectArea("SC5")
	DBSelectArea("SC9")
	DBSelectArea("SC6")
	DBSelectArea("SE4")
	DBSelectArea("SB1")
	DBSelectArea("SB2")
	DBSelectArea("SF4")
	
	SC5->(DBSetOrder(1))
	SC9->(DBSetOrder(1))
	SC6->(DBSetOrder(1))
	SE4->(DBSetOrder(1))
	SB1->(DBSetOrder(1))
	SB2->(DBSetOrder(1))
	SF4->(DBSetOrder(1))

	SC5->(DBGoTop())
	SC9->(DBGoTop())
	SC6->(DBGoTop())
	SE4->(DBGoTop())
	SB1->(DBGoTop())
	SB2->(DBGoTop())
	SF4->(DBGoTop())

	aPvlNfs := {}
	
	If SC5->(DbSeek(xFilial("SC5")+cC5Num))
		If SC9->(DbSeek(xFilial("SC9")+cC5Num))
			While SC9->(!Eof()) .AND. SC9->C9_PEDIDO == cC5Num
				SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
				SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
				SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
				SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL))
				SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
	
				aAdd(aPvlNfs,{;
				SC9->C9_PEDIDO,;
				SC9->C9_ITEM,;
				SC9->C9_SEQUEN,;
				SC9->C9_QTDLIB,;
				SC9->C9_PRCVEN,;
				SC9->C9_PRODUTO,;
				.F.,;
				SC9->(RECNO()),;
				SC5->(RECNO()),;
				SC6->(RECNO()),;
				SE4->(RECNO()),;
				SB1->(RECNO()),;
				SB2->(RECNO()),;
				SF4->(RECNO());
				})
				SC9->(DbSkip())
			EndDo
		EndIf
    EndIf
    
	If Len(aPvlNfs) > 0
		//xME1Tot(cC5Num)
		cNotaGer	:= ""
		cSerieX		:= allTrim(getMv("MGF_SERSF2")) // AUT - Esta série deve estar cadastrada no SX5 (Tabela 00 Chave 01) para cada filial
	
		cNotaGer	:= MaPvlNfs(aPvlNfs, cSerieX, .F., .F., .F., .F., .F., 0, 0, .F., .F.)
	Endif	
	
	If !Empty(cNotaGer)
		if !lSchedule
			cMsgProc += "Nota Fiscal Gerada " + cNotaGer + CRLF
			//oSay:cCaption := ("Nota Fiscal Gerada: " + cNotaGer)
		endif

		CONOUT("Nota Fiscal Gerada: " + cNotaGer)
		APMsgInfo(cMsgProc)

		//SF2.F2_FILIAL + SF2.F2_DOC + SF2.F2_SERIE + SF2.F2_CLIENTE + SF2.F2_LOJA

		SC9->(DBGoTop())
		SC9->(DbSeek(xFilial("SC9")+cC5Num))

		u_updateSZ5(cSZ5Num, 2, xFilial("SF2") + padR(cNotaGer, tamSx3("F2_DOC")[1]) + padR(cSerieX, tamSx3("F2_SERIE")[1]) + SC9->C9_CLIENTE + SC9->C9_LOJA)
	Else
		DISARMTRANSACTION()
		if !lSchedule
			cMsgProc += "Nota Fiscal não foi gerada." + CRLF
		endif

		CONOUT("Nota Fiscal não foi gerada.")
		APMsgAlert(cMsgProc)
	Endif

	//Funcao para anular as variaveis criadas na NF de Saida
	MaNfsEnd()

	//Limpa o Array de NF para Processar Pr??o Pedido
	aPvlNfs := {}

	restArea(aAreaSF4)
	restArea(aAreaSB2)
	restArea(aAreaSB1)
	restArea(aAreaSE4)
	restArea(aAreaSC6)
	restArea(aAreaSC9)
	restArea(aAreaSC5)
	restArea(aArea)
return

//-------------------------------------------------------------
// Atualiza SZ5 com o PV / NF
//-------------------------------------------------------------
user function updateSZ5(cSZ5Num, nType, cNum)
	local cUpdSZ5 := ""
	local cFilSZ5 := ""

	cUpdSZ5 := "UPDATE " + retSQLName("SZ5")	+ CRLF
	cUpdSZ5 += " SET"	+ CRLF

	if nType == 1
		cUpdSZ5 += "	Z5_NUMPV	= '" + cNum + "'"	+ CRLF
		cFilSZ5 := xFilial("SZ5")
	elseif nType == 2
		cUpdSZ5 += "	Z5_NUMNF = '" + cNum + "'"	+ CRLF
		cFilSZ5 := SZ5->Z5_FILIAL
	elseif nType == 3
		cUpdSZ5 += "	Z5_NUMNFEN = '" + cNum + "'"	+ CRLF
		cFilSZ5 := SZ5->Z5_FILIAL
	endif

	cUpdSZ5 += " WHERE"										+ CRLF
	cUpdSZ5 += " 		Z5_NUM		=	'" + cSZ5Num + "'"	+ CRLF
	cUpdSZ5 += " 	AND	Z5_FILIAL		=	'" + cFilSZ5 + "'"	+ CRLF
	cUpdSZ5 += " 	AND	D_E_L_E_T_	<>	'*'"				+ CRLF

	tcSQLExec(cUpdSZ5)
return


//------------------------------------------------------
// Valida Tabela de Preco
//------------------------------------------------------
static function valTabPrc(cGetTabPrc,cDescTabPrc,oDescTabPrc)
	local cQryDA0 := ""
	local lRet	:= .T.

	if lChk .AND. allTrim(cGetTabPrc) <> allTrim(cTabPrcRem)
		msgAlert("Tabela de Preço digitada é diferente da Tabela de Preço definida para Remessa/Retorno (" + cTabPrcRem + ")")
		return .F.
	endif

	cQryDA0 := "SELECT * "									+ CRLF
	cQryDA0 += " FROM " + retSQLName("DA0") + " DA0"						+ CRLF
	cQryDA0 += " WHERE"														+ CRLF
	cQryDA0 += " 	DA0_CODTAB				=	'" + cGetTabPrc			+ "'"	+ CRLF
	cQryDA0 += " 	AND	DA0_FILIAL	  		=	'" + xFilial("DA0")		+ "'"	+ CRLF
	cQryDA0 += " 	AND	DA0.D_E_L_E_T_		<>	'*'"							+ CRLF

	TcQuery (cQryDA0) New Alias "QRYDA0"

	if !QryDA0->(EOF())
		If QRYDA0->DA0_ATIVO == "2"
			msgAlert("Tabela de Preço bloqueada para uso.")
			lRet := .F.
		Endif
		If lRet
			If QRYDA0->DA0_DATDE > dTos(dDataBase) .or. (!Empty(QRYDA0->DA0_DATATE) .and. QRYDA0->DA0_DATATE < dTos(dDataBase))
				msgAlert("Tabela de Preço fora de vigência.")
				lRet := .F.
			Endif
		Endif	
		If lRet        
			cDescTabPrc := QRYDA0->DA0_DESCRI
			oDescTabPrc:refresh()
		Endif	
	else
		msgAlert("Tabela de Preço informada não existe no cadastro.")
		lRet := .F.
	endif

	QRYDA0->(DBCloseArea())
return lRet


//------------------------------------------------------
// Valida Vendedor
//------------------------------------------------------
static function valVend(cGetVend,cDescVend,oDescVend)
	local cQrySA3 := ""
	local lRet	:= .T.

	cQrySA3 := "SELECT A3_COD,A3_NOME,A3_MSBLQL "									+ CRLF
	cQrySA3 += " FROM " + retSQLName("SA3") + " SA3"						+ CRLF
	cQrySA3 += " WHERE"														+ CRLF
	cQrySA3 += " 	A3_COD					=	'" + cGetVend			+ "'"	+ CRLF
	cQrySA3 += " 	AND	A3_FILIAL	  		=	'" + xFilial("SA3")		+ "'"	+ CRLF
	cQrySA3 += " 	AND	SA3.D_E_L_E_T_		<>	'*'"							+ CRLF

	TcQuery ChangeQuery(cQrySA3) New Alias "QRYSA3"

	if !QrySA3->(EOF())
		If QRYSA3->A3_MSBLQL == "1"
			msgAlert("Vendedor bloqueado para uso.")
			lRet := .F.
		Endif
		If lRet        
			cDescVend := QRYSA3->A3_NOME
			oDescVend:refresh()
		Endif	
	else
		msgAlert("Vendedor informado não existe no cadastro.")
		lRet := .F.
	endif

	QRYSA3->(DBCloseArea())
return lRet


//------------------------------------------------------
// Valida Especie do Pedido
//------------------------------------------------------
static function valEsp(cGetEsp,cDescEsp,oDescEsp)
	local cQrySZJ := ""
	local lRet	:= .T.

	cQrySZJ := "SELECT ZJ_COD,ZJ_NOME "									+ CRLF
	cQrySZJ += " FROM " + retSQLName("SZJ") + " SZJ"						+ CRLF
	cQrySZJ += " WHERE"														+ CRLF
	cQrySZJ += " 	ZJ_COD					=	'" + cGetEsp			+ "'"	+ CRLF
	cQrySZJ += " 	AND	ZJ_FILIAL	  		=	'" + xFilial("SZJ")		+ "'"	+ CRLF
	cQrySZJ += " 	AND	SZJ.D_E_L_E_T_		<>	'*'"							+ CRLF

	TcQuery ChangeQuery(cQrySZJ) New Alias "QRYSZJ"

	if !QrySZJ->(EOF())
		cDescEsp := QrySZJ->ZJ_NOME
		oDescEsp:refresh()
	else
		msgAlert("Espécie do Pedido informado não existe no cadastro.")
		lRet := .F.
	endif

	QrySZJ->(DBCloseArea())
return lRet


Static Function _A410Devol(o,cAlias,nReg,nOpcx)

Static oNoMarked:= LoadBitmap(GetResources(),'LBNO')
Static oMarked	:= LoadBitmap(GetResources(),'LBOK') 

Local oDlgEsp
Local oLbx
Local lFornece  := .F.
Local aRotina	:= {{OemtoAnsi("Remessa"),"U_A410ProcDv",0,4,,,.T.}}
Local nOpca     := 0
Local aHSF1     := {}
Local aSF1      := {}
Local aCpoSF1   := {}
Local nCnt      := 0
Local nPosDoc   := 0
Local nPosSerie := 0
Local cDocSF1   := ''
Local cIndex    := ''
Local cQuery    := ''
Local cAliasSF1 := ''
Local lUsaNewKey:= TamSX3("F2_SERIE")[1] == 14 // Verifica se o novo formato de gravacao do Id nos campos _SERIE esta em uso

Private cFornece := CriaVar("F1_FORNECE",.F.)
Private cLoja    := CriaVar("F1_LOJA",.F.)
Private dDataDe   := CToD('  /  /  ')
Private dDataAte  := CToD('  /  /  ')
Private lForn    := .T.

If !lChk //!(cComboTipo == "Remessa" .or. cComboTipo == "Retorno")
	MsgAlert("Para usar esta opção a caixa de seleção 'Triangulação' deve estar marcada. Verifique.")
	Return()
Endif	

If Empty(cComboTri)
	MsgAlert("É necessário escolher o tipo de Triangulação. Verifique.")
	Return()
Endif	

If .T.//Inclui
	//-- Valida filtro de retorno de doctos fiscais.
	If _A410FRet(@lFornece,@dDataDe,@dDataAte,@lForn)
		If cComboTri == "Retorno"
			LoadP3Prod()
		Else
			DbSelectArea("SF1")
			cIndex := CriaTrab(NIL,.F.)
			cQuery := " SF1->F1_FILIAL == '" + xFilial("SF1") + "' "
		  	cQuery += " .And. SF1->F1_FORNECE == '" + cFornece + "' "
		  	cQuery += " .And. SF1->F1_LOJA    == '" + cLoja    + "' "
		  	cQuery += " .And. DtoS(SF1->F1_EMISSAO) >= '" + DtoS(dDataDe)  + "'"
			cQuery += " .And. DtoS(SF1->F1_EMISSAO) <= '" + DtoS(dDataAte) + "' "
			cQuery += " .And. !Empty(SF1->F1_VALMERC) " // Notas Classificadas
			cQuery += " .And. !U_MGFEST24() " // Verifica Notas já remetidas
			If lForn
			  	cQuery += " .And. !(SF1->F1_TIPO $ 'DB') "
			Else
			  	cQuery += " .And. SF1->F1_TIPO $ 'DB' "
			EndIf
			
			If Existblock("A410RNF")
            	cQuery := ExecBlock("A410RNF",.F.,.F.,{dDataDe,dDataAte,lForn,lFornece})
			EndIf
			
			IndRegua("SF1",cIndex,SF1->(IndexKey()),,cQuery)
			
			If SF1->(!Eof())
				MaWndBrowse(0,0,300,600,OemToAnsi("Retorno de Doctos. de Entrada"),"SF1",,aRotina,,,,.T.,,,,,,.F.) 
			Else
		      	Aviso(OemToAnsi("Atencao!"),OemToAnsi("Nenhum documento encontrado, favor verificar os dados informados  ..."),{OemToAnsi("Ok")}, 2) //-- //"Atencao!"###"Nenhum documento encontrado, favor verificar os dados informados  ..."###"Ok"
			EndIf
			RetIndex( "SF1" )
			FErase( cIndex+OrdBagExt() )		
		EndIf		
	EndIf
EndIf

Return .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ A410FRet ³ Autor ³ Patricia A. Salomao   ³ Data ³ 26/07/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Filtro para retornar de doctos fiscais.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A410FRet()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpL1 - Fornecedor ?                                       ³±±
±±³          ³ ExpD1 - Data Inicio                                        ³±±
±±³          ³ ExpD2 - Data Fim                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA410                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _A410FRet(lFornece,dDataDe,dDataAte,lForn)
Local cTDataDe  := OemToAnsi("Dt. Entrada De") //-- Dt. Entrada De
Local cTDataAte := OemToAnsi("Dt. Entrada Ate") //-- Dt. Entrada Ate
Local cTFornece := RetTitle("F1_FORNECE")
Local cTLoja    := RetTitle("F1_LOJA")
Local nOpcao    := 0
Local lCliente  := .F.
Local lDocto    := .F.
Local oDlgEsp
Local oCliente
Local oForn
Local oDocto 
Local oFornece
Local oPanelCli
Local oPanelFor
Local lGetFor	:= IIf(cComboTri=="Retorno",.F.,.T.)

GetInfoSZ4()

If cComboTri=="Retorno"
	cFornece	:= QRYSZ4->Z4_FORRET  //Z4_CODCLI
	cLoja		:= QRYSZ4->Z4_LJFORRE//Z4_LOJACLI
EndIf

DEFINE MSDIALOG oDlgEsp FROM 00,00 TO 190,490 PIXEL TITLE OemToAnsi("Retorno de Doctos. de Entrada") //-- Retorno de Doctos. de Entrada

	//-- Fornecedor'
	//@ 02,10 CHECKBOX oForn VAR lForn PROMPT OemToAnsi("Fornecedor") SIZE 50,010 ;
	//	ON CLICK( lCliente := .F., oCliente:Refresh(), A410CliFor(lForn,@lFornece,@lDocto,oDocto,oFornece,oDlgEsp,oPanelCli,oPanelFor)) OF oDlgEsp PIXEL  //-- Fornecedor

	//-- 'Cliente'
	//@ 02,120 CHECKBOX oCliente VAR lCliente PROMPT OemToAnsi(STR0105) SIZE 50,010 ;
	//	ON CLICK( lForn := .F., oForn:Refresh(), A410CliFor(lForn,@lFornece,@lDocto,oDocto,oFornece,oDlgEsp,oPanelCli,oPanelFor)) OF oDlgEsp PIXEL //-- Cliente


	@ 018,000 MSPANEL oPanelCli OF oDlgEsp SIZE 245,020               

	@ 018,000 MSPANEL oPanelFor OF oDlgEsp SIZE 245,020

	cTFornece := RetTitle("F1_FORNECE")
    cTLoja    := RetTitle("F2_LOJA")
	@ 001,05 SAY cTFornece PIXEL SIZE 47 ,9 OF oPanelFor
	@ 001,40 MSGET cFornece PICTURE "@!" F3 'FOR' SIZE 65, 10 OF oPanelFor PIXEL WHEN lGetFor

	@ 001,120 SAY cTLoja PIXEL OF oPanelFor
	@ 001,160 MSGET cLoja PICTURE "@!" SIZE 20, 10 OF oPanelFor PIXEL ;
			VALID Vazio() .Or. ExistCpo('SA2',cFornece+cLoja,1) WHEN lGetFor

    cTLoja    := RetTitle("F2_LOJA")
	@ 001,05 SAY RetTitle("F2_CLIENTE") PIXEL SIZE 50 ,10 OF oPanelCli
	@ 001,40 MSGET cFornece F3 'SA1' SIZE 65, 10 OF oPanelCli PIXEL

	@ 001,120 SAY cTLoja PIXEL OF oPanelCli
	@ 001,160 MSGET cLoja SIZE 20, 10 OF oPanelCli PIXEL ;
			VALID Vazio() .Or. ExistCpo('SA1',cFornece+cLoja,1)
	oPanelCli:Hide()


	@ 39,05 SAY cTDataDe PIXEL //-- Data De
	@ 38,40 MSGET dDataDe PICTURE "@D" SIZE 45, 10 OF oDlgEsp PIXEL

	@ 39,120 SAY cTDataAte PIXEL //-- Data Ate
	@ 38,160 MSGET dDataAte PICTURE "@D" SIZE 45, 10 OF oDlgEsp PIXEL

	//@ 60,003 TO 085,195 LABEL OemToAnsi(STR0100) OF oDlgEsp PIXEL  //-- Tipo de Selecao

	//-- 'Fornecedor'
	//@ 70,10 CHECKBOX oFornece VAR lFornece PROMPT PadR(IIf(lForn,OemToAnsi(STR0099),RetTitle("F2_CLIENTE")),20) SIZE 50,010 ;
	//	ON CLICK( lDocto := .F., oDocto:Refresh() ) OF oDlgEsp PIXEL  //-- Fornecedor

	//-- 'Documento'
	//@ 70,120 CHECKBOX oDocto VAR lDocto PROMPT OemToAnsi(STR0102) SIZE 50,010 ;
	//	ON CLICK( lFornece := .F., oFornece:Refresh() ) OF oDlgEsp PIXEL //-- Documento

	If cComboTri=="Retorno"
		lForn := .t.
	else
		lForn := .T.
	endif

	lCliente := .F.
	lFornece := .F.
	lDocto := .T.

	DEFINE SBUTTON FROM 05,215 TYPE 1 OF oDlgEsp ENABLE ;
		ACTION IIf(!Empty(cFornece) .And. !Empty(cLoja) .And. ;
			 		 !Empty(dDataDe) .And. !Empty(dDataAte) .And. ;
			 		 (lFornece .Or. lDocto) .And. ;
			 		 IIF(lForn,ExistCpo('SA2',cFornece+cLoja,1),ExistCpo('SA1',cFornece+cLoja,1)) .and. ;//(nOpcao := 1,oDlgEsp:End()),.F.)			 		 
			 		 IIf(cComboTri=="Retorno",IIf(cFornece+cLoja==QRYSZ4->Z4_FORRET+QRYSZ4->Z4_LJFORRE,.T.,(MsgAlert("Fornecedor não é o mesmo do cadastrado no cadastro de Armazéns X Unidades, escolher fornecedor correto."),.F.)),.T.),;
			 		 (nOpcao := 1,oDlgEsp:End()),.F.)


DEFINE SBUTTON FROM 20,215 TYPE 2 OF oDlgEsp ENABLE ACTION (nOpcao := 0,oDlgEsp:End())

ACTIVATE MSDIALOG oDlgEsp CENTERED

Return ( nOpcao == 1 )   


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³a410ProcDv³Autor  ³Henry Fila             ³ Data ³07.09.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do cabecalho do pedido de venda                ³±±
±±³          ³ExpN2: Recno do cabecalho do pedido de venda                ³±±
±±³          ³ExpN3: Opcao do arotina                                     ³±±
±±³          ³ExpL3: Se traz baseado em uma entrada (SF1)                 ³±±
±±³          ³       .T. - Se baseia na nota fiscal de entrada            ³±±
±±³          ³       .F. - Copia um pedido de venda Normal                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Esta rotina tem como objetivo efetuar a interface com o usua³±±
±±³          ³rio e o pedido de vendas                                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A410ProcDv(cAlias,nReg,nOpc,lFornece,cFornece,cLoja,cDocSF1)

Local aArea     := GetArea()
Local aAreaSX3  := SX3->(GetArea())
Local aAreaSF1  := SF1->(GetArea())
Local aAreaSD1  := SD1->(GetArea())
Local aAreaSB8  := SB8->(GetArea())
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aPosGet   := {}
Local aRegSC6   := {}
Local aRegSCV   := {}
Local aInfo     := {}
Local aHeadSC6  := {}
Local aValor    := {}

Local lLiber 	:= .F.
Local lTransf	:= .F.
Local lQuery    := .F.
Local lContinua := .T.
Local lPoder3   := .T. 
Local lM410PcDv := ExistBlock("M410PCDV")
Local nOpcA		:= 0
Local nUsado    := 0
Local nCntFor   := 0
Local nTotalPed := 0
Local nTotalDes := 0
Local nNumDec   := TamSX3("C6_VALOR")[2]
Local cItem		:= StrZero(0,TamSX3("C6_ITEM")[1])
Local nGetLin   := 0
Local nStack    := GetSX8Len()
Local nPosPrc   := 0
Local nPValDesc := 0
Local nPPrUnit  := 0
Local nPQuant   := 0
Local nSldQtd   := 0
Local nSldQtd2  := 0
Local nSldLiq   := 0
Local nSldBru   := 0
Local nX        := 0
Local nCntSD1   := 0
Local nTamPrcVen:= TamSX3("C6_PRCVEN")[2]

Local cAliasSD1 := "SD1"
Local cAliasSB1 := "SB1"
Local cCodTES   := ""
Local cCampo    :=""
Local cTipoPed  :=""
Local cQuery   := ""
Local oDlg
Local oGetd
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Local aRecnoSE1RA := {} // Array com os titulos selecionados pelo Adiantamento
Local aHeadAGG    := {}
Local aColsAGG    := {}
Local lBenefPodT	:=.F.

#IFNDEF TOP
	Local cIndex   := ""
	Local nIndBrw  := 0		
#ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na LinhaOk                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
PRIVATE aCols      := {}
PRIVATE aHeader    := {}
PRIVATE aHeadFor   := {}
PRIVATE aColsFor   := {}
PRIVATE N          := 1
*/
/*
If IsAtNewGrd()
	PRIVATE oGrade	  := MsMatGrade():New('oGrade',,"C6_QTDVEN",,"a410GValid()",{ {VK_F4,{|| A440Saldo(.T.,oGrade:aColsAux[oGrade:nPosLinO][aScan(oGrade:aHeadAux,{|x| AllTrim(x[2])=="C6_LOCAL"})] )}} }) 
Else
	PRIVATE aColsGrade := {}
	PRIVATE aHeadgrade := {}
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTELA[0][0],aGETS[0]

PRIVATE oGetPV	:= Nil
*/

Private INCLUI := .T. // variavel criada para nao dar erro no x3_relacao de alguns campos da SC5 que precisam desta variavel criada

Default lFornece := .F.
Default cFornece := SF1->F1_FORNECE
Default cLoja    := SF1->F1_LOJA
Default cDocSF1  := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega perguntas do MATA440 e MATA410                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte("MTA440",.F.)
//lLiber := MV_PAR02 == 1
//lTransf:= MV_PAR01 == 1

//Pergunte("MTA410",.F.)
//Carrega as variaveis com os parametros da execauto
//Ma410PerAut()

// limpa variaveis private
aCols := {}
aHeader := {}
N := 1

SB8->(dbSetOrder(3))

If SoftLock("SF1")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC6")
	While ( !EOF() .And. (SX3->X3_ARQUIVO == "SC6") )
		If (	X3USO(SX3->X3_USADO) .And.;
				!( Trim(SX3->X3_CAMPO) == "C6_NUM" );
				.And. Trim(x3_campo) <> "C6_QTDEMP";
				.And. Trim(x3_campo) <> "C6_QTDENT";
				.And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			aAdd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	If ( lContinua )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem dos itens da Nota Fiscal de Devolucao/Retorno          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD1")
		dbSetOrder(1)
		#IFDEF TOP
			lQuery    := .T.
			cAliasSD1 := "QRYSD1"
			cAliasSB1 := "QRYSD1"
			aStruSD1  := SD1->(dbStruct())
			cQuery    := "SELECT SD1.*,B1_DESC,B1_UM,B1_SEGUM "
			cQuery    += "FROM "+RetSqlName("SD1")+" SD1, "
			cQuery    += RetSqlName("SB1")+" SB1 "
			cQuery    += "WHERE SD1.D1_FILIAL='"+xFilial("SD1")+"' AND "
			If !lFornece
				cQuery    += "SD1.D1_DOC = '"+SF1->F1_DOC+"' AND "
				cQuery    += "SD1.D1_SERIE = '"+SF1->F1_SERIE+"' AND "
			Else
				If !Empty(cDocSF1)
					cQuery += " ( "
					cQuery += cDocSF1 + " AND "
				EndIf
			EndIf
			cQuery    += "SD1.D1_FORNECE = '"+cFornece+"' AND "
			cQuery    += "SD1.D1_LOJA = '"+cLoja+"' AND "
			cQuery    += "SD1.D_E_L_E_T_=' ' AND "

			cQuery    += "SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
			cquery    += "SB1.B1_COD = SD1.D1_COD AND "
			cQuery    += "SB1.D_E_L_E_T_=' ' "

			cQuery    += "ORDER BY "+SqlOrder(SD1->(IndexKey()))

			cQuery    := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)

			For nX := 1 To Len(aStruSD1)
				If aStruSD1[nX][2]<>"C"
					TcSetField(cAliasSD1,aStruSD1[nX][1],aStruSD1[nX][2],aStruSD1[nX][3],aStruSD1[nX][4])
				EndIf
			Next nX
		#ELSE
		#ENDIF

		While !Eof() .And. (cAliasSD1)->D1_FILIAL == xFilial("SD1") .And.;
			(cAliasSD1)->D1_FORNECE == cFornece .And.;
			(cAliasSD1)->D1_LOJA == cLoja .And.;
			If(!lFornece,(cAliasSD1)->D1_DOC == SF1->F1_DOC .And.;
							 (cAliasSD1)->D1_SERIE == SF1->F1_SERIE,.T.)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se existe quantidade a ser devolvida                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If IIf(cComboTri=="Retorno",(cAliasSD1)->D1_QUANT > (cAliasSD1)->D1_QTDEDEV,.T.)

				cItem := Soma1(cItem)

				If !lQuery
					SB1->(dbSetOrder(1))
					SB1->(MsSeek(xFilial("SB1")+(cAliasSD1)->D1_COD))
				Endif

				SF1->(dbSetOrder(1))
				SF1->(MsSeek(xFilial("SF1")+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_TIPO))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe um tes de devolucao correspondente           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				dbSelectArea("SF4")
				DbSetOrder(1)
				If MsSeek(xFilial("SF4")+(cAliasSD1)->D1_TES) .and. cComboTri == "Retorno"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o poder de terceiros                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lPoder3 
						lPoder3 := ( SF4->F4_PODER3=="R" ) 
					EndIf

					If Empty(SF4->F4_TESDV) .Or. !(SF4->(MsSeek(xFilial("SF4")+SF4->F4_TESDV)))
						Help(" ",1,"DSNOTESDEV")
						lContinua := .F.
						Exit 
					Else
						cCodTES := SF4->F4_CODIGO
					EndIf
					
					If !(lPoder3 .Or. SF1->F1_TIPO=="N")
						Help(" ",1,"A410PODER3")
						lContinua := .F.
						Exit 						
					EndIf
				Elseif cComboTri == "Remessa"
					lPoder3 := .F.
					cCodTES := QRYSZ4->Z4_TESREM
				EndIf
				
				If cComboTri == "Retorno"				
					aValor := _A410SNfOri((cAliasSD1)->D1_FORNECE,;
											(cAliasSD1)->D1_LOJA,;
											(cAliasSD1)->D1_DOC,;
											(cAliasSD1)->D1_SERIE,;
											If(lPoder3,"",(cAliasSD1)->D1_ITEM),;
											(cAliasSD1)->D1_COD,;
											If(lPoder3,(cAliasSD1)->D1_IDENTB6,),;
											If(lPoder3,(cAliasSD1)->D1_LOCAL,),;
											cAliasSD1,,IIf(lForn,.F.,.T.) )

					nSldQtd:= aValor[1]
					nSldQtd2:=ConvUm((cAliasSD1)->D1_COD,nSldQtd,0,2)
					nSldLiq:= aValor[2]
					nSldBru:= nSldLiq+A410Arred(nSldLiq*(cAliasSD1)->D1_VALDESC/((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC),"C6_VALOR")
				Else
					nSldQtd:= (cAliasSD1)->D1_QUANT
					nSldQtd2:=ConvUm((cAliasSD1)->D1_COD,nSldQtd,0,2)
					nSldLiq:= (cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC
					nSldBru:= nSldLiq+A410Arred(nSldLiq*(cAliasSD1)->D1_VALDESC/((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC),"C6_VALOR")
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe saldo                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nSldQtd <> 0

					nCntSD1++
					If nCntSD1 > 900  // No. maximo de Itens 
						Exit
					EndIf

					aAdd(aCols,Array(Len(aHeader)+1))
					For nCntFor := 1 To Len(aHeader)
						cCampo := Alltrim(aHeader[nCntFor,2])

						If ( aHeader[nCntFor,10] # "V" .And. !cCampo$"C6_QTDLIB#C6_RESERVA" ) .and. aHeader[nCntFor,08] != "M"

							Do Case

							Case Alltrim(aHeader[nCntFor][2]) == "C6_ITEM"
								aCols[Len(aCols)][nCntFor] := cItem
							Case Alltrim(aHeader[nCntFor][2]) == "C6_PRODUTO"
								aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_COD								
								SB1->(dbSetOrder(1))
								SB1->(MsSeek(xFilial("SB1")+(cAliasSD1)->D1_COD))
								aCols[Len(aCols)][Ascan(aHeader,{|x| Alltrim(x[2])=="C6_CLASFIS"})] :=  IIf( !Empty(SB1->B1_TS), SB1->B1_TS, SF4->F4_CODIGO ) 
				 				//If ExistTrigger("C6_PRODUTO")
				   			        //		RunTrigger(2,Len(aCols))
							        //	EndIf
							Case Alltrim(aHeader[nCntFor][2]) == "C6_CC"
								aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_CC
							Case Alltrim(aHeader[nCntFor][2]) == "C6_CONTA"
								aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_CONTA
							Case Alltrim(aHeader[nCntFor][2]) == "C6_ITEMCTA"
								aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_ITEMCTA
							Case Alltrim(aHeader[nCntFor][2]) == "C6_CLVL"
								aCols[Len(aCols)][nCntFor] :=(cAliasSD1)->D1_CLVL			
							Case Alltrim(aHeader[nCntFor][2]) == "C6_DESCRI"
								aCols[Len(aCols)][nCntFor] := (cAliasSB1)->B1_DESC
							Case Alltrim(aHeader[nCntFor][2]) == "C6_SEGUM"
								aCols[Len(aCols)][nCntFor] := (cAliasSB1)->B1_SEGUM
							Case Alltrim(aHeader[nCntFor][2]) == "C6_UM"
								aCols[Len(aCols)][nCntFor] := (cAliasSB1)->B1_UM
							Case Alltrim(aHeader[nCntFor][2]) == "C6_UNSVEN"
								aCols[Len(aCols)][nCntFor] := a410Arred(nSldQtd2,"C6_UNSVEN")
							Case Alltrim(aHeader[nCntFor][2]) == "C6_QTDVEN"
								aCols[Len(aCols)][nCntFor] := a410Arred(nSldQtd,"C6_QTDVEN")
							Case Alltrim(aHeader[nCntFor][2]) == "C6_PRCVEN"
								If nTamPrcVen > 2
									aCols[Len(aCols)][nCntFor] := a410Arred(((cAliasSD1)->D1_VUNIT-((cAliasSD1)->D1_VALDESC/(cAliasSD1)->D1_QUANT)),"C6_PRCVEN")
								Else
									aCols[Len(aCols)][nCntFor] := a410Arred(nSldLiq/IIf(nSldQtd==0,1,nSldQtd),"C6_PRCVEN")
								EndIf
							Case Alltrim(aHeader[nCntFor][2]) == "C6_PRUNIT"
								aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_VUNIT
							Case Alltrim(aHeader[nCntFor][2]) == "C6_VALOR"
								If nSldQtd <> (cAliasSD1)->D1_QUANT
									If nTamPrcVen > 2
										aCols[Len(aCols)][nCntFor] := a410Arred(nSldQtd*a410Arred(((cAliasSD1)->D1_VUNIT-((cAliasSD1)->D1_VALDESC/(cAliasSD1)->D1_QUANT)),"C6_PRCVEN"),"C6_VALOR")
									Else
										aCols[Len(aCols)][nCntFor] := a410Arred(nSldQtd*a410Arred(nSldLiq/IIf(nSldQtd==0,1,nSldQtd),"C6_PRCVEN"),"C6_VALOR")
									EndIf
								Else
									aCols[Len(aCols)][nCntFor] := nSldLiq
								EndIf
							Case Alltrim(aHeader[nCntFor][2]) == "C6_VALDESC"
								If (cAliasSD1)->D1_VALDESC>0
									aCols[Len(aCols)][nCntFor] := a410Arred(((cAliasSD1)->D1_VUNIT-a410Arred(nSldLiq/IIf(nSldQtd==0,1,nSldQtd),"C6_PRCVEN"))*a410Arred(nSldQtd,"C6_QTDVEN"),"C6_VALDESC")
								Else
									aCols[Len(aCols)][nCntFor] := 0
								EndIf
							Case Alltrim(aHeader[nCntFor][2]) == "C6_DESCONT"
								If (cAliasSD1)->D1_DESC>0
									aCols[Len(aCols)][nCntFor] :=(cAliasSD1)->D1_DESC
								Else
									aCols[Len(aCols)][nCntFor] := 0
								EndIf
							Case Alltrim(aHeader[nCntFor][2]) == "C6_TES"
								aCols[Len(aCols)][nCntFor] := cCodTES
								SF4->(dbSetOrder(1))
								SF4->(MsSeek(xFilial("SF4")+cCodTES))
								If !Empty(Subs(aCols[Len(aCols)][Ascan(aHeader,{|x| Alltrim(x[2])=="C6_CLASFIS"})],1,1)) .And. !Empty(SF4->F4_SITTRIB) 
									aCols[Len(aCols)][Ascan(aHeader,{|x| Alltrim(x[2])=="C6_CLASFIS"})] :=Subs(aCols[Len(aCols)][Ascan(aHeader,{|x| Alltrim(x[2])=="C6_CLASFIS"})],1,1)+SF4->F4_SITTRIB 								
				 				EndIf
				 				//If ExistTrigger("C6_TES    ")
				   				//	RunTrigger(2,Len(aCols))
								//EndIf
							Case Alltrim(aHeader[nCntFor][2]) == "C6_CF"
								aCols[Len(aCols)][nCntFor] := SF4->F4_CF
							Case Alltrim(aHeader[nCntFor][2]) == "C6_NFORI"
								aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_DOC
							Case Alltrim(aHeader[nCntFor][2]) == "C6_SERIORI"
								aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_SERIE // Deve amarrar pelo ID de controle D1_SERIE sera costrado apenas a serie por causa da picture !!! Manter Projeto Chave Unica.
							Case Alltrim(aHeader[nCntFor][2]) == "C6_ITEMORI" 
								aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_ITEM
							Case Alltrim(aHeader[nCntFor][2]) == "C6_NUMLOTE"
								aCols[Len(aCols)][nCntFor] := IIF(SF4->F4_ESTOQUE == "S",(cAliasSD1)->D1_NUMLOTE ,"")
							Case Alltrim(aHeader[nCntFor][2]) == "C6_LOTECTL"
								aCols[Len(aCols)][nCntFor] := IIF(SF4->F4_ESTOQUE == "S",(cAliasSD1)->D1_LOTECTL ,"")
							Case Alltrim(aHeader[nCntFor][2]) == "C6_LOCAL"
								aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_LOCAL
							Case Alltrim(aHeader[nCntFor][2]) == "C6_IDENTB6"
								aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_IDENTB6
							Case Alltrim(aHeader[nCntFor][2]) == "C6_DTVALID"			
								If SF4->F4_ESTOQUE == "S"
									aCols[Len(aCols)][nCntFor] := (cAliasSD1)->D1_DTVALID
									If SB8->(MsSeek(xFilial("SB8")+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_LOCAL+(cAliasSD1)->D1_LOTECTL+IIf(Rastro((cAliasSD1)->D1_COD,"S"),(cAliasSD1)->D1_NUMLOTE,"")))
										aCols[Len(aCols)][nCntFor] := SB8->B8_DTVALID
									Endif   
								Else
									aCols[Len(aCols)][nCntFor] := CTOD("  /  /  ")
								EndIf
							Case Alltrim(aHeader[nCntFor][2]) == "C6_CLASFIS"
								aCols[Len(aCols)][nCntFor] := SB1->B1_ORIGEM+SF4->F4_SITTRIB
							OtherWise
								aCols[Len(aCols)][nCntFor] := CriaVar(cCampo)
							EndCase
						Else
							If aHeader[nCntFor,08] != "M"
								aCols[Len(aCols)][nCntFor] := CriaVar(cCampo)
							Endif	
						EndIf
					Next nCntFor

					aCols[Len(aCols)][Len(aHeader)+1] := .F.

					If lM410PCDV
						ExecBlock("M410PCDV",.F.,.F.,{cAliasSD1})
					Endif
                
				Else
					MsgStop("Não há saldo em poder de terceiro para atender ao produto: "+(cAliasSD1)->D1_COD )
					lContinua := .F.
					Exit
				Endif

			Endif

			dbSelectArea(cAliasSD1)
			dbSkip()
		EndDo
		If ( lQuery )
			dbSelectArea(cAliasSD1)
			dbCloseArea()
			ChkFile("SC6",.F.)
			dbSelectArea("SC6")
		Else
			If lFornece
				RetIndex( "SD1" )
				FErase( cIndex+OrdBagExt() )
			EndIf
		EndIf

		If (lContinua)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa as variaveis de busca do acols                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			nPosPrc   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
			nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
			nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
			nPQuant   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inici aliza desta forma para criar uma nova instancia de variaveis private³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria Variaveis de Memoria da Enchoice                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SX3")
			DbSetOrder(1)
			DbSeek("SC5")
			While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC5") )
				cCampo := SX3->X3_CAMPO

				If	( SX3->X3_CONTEXT <> "V" ) .and. SX3->X3_TIPO != "M"
					Do Case

					Case Alltrim(cCampo) == "C5_TIPO"

						cTipoPed := "" 

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica o tipo da nota para o retorno do pedido     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Do Case
						Case SF1->F1_TIPO == "N" .And. lPoder3
							cTipoPed := "B" 
						Case SF1->F1_TIPO == "B" .And. lPoder3
							cTipoPed := "N" 
							lBenefPodT := .T.
						EndCase

						If Empty(cTipoPed)
							cTipoPed := "D" 
						Endif

						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),cTipoPed )

					Case Alltrim(cCampo) == "C5_CLIENTE"
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),cFornece)
					Case Alltrim(cCampo) == "C5_LOJACLI"
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),cLoja)
					Case Alltrim(cCampo) == "C5_EMISSAO"
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),dDataBase)
					Case Alltrim(cCampo) == "C5_CONDPAG"
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),SF1->F1_COND)
					Case Alltrim(cCampo) == "C5_CLIENT"
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),cFornece)						
					Case Alltrim(cCampo) == "C5_LOJAENT"
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),cLoja)
					OtherWise
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),CriaVar(SX3->X3_CAMPO))
					EndCase
				Else
					If  SX3->X3_TIPO != "M"
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),CriaVar(SX3->X3_CAMPO))
					Endif	
				Endif

				DbSelectArea("SX3")
				DbSkip()
			EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Busca o tipo do cliente/fornecedor                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If M->C5_TIPO$"DB"
				SA2->(dbSetOrder(1))
				If SA2->(MsSeek(xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI))
					_SetOwnerPrvt("C5_TIPOCLI",If(SA2->A2_TIPO=="J","R",SA2->A2_TIPO))
				EndIf
			Else
				SA1->(dbSetOrder(1))
				If SA1->(MsSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
					_SetOwnerPrvt("C5_TIPOCLI",SA1->A1_TIPO)
				Endif 
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Marca o cliente utilizado para verificar posterior mudanca ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//a410ChgCli(M->C5_CLIENTE+M->C5_LOJACLI)
		Endif

	EndIf
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao ache nenhum item , abandona rotina.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua )
	If ( Len(aCols) == 0 )
		lContinua := .F.
	EndIf
EndIf

aRegSC6 := {}
aRegSCV := {}

/*
If ( lContinua )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o array com as formas de pagamento do SX5³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Ma410MtFor(@aHeadFor,@aColsFor)
	A410ReCalc(.F.,lBenefPodT)	

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz o calculo automatico de dimensoes de objetos     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize := MsAdvSize()
		aObjects := {}
		aAdd( aObjects, { 100, 100, .t., .t. } )
		aAdd( aObjects, { 100, 100, .t., .t. } )
		aAdd( aObjects, { 100, 015, .t., .f. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
		nGetLin := aPosObj[3,1]

		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Armazenar dados do Pedido anterior.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF M->C5_TIPO $ "DB"
			aTrocaF3 := {{"C5_CLIENTE","SA2"}}
		Else
			aTrocaF3 := {}
		EndIf
		oGetPV:=MSMGet():New( "SC5", nReg, 3, , , , , aPosObj[1],,3,,,"A415VldTOk",,,.T.)
		A410Limpa(.F.,M->C5_TIPO)
//		@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->C5_TIPO$"DB",STR0008,STR0009)) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!"	OF oDlg PIXEL
		@ nGetLin,aPosGet[1,3]  SAY OemToAnsi(STR0011)						SIZE 020,09 OF oDlg PIXEL	//"Total :"
		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,Iif(cPaisloc=="CHI",NIL,nNumDec))	SIZE 050,09 OF oDlg PIXEL		
		@ nGetLin,aPosGet[1,5]  SAY OemToAnsi(STR0012)						SIZE 030,09 OF oDlg PIXEL 	//"Desc. :"
		@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,Iif(cPaisloc=="CHI",NIL,nNumDec))		SIZE 050,09 OF oDlg PIXEL RIGHT
		@ nGetLin+10,aPosGet[1,5]  SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
		If cPaisLoc == "BRA"				
			@ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,2) OF oDlg PIXEL RIGHT
		Else
			@ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,Iif(cPaisloc=="CHI",NIL,nNumDec)) OF oDlg PIXEL RIGHT
		EndIf
		oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
			oSay2:SetText(n2),;
			oSay3:SetText(n3),;
			oSay4:SetText(n4) }
		Set Key VK_F4 to A440Stok(NIL,"A410")
		oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],3,"A410LinOk","A410TudOk","+C6_ITEM/C6_Local/C6_TES/C6_CF/C6_PEDCLI",.T.,,1,,ITENSSC6*IIF(MaGrade(),1,3.33),"A410Blq()")
		Private oGetDad:=oGetd
		A410Bonus(2)
		Ma410Rodap(oGetD,nTotalPed,nTotalDes)
		ACTIVATE MSDIALOG oDlg ON INIT Ma410Bar(oDlg,{||nOpcA:=1,if(A410VldTOk(nOpc).And.oGetd:TudoOk(),If(!obrigatorio(aGets,aTela),nOpcA := 0,oDlg:End()),nOpcA := 0)},{||oDlg:End()},nOpc,oGetD,nTotalPed,@aRecnoSE1RA,@aHeadAGG,@aColsAGG)
		SetKey(VK_F4,)
	EndIf
	If ( nOpcA == 1 )
		A410Bonus(1)
		If a410Trava()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoIniLan("000100")
			If !A410Grava(lLiber,lTransf,2,aHeadFor,aColsFor,aRegSC6,aRegSCV,,,aRecnoSE1RA,aHeadAGG,aColsAGG)
				Help(" ",1,"A410NAOREG")
			EndIf
			If ( (ExistBlock("M410STTS") ) )
				ExecBlock("M410STTS",.f.,.f.)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoFinLan("000100")
		EndIf
	Else
		While GetSX8Len() > nStack
			RollBackSX8()
		EndDo
		If ( (ExistBlock("M410ABN")) )
			ExecBlock("M410ABN",.f.,.f.)
		EndIf
	EndIf
Else
	While GetSX8Len() > nStack
		RollBackSX8()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Limpa cliente anterior para proximo pedido                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
a410ChgCli("")
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Destrava Todos os Registros                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsUnLockAll()

If lContinua

	cGetForn := SF1->F1_FORNECE
	oGetForn:Refresh()

	cGetLjForn := SF1->F1_LOJA
	oGetLjForn:Refresh()

	cDescForn := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")
	oDescForn:Refresh()

	cGetNFEnt := SF1->F1_DOC
	oGetNFEnt:Refresh()
	
	cGetNFSer := SF1->F1_SERIE	
	oGetNFSer:Refresh()
	
	// zera dados relacionados a operacao de venda ou transferencia
	aProdMark := {}
	
Endif
	
RestArea(aAreaSX3)
RestArea(aAreaSF1)
RestArea(aAreaSD1)
RestArea(aAreaSB8)
RestArea(aArea)

Return( nOpcA )                


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³a410SNfOri³ Autor ³Eduardo Riera          ³ Data ³01.03.99  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula o Saldo da Nota Original informada.                 ³±±
±±³          ³Calcula o Saldo do poder de terceiros.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpN1: Quantidade ja utilizada                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Cliente/Fornecedor                                   ³±±
±±³          ³ExpC2: Loja                                                 ³±±
±±³          ³ExpC3: Nota Fiscal Original                                 ³±±
±±³          ³ExpC4: Serie Original                                       ³±±
±±³          ³ExpC5: Item da Nota Original                                ³±±
±±³          ³ExpC6: Codigo do Produto                                    ³±±
±±³          ³ExpC7: Identificador do Poder de Terceiro                   ³±±
±±³          ³ExpC8: Local Padrao                                         ³±±
±±³          ³ExpC7: Alias do SD1                                    (OPC)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//_A410SNfOri(cCliFor,cLoja,SD1->D1_DOC,SD1->D1_SERIE,"",SD1->D1_COD,(cAliasTRB)->B6_IDENT,aCols[n][nPosLocal])[1]
Static Function _A410SNfOri(cCliFor,cLoja,cNfOri,cSerOri,cItemOri,cProduto,cIdentB6,cLocal,cAliasSD1,aPedido,l410ProcDv)

Local aArea 	:= GetArea()
Local aAreaSD1	:= SD1->(GetArea())
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())
Local aAreaSB6	:= SB6->(GetArea())
Local aStruSC6  := {}
Local aCq       := {}
Local aRetCq    := {}
Local nX        := 0
Local nQuant	:= 0
Local nValor    := 0
Local nPQtdVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"  .Or. AllTrim(x[2])=="D2_QUANT"})
Local nPPrcVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"  .Or. AllTrim(x[2])=="D2_PRCVEN"})
Local nPNfOri 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"   .Or. AllTrim(x[2])=="D2_NFORI"})
Local nPSerOri	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI" .Or. AllTrim(x[2])=="D2_SERIORI"})
Local nPItemOri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI" .Or. AllTrim(x[2])=="D2_ITEMORI"})
Local nPIdentb6 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_IDENTB6" .Or. AllTrim(x[2])=="D2_IDENTB6"})
Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"     .Or. AllTrim(x[2])=="D2_TES"})
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" .Or. AllTrim(x[2])=="D2_COD"})
Local nPLote    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE" .Or. AllTrim(x[2])=="D2_NUMLOTE"})
Local nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"   .Or. AllTrim(x[2])=="D2_LOCAL"})
Local nUsado	:= 0
Local nCntFor	:= 0
Local cCq       := SuperGetMv("MV_CQ")
Local cQuery    := ""
Local cAliasSC6 := "SC6"
Local lQuery    := .F.
Local aSaldoCQ  := {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Local nQtdCols  := 0
Local nQtdPed   := 0

DEFAULT aPedido   := {}
DEFAULT cIdentB6  := CriaVar("C6_IDENTB6",.F.)
DEFAULT cAliasSD1 := "SD1"
DEFAULT l410ProcDv:= .F.	//Se for .T., está vindo da rotina de "Retornar" do pedido de vendas (Função: A410ProcDv)

If Type("M->C5_NUM") == "U"
	M->C5_NUM := ""
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para devolucao                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  ( !Empty(cItemOri) )
	dbSelectArea("SD1")
	dbSetOrder(1)
	If ( xFilial("SD1")+cNfOri+cSerOri+cCliFor+cLoja+cProduto+cItemOri == ;
			(cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEM .Or. ;
			MsSeek(xFilial("SD1")+cNfOri+cSerOri+cCliFor+cLoja+cProduto+cItemOri) )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica quantidade ja faturada independente da TES                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nQuant += (cAliasSD1)->D1_QUANT
		nQuant -= (cAliasSD1)->D1_QTDEDEV
		nValor += (cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC
		nValor -= (cAliasSD1)->D1_VALDEV
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica quantidade no CQ                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD1)->D1_LOCAL == cCQ
			If __lPyme
				aCQ := fLibRejCQ((cAliasSD1)->D1_COD,(cAliasSD1)->D1_DOC,(cAliasSD1)->D1_SERIE,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,Nil,(cAliasSD1)->D1_ITEM)
			Else
				aCQ := fLibRejCQ((cAliasSD1)->D1_COD,(cAliasSD1)->D1_DOC,(cAliasSD1)->D1_SERIE,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,(cAliasSD1)->D1_NUMLOTE,(cAliasSD1)->D1_ITEM)				
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica a quantidade em  Pedido de Venda                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC6")
		dbSetOrder(5)
		#IFDEF TOP
			lQuery := .T.
			cAliasSC6 := "A410SNFORI"
			aStruSC6  := SC6->(dbStruct())
			cQuery := "SELECT SC6.C6_FILIAL,SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_PRODUTO,"
			cQuery += "SC6.C6_NFORI,SC6.C6_SERIORI,SC6.C6_ITEMORI,SC6.C6_NUM,"
			cQuery += "SC6.C6_QTDVEN,SC6.C6_QTDENT,SC6.C6_QTDEMP,SC6.C6_PRCVEN,"
			cQuery += "SC6.C6_NOTA "
			cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
			cQuery += "WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
			cQuery += "SC6.C6_CLI='"+cCliFor+"' AND "
			cQuery += "SC6.C6_LOJA='"+cLoja+"' AND "
			cQuery += "SC6.C6_PRODUTO='"+cProduto+"' AND "
			cQuery += "SC6.C6_NFORI='"+cNfOri+"' AND "
			cQuery += "SC6.C6_SERIORI='"+cSerOri+"' AND "
			cQuery += "SC6.C6_ITEMORI='"+cItemOri+"' AND "
			cQuery += "SC6.C6_BLQ <> 'R' AND "
			cQuery += "SC6.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)
			
			For nX := 1 To Len(aStruSC6)
				If FieldPos(aStruSC6[nX][1])<>0 .And. aStruSC6[nX][2]<>"C"
					TcSetField(cAliasSC6,aStruSC6[nX][1],aStruSC6[nX][2],aStruSC6[nX][3],aStruSC6[nX][4])
				EndIf
			Next nX
			
		#ELSE
			MsSeek(xFilial("SC6")+cCliFor+cLoja+cProduto+cNfOri+cSerOri+cItemOri)
		#ENDIF
		While ( !Eof() .And. xFilial("SC6") == (cAliasSC6)->C6_FILIAL .And.;
				cCliFor == (cAliasSC6)->C6_CLI .And.;
				cLoja == (cAliasSC6)->C6_LOJA .And.;
				cProduto == (cAliasSC6)->C6_PRODUTO .And.;
				cNfOri == (cAliasSC6)->C6_NFORI .And.;
				cSerOri == (cAliasSC6)->C6_SERIORI .And.;
				cItemOri == (cAliasSC6)->C6_ITEMORI )
			If ( M->C5_NUM != (cAliasSC6)->C6_NUM )			
				If aScan(aPedido,{|x| x == (cAliasSC6)->C6_NUM}) == 0  .And. (Max((cAliasSC6)->C6_QTDVEN,(cAliasSC6)->C6_QTDEMP)-(cAliasSC6)->C6_QTDENT) > 0
					aAdd(aPedido,(cAliasSC6)->C6_NUM)
				EndIf
				nQuant -= (Max((cAliasSC6)->C6_QTDVEN,(cAliasSC6)->C6_QTDEMP)-(cAliasSC6)->C6_QTDENT)
				nValor -= (cAliasSC6)->C6_PRCVEN*Max((Max((cAliasSC6)->C6_QTDVEN,(cAliasSC6)->C6_QTDEMP)-(cAliasSC6)->C6_QTDENT),IIf(Empty((cAliasSC6)->C6_NOTA).And.(cAliasSC6)->C6_QTDVEN==0,1,0))
			Else
				nQuant += (cAliasSC6)->C6_QTDENT
				nValor += (cAliasSC6)->C6_PRCVEN*Max((cAliasSC6)->C6_QTDENT,IIf(Empty((cAliasSC6)->C6_NOTA).And.(cAliasSC6)->C6_QTDVEN==0,1,0))
			EndIf
			dbSelectArea(cAliasSC6)
			dbSkip()
		EndDo
		If lQuery
			dbSelectArea(cAliasSC6)
			dbCloseArea()
			dbSelectArea("SC6")
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica a quantidade no Pedido Atual                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nUsado := Len(aHeader)
		For nCntFor := 1  To Len(aCols)
			If ( !aCols[nCntFor][nUsado+1] .And. nPNfOri != 0 .And.;
					nPSerOri!= 0 .And.;
					nPItemOri!=0 .And. n <> nCntFor)
				If ( aCols[nCntFor][nPNfOri] 		== cNfOri .And.;
						aCols[nCntFor][nPSerOri]	== cSerOri .And.;
						aCols[nCntFor][nPItemOri]	== cItemOri )
					nQuant -= aCols[nCntFor][nPQtdVen]
					nValor -= aCols[nCntFor][nPPrcVen]*aCols[nCntFor][nPQtdVen]
				EndIf
			EndIf
		Next nCntFor
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para  Poder de Terceiros - nao se deve verificar F4_ESTOQUE  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o Saldo do Poder de Terceiro no SB6 com identificador          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nQuant := 0
	nValor := 0
	dbSelectArea("SB6")
	dbSetOrder(3)
	If ( MsSeek(xFilial("SB6")+cIdentB6+cProduto+"R",.F.) )
		nQuant := SB6->B6_SALDO - SB6->B6_QULIB
		nValor := ( nQuant * SB6->B6_PRUNIT )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica a quantidade em  Pedido de Venda                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC6")
		dbSetOrder(5)
		If ( MsSeek(xFilial("SC6")+cCliFor+cLoja+cProduto+cNfOri+cSerOri) )
			While ( !Eof() .And. xFilial("SC6")	== SC6->C6_FILIAL .And.;
					cCliFor			== SC6->C6_CLI		.And.;
					cLoja				== SC6->C6_LOJA	.And.;
					cProduto			== SC6->C6_PRODUTO.And.;
					cNfOri			== SC6->C6_NFORI	.And.;
					cSerOri			== SC6->C6_SERIORI )
				If  ( cIdentB6 ==  SC6->C6_IDENTB6 )
					dbSelectArea("SF4")
					dbSetOrder(1)
					If ( MsSeek(xFilial("SF4")+SC6->C6_TES) )
						If ( SF4->F4_PODER3 == "D" )
							If ( M->C5_NUM != SC6->C6_NUM )
								If aScan(aPedido,{|x| x == (cAliasSC6)->C6_NUM}) == 0 .And.  (Max((cAliasSC6)->C6_QTDVEN,(cAliasSC6)->C6_QTDEMP)-(cAliasSC6)->C6_QTDENT) > 0
									aAdd(aPedido,(cAliasSC6)->C6_NUM)
								EndIf
								nQuant -= (If(SC6->C6_QTDEMP>0,0,SC6->C6_QTDVEN)-SC6->C6_QTDENT)
								nValor -= ((If(SC6->C6_QTDEMP>0,0,SC6->C6_QTDVEN)-SC6->C6_QTDENT)*SB6->B6_PRUNIT)
								nQtdPed += SC6->C6_QTDVEN
							Else
								nQuant += SC6->C6_QTDENT
								nQuant += SC6->C6_QTDEMP
								nValor += ((SC6->C6_QTDENT)*SB6->B6_PRUNIT)
								nValor += ((SC6->C6_QTDEMP)*SB6->B6_PRUNIT)
								nQtdPed += If(SC6->C6_QTDENT>0,SC6->C6_QTDVEN-SC6->C6_QTDENT,0)
							EndIf
						EndIf
					EndIf
				EndIf
				dbSelectArea("SC6")
				dbSkip()
			EndDo
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica a quantidade no Pedido Atual                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nUsado := Len(aHeader)
		For nCntFor := 1  To Len(aCols)
			If ( !aCols[nCntFor][nUsado+1] .And. nPIdentB6 != 0 )
				If ( aCols[nCntFor][nPIdentB6] == cIdentB6 ) .And. cProduto == aCols[nCntFor][nPProduto]
					dbSelectArea("SF4")
					dbSetOrder(1)
					If ( MsSeek(xFilial("SF4")+aCols[nCntFor][nPTes])  )
						If ( SF4->F4_PODER3 == "D" )
							nQuant -= aCols[nCntFor][nPQtdVen]
							nValor += aCols[nCntFor][nPQtdVen]*SB6->B6_PRUNIT
							nQtdCols += aCols[nCntFor][nPQtdVen]
						EndIf
					EndIf
				EndIf
			EndIf
		Next nCntFor
		dbSelectArea("SD1")
		dbSetOrder(4)
		If MsSeek(xFilial("SD1")+SB6->B6_IDENT)
			aSaldoCQ := A175CalcQt(SD1->D1_NUMCQ, SB6->B6_PRODUTO, SB6->B6_LOCAL)
		Endif	
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Nao ha como otimizar o codigo pois pode haver poder de terceiro         ³
		//³gravados c/ identificador ou nao, assim somente eh possivel calcular  o ³
		//³saldo verificando  todas os  pedidos deste  cliente  com este  produto  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB6")
		dbSetOrder(2)
		MsSeek(xFilial("SB6")+cProduto+cCliFor+cLoja+"R")
		While ( !Eof() .And.	xFilial("SB6")	==	SB6->B6_FILIAL .And.;
				cProduto			== SB6->B6_PRODUTO .And.;
				cCliFor			== SB6->B6_CLIFOR .And.;
				cLoja			 	== SB6->B6_LOJA .And.;
				"R"				==	SB6->B6_PODER3 )
			If !(	( M->C5_TIPO == "B" .And. SB6->B6_TPCF != "F") .Or.;
					( M->C5_TIPO == "N" .And. SB6->B6_TPCF != "C") )
				nQuant += ( SB6->B6_SALDO - SB6->B6_QULIB )
				nValor += ( SB6->B6_SALDO - SB6->B6_QULIB )*SB6->B6_PRUNIT
			EndIf
			dbSelectArea("SB6")
			dbSkip()
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica a quantidade em Pedido de Venda                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC6")
		dbSetOrder(5)
		If ( MsSeek(xFilial("SC6")+cCliFor+cLoja+cProduto) )
			While ( !Eof() .And. xFilial("SC6")	== SC6->C6_FILIAL .And.;
					cCliFor	== SC6->C6_CLI	.And.;
					cLoja == SC6->C6_LOJA	.And.;
					cProduto == SC6->C6_PRODUTO )
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(xFilial("SF4")+SC6->C6_TES)
				If ( SF4->F4_PODER3 == "D" )
					If ( M->C5_NUM != SC6->C6_NUM )
						nQuant -= (SC6->C6_QTDVEN-SC6->C6_QTDENT)
						nValor -= IIf(Empty(SC6->C6_NOTA).And.SC6->C6_QTDVEN==0,1,SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN
					Else
						nQuant += SC6->C6_QTDENT
						nValor += IIf(Empty(SC6->C6_NOTA).And.SC6->C6_QTDVEN==0,1,SC6->C6_QTDENT)*SC6->C6_PRCVEN
					EndIf
				EndIf
				dbSelectArea("SC6")
				dbSkip()
			EndDo
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica a quantidade no Pedido Atual                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nUsado := Len(aHeader)
		For nCntFor := 1  To Len(aCols)
			If ( !aCols[nCntFor][nUsado+1] .And. nPIdentB6 != 0 )
				dbSelectArea("SF4")
				dbSetOrder(1)
				If ( MsSeek(xFilial("SF4")+aCols[nCntFor][nPTes])  )
					If ( SF4->F4_PODER3 == "D"  )
						nQuant -= aCols[nCntFor][nPQtdVen]
						nValor -= IIf(Empty(SC6->C6_NOTA).And.SC6->C6_QTDVEN==0,1,aCols[nCntFor][nPQtdVen])*aCols[nCntFor][nPPrcVen]
						nQtdCols += aCols[nCntFor][nPQtdVen]
					EndIf
				EndIf
			EndIf
		Next nCntFor
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara o array com os dados do controle de qualidade                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCntFor := 1  To Len(aCq)
	If aCq[nCntFor,1] > 0 	.And. aCq[nCntFor,2] > 0
		AADD(aRetCq,{aCq[nCntFor,2],ConvUm(cProduto,aCq[nCntFor,2],0,2),aCq[nCntFor,3]})
	EndIf
Next nCntFor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a entrada da rotina                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSB6)
RestArea(aAreaSF4)
RestArea(aAreaSC6)
RestArea(aAreaSD1)
RestArea(aArea)

Return({NoRound(nQuant,TamSX3("C6_QTDVEN")[2]),IIf(!l410ProcDv,a410Arred(nValor,"C6_VALOR"),nValor),If(Len(aRetCq)>0,aRetCq,""),aSaldoCQ,nQtdCols,nQtdPed})


//------------------------------------------------------
// Valida o fornecedor
//------------------------------------------------------
static function valForn(cGetForn,cGetLjForn,cDescForn,oDescForn)
	local cQrySA2 := ""
	local lRet		:= .T.

	cQrySA2 := "SELECT A2_COD, A2_NOME"									+ CRLF
	cQrySA2 += " FROM " + retSQLName("SA2") + " SA2"						+ CRLF
	cQrySA2 += " WHERE"														+ CRLF
	cQrySA2 += " 		SA2.A2_COD			=	'" + cGetForn		+ "'"	+ CRLF
	If !Empty(cGetLjForn)
		cQrySA2 += " 	AND SA2.A2_LOJA			=	'" + cGetLjForn		+ "'"	+ CRLF
	Endif	
	cQrySA2 += " 	AND	SA2.A2_FILIAL		=	'" + xFilial("SA2")	+ "'"	+ CRLF
	cQrySA2 += " 	AND	SA2.D_E_L_E_T_	<>	'*'"							+ CRLF

	TcQuery ChangeQuery(cQrySA2) New Alias "QRYSA2"

	if !QRYSA2->(EOF())
		cDescForn := QRYSA2->A2_NOME
		oDescForn:refresh()
	else
		msgAlert("Código do Fornecedor informado não existe no cadastro.")
		lRet := .F.
	endif

	QRYSA2->(DBCloseArea())
return lRet


//------------------------------------------------------
// Tratamento para 'salvar' os registros marcados pelo usuario
//------------------------------------------------------
Static Function LoadP3Prod()
	local nI			:= 0
	local nJ			:= 0
	local aProdBKP	:= {}
	local nTamSD1		:= (tamSx3("D1_FILIAL")[1] + tamSx3("D1_DOC")[1] + tamSx3("D1_SERIE")[1] + tamSx3("D1_FORNECE")[1] + tamSx3("D1_LOJA")[1] + tamSx3("D1_ITEM")[1])

	aProdBKP	:= aClone(aProd)
	aProd		:= {}

	fwMsgRun(, {|oSay| GetP3Prod( oSay )}, "Verificando produtos", "Aguarde. Selecionando produtos em estoque..." )

	while !QRYSB2->(EOF())
		//aadd(aProd, {.F., QRYSB2->B2_LOCALIZ, QRYSB2->B2_COD, QRYSB2->B1_DESC, QRYSB2->B1_UM, QRYSB2->B1_TIPO, QRYSB2->B1_GRUPO, QRYSB2->B8_LOTECTL, dToC(sToD(QRYSB2->B8_DTVALID)), QRYSB2->SALDO, 0, space(nTamSD1)})
		aadd(aProd, {.F., QRYSB2->DOCUMENTO, QRYSB2->PRODUTO, QRYSB2->DESCRI, QRYSB2->UM, QRYSB2->TIPO, QRYSB2->GRUPO, QRYSB2->LOTE, STOD(QRYSB2->VALIDADE), QRYSB2->SALDO, QRYSB2->SALDO, QRYSB2->IDENTB6, QRYSB2->SERIE, QRYSB2->ITEM, QRYSB2->VUNIT, QRYSB2->D1_TOTAL, QRYSB2->D1_QUANT })
		QRYSB2->(DBSkip())
	enddo

	QRYSB2->(DBCloseArea())

	// refaz marcação do usuario
	if cGetCdArma == cCodArmBKP
		for nI := 1 to len(aProdMark)
			for nJ := 1 to len(aProd)
				if aProdMark[nI, 3] == aProd[nJ, 3]
					aProd[nJ, 1]	:= .T.
					//aProd[nJ, 11]	:= aProdMark[nI, 11]
					aProd[nJ, 11]	:= aProdMark[nI, 11]
					exit
				endif
			next
		next
	endif

	aProdMark	:= {}
	cCodArmBKP	:= cGetCdArma

	if !empty(aProd)
		MarkP3Prod()

		cGetForn := cFornece
		oGetForn:Refresh()

		cGetLjForn := cLoja
		oGetLjForn:Refresh()

		cDescForn := Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_NOME")
		oDescForn:Refresh()
	else
		msgAlert("Não foram encontrados produtos disponíveis neste armazém.")
	endif
	
	// zera dados relacionados a operacao de remessa e retorno
	cGetForn := space(tamSx3("A2_COD")[1])
	oGetForn:Refresh()
	
	cGetLjForn := space(tamSx3("A2_LOJA")[1])
	oGetLjForn:Refresh()

	cDescForn:= space(tamSx3("A2_NOME")[1])
	oDescForn:Refresh()
	
	cGetNFEnt := space(tamSx3("F1_DOC")[1])
	oGetNFEnt:Refresh()
	
	cGetNFSer := space(tamSx3("F1_SERIE")[1])
	oGetNFSer:Refresh()
	
	aHeader := {}
	aCols := {}
	
return

//------------------------------------------------------
// Seleciona produtos em estoque 
//------------------------------------------------------
Static function GetP3Prod(oSay)
	local lConsPrev	:= if( SuperGetMV( 'MV_QTDPREV', .F., 'N' ) == 'S', .T., .F. )
	local cQrySB2		:= ""

	oSay:cCaption := ("Selecionando produtos a retornar ")// + cGetCdArma)

	cQrySB2 += "SELECT B6_DOC DOCUMENTO, B6_PRODUTO PRODUTO, B1_DESC DESCRI, B1_TIPO TIPO, B1_UM UM, B1_GRUPO GRUPO, B6_SALDO SALDO, "	+ CRLF
	cQrySB2 += "	D1_LOTECTL LOTE, D1_DTVALID VALIDADE, B6_IDENT IDENTB6, B6_SERIE SERIE, D1_ITEM ITEM, D1_VUNIT VUNIT, D1_TOTAL, D1_QUANT "	+ CRLF
	cQrySB2 += "FROM " + RetSQLName("SB6") + " SB6"						+ CRLF
	cQrySB2 += "INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' "	+ CRLF
	cQrySB2 += "	AND B1_FILIAL = '"+xFilial("SB1")+"' "	+ CRLF
	cQrySB2 += "	AND B1_COD = B6_PRODUTO "	+ CRLF
	cQrySB2 += "INNER JOIN " + RetSQLName("SD1") + " SD1 ON SD1.D_E_L_E_T_ = '' "	+ CRLF
	cQrySB2 += "	AND D1_FILIAL = '"+xFilial("SD1")+"' "	+ CRLF
	cQrySB2 += "	AND D1_IDENTB6 = B6_IDENT "	+ CRLF
	cQrySB2 += "WHERE SB6.D_E_L_E_T_ = '' "	+ CRLF
	cQrySB2 += " 	AND	B6_FILIAL =	'" + xFilial("SBF")	+ "' "	+ CRLF
	cQrySB2 += "	AND B6_CLIFOR = '" + cFornece + "' "	+ CRLF
	cQrySB2 += "	AND B6_LOJA = '" + cLoja + "' "	+ CRLF
	cQrySB2 += "	AND B6_EMISSAO BETWEEN '" + DtoS(dDataDe)  + "' AND '" + DtoS(dDataAte) + "' "	+ CRLF
	cQrySB2 += "	AND B6_SALDO > 0 "	+ CRLF
	cQrySB2 += "	AND B6_TES < '500' "	+ CRLF
	cQrySB2 += "	AND B6_LOCAL = '" + cGetCdArma + "' "	+ CRLF
	cQrySB2 += "ORDER BY DOCUMENTO, PRODUTO, VALIDADE, LOTE "	+ CRLF

	memoWrite("C:\TEMP\" + funName() + ".sql", cQrySB2)

	TcQuery ChangeQuery(cQrySB2) New Alias "QRYSB2"

return

//------------------------------------------------------
// Marca os produtos para retorno (P3) 
//------------------------------------------------------
Static Function MarkP3Prod()
	local aSeek		:= {}
	local oDlgProd	:= nil
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	local bMark		:= { || iif(aProd[oMark:nAt][1], 'LBOK', 'LBNO')			}
	local bDblClick	:= { || clickMark(oMark, aProd)								}
	local bMarkAll	:= { || markAll(oMark, aProd)								}
	local bOk			:= { || retMark(oMark, aProd, aProdMark), iif( chkNFOrig(), oDlgProd:end(), ) 	}
	local bClose		:= { || iif( chkNFOrig(), oDlgProd:end(), ) }
	local nTamSD1		:= (tamSx3("D1_FILIAL")[1] + tamSx3("D1_DOC")[1] + tamSx3("D1_SERIE")[1] + tamSx3("D1_FORNECE")[1] + tamSx3("D1_LOJA")[1] + tamSx3("D1_COD")[1] + tamSx3("D1_ITEM")[1])

	private nQtdeSolic	:= 0
	private cNFOri		:= space(nTamSD1)

	//Pesquisa que sera exibido
	aadd(aSeek,{"Código"		, { {"","C",tamSx3("B1_COD")[1],0,"Codigo"		,,} }})
	aadd(aSeek,{"Descrição"	, { {"","C",tamSx3("B1_DESC")[1],0,"Descricao"	,,} }})

	//-------------------------------------------------------------
	// Tela de seleção da Oportunidade
	//-------------------------------------------------------------

	DEFINE MSDIALOG oDlgProd TITLE 'Automação de Transferências / Retorno do CD' FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL STYLE DS_MODALFRAME
		oMark := fwBrowse():New()
		oMark:setDataArray()
		oMark:setArray(aProd)
		oMark:disableConfig()
		oMark:disableReport()
		oMark:setOwner(oDlgProd)
		oMark:setSeek(, aSeek)

/*
		SetSeek
		Habilita a utilização da pesquisa de registros no Browse
		
		@param   bAction Code-Block executado para a pesquisa de registros, caso não seja informado será utilizado o padrão
		@param   aOrder  Estrutura do array
						[n,1] Título da pesquisa
						[n,2,n,1] LookUp
						[n,2,n,2] Tipo de dados
						[n,2,n,3] Tamanho
						[n,2,n,4] Decimal
						[n,2,n,5] Título do campo
						[n,2,n,6] Máscara
						[n,2,n,7] Nome Fisico do campo - Opcional - é ajustado no programa
						[n,3] Ordem da pesquisa
						[n,4] Exibe na pesquisa 
*/

		oMark:addMarkColumns(bMark, bDblClick, bMarkAll) 

		oMark:addColumn({"Documento"		, {||aProd[oMark:nAt,2]}		, "C", pesqPict("SB6","B6_DOC")		, 1, tamSx3("B6_DOC")[1]	,, .F.})
		oMark:addColumn({"Código"			, {||aProd[oMark:nAt,3]}		, "C", pesqPict("SB1","B1_COD")		, 1, (tamSx3("B1_COD")[1]*2)	,, .F.})
		oMark:addColumn({"Descrição"		, {||aProd[oMark:nAt,4]}		, "C", pesqPict("SB1","B1_DESC")	, 1, tamSx3("B1_DESC")[1]		,, .F.})
		oMark:addColumn({"Un"				, {||aProd[oMark:nAt,5]}		, "C", pesqPict("SB1","B1_UM")		, 1, tamSx3("B1_UM")[1]			,, .F.})
		oMark:addColumn({"Tipo"				, {||aProd[oMark:nAt,6]}		, "C", pesqPict("SB1","B1_TIPO")	, 1, tamSx3("B1_TIPO")[1]		,, .F.})
		oMark:addColumn({"Grupo"			, {||aProd[oMark:nAt,7]}		, "C", pesqPict("SB1","B1_GRUPO")	, 1, tamSx3("B1_GRUPO")[1]		,, .F.})
		oMark:addColumn({"Lote"				, {||aProd[oMark:nAt,8]}		, "C", pesqPict("SB8","B8_LOTECTL")	, 1, tamSx3("B8_LOTECTL")[1]	,, .F.})
		oMark:addColumn({"Validade"			, {||aProd[oMark:nAt,9]}		, "C", pesqPict("SB8","B8_DTVALID")	, 1, tamSx3("B8_DTVALID")[1]	,, .F.})
		oMark:addColumn({"Qtde Disponível"	, {||aProd[oMark:nAt,10]} 		, "N", pesqPict("SB2","B2_QATU")	, 2, tamSx3("B2_QATU")[1]		,, .F.})

		oMark:addColumn({"Qtde Solicitada"	, {||aProd[oMark:nAt,11]}	, "N", pesqPict("SB2","B2_QATU")	, 2	, tamSx3("B2_QATU")[1]		,2,	 .T.,, .F.,, "nQtdeSolic",, .F., .T.,})
		
		oMark:setEditCell(.T., {|| u_valFields() })
		/*
		Sintaxe
		FWBrowse(): SetEditCell ( [ lEditCell], [ bValidEdit] ) -->

		Parâmetros
		Nome		Tipo	Descrição	Obrigatório	Referência
		lEditCell	Lógico	Indica se permite a edição de células.	 	 
		bValidEdit	Bloco de código	Code-Block executado para validar a edição da célula.
		*/
		//oMark:addColumn({"NF Origem"		, {||aProd[oMark:nAt,11]}	, "C", "@!"							, 1	, nTamSD1						,,	 .T.,, .F.,, "cNFOri"		,, .F., .T.,})

		//oMark:setEditCell(.T., {|| u_valFields() })

		//oMark:aColumns[11]:XF3 := 'XSD1'

/* add(Column
[n][01] Título da coluna
[n][02] Code-Block de carga dos dados
[n][03] Tipo de dados
[n][04] Máscara
[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
[n][06] Tamanho
[n][07] Decimal
[n][08] Indica se permite a edição
[n][09] Code-Block de validação da coluna após a edição
[n][10] Indica se exibe imagem
[n][11] Code-Block de execução do duplo clique
[n][12] Variável a ser utilizada na edição (ReadVar)
[n][13] Code-Block de execução do clique no header
[n][14] Indica se a coluna está deletada
[n][15] Indica se a coluna será exibida nos detalhes do Browse
[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
[n][17] Id da coluna
[n][18] Indica se a coluna é virtual
*/

		oMark:activate(.T.)

		enchoiceBar(oDlgProd, bOk , bClose)
	ACTIVATE MSDIALOG oDlgProd CENTER

Return

//------------------------------------------------------
// Valida NFE já enviada (remessa gravada em Z5_NFREMOR)
//------------------------------------------------------
User Function MGFEST24()

Local cQrySZ5 := ""
Local lRet		:= .F.

cQrySZ5 := "SELECT Z5_NFREMOR "	+ CRLF
cQrySZ5 += "FROM " + retSQLName("SZ5") + " SZ5"						+ CRLF
cQrySZ5 += "WHERE SZ5.D_E_L_E_T_ = ' ' "														+ CRLF
cQrySZ5 += " 	AND	SZ5.Z5_FILIAL = '" + xFilial("SZ5")	+ "' "	+ CRLF
cQrySZ5 += "	AND SZ5.Z5_NFREMOR = '" + SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA	+ "' " + CRLF

TcQuery ChangeQuery(cQrySZ5) New Alias "SZ5NFE"

If !SZ5NFE->(EOF())
	lRet := .T.
Endif

DbSelectArea("SZ5NFE")
DBCloseArea()

DbSelectArea("SF1")

Return lRet


// tela para tratar a geracao da nota de saida na rotina de automacao de venda
User Function Est01GerNfs()

Local aArea		:= GetArea()
//Local aIndex 	:= {} 
//Local cFiltro 	:= "Empty(Z5_NUMNF) .or. Empty(Z5_NUMNFEN)"
Local aCores    := {}

Private aRotina := {	{ "Pesquisar" 						, "PesqBrw" 		, 0 , 1 },; 
						{ "Visualizar" 						, "AxVisual" 		, 0 , 2 },; 
						{ "Visualizar Pedido de Venda" 		, "U_Est01PVVis"	, 0 , 2 },; 
						{ "Gerar NF Saída Origem" 			, "U_Est01NFSGer"	, 0 , 4 },; 
						{ "Gerar Pré-NF Entrada Destino"	, "U_Est01NFEGer"	, 0 , 4 },;
						{ "Legenda"							, "U_Est01Legend"	, 0 , 1 }}

//Private bFiltraBrw 	:= { || FilBrowse( "SZ5" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro 
Private cCadastro 	:= "Automação de Venda - Gerar Nota de Saída e Pré-Nota de Entrada" 

//Eval( bFiltraBrw )

aAdd(aCores,    { 'Empty(Z5_NUMNF) .and. Empty(Z5_NUMNFEN)'    	, 'ENABLE'})
//aAdd(aCores,    { 'Empty(Z5_NUMNF) .and. !Empty(Z5_NUMNFEN)'	, 'BR_AZUL'})
aAdd(aCores,    { '!Empty(Z5_NUMNF) .and. Empty(Z5_NUMNFEN)' 	, 'BR_AMARELO'})
aAdd(aCores,    { '!Empty(Z5_NUMNF) .and. !Empty(Z5_NUMNFEN)'	, 'DISABLE'})

mBrowse(6,1,22,75,"SZ5",,,,,,aCores)

//EndFilBrw( "SZ5" , @aIndex ) 				

RestArea(aArea)

Return( NIL ) 


// visualiza pedido de venda
User Function Est01PVVis(cAlias,nRecno,nOpc)

Local aArea := GetArea()

SC5->(dbSetOrder(1))
If SC5->(dbSeek(xFilial("SC5")+SZ5->Z5_NUMPV))
	A410Visual("SC5",SC5->(Recno()),2)
Endif

RestArea(aArea)

Return()

	
// gera a nota de saida na filial de origem
User Function Est01NFSGer() 	

If Empty(SZ5->Z5_NUMNF)
	If APMsgYesNo("Confirma a geração da Nota de Saída para a Filial de origem para o registro posicionado ?")
		BEGIN TRANSACTION
			fwMsgRun(, {|| u_genNF(nil,SZ5->Z5_NUMPV,SZ5->Z5_NUM,.F.)}, "Processando", "Aguarde. Gerando Nota de Saída..." )
		END TRANSACTION
	Endif
Else
	APMsgAlert("Já foi gerada a Nota de Saída para o registro posicionado.")	
Endif	
		
Return()


// gera a nota de entrada na filial de destino
User Function Est01NFEGer() 	

If Empty(SZ5->Z5_NUMNFEN)
	If APMsgYesNo("Confirma a geração da Pré-Nota de Entrada para a filial de destino para o registro posicionado ?")
		BEGIN TRANSACTION
			fwMsgRun(, {|| u_MGFEST17(SZ5->Z5_NUMNF)}, "Processando", "Aguarde. Gerando Pré-Nota de Entrada..." )
		END TRANSACTION
	Endif
Else
	APMsgAlert("Já foi gerada a Pré-Nota de Entrada para o registro posicionado.")	
Endif	
		
Return()


User Function Est01Legend()

Local aLegenda	 := {}

aAdd(aLegenda,{"ENABLE" 		,"Nenhuma Nota Gerada"})
aAdd(aLegenda,{"BR_AMARELO"		,"Nota de Saída Gerada"})
//aAdd(aLegenda,{"BR_AZUL"		,"Pré-Nota de Entrada Gerada"})
aAdd(aLegenda,{"DISABLE"		,"Nota de Saída e Pré-Nota de Entrada Geradas"})

BrwLegenda(cCadastro,"Legenda", aLegenda )

Return .T.

//---------------------------------------------------------------------------------
// Retorna o Peso Liquido e Bruto da Nota de Origem
//---------------------------------------------------------------------------------
static function getPeso()
	local cQrySF1	:= ""
	local aRetPreso	:= { 0 , 0 }

	cQrySF1 := "SELECT F1_PLIQUI, F1_PBRUTO, F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA"
	cQrySF1 += " FROM " + retSQLName("SF1") + " SF1"
	cQrySF1 += " WHERE"
	cQrySF1 += "		SF1.F1_LOJA		=	'" + cGetLjForn		+ "'"
	cQrySF1 += "	AND	SF1.F1_FORNECE	=	'" + cGetForn		+ "'"
	cQrySF1 += "	AND	SF1.F1_SERIE	=	'" + cGetNFSer		+ "'"
	cQrySF1 += "	AND	SF1.F1_DOC		=	'" + cGetNFEnt		+ "'"
	cQrySF1 += " 	AND	SF1.F1_FILIAL	=	'" + xFilial("SF1")	+ "'"
	cQrySF1 += " 	AND	SF1.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySF1 New Alias "QRYSF1"

	if !QRYSF1->(EOF())
		aRetPreso := { QRYSF1->F1_PBRUTO, QRYSF1->F1_PLIQUI }
	endif

	QRYSF1->(DBCloseArea())
return aRetPreso

//---------------------------------------------------------------------------------
// Verifica se produto se encontra na tabela de Preco
//---------------------------------------------------------------------------------
static function chkProdTbl( cProd )
	local cQryDA1 := ""

	cQryDA1 := "SELECT DA1_CODTAB, DA1_CODPRO"
	cQryDA1 += " FROM " + retSQLName("DA1") + " DA1"
	cQryDA1 += " WHERE"
	cQryDA1 += " 		DA1.DA1_CODPRO	=	'" + cProd			+ "'"
	cQryDA1 += " 	AND	DA1.DA1_CODTAB	=	'" + cTabPrcRem		+ "'"
	cQryDA1 += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1")	+ "'"
	cQryDA1 += " 	AND	DA1.D_E_L_E_T_	<>	'*'"

	TcQuery cQryDA1 New Alias "QRYDA1"

	if QRYDA1->(EOF())
		// INCLUI item na Tabela de Preco
		cQryDA1 := "SELECT COALESCE( MAX( DA1_ITEM ), '0' ) DA1ITEM"
		cQryDA1 += " FROM " + retSQLName("DA1") + " DA1"
		cQryDA1 += " WHERE"
		cQryDA1 += " 		DA1.DA1_CODTAB	=	'" + cTabPrcRem		+ "'"
		cQryDA1 += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1")	+ "'"
		cQryDA1 += " 	AND	DA1.D_E_L_E_T_	<>	'*'"

		TcQuery cQryDA1 New Alias "QRYDA1MAX"

		if !QRYDA1MAX->(EOF())
			DBSelectArea("DA1")
			recLock("DA1", .T.)
				DA1->DA1_FILIAL	:= xFilial("DA1")
				DA1->DA1_CODTAB	:= cTabPrcRem
				DA1->DA1_ITEM	:= soma1( strZero ( val( QRYDA1MAX->DA1ITEM ) , tamSX3("DA1_ITEM")[1] ) )
				DA1->DA1_CODPRO	:= cProd
				DA1->DA1_PRCVEN	:= 1
			DA1->(msUnlock())
		endif

		QRYDA1MAX->(DBCloseArea())
	endif

	QRYDA1->(DBCloseArea())
return
/*
Inicializar o calculo para primeira nota sair correta
*/
STATIC Function xME1Tot(cPedido)

	Local aArea 	:= GetArea()
	Local aAreaSC5 	:= SC5->(GetArea())
	Local aAreaSA1 	:= SA1->(GetArea())
	Local aAreaSC6 	:= SC6->(GetArea())
	Local aAreaSB1 	:= SB1->(GetArea())
	Local aAreaSF4 	:= SF4->(GetArea())

	Local nRet		:= 0
	Local nQtdSc6	:= xMF16QtdIt(cPedido)
	Local nValDes	:= 0
	Local nRecSB1	:= 0
	Local nRecSF4	:= 0

	dbSelectArea('SC5')
	SC5->(DbSetOrder(1))//C5_FILIAL+C5_NUM
	If SC5->(dbSeek(FWxFilial('SC5') + cPedido))

		//Cabeçalho
		MaFisIni(SC5->C5_CLIENT			 ,;//01 Codigo Cliente/Fornecedor
		SC5->C5_LOJACLI				 ,;//02 Loja do Cliente/Fornecedor 
		If(SC5->C5_TIPO$'DB',"F","C"),;//03 C:Cliente , F:Fornecedor
		SC5->C5_TIPO				 ,;//04 Tipo da NF
		SC5->C5_TIPOCLI				 ,;//05 Tipo do Cliente/Fornecedor 
		Nil							 ,;//06 Relacao de Impostos que suportados no arquivo
		Nil							 ,;//07 Tipo de complemento 
		.F.							 ,;//08 Permite Incluir Impostos no Rodape .T./.F. 
		"SB1"						 ,;//09 Alias do Cadastro de Produtos - ("SBI" P/ Front Loja) 
		"MATA461"       			 ,;//10 Nome da rotina que esta utilizando a funcao
		Nil							 ,;//11 Tipo de documento					
		Nil							 ,;//12 Espécie do documento					
		Nil							 ,;//13 Código e Loja do Prospect					
		Nil							 ,;//14 Grupo Cliente					
		Nil							 ,;//15 Recolhe ISS					
		Nil							 ,;//16 Código do cliente de entrega na nota fiscal de saída					
		Nil							 ,;//17 Loja do cliente de entrega na nota fiscal de saída					
		Nil							 ,;//18 Informações do transportador [01]-UF,[02]-TPTRANS					
		Nil							 ,;//19 Se esta emitindo nota fiscal ou cupom fiscal (Sigaloja)					
		Nil							 ,;//20 Define se calcula IPI (SIGALOJA)
		cPedido						 ,;//21 Pedido de Venda
		SC5->C5_CLIENT				 ,;//22 Cliente do Faturamento 
		SC5->C5_LOJACLI	)			//23 Loja do Cliente do Faturamento

		dbSelectArea('SC6')
		SC6->(dbSelectArea(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO
		If SC6->(dbSeek(FWxFilial('SC6') + cPedido))
			While SC6->(!EOF()) .and. SC6->(C6_FILIAL + C6_NUM) == FWxFilial('SC6') + cPedido

				dbSelectArea('SB1')
				SB1->(dbSetOrder(1))//B1_FILIAL + B1_COD
				If SB1->(DbSeek(FWxFilial('SB1') + SC6->C6_PRODUTO))
					nRecSB1 := SB1->(RECNO())	
				EndIf

				dbSelectArea('SF4')
				SF4->(dbSetOrder(1))//F4_FILIAL, F4_CODIGO
				If SF4->(DbSeek(FWxFilial('SF4') + SC6->C6_TES))
					nRecSF4 := SF4->(RECNO())	
				EndIf

				nValDes	:= SC6->C6_VALDESC	+ (SC5->C5_DESCONT/nQtdSc6)

				MaFisAdd(	SC6->C6_PRODUTO			,;// 01-Codigo do Produto 					( Obrigatorio )
				SC6->C6_TES				,;// 02-Codigo do TES 						( Opcional )
				SC6->C6_QTDVEN			,;// 03-Quantidade 							( Obrigatorio )
				SC6->C6_PRCVEN			,;// 04-Preco Unitario 						( Obrigatorio )
				nValDes					,;// 05 desconto
				SC6->C6_NFORI			,;// 06-Numero da NF Original 				( Devolucao/Benef )
				SC6->C6_SERIORI			,;// 07-Serie da NF Original 				( Devolucao/Benef )
				nil						,;// 08-RecNo da NF Original no Arq SD1/SD2
				SC5->C5_FRETE/nQtdSc6	,;// 09-Valor do Frete do Item 				( Opcional )
				SC5->C5_DESPESA/nQtdSc6	,;// 10-Valor da Despesa do item	 		( Opcional )
				SC5->C5_SEGURO/nQtdSc6	,;// 11-Valor do Seguro do item 			( Opcional )
				SC5->C5_FRETAUT/nQtdSc6	,;// 12-Valor do Frete Autonomo 			( Opcional )
				SC6->C6_VALOR			,;// 13-Valor da Mercadoria 				( Obrigatorio )
				nil						,;// 14-Valor da Embalagem 					( Opcional )
				nRecSB1					,;// 15-RecNo do SB1
				nRecSF4					,;// 16-RecNo do SF4
				SC6->C6_ITEM			,;// 17-Numero do item – Exemplo '01'
				Nil						,;// 18-Despesas não tributadas (Portugal)
				Nil						,;// 19-Tara (Portugal) 	
				SC6->C6_CF				,;// 20-CFOP
				Nil						,;// 21-Array para o calculo do IVA Ajustado (opcional)
				Nil						,;// 22-Concepto
				Nil						,;// 23-Base Veiculo
				Nil						,;// 24-Lote Produto
				Nil						,;// 25-Sub-Lote Produto
				SC6->C6_ABATISS)		  // 26-Valor do Abatimento ISS

				SC6->(dbSkip())
			EndDo
		EndIf
		nRet := MaFisRet(,'NF_TOTAL')
		//MaFisEnd()
	EndIf

	RestArea(aAreaSF4)
	RestArea(aAreaSB1)
	RestArea(aAreaSC6)
	RestArea(aAreaSA1)
	RestArea(aAreaSC5)
	RestArea(aArea)

Return nRet

Static Function xMF16QtdIt(cPedido)

	Local aArea		:= GetArea()
	Local aAreaSC6	:= SC6->(GetArea())	
	Local nRet		:= 0

	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO

	If SC6->(dbSeek(FWxFilial('SC6') + cPedido))
		While SC6->(!EOF()) .and. SC6->(C6_FILIAL + C6_NUM) ==  FWxFilial('SC6') + cPedido
			nRet ++			
			SC6->(dbSkip())
		EndDo
	EndIf

	RestArea(aArea)
	RestArea(aAreaSC6)

Return nRet