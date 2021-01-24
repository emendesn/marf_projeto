#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

//Variáveis Estáticas
Static cTitulo := "Solicitação Financeira (Prorrogação & Desconto)"

/*/
==============================================================================================================================================================================
Descrição   : Controle de solicitações de desconto financeiro e prorrogações de títulos

@description
Informar quais titulos desejados, e estes sofrerão aprovação ou  rejeição.
Títulos prorrogados terão eu vencimento alterado
Títulos com desconto, terão a inclusao do equivalente, com o tipo NCC

@author     : Renato Junior
@since      : 15/07/2020
@type       : User Function

@table ZGQ -   Solicitação Financeira

@menu
Financeiro - Atualizações-Especificos MARFRIG

@history 
/*/   
User Function MGFFINBR()
Local aArea   := GetArea()
Local oBrowse
Local _cxUser	:=	RetCodUsr()

Private cNomUsu	:= Padr(UsrFullName(RetCodUsr()),TamSx3("ZGQ_USUARI")[1])

If 	! ZGR->( DBSETORDER(2), dbSeek( XFILIAL("ZGR") + _cxUser + "S" ) )	.OR. (ZGR->ZGR_GATIVO = 'N' .OR. ZGR->ZGR_ATIVO == 'N')
	Help(" ",1,"NAOSOLICITA",,"Você não é Solicitante , Grupo ou Usuário está inativo"+CHR(10)+"Por favor, verifique os Grupos",1,0) //###
	ZGR->( DBSETORDER(1))
Else
	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("ZGQ")
	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)
	oBrowse:SetFilterDefault("ZGQ->ZGQ_CODGRU == '"+ZGR->ZGR_CODIGO+"'")
	//Legendas
	oBrowse:AddLegend( "ZGQ->ZGQ_STATUS == 'E'"     						, "BR_CINZA","Em Análise" )
	oBrowse:AddLegend( "'PROCESSAMENTO OK' $ ALLTRIM(ZGQ->ZGQ_STPROC)"      , "GREEN"	,"Processamento Ok" )
	oBrowse:AddLegend( "EMPTY(ZGQ->ZGQ_STATUS) .AND. ZGQ->ZGQ_DESCON > 0"	, "BLUE"	,"Desconto Pendente" )
	oBrowse:AddLegend( "EMPTY(ZGQ->ZGQ_STATUS) .AND. ZGQ->ZGQ_DESCON == 0"	, "YELLOW"	,"Prorrogação Pendente" )
	oBrowse:AddLegend( "! 'PROCESSAMENTO OK' $ ALLTRIM(ZGQ->ZGQ_STPROC)"    , "RED"		,"Erro ao Processar" )

	//Ativa a Browse
	oBrowse:Activate()
	RestArea(aArea)

Endif

Return Nil

//
Static Function MenuDef()
	Local aRotina := {}
	//Adicionando opções
	ADD OPTION aRotina TITLE 'Pesquisar'  	ACTION 'PesqBrw'			OPERATION 1	ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.MGFFINBR'	OPERATION 2	ACCESS 0 //OPERATION 1 MODEL_OPERATION_VIEW
	ADD OPTION aRotina TITLE 'Incluir'		ACTION 'VIEWDEF.MGFFINBR'	OPERATION 3	ACCESS 0 //OPERATION 3 MODEL_OPERATION_INSERT
	ADD OPTION aRotina TITLE 'Alterar'		ACTION 'VIEWDEF.MGFFINBR'	OPERATION 4	ACCESS 0 //OPERATION 4 MODEL_OPERATION_UPDATE
	ADD OPTION aRotina TITLE 'Excluir'		ACTION 'VIEWDEF.MGFFINBR'	OPERATION 5	ACCESS 0 //OPERATION 5 MODEL_OPERATION_DELETE
	ADD OPTION aRotina TITLE 'Log de Erro'	ACTION 'u_FINBR_Log'     	OPERATION 6	ACCESS 0 //OPERATION X
	ADD OPTION aRotina TITLE 'Envia Aprov'	ACTION 'u_FINBR_Env'      	OPERATION 6	ACCESS 0 //OPERATION X
Return aRotina

//
Static Function ModelDef()
	//Criação do objeto do modelo de dados
	Local oModel := Nil
	
	//Criação da estrutura de dados utilizada na interface
	Local oStZGQ := FWFormStruct(1, "ZGQ")
	
	//Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("mMGFFINBR", {|oModel|ZGQPre(oModel)}/*bPre*/, {|oModel|ZGQPos(oModel) } /*bPos*/, {|oModel|ZGQCmt(oModel) }/*bCommit*/,/*bCancel*/) 
	
	//Atribuindo formulários para o modelo
	oModel:AddFields("FORMZGQ",/*cOwner*/,oStZGQ)

	//Setando a chave primária da rotina
	oModel:SetPrimaryKey({'ZGQ_FILIAL','ZGQ_ID'})
	
	//Adicionando descrição ao modelo
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
	
	//Setando a descrição do formulário
	oModel:GetModel("FORMZGQ"):SetDescription("Formulário do Cadastro "+cTitulo)

	oStZGQ:SetProperty("ZGQ_ID",MODEL_FIELD_INIT,{||GETSXENUM('ZGQ','ZGQ_ID')})

Return oModel

//
Static Function ViewDef()
	//Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("MGFFINBR")
//	Local cFldZGQ   := "ZGQ_FILTIT,ZGQ_DTHORA,ZGQ_USUARI,ZGQ_STATUS,ZGQ_STPROC,ZGQ_RECSE1,ZGQ_NIVEL,ZGQ_USRAPR,ZGQ_DTHAPR"
	Local cFldZGQ   := "ZGQ_DTHORA,ZGQ_USUARI,ZGQ_STATUS,ZGQ_STPROC,ZGQ_RECSE1,ZGQ_NIVEL,ZGQ_USRAPR,ZGQ_DTHAPR,ZGQ_USRCIE,ZGQ_DTHCIE"
	//Criação da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStZGQ := FWFormStruct(2, "ZGQ",{|cCampo|!(AllTrim(cCampo) $ cFldZGQ)})
	
	//Criando oView como nulo
	Local oView := Nil
	//Criando a view que será o retorno da função e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formulários para interface
	oView:AddField("VIEW_ZGQ", oStZGQ, "FORMZGQ")
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando título do formulário
	oView:EnableTitleView('VIEW_ZGQ', 'Dados do Grupo de Produtos' )  
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
	//O formulário da interface será colocado dentro do container
	oView:SetOwnerView("VIEW_ZGQ","TELA")
Return oView

/*/{Protheus.doc} FINBR_Leg
Função para mostrar a legenda das rotinas MVC

@author Renato Bandeira
@since 21/07/2020
/*/
User Function FINBR_Leg()
	Local aLegenda := {}
	//Monta as cores
	AADD(aLegenda,{"BR_CINZA",		"Em Análise"  })
	AADD(aLegenda,{"BR_VERDE",		"Processamento Ok"  })
	AADD(aLegenda,{"BR_VERMELHO",	"Erro ao Processar"})
	AADD(aLegenda,{"BR_AZUL",       "Desconto Pendente"})
	AADD(aLegenda,{"BR_AMARELO",	"Prorrogação Pendente"})

	BrwLegenda("Situação da Solicitação", "Status", aLegenda)
Return

/*/{Protheus.doc} FINBR_Log
Função para mostrar o Log de Erros e Reprocessar

@author Renato Bandeira
@since 21/07/2020
/*/
User Function FINBR_Log()
Local _cArqErro	:=	ALLTRIM(ZGQ->ZGQ_STPROC)

// Se Aprovado e Status <> OK
If ZGQ->ZGQ_STATUS == "A"	.AND. _cArqErro	 <> 'PROCESSAMENTO OK'
	DEFINE MSDIALOG oDlg TITLE "Log de Erros na Importação" From 0,0 TO 340,550 OF oMainWnd PIXEL
	cShowErr := MemoRead(_cArqErro)
	@ 5,5 GET oMemo Var cShowErr Of oDlg MEMO SIZE 267,145 PIXEL
	oMemo:brClicked := {||AllwaysTrue()}

	DEFINE SBUTTON FROM 153,230 TYPE 01 ACTION oDlg:End() ENABLE OF oDlg PIXEL
	DEFINE SBUTTON FROM 153,200 TYPE 19 ACTION (FINBRReproc(),oDlg:End()) ENABLE ONSTOP "Reprocessa" OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTER
Endif	

Return


/*/{Protheus.doc} FINBRReproc
Função para reprocessar o titulo Selecionado

@author Renato Bandeira
@since 21/07/2020
/*/
Static Function FINBRReproc()
If ZGQ->ZGQ_RECSE1 > 0
	MsgAlert("Tipo NCC não pode reprocessar, corrija manualmente.")
Else
	Processa({|| u_GerTitSel({{cEmpAnt,/*ALLTRIM(ZGQ->ZGQ_FILIAL)+"0001"*/ ZGQ->ZGQ_FILTIT ,ZGQ->ZGQ_PREFIX, ZGQ->ZGQ_NUM, ZGQ->ZGQ_PARCEL, ZGQ->ZGQ_TIPO, ;
	ZGQ->ZGQ_CLIENT, ZGQ->ZGQ_LOJA , ZGQ->ZGQ_NOVENC, ZGQ->ZGQ_DESCON, ZGQ->ZGQ_ID, ZGQ->ZGQ_RECSE1, ZGQ->ZGQ_NATURE, ZGQ->ZGQ_MOTSOL }}) }, ;
	'Aguarde...' , 'Efetivando Solicitação Financeira... ',.T.)
Endif
Return Nil


/*/{Protheus.doc} FINBREnv
Função para Marcar o Status "E" - enviado para Análise

@author Renato Bandeira
@since 21/07/2020
/*/
User Function FINBR_Env()
Local cQuery		:= ''
Local _lRet			:= .T.
Local cNextAlias	:= GetNextAlias()
Local _aNivel	:=	{}

cQuery  := ''
cQuery  += " SELECT R_E_C_N_O_ AS POSICA FROM "+RetSqlName("ZGQ")+" ZGQ "
cQuery  += " WHERE ZGQ.D_E_L_E_T_ = ' ' AND ZGQ_STATUS = ' ' "
cQuery  += " AND ZGQ_USUARI = '"+ cNomUsu+"' "

If Select(cNextAlias) > 0
	(cNextAlias)->(DbClosearea())
Endif
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
dbSelectArea(cNextAlias)
(cNextAlias)->(dbGoTop())

While ! (cNextAlias)->(Eof())
	ZGQ->( DBGOTO( (cNextAlias)->POSICA))
	If ZGQ->( RECLOCK("ZGQ",.F.))
	    ZGQ->ZGQ_STATUS  :=  "E"
	    ZGQ->ZGQ_NIVEL   :=  SOMA1(ZGQ->ZGQ_NIVEL)
   		ZGQ->( MSUNLOCK())
		If ASCAN(_aNivel, ZGQ->ZGQ_NIVEL+ZGR->ZGR_CODIGO )	== 0
			AADD(_aNivel, ZGQ->ZGQ_NIVEL+ZGR->ZGR_CODIGO)
		Endif
	Endif
	(cNextAlias)->(Dbskip())
Enddo
If Select(cNextAlias) > 0
	(cNextAlias)->(DbClosearea())
Endif

// Envia e-mail para usarios do nivel 
Processa({|| U_FINBREmail(_aNivel) },'Aguarde...' , 'Enviando E-mail para Analise Financeira... ',.T.)

Return Nil


/*/{Protheus.doc} ZGQPre
Função para verificar se é valido

@author Renato Bandeira
@since 21/07/2020
/*/
Static Function ZGQPre( oModel )
Local nOperation	:= oModel:GetOperation()
Local lRet			:= .T.

//If nOperation <> MODEL_OPERATION_INSERT	.AND. ! EMPTY(oModel:GetValue('FORMZGQ','ZGQ_STATUS'))
If (nOperation == MODEL_OPERATION_UPDATE .OR. nOperation == MODEL_OPERATION_DELETE)	.AND. ! EMPTY(oModel:GetValue('FORMZGQ','ZGQ_STATUS'))
	Help( ,, 'Não permitido',, "Em Análise ou Aprovado", 1, 0 )
	lRet	:= .F.
Endif

Return lRet

/*/{Protheus.doc} ZGQCmt
Função para gravar e confirmar numero sequencial

@author Renato Bandeira
@since 21/07/2020
/*/
Static function ZGQCmt( oModel )
Local lRet		:= .T.
Local nOperation    := oModel:GetOperation()

If oModel:VldData()
	FwFormCommit( oModel )
	oModel:DeActivate()
	confirmSX8()
Else
	RollBackSX8()
	JurShowErro( oModel:GetModel():GetErrormessage() )
	lRet := .F.
	DisarmTransaction()
EndIf
Return lRet


/*/{Protheus.doc} ZGQPos
Função para efetuar validações

@author Renato Bandeira
@since 21/07/2020
/*/
Static Function ZGQPos( oModel )
local nOper		:= oModel:GetOperation()
local lRet		:= .T.
Local cDtHora	:= cValtoChar(GravaData(dDataBase, .T., 5 )) + " " + LEFT(TIME(),5)
//Local cNomUsu	:= Padr(UsrFullName(RetCodUsr()),TamSx3("ZGQ_USUARI")[1])
Local _lAchouE1 := .F.
Local _nSaldo	:= 0

If ! EMPTY(oModel:GetValue('FORMZGQ','ZGQ_STATUS'))
	Help( ,, 'Não permitido! ',, "Em Análise ou Aprovado", 1, 0 )
	lRet	:= .F.
Else
	If nOper == MODEL_OPERATION_INSERT	.OR. nOper == MODEL_OPERATION_UPDATE
		_lAchouE1	:= SE1->( DBSETORDER(2), DbSeek( XFILIAL("SE1") + M->( ZGQ_CLIENT+ZGQ_LOJA+ZGQ_PREFIX+ZGQ_NUM+ZGQ_PARCEL+ZGQ_TIPO)))
		If _lAchouE1
			oModel:SetValue('FORMZGQ','ZGQ_RECSE1', SE1->(RECNO()))
			_nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,,dDataBase,SE1->E1_LOJA)
		Endif
		If oModel:GetValue('FORMZGQ','ZGQ_DESCON')	> 0	// Desconto
			If EMPTY(oModel:GetValue('FORMZGQ','ZGQ_MOTSOL'))
				Help( ,, "Motivo é obrigatório para Desconto",, 'Não Informado !', 1, 0 )
				lRet	:= .F.
			ElseIf _lAchouE1	.AND. oModel:GetValue('FORMZGQ','ZGQ_TIPO')	== "NCC"
				Help( ,, "Não pode compensar Tipo NCC",, 'Titulo NCC já existe !', 1, 0,NIL,NIL,NIL,NIL,NIL,{"Informe título diferente de NCC neste caso"})
				lRet	:= .F.
			//ElseIf ! _lAchouE1	.AND. oModel:GetValue('FORMZGQ','ZGQ_TIPO')	<> "NCC"
			//	Help( ,, "Para novo desconto, tipo deve ser NCC",, 'Tipo Inválido !', 1, 0,NIL,NIL,NIL,NIL,NIL,{"Informe o tipo como NCC"})
			//	lRet	:= .F.
			ElseIf _lAchouE1	.AND. oModel:GetValue('FORMZGQ','ZGQ_DESCON')	> _nSaldo
				Help( ,, "Titulo a ser compensado tem saldo menor que o desconto",, 'Titulo com Saldo :'+Transform(_nSaldo,"@E 999,999,999.9999"), 1, 0,NIL,NIL,NIL,NIL,NIL,{"Verifique o saldo deste titulo"})
				lRet	:= .F.
			Endif
		ElseIf ! _lAchouE1	// Prorrogação
			Help( ,, "Na prorrogação, informar titulo existente",, 'Titulo Inexistente !', 1, 0 )
			lRet	:= .F.
		Endif
	Endif
	If nOper == MODEL_OPERATION_INSERT
		If EMPTY(oModel:GetValue('FORMZGQ','ZGQ_NOVENC'))	.AND. oModel:GetValue('FORMZGQ','ZGQ_DESCON')	== 0
			Help( ,, "Desconto ou Prorrogação",, 'Não Informado !', 1, 0 )
			lRet	:= .F.
		Else
			oModel:SetValue('FORMZGQ','ZGQ_DTHORA', cDtHora)
			oModel:SetValue('FORMZGQ','ZGQ_USUARI', cNomUsu)
		Endif
	Endif
Endif
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GerTitSel()
Efetua o Msexecauto dos titulos
@author Renato Junior

@since 15/07/2020
@return lRetSeg
/*/
//-------------------------------------------------------------------
User Function GerTitSel(aParametros)
Local _nOqFazer	    :=	0
Local nCtt          :=  0
Local _aParSE1	    :=	{}
Local aTitulo       := {}
Local cError        := ''
Local lIsBlind      :=  IsBlind() .OR. Type("__LocalDriver") == "U"	//FunName() == "MGFFINBR"	//
Local _nTotTit	    :=	len(aParametros)
local _cTITGERAD    :=  ""
Local lCtbOnLine := .F.
Local nHdlPrv := 0

DEFAULT lCtbOnLine	:= .F.
DEFAULT nHdlPrv		:= 0

ProcRegua( _nTotTit )
For nCtt	:=	1	TO _nTotTit
	IncProc("Executando solicitação : " + STR(nCtt))
	_aParSE1	:=	aParametros[nCtt]
	If lIsBlind	.AND.  nCtt ==   1
	    RpcSetType(3)
	    RpcSetEnv(_aParSE1[1],_aParSE1[2])
	Else
	    cFilAnt	:=	_aParSE1[2]
	Endif

	If _aParSE1[10] > 0	// 3 - Inclusao, 4 - Alteração, 5 - Exclusão
		_nOqFazer	:=	3
		nStackSX8 := GetSx8Len()
        _dVencto    :=  SE1->E1_VENCREA
	Else
		_nOqFazer	:=	4
		//Alteração deve ter o registro SE1 posicionado
    	lCont:= SE1->( DBSETORDER(1), DbSeek(xFilial("SE1")+_aParSE1[03]+_aParSE1[04]+_aParSE1[05]+_aParSE1[06]+_aParSE1[07]+_aParSE1[08]))
        _dVencto    :=  _aParSE1[09]
	Endif

    aTitulo := {}
    AADD(aTitulo, { "E1_PREFIXO"	, _aParSE1[03], NIL })
    AADD(aTitulo, { "E1_NUM"      	, _aParSE1[04], NIL })
    If 	_nOqFazer	==	4
        AADD(aTitulo, { "E1_PARCELA"	, _aParSE1[05], NIL })
        AADD(aTitulo, { "E1_TIPO"     , _aParSE1[06], NIL })
    Else
        AADD(aTitulo, { "E1_PARCELA"	, RParcNcc(SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)), NIL })
        AADD(aTitulo, { "E1_TIPO"     , "NCC"		, NIL })
    Endif
    AADD(aTitulo, { "E1_CLIENTE"  , _aParSE1[07], NIL })
    AADD(aTitulo, { "E1_LOJA"     , _aParSE1[08], NIL })
    If 	_nOqFazer	==	4
        AADD(aTitulo, { "E1_VENCTO"   , _dVencto, NIL })
        AADD(aTitulo, { "E1_VENCREA"  , _dVencto, NIL })
    Else
        AADD(aTitulo, { "E1_VENCTO"   , dDataBase        , NIL })
        AADD(aTitulo, { "E1_VENCREA"  , dDataBase        , NIL })
        AADD(aTitulo, { "E1_EMISSAO"  , dDataBase		, NIL })
        AADD(aTitulo, { "E1_VALOR"    , _aParSE1[10]	, NIL })
        AADD(aTitulo, { "E1_NATUREZ"  , _aParSE1[13]			, NIL })
    Endif
	If ! Empty(_aParSE1[14])
        AADD(aTitulo, { "E1_HIST"  , _aParSE1[14]			, NIL })
	EndIf
    AADD(aTitulo, { "E1_ZID0001"  , _aParSE1[11]		, NIL })

    lMsErroAuto := .F.
    MsExecAuto( { |x,y| FINA040(x,y)} , aTitulo, _nOqFazer)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
    If lMsErroAuto // SE ENCONTROU ALGUM ERRO
        If 	_nOqFazer	==	3
    		While GetSX8Len() > nStackSX8
			    ROLLBACKSX8()
    		EndDo
        Endif
//        If ! lIsBlind  // COM INTERFACE GRÁFICA	!IsBlind()
        If ! FUNNAME() == "MGFFINBS"  // COM INTERFACE GRÁFICA	!IsBlind()
        	MsgAlert("Erro na execução do titulo !")
		Endif
        _cZGQSTPROC  := "FINBR" + fwTimeStamp(1) +".log"
        cError := MostraErro("/dirdoc", _cZGQSTPROC) // ARMAZENA A MENSAGEM DE ERRO
        ConOut(PadC("MGFFINBR Automatic routine ended with error", 80))
        ConOut("Error: "+ cError)
        _cZGQSTPROC  := "\dirdoc\"+_cZGQSTPROC
        RollBackSx8()
        lRetSeg := .F.
    Else
        _cZGQSTPROC  := "PROCESSAMENTO OK"
        // Verifica se tem compensação na inclusão 
        If  _nOqFazer	==	3   .AND.   _aParSE1[12]    >   0    
            _cTITGERAD  += " ("+SE1->E1_PREFIXO+"/"+SE1->E1_NUM+"/"+SE1->E1_PARCELA+"/"+SE1->E1_TIPO+")"
			MaIntBxCR(3,{_aParSE1[12]},,{SE1->(RECNO())},,{lCtbOnLine,.F.,.F.,.F.,.F.,.F.},,,,,/*nSaldoComp*/,,nHdlPrv)
            If EMPTY(SE1->E1_BAIXA)  // Não conseguiu compensar
                _cZGQSTPROC  := "NAO COMPENSOU TITULO NCC"
            Endif
        Endif
        If 	_nOqFazer	==	3
    		While GetSX8Len() > nStackSX8
                CONFIRMSX8()
    		EndDo
        Endif
    Endif
    // Atualiza Status na ZGQ_STPROC
	If lIsBlind	.AND.  ZGQ->(DBSETORDER(1), DBSEEK( cFilAnt + _aParSE1[11]))
    Endif
    RECLOCK("ZGQ",.F.)
    ZGQ->ZGQ_STPROC  :=  _cZGQSTPROC + _cTITGERAD
    ZGQ->( MSUNLOCK())
Next
Return(lRetSeg)


//-------------------------------------------------------------------
/*/{Protheus.doc} RParcNcc()
Retorna a proxima parcela quando for inclusao de NCC
@author Renato Junior

@since 15/07/2020
@return - proxima parcela - formato 99
/*/
//-------------------------------------------------------------------
Static Function RParcNcc( _cChvNCC)
local _cRetParc :=  "01"

If SE1->( Dbsetorder(2) ,DbSeek(_cChvNCC))
    While ! SE1->(eof()) .AND. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == _cChvNCC
        If SE1->E1_TIPO ==  "NCC"
            _cRetParc    :=  SE1->E1_PARCELA
        Endif
        SE1->( DbSkip())
    EndDo
Endif
Return(SOMA1(_cRetParc) )
