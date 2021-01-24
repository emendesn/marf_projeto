#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'RWMAKE.CH'

#DEFINE CAMPOEXCL	'ZGQ_OK'

/*/
==============================================================================================================================================================================
Descrição   : Tela para Analisar as Solicitações Financeiros

@description
Aprova ou Reprova os títulos

@author     : Renato Junior
@since      : 15/07/2020
@type       : User Function

@table
ZGQ -   SOLICITAÇÕES FINANCEIRAS

@menu
Financeiro - Atualizações-Especificos MARFRIG

@history 
/*/   
User Function MGFFINBS()
Private _cxUser	:=	RetCodUsr()
Private _cGrpValid	:=	""
Private _cZGRTIPO	:=	""

If 	Empty( _cGrpValid:=U_FINBTChk("'"+_cxUser+"'", "", .T., @_cZGRTIPO))
	Help(" ",1,"SEMACESSO",,"Sem acesso para Ciência/Aprovação , Grupo ou Usuário está inativo"+CHR(10)+"Por favor, verifique os Grupos",1,0) //###
Else
	MGFFINBS2( MGFFINBS1() /* Monta a Tabela Temporária */    ) //Monta o Mark Browser
Endif

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFINBS1()
 Monta a Tabela Temporária

@author Renato Junior
@since 15/07/2020
@return _aStrut
/*/
//-------------------------------------------------------------------
Static function MGFFINBS1()
local _aStrut   :=  {}
local _aCampos  :=  {}
local _ni       :=  0
Local _aRet		:=	{}

AADD(_aCampos, 'ZGQ_FILIAL')
AADD(_aCampos, 'ZGQ_ID')
AADD(_aCampos, 'ZGQ_NUM')
AADD(_aCampos, 'ZGQ_PREFIX')
AADD(_aCampos, 'ZGQ_PARCEL')
AADD(_aCampos, 'ZGQ_TIPO')
AADD(_aCampos, 'ZGQ_CLIENT')
AADD(_aCampos, 'ZGQ_LOJA')
AADD(_aCampos, {'E1_NOMCLI'	,'C',40 ,0})
AADD(_aCampos, 'ZGQ_NOVENC')
AADD(_aCampos, 'ZGQ_DESCON')
AADD(_aCampos, 'ZGQ_MOTSOL')
AADD(_aCampos, 'ZGQ_DTHORA')
AADD(_aCampos, 'ZGQ_USUARI')
AADD(_aCampos, 'ZGQ_STATUS')
AADD(_aCampos, 'ZGQ_STPROC')
AADD(_aCampos, {'E1_VENCREA'	,'D',08 ,0})
AADD(_aCampos, {'SALDOTIT'		,'N',16 ,2})
AADD(_aCampos, {'E1_NATUREZ'	,'C',10 ,0})
AADD(_aCampos, {'NOME_GRUPO'	,'C',45 ,0})
AADD(_aCampos, {'ZGQ_OK'		,'C',01 ,0})

For _ni := 1 to len(_aCampos)
	if ValType( _aCampos[_ni]) == "A"
			aadd(_aStrut, _aCampos[_ni])
	Else
		_aRet	:=	TamSX3( _aCampos[_ni])
		AADD(_aStrut, { _aCampos[_ni],	_aRet[3],	_aRet[1],	_aRet[2]})
	Endif
Next _ni

Return _aStrut

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFINBS2
Monta o Mark Browser

@author Renato Junior
@since 15/07/2020
@return Nil
/*/
//-------------------------------------------------------------------
static function MGFFINBS2(strTab)
	local _aStruLib	    :=  strTab //Estrutura da tabela de Aprovação GW3
	local _cTmp		    :=  GetNextAlias()
	local _cAliasTmp
	local _aColumns	    :=  {}
	local _cInsert      :=  ''
	local _nx           :=  0
	local _ni           :=  0
	local _cFim         :=  CHR(13) + CHR(10)
	Local _nCodRetTop	:= 0

	dbSelectarea("ZGQ")
	Dbsetorder(1)

	//Instancio o objeto que vai criar a tabela temporária no BD para poder utilizar posteriormente
	oTmp := FWTemporaryTable():New( _cTmp )

	//Defino os campos da tabela temporária
	oTmp:SetFields(_aStruLib)

	//Criação da tabela temporária no BD
	oTmp:Create()

	//Obtenho o nome "verdadeiro" da tabela no BD (criada como temporária)
	_cTable := oTmp:GetRealName()

	//Preparo o comando para alimentar a tabela temporária - Nao sera considerado Filial no SE1
	_cInsert += "INSERT INTO " + _cTable + _cFim
	_cInsert += " ( " + _cFim
	_cInsert += "ZGQ_DTHORA,ZGQ_USUARI,ZGQ_FILIAL,ZGQ_PREFIX,ZGQ_NUM,ZGQ_PARCEL,ZGQ_TIPO, " + _cFim
	_cInsert += "ZGQ_CLIENT,ZGQ_LOJA,ZGQ_NOVENC,ZGQ_DESCON,ZGQ_MOTSOL,ZGQ_STATUS,ZGQ_STPROC,ZGQ_ID, " + _cFim
	_cInsert += "E1_NOMCLI,E1_VENCREA,SALDOTIT,NOME_GRUPO " + _cFim
	_cInsert += ") " + _cFim

	_cInsert += "SELECT " + _cFim
	_cInsert += "ZGQ_DTHORA,ZGQ_USUARI,ZGQ_FILIAL,ZGQ_PREFIX,ZGQ_NUM,ZGQ_PARCEL,ZGQ_TIPO, " + _cFim
	_cInsert += "ZGQ_CLIENT,ZGQ_LOJA,ZGQ_NOVENC,ZGQ_DESCON,ZGQ_MOTSOL,ZGQ_STATUS,ZGQ_STPROC,ZGQ_ID, " + _cFim
	_cInsert += "A1_NOME E1_NOMCLI, "
//	_cInsert += "NVL(E1_NOMCLI, A1_NOME) E1_NOMCLI, "
	_cInsert += "NVL(E1_VENCREA,' ') E1_VENCREA, NVL(E1_SALDO-E1_SDDECRE+E1_SDACRES,0) SALDOTIT " + _cFim
	_cInsert += ",ZGR.ZGR_CODIGO||'-'||ZGR.ZGR_DESCRI AS NOME_GRUPO " + _cFim

    _cInsert += "FROM "+ RetSQLName("ZGQ") +" ZGQ " + _cFim

	_cInsert += "LEFT JOIN "+ RetSQLName("ZGR") +" ZGR ON ZGR.ZGR_FILIAL = '"+XFILIAL("SA1")+"' AND ZGR.ZGR_CODIGO = ZGQ.ZGQ_CODGRU AND  ZGR.D_E_L_E_T_ = ' ' "
    _cInsert += "AND ZGR_USRCOD = '"+_cxUser+"' " + _cFim			//Somente Solicitacoes do usuario logado

    _cInsert += "LEFT JOIN "+ RetSQLName("SE1") +" SE1 " + _cFim
    _cInsert += "ON E1_FILIAL = ZGQ_FILIAL AND E1_CLIENTE = ZGQ_CLIENT AND E1_LOJA = ZGQ_LOJA AND E1_PREFIXO = ZGQ_PREFIX " + _cFim
    _cInsert += "AND E1_NUM = ZGQ_NUM AND E1_PARCELA = ZGQ_PARCEL AND E1_TIPO = ZGQ_TIPO " + _cFim
	_cInsert += "AND SE1.D_E_L_E_T_ = ' ' "  + _cFim 

    _cInsert += "JOIN "+ RetSQLName("SA1") +" SA1 " + _cFim
	_cInsert += "ON A1_FILIAL = '"+XFILIAL("SA1")+"' AND A1_COD = ZGQ_CLIENT AND A1_LOJA = ZGQ_LOJA AND SA1.D_E_L_E_T_ = ' ' "

    _cInsert += "WHERE ZGQ.D_E_L_E_T_ = ' ' AND ZGQ_STATUS = 'E' AND ZGQ_STPROC = ' ' " + _cFim
    _cInsert += "AND ZGQ.ZGQ_CODGRU IN ("+_cGrpValid+") " + _cFim	// Somente Grupos do usuario logado 

    _cInsert += "ORDER BY ZGQ_ID "

	//Executo o comando para alimentar a tabela temporária
	memowrite("c:\totvs\RVBJ_MGFFINBS2.TXT", _cInsert  )// remover
	_cInsert := strTran(_cInsert, _cFim, '')

	Processa({|| _nCodRetTop := TcSQLExec(_cInsert)})
If _nCodRetTop < 0
	MsgStop(TcSQLError())
	Help(" ",1,"ERRO SINTAXE",,TcSQLError(),1,0)
Else
	For _nx := 1 To Len(_aStruLib)
		if !(_aStruLib[_nx][1] $ CAMPOEXCL)
			aadd(_aColumns,FWBrwColumn():New())
			_aColumns[Len(_aColumns)]:SetData( &("{||"+_aStruLib[_nx][1]+"}") )
		    If	_aStruLib[_nx][1]	== "SALDOTIT"
    			_aColumns[Len(_aColumns)]:SetTitle("Saldo Tit")
			    _aColumns[Len(_aColumns)]:SetPicture(PesqPict("SE1","E1_VALOR"))
            Else
			    _aColumns[Len(_aColumns)]:SetTitle(RetTitle(_aStruLib[_nx][1]))
			    If	_aStruLib[_nx][1]	== "NOME_GRUPO"
	    			_aColumns[Len(_aColumns)]:SetTitle("Nome Grupo")
	    			_aColumns[Len(_aColumns)]:SetPicture("@!")
				Else
	    			_aColumns[Len(_aColumns)]:SetPicture(PesqPict("ZGQ",_aStruLib[_nx][1]))
				Endif
		    Endif
   			_aColumns[Len(_aColumns)]:SetSize(_aStruLib[_nx][3])
		    _aColumns[Len(_aColumns)]:SetDecimal(_aStruLib[_nx][4])
		EndIf
	Next _nx

	_cAliasTmp := oTmp:GetAlias()
	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetAlias( _cAliasTmp )
	oBrowse:SetDescription( 'Análise de Títulos - Prorrogação & Desconto ' )
	oBrowse:SetTemporary(.T.)
	oBrowse:SetLocate()
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:SetFilterDefault( "" )
	oBrowse:DisableDetails()
	If _cZGRTIPO	==	"A"
		oBrowse:AddButton("Aprova", {|| MsgRun('Atualizando Status Aprovado','Processando',{|| MGFFINBS3("Aprova") }) },,,, .F., 2 )
		oBrowse:AddButton("Rejeita", {|| MsgRun('Atualizando Status Rejeitado','Processando',{|| MGFFINBS3("Rejeita") }) },,,, .F., 2 )
		oBrowse:AddButton("CONFIRMA", {|| MsgRun('Executando Analise','Processando',{|| MGFFINBS4() }) },,,, .F., 2 )
	Else
		oBrowse:AddButton("Ciência", {|| MsgRun('Executando Ciência','Processando',{|| MGFFINBS3("Ciência") }) },,,, .F., 2 )
		oBrowse:AddButton("CONFIRMA", {|| MsgRun('Executando Analise','Processando',{|| MGFFINBS5() }) },,,, .F., 2 )
	Endif

	// Definição da legenda
	If _cZGRTIPO	==	"A"
		oBrowse:AddLegend( "ZGQ_STATUS<>'E'", "BR_VERDE"	, "Análise Efetuada" )
		oBrowse:AddLegend( "ZGQ_STATUS=='E'", "BR_VERMELHO"	, "Análise Pendente" )
	Else
		oBrowse:AddLegend( "ZGQ_OK=='S'"    , "BR_VERDE"	, "Ciência Efetuada" )
		oBrowse:AddLegend( "ZGQ_OK==' '"    , "BR_VERMELHO"	, "Ciência Pendente" )
	Endif
	oBrowse:SetColumns(_aColumns)
	oBrowse:Activate()
Endif
	oTmp:Delete()
Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFINBS3()
Atualiza Status no ambiente de trabalho
@author Renato Junior

@since 15/07/2020
@return Nil
/*/
//-------------------------------------------------------------------
Static function MGFFINBS3(cNomTipo)
Local cAlias	:= oBrowse:Alias()
Local _cMsgReje	:=	SPACE(60)
Local _cE1NATUR	:=	""
Local _cMOTSOL  :=  ""

If (cAlias)->(Eof())
	MSGALERT("SEM DADOS A ANALISAR !")
	Return
Endif

If	cNomTipo	== "Ciência"
	RECLOCK(cAlias,.F.)
	// Marca/Desmarca
	(cAlias)->ZGQ_OK	:=	Iif((cAlias)->ZGQ_OK==" ","S", " ")
	(cAlias)->(MSUNLOCK())
Else
	_cMOTSOL  :=  (cAlias)->ZGQ_MOTSOL
	_cE1NATUR :=  (cAlias)->E1_NATUREZ
	If	cNomTipo	== "Rejeita"
		While .T.
			GetRejeita(@_cMsgReje)
			If ! Empty(_cMsgReje)
				Exit
			Else
				MsgInfo("Motivo da Rejeição é obrigatório!")
			Endif
		Enddo
	ElseIf	cNomTipo	== "Aprova"	.AND. (cAlias)->ZGQ_DESCON > 0
		While .T.
			GetNatureza(@_cE1NATUR, @_cMOTSOL)
			If ! Empty(_cE1NATUR)
				Exit
			Else
				MsgInfo("Natureza é obrigatório!")
			Endif
		Enddo
	Endif
	RECLOCK(cAlias,.F.)
	(cAlias)->ZGQ_STATUS	:=	cNomTipo	
	(cAlias)->ZGQ_STPROC	:=	_cMsgReje
	(cAlias)->ZGQ_MOTSOL	:=	_cMOTSOL
	(cAlias)->E1_NATUREZ	:=	_cE1NATUR
	(cAlias)->(MSUNLOCK())
EndIf
oBrowse:refresh(.F.)

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFINBS4()
Atualiza Status na ZGQ e envia para Startjob
@author Renato Junior

@since 15/07/2020
@return Nil
/*/
//-------------------------------------------------------------------
static function MGFFINBS4()	//_ZGRTIPO)
Local cAlias		:= oBrowse:Alias()
Local aParametros	:= {}
Local cNomUsu	:= Padr(UsrFullName(RetCodUsr()),TamSx3("ZGQ_USUARI")[1])
Local cDtHora	:= cValtoChar(GravaData(dDataBase, .T., 5 )) + " " + LEFT(TIME(),5)

If (cAlias)->(Eof())
	MSGALERT("SEM DADOS A ENVIAR !")
	Return
Endif

Begin Transaction

(cAlias)->(DbGoTop())
While (cAlias)->(!Eof())
	If (cAlias)->ZGQ_STATUS <> "E"
		If ZGQ->(DBSETORDER(1), DBSEEK( (cAlias)->(ZGQ_FILIAL+ZGQ_ID)))
			ZGQ->(RECLOCK("ZGQ",.F.))
			ZGQ->ZGQ_STATUS	:=	(cAlias)->ZGQ_STATUS
			ZGQ->ZGQ_STPROC	:=	(cAlias)->ZGQ_STPROC
			ZGQ->ZGQ_MOTSOL	:=	(cAlias)->ZGQ_MOTSOL
			ZGQ->ZGQ_NATURE	:=	(cAlias)->E1_NATUREZ
			ZGQ->ZGQ_USRAPR	:=	cNomUsu
			ZGQ->ZGQ_DTHAPR	:=	cDtHora
			If ZGQ->ZGQ_STATUS	== "A"	// Aprovado
				If ZGQ->ZGQ_RECSE1	==	0			// Se for inclusao de desconto sem os dados, neste momento preenche
					ZGQ->ZGQ_PREFIX	:=	"MAN"
					ZGQ->ZGQ_NUM	:=	GETSXENUM("SE1","E1_NUM")
					ZGQ->ZGQ_PARCEL	:=	"01"
					ZGQ->ZGQ_TIPO	:=	"NCC"
					CONFIRMSX8()
				Endif
				//
		    	AADD( aParametros ,{cEmpAnt,ZGQ->ZGQ_FILTIT,ZGQ->ZGQ_PREFIX, ZGQ->ZGQ_NUM, ZGQ->ZGQ_PARCEL, ZGQ->ZGQ_TIPO, ;
				ZGQ->ZGQ_CLIENT, ZGQ->ZGQ_LOJA , ZGQ->ZGQ_NOVENC, ZGQ->ZGQ_DESCON, ZGQ->ZGQ_ID, ZGQ->ZGQ_RECSE1, ZGQ->ZGQ_NATURE, ZGQ->ZGQ_MOTSOL})
				//
			Endif
			ZGQ->(MSUNLOCK())
			(cAlias)->(Dbdelete())
		Endif
	Endif
	(cAlias)->(DbSkip())
EndDo
(cAlias)->(DbGoTop())

End Transaction

oBrowse:refresh(.F.)
//
//u_GerTitSel(aParametros)
If LEN(aParametros)	> 0
	Processa( {|| StartJob("u_GerTitSel",GetEnvServer(),.T.,aParametros) },'Aguarde...' , 'Efetivando Solicitações no SIGAFIN',.F. )
Endif

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFINBS5()
Confirma a Ciencia - atualiza o Nivel e envia e-mail
@author Renato Junior

@since 27/07/2020
@return Nil
/*/
//-------------------------------------------------------------------
static function MGFFINBS5()
Local cAlias		:= oBrowse:Alias()
Local _aNivel	:=	{}
Local cNomUsu	:= Padr(UsrFullName(RetCodUsr()),TamSx3("ZGQ_USUARI")[1])
Local cDtHora	:= cValtoChar(GravaData(dDataBase, .T., 5 )) + " " + LEFT(TIME(),5)

If (cAlias)->(Eof())
	MSGALERT("SEM DADOS A ENVIAR !")
	Return
Endif

Begin Transaction
(cAlias)->(DbGoTop())
While (cAlias)->(!Eof())
	If (cAlias)->ZGQ_OK == "S"
		If ZGQ->(DBSETORDER(1), DBSEEK( (cAlias)->(ZGQ_FILIAL+ZGQ_ID)))
			ZGQ->(RECLOCK("ZGQ",.F.))
		    ZGQ->ZGQ_NIVEL   :=  SOMA1(ZGQ->ZGQ_NIVEL)
			ZGQ->ZGQ_USRCIE	:=	cNomUsu
			ZGQ->ZGQ_DTHCIE	:=	cDtHora
	   		ZGQ->( MSUNLOCK())
			If ASCAN(_aNivel, ZGQ->(ZGQ_NIVEL+ZGQ_CODGRU) )	== 0
				AADD(_aNivel, ZGQ->(ZGQ_NIVEL+ZGQ_CODGRU))
			Endif
			//
			(cAlias)->(Dbdelete())
		Endif
	Endif
	(cAlias)->(DbSkip())
EndDo
(cAlias)->(DbGoTop())
End Transaction

oBrowse:refresh(.F.)
// Envia e-mail para usarios do nivel 
Processa({|| U_FINBREmail(_aNivel) },'Aguarde...' , 'Enviando E-mail para Analise Financeira... ',.T.)

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} GetRejeita()
Solicita Mensagem de Rejeição
@author Renato Junior

@since 15/07/2020
@return Nil
/*/
//-------------------------------------------------------------------
Static Function GetRejeita(cMsgVolta)
Local cMsg, lOk := .F.
Local _cMsg := SPACE(60)

cMsg := "Deseja Rejeitar este Título ? Digite o Motivo :"

Define MSDialog oDlg Title "Motivo" From 0, 0 To 130, 420 Of oMainWnd Pixel
@ 016,004 To 166,270 Label Pixel Of oDlg
@ 036,075 Say cMsg Size 136,200 Pixel Of oDlg
@ 050,072 MsGet _cMsg  Size 133,000 Valid (NaoVazio(_cMsg)) Pixel Of oDlg
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(ODlg,{||lRet := .T. , cMsgVolta := ALLTRIM(_cMsg),  ODlg:End()},{||lRet := .F.  ,ODlg:End(),},,)

If ! lOk
    _cMsg := ""
EndIf
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GetNatureza()
Solicita Mensagem de Rejeição
@author Renato Junior

@since 15/07/2020
@return Nil
/*/
//-------------------------------------------------------------------
Static Function GetNatureza(cNatureza, cMotSol)
Local cMsg, lOk := .F.

Define MSDialog oDlg Title "Natureza" From 0, 0 To 300, 720 Of oMainWnd Pixel
@ 016,004 To 166,570 Label Pixel Of oDlg
@ 036,075 Say "Informar a Natureza deste Título :" Size 136,200 Pixel Of oDlg
@ 050,072 MsGet cNatureza  Size 060,000 F3 "SED" Valid (NaoVazio(cNatureza) .And. ExistCpo("SED",cNatureza)) Pixel Of oDlg
@ 070,075 Say "Motivo da Solicitação :" Size 136,200 Pixel Of oDlg
@ 084,072 MsGet cMotSol    Size 275,000 Pixel Of oDlg
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(ODlg,{||lRet := .T., ODlg:End()},{||lRet := .F.  ,ODlg:End(),},,)

Return

/*/{Protheus.doc} FINBREmail
Função para Enviar e-mail para aprovadores

@author Renato Bandeira
@since 27/07/2020

@param - Xanivel - array com os niveis + grupos
/*/
User Function FINBREmail(XaNivel)
Local _cGrupos	:=	""
local cEmailDE	:=	ALLTRIM(UsrRetMail(RetCodUsr()))
Local cEmailPA	:=	""
Local _lAchou	:=	.F.
Local cQuery		:= ''
Local cNextAlias	:= GetNextAlias()
Local _nCr1			:=	0

For	_nCr1	:=	1	TO LEN(XaNivel)	//	Ajusta sequencia de nivel+grupos
	_cGrupos	+=	XaNivel[_nCr1]+","
Next
If RIGHT(_cGrupos,1)==","
	_cGrupos	:=	LEFT(_cGrupos, LEN(_cGrupos)-1)
Endif

cQuery  += " SELECT ZGR_USRCOD FROM "+RetSqlName("ZGR")+" ZGR "
cQuery  += " WHERE ZGR.D_E_L_E_T_ = ' ' "
cQuery  += " AND ZGR_NIVEL||ZGR_CODIGO IN ('"+_cGrupos+"') "
cQuery  += " AND ZGR_GATIVO = 'S' AND ZGR_ATIVO= 'S' "	// Grupo e Linha Ativos
cQuery  += " AND ZGR_ROTINA LIKE '%1%' "	// Apenas verifica para grupos da Rotina 1 
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
	EnvMail({cEmailDE, cEmailPA, ""})
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
	Local cSubject	:=	""

	Local cErrMail

	cCtMail	:=	LEFT(cEmail, AT("@",cEmail)-1)

	cSubject	:=	"Títulos para Analise Financeira – Marfrig"

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
	Local nI:=	0

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

	cHtml += "<p><span style='color:red'>Você tem Título(s) para Analisar<o:p></o:p></span></p>"

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
