#Include "Protheus.ch"
#Include "FwMvcDef.ch"
#Include "FwMBrowse.ch"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFGFE66
Cadastro na Tabela (ZH7) Exce��es RCTRC

@description
Manuten��o (Inclus�o/Altera��o/Exclus�o) na Tabela de Exce��es RCTRC (ZH7)

@author Rog�rio Doms
@since 27/08/2020
@type Function

@table
ZH7 - Tabela Exce��es RCTRC

@param

@return
_cret - Nulo

@menu
Gest�o Frete Embarcador-Atualiza��es-Especifico-@ Exce��es RCTRC

@history //Manter at� as �ltimas 3 manuten��es do fonte para facilitar identifica��o de vers�o, remover esse coment�rio
/*/   
User Function MGFGFE66()

	Local _oBrowse

	//Instanciamento da Classe de Browse
	_oBrowse := FWMBrowse():New()

	//Defini��o da tabela do Browse
	_oBrowse:SetAlias("ZH7")

	//Defini��o do t�tulo do browser
	_oBrowse:SetDescription( FWX2Nome("ZH7") )

	//Define legenda para o Browse de acordo com uma variavel
    //Obs: Para visuzalir as legenda em MVC basta dar duplo clique no marcador de legenda
	_oBrowse:AddLegend( "ZH7_SITUAC=='1'", "GREEN", "Ativo"  )
	_oBrowse:AddLegend( "ZH7_SITUAC=='2'", "RED"  , "Inativo"  )

	//Desabilita os detalhes que s�o habilitados para o Browse quando o usu�rio navega nos registros pelo Grid
	_oBrowse:DisableDetails()

	_oBrowse:Activate()

Return()


/*/
==============================================================================================================================================================================
{Protheus.doc} MenuDef()
Fun��o para criar o Menu (Vizualizar/Incluir/Alterar/Excluir)

@author Rog�rio Doms
@since 27/08/2020
@type Function

@param

@return
	_aRotina - Array com os bot�es
/*/
Static Function MenuDef()

	Local _aRotina := {}

	ADD OPTION _aRotina TITLE "Visualizar"  ACTION "VIEWDEF.MGFGFE66"   OPERATION 2 ACCESS 0
	ADD OPTION _aRotina TITLE "Incluir"     ACTION "VIEWDEF.MGFGFE66"   OPERATION 3 ACCESS 0
	ADD OPTION _aRotina TITLE "Alterar"     ACTION "VIEWDEF.MGFGFE66"   OPERATION 4 ACCESS 0
	ADD OPTION _aRotina TITLE "Excluir"     ACTION "VIEWDEF.MGFGFE66"   OPERATION 5 ACCESS 0
	ADD OPTION _aRotina TITLE "Exp.Excel"   ACTION "U_GFE66EXCEL" 	  	OPERATION 6 ACCESS 0

Return( _aRotina )


/*/
==============================================================================================================================================================================
{Protheus.doc} ModelDef()
Fun��o para Defini��o do Modelo de Dados para Cadastro de Exce��es RCTRC

@author Rog�rio Doms
@since 27/08/2020
@type Function

@param

@return
	_oModel - Objeto
/*/
Static Function ModelDef()

	Local _oModel
	Local _oStruZH7M := FWFormStruct( 1, "ZH7", { |x| AllTrim(x) $ "ZH7_FILIAL|ZH7_CODIGO|ZH7_DESCR|ZH7_VIGDE|ZH7_VIGATE|ZH7_SITUAC" } )
	Local _oStruZH7D := FWFormStruct( 1, "ZH7", { |x| AllTrim(x) $ "ZH7_ITEM|ZH7_TABELA|ZH7_NOME|ZH7_EXPRES|ZH7_EXPSIM|ZH7_OBS" } )

	_oModel := MPFormModel():New('zMGFGFE66', /*bMPFormModelo*/, { | oModel | GFE66Grv()} /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	_oModel:AddFields("ZH7MASTER", /*cOwner*/, _oStruZH7M, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	
	_oModel:AddGrid("ZH7DETAIL", "ZH7MASTER", _oStruZH7D, /*bLinePre*/, {|a,b| PosvldZH7(a,b)}/*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	
	//Faz relaciomaneto entre os compomentes do model
	_oModel:SetRelation("ZH7DETAIL", { { "ZH7_FILIAL", 'xFilial("ZH7")' }, { "ZH7_CODIGO", "ZH7_CODIGO" } }, ZH7->( IndexKey( 1 ) ) )

	//Chave Promaria
	_oModel:SetPrimaryKey( { "ZH7_FILIAL", "ZH7_CODIGO", "ZH7_ITEM" } )

	//Liga o controle de nao repeticao de linha
	_oModel:GetModel("ZH7DETAIL"):SetUniqueLine( {"ZH7_ITEM"} )

	//Determina se � opcional a inser��o de detalhe
	_oModel:GetModel("ZH7DETAIL"):SetOptional( .F. )

	//Adiciona a descricao do Modelo de Dados
	_oModel:SetDescription( FWX2Nome("ZH7" ) )

	_oModel:GetModel("ZH7MASTER"):SetDescription( FWX2Nome("ZH7" ) )

	_oStruZH7M:SetProperty("ZH7_VIGATE"	, MODEL_FIELD_VALID	,{|| VDtVigAte() })
	_oStruZH7D:SetProperty("ZH7_TABELA"	, MODEL_FIELD_VALID	,{|| ValTabela() })
	_oStruZH7D:SetProperty("ZH7_EXPRES"	, MODEL_FIELD_VALID	,{|| ValExpres() })

Return(_oModel)


/*/
==============================================================================================================================================================================
{Protheus.doc} ViewDef()
Fun��o para Defini��o da Visualiza��o da Tela

@author Rog�rio Doms
@since 27/08/2020
@type Function

@param

@return
	_oView - Objeto
/*/
Static Function ViewDef()

	Local _oView
	Local _oModelVd	 := ModelDef()
	Local _oStruZH7M := FWFormStruct( 2, "ZH7", { |x| AllTrim(x) $ "ZH7_FILIAL|ZH7_CODIGO|ZH7_DESCR|ZH7_VIGDE|ZH7_VIGATE|ZH7_SITUAC" } )
	Local _oStruZH7D := FWFormStruct( 2, "ZH7", { |x| AllTrim(x) $ "ZH7_ITEM|ZH7_TABELA|ZH7_NOME|ZH7_EXPRES|ZH7_EXPSIM|ZH7_OBS" } )

	// Cria o objeto de View
	_oView := FWFormView():New()
	_oView:SetModel(_oModelVd)

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	_oView:AddField("VIEW_ZH7M", _oStruZH7M, "ZH7MASTER" )
	_oView:AddGrid("VIEW_ZH7D", _oStruZH7D, "ZH7DETAIL" )
	
	_oView:AddIncrementField( 'VIEW_ZH7D', 'ZH7_ITEM' )

	//Criar um "box" horizontal para receber algum elemento da view
	_oView:CreateHorizontalBox("SUPERIOR", 20 )
	_oView:CreateHorizontalBox("INFERIOR1", 80 )

	//Relaciona o ID da View com o "box" para exibicao
	_oView:SetOwnerView("VIEW_ZH7M", "SUPERIOR" )
	_oView:SetOwnerView("VIEW_ZH7D", "INFERIOR1" )

	//Liga a identificacao do componente
	_oView:EnableTitleView("VIEW_ZH7D", "Itens Exce��es RCTRC" )

Return(_oView)


/*/
==============================================================================================================================================================================
{Protheus.doc} GFE66Grv()
Fun��o para Alterar todos os Itens

@author Rog�rio Doms
@since 28/08/2020
@type Function

@param

@return
	_lRet - Verdadeiro
/*/
Static Function GFE66Grv()

	Local _oModel   := FWModelActive()
	Local _oModZH7M := _oModel:GetModel('ZH7MASTER')
	Local _cCodigo  := _oModZH7M:GetValue("ZH7_CODIGO")
	Local _nOper	:= _oModel:GetOperation()
	Local _lRet     := .T.

	If _nOper == 4
		DBSelectArea("ZH7")
		ZH7->(DBSetOrder(01))
		ZH7->(DBSeek( xFilial("ZH7") + _cCodigo ))
		While !ZH7->(Eof()) .and. ZH7->ZH7_CODIGO == _cCodigo
			ZH7->( RecLock("ZH7",.F.) )
				ZH7->ZH7_VIGDE  := _oModZH7M:GetValue("ZH7_VIGDE")
				ZH7->ZH7_VIGATE := _oModZH7M:GetValue("ZH7_VIGATE")
				ZH7->ZH7_SITUAC := _oModZH7M:GetValue("ZH7_SITUAC")
			ZH7->( MsUnLock() )	

			ZH7->( DBSkip() )
		EndDo
			
	EndIf

Return(_lRet)


/*/
==============================================================================================================================================================================
{Protheus.doc} ValDtVig()
Fun��o para Validar a Data de Vig�ncia

@author Rog�rio Doms
@since 27/08/2020
@type Function

@param

@return
	_lRet - Verdadeiro
/*/
Static Function VDtVigAte()

	Local _oModel	 := FWModelActive()
	Local _oModZH7M  := _oModel:GetModel('ZH7MASTER')
	Local _dDtVigDe  := _oModZH7M:GetValue("ZH7_VIGDE")
	Local _dDtVigAte := _oModZH7M:GetValue("ZH7_VIGATE")
	Local _lRet      := .T.

	//Valida Data de Vigencia Ate
	If _dDtVigAte < _dDtVigDe
		//U_MGFmsg("Data Vig�ncia At� Deve ser Superior a Data Vig�ncia De ")
		_lRet := .F.
	EndIf

Return(_lRet)


/*/
==============================================================================================================================================================================
{Protheus.doc} ValTabela()
Fun��o para Validar se a Tabela Digitada Existe na Tabela SX2

@author Rog�rio Doms
@since 27/08/2020
@type Function

@param

@return
	_lRet - Verdadeiro
/*/
Static Function ValTabela()

	Local _oModel	:= FWModelActive()
	Local _oModZH7M := _oModel:GetModel('ZH7MASTER')
	Local _oModZH7D := _oModel:GetModel('ZH7DETAIL')
	Local _cCodigo  := _oModZH7M:GetValue("ZH7_CODIGO")
	Local _cTabela  := _oModZH7D:GetValue("ZH7_TABELA")
	Local _cItem    := _oModZH7D:GetValue("ZH7_ITEM")
	Local _nOper	:= _oModel:GetOperation()
	Local _lRet     := .T.

	If _nOper == 4	//	ALTERA��O
		//Valida existencia da Tabela na ZH7 N�o Permite Altera��o
		DBSelectArea("ZH7")
		ZH7->(DBSetOrder(01))
		If ZH7->(DBSeek(xFilial("ZH7") + _cCodigo + _cItem))
			U_MGFmsg("N�o � Permitido ALTERA��O. Campo [Tabela]")
			_oModel:LoadValue("ZH7DETAIL","ZH7_TABELA",Alltrim(ZH7->ZH7_TABELA))
			Return(.T.)
		EndIf
	EndIf

	//Posiciona na Tabela SX2
	DBSelectArea("SX2")
	SX2->(DBSetOrder(01))
	If SX2->(DBSeek( _cTabela ))
		_oModel:LoadValue("ZH7DETAIL","ZH7_NOME",Alltrim(SX2->X2_NOME))
		_lRet := .T.
	Else
		//U_MGFmsg("Valor Inv�lido (Tabela)")
		_lRet := .F.
	EndIf

Return(_lRet)


/*/
==============================================================================================================================================================================
{Protheus.doc} ValExpres()
Fun��o para Validar e Informar a Express�o com os campos da Tabela Selecionada

@author Rog�rio Doms
@since 27/08/2020
@type Function

@param

@return
	_lRet - Verdadeiro
/*/
Static Function ValExpres()

	Local _oModel   := FWModelActive()
	Local _oModZH7M := _oModel:GetModel('ZH7MASTER')
	Local _oModZH7D := _oModel:GetModel('ZH7DETAIL')
	Local _cCodigo  := _oModZH7M:GetValue("ZH7_CODIGO")
	Local _cTabela  := _oModZH7D:GetValue("ZH7_TABELA")
	Local _cItem    := _oModZH7D:GetValue("ZH7_ITEM")
	Local _nOper	:= _oModel:GetOperation()
	Local _cExpres  := ""
	Local _lRet     := .T.
	Local _nI       := 0

	If _nOper == 4
		//Valida existencia da Tabela na ZH7 N�o Permite Altera��o
		DBSelectArea("ZH7")
		ZH7->(DBSetOrder(01))
		If ZH7->(DBSeek(xFilial("ZH7") + _cCodigo + _cItem))
			U_MGFmsg("N�o Permite Altera��o. Campo [Express�o}")
			_oModel:LoadValue("ZH7DETAIL","ZH7_EXPRES",Upper(Alltrim(ZH7->ZH7_EXPRES)))
			_oModel:LoadValue("ZH7DETAIL","ZH7_EXPSIM",Upper(Alltrim(ZH7->ZH7_EXPSIM)))
			Return(.T.)
		EndIf
	EndIf

	DBSelectArea(_cTabela)

	_cExpres := BuildExpr(_cTabela,,,.T.,,,)
	_cExpres := Upper(Alltrim(StrTran(_cExpres,".","")))

	If Len(_cExpres) > TamSX3("ZH7_EXPRES")[1]
		U_MGFmsg("O tamanho da Express�o (" + cValToChar(Len(_cExpres)) + ") � maior do que o sistema comporta (" + cValTochar(TamSX3("ZH7_EXPRES")[1]) + ")")
		Return(.F.)
	EndIf

	//Carrega a Express�o Simplificada
	_oModel:LoadValue("ZH7DETAIL","ZH7_EXPRES",_cExpres)
	_oModZH7D:SetValue("ZH7_EXPSIM", xCriaEsp(/*oModelZH7:GetValue("ZH7_EXPRES")*/ _cExpres, _cTabela ))

Return(.T.)


/*/
==============================================================================================================================================================================
{Protheus.doc} xCriaEsp(cExp,aTab)
Fun��o para montar a Express�o com os Campos da Tabela

@author Rog�rio Doms
@since 27/08/2020
@type Function

@param
	_cExp - String - Espress�o
	_aTab - Array  - Tabelas

@return
	cRet - String - Express�o
/*/
Static Function xCriaEsp(_cExp,_cTab)

	Local _aArea := GetArea()
	Local _cRet  := _cExp
	Local _nI    := 0

	_cRet := xFieldTab(_cTab,_cRet)

	//Substitui os AND
	_cRet := StrTran( _cRet, "AND", "E" )

	//Substitui os OR
	_cRet := StrTran( _cRet, "OR", "OU" )

	RestArea(_aArea)

Return(Upper(_cRet))


/*/
==============================================================================================================================================================================
{Protheus.doc} xFieldTab(cxAlias,cText)
Fun��o para montar a Express�o Simplificada com os Titulos dos Campos da Tabela

@author Rog�rio Doms
@since 27/08/2020
@type Function

@param
	_cXAlias - String - Tabela
	_cText   - string - express�o

@return
	cRet - String - Express�o Simplificada
/*/
Static Function xFieldTab(_cXAlias,_cText)

	Local _cRet := _cText
	Local _cNextAlias := GetNextAlias()

	BeginSql Alias _cNextAlias

		SELECT
			X3_CAMPO,
			X3_TITULO
		FROM SX3010 X3
		WHERE X3.%NotDel%
		  AND X3.X3_ARQUIVO = %Exp:_cXAlias%
		ORDER BY X3_ORDEM

	EndSql

	While (_cNextAlias)->(!Eof() )
		_cRet := StrTran( _cRet, AllTrim((_cNextAlias)->X3_CAMPO), Alltrim((_cNextAlias)->X3_TITULO) )
		(_cNextAlias)->(DBSkip())
	EndDo

	(_cNextAlias)->(DBCloseArea())

Return(_cRet)


/*/
==============================================================================================================================================================================
{Protheus.doc} GFE66EXCEL()
Fun��o para Gerar uma Planilha Excel

@author Rog�rio Doms
@since 28/08/2020
@type Function

@param

@return
	cRet - Nulo 
/*/
User Function GFE66EXCEL()

    Local _aAreaZH7   := ZH7->(GetArea())
	lOCAL _cTMPZH7    := GetNextAlias()
    Local _cArquivo   := GetTempPath() + 'MGFGFE66.xml'
	Local _aLinhaAux  := {}
    Local _oFWMsExcel
    Local _oExcel

	//Seleciona Registros ZH7
	BeginSql Alias _cTMPZH7

		SELECT *
		FROM 
		    %Table:ZH7% ZH7
		WHERE 
		    ZH7.%NotDel% AND
			ZH7.ZH7_FILIAL = %xFilial:ZH7%

		ORDER BY ZH7_FILIAL, ZH7_CODIGO, ZH7_ITEM

	EndSql

     //Criando o objeto que ir� gerar o conte�do do Excel
    _oFWMsExcel := FWMSExcel():New()

	_oFWMsExcel:AddworkSheet("Exce��es")
	_oFWMsExcel:AddTable ( "Exce��es" , "Regras das Exce��es" )
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "C�digo"           /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "Descri��o"        /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "DT.Vig�ncia De"   /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "DT.Vig�ncia Ate"  /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "Situa��o"         /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "Item"             /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "Tabela"           /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "Nome"             /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "Express�o"        /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "Exp.Simplificada" /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exce��es" /*cWorkSheet*/, "Regras das Exce��es" /*cTable*/, "Observa��o"       /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	
	while (_cTMPZH7)->( !EoF() )
			_aLinhaAux := {}

			aadd( _aLinhaAux , (_cTMPZH7)->ZH7_CODIGO			     )
			aadd( _aLinhaAux , (_cTMPZH7)->ZH7_DESCR				     )
			aadd( _aLinhaAux , DTOC( STOD( (_cTMPZH7)->ZH7_VIGDE )  ) )
			aadd( _aLinhaAux , DTOC( STOD( (_cTMPZH7)->ZH7_VIGATE ) ) )
			aadd( _aLinhaAux , IIf((_cTMPZH7)->ZH7_SITUAC == '1', 'Ativo', 'Inativo') )
			aadd( _aLinhaAux , (_cTMPZH7)->ZH7_ITEM 					  )
			aadd( _aLinhaAux , (_cTMPZH7)->ZH7_TABELA				  )
			aadd( _aLinhaAux , (_cTMPZH7)->ZH7_NOME					  )
			aadd( _aLinhaAux , (_cTMPZH7)->ZH7_EXPRES				  )
			aadd( _aLinhaAux , (_cTMPZH7)->ZH7_EXPSIM				  )
			aadd( _aLinhaAux , (_cTMPZH7)->ZH7_OBS					  )

			_oFWMsExcel:AddRow( "Exce��es" , "Regras das Exce��es" , _aLinhaAux )

			(_cTMPZH7)->( DBSkip() )
	enddo

     
    //Ativando o arquivo e gerando o xml
    _oFWMsExcel:Activate()
    _oFWMsExcel:GetXMLFile(_cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    _oExcel := MsExcel():New()          //Abre uma nova conex�o com Excel
    _oExcel:WorkBooks:Open(_cArquivo)	//Abre uma planilha
    _oExcel:SetVisible(.T.)             //Visualiza a planilha
    _oExcel:Destroy()                   //Encerra o processo do gerenciador de tarefas
     
    (_cTMPZH7)->( DbCloseArea() )

    RestArea( _aAreaZH7 )

Return()


/*/
==============================================================================================================================================================================
{Protheus.doc} PosvldZH7(_oMdl, _nLin)
Fun��o para Validar duplicidade de Express�o

@author Rog�rio Doms
@since 27/08/2020
@type Function

@param
	_oMdl - Objeto   - Model
	_nLin - Numerico - Linha da Grid

@return
	_lRet - Booleand - Verdadeiro/Falso
/*/
Static Function PosvldZH7(_oMdl, _nLin)

Local _aAreaZH7     := ZH7->(GetArea())
Local _oModel 		:= FWModelActive()
Local _aSaveLines	:= FWSaveRows()
Local _oMdlZH7D		:= _oModel:GetModel('ZH7DETAIL')
Local _cExpres		:= _oMdlZH7D:GetValue("ZH7_EXPRES")
Local _cMsgErr		:= ""
Local _nI			:= 0
Local _lRet			:= .T.

If Empty(_cExpres)
	_cMsgErr := "Express�o n�o informado."
Else
	For _nI := 1 to _oMdlZH7D:Length()
	 	If _nLin <> _nI	// Desconsidera a propria linha digitada
			_oMdlZH7D:GoLine(_nI)
			if !_oMdlZH7D:isDeleted()
				If _cExpres == _oMdlZH7D:GetValue("ZH7_EXPRES")
					_cMsgErr := "Express�o j� cadastrada."
					Exit
				Endif
			Endif
		Endif
	Next
Endif

//Valida se express�o informada em outro regra de exce��es
DBSelectArea("ZH7")
ZH7->( DBSetOrder(02) )
If ZH7->( DBSeek( xFILIAL("ZH7") + _cExpres ) )
	_cMsgErr := " Express�o j� cadastrada na Regra: " + ZH7->ZH7_CODIGO + " - ( " + Alltrim(ZH7->ZH7_DESCR) + " ) no Item: ( " + ZH7->ZH7_ITEM + " )"
EndIf

If ! Empty(_cMsgErr)
	Help( ,, 'N�o permitido',, _cMsgErr, 1, 0 )
	_lRet := .F.
Endif

FWRestRows( _aSaveLines )

RestArea( _aAreaZH7 )

Return _lRet 


