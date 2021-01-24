#INCLUDE "TOTVS.CH"
#Include 'FWMVCDef.ch'

/*/
==============================================================================================================================================================================
Descrição   : Grupo de Aprovadores

@description
Grupo de Aprovação dos títulos, da solicitação financeira

@author     : Renato Junior
@since      : 15/07/2020
@type       : User Function

@table      ZGQ -   SOLICITAÇÕES FINANCEIRAS
@menu       Financeiro - Atualizações-Especificos MARFRIG
@history 
/*/   
User Function MGFFINBT()
Local oBrowse		:= Nil
Local aBKRotina		:= {}

Private _nTamNmUsr  := TamSx3("ZGR_USRNOM")[1]

DBSELECTAREA("ZGR")
ZGR->(DBSETORDER(1))

If Type('aRotina') <> 'U'
	aBKRotina		:= aRotina
Endif	
aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZGR')
oBrowse:SetDescription('"Grade de Aprovação')

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
¦Programa  ¦MENUDEF  ¦ Autor ¦ Renato Junior                ¦ Data ¦ 27.07.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function MenuDef()

Local aRotina := {}
aAdd( aRotina, { 'Visualizar'	, 'VIEWDEF.MGFFINBT', 0, 2, 0, NIL } )
aAdd( aRotina, { 'Incluir' 		, 'VIEWDEF.MGFFINBT', 0, 3, 0, NIL } )
aAdd( aRotina, { 'Alterar' 		, 'VIEWDEF.MGFFINBT', 0, 4, 0, NIL } )
aAdd( aRotina, { 'Excluir' 		, 'VIEWDEF.MGFFINBT', 0, 5, 0, NIL } )
Return( aRotina )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦MODELDEF ¦ Autor ¦ Renato Junior                ¦ Data ¦ 27.07.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function ModelDef()
Local oModel		:= Nil
Local oSTRZGRCAB	:= FWFormStruct(1, "ZGR")     
Local oSTRZGRITE	:= FWFormStruct(1, "ZGR")     
Local bLinPreZGR	:= {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| LinePreZGR(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel)}
Local aGatilho		:= {}

oSTRZGRCAB:SetProperty( "ZGR_CODIGO"    , MODEL_FIELD_INIT, { ||GetSXENum('ZGR','ZGR_CODIGO')} )
oSTRZGRCAB:SetProperty( "ZGR_DESCRI" 	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZGRCAB:SetProperty( "ZGR_GATIVO" 	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZGRCAB:SetProperty( "ZGR_ROTINA" 	, MODEL_FIELD_OBRIGAT,  .T. )

oSTRZGRITE:SetProperty( "ZGR_NIVEL" 	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZGRITE:SetProperty( "ZGR_SEQUEN" 	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZGRITE:SetProperty( "ZGR_USRCOD" 	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZGRITE:SetProperty( "ZGR_USRNOM"    , MODEL_FIELD_INIT, { |cNomTmp| If(!INCLUI, ( cNomTmp := LEFT( UsrFullName(ZGR->ZGR_USRCOD), _nTamNmUsr), cNomTmp ), "" ) } )
//oSTRZGRITE:SetProperty( "ZGR_USRNOM"    , MODEL_FIELD_OBRIGAT,  .T. )
oSTRZGRITE:SetProperty( "ZGR_TIPO" 	    , MODEL_FIELD_OBRIGAT,  .T. )
oSTRZGRITE:SetProperty( "ZGR_ATIVO" 	, MODEL_FIELD_OBRIGAT,  .T. )

//-----------------------------------Inicio dos gatilhos

// Gatilhos Cliente
aGatilho := FwStruTrigger ( 'ZGR_USRCOD' /**cDom*/, 'ZGR_USRNOM' /*cCDom*/, "StaticCall( MGFFINBT, gZGRCODALC )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZGRITE:AddTrigger( aGatilho[1] /*cIdField*/, aGatilho[2] /*cTargetIdField*/, aGatilho[3] /*bPre*/, aGatilho[4] /*bSetValue*/ )

//-------------------------------------------- FIM DOS GATILHOS
oModel:= MPFormModel():New("MODELO", Nil, Nil, { |oMdl| bCommit( oMdl ) } )
oModel:AddFields("MODEL_ZGR_CAB", Nil, oSTRZGRCAB)
oModel:AddGrid("MODEL_ZGR_ITE", "MODEL_ZGR_CAB", oSTRZGRITE, bLinPreZGR)
oModel:SetPrimaryKey({"ZGR_FILIAL","ZGR_CODIGO","ZGR_NIVEL","ZGR_SEQUEN"})
oModel:SetRelation("MODEL_ZGR_ITE",{{"ZGR_FILIAL",'xFilial("ZGR")'},{"ZGR_CODIGO","ZGR_CODIGO"}},ZGR->(IndexKey()))
oModel:SetDescription('Grupo de Aprovadores Financeiro' )
oModel:GetModel( "MODEL_ZGR_ITE" ):SetDescription( 'Grupo de Aprovadores' )
Return( oModel ) 

/*
+------------------------------------------------------------------------------+
¦Programa  ¦VIEWDEF  ¦ Autor ¦ Renato Junior                ¦ Data ¦ 27.07.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function ViewDef()
Local oModel	:= FWLoadModel("MGFFINBT") // Vincular o View ao Model
Local oView		:= FWFormView():New() // Criacao da Interface
Local oStrZGRC	:= FWFormStruct(2, 'ZGR')
Local oStrZGRI	:= FWFormStruct(2, 'ZGR')

// CAMPOS QUE SERÃO EXCLUIDOS DO CABEÇALHO 
oStrZGRC:RemoveField( "ZGR_NIVEL" )
oStrZGRC:RemoveField( "ZGR_SEQUEN" )
oStrZGRC:RemoveField( "ZGR_USRCOD" )
oStrZGRC:RemoveField( "ZGR_USRNOM" )
oStrZGRC:RemoveField( "ZGR_TIPO" )
oStrZGRC:RemoveField( "ZGR_ATIVO" )

// CAMPOS QUE SERÃO EXCLUIDOS DO ITEM 
oStrZGRI:RemoveField( "ZGR_CODIGO")
oStrZGRI:RemoveField( "ZGR_DESCRI")
oStrZGRI:RemoveField( "ZGR_GATIVO" )
oStrZGRI:RemoveField( "ZGR_ROTINA" )

oView:SetModel(oModel)
oView:AddField( 'VIEW_ZGRC' , oStrZGRC, "MODEL_ZGR_CAB" )
oView:AddGrid(  'VIEW_ZGRI' , oStrZGRI, 'MODEL_ZGR_ITE' )

oView:CreateHorizontalBox( 'SUPERIOR', 20,,,) //20
oView:CreateHorizontalBox( 'INFERIOR', 80,,,) //80

oView:AddIncrementField( 'VIEW_ZGRI', 'ZGR_ITEM' )

oView:SetOwnerView( 'VIEW_ZGRC', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_ZGRI', 'INFERIOR' )
Return( oView )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦bCancel  ¦ Autor ¦ Renato Junior                ¦ Data ¦ 27.07.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function bCancel(oModel)
Local lRet := .T.
Return( lRet )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦GZGRCODALC  ¦ Autor ¦ Renato Junior             ¦ Data ¦ 27.07.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function gZGRCODALC()
Local cRet	:= ''
cCodUser := LEFT( UsrFullName(FwFldGet('ZGR_USRCOD')), _nTamNmUsr)
cRet 		:= Alltrim(cCodUser)
Return( cRet )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦bCommit  ¦ Autor ¦ Renato Junior                ¦ Data ¦ 27.07.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function bCommit( oModel )
Local oModelCAB		:= oModel:GetModel('MODEL_ZGR_CAB')
Local oModelITE		:= oModel:GetModel('MODEL_ZGR_ITE')
Local nOperation 	:= oModel:GetOperation()
Local cFilialZGR	:= xFilial("ZGR")
Local nI			:= 00
Local lRet 			:= .T.
Local nTamArray1	:= oModelITE:Length()
Local _cSolExist	:=	""
Local _cZGRUSRCOD	:=	""	// Usuario informado na linha

If ! oModel:VldData()
	RollBackSX8()
EndIf

Begin Transaction

If nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE .OR. nOperation == MODEL_OPERATION_DELETE 
	For nI := 01 to nTamArray1
		oModelITE:GoLine(nI)
		If oModelITE:GetValue( 'ZGR_TIPO' )	== "S"	.AND. oModelITE:GetValue( 'ZGR_ATIVO' )	== "S"
			_cZGRUSRCOD	+=	"'"+oModelITE:GetValue( 'ZGR_USRCOD' )+"',"		// Adiciona todos Solicitantes informados
		EndIf
	Next
	If ! Empty(_cZGRUSRCOD) .AND.	! Empty(_cSolExist	:=	U_FINBTChk(_cZGRUSRCOD, oModelCAB:GetValue( 'ZGR_CODIGO' ),.F.))	// Se Solicitante nao estiver em outro(s) grupo(s)
		oModel:SetErrorMessage(, , , ,'bCommit' , "Ja foi informado anteriormente Usuário/Grupo/Nível/Sequência : " + _cSolExist , "Verifique a duplicidade de Solicitante !", , )
		lRet := .F.
	Else
			If nOperation == MODEL_OPERATION_INSERT
				ConfirmSX8()
			Endif
			For nI := 01 to nTamArray1
				oModelITE:GoLine(nI)
				If oModelITE:IsDeleted() .OR. nOperation == MODEL_OPERATION_DELETE 
					If ZGR->( DBSETORDER(1), dbSeek( cFilialZGR+oModelITE:GetValue('ZGR_CODIGO')+oModelITE:GetValue('ZGR_NIVEL')+oModelITE:GetValue('ZGR_SEQUEN') ) )
						RecLock('ZGR', .F.)
						ZGR->( dbDelete() )
						ZGR->(MsUnlock())			
					Endif		
				Else
					If ZGR->( DBSETORDER(1), dbSeek( cFilialZGR+oModelITE:GetValue('ZGR_CODIGO')+oModelITE:GetValue('ZGR_NIVEL')+oModelITE:GetValue('ZGR_SEQUEN') ) )
						RecLock('ZGR', .F.)
					Else
						RecLock('ZGR', .T.)
					Endif
					//Filial
					ZGR->ZGR_FILIAL  := cFilialZGR
					//Cabeçalho
					ZGR->ZGR_CODIGO	:= oModelCAB:GetValue( 'ZGR_CODIGO' )
					ZGR->ZGR_DESCRI := oModelCAB:GetValue( 'ZGR_DESCRI' )
					ZGR->ZGR_GATIVO := oModelCAB:GetValue( 'ZGR_GATIVO' )
					ZGR->ZGR_ROTINA := oModelCAB:GetValue( 'ZGR_ROTINA' )
	            	//
					ZGR->ZGR_NIVEL  := oModelITE:GetValue( 'ZGR_NIVEL' )	
					ZGR->ZGR_SEQUEN	:= oModelITE:GetValue( 'ZGR_SEQUEN' )
					ZGR->ZGR_USRCOD := oModelITE:GetValue( 'ZGR_USRCOD' )
					ZGR->ZGR_TIPO   := oModelITE:GetValue( 'ZGR_TIPO' )
					ZGR->ZGR_ATIVO  := oModelITE:GetValue( 'ZGR_ATIVO' )
					ZGR->(MsUnlock())	
				Endif
			Next nI
	Endif
EndIf

End Transaction

Return( lRet )

/*
+---------------------------------------------------------------------------------+
¦Programa  ¦LINEPREZGR  ¦ Autor ¦ Renato Junior                ¦ Data ¦ 27.07.2020¦
+----------+----------------------------------------------------------------------¦
@param		oGridModel		, Objeto	, Grid
@param		nLine			, Numerico	, Linha do grid
@param		cAction			, Caracter	, Ação UNDELETE / DELETE / SETVALUE / CANSETVALUE
@param		cIDField		, Caracter	, Campo Sendo atualizado
@param		xValue			, Indefinido, Novo valor
@param		xCurrentValue	, Indefinido, Valor antigo
@return		lRet, Boolean, Retorno
*/
Static Function LinePreZGR( oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel )
Local lRet 			:= .T.
Local oModelITE		:= oModel:GetModel( 'MODEL_ZGR_ITE' )
Local nI			:= 00
Local nLineZGR		:= oModelITE:GetLine()
Local nTamArray1	:= oModelITE:Length()
Local _cNivelAtu    :=  "00"

Begin Sequence
If cAction == "SETVALUE"
	If cIDField == 'ZGR_USRCOD' 
	
		For nI := 01 to nTamArray1
			If nI <> nLineZGR
				oModelITE:GoLine(nI)
				If xValue == oModelITE:GetValue( 'ZGR_USRCOD' )
					oModel:SetErrorMessage(, , , ,'LinePreZGR' , "Usuário já informado no nivel/sequencia: " + ;
                    oModelITE:GetValue( 'ZGR_NIVEL' )+"/"+oModelITE:GetValue( 'ZGR_SEQUEN' ), "Alterar codigo já informado", , )
					lRet := .F.; Break
				Endif
			Endif
		Next nI

    ElseIf cIDField == 'ZGR_TIPO' 
		ZGR->( DBSETORDER(2), dbSeek( XFILIAL("ZGR") + oModelITE:GetValue( 'ZGR_USRCOD' )))
		WHILE ! ZGR->( EOF())	.AND. ZGR->ZGR_USRCOD	== oModelITE:GetValue( 'ZGR_USRCOD' )
		 	If ZGR->ZGR_CODIGO <> oModelITE:GetValue( 'ZGR_CODIGO' ) .AND. ZGR->ZGR_GATIVO = 'S' .AND. ZGR->ZGR_ATIVO == 'S'	.AND. ZGR->ZGR_TIPO <> M->ZGR_TIPO
				oModel:SetErrorMessage(, , , ,'LinePreZGR' , "Usuário já informado com outro tipo: " + ZGR->ZGR_TIPO , "Não pode ser diferente", , )
				lRet := .F.
				ZGR->( DBSETORDER(1))
				Break
			Endif
		 	ZGR->( DBSKIP())
		ENDDO
		ZGR->( DBSETORDER(1))
    ElseIf cIDField == 'ZGR_SEQUEN' 
        _cNivelAtu  :=  oModelITE:GetValue( 'ZGR_NIVEL' )
		For nI := 01 to nTamArray1
			If nI <> nLineZGR
				oModelITE:GoLine(nI)
				If _cNivelAtu + xValue == oModelITE:GetValue( 'ZGR_NIVEL' ) + oModelITE:GetValue( 'ZGR_SEQUEN' )
					oModel:SetErrorMessage(, , , ,'LinePreZGR' , "Nivel/Sequencia já informado ", "Não pode duplicar", , )
					lRet := .F.; Break
				Endif
			Endif
		Next nI

	Endif
Endif
End Sequence
oModelITE:GoLine(nLineZGR)
Return( lRet )



/*/{Protheus.doc} FINBT_Chk()
Função para Verificar : 1 - Existe usuario em outro grupo como Solcitante

@author Renato Bandeira
@since 16/09/2020
/*/
User Function FINBTChk(xCodUsuar, xCodGrupo, xlAnalise, xZGRTIPO)
Local cQuery		:= ''
Local _cRetMsg		:= ""
Local cNextAlias	:= GetNextAlias()
Local _cFim         := CHR(13) + CHR(10)

If RIGHT(xCodUsuar,1)==","		//	Ajusta sequencia de codigos de usuario
	xCodUsuar	:=	LEFT(xCodUsuar, LEN(xCodUsuar)-1)
Endif

cQuery  := ''
cQuery  += " SELECT ZGR_USRCOD,ZGR_CODIGO,ZGR_NIVEL,ZGR_SEQUEN,ZGR_TIPO FROM "+RetSqlName("ZGR")+" ZGR "
cQuery  += " WHERE ZGR.D_E_L_E_T_ = ' ' "
cQuery  += " AND ZGR_USRCOD IN ("+xCodUsuar+") "
If ! xlAnalise	// Se não for Analise : Filtra apenas grupo do solicitante e tipo Solicitante
	cQuery  += " AND ZGR_CODIGO <> '"+xCodGrupo+"' "
	cQuery  += " AND ZGR_TIPO = 'S' "
Else			// Se for Analise : Nao demonstra tipo solicitante
	cQuery  += " AND ZGR_TIPO <> 'S' "
Endif
cQuery  += " AND ZGR_GATIVO = 'S' AND ZGR_ATIVO= 'S' "	// Grupo e Linha Ativos
cQuery  += " AND ZGR_ROTINA LIKE '%1%' "	// Apenas verifica para grupos da Rotina 1 

If Select(cNextAlias) > 0
	(cNextAlias)->(DbClosearea())
Endif
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
dbSelectArea(cNextAlias)
(cNextAlias)->(dbGoTop())
While ! (cNextAlias)->(Eof())
	If xlAnalise	// Variavel para a rotina de Analise
		_cRetMsg	+=	"'"+(cNextAlias)->ZGR_CODIGO+"',"
		xZGRTIPO	:=	(cNextAlias)->ZGR_TIPO	// Somente um tipo para cada usuario
	Else
		_cRetMsg	:=	(cNextAlias)->(ZGR_USRCOD+"/"+ZGR_CODIGO+"/"+ZGR_NIVEL+"/"+ZGR_SEQUEN) + _cFim
	Endif
	(cNextAlias)->(Dbskip())
Enddo
If Select(cNextAlias) > 0
	(cNextAlias)->(DbClosearea())
Endif

If xlAnalise	.AND.	RIGHT(_cRetMsg,1)==","	// Ajusta para ser utilizado corretamente no Select
	_cRetMsg	:=	LEFT(_cRetMsg, LEN(_cRetMsg)-1)
Endif

Return _cRetMsg
