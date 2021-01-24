#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*/
{Protheus.doc} MGFGCT16
	Popular o array dos itens de clientes.

	@description
		Popular automaticamente os arrays dos itens para as abas Clientes e Palnilhas 
		quando se tratar de Grandes Lojas, para a geração de contratos de venda. 

	@author Marcos Cesar Donizeti Vieira
	@since 04/12/2020

	@version P12.1.017
	@country Brasil
	@language Português
	
/*/
User Function MGFGCT16() 
	Local _lRet 	:= .T.  
	Local _aArea 	:= GetArea() 

	Local _lGrdRede	:= .F.

	Local oDlg
	Local _bOk		:= {|| _lGrdRede := .T.,oDlg:End()}
	Local _bCancel	:= {|| _lGrdRede := .F.,oDlg:End()}

	Local oModel 	:= FwModelActive()
	Local oModelCN9	:= oModel:GetModel("CN9MASTER")

	Private _cGrdRede	:= Space(03)
	Private _dDtIni		:= oModelCN9:GetValue("CN9_DTINIC")
	Private _dDtFim		:= oModelCN9:GetValue("CN9_DTFIM")

	
	If Type("_lGatilho") = "U"	//Verifica para não executar o gatilho novamente quando a variável existir.
		_lGatilho := .T.
	Else 
		_lGatilho := .F.
	EndIf 

	If oModelCN9:GetValue("CN9_ESPCTR") == "2" .And. _lGatilho	//-- Valida se a espécie do contrato é Vendas
		If MsgYesNo("Deseja buscar Grandes Redes? ")	
			
			Define MSDialog oDlg Title "SELEÇÃO DE GRANDES REDES" From 0, 0 To 135, 346 Of oDlg Pixel
				@ 032,004 To 066,170 Label Pixel Of oDlg
				@ 042,029 Say "Grandes Redes: " Size 125,022 Pixel Of oDlg
				@ 040,075 MsGet _cGrdRede  		Size 033,009 F3 "SZQ" Valid ( GCT16A(oDlg,_cGrdRede) ) Picture "@!" Pixel Of oDlg
			Activate MSDialog oDlg Centered On Init (EnchoiceBar( oDlg, _bOk, _bCancel ))

			If !Empty(_cGrdRede)
				Processa({|| GCT16B()},"Aguarde...","Populando grid com os Clientes da rede: "+SZQ->ZQ_DESCR,.F.)	//-- Popula Array das lojas das Grandes Redes
			EndIF

		EndIf	
	EndIf

	RestArea(_aArea)

Return(_lRet)



/*/{Protheus.doc} GCT16A
    Validar Grandes Redes
    @type  Static Function 
    @author Marcos Vieira
    @since 04/22/2020
/*/
Static Function GCT16A(oDlg, _cGrdRede)

	SZQ->(dbSetorder(1))
	If SZQ->(dbSeek(xFilial("SZQ")+_cGrdRede))
		@ 053,005 Say SZQ->ZQ_DESCR Size 200,022 Pixel COLOR CLR_BLUE  Of oDlg
		oDlg:Refresh() 
	EndIf

Return



/*/{Protheus.doc} GCT16B
    Popula Array com as loajs das Grandes Redes
    @type  Static Function 
    @author Marcos Vieira
    @since 04/22/2020
/*/
Static Function GCT16B(_cAliasSA1)
	Local oModel		:= FWModelActive()
	Local oModelCNA 	:= oModel:GetModel("CNADETAIL")
	Local oModelCNC 	:= oModel:GetModel("CNCDETAIL")

	Local _cAliasSA1 	:= GetNextAlias()
	Local _lPLinha		:= .T.
	Local _cNrPlan		:= Soma1( Replicate( "0",(TamSx3('CNA_NUMERO')[1]) )  )
	Local _cTpPlan		:= "001"
	
	//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
	If !ExisteSx6("MGF_GCT16A")
		CriarSX6("MGF_GCT16A", "C", "Tipo de planilha para popular automaticamente grandes lojas."	, '001' )	
	EndIf

	_cTpPlan := Alltrim( SuperGetMV( "MGF_GCT16A", .T., "001" ) )

	BeginSql Alias _cAliasSA1 
		SELECT
			SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME
		FROM 
			%table:SA1% SA1
		WHERE
			A1_FILIAL = %xFilial:SA1% AND A1_ZREDE = %Exp:_cGrdRede% AND SA1.%NotDel%
	EndSql

	oModelCNC:DelAllLine()
	oModelCNC:ClearData()
	
	While (_cAliasSA1)->( !Eof() )//----- Popula Grid da Aba Clientes
		If _lPLinha		//-- Se é a Primeira linha não adiciona outra ao Grid
			_lPLinha := .F.
		Else
			oModelCNC:AddLine()	
		EndIf

		oModelCNC:SetValue('CNC_CLIENT'	, (_cAliasSA1)->A1_COD	)
		oModelCNC:SetValue('CNC_LOJACL'	, (_cAliasSA1)->A1_LOJA	)
		oModelCNC:SetValue('CNC_NOMECL'	, (_cAliasSA1)->A1_NOME	)
		
		(_cAliasSA1)->( dbSkip() )
	EndDo

	oModelCNC:GoLine(1)

	oModelCNA:DelAllLine()
	oModelCNA:ClearData()
	
	_lPLinha := .T.

	(_cAliasSA1)->( dbGoTop() )
	While (_cAliasSA1)->( !Eof() )	//----- Popula Grid da Aba Planilhas
		If _lPLinha		//-- Se é a Primeira linha não adiciona outra ao Grid
			_lPLinha := .F.
		Else
			oModelCNA:AddLine()	
			_cNrPlan := Soma1( _cNrPlan  )
		EndIf

		oModelCNA:SetValue('CNA_NUMERO'	, _cNrPlan				)
		oModelCNA:SetValue('CNA_CLIENT'	, (_cAliasSA1)->A1_COD	)
		oModelCNA:SetValue('CNA_LOJACL'	, (_cAliasSA1)->A1_LOJA	)
		oModelCNA:SetValue('CNA_DTINI'	, _dDtIni				)
		oModelCNA:SetValue('CNA_DTFIM'	, _dDtFim				)
		oModelCNA:SetValue('CNA_TIPPLA'	, _cTpPlan				)
		
		(_cAliasSA1)->( dbSkip() )
	EndDo

	(_cAliasSA1)->(DBCloseArea())

	oModelCNA:GoLine(1)

Return