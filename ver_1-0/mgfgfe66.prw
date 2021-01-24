#Include "Protheus.ch"
#Include "FwMvcDef.ch"
#Include "FwMBrowse.ch"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFGFE66
Cadastro na Tabela (ZH7) Exceções RCTRC

@description
Manutenção (Inclusão/Alteração/Exclusão) na Tabela de Exceções RCTRC (ZH7)

@author Rogério Doms
@since 27/08/2020
@type Function

@table
ZH7 - Tabela Exceções RCTRC

@param

@return
_cret - Nulo

@menu
Gestão Frete Embarcador-Atualizações-Especifico-@ Exceções RCTRC

@history //Manter até as últimas 3 manutenções do fonte para facilitar identificação de versão, remover esse comentário
/*/   
User Function MGFGFE66()

	Local _oBrowse

	//Instanciamento da Classe de Browse
	_oBrowse := FWMBrowse():New()

	//Definição da tabela do Browse
	_oBrowse:SetAlias("ZH7")

	//Definição do título do browser
	_oBrowse:SetDescription( FWX2Nome("ZH7") )

	//Define legenda para o Browse de acordo com uma variavel
    //Obs: Para visuzalir as legenda em MVC basta dar duplo clique no marcador de legenda
	_oBrowse:AddLegend( "ZH7_SITUAC=='1'", "GREEN", "Ativo"  )
	_oBrowse:AddLegend( "ZH7_SITUAC=='2'", "RED"  , "Inativo"  )

	//Desabilita os detalhes que são habilitados para o Browse quando o usuário navega nos registros pelo Grid
	_oBrowse:DisableDetails()

	_oBrowse:Activate()

Return()


/*/
==============================================================================================================================================================================
{Protheus.doc} MenuDef()
Função para criar o Menu (Vizualizar/Incluir/Alterar/Excluir)

@author Rogério Doms
@since 27/08/2020
@type Function

@param

@return
	_aRotina - Array com os botões
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
Função para Definição do Modelo de Dados para Cadastro de Exceções RCTRC

@author Rogério Doms
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

	//Determina se é opcional a inserção de detalhe
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
Função para Definição da Visualização da Tela

@author Rogério Doms
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
	_oView:EnableTitleView("VIEW_ZH7D", "Itens Exceções RCTRC" )

Return(_oView)


/*/
==============================================================================================================================================================================
{Protheus.doc} GFE66Grv()
Função para Alterar todos os Itens

@author Rogério Doms
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
Função para Validar a Data de Vigência

@author Rogério Doms
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
		//U_MGFmsg("Data Vigência Até Deve ser Superior a Data Vigência De ")
		_lRet := .F.
	EndIf

Return(_lRet)


/*/
==============================================================================================================================================================================
{Protheus.doc} ValTabela()
Função para Validar se a Tabela Digitada Existe na Tabela SX2

@author Rogério Doms
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

	If _nOper == 4	//	ALTERAÇÃO
		//Valida existencia da Tabela na ZH7 Não Permite Alteração
		DBSelectArea("ZH7")
		ZH7->(DBSetOrder(01))
		If ZH7->(DBSeek(xFilial("ZH7") + _cCodigo + _cItem))
			U_MGFmsg("Não é Permitido ALTERAÇÃO. Campo [Tabela]")
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
		//U_MGFmsg("Valor Inválido (Tabela)")
		_lRet := .F.
	EndIf

Return(_lRet)


/*/
==============================================================================================================================================================================
{Protheus.doc} ValExpres()
Função para Validar e Informar a Expressão com os campos da Tabela Selecionada

@author Rogério Doms
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
		//Valida existencia da Tabela na ZH7 Não Permite Alteração
		DBSelectArea("ZH7")
		ZH7->(DBSetOrder(01))
		If ZH7->(DBSeek(xFilial("ZH7") + _cCodigo + _cItem))
			U_MGFmsg("Não Permite Alteração. Campo [Expressão}")
			_oModel:LoadValue("ZH7DETAIL","ZH7_EXPRES",Upper(Alltrim(ZH7->ZH7_EXPRES)))
			_oModel:LoadValue("ZH7DETAIL","ZH7_EXPSIM",Upper(Alltrim(ZH7->ZH7_EXPSIM)))
			Return(.T.)
		EndIf
	EndIf

	DBSelectArea(_cTabela)

	_cExpres := BuildExpr(_cTabela,,,.T.,,,)
	_cExpres := Upper(Alltrim(StrTran(_cExpres,".","")))

	If Len(_cExpres) > TamSX3("ZH7_EXPRES")[1]
		U_MGFmsg("O tamanho da Expressão (" + cValToChar(Len(_cExpres)) + ") é maior do que o sistema comporta (" + cValTochar(TamSX3("ZH7_EXPRES")[1]) + ")")
		Return(.F.)
	EndIf

	//Carrega a Expressão Simplificada
	_oModel:LoadValue("ZH7DETAIL","ZH7_EXPRES",_cExpres)
	_oModZH7D:SetValue("ZH7_EXPSIM", xCriaEsp(/*oModelZH7:GetValue("ZH7_EXPRES")*/ _cExpres, _cTabela ))

Return(.T.)


/*/
==============================================================================================================================================================================
{Protheus.doc} xCriaEsp(cExp,aTab)
Função para montar a Expressão com os Campos da Tabela

@author Rogério Doms
@since 27/08/2020
@type Function

@param
	_cExp - String - Espressão
	_aTab - Array  - Tabelas

@return
	cRet - String - Expressão
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
Função para montar a Expressão Simplificada com os Titulos dos Campos da Tabela

@author Rogério Doms
@since 27/08/2020
@type Function

@param
	_cXAlias - String - Tabela
	_cText   - string - expressão

@return
	cRet - String - Expressão Simplificada
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
Função para Gerar uma Planilha Excel

@author Rogério Doms
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

     //Criando o objeto que irá gerar o conteúdo do Excel
    _oFWMsExcel := FWMSExcel():New()

	_oFWMsExcel:AddworkSheet("Exceções")
	_oFWMsExcel:AddTable ( "Exceções" , "Regras das Exceções" )
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "Código"           /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "Descrição"        /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "DT.Vigência De"   /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "DT.Vigência Ate"  /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "Situação"         /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "Item"             /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "Tabela"           /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "Nome"             /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "Expressão"        /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "Exp.Simplificada" /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	_oFWMsExcel:AddColumn( "Exceções" /*cWorkSheet*/, "Regras das Exceções" /*cTable*/, "Observação"       /*cColumn*/, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
	
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

			_oFWMsExcel:AddRow( "Exceções" , "Regras das Exceções" , _aLinhaAux )

			(_cTMPZH7)->( DBSkip() )
	enddo

     
    //Ativando o arquivo e gerando o xml
    _oFWMsExcel:Activate()
    _oFWMsExcel:GetXMLFile(_cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    _oExcel := MsExcel():New()          //Abre uma nova conexão com Excel
    _oExcel:WorkBooks:Open(_cArquivo)	//Abre uma planilha
    _oExcel:SetVisible(.T.)             //Visualiza a planilha
    _oExcel:Destroy()                   //Encerra o processo do gerenciador de tarefas
     
    (_cTMPZH7)->( DbCloseArea() )

    RestArea( _aAreaZH7 )

Return()


/*/
==============================================================================================================================================================================
{Protheus.doc} PosvldZH7(_oMdl, _nLin)
Função para Validar duplicidade de Expressão

@author Rogério Doms
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
	_cMsgErr := "Expressão não informado."
Else
	For _nI := 1 to _oMdlZH7D:Length()
	 	If _nLin <> _nI	// Desconsidera a propria linha digitada
			_oMdlZH7D:GoLine(_nI)
			if !_oMdlZH7D:isDeleted()
				If _cExpres == _oMdlZH7D:GetValue("ZH7_EXPRES")
					_cMsgErr := "Expressão já cadastrada."
					Exit
				Endif
			Endif
		Endif
	Next
Endif

//Valida se expressão informada em outro regra de exceções
DBSelectArea("ZH7")
ZH7->( DBSetOrder(02) )
If ZH7->( DBSeek( xFILIAL("ZH7") + _cExpres ) )
	_cMsgErr := " Expressão já cadastrada na Regra: " + ZH7->ZH7_CODIGO + " - ( " + Alltrim(ZH7->ZH7_DESCR) + " ) no Item: ( " + ZH7->ZH7_ITEM + " )"
EndIf

If ! Empty(_cMsgErr)
	Help( ,, 'Não permitido',, _cMsgErr, 1, 0 )
	_lRet := .F.
Endif

FWRestRows( _aSaveLines )

RestArea( _aAreaZH7 )

Return _lRet 


