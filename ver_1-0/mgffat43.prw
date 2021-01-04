#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFFAT43
Autor....:              Atilio Amarilla
Data.....:              21/07/2017
Descricao / Objetivo:   Cadastro de Seguro RCTRC
Doc. Origem:            GAP RCTRC
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User function MGFFAT43()
	local oBrowse       

	//Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZBS')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Consulta XML Enviados a Seguradora')

	oBrowse:disableReport()

	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  	ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' 	ACTION 'VIEWDEF.MGFFAT43'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Retransmitir' ACTION 'U_MGFFT43T'			OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar Planilha' 	ACTION 'u_xImpFat43'	OPERATION 2 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZBS := FWFormStruct( 1, 'ZBS', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('FAT43MDL', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZBSMASTER', /*cOwner*/, oStruZBS, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Consulta XML Enviados a Seguradora' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZBSMASTER' ):SetDescription( 'Dados de XML Enviados a Seguradora' )

	oModel:SetPrimaryKey({})

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFAT43' )
	// Cria a estrutura a ser usada na View
	Local oStruZBS := FWFormStruct( 2, 'ZBS' )
	Local oView  

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZBS', oStruZBS, 'ZBSMASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZBS', 'TELA' )
Return oView

//-------------------------------------------------------------------
User Function MGFFT43T()

	If MSGYESNO("Retransmitir solicitacao de averba��o da nota " + alltrim(ZBS->ZBS_NUM) + "?","Retransmiss�o de Averba��o de nota")

		fwmsgrun( ,{|| U_MGFFT41T() },'Retransmiss�o de Averba��o de nota','Aguarde...')

		msgalert("Processo concluido!","Retransmiss�o de Averba��o de nota")

	Else

		MsgStop( "Processo Cancelado!", "Retransmiss�o de Averba��o de nota" )
	
	EndIf

Return


//-------------------------------------------------------------------
user function xImpFat43()
	private	aRet
	private	aParambox	:=	{}

	aadd(aParamBox, {1, "Emissao de"				, CToD(space(8))	, "@R 99/99/99"				, 								, ,	, 070 	, .F.})
	aadd(aParamBox, {1, "Emissao ate"				, CToD(space(8))	, "@R 99/99/99"				, 								, ,	, 070 	, .F.})
	aadd(aParambox, {6, "Salvar arquivo Excel em"	, space(100)		, "@!"	, ""	, ""	, 070, .T., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY})

	if paramBox(aParambox, "Par�metros"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
		cursorWait() //Mostra Ampulheta
		msAguarde({|| defRelat()}, "Aguarde...", "Gerando relatorio!")
		cursorArrow() //Libera Ampulheta
	endif
return

//-------------------------------------------------------------------
static function defRelat()
	local oExcel	:= fwMSExcel():New()
	local oExcelApp	:= nil
	local cLocArq	:= allTrim(MV_PAR03)
	local cWrkSht1	:= "SEGURO RCTRC"
	local cTblTit1	:= "MGF - Seguro RCTRC"
	local aArea		:= getArea()
	local aAreaZBS	:= ZBS->(getArea())
	local nCountQry	:= 0
	local nCountPro	:= 0

	private cQryExcel	:= getNextAlias()

	getInfoZBS()

	if (cQryExcel)->(EOF())
		msgAlert("Nao h� dados com os parametros informados.")
	else
		Count to nCountQry

		(cQryExcel)->(DBGoTop())

		msProcTxt("Montando estrutura da planilha...")

		oExcel:AddworkSheet(cWrkSht1)			//Cria Planilha
		oExcel:AddTable(cWrkSht1, cTblTit1) 	//Cria Tabela

		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Filial"		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Numero NF"		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Serie NF"		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Emissao NF"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Situacao"		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Vlr Tot NF"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Num Pedido"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Numero OE"		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Cod Cliente"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Loja Cliente"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Nome Cliente"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "UF"			, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "CNPJ/CPF Cli"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Cod Transp"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Nome Transp"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Status Envio"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "CCE"			, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Dt/Hr Envio"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Cod Usuario"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Usuario"		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Dt/Hr Retran"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Dt/Hr Retorn"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Retorno WS"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Integ Taura"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Arquivo XML"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "CFOP"			, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Operacao"		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Averbacao"		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "D.RCTRC Tota"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Tipo Veiculo"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "D.RCTRC Rate"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Ordem de Emb"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monet�rio,4-DateTime )*/)

		while !(cQryExcel)->(EOF())
			nCountPro++

			msProcTxt("Processando " + str(nCountPro) + " de " + str(nCountQry) )

			aLinha := {}

			aadd( aLinha, (cQryExcel)->ZBS_FILIAL	)
			aadd( aLinha, (cQryExcel)->ZBS_NUM   	)
			aadd( aLinha, (cQryExcel)->ZBS_SERIE 	)
			aadd( aLinha, dToC( sToD( (cQryExcel)->ZBS_EMISS ) ) 	)
			aadd( aLinha, (cQryExcel)->ZBS_SITUAC	)
			aadd( aLinha, (cQryExcel)->ZBS_VALTOT	)
			aadd( aLinha, (cQryExcel)->ZBS_PEDIDO	)
			aadd( aLinha, (cQryExcel)->ZBS_OE		)
			aadd( aLinha, (cQryExcel)->ZBS_CODCLI	)
			aadd( aLinha, (cQryExcel)->ZBS_LOJCLI	)
			aadd( aLinha, (cQryExcel)->ZBS_NOMCLI	)
			aadd( aLinha, (cQryExcel)->ZBS_UF    	)
			aadd( aLinha, (cQryExcel)->ZBS_CNPJ		)
			aadd( aLinha, (cQryExcel)->ZBS_TRANSP	)
			aadd( aLinha, (cQryExcel)->ZBS_NOMTRN	)
			aadd( aLinha, (cQryExcel)->ZBS_STATUS	)
			aadd( aLinha, (cQryExcel)->ZBS_CCE   	)
			aadd( aLinha, (cQryExcel)->ZBS_DTHREN	)
			aadd( aLinha, (cQryExcel)->ZBS_CODUSR	)
			aadd( aLinha, (cQryExcel)->ZBS_NOMUSR	)
			aadd( aLinha, (cQryExcel)->ZBS_DTHRRT	)
			aadd( aLinha, (cQryExcel)->ZBS_DTHRWS	)
			aadd( aLinha, (cQryExcel)->ZBS_RETWS	)
			aadd( aLinha, (cQryExcel)->ZBS_ITAURA	)
			aadd( aLinha, (cQryExcel)->ZBS_ARQXML	)
			aadd( aLinha, (cQryExcel)->ZBS_CFOP		)
			aadd( aLinha, (cQryExcel)->ZBS_OPER		)
			aadd( aLinha, (cQryExcel)->ZBS_AVERBA	)
			aadd( aLinha, (cQryExcel)->ZBS_DESTOT	)
			aadd( aLinha, (cQryExcel)->ZBS_TPVEIC	)
			aadd( aLinha, (cQryExcel)->ZBS_DESCRA	)
			aadd( aLinha, (cQryExcel)->ZBS_NRROM	)

			oExcel:addRow(cWrkSht1, cTblTit1, aLinha)

			(cQryExcel)->(DBSkip())
		enddo

		oExcel:Activate()
		cArq := CriaTrab(NIL, .F.) + ".xml"
		oExcel:GetXMLFile(cArq)

		msProcTxt("Transferindo para estacao...")

		if __CopyFile(cArq, cLocArq + cArq)
			MsgInfo("Relatorio gerado em: " + cLocArq + cArq)
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(cLocArq + cArq)
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			if !ApOleClient('MsExcel')
				msgAlert("Excel nao esta instalado neste computador.")
			endIf
		endif
	endif

	if select(cQryExcel) > 0
		(cQryExcel)->(DbClosearea())
	endif

	restArea(aAreaZBS)
	restArea(aArea)
return

static function getInfoZBS()
	local cQryZBS := ""

	cQryZBS := "SELECT *"
	cQryZBS += " FROM " + retSQLName("ZBS") + " ZBS"
	cQryZBS += " WHERE"
	cQryZBS += "	ZBS.D_E_L_E_T_	<>	'*'"

	if !empty(MV_PAR01)
		cQryZBS += " AND ZBS_EMISS >= '" + dToS(MV_PAR01) + "'"
	endif

	if !empty(MV_PAR02)
		cQryZBS += " AND ZBS_EMISS <= '" + dToS(MV_PAR02) + "'"
	endif

	tcQuery cQryZBS New Alias (cQryExcel)
return