#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"
#Include "MSMGADD.CH"


//Variáveis Estáticas
Static cTitulo := "Apuração de Descontos de Contrato e Acordos Comerciais"

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

@table ZHC -   Solicitação Financeira

@menu
Financeiro - Atualizações-Especificos MARFRIG

@history
/*/
User Function MGFFINBX()
	Local aArea   := GetArea()
	Local oBrowse

	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()

	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("ZHC")
	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)

	//Legendas 1=Em aberto;2=Analisado;3=Enviado;4=Aprovado;5=Rejeitado
	oBrowse:AddLegend( "ZHC->ZHC_STATUS == '1'" , "GREEN"	,"Em aberto" )
	oBrowse:AddLegend( "ZHC->ZHC_STATUS == '2'"	, "YELLOW"	,"Analisado" )
	oBrowse:AddLegend( "ZHC->ZHC_STATUS == '3'" , "BR_CINZA","Enviado" )
	oBrowse:AddLegend( "ZHC->ZHC_STATUS == '4'"	, "BLUE"	,"Aprovado" )
	oBrowse:AddLegend( "ZHC->ZHC_STATUS == '5'" , "RED"		,"Rejeitado" )

	If FINBX_02()	// Se usuario aprovador somente visualiza estes
		oBrowse:SetMenuDef("")
		oBrowse:AddButton("Aprovar"	, {|| FINBX_Apr() , oBrowse:refresh(.t.) } ,,,, .F., 2 )
		oBrowse:AddButton("Rejeitar", {|| FINBX_Rej() , oBrowse:refresh(.t.) } ,,,, .F., 2 )
	Endif
	//Ativa a Browse
	oBrowse:Activate()
	RestArea(aArea)
Return Nil

//
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  		ACTION 'PesqBrw'			OPERATION 1	ACCESS 0
	ADD OPTION aRotina TITLE 'Análise'	    	ACTION 'u_FINBX_Ana'     	OPERATION 6	ACCESS 0 //OPERATION X
	ADD OPTION aRotina TITLE 'Visualizar'		ACTION 'VIEWDEF.MGFFINBX'	OPERATION 2	ACCESS 0 //OPERATION 1 MODEL_OPERATION_VIEW
	ADD OPTION aRotina TITLE 'Incluir'			ACTION 'u_FINBX_Inc'		OPERATION 3	ACCESS 0 //OPERATION 3 MODEL_OPERATION_INSERT
	ADD OPTION aRotina TITLE 'Excluir'			ACTION 'VIEWDEF.MGFFINBX'	OPERATION 5	ACCESS 0 //OPERATION 5 MODEL_OPERATION_DELETE
	ADD OPTION aRotina TITLE 'Envia Aprovação'	ACTION 'u_FINBX_Env'      	OPERATION 6	ACCESS 0 //OPERATION X
	ADD OPTION aRotina TITLE 'Legenda'	    	ACTION 'u_FINBX_Leg'     	OPERATION 6	ACCESS 0 //OPERATION X
	ADD OPTION aRotina TITLE 'Título NCC'		ACTION 'u_FINBX_NCC'      	OPERATION 6	ACCESS 0 //OPERATION X
	//	ADD OPTION aRotina TITLE 'Visualiza NCC'	ACTION 'u_FINBX_NCC'      	OPERATION 6	ACCESS 0 //OPERATION X
	ADD OPTION aRotina TITLE 'Legenda'	    	ACTION 'u_FINBX_Leg'     	OPERATION 6	ACCESS 0 //OPERATION X

Return aRotina

//
Static Function ModelDef()
	//Criação do objeto do modelo de dados
	Local oModel := Nil

	//Criação da estrutura de dados utilizada na interface
	Local oStZHC := FWFormStruct(1, "ZHC")

	//Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("mMGFFINBX", /*{|oModel|ZHCPre(oModel)}*/ /*bPre*/, /*{|oModel|ZHCPos(oModel) }*/ /*bPos*/, {|oModel|ZHCCmt(oModel) }/*bCommit*/,/*bCancel*/)

	//Atribuindo formulários para o modelo
	oModel:AddFields("FORMZHC",/*cOwner*/,oStZHC)

	//Setando a chave primária da rotina
	oModel:SetPrimaryKey({'ZHC_FILIAL','ZHC_CONTRA'})

	//Adicionando descrição ao modelo
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)

	//Setando a descrição do formulário
	oModel:GetModel("FORMZHC"):SetDescription("Formulário do Cadastro "+cTitulo)

	//oStZHC:SetProperty("ZHC_ID",MODEL_FIELD_INIT,{||GETSXENUM('ZHC','ZHC_ID')})

Return oModel

//
Static Function ViewDef()
	//Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("MGFFINBX")
	Local cFldZHC   := "ZHC_DESCON,ZHC_STATUS,ZHC_PESOT,ZHC_TOTVAL,ZHC_TOTDEV,ZHC_TOTLIQ,ZHC_TDESCT,ZHC_E1RECN,ZHC_NIVEL"
	//Criação da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStZHC := FWFormStruct(2, "ZHC",{|cCampo|!(AllTrim(cCampo) $ cFldZHC)})

	//Criando oView como nulo
	Local oView := Nil
	//Criando a view que será o retorno da função e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)

	//Atribuindo formulários para interface
	oView:AddField("VIEW_ZHC", oStZHC, "FORMZHC")

	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)

	//Colocando título do formulário
	oView:EnableTitleView('VIEW_ZHC', 'Dados do Desconto em Contrato' )

	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})

	//O formulário da interface será colocado dentro do container
	oView:SetOwnerView("VIEW_ZHC","TELA")
Return oView

/*/{Protheus.doc} FINBX_Leg
Função para mostrar a legenda das rotinas MVC

@author Renato Bandeira
@since 11/09/2020
/*/
User Function FINBX_Leg()
	Local aLegenda := {}
	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",		"Em aberto"  })
	AADD(aLegenda,{"BR_AMARELO",	"Analisado"})
	AADD(aLegenda,{"BR_CINZA",		"Enviado"  })
	AADD(aLegenda,{"BR_AZUL",       "Aprovado"})
	AADD(aLegenda,{"BR_VERMELHO",	"Rejeitado"})

	BrwLegenda("Situação da Solicitação", "Status", aLegenda)
Return

/*/{Protheus.doc} FINBR_Apr
Função para Marcar o Status "4" - Aprovado - Geração da NCC

@author Renato Bandeira
@since 28/09/2020
/*/
Static Function FINBX_Apr()

	If ! ZHC->ZHC_STATUS == '3'
		Help( ,, 'Aprovação',, 'Somente se já foi Enviado', 1, 0 )
	Else
		If ZHC->( RECLOCK("ZHC",.F.))
			ZHC->ZHC_STATUS	:=  "4"
			ZHC->( MSUNLOCK())
		Endif
	Endif
Return Nil


/*/{Protheus.doc} FINBR_Rej
Função para Marcar o Status "5" - Rejeitado

@author Renato Bandeira
@since 28/09/2020
/*/
Static Function FINBX_Rej()	//oBrowse)

	If ! ZHC->ZHC_STATUS == '3'
		Help( ,, 'Rejeição',, 'Somente se já foi Enviado', 1, 0 )
	Else
		If ZHC->( RECLOCK("ZHC",.F.))
			ZHC->ZHC_STATUS  :=  "5"
			ZHC->( MSUNLOCK())
		Endif
	Endif

Return Nil

/*/{Protheus.doc} FINBR_Cnf
Função para Marcar o Status "2" - Analisado

@author Renato Bandeira
@since 29/09/2020
/*/
Static Function FINBX_Cnf()	//oBrowse)
	If ZHC->( RECLOCK("ZHC",.F.))
		ZHC->ZHC_STATUS  :=  "2"
		ZHC->( MSUNLOCK())
	Endif
Return Nil

/*/{Protheus.doc} FINBR_Ina
Função para inativar (excluir) movimento (ZHD)

@author Renato Bandeira
@since 28909/2020
/*/
Static Function FINBX_Ina(XcAliasTmp)

	If MSGYESNO("Confirma a operação ? Não poderá ser desfeito !")
		Begin Transaction
			If RECLOCK("ZHC",.F.)	// Recalcula valores
				ZHC->ZHC_PESOT	-=	(XcAliasTmp)->VLR_PLIQNF
				ZHC->ZHC_TOTVAL	-=	(XcAliasTmp)->ZHD_TOTVAL
				ZHC->ZHC_TOTDEV	-=	(XcAliasTmp)->ZHD_TOTDEV
				ZHC->( MSUNLOCK())
				ZHD->(DBGOTO((XcAliasTmp)->ZHDPOSIC))	// Exclui item do Fechamento
				If RECLOCK("ZHD",.F.)
					ZHD->( DBDELETE())
				Endif
				If RECLOCK(XcAliasTmp,.F.)	// Deleta registro posicionado no browse temporario
					(XcAliasTmp)->( DBDELETE())
				Endif
			Endif
		End Transaction
	Endif

Return Nil


/*/{Protheus.doc} FINBR_Env
Função para Marcar o Status "3" - enviado para Análise de Aprovação/Rejeição
Somente tipo Acordo ?

@author Renato Bandeira
@since 21/07/2020
/*/
User Function FINBX_Env()
	Local aArea 		:= GetArea()

	Private cEmailCC	:= 	""

	If ! ZHC->ZHC_STATUS == '2'
		Help( ,, 'Envio de e-mail para Aprovação',, 'Somente se estiver Analisado', 1, 0 )
	Else
		GetEmailCC(@cEmailCC)	// E-mail CC
		If ZHC->( RECLOCK("ZHC",.F.))
			ZHC->ZHC_STATUS  :=  "3"
			ZHC->ZHC_NIVEL   :=  SOMA1(ZHC->ZHC_NIVEL)
			ZHC->( MSUNLOCK())
			// Envia e-mail para usarios do nivel
			Processa({|| FINBXEmail({ZHC->ZHC_NIVEL }) },'Aguarde...' , 'Enviando E-mail para Analise do Desconto... ',.T.)
		Endif
	Endif

	RestArea( aArea )

Return Nil


/*/{Protheus.doc} FINBX_NCC
Se o Status "4" - aprovado , visualiza o NCC pelo Recno

@author Renato Bandeira
@since 28/09/2020
/*/
User Function FINBX_NCC()
	Local _aAreaCons	:=	GetArea()
	Local _cFilAnt		:=	cFilAnt
	Local aRet		:= {}
	Local aPergs	:= {}
	Local _cNaturez	:=	SPACE(10)
	Local _cCliente	:=	SPACE(06)
	Local _cLojaCli	:=	SPACE(02)

	Private altera := .F.
	Private ccadastro := "Visualizando Titulo NCC de Desconto"

	If	! ZHC->ZHC_STATUS == '4'	//.AND.	ZHC->ZHC_E1RECN	> 0
		Help( ,, 'Título NCC',, 'Somente se estiver Aprovado', 1, 0 )
	Else
		If ZHC->ZHC_E1RECN	>	0	// Visualiza NCC
			SE1->(DBGOTO(ZHC->ZHC_E1RECN))
			cFilAnt	:=	SE1->E1_FILIAL
			AxVisual("SE1",SE1->(RECNO()),2)
			Restarea( _aAreaCons)
		Else
			// Informa Cliente e Natureza
			aAdd( aPergs ,{1,"Natureza : "	,_cNaturez	,"@9",'Vazio() .OR. ExistCpo("SED", MV_PAR01 )',"SED",'.T.',50,.T.})
			aAdd( aPergs ,{1,"Cliente : "	,_cCliente	,"@9",'Vazio() .OR. ExistCpo("SA1", MV_PAR02 )',"VSA",'.T.',40,.T.})
			aAdd( aPergs ,{1,"Loja : "		,_cLojaCli	,"@9",'Vazio() .OR. ExistCpo("SA1", MV_PAR02+MV_PAR03 )',"",'.T.',20,.T.})
			aAdd( aPergs ,{1,"Nome : "		,space(40)	,"@!",'.T.',"",'.F.',100,.T.})

			If !ParamBox(aPergs ,"NCC - Inclusão - Parametros",aRet)
				Help( ,, 'NCC - Inclusão',, 'Efetivação da NCC Cancelada', 1, 0 )
			Else
				Begin Transaction
					If ZHC->( RECLOCK("ZHC",.F.))
						ZHC->ZHC_NATURE	:= MV_PAR01
						ZHC->ZHC_CLIENT	:= MV_PAR02
						ZHC->ZHC_LOJA	:= MV_PAR03

						Processa({|| GerTitSel({{ZHC->ZHC_CLIENT, ZHC->ZHC_LOJA , ZHC->ZHC_NATURE, (ZHC->(ZHC_TOTVAL-ZHC_TOTDEV) * ZHC->ZHC_DESCON)/100 }}) }, ;
							'Aguarde...' , 'Efetivando NCC... ',.T.)

						ZHC->ZHC_E1RECN  :=  SE1->(RECNO())
						ZHC->( MSUNLOCK())
					Endif
				End Transaction
			EndIf
		Endif
	Endif
Return Nil


/*/{Protheus.doc} FINBXVSE1
Visualiza SE1 do registro atual da ZHD

@author Renato Bandeira
@since 30/09/2020
/*/
Static Function FINBXVSE1(XcAliasTmp)
	Local _aAreaCons	:=	GetArea()
	Local _cFilAnt		:=	cFilAnt

	Private altera := .F.
	Private ccadastro := "Visualizando Titulo a Receber"

	SE1->(DBGOTO((XcAliasTmp)->SE1POSIC))
	cFilAnt	:=	SE1->E1_FILIAL
	AxVisual("SE1",SE1->(RECNO()),2)
	Restarea( _aAreaCons)
	cFilAnt	:=	_cFilAnt

Return Nil


/*/{Protheus.doc} FINBXVSF2
Visualiza SF2 referente SE1 do registro atual da ZHD
Ordem 2 - F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE+F2_TIPO+F2_ESPECIE

@author Renato Bandeira @since 30/09/2020
/*/
Static Function FINBXVSF2(XcAliasTmp)
	Local _aAreaCons	:=	GetArea()
	Local _cFilAnt		:=	cFilAnt
	Local _cE1ORIGEM	:=	""
	Local _lTemDev		:=	.F.
	Local aRet			:= {}
	Local aParambox		:= {}
	Local _cMsgTemp		:=	""
	Local _nPosPerg		:=	1

	// Para todos tem que posicionar no SE1
	SE1->(DBGOTO((XcAliasTmp)->SE1POSIC))
	_cE1ORIGEM	:=	ALLTRIM(SE1->E1_ORIGEM)
	If _cE1ORIGEM	$	"MATA460|MATA100"
		_cKey1		:=	SE1->(E1_NUM + E1_PREFIXO)
		If _cE1ORIGEM	==	"MATA100"
			//Dev.Ref.:200-001083776/200-001083779/200-001083780
			If ! "Dev.Ref.:"	$	SE1->E1_HIST
				Help( ,, 'Sem Referência de Nota',, SE1->E1_HIST, 1, 0 )
			Else
				_cMsgTemp	:=	STRTRAN(ALLTRIM(SE1->E1_HIST),"Dev.Ref.:","")
				_cMsgTemp	:=	STRTRAN(_cMsgTemp,"/","','")
				_cMsgTemp	:=	"{'" + _cMsgTemp + "'}"
				_cMsgTemp	:=	&(_cMsgTemp)
				If Len(_cMsgTemp) > 1
					AAdd( aParambox,{3, "Nota :"     , 1 , _cMsgTemp , 070 , "" , .T. } )
					If ParamBox(aParambox, "Selecione a Nota"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .F. /*lCanSave*/, .F. /*lUserSave*/)
						_nPosPerg	:=	aRet[1]
					EndIf
				Endif
				_cKey1		:=	RIGHT(_cMsgTemp[ _nPosPerg] , 9) + LEFT(_cMsgTemp[ _nPosPerg] , 3)
				_lTemDev	:=	.T.
			Endif
		Endif
		If _cE1ORIGEM	==	"MATA460"	.OR.	_lTemDev
			DBSELECTAREA("SF2")
			SF2->(DBSETORDER(2))	//F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE+F2_TIPO+F2_ESPECIE
			If SF2->(DBSEEK(SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA) + _cKey1 ))
				cFilAnt	:=	SE1->E1_FILIAL
				Mc090Visual("SF2",SF2->(RECNO()),2)
			Endif
		Endif
	Endif

	Restarea( _aAreaCons)
	cFilAnt	:=	_cFilAnt

Return Nil


/*/{Protheus.doc} ZHCCmt
Função para gravar e confirmar numero sequencial

@author Renato Bandeira
@since 21/07/2020
/*/
Static function ZHCCmt( oModel )
	Local lRet		:= .T.
	Local nOperation	:= oModel:GetOperation()

	If nOperation == 5	//DELETE
		Processa({|| FINBX_Exc()},"Aguarde....","Excluindo Período")
	Endif

	If	lRet
		If oModel:VldData()
			FwFormCommit( oModel )
			oModel:DeActivate()
		Else
			JurShowErro( oModel:GetModel():GetErrormessage() )
			DisarmTransaction()
		Endif
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		DisarmTransaction()
	Endif

Return lRet


/*/{Protheus.doc} FINBX_01
Pesquisa se conrtato foi utilizado dentro do periodo informado

@author Renato Bandeira
@since 14/09/2020
/*/
Static Function FINBX_01(cContrat,dDtDe, dDtAt)
	Local cQuery		:= ''
	Local _lRet			:= .F.
	Local cNextAlias	:= GetNextAlias()

	cQuery  := ''
	cQuery  += " SELECT R_E_C_N_O_ AS POSICA FROM "+RetSqlName("ZHC")+" ZHC "
	cQuery  += " WHERE ZHC.D_E_L_E_T_ = ' ' AND  "
	cQuery  += " ZHC_CONTRA = '"+cContrat+"' AND ( "	// ignora revisao pois esta sofrera alteracoes
	cQuery  += " '"+dDtDe+"' BETWEEN ZHC.ZHC_DATADE AND ZHC.ZHC_DATATE "	// Data Inicial em alguma apuração
	cQuery  += " OR '"+dDtAt+"' BETWEEN ZHC.ZHC_DATADE AND ZHC.ZHC_DATATE "	// Data Final em alguma apuração
	cQuery  += " OR '"+dDtAt+"' < ZHC.ZHC_DATADE ) "						// Data Final anterio a alguma apuração

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
	dbSelectArea(cNextAlias)
	If ! (cNextAlias)->(Eof())
		_lRet	:= .T.
	Endif

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

Return _lRet


/*/{Protheus.doc} FINBX_Inc
Inclusão dos contratos
Efetua consistencias em datas e se ja existe
Inclui de acordo com os campos de descontos CN9_ZDESCF e CN9_ZACORD
CN9	1	CN9_FILIAL+CN9_NUMERO+CN9_REVISA

@author Renato Bandeira
@since 01/10/2020
/*/
User Function FINBX_Inc( XlRet)
	Local _aDescon	:=	{}
	Local _nCti	:=	0
	Local _aMensa	:=	{}

	Private _aRet	:= {}, _aParambox	:= {}	//, _bParameRe
	Private _nZhdpeso		:=	0
	Private _nZhdtotval	:=	0
	Private _nZhdtotdev	:=	0
	Private oProcess

	_aParambox	:= {}
	aAdd(_aParambox,{1,"Contrato"		,Space(tamSx3("ZHC_CONTRA")[1])	,""	,"NaoVazio()"										,"FINBX","",070,.F.})
	aAdd(_aParambox,{1,"Revisao"		,Space(tamSx3("ZHC_REVISA")[1])	,""	,"U_FINBX_04(MV_PAR01,MV_PAR02)"					,""		,"",010,.F.})
	aAdd(_aParambox,{1,"Data Inicial"	,Ctod("")						,""	,"NaoVazio()"										,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Final"		,Ctod("")						,""	,"NaoVazio()"										,""		,"",050,.T.})

	If !ParamBox(_aParambox ,"Inclusão - Parametros",_aRet) ; Return ; Endif

		If MV_PAR03 > MV_PAR04
			_aMensa	:=	{"Data Inicial maior que Data Final",'Divergência !'}
		ElseIf MV_PAR04	> dDataBase
			_aMensa	:=	{"Data Final maior que data atual",'Divergência !'}
		ElseIf FINBX_01(MV_PAR01, DTOS(MV_PAR03), DTOS(MV_PAR04))
			_aMensa	:=	{"Contrato já apurado neste período",'Já existente !'}
		Endif
		If Len(_aMensa)	> 0
			Help( ,, _aMensa[2],, _aMensa[1], 1, 0 )
			Return
		Endif

		If CN9->CN9_ZACORD	>	0
			AAdd(_aDescon,{CN9->CN9_ZACORD, "1"})
		Endif
		If CN9->CN9_ZDESCF	>	0
			AAdd(_aDescon,{CN9->CN9_ZDESCF, "2"})
		Endif

		Begin Transaction
			// Inclui os titulos referente a cada contrato
			oProcess := MsNewProcess():New( { || FINBX_03(_aDescon, @XlRet) } , "Incluindo Faturamento/Títulos" , "Aguarde..." , .F. )
			oProcess:Activate()
			If ! XlRet
				//			Help( ,, "Verifique !",, "Não encontrado Títulos/Notas de "+Iif(_aDescon[_nCti][2]=="1","Acordo","Fechamento"), 1, 0 )
				Help( ,, "Verifique !",, "Não encontrado Títulos/Notas no período selecionado. ", 1, 0 )
			Else
				For _nCti	:=	1	to Len(_aDescon)
					RECLOCK("ZHC",.T.)
					ZHC_FILIAL	:=	XFILIAL("ZHC")
					ZHC_CONTRA	:=	MV_PAR01	//_cCONTRA
					ZHC_REVISA	:=	MV_PAR02	//_cREVISA
					ZHC_DATADE	:=	MV_PAR03	//_dDATADE
					ZHC_DATATE	:=	MV_PAR04	//_dDATATE
					ZHC_STATUS	:=	"1"
					ZHC_DESCON	:=	_aDescon[_nCti][1]
					ZHC_TIPO	:=	_aDescon[_nCti][2]
					// ATUALIZA VALORES ACUMULADOS
					ZHC->ZHC_PESOT	:=	_nZhdpeso
					ZHC->ZHC_TOTVAL	:=	_nZhdtotval
					ZHC->ZHC_TOTDEV	:=	_nZhdtotdev
					ZHC->(MSUNLOCK())
				Next
			Endif
		End Transaction

		Return Nil

/*/{Protheus.doc} FINBX_03
Executa função para inclusao dos titulos
Grava os registros

@author Renato Bandeira
@since 14/09/2020
/*/
Static function FINBX_03(_aDescon, XlRet)
	Local _nCti			:=	0
	Local _nQtd			:=	Len(_aDescon)
	Local cQuery  		:= ""
	Local cNextAlias	:= ""
	Local _cEmp_De		:=	LEFT(cFilAnt,2)+"    "
	Local _cEmpAte		:=	LEFT(cfilAnt,2)+"9999"

	cNextAlias	:= GetNextAlias()
	cQuery  := ''
	cQuery  += " SELECT CR.R_E_C_N_O_ AS E1POSIC "
	cQuery  += " ,NVL(NFS.F2_PLIQUI,0)                                    AS PLIQUIDO_NF "
	cQuery  += " , CASE WHEN CR.E1_ORIGEM = 'MATA460' AND CR.E1_NATUREZ <> '10107' "
	cQuery  += " THEN CR.E1_VALOR ELSE 0 END                     AS VLR_TITULO "
	cQuery  += " , CASE WHEN CR.E1_ORIGEM IN ('MATA100 ', 'MGFFIS36') AND CR.E1_NATUREZ = '10107' "
	cQuery  += " THEN CR.E1_VALOR ELSE 0 END                     AS VLR_DEVOLUCAO "

	cQuery  += " FROM "+RetSqlName("SE1")+" CR "
	cQuery  += " INNER JOIN "+RetSqlName("CNC")+" CNC "

	cQuery  += " ON CNC_FILIAL = '"+XFILIAL("CNC")+"' AND CNC_NUMERO = '"+MV_PAR01+"'  AND CNC_REVISA = '"+MV_PAR02+"' AND CNC.D_E_L_E_T_ = ' '
	cQuery  += " AND CNC.CNC_CLIENT = CR.E1_CLIENTE AND CNC.CNC_LOJACL = CR.E1_LOJA "

	cQuery  += " LEFT JOIN "+RetSqlName("SF2")+" NFS ON CR.E1_FILIAL    = NFS.F2_FILIAL "
	cQuery  += " AND CR.E1_NUM       = NFS.F2_DOC AND CR.E1_CLIENTE   = NFS.F2_CLIENTE AND CR.E1_LOJA      = NFS.F2_LOJA "
	cQuery  += " AND CR.E1_PREFIXO   = NFS.F2_SERIE AND NFS.D_E_L_E_T_  = ' ' "
	cQuery  += " WHERE CR.D_E_L_E_T_ = ' ' AND CR.E1_ORIGEM IN ('MATA100 ', 'MGFFIS36', 'MATA460') "
	cQuery  += " AND CR.E1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	cQuery  += " AND CR.E1_FILIAL BETWEEN '"+_cEmp_De+"' AND '"+_cEmpAte+"' "

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	cQuery  := ChangeQuery(cQuery)

	memowrite("c:\totvs\MGFFINBX_A.TXT", cQuery  )// remover

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
	dbSelectArea(cNextAlias)
	oProcess:SetRegua2( (cNextAlias)->(RecCount()) ) //Alimenta a segunda barra de progresso
	If (cNextAlias)->(!Eof())
		XlRet	:=	.T.
		oProcess:SetRegua1( _nQtd ) //Alimenta a primeira barra de progresso
		Begin Transaction
			For _nCti	:=	1	to	_nQtd
				oProcess:IncRegua1("Processando "+Iif(_aDescon[_nCti][2]=="1","Acordo","Fechamento"))
				_nZhdpeso		:=	_nZhdtotval	:=	_nZhdtotdev	:=	0
				(cNextAlias)->(DbGotop())
				While (cNextAlias)->(!Eof())
					oProcess:IncRegua2("Incluindo Títulos/Notas")
					RECLOCK("ZHD",.T.)
					ZHD->ZHD_FILIAL	:=	XFILIAL("ZHD")
					ZHD->ZHD_CONTRA	:=	MV_PAR01
					ZHD->ZHD_REVISA	:=	MV_PAR02
					ZHD->ZHD_DATADE	:=	MV_PAR03
					ZHD->ZHD_DATATE	:=	MV_PAR04
					ZHD->ZHD_TIPO	:=	_aDescon[_nCti][2]
					ZHD->ZHD_E1RECN	:=	(cNextAlias)->E1POSIC
					ZHD->ZHD_PESO	:=	(cNextAlias)->PLIQUIDO_NF
					ZHD->ZHD_TOTVAL	:=	(cNextAlias)->VLR_TITULO
					ZHD->ZHD_TOTDEV	:=	(cNextAlias)->VLR_DEVOLUCAO
					ZHD->(MSUNLOCK())
					_nZhdpeso	+=	ZHD->ZHD_PESO
					_nZhdtotval	+=	ZHD->ZHD_TOTVAL
					_nZhdtotdev	+=	ZHD->ZHD_TOTDEV
					(cNextAlias)->(dbSkip())
				EndDo
			Next
			(cNextAlias)->(DbClosearea())
		End Transaction
	Else
		XlRet	:=	.F.
	Endif
Return


/*/{Protheus.doc} FINBX_04
Inclusão dos contratos - validacao (X3_VLDUSER) do campo ZHC_CONTRA

@author Renato Bandeira
@since 14/09/2020
/*/
User Function FINBX_04(_cZHCCONTRA, _cZHCREVISA)
	Local lRet		:=	.T.
	Local _cMsgTemp	:=	""

	If ! CN9->(DBSETORDER(1), DbSeek( XFILIAL("CN9")+_cZHCCONTRA + _cZHCREVISA))
		_cMsgTemp	:=	"Contrato Inexistente"
	Else
		If  ! CN9->CN9_SITUAC=='05'
			_cMsgTemp	:=	"Contrato não está vigente"
		ElseIf CN9->CN9_ZACORD	== 0	.AND.	CN9->CN9_ZDESCF	== 0
			_cMsgTemp	:=	"Contrato sem descontos"
		Endif
	Endif

	If ! Empty(_cMsgTemp)
		Help( ,, 'Verifique Contrato Informado !',, _cMsgTemp, 1, 0 )
		lRet	:= .F.
	Endif

Return lRet


/*/{Protheus.doc} FINBX_Exc
Exclusão dos contratos e o detalhe

@author Renato Bandeira
@since 15/09/2020
/*/
Static Function FINBX_Exc()
	Local cQuery		:= ''
	Local cNextAlias	:= GetNextAlias()

	cQuery  := ''
	cQuery  += " SELECT R_E_C_N_O_ AS POSICA FROM "+RetSqlName("ZHD")+" ZHD WHERE "
	cQuery  += " ZHD.ZHD_FILIAL = '"+XFILIAL("ZHC")+"' AND "
	cQuery  += " ZHD.ZHD_CONTRA = '"+ZHC->ZHC_CONTRA+"' AND "
	cQuery  += " ZHD.ZHD_DATADE = '"+DTOS(ZHC->ZHC_DATADE)+"' AND "
	cQuery  += " ZHD.ZHD_DATATE = '"+DTOS(ZHC->ZHC_DATATE)+"' AND "
	cQuery  += " ZHD.ZHD_TIPO = '"+ZHC->ZHC_TIPO+"' AND "
	cQuery  += " ZHD.D_E_L_E_T_ = ' ' "
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
	dbSelectArea(cNextAlias)
	ProcRegua((cNextAlias)->(LASTREC()))
	(cNextAlias)->(DBGOTOP())
	While (cNextAlias)->(!Eof())
		IncProc("Excluindo Títulos/Notas")
		ZHD->(DBGOTO((cNextAlias)->POSICA))
		RECLOCK("ZHD",.F.)
		ZHD->(DBDELETE())
		(cNextAlias)->(dbSkip())
	EndDo

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

Return Nil


/*/
	==============================================================================================================================================================================
	Descrição   : Tela para Análise Títulos/Notas

	@description
	Tela para Análise Títulos/Notas

	@author Renato Bandeira
	@since 16/09/2020
	@type       : User Function

	@menu       : Financeiro - Atualizações-Especificos MARFRIG

	@history
/*/
User Function FINBX_Ana()
	Local _nx       :=  0
	Local _aEstruCpo	:=	{}
	Local _cCpCase		:=	""
	Local _cTabWhere	:=	""
	Local aRet 			:=	{}
	Local _cCPOEXCLU	:=	""
	Local _cCpo_OK		:=	"OK_POSIC"	//Nil
	Local _aLegenda		:=	{}
	Local _cTitRotin	:=	"Análise do Desconto em Contrato - Títulos Selecionados"
	Local _a_Botoes		:=	{}
	Local _a_TeclaF		:=	{}
	Local _aSeek		:=	{}
	Local _cDirSql		:=	"c:\totvs\MGFFINBX_B.TXT"	//Nil
	Local _cMenuDef		:=	STRTRAN(PROCNAME(),"U_","")

	If ZHC->ZHC_STATUS $ '5'	// Rejeitado, verifica se ira Reanalisar
		If MSGYESNO("Rejeitado. Reabrir para Análise ? Não poderá ser desfeito !")
			RECLOCK("ZHC",.F.)
			ZHC->ZHC_STATUS	:=	"1"
			ZHC->(MSUNLOCK())
		Else
			Return Nil
		Endif
	ElseIf ! ZHC->ZHC_STATUS $ '12'
		Help( ,, 'Análise',, 'Somente se estiver em Aberto ou em Análise', 1, 0 )
		Return Nil
	Endif
	//                 ALIAS,COLUNA TABELA  ,{TAM,DEC,TIPO} 				,CPO TAB TEMP	, PICTURE
	AADD( _aEstruCpo, {"FIL","M0_CODFIL"	,{12,0,"C","Filial"}			,"COD_FILIAL"	,"@9"	}	)
	AADD( _aEstruCpo, {"FIL","M0_FILIAL"	,{41,0,"C","Nome Filial"}		,"NOM_FILIAL"	,"@!"	}	)
	AADD( _aEstruCpo, {"CR"	,"E1_EMISSAO"	,								,"DT_EMISSAO"	,		}	)
	AADD( _aEstruCpo, {"CR"	,"E1_VENCTO"	,								,"DT_VENCTO"	,		}	)
	_cCpCase	:=	""
	_cCpCase	+=	" CASE"
	_cCpCase	+=	" WHEN CR.E1_SALDO = 0 THEN 'TITULO BAIXADO'"
	_cCpCase	+=	" WHEN (CR.E1_SALDO + CR.E1_SDACRES) <> (CR.E1_VALOR + CR.E1_SDACRES) THEN 'BAIXADO PARCIALMENTE'"
	_cCpCase	+=	" WHEN CR.E1_NUMBOR <> '' THEN 'TITULO EM BORDERO'"
	_cCpCase	+=	" WHEN CR.E1_NUMBOR <> '' AND (CR.E1_SALDO <> CR.E1_VALOR) THEN 'TITULO BAIXADO PARCIALMENTE E EM BORDERO'"
	_cCpCase	+=	" ELSE 'TITULO EM ABERTO' END"
	AADD( _aEstruCpo, {		,_cCpCase		,{40,0,"C","Status Titulo"}		,"STATUS_TIT","@!"	}	)
	AADD( _aEstruCpo, {"CLI","A1_COD"		,								,"CODCLIENTE",		}	)
	AADD( _aEstruCpo, {"CLI","A1_NOME"		,								,"NOMCLIENTE",		}	)
	AADD( _aEstruCpo, {"CLI","A1_CGC"		,								,"NUM_CNPJ"	,		}	)
	_cCpCase	:=	"NVL(ZQ_COD,' ')"
	AADD( _aEstruCpo, {		,_cCpCase		,"ZQ_COD"						,"COD_REDE"	,		}	)
	_cCpCase	:=	"NVL(ZQ_DESCR,' ')"
	AADD( _aEstruCpo, {		,_cCpCase		,"ZQ_DESCR"						,"DESC_REDE",		}	)
	AADD( _aEstruCpo, {"SEG","AOV_CODSEG"	,								,"COD_SEGTO",		}	)
	AADD( _aEstruCpo, {"SEG","AOV_DESSEG"	,								,"DESC_SEGTO",		}	)
	AADD( _aEstruCpo, {"CR"	,"E1_PORTADO"	,								,"COD_PORTAD",		}	)
	AADD( _aEstruCpo, {"CR"	,"E1_TIPO"		,								,"TIP_DOCTO",		}	)
	AADD( _aEstruCpo, {"CR"	,"E1_PREFIXO"	,								,"SERIE_NF"	,		}	)
	AADD( _aEstruCpo, {"CR"	,"E1_NUM"		,								,"NUM_NF"	,		}	)
	AADD( _aEstruCpo, {		,"ZHD_PESO"		,								,"VLR_PLIQNF",		}	)
	AADD( _aEstruCpo, {"CR"	,"E1_VEND1"		,								,"COD_VEND"	,		}	)
	_cCpCase	:=	"NVL(VEN.A3_NOME,' ')"
	AADD( _aEstruCpo, {		,_cCpCase		,"A3_NOME"						,"NOM_VEND"	,		}	)
	AADD( _aEstruCpo, {"CR"	,"E1_HIST"		,								,"OBSERVACAO",		}	)
	AADD( _aEstruCpo, {		,"ZHD_TOTVAL"	,								,			,		}	)
	AADD( _aEstruCpo, {		,"ZHD_TOTDEV"	,								,			,		}	)
	AADD( _aEstruCpo, {"CR"	,"R_E_C_N_O_"	,{12,0,"N",""}					,"SE1POSIC"	,		}	)
	AADD( _aEstruCpo, {"ZHD","R_E_C_N_O_"	,{12,0,"N",""}					,"ZHDPOSIC"	,		}	)
	// Campos que estarão somente na tabela temporaria
	AADD( _aEstruCpo, {		,				,{02,0,"C",""}					,"OK_POSIC"	,"@!"	}	)

	_cCPOEXCLU	:=	"SE1POSIC|ZHDPOSIC"	// Campos que não devem constar no Browse
	// Tabelas, relacionamentos e filtros do Select
	_cTabWhere	+=	" FROM "+ RetSQLName("ZHD") +" ZHD "
	_cTabWhere	+=	" INNER JOIN "+ RetSQLName("SE1") +" CR ON CR.R_E_C_N_O_ = ZHD.ZHD_E1RECN   AND CR.D_E_L_E_T_  = ' ' "
	_cTabWhere	+=	" INNER JOIN SYS_COMPANY  FIL ON CR.E1_FILIAL    = FIL.M0_CODFIL AND FIL.D_E_L_E_T_  = ' ' "
	_cTabWhere	+=	" LEFT JOIN "+ RetSQLName("SA3") +"        VEN ON CR.E1_VEND1     = VEN.A3_COD AND VEN.D_E_L_E_T_ = ' ' "
	_cTabWhere	+=	" INNER JOIN "+ RetSQLName("SA1") +"       CLI ON CR.E1_CLIENTE   = CLI.A1_COD AND CR.E1_LOJA = CLI.A1_LOJA  AND CLI.D_E_L_E_T_  = ' ' "
	_cTabWhere	+=	" LEFT JOIN "+ RetSQLName("SZQ") +"        RED ON CLI.A1_ZREDE    = RED.ZQ_COD AND RED.D_E_L_E_T_  = ' ' "
	_cTabWhere	+=	" LEFT JOIN "+ RetSQLName("AOV") +"        SEG ON CLI.A1_CODSEG   = SEG.AOV_CODSEG AND SEG.D_E_L_E_T_  = ' ' "
	_cTabWhere	+=	" WHERE "
	_cTabWhere	+=	" ZHD_FILIAL = '"+ZHC->ZHC_FILIAL+"' AND ZHD_CONTRA = '"+ZHC->ZHC_CONTRA+"' "
	_cTabWhere	+=	" AND ZHD_REVISA = '"+ZHC->ZHC_REVISA+"' "
	_cTabWhere	+=	" AND ZHD_DATADE = '"+DTOS(ZHC->ZHC_DATADE)+"' AND ZHD_DATATE = '"+DTOS(ZHC->ZHC_DATATE)+"' "
	_cTabWhere	+=	" AND ZHD_TIPO  = '"+ZHC->ZHC_TIPO  +"' AND ZHD.D_E_L_E_T_ = ' ' "

	AADD( _aLegenda, {"ZHD_TOTVAL > 0", "BR_VERDE"		, "VENDA" })
	AADD( _aLegenda, {"ZHD_TOTDEV > 0", "BR_VERMELHO"	, "DEVOLUÇÃO" })

	AADD( _a_Botoes, {"Confirma"		,{|| MsgRun('Movimento Analisado','Processando',{|| FINBX_Cnf() , oBrowEs:refresh(.t.) })} })
	AADD( _a_Botoes, {"Inativa"			,{|| MsgRun('Movimento Inativado','Processando',{|| FINBX_Ina(_cAliasTmp) , oBrowEs:refresh(.t.) })} })
	AADD( _a_Botoes, {"Visual.Tit-F6"	,{|| MsgRun('Visualizando Titulo a Receber','Processando',{|| FINBXVSE1(_cAliasTmp) , oBrowEs:refresh(.t.) })} })
	AADD( _a_Botoes, {"Visual.Nfs-F7"	,{|| MsgRun('Visualizando Nota Fiscal','Processando',{|| FINBXVSF2(_cAliasTmp) , oBrowEs:refresh(.t.)}) } })

	AADD(_a_TeclaF, {VK_F6, {|| MsgRun('Visualizando Titulo a Receber','Processando',{|| FINBXVSE1(_cAliasTmp) , oBrowEs:refresh(.t.) })} })
	AADD(_a_TeclaF, {VK_F7, {|| MsgRun('Visualizando Nota Fiscal','Processando',{|| FINBXVSF2(_cAliasTmp) , oBrowEs:refresh(.t.) })} })

	// Pesquisa que será apresentada na tela : 1a array do create, 2o da pesquisa
	//               Cpo Tab Temp
	aAdd(_aSeek,	{ {"DT_EMISSAO"} 	,{"Emissão"			,{{"","D",008,0,"Emissão"		,""}} 	}} )
	aAdd(_aSeek,	{ {"NUM_NF"} 		,{"Num.Titulo"		,{{"","C",040,0,"Numero"		,"@!"}} }} )

	FINBX_BROW("ZHD",_aEstruCpo,_cTabWhere,_cCPOEXCLU,/*_cCpo_OK*/,_aLegenda,_cTitRotin,_a_Botoes,_cMenuDef,_a_TeclaF,_aSeek,_cDirSql)

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} EEC83B()
Monta o Mark Browser

@author Renato Junior

@since 07/08/20
@version 1.0
@return Nil
/*/
//------------------------------------------------------------------
Static Function FINBX_BROW(cTabPrinci,XaEstruCpo,XcTabWhere,XcCPOEXCLU,XcCpo_OK,XaLegenda,XcTitRotin,Xa_Botoes,XcMenuDef,Xa_TeclaF,XaSeek,XcDirSql)
	Local _cTmp		    :=  GetNextAlias()
	Local _aColumns	    :=  {}
	Local _cInsert      :=  ''
	Local _nx           :=  0
	Local _cFim         :=  CHR(13) + CHR(10)
	Local nStatus		:=	0
	Local _cNomCampo	:=	""
	Local _cCpSelect	:=	""
	Local _aStrutLib   :=  {}
	Local _cCpInsert	:=	""
	Local _aPicture		:=	{}
	Local _aTituloX3	:=	{}
	Local _aSeek	:=	{}

	Private _cAliasTmp

	For _nx := 1 to len(XaEstruCpo)
		// Coluna do Select  : prefixo + ponto + nome
		If	! XaEstruCpo[_nx][2]	==	Nil
			_cNomCampo	:=	Iif(XaEstruCpo[_nx][1]==Nil,"",XaEstruCpo[_nx][1] + ".") + XaEstruCpo[_nx][2]
			//	Adiciona colunas do Select
			_cCpSelect	+= Iif(_nx > 1, ", ","")
			_cCpSelect	+=	_cNomCampo
			If ! XaEstruCpo[_nx][4] == nil	// Tem ALIAS , concatena
				_cCpSelect	+=	" AS " + XaEstruCpo[_nx][4]
			Endif
		Endif
		// Adiciona Picture em Array
		If XaEstruCpo[_nx][5] == nil
			AADD( _aPicture, Posicione("SX3",2,_cNomCampo,"X3_PICTURE") )
		Else
			AADD( _aPicture, XaEstruCpo[_nx][5] )
		Endif
		// Coluna do Insert  : prefixo + ponto + nome
		If	! XaEstruCpo[_nx][2]	==	Nil
			_cNomCampo	:=	Iif( XaEstruCpo[_nx][4] == nil, XaEstruCpo[_nx][2],XaEstruCpo[_nx][4])
			_cCpInsert	+=	Iif(_nx > 1, ", ","")	+	_cNomCampo
		Else
			_cNomCampo	:=	XaEstruCpo[_nx][4]
		Endif
		// Adiciona Tipo, Tmanho, Decimal e Titulo
		If XaEstruCpo[_nx][3] == nil
			aRet	:=	TamSX3( XaEstruCpo[_nx][2])
			AADD( _aTituloX3, RetTitle(XaEstruCpo[_nx][2]) )
		ElseIf ValType( XaEstruCpo[_nx][3]) == "C"
			aRet	:=	TamSX3( XaEstruCpo[_nx][3])
			AADD( _aTituloX3, RetTitle(XaEstruCpo[_nx][3]) )
		Else
			aRet	:=	XaEstruCpo[_nx][3]
			AADD( _aTituloX3, aRet[4] )
		Endif
		AADD(_aStrutLib, {_cNomCampo		,aRet[3], aRet[1], aRet[2]})
	Next _nx

	dbSelectarea(cTabPrinci)
	Dbsetorder(1)
	//Instancio o objeto que vai criar a tabela temporária no BD para poder utilizar posteriormente
	oTmpE := FWTemporaryTable():New( _cTmp )
	//Defino os campos da tabela temporária
	oTmpE:SetFields(_aStrutLib)

	If Valtype(XaSeek)	<> "U"	//Habilita a utilização da pesquisa de registros no Browse
		For _nx := 1 To Len(XaSeek)
			oTmpE:AddIndex( STRZERO(_nx,2), XaSeek[_nx][1] )
		Next
	Endif
	//Criação da tabela temporária no BD
	oTmpE:Create()
	//Obtenho o nome "verdadeiro" da tabela no BD (criada como temporária)
	_cTable := oTmpE:GetRealName()
	//Preparo o comando para alimentar a tabela temporária
	_cInsert += "INSERT INTO " + _cTable + _cFim
	_cInsert += "( " + _cFim + _cCpInsert + _cFim + ") " + _cFim

	_cInsert += "SELECT " + _cFim + _cCpSelect + _cFim

	_cInsert += XcTabWhere

	//Executo o comando para alimentar a tabela temporária
	If Valtype(XcDirSql)	<> "U"	// Campo OK
		memowrite(XcDirSql, _cInsert  )
	Endif

	_cInsert := strTran(_cInsert, _cFim, '')

	Processa({||   (nStatus := TcSQLExec(_cInsert))})
	If (nStatus < 0)
		Help( ,, "TCSQLError() ",, TCSQLError(), 1, 0 )
	Endif
	For _nx := 1 To Len(_aStrutLib)
		if !(_aStrutLib[_nx][1] $ XcCPOEXCLU)
			aadd(_aColumns,FWBrwColumn():New())
			_aColumns[Len(_aColumns)]:SetData( &("{||"+_aStrutLib[_nx][1]+"}") )
			_aColumns[Len(_aColumns)]:SetTitle(	_aTituloX3[_nx])
			_aColumns[Len(_aColumns)]:SetPicture(	_aPicture[_nx])
			_aColumns[Len(_aColumns)]:SetSize(	_aStrutLib[_nx][3])
			_aColumns[Len(_aColumns)]:SetDecimal(	_aStrutLib[_nx][4])
		EndIf
	Next _nx

	_cAliasTmp := oTmpE:GetAlias()
	oBrowEs:= FWMarkBrowse():New()
	oBrowEs:SetAlias( _cAliasTmp )
	oBrowEs:SetDescription( XcTitRotin)
	oBrowEs:SetTemporary(.T.)
	oBrowEs:SetLocate()
	oBrowEs:SetUseFilter(.T.)
	oBrowEs:SetDBFFilter(.T.)

	If Valtype(XaSeek)	<> "U"	//Habilita a utilização da pesquisa de registros no Browse
		For _nx := 1 To Len(XaSeek)
			aAdd(_aSeek,{XaSeek[_nx][2][1]	,XaSeek[_nx][2][2] } )
		Next
		oBrowEs:SetSeek(.T.,_aSeek)
	Endif
	oBrowEs:SetFilterDefault( "" )
	oBrowEs:DisableDetails()

	If Valtype(Xa_Botoes)	<> "U"	// Definição dos Botões
		For _nx := 1 To Len(Xa_Botoes)
			oBrowEs:AddButton(Xa_Botoes[_nx][1], Xa_Botoes[_nx][2],,,, .F., 2 )
		Next _nx
	Endif
	// Visualizacao do Registro como Axvisual
	oBrowEs:AddButton("Visualiza", {|| MBrowVisu(_cAliasTmp, _aTituloX3, XcTitRotin)},,,, .F., 2 )

	If Valtype(XcCpo_OK)	<> "U"	// Campo OK
		oBrowEs:AddButton("Marcar Todos", {|| xMarkAll()},,,, .F., 2 )
		oBrowEs:AddButton("Desmarc.Todos", {|| xMarkAll()},,,, .F., 2 )
		oBrowEs:SetFieldMark(XcCpo_OK)
		oBrowEs:SetCustomMarkRec({||xMark(XcCpo_OK)})
		oBrowEs:SetAllMark({|| xMarkAll(XcCpo_OK) })
	Endif
	// Definição da legenda
	If Valtype(XaLegenda)	<> "U"
		For _nx := 1 To Len(XaLegenda)
			oBrowEs:AddLegend( XaLegenda[_nx][1],	XaLegenda[_nx][2],	XaLegenda[_nx][3] )
		Next _nx
	Endif

	oBrowEs:SetColumns(_aColumns)
	// Menu da rotina Chamadora
	If Valtype(XcMenuDef)	<> "U"
		oBrowEs:SetMenuDef(XcMenuDef)
	Endif
	// Define Atalho
	If Valtype(Xa_TeclaF)	<> "U"
		For _nx := 1 To Len(Xa_TeclaF)
			SetKey( Xa_TeclaF[_nx][1],	Xa_TeclaF[_nx][2])
		Next _nx
	Endif
	oBrowEs:Activate()
	oTmpE:Delete()
	//-- Limpa atalho
	If Valtype(Xa_TeclaF)	<> "U"
		For _nx := 1 To Len(Xa_TeclaF)
			SetKey(Xa_TeclaF[_nx][1],Nil)
		Next _nx
	Endif
Return Nil

/*/{Protheus.doc} xMark()
// Marca todas as opções com Zero de diferença

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return lRet
/*/
static function xMark(XcCpo_OK)
	local cAlias    :=  oBrowEs:Alias()
	local lRet      :=  .T.

	If (!oBrowEs:IsMark())
		RecLock(cAlias,.F.)
		(cAlias)->&(XcCpo_OK)  := oBrowEs:Mark()
		(cAlias)->(MsUnLock())
	Else
		RecLock(cAlias,.F.)
		(cAlias)->&(XcCpo_OK)  := ""
		(cAlias)->(MsUnLock())
	EndIf

Return lRet


/*/{Protheus.doc} xMarkAll()
// inverte a marcação de todos os itens

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return lRet
/*/
static function xMarkAll(XcCpo_OK)
	local lRet      :=  .T.
	local cAlias	:= oBrowEs:Alias()
	local aRest		:= GetArea()

	(cAlias)->(DbGoTop())
	While (cAlias)->(!Eof())
		RecLock(cAlias,.F.)
		If (!oBrowEs:IsMark())
			(cAlias)->&(XcCpo_OK)  := oBrowEs:Mark()
		Else
			(cAlias)->&(XcCpo_OK)  := ""
		EndIf
		(cAlias)->(MsUnLock())
		(cAlias)->(DbSkip())
	EndDo

	RestArea(aRest)
	oBrowEs:refresh(.F.)
Return lRet

/*/{Protheus.doc} MBrowVisu
Função para visualizar dados do registro do arquivo temporário.

@author Renato Bandeira
@since 03/11/2020
/*/
Static Function MBrowVisu(XcAliasTmp, XaTituloX3, XcTitRotin)
	Local nI := 0
	Local nRec := (XcAliasTmp)->(RecNo())
	Local nTop := 0
	Local nLeft := 0
	Local nBottom := 0
	Local nRight := 0

	Local aInfo := {}
	Local aHead := {}
	Local aStruct := {}
	Local oDlg
	Local oEnchoice

	// Carregar o vetor com os títulos dos campos.
	aStruct := (XcAliasTmp)->( dbStruct() )	// Buscar a estrutura da área de trabalho.
	For nI :=	1	TO	LEN(aStruct )	// Montar os SAY e GET da Enchoice.
		ADD FIELD aInfo TITULO XaTituloX3[nI] CAMPO aStruct[nI,1] TIPO aStruct[nI,2] TAMANHO aStruct[nI,3] DECIMAL aStruct[nI,4] NIVEL 1
		cField := aInfo[nI][2]
		M->&(cField) := (XcAliasTmp)->&(cField)
	Next
	If SetMDIChild()		// Definir as coordenadas para a janela.
		oMainWnd:ReadClientCoors()
		nTop := 40
		nLeft := 30
		nBottom := oMainWnd:nBottom-80
		nRight := oMainWnd:nRight-70
	Else
		nTop := 135
		nLeft := 0
		nBottom := TranslateBottom(.T.,28)
		nRight := 632
	Endif
	// Apresentar os dados para visualização no objeto.
	DEFINE MSDIALOG oDlg TITLE XcTitRotin FROM nTop,nLeft TO nBottom,nRight PIXEL
	oEnchoice := MsMGet():New( XcAliasTmp ,nRec,2,,,,,{0,0,0,0},,,,,,oDlg,,,.F.,,,,aInfo)
	oEnchoice:oBox:Align := CONTROL_ALIGN_ALLCLIENT
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() }, {|| oDlg:End() })
Return

/*/{Protheus.doc} FINBXEmail
Função para Enviar e-mail para Analise do Desconto

@author Renato Bandeira
@since 24/09/2020

@param - Xanivel - array com os niveis + grupos
/*/
Static Function FINBXEmail(XaNivel)
	Local _cNiveis	:=	""
	local cEmailDE	:=	ALLTRIM(UsrRetMail(RetCodUsr()))
	Local cEmailPA	:=	""
	Local _lAchou	:=	.F.
	Local cQuery		:= ''
	Local cNextAlias	:= GetNextAlias()
	Local _nCr1			:=	0
	Local _cAnexoPDF	:=	""

	For	_nCr1	:=	1	TO LEN(XaNivel)	//	Ajusta sequencia de nivel+grupos
		_cNiveis	+=	XaNivel[_nCr1]+","
	Next
	If RIGHT(_cNiveis,1)==","
		_cNiveis	:=	LEFT(_cNiveis, LEN(_cNiveis)-1)
	Endif

	cQuery  += " SELECT ZGR_USRCOD FROM "+RetSqlName("ZGR")+" ZGR "
	cQuery  += " WHERE ZGR.D_E_L_E_T_ = ' ' "
	cQuery  += " AND ZGR_NIVEL IN ('"+_cNiveis+"') "
	cQuery  += " AND ZGR_GATIVO = 'S' AND ZGR_ATIVO= 'S' "	// Grupo e Linha Ativos
	cQuery  += " AND ZGR_ROTINA LIKE '%2%' "	// Apenas verifica para grupos da Rotina 2 - so poderá ter um grupo Ativo Cadastrado
	cQuery  += " GROUP BY ZGR_USRCOD "

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
	dbSelectArea(cNextAlias)
	(cNextAlias)->(dbGoTop())
	While ! (cNextAlias)->(Eof())
		cEmailPA += ChkExisCarat(";", cEmailPA) + ALLTRIM(UsrRetMail((cNextAlias)->ZGR_USRCOD))
		_lAchou	:=	.T.
		(cNextAlias)->(Dbskip())
	Enddo
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	If _lAchou
		_cAnexoPDF := FINBX_PDF( FINBX_05() )
		EnvMail({cEmailDE, cEmailPA, cEmailCC, _cAnexoPDF  })
		Ferase(_cAnexoPDF)
	Endif

Return Nil

//----------------------------------------------
// Envio de e-mail
// Exemplo de chamada : EnvMail({cEmailDE,cKeyLoop,cEmailCC}, cCorpo,"Cliente") )
//----------------------------------------------
Static Function EnvMail(aEmPara)

	Local oMail, oMessage
	Local nErro		:= 0
	Local lRetMail 	:= .T.
	Local cSmtpSrv  := GETMV("MGF_SMTPSV")
	Local cCtMail   := ""
	Local cPwdMail  := ""
	Local nParSmtpP := GETMV("MGF_PTSMTP")
	Local nSmtpPort
	Local nTimeOut  := GETMV("MGF_TMOUT")
	Local cEmail    := aEmPara[1]
	Local cPara		:= aEmPara[2]
	Local cCopia	:= aEmPara[3]
	Local cAnexoPDF	:= aEmPara[4]
	Local cSubject	:=	""

	Local cErrMail

	cCtMail	:=	LEFT(cEmail, AT("@",cEmail)-1)
	cSubject	:=	"Fechamento "+ZHC->ZHC_CONTRA+" – "+ALLTRIM(Posicione("CN9",1,xFilial("CN9")+ZHC->(ZHC_CONTRA+ZHC_REVISA),"CN9_ZNOME"))
	oMail := TMailManager():New()

	if nParSmtpP == 25
		oMail:SetUseSSL( .F. )
		oMail:SetUseTLS( .F. )
		oMail:Init("", cSmtpSrv, "", "",, nParSmtpP)
	elseif nParSmtpP == 465
		nSmtpPort := nParSmtpP
		oMail:SetUseSSL( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	else
		nParSmtpP == 587
		nSmtpPort := nParSmtpP
		oMail:SetUseTLS( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	endif

	oMail:SetSmtpTimeOut( nTimeOut )
	nErro := oMail:SmtpConnect()

	If nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	If 	nParSmtpP != 25
		nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
		If nErro != 0
			cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
			conout(cErrMail)
			oMail:SMTPDisconnect()
			lRetMail := .F.
			Return (lRetMail)
		Endif
	Endif

	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom                  := cEmail
	oMessage:cTo                    := cPara
	oMessage:cCc                    := cCopia
	oMessage:cSubject               := cSubject
	oMessage:cBody                  := bodyMail()	//cCorpo, cCliOuCom)

	If !Empty(cAnexoPDF)
		nErro := oMessage:AttachFile( cAnexoPDF )
		If nErro < 0
			Help( ,, 'Anexo em PDF',, 'Não foi possível anexar : ' + cAnexoPDF, 1, 0 )
		Endif
	Endif
	nErro := oMessage:Send( oMail )
	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()

Return .T.

//----------------------------------------------
// Corpo do e-mail e inclusao da tabela
//----------------------------------------------
static function bodyMail()	//cCorpo, cCliOuCom)
	Local cHtml 	:= ""

	cHtml += "<!DOCTYPE html>"
	cHtml += "<html> "
	cHtml += "<head> "
	cHtml += "<style> "
	cHtml += "table { "
	cHtml += "font-family: arial, sans-serif; "
	cHtml += "border-collapse: collapse; "
	cHtml += "width: 100%; "
	cHtml += "} "

	cHtml += "td, th { "
	cHtml += "border: 1px solid #dddddd; "
	cHtml += "text-align: left; "
	cHtml += "padding: 8px; "
	cHtml += "} "

	cHtml += " </style> "
	cHtml += "</head> "
	cHtml += "  </html> "

	cHtml += "<HTML> "
	cHtml += "<HEAD> "
	cHtml += "<style> "
	cHtml += "table, th, td {  "
	cHtml += "border: 0; "

	cHtml += " }  "
	cHtml += "th, td { "
	cHtml += "padding: 5px; "
	cHtml += "text-align: left; "
	cHtml += "} "
	cHtml += "</style> "

	cHtml += "<p><span style='color:black'>Olá,<o:p></o:p></span></p>"
	cHtml += "<p></p>"
	cHtml += "<p><span style='color:black'>Segue ACORDO DESCONTO DE  "+TRANSFORM(ZHC->ZHC_DESCON,"@E 99.99")+" % - PERIODO DE "+DTOC(ZHC->ZHC_DATADE)+" A "+DTOC(ZHC->ZHC_DATATE)+".<o:p></o:p></span></p>"

	cHtml += "<p></p>"
	cHtml += "<p><span style='color:black'>Att<o:p></o:p></span></p>"
	cHtml += "<p></p>"
	cHtml += "<p><span style='color:black'>Contas a Receber<o:p></o:p></span></p>"

	cHtml += "</head> "

	cHtml += " <body lang=PT-BR style='tab-interval:35.4pt'> "
	cHtml += "<div class=WordSection1> "


	cHtml += "<p class=MsoNormal><o:p>&nbsp;</o:p></p> "
	cHtml += "<p class=MsoNormal><o:p>&nbsp;</o:p></p> "
	cHtml += "</div> "
	cHtml += "</body> "

	cHtml += " </html> "

	//memowrite("c:\totvs\RVBJ_MGFFINBP3.HTML", cHtml  )	// remover

Return cHtml

//----------------------------------------------------------------------------
// Retorna caracter para contenar analisando a necessidade
//----------------------------------------------------------------------------
Static Function ChkExisCarat(cOqProcurar, cVariavel)
	cOqProcurar	:=	Iif(!Empty(cVariavel),cOqProcurar,"")
Return( cOqProcurar)

//-------------------------------------------------------------------
/*/{Protheus.doc} GerTitSel()
Efetua o Msexecauto dos titulos para inclusao de NCC
@author Renato Junior

@since 28/09/2020
@return lRetSeg
/*/
//-------------------------------------------------------------------
Static Function GerTitSel(aParametros)
	Local nCtt          :=  0
	Local _aParSE1	    :=	{}
	Local aTitulo       := {}
	Local _nTotTit	    :=	len(aParametros)
	Local lCtbOnLine	:= .F.
	Local nHdlPrv		:= 0
	Local _cE1HIST		:=	IIF(ZHC->ZHC_TIPO=="1","ACORDO","FECHAMENTO")+ " Desconto de "+TRANSFORM(ZHC->ZHC_DESCON,"@E 99.99")+" % - período de "+DTOC(ZHC->ZHC_DATADE)+" a "+DTOC(ZHC->ZHC_DATATE)

	DEFAULT lCtbOnLine	:= .F.
	DEFAULT nHdlPrv		:= 0

	ProcRegua( _nTotTit )
	For nCtt	:=	1	TO _nTotTit
		IncProc("Executando solicitação : " + STR(nCtt))
		_aParSE1	:=	aParametros[nCtt]
		nStackSX8 := GetSx8Len()
		aTitulo := {}
		AADD(aTitulo, { "E1_PREFIXO"	, "MAN"			, NIL })
		AADD(aTitulo, { "E1_NUM"      	, GETSXENUM("SE1","E1_NUM")	, NIL })
		AADD(aTitulo, { "E1_PARCELA"	, "01"			, NIL })
		AADD(aTitulo, { "E1_TIPO"		, "NCC"			, NIL })
		AADD(aTitulo, { "E1_CLIENTE"	, _aParSE1[01]	, NIL })
		AADD(aTitulo, { "E1_LOJA"		, _aParSE1[02]	, NIL })
		AADD(aTitulo, { "E1_VENCTO"		, dDataBase     , NIL })
		AADD(aTitulo, { "E1_VENCREA"	, dDataBase     , NIL })
		AADD(aTitulo, { "E1_EMISSAO"	, dDataBase		, NIL })
		AADD(aTitulo, { "E1_NATUREZ"	, _aParSE1[03]	, NIL })
		AADD(aTitulo, { "E1_VALOR"		, _aParSE1[04]	, NIL })
		AADD(aTitulo, { "E1_HIST"		, _cE1HIST		, NIL })

		lMsErroAuto := .F.
		MsExecAuto( { |x,y| FINA040(x,y)} , aTitulo, 3 /*_nOqFazer*/)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
		If lMsErroAuto // SE ENCONTROU ALGUM ERRO
			MostraErro()
			While GetSX8Len() > nStackSX8
				ROLLBACKSX8()
			EndDo
		Else
			While GetSX8Len() > nStackSX8
				CONFIRMSX8()
			EndDo
		Endif
	Next
Return	//(lRetSeg)


/*/{Protheus.doc} FINBX_02
Executa função para inclusao dos titulos

@author Renato Bandeira
@since 14/09/2020
/*/
Static function FINBX_02()
	//Local _cCodUsr	:=	RetCodUsr()
	Local _lAchou	:=	.F.
	Local cQuery		:= ''
	Local cNextAlias	:= GetNextAlias()

	cQuery  += " SELECT ZGR_USRCOD FROM "+RetSqlName("ZGR")+" ZGR "
	cQuery  += " WHERE ZGR.D_E_L_E_T_ = ' ' "
	cQuery  += " AND ZGR_USRCOD = '"+RetCodUsr()+"' "
	cQuery  += " AND ZGR_GATIVO = 'S' AND ZGR_ATIVO= 'S' "	// Grupo e Linha Ativos
	cQuery  += " AND ZGR_ROTINA LIKE '%2%' "	// Apenas verifica para grupos da Rotina 2 - so poderá ter um grupo Ativo Cadastrado
	cQuery  += " GROUP BY ZGR_USRCOD "

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
	dbSelectArea(cNextAlias)
	If  ! (cNextAlias)->(Eof())
		_lAchou	:=	.T.
	Endif
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

Return _lAchou


/*/{Protheus.doc} FINBX_PDF
Executa função para geram relatorio de análise dos descontos em PDF
Retornara caminho que deverá ser anexado ao e-mail

@author Renato Bandeira
@since 02/10/2020
@return aAnexos - Array com anexos

/*/
Static Function FINBX_PDF(XcAliasTmp)
	Local lAdjustToLegacy := .F.
	Local lDisableSetup  := .T.
	Local oPrinter
	Local cLocal		:= GetTempPath(.T.)	//"c:\totvs\pdf\"
	Local _cDestino		:= "\mgf"	//"\.Bandeira\PDF"
	Local _cNomArqui      := ZHC->(ZHC_CONTRA+"_"+ZHC_REVISA+"_"+ZHC_TIPO)+".pd_"
	Local cFilePrint := ""
	Local nLin	:=	0

	Private nColFim     := 2200
	Private nBor		:= 10

	oFont09		:= TFont():New( "Courier New",,09,,.F.,,,,,.F. )
	oFont09B	:= TFont():New( "Courier New",,09,,.T.,,,,,.F. )
	oFont10		:= TFont():New( "Courier New",,10,,.F.,,,,,.F. )
	oFont10B	:= TFont():New( "Courier New",,10,,.T.,,,,,.F. )
	oFont11B	:= TFont():New( "Courier New",,11,,.T.,,,,,.F. )
	oFont12B	:= TFont():New( "Courier New",,12,,.T.,,,,,.F. )
	oFont13B	:= TFont():New( "Courier New",,13,,.T.,,,,,.F. )
	oFont14B	:= TFont():New( "Times New Roman",,14,,.T.,,,,,.F. )
	oFont16B	:= TFont():New( "Times New Roman",,16,,.T.,,,,,.F. )

	oPrinter := FWMSPrinter():New(_cNomArqui, IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , , .F. )
	oPrinter:SetLandscape()

	oPrinter:SetPaperSize(8)

	nLinQueb	:=	9999
	While ! (XcAliasTmp)->(EOF())

		oPrinter:StartPage()
		nLin := 50
		nEsp := 20
		oPrinter:Say(nLin,0005, "RELATÓRIO DE FECHAMENTO MENSAL POR DATA DE EMISSÃO PARA APURAÇÃO DO DESCONTO COMERCIAL - BASE PROTHEUS",oFont16B)
		oPrinter:Say(nLin,1050, "EMISSÃO : "+dtoc(dDataBase),oFont16B)
		nLin += nEsp-5
		oPrinter:Say(nLin,005, "Cliente: "+ALLTRIM(Posicione("CN9",1,xFilial("CN9")+ZHC->(ZHC_CONTRA+ZHC_REVISA),"CN9_ZNOME")) + ;
			IIF(ZHC->ZHC_TIPO=="1","    ACORDO","    FECHAMENTO")+ "    Desconto de "+TRANSFORM(ZHC->ZHC_DESCON,"@E 99.99")+ ;
			" % - período de "+DTOC(ZHC->ZHC_DATADE)+" a "+DTOC(ZHC->ZHC_DATATE)	,oFont14B)

		nLin += nEsp * 3
		oPrinter:Say(nLin, 0850 /*0830*/, "Valor           Devolução      Líquido        Desconto"				,oFont12B)

		nLin += nEsp
		oPrinter:Say(nLin, 0670 /*0700*/ , "Peso   "+LTRIM(TRANSFORM(ZHC->ZHC_PESOT , "@E 9999999.9999"))+;
			"       Total       "+LTRIM(TRANSFORM(ZHC->ZHC_TOTVAL, "@E 99,999,999,999,999.99"))+ ;
			"     R$     "+LTRIM(TRANSFORM(ZHC->ZHC_TOTDEV, "@E 99,999,999,999,999.99"))+;
			"     R$     "+LTRIM(TRANSFORM(ZHC->(ZHC_TOTVAL-ZHC_TOTDEV), "@E 99,999,999,999,999.99"))+ ;
			"     R$     "+LTRIM(TRANSFORM(IIF(ZHC->ZHC_DESCON>0,(ZHC->(ZHC_TOTVAL-ZHC_TOTDEV) * ZHC->ZHC_DESCON)/100,0), "@E 99,999,999,999.99")),oFont14B,)

		nEsp	:= 20
		nB_01 := 			003
		nB_02 :=	nB_01 + 050
		nB_03 :=	nB_02 + 150
		nB_04 :=	nB_03 + 085
		nB_05 :=	nB_04 + 080

		nC_02 :=	nB_05 + 065
		nC_03 :=	nC_02 + 025
		nC_04 :=	nC_03 + 058
		nC_05 :=	nC_04 + 045
		//nC_06 :=	nC_05 + 030
		nC_07 :=	nC_05 + 035	//45
		nC_08 :=	nC_07 + 067
		nC_09 :=	nC_08 + 065
		nC_10 :=	nC_09 + 120
		nC_11 :=	nC_10 + 065
		nC_12 :=	nC_11 + 060	//70
		nC_13 :=	nC_12 + 080	//85
//			nLin 	+= (nEsp * 2) * 0.75
		nLin 	+= nEsp * 3
		nCentra	:=	015		//13		//10		//008

		oPrinter:Say(nLin, nB_01+(nCentra*0), "Unidade"					,oFont11B)
		oPrinter:Say(nLin, nB_02+(nCentra*3), "Cod/Cliente"				,oFont11B)
		oPrinter:Say(nLin, nB_03+(nCentra*2), "CNPJ"					,oFont11B)
		oPrinter:Say(nLin, nB_04+(nCentra*4), "Rede"					,oFont11B)
		oPrinter:Say(nLin, nC_02+(nCentra*2), "Tipo"					,oFont11B)
		oPrinter:Say(nLin, nC_03+(nCentra*3), "Emissão"					,oFont11B)
		oPrinter:Say(nLin, nC_04+(nCentra*3), "Vencimento"				,oFont11B)
		//oPrinter:Say(nLin, nC_06+(nCentra*0), "Natureza"				,oFont11B)
		oPrinter:Say(nLin, nC_07+(nCentra*4)-5, "N.Fiscal"				,oFont11B)	//0
		oPrinter:Say(nLin, nC_08+(nCentra*5), "Peso"					,oFont11B)
		oPrinter:Say(nLin, nC_09+(nCentra*5), "Observação"				,oFont11B)
		oPrinter:Say(nLin, nC_10+(nCentra*5), "Valor"					,oFont11B)
		oPrinter:Say(nLin, nC_11+(nCentra*5), "Devolução"				,oFont11B)
		oPrinter:Say(nLin, nC_12+(nCentra*6), "Líquido"					,oFont11B)
		oPrinter:Say(nLin, nC_13+(nCentra*6), "Desconto"				,oFont11B)
		nLin 	+= nEsp * 0.5
		// Immprime Detalhes
		_cCODFILIAL	:=	(XcAliasTmp)->COD_FILIAL
		_cNUMCNPJ	:=	(XcAliasTmp)->NUM_CNPJ

		nEsp	:= 25
		nLinQueb	:=	0
		While ! (XcAliasTmp)->(EOF())	.AND. ++nLinQueb <= 27
			nCentra	:=	007
			nLin += nEsp
			oPrinter:Say(nLin, nB_01+(nCentra*00), RTRIM((XcAliasTmp)->COD_FILIAL),														oFont11B)
			oPrinter:Say(nLin, nB_02+(nCentra*01), (XcAliasTmp)->(CODCLIENTE+'/'+LEFT(NOMCLIENTE,20)),									oFont11B)
			oPrinter:Say(nLin, nB_03+(nCentra*02), (XcAliasTmp)->NUM_CNPJ,																oFont11B)
			oPrinter:Say(nLin, nB_04+(nCentra*03), (XcAliasTmp)->(COD_REDE+'/'+LEFT(DESC_REDE,20)),										oFont11B)
			//
			oPrinter:Say(nLin, nC_02+(nCentra*04), (XcAliasTmp)->TIP_DOCTO,																oFont11B)
			oPrinter:Say(nLin, nC_03+(nCentra*05), DTOC(STOD((XcAliasTmp)->DT_EMISSAO)),													oFont11B)
			oPrinter:Say(nLin, nC_04+(nCentra*06), DTOC(STOD((XcAliasTmp)->DT_VENCTO)),													oFont11B)
			//oPrinter:Say(nLin, nC_06, (XcAliasTmp)->NATUREZA,																oFont11B)
			oPrinter:Say(nLin, nC_07+(nCentra*07), (XcAliasTmp)->NUM_NF,																	oFont11B)
			oPrinter:Say(nLin, nC_08+(nCentra*08), Transform((XcAliasTmp)->VLR_PLIQNF, PesqPict("ZHD","ZHD_PESO")),						oFont11B)
			oPrinter:Say(nLin, nC_09+(nCentra*09), LEFT((XcAliasTmp)->OBSERVACAO,15),												oFont11B)
			oPrinter:Say(nLin, nC_10+(nCentra*10), ALLTRIM(Transform((XcAliasTmp)->ZHD_TOTVAL, PesqPict("ZHD","ZHD_TOTVAL"))),			oFont11B)
			oPrinter:Say(nLin, nC_11+(nCentra*11), ALLTRIM(Transform((XcAliasTmp)->ZHD_TOTDEV, PesqPict("ZHD","ZHD_TOTDEV"))),			oFont11B)
			oPrinter:Say(nLin, nC_12+(nCentra*12), ALLTRIM(Transform((XcAliasTmp)->(ZHD_TOTVAL-ZHD_TOTDEV), "@E 99,999,999,999,999.99")),oFont11B)
			oPrinter:Say(nLin, nC_13+(nCentra*13), ALLTRIM(Transform((XcAliasTmp)->(ZHD_TOTVAL-ZHD_TOTDEV) * (ZHC->ZHC_DESCON/100), "@E 99,999,999,999.99")),	oFont11B)
			(XcAliasTmp)->(DBSKIP())
		Enddo

		oPrinter:EndPage()

	Enddo

	If Select(XcAliasTmp) > 0
		(XcAliasTmp)->(DbClosearea())
	Endif

	cFilePrint := cLocal+_cNomArqui
	File2Printer( cFilePrint, "PDF" )
	oPrinter:cPathPDF:= cLocal
	oPrinter:SetViewPDF(.F.)
	oPrinter:Preview()

	cFilePrint	:=	STRTRAN(cFilePrint,".pd_",".pdf")
	If ! CpyT2S( cFilePrint, _cDestino , .F. )
		Help( ,, 'Relatorio em PDF',, 'Não foi possível transferir/anexar ao e-mail', 1, 0 )
	Else
		ferase( cFilePrint)
		_cNomArqui	:=	STRTRAN(_cNomArqui,".pd_",".pdf")
		c_Anexo :=	_cDestino + "\"+ _cNomArqui
	Endif
Return(	c_Anexo)


/*/{Protheus.doc} FINBX_05
Select na tabela ZHd relaciondo com as demais - Utilizado na geracao do PDF

@author Renato Bandeira
@since 05/10/2020
/*/
Static function FINBX_05()
	Local cQuery		:= ''
	Local cNextAlias	:= GetNextAlias()

	cQuery  += " SELECT "
	cQuery  += " FIL.M0_CODFIL AS COD_FILIAL, FIL.M0_FILIAL AS NOM_FILIAL, CR.E1_EMISSAO AS DT_EMISSAO, CR.E1_VENCTO AS DT_VENCTO,  "
	cQuery  += " CASE WHEN CR.E1_SALDO = 0 THEN 'TITULO BAIXADO' WHEN (CR.E1_SALDO + CR.E1_SDACRES) <> (CR.E1_VALOR + CR.E1_SDACRES) THEN 'BAIXADO PARCIALMENTE' WHEN CR.E1_NUMBOR <> '' THEN 'TITULO EM BORDERO' WHEN CR.E1_NUMBOR <> '' AND (CR.E1_SALDO <> CR.E1_VALOR) THEN 'TITULO BAIXADO PARCIALMENTE E EM BORDERO' ELSE 'TITULO EM ABERTO' END AS STATUS_TIT, "
	cQuery  += " CLI.A1_COD AS CODCLIENTE, CLI.A1_NOME AS NOMCLIENTE, CLI.A1_CGC AS NUM_CNPJ, "
	cQuery  += " RED.ZQ_COD AS COD_REDE, RED.ZQ_DESCR AS DESC_REDE, "
	cQuery  += " SEG.AOV_CODSEG AS COD_SEGTO, SEG.AOV_DESSEG AS DESC_SEGTO, "
	cQuery  += " CR.E1_PORTADO AS COD_PORTAD, CR.E1_TIPO AS TIP_DOCTO, CR.E1_PREFIXO AS SERIE_NF, CR.E1_NUM AS NUM_NF, "
	cQuery  += " ZHD_PESO AS VLR_PLIQNF, CR.E1_VEND1 AS COD_VEND, NVL(VEN.A3_NOME,' ') AS NOM_VEND, CR.E1_HIST AS OBSERVACAO, "
	cQuery  += " CR.E1_NATUREZ AS NATUREZA, ZHD_TOTVAL, ZHD_TOTDEV "

	cQuery	+=	" FROM "+ RetSQLName("ZHD") +" ZHD "
	cQuery	+=	" INNER JOIN "+ RetSQLName("SE1") +" CR ON CR.R_E_C_N_O_ = ZHD.ZHD_E1RECN   AND CR.D_E_L_E_T_  = ' ' "
	cQuery	+=	" INNER JOIN SYS_COMPANY  FIL ON CR.E1_FILIAL    = FIL.M0_CODFIL AND FIL.D_E_L_E_T_  = ' ' "
	cQuery	+=	" LEFT JOIN "+ RetSQLName("SA3") +"        VEN ON CR.E1_VEND1     = VEN.A3_COD AND VEN.D_E_L_E_T_ = ' ' "
	cQuery	+=	" INNER JOIN "+ RetSQLName("SA1") +"       CLI ON CR.E1_CLIENTE   = CLI.A1_COD AND CR.E1_LOJA = CLI.A1_LOJA  AND CLI.D_E_L_E_T_  = ' ' "
	cQuery	+=	" LEFT JOIN "+ RetSQLName("SZQ") +"        RED ON CLI.A1_ZREDE    = RED.ZQ_COD AND RED.D_E_L_E_T_  = ' ' "
	cQuery	+=	" LEFT JOIN "+ RetSQLName("AOV") +"        SEG ON CLI.A1_CODSEG   = SEG.AOV_CODSEG AND SEG.D_E_L_E_T_  = ' ' "
	cQuery	+=	" WHERE "
	cQuery	+=	" ZHD_FILIAL = '"+ZHC->ZHC_FILIAL+"' AND ZHD_CONTRA = '"+ZHC->ZHC_CONTRA+"' "
	cQuery	+=	" AND ZHD_REVISA = '"+ZHC->ZHC_REVISA+"' "
	cQuery	+=	" AND ZHD_DATADE = '"+DTOS(ZHC->ZHC_DATADE)+"' AND ZHD_DATATE = '"+DTOS(ZHC->ZHC_DATATE)+"' "
	cQuery	+=	" AND ZHD_TIPO  = '"+ZHC->ZHC_TIPO  +"' AND ZHD.D_E_L_E_T_ = ' ' "

//	cQuery	+=	" ORDER BY FIL.M0_CODFIL, CLI.A1_CGC "
	cQuery	+=	" ORDER BY CR.E1_EMISSAO "

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	cQuery  := ChangeQuery(cQuery)
	// remover
	//memowrite("c:\totvs\MGFFINBX_C.TXT", cQuery  )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
	dbSelectArea(cNextAlias)

Return( cNextAlias)

//----------------------------------------------------------------------------
// Informa email adicional, se desejado
//----------------------------------------------------------------------------
Static Function GetEmailCC(cCodVolta)
	Local cMsg, lOk := .F.
	Local cCod := SPACE(99)

	cMsg := "Deseja enviar os e-mails com copia para outra pessoa ? Digite o endereço :"

	Define MSDialog oDlg Title "E-mail adicional" From 0, 0 To 130, 420 Of oMainWnd Pixel

	@ 016,004 To 166,270 Label Pixel Of oDlg
	@ 036,075 Say cMsg Size 136,200 Pixel Of oDlg
	@ 050,072 MsGet cCod  Size 133,000 Pixel Of oDlg

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(ODlg,{||lRet := .T. , cCodVolta := ALLTRIM(cCod),  ODlg:End()},{||lRet := .F.  ,ODlg:End(),},,)

	If ! lOk
		cCod := ""
	EndIf

Return
