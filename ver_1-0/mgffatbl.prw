#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
/*/
=============================================================================
{Protheus.doc} MGFFATBL
Cadastro de regra para Venda interestadual x Grupo tributário

@description
Cadastra regra para Vendas interestaduais x Grupo tributário
Regra verificada pelo ponto de entrada 

@author Cosme Nunes
@since 19/02/2020
@type User Function

@table 
    SFW - Cabeçalho 
    SFX - Itens 

@param
    Não se aplica
    
@return
    Não se aplica

@menu
    MGFFATBL - Cadastro de regra para Venda interestadual x Grupo tributário

@history 
    19/02/2020 - RTASK0010790 - Chamados RITM0023263 - Cosme Nunes
/*/ 

User Function MGFFATBL()

Local oBrowse		:= Nil
Local aBKRotina		:= {}

If Type('aRotina') <> 'U'
	aBKRotina		:= aRotina
Endif	
aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZFW')
oBrowse:SetDescription('Regra Venda Interestadual x Grupo Tributação')

oBrowse:SetWalkThru(.F.)
oBrowse:SetAmbiente(.F.)
oBrowse:SetUseCursor(.F.)
oBrowse:DisableLocate(.F.)
oBrowse:DisableConfig()
oBrowse:DisableDetails()
oBrowse:Activate()
aRotina	:= aBKRotina	
Return( Nil )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦MENUDEF  ¦ Autor ¦ Cosme Nunes - Marfrig  ¦ Data ¦ 31.10.2019¦
+----------+-------------------------------------------------------------------¦
*/

Static Function MenuDef()

Local aRotina := {}
aAdd( aRotina, { 'Visualizar'	, 'VIEWDEF.MGFFATBL', 0, 2, 0, NIL } )
aAdd( aRotina, { 'Incluir' 		, 'VIEWDEF.MGFFATBL', 0, 3, 0, NIL } )
aAdd( aRotina, { 'Alterar' 		, 'VIEWDEF.MGFFATBL', 0, 4, 0, NIL } )
aAdd( aRotina, { 'Excluir' 		, 'VIEWDEF.MGFFATBL', 0, 5, 0, NIL } )
//aAdd( aRotina, { 'Imprimir'		, 'VIEWDEF.MGFFATBL', 0, 5, 0, NIL } )
Return( aRotina )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦MODELDEF ¦ Autor ¦ Cosme Nunes - Marfrig  ¦ Data ¦ 31.10.2019¦
+----------+-------------------------------------------------------------------¦
*/

Static Function ModelDef()
Local oModel		:= Nil
Local oSTRZFWCAB	:= FWFormStruct(1, "ZFW")     
Local oSTRZFXITE	:= FWFormStruct(1, "ZFX")     
Local bLinPreZFX	:= {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| LinePreZFX(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel)}
Local aGatCabec		:= {}
Local aGatItem		:= {}

oSTRZFWCAB:SetProperty( "ZFW_NATFIN" 	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZFWCAB:SetProperty( "ZFW_CCUSTO"  	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZFWCAB:SetProperty( "ZFW_CONTA"  	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZFWCAB:SetProperty( "ZFW_UF"     	, MODEL_FIELD_OBRIGAT,  .F. )

oSTRZFXITE:SetProperty( "ZFX_GRPTRI"  , MODEL_FIELD_OBRIGAT,  .T. )

//oSTRZFXITE:SetProperty( "ZFX_GRPTRI" , MODEL_FIELD_WHEN,{ ||If(Inclui .or. empty(),.T.,.F.) } )

//-----------------------------------Inicio dos gatilhos

// Gatilhos 
aGatCabec := FwStruTrigger ( 'ZFW_LOJA'    /*cDom*/, 'ZFW_RAZSOC' /*cCDom*/, "StaticCall( MGFFATBL, GZFW_LJ1 )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZFWCAB:AddTrigger( aGatCabec[1] /*cIdField*/, aGatCabec[2] /*cTargetIdField*/, aGatCabec[3] /*bPre*/, aGatCabec[4] /*bSetValue*/ )

aGatCabec := FwStruTrigger ( 'ZFW_LOJA'    /*cDom*/, 'ZFW_UF' /*cCDom*/, "StaticCall( MGFFATBL, GZFW_LJ2 )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZFWCAB:AddTrigger( aGatCabec[1] /*cIdField*/, aGatCabec[2] /*cTargetIdField*/, aGatCabec[3] /*bPre*/, aGatCabec[4] /*bSetValue*/ )

aGatItem := FwStruTrigger ( 'ZFX_GRPTRI'    /*cDom*/, 'ZFX_DGRPTR' /*cCDom*/, "StaticCall( MGFFATBL, GZFXGRT1 )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZFXITE:AddTrigger( aGatiTEM[1] /*cIdField*/, aGatiTEM[2] /*cTargetIdField*/, aGatiTEM[3] /*bPre*/, aGatiTEM[4] /*bSetValue*/ )

aGatItem := FwStruTrigger ( 'ZFX_GRPTRI'    /*cDom*/, 'ZFX_UF' /*cCDom*/, "StaticCall( MGFFATBL, GZFXGRT2 )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZFXITE:AddTrigger( aGatiTEM[1] /*cIdField*/, aGatiTEM[2] /*cTargetIdField*/, aGatiTEM[3] /*bPre*/, aGatiTEM[4] /*bSetValue*/ )


//-------------------------------------------- FIM DOS GATILHOS

oModel:= MPFormModel():New("MODELO", Nil, Nil, { |oMdl| bCommit( oMdl ) } )
oModel:AddFields("MODEL_ZFW_CAB", Nil, oSTRZFWCAB)
oModel:AddGrid("MODEL_ZFX_ITE", "MODEL_ZFW_CAB", oSTRZFXITE, bLinPreZFX)
oModel:SetPrimaryKey({"ZFW_CODFOR","ZFW_LOJA"})

//oModel:SetRelation("MODEL_SZR_ITE",{{"ZR_FILIAL",'xFilial("SZR")'},{"ZR_CODROM","ZR_CODROM"}},SZR->(IndexKey()))
oModel:SetRelation("MODEL_ZFX_ITE",  {{"ZFX_FILIAL","ZFW_FILIAL"}   ,{"ZFX_CODFOR","ZFW_CODFOR"},{"ZFX_LOJA","ZFW_LOJA"}},ZFX->(IndexKey(2)))
oModel:SetDescription('Regra de Venda Interestadual')
oModel:GetModel( "MODEL_ZFX_ITE" ):SetDescription( 'Grupo Tributário' )
Return( oModel ) 

/*
+------------------------------------------------------------------------------+
¦Programa  ¦VIEWDEF  ¦ Autor ¦ Cosme Nunes - Marfrig  ¦ Data ¦ 31.10.2019¦
+----------+-------------------------------------------------------------------¦
*/
Static Function ViewDef()

Local oModel	:= FWLoadModel("MGFFATBL") // Vincular o View ao Model
Local oView		:= FWFormView():New() // Criacao da Interface
Local oStrZFWC	:= FWFormStruct(2, 'ZFW')
Local oStrZFXD	:= FWFormStruct(2, 'ZFX')

// CAMPOS QUE SERÃO EXCLUIDOS DO CABEÇALHO 
//oStrZFWC:RemoveField( "ZFW_" )

// CAMPOS QUE SERÃO EXCLUIDOS DO ITEM 
oStrZFXD:RemoveField( "ZFX_CODFOR")
oStrZFXD:RemoveField( "ZFX_LOJA")

oView:SetModel(oModel)
oView:AddField( 'VIEW_ZFWC' , oStrZFWC, "MODEL_ZFW_CAB" )
oView:AddGrid(  'VIEW_ZFXD' , oStrZFXD, 'MODEL_ZFX_ITE' )

oView:CreateHorizontalBox( 'SUPERIOR', 35,,,) //20
oView:CreateHorizontalBox( 'INFERIOR', 65,,,) //80

//oView:AddGrid(  'VIEW_ZFWD' , oStrZFWD, 'MODEL_ZFW_ITE' )
oView:AddIncrementField( 'VIEW_ZFXD', 'ZFX_ITEM' )

oView:SetOwnerView( 'VIEW_ZFWC', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_ZFXD', 'INFERIOR' )
Return( oView )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦BCANCEL  ¦ Autor ¦ Cosme Nunes - Marfrig  ¦ Data ¦ 31.10.2019¦
+----------+-------------------------------------------------------------------¦
*/
Static Function bCancel(oModel)
Local lRet := .T.
Return( lRet )

//-----------------------------------------------------------------------------------------------
// Gatilho Produto
//-----------------------------------------------------------------------------------------------
/*
+------------------------------------------------------------------------------+
¦Programa  ¦GZFW_LJ1 ¦ Autor ¦ Cosme Nunes - Marfrig  ¦ Data ¦ 31.10.2019      ¦
+----------+-------------------------------------------------------------------¦
*/
Static Function GZFW_LJ1()
Local cRet	:= ''
DbSelectArea("SA2")
DbSetOrder(1)
DBGOTOP()
If SA2->( dbSeek( xFilial('SA2') + FwFldGet("ZFW_CODFOR")+FwFldGet("ZFW_LOJA") ))
	cRet	:= SA2->A2_NOME
EndIf
Return( cRet )

/*+------------------------------------------------------------------------------+
¦Programa  ¦GZFW_LJ2 ¦ Autor ¦ Cosme Nunes - Marfrig  ¦ Data ¦ 31.10.2019¦
+----------+-------------------------------------------------------------------¦
*/
Static Function GZFW_LJ2()
Local cRet	:= ''
DbSelectArea("SA2")
DbSetOrder(1)
DBGOTOP()
If SA2->( dbSeek( xFilial('SA2') + FwFldGet("ZFW_CODFOR")+FwFldGet("ZFW_LOJA") ))
	cRet	:= SA2->A2_EST
EndIf
Return( cRet )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦GZFXGRT1 ¦ Autor ¦ Cosme Nunes - Marfrig  ¦ Data ¦ 31.10.2019¦
+----------+-------------------------------------------------------------------¦
*/
Static Function GZFXGRT1()
Local cRet		:= ' '
If SX5->(DbSeek(FWxFilial('SX5') + "21"+ FwFldGet("ZFX_GRPTRI") ))
    cRet := SX5->X5_DESCRI
EndIf
Return( cRet )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦GZFXGRT2 ¦ Autor ¦ Cosme Nunes - Marfrig  ¦ Data ¦ 31.10.2019¦
+----------+-------------------------------------------------------------------¦
*/
Static Function GZFXGRT2()
Local cRet		:= ' '
DbSelectArea("SA2")
DbSetOrder(1)
DBGOTOP()
If SA2->( dbSeek( xFilial('SA2') + FwFldGet("ZFW_CODFOR")+FwFldGet("ZFW_LOJA") ))
	cRet	:= SA2->A2_EST
EndIf
Return( cRet )


/*
+---------------------------------------------------------------------------------+
¦Programa  ¦BCOMMIT      ¦ Autor ¦ Cosme Nunes - Marfrig  ¦ Data ¦ 31.10.2019¦
+----------+----------------------------------------------------------------------¦
*/

Static Function bCommit( oModel )

Local oModelCAB		:= oModel:GetModel('MODEL_ZFW_CAB')
Local oModelITE		:= oModel:GetModel('MODEL_ZFX_ITE')
Local nOperation 	:= oModel:GetOperation()
Local cFilialZFW	:= xFilial("ZFW")
Local cFilialZFX	:= xFilial("ZFX")
Local nI			:= 00
Local lRet 			:= .T.
Local nTamArray1	:= oModelITE:Length()

Begin Transaction

    If  nOperation == MODEL_OPERATION_INSERT .OR. ;
        nOperation == MODEL_OPERATION_UPDATE .OR. ;
        nOperation == MODEL_OPERATION_DELETE 
        
        If ZFW->( dbSeek( cFilialZFW + oModelCAB:GetValue( 'ZFW_CODFOR' ) + oModelCAB:GetValue( 'ZFW_LOJA' ) ) )
            RecLock('ZFW', .F.)
        Else
            RecLock('ZFW', .T.)
        Endif        

        If nOperation == MODEL_OPERATION_DELETE 
            RecLock('ZFW', .F.)
            ZFW->( dbDelete() )
            ZFW->(MsUnlock())			
        Else
            //Cabeçalho
            ZFW->ZFW_FILIAL  	:= cFilialZFW        
            ZFW->ZFW_CODFOR		:= oModelCAB:GetValue( 'ZFW_CODFOR')
            ZFW->ZFW_LOJA		:= oModelCAB:GetValue( 'ZFW_LOJA')
            ZFW->ZFW_NATFIN		:= oModelCAB:GetValue( 'ZFW_NATFIN')
            ZFW->ZFW_CCUSTO		:= oModelCAB:GetValue( 'ZFW_CCUSTO')
            ZFW->ZFW_CONTA		:= oModelCAB:GetValue( 'ZFW_CONTA')
            ZFW->ZFW_UF	    	:= oModelCAB:GetValue( 'ZFW_UF')
            ZFW->(MsUnlock())	
        EndIf

        For nI := 01 to nTamArray1
            
            oModelITE:GoLine(nI)
            
            If oModelITE:IsDeleted() .OR. nOperation == MODEL_OPERATION_DELETE 
                ZFX->(DBSETORDER(3))    
                If ZFX->( dbSeek( cFilialZFX + oModelITE:GetValue( 'ZFX_ITEM' ) + oModelITE:GetValue( 'ZFX_CODFOR' ) + oModelITE:GetValue( 'ZFX_LOJA' ) ) )
                    RecLock('ZFX', .F.)
                    ZFX->( dbDelete() )
                    ZFX->(MsUnlock())			
                Endif		
            Else
                ZFX->(DBSETORDER(3))    
                If ZFX->( dbSeek( cFilialZFX + oModelITE:GetValue( 'ZFX_ITEM' ) + oModelITE:GetValue( 'ZFX_CODFOR' ) + oModelITE:GetValue( 'ZFX_LOJA' ) ) )
                    RecLock('ZFX', .F.)
                Else
                    RecLock('ZFX', .T.)
                Endif
                ZFX->ZFX_FILIAL  	:= cFilialZFX
                ZFX->ZFX_CODFOR		:= oModelCAB:GetValue( 'ZFW_CODFOR')
                ZFX->ZFX_LOJA		:= oModelCAB:GetValue( 'ZFW_LOJA')			
                ZFX->ZFX_ITEM    	:= oModelITE:GetValue( 'ZFX_ITEM')
                ZFX->ZFX_GRPTRI 	:= oModelITE:GetValue( 'ZFX_GRPTRI')
                ZFX->ZFX_UF	    	:= oModelCAB:GetValue( 'ZFW_UF')
                ZFX->(MsUnlock())	
            Endif
            
        Next nI

    EndIf

End Transaction

Return( lRet )


/*
+---------------------------------------------------------------------------------+
¦Programa  ¦LINEPREZFX  ¦ Autor ¦ Cosme Nunes - Marfrig  ¦ Data ¦ 31.10.2019¦
+----------+----------------------------------------------------------------------¦

@param		oGridModel		, Objeto	, Grid
@param		nLine			, Numerico	, Linha do grid
@param		cAction			, Caracter	, Ação UNDELETE / DELETE / SETVALUE / CANSETVALUE
@param		cIDField		, Caracter	, Campo Sendo atualizado
@param		xValue			, Indefinido, Novo valor
@param		xCurrentValue	, Indefinido, Valor antigo
@return		lRet, Boolean, Retorno

*/

Static Function LinePreZFX( oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel )

Local lRet 			:= .T.
Local oModelITE		:= oModel:GetModel( 'MODEL_ZFX_ITE' )
Local nI			:= 00
Local nLineZFX		:= oModelITE:GetLine()
Local nTamArray1	:= oModelITE:Length()

Begin Sequence

If cAction == "SETVALUE"

	If cIDField == 'ZFX_GRPTRI' 

        oModelITE:SetValue( 'ZFX_CODFOR', FwFldGet('ZFX_CODFOR'))

		For nI := 01 to nTamArray1
			
			If nI <> nLineZFX

				oModelITE:GoLine(nI)

				If xValue == oModelITE:GetValue( 'ZFX_GRPTRI' )

					oModel:SetErrorMessage(, , , ,'LinePreZFX' , "Codigo já informado no item: " + oModelITE:GetValue( 'ZFX_ITEM' ), "Alterar Grupo de Tributação já informado", , )
					lRet := .F.; Break
				
				Endif
				
			Endif
			
		Next nI

	Endif

Endif
End Sequence
oModelITE:GoLine(nLineZFX)
Return( lRet )