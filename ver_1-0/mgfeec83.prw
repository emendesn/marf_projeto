#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'STD.CH'

#define CRLF chr(13) + chr(10)

#DEFINE CAMPOEXCL	'EEQ_OK'

/*/
=============================================================================
Descrição   : Tela para Importação de arquivos para Adto, Baixa ou Liquidação

@description
Seleciona arquivos de acordo com criterio especifico :
1) Importação de arquivo extrato bancário, contendo adiantamentos de exportação
e baixas de cambio.
2) Importação de arquivo contendo liquidações de cambio.

@author     : Renato Junior
@since      : 24/06/2020
@type       : User Function

@table
ZGH -   LOG DE ARQUIVOS IMPORTADOS

@param
@return
@menu
Financeiro - Atualizações-Especificos MARFRIG

@history  - 07/12/20 - Tratamento do Numero do ID por select
/*/
User Function MGFEEC83()
	Private lMsErroAuto := .F.
	Private oBrowse3
	Private cRetDir		:= ""

	dbselectarea("ZGH")
	If ZGH->(LASTREC()) == 0
		RECLOCK("ZGH",.T.)
		ZGH->(MSUNLOCK())
	Endif

	oBrowse3 := FWMBrowse():New()
	oBrowse3:SetAlias('ZGH')
	oBrowse3:SetDescription('Financeiro Exportação - Processamento por Arquivo')

	oBrowse3:AddLegend( "ZGH_TIPO == '1' "  , "YELLOW"   , "Adto/Baixa" )
	oBrowse3:AddLegend( "ZGH_TIPO == '2' "  , "GREEN"    , "Liquidação" )

	oBrowse3:Activate()

return NIL

//
Static function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Adto/Baixa' 		ACTION 'U_XPROCARQ("1")' 	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Liquidar' 		ACTION 'U_XPROCARQ("2")' 	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Estornar' 		ACTION 'U_EEC83A()' 		OPERATION 4 ACCESS 0

Return aRotina
//

Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZGH := FWFormStruct( 1, 'ZGH')
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('XMGFEEC83', , , , )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZGHMASTER', , oStruZGH, , ,  )

	//Adiciona chave Primária
	oModel:SetPrimaryKey({"ZGH_FILIAL","ZGH_ID"})

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Processamento por Arquivo' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZGHMASTER' ):SetDescription( 'Proc Arq CSV' )

Return oModel

//
Static Function ViewDef()

	// Cria a estrutura a ser usada na View
	Local oStruZGH := FWFormStruct( 2, 'ZGH') //,{ |x| ALLTRIM(x) $ 'ZP_CODREG, ZP_DESCREG, ZP_ATIVO' })

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFEEC83' )
	Local oView

	oStruZGH:RemoveField( "ZGH_ID" )

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZGH', oStruZGH, 'ZGHMASTER' )

Return oView

/*/
==============================================================================================================================================================================
{Protheus.doc} XPROCARQ()
Le arquivo CSV : verifica inconsistencias, exsecuta msexecauto , registra log de processamento

@author Renato Junior
@since 30/06/2020
@type Function

@param _cQualProc - tipo do processamento = 1 Adto/Baixa ; 2 Liquidacao
/*/
User Function XPROCARQ(_cQualProc)
	//	Local _lContin1	:=	.F.

	Private cPerg		:=  "MGFEEC83_"+_cQualProc
	Private _cArqNome	:=	""
	Private _cDirCsv	:=	""
	Private _cZGHID		:=	GETSXENUM('ZGH','ZGH_ID')

	ValidPerg()
	If Pergunte(cPerg,.T.)
		_cArqNome	:=	ALLTRIM(UPPER(MV_PAR01))
		If VerJaProc(_cQualProc)
			FwMsgRun(, {|| xPcArqCsv(_cQualProc) }, "Processando "+_cArqNome, "Aguarde, lendo o arquivo CSV... " )
		Endif
	EndIf
Return

/*/
==============================================================================================================================================================================
{Protheus.doc} VerJaProc()
Verifica na tabela de Log de processamento (ZGH	) se ja foi processado

@author Renato Junior
@since 25/06/2020
@type Function

@param 	_cQualProc   - 1=Adto/Baixa ; 2-Liquidacao
@return .T. SE ja processado anteriormente
/*/
Static Function VerJaProc(_cQualProc)
	Local _nPosCara		:=	0
	Local _cNmCurto		:=	""
	Local cQuery		:= ''
	Local _lRet			:= .T.
	Local cNextAlias	:= GetNextAlias()
	Local cMsgVend		:=	""

	_cNmCurto	:=	RetNmCurto(_cArqNome)
	_cDirCsv	:=	STRTRAN(_cArqNome,_cNmCurto,"")

	cQuery  := ''	// Verifica se já existe na tabela
	cQuery  += " SELECT ZGH_ID FROM "+RetSqlName("ZGH")+" ZGH WHERE ZGH.D_E_L_E_T_ = ' ' "
	cQuery  += " AND ZGH_TIPO = '"+_cQualProc+"' "
	cQuery  += " AND ZGH_ARQUIV LIKE '%"+_cNmCurto+"%'"

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
	dbSelectArea(cNextAlias)
	(cNextAlias)->(dbGoTop())

	If ! (cNextAlias)->(Eof())
		While ! (cNextAlias)->(Eof())
			cMsgVend	+=	CRLF + "ID : "+(cNextAlias)->ZGH_ID
			(cNextAlias)->(Dbskip())
		Enddo
		If ! MsgYesNo("O arquivo informado já foi processado anteriormente :"+cMsgVend,"Deseja reprocessar?")
			_lRet			:= .F.
		Endif
	Endif
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
Return _lRet

/*/
==============================================================================================================================================================================
{Protheus.doc} xPcArqCsv()
Efetua a leitura do arquivo CSV, efetuando as validações de acordo com o layout

@author Renato Junior
@since 25/06/2020
@type Function

@param 	_cQualProc   - 1=Adto/Baixa ; 2-Liquidacao
@return
/*/
Static Function xPcArqCsv(_cQualProc)
	Local lContinua	:=	.T.
	Local _nCti		:=	_nCtj	:=	nColunas:=	_nVlContr	:=	0
	Local cLinha	:=	""
	Local aDados	:=	{}
	Local _aChkCpo	:=  {}
	Local _aHeader	:=	{}
	Local _acols	:=	{}
	Local _aProcAdto:=  {}
	Local _aProcBxLq :=	{}
	Local _cNomProc	:=	Iif(_cQualProc=="1","Adto/Baixa","Liquidação")
	Local _cBkFilAnt	:=	cFilAnt

	Private _aParcsEEQ	:=	{}
/*/
	aAdd(_aChkCpo , {"TIPOREG","EEQ_FILIAL","PROCESSO","EEQ_NRINVO","EEQ_PARC","EEQ_DTCE","EEQ_ZORDNT","EEQ_ZREFBC","EEQ_ZDESP", ;
		"EEQ_VL","EEQ_DESCON","EEQ_ACRESC","EEQ_MOTIVO","EEQ_ZOBS","EEQ_ZBANCO","EEQ_ZAGENC","EEQ_ZCONTA","EEQ_DECRES", ;
		"EEQ_PGT","EEQ_RFBC","EEQ_NROP","EEQ_BANC","EEQ_AGEN","EEQ_NCON" })		// ADTO/BAIXA
/*/
	aAdd(_aChkCpo , {"TIPOREG","EEQ_FILIAL","PROCESSO","EEQ_PARC","EEQ_DTCE","EEQ_ZORDNT","EEQ_ZREFBC","EEQ_ZDESP", ;
		"EEQ_VL","EEQ_DESCON","EEQ_ACRESC","EEQ_MOTIVO","EEQ_ZOBS","EEQ_ZBANCO","EEQ_ZAGENC","EEQ_ZCONTA","EEQ_DECRES", ;
		"EEQ_PGT","EEQ_RFBC","EEQ_NROP","EEQ_BANC","EEQ_AGEN","EEQ_NCON" })		// ADTO/BAIXA

	aAdd( _aChkCpo , {"EEQ_FILIAL","PROCESSO","EEQ_PARC","EEQ_EVENT","EEQ_VL","EEQ_PGT", ;
		"CONTRATO","EEQ_TX","EEQ_BANC","EEQ_AGEN","EEQ_NCON","EEQ_MOTIVO","DESDOBRA"}  )	// LIQUIDACAO

	nColunas	:=	LEN(_aChkCpo[VAL(_cQualProc)])

	If !File(_cArqNome)
		MsgStop("O arquivo " +_cArqNome + " não foi selecionado. A importação será abortada!","ATENCAO")
		Return( .F.)
	EndIf

	_cLnErStru	:=	""
	FT_FUSE(_cArqNome)
	FT_FGOTOP()
	FT_FREADLN()	// Ignora 1a. Linha - Nome das colunas
	FT_FSKIP()

	While !FT_FEOF()
		cLinha := FT_FREADLN()
		aAdd(aDados,Separa(cLinha,";",.T.))
		If Len(aDados[Len(aDados)]) <> nColunas
			_cLnErStru	+=  ALLTRIM(STR(Len(aDados)+1))+"/"
			lContinua := .F.
		ElseIf _cQualProc	== "2"	 	// Na liquidação, Soma valores do contrato
			_nVlContr	+=	ROUND(VlSemPont(aDados[Len(aDados)][ASCAN(_aChkCpo[VAL(_cQualProc)],"EEQ_VL")]),2)
		Endif
		FT_FSKIP()
	EndDo
	FT_FUSE()

	If !lContinua
		APMsgStop(	"Estrutura do arquivo CSV inválido. Linha(s): "+_cLnErStru)
		Return(.F.)
	Endif

	If _cQualProc	== "2"	.AND. _nVlContr	<> MV_PAR02
		MsgStop("A somatória dos valores a liquidar ($"+AllTrim(Transf(_nVlContr,"@E 999,999,999.99"))+") não confere com o informando no Valor de Contrato.","Por favor, verificar.")
		Return(.F.)
	Endif

	_acols		:= {}
	_aProcAdto	:= {}
	_aProcBxLq	:= {}
	While LEN(aDados) > 0 // Faz a leitura e elimina linha do array, reduzindo pilha
		// Verifica inconsistencias na linha
		ChkErrCpo( _aChkCpo[VAL(_cQualProc)], _cQualProc, aDados[1], @_acols, ;
			@_aProcAdto, @_aProcBxLq )
		ADEL(aDados, 1)
		aSize(aDados,Len(aDados)-1)
	Enddo
	cFilAnt	:=	_cBkFilAnt

	If Len(_acols)	> 0	// Tem inconsistencias
		// Colunas do Log
		If _cQualProc	== "1"
			_aheader := {"Tipo Registro","Filial","Processo","Inconsistência"}
		Else
			_aheader := {"Filial","Processo","Evento","Inconsistência"}
		Endif

		U_MGListBox( "Log de Leitura do Arquivo ("+_cNomProc+")" , _aheader , _acols , .T. , 1 )
	Endif

	If LEN(_aProcAdto)+LEN(_aProcBxLq) > 0
		lContinua := .T.
	Else
		lContinua := .F.
	EndIf
	// Se tem algo correto e tambem com erro, verifica se vai continuar. Se tudo com erro encerra
	If lContinua .AND. Len(_acols)	> 0
		lContinua := MsgYesNo("Existe(m) Erro(s) no arquivo CSV", "Deseja continuar ?")
	Endif

	If (lContinua)
		// Grava o Log de processamento se nao houver erros de estrutura
		Dbselectarea("ZGH")
		RECLOCK("ZGH",.T.)
		ZGH->ZGH_FILIAL		:=	XFILIAL("ZGH")
		ZGH->ZGH_ID			:=	_cZGHID
		ZGH->ZGH_ARQUIV		:=	_cArqNome
		ZGH->ZGH_TIPO		:=	_cQualProc
		ZGH->ZGH_DTHORA		:=	cValtoChar(GravaData(dDataBase, .T., 5 )) + " " + LEFT(TIME(),5)
		ZGH->ZGH_USUARIO	:=	UsrFullName(RetCodUsr())
		ZGH->(MSUNLOCK())
		confirmSX8()
		//
		_acols:=	{}
		ExecRotAuto( _cQualProc, @_acols, @_aProcAdto, @_aProcBxLq )
		If Len(_acols)	> 0	// Se Tem inconsistencias alimenta Colunas do Log
			If _cQualProc	== "1"
				_aheader := {"Tipo Registro","Filial","Processo","Retorno"}
			Else
				_aheader := {"Filial","Processo","Evento","Retorno"}
			Endif
			U_MGListBox( "Log de Processamento ("+_cNomProc+")" , _aheader , _acols , .T. , 1 )
		Endif
	Else
		RollbackSX8()
	Endif
Return( lContinua)

/*/
==============================================================================================================================================================================
{Protheus.doc} ChkErrCpo()
Verifica os erros na linha do arquivo

@author Renato Junior @since 25/06/2020  @type Function

@param
_XaChkCpo - Array com os nomes das colunas usados como referencia  nas posicoes do array
_XcTipo - Tipo do arquivo : 1 Adto/Baixa ; 2 - Liquidacao
_XlinLida - array com a linha lida do CSV
_aAchouErr - Array enviado como referencia (acols), que conterá os erros encontrados
_aProcAdto - Array enviado como referencia , que conterá os dados para o ExecAuto
_aProcBxLq - Array enviado como referencia , que conterá os dados para o ExecAuto
/*/
Static Function ChkErrCpo(_XaChkCpo,_XcTipo,_XlinLida, _aAchouErr, _aProcAdto, _aProcBxLq)
	Local nCtt			:=	0
	Local _XVarTrab		:=	""
	local _cMsgErr		:=	""
	Local _nEEQVL		:=	0
	Local _dEEQDTCE		:=	CTOD("  /  /  ")
	Local _cKeySA6		:=	""
	Local _lAchaBco		:=	.T.
	Local _aTrabalho	:=	{}
	Local _lDesDobra	:=	.F.
	Local _cEEQZREFBC	:=	""
	Local _cCliLoja		:=	""
	Local _cEEQNOMBC	:=	""
	Local _cEEQZID000	:=	""
	Local _cEEQBANC		:=	""
	Local _cEEQAGEN		:=	""
	Local _cEEQNCON		:=	""
	Local _cEEQRFBC		:=	""
	Local _lNewParc		:=	.F.

	Private _cEEQ_FIL	:= 	_cEEQPREEMB	:=	_cEEQEVENT := ""
	Private _cTIPOREG	:=	"Liquida"	// Este conteudo somente para  referencia

	// TIPO DE REGISTRO
	If 	_XcTipo == "1" .AND. (nCtt := ASCAN(_XaChkCpo,"TIPOREG"))>0
		_cTIPOREG	:=	ALLTRIM(_XlinLida[nCtt])
		If ! _cTIPOREG $ "Adto|Baixa"
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Tipo de Registro não é válido")
			Return
		Endif
	Endif
	// FILIAL - Todos os tipos
	If (nCtt := ASCAN(_XaChkCpo,"EEQ_FILIAL"))>0
		_cEEQ_FIL	:=	ALLTRIM(_XlinLida[nCtt])
		If EMPTY(_cEEQ_FIL) .OR. ! IsDigit(_cEEQ_FIL) .OR. ! SM0->(dbSeek(cEmpAnt+ (_cEEQ_FIL:=STRZERO(VAL(_cEEQ_FIL),TamSx3("EEQ_FILIAL")[1]))))
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Filial informada não é válida")
			Return
		Endif
	Endif
	cFilAnt	:=	_cEEQ_FIL
	// PROCESSO - Todos os tipos
	If (nCtt := ASCAN(_XaChkCpo,"PROCESSO"))>0
		_cEEQPREEMB	:= ALLTRIM(SUBS(_XlinLida[nCtt],01,20))
		_cEEQPREEMB	:= Padr(_cEEQPREEMB,TamSx3("EEQ_PREEMB")[1] )

		If EMPTY(_cEEQPREEMB)
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Número de Processo não informado")
		Else
			If _cTIPOREG $ "Liquida|Baixa" .AND. ! EEC->( DbSetOrder(1) , DbSeek( XFILIAL("EEC") + _cEEQPREEMB ))	// 1	EEC_FILIAL+EEC_PREEMB
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Processo não localizado no Protheus (EEC)")
				Return
			ElseIf EEC->EEC_STTDES	== "Processo/Embarque Cancelado"
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Processo cancelado no Protheus (EEC)")
				Return
			Else
				If _cTIPOREG == "Liquida"
					_cEEQNRINVO	:= EEC->EEC_NRINVO
				Endif
				_cCliLoja	:=	EEC->(EEC_IMPORT+EEC_IMLOJA)
			Endif
			If _cTIPOREG $ "Adto" .AND. ! EE7->( DbSetOrder(1) , DbSeek( XFILIAL("EE7") + _cEEQPREEMB ))	// 1	EE7_FILIAL+EE7_PEDIDO
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Processo não localizado no Protheus (EE7)")
				Return
			ElseIf EE7->EE7_STTDES	== "Processo/Embarque Cancelado"
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Processo cancelado no Protheus (EE7)")
				Return
			Else
				_cCliLoja	:=	EE7->(EE7_IMPORT+EE7_IMLOJA)
			Endif
		Endif
	Endif
	// Verifica se Moeda de Negociação está cadastrada
	If ! EXJ->( DbSetOrder(1) ,  DBSEEK(XFILIAL("EXJ") + _cCliLoja)) .OR. EMPTY(EXJ->EXJ_MOEDA)
		// Informação deverá ser alimentada automaticamente pois só é necessário este relacionamento na EXJ, quando Adiantamento Cliente
		IF ! EXJ->( FOUND())
			RECLOCK("EXJ", .T. )
			EXJ->EXJ_FILIAL	:=	XFILIAL("EXJ")
			EXJ->EXJ_COD	:=	LEFT( _cCliLoja, 06)
			EXJ->EXJ_LOJA	:=	RIGHT( _cCliLoja, 02)
		ELSE
			RECLOCK("EXJ", .F. )
		ENDIF
		EXJ->EXJ_MOEDA	:=	"US$"
		EXJ->( MSUNLOCK())
	Endif
	// EEQ_PARC - Baixa/Liquida
	If _cTIPOREG $ "Liquida|Baixa" .AND. (nCtt := ASCAN(_XaChkCpo,"EEQ_PARC"))>0
		_cEEQPARC	:=	ALLTRIM(_XlinLida[nCtt])
		If _cEEQPARC	==	"??"	.AND. _cTIPOREG == "Baixa"
			_lNewParc	:=	.T.
			nPosItCtb := aScan(_aParcsEEQ, {|x| Alltrim(x[1]) == Alltrim(cFilAnt+_cEEQPREEMB) })
			If 	nPosItCtb	> 0
				_cEEQPARC	:=  _aParcsEEQ[nPosItCtb][2]
				_aParcsEEQ[nPosItCtb][2]	:=	SOMA1(_cEEQPARC,2)
			Else
				// Invalida operação pois ?? tem que estar apos a EXP da primeira Baixa
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Parcela ?? sem parcela da Baixa")
				Return
			Endif
		ElseIf EMPTY(_cEEQPARC) .OR. ( !EMPTY(_cEEQPARC) .AND. ! IsDigit(_cEEQPARC) )
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Parcela informada não é válida")
			Return
		Else
			_cEEQPARC	:=	STRZERO(VAL(_cEEQPARC),TamSx3("EEQ_PARC")[1])
		Endif
	Else
		_cEEQPARC	:=	""
	Endif
	// EEQ_NRINVO
	/*/
	If _cTIPOREG $ "Adto|Baixa" .AND. (nCtt := ASCAN(_XaChkCpo,"EEQ_NRINVO"))>0	.AND. EMPTY(_cEEQNRINVO:=ALLTRIM(_XlinLida[nCtt]))
		Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Nro Invoice não está preenchido")
	Endif
	/*/
	// EVENTO
	If	_cTIPOREG	==	"Adto"
		_cEEQEVENT	:=	"602"
	Else
		If (nCtt := ASCAN(_XaChkCpo,"EEQ_EVENT"))>0	// Liquida
			_cEEQEVENT	:= _XlinLida[nCtt]
		Else	// Baixa
			_cEEQEVENT	:=	"101"
		Endif
		If _cTIPOREG == "Liquida" .AND. ! _cEEQEVENT $"101|400"
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Evento informado não é válido")
			Return
		Else
			If	!	_lNewParc
				If EEQ->( DbSetOrder(1) ,  DBSEEK(XFILIAL("EEQ") + _cEEQPREEMB + _cEEQPARC))
					// Verifica se já foi processado
					If _cTIPOREG == "Liquida"	.AND. ! EMPTY(EEQ->EEQ_ZID002)
						Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="EXP já processada no ID : "+EEQ->EEQ_ZID002)
						Return
					Endif
					If _cTIPOREG == "Liquida" .AND. ! (! EMPTY(EEQ->EEQ_DTCE) .AND. EMPTY(EEQ->EEQ_PGT ))
						Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Evento com datas invalidas para Liquidação")
						Return
					ElseIf _cTIPOREG == "Baixa" .AND. ! EMPTY(EEQ->EEQ_DTCE)
						Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Evento com Dt.Cred.Ext invalida para Baixa")
						Return
					Endif
				Else
					Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Evento "+_cEEQEVENT+" não encontrado para "+ ;
						Iif(_cTIPOREG=="Liquida","Liquidação","Baixa"))
					Return
				Endif
			Endif
		Endif
	Endif
	// DESDOBRA - Liquida
	If _cTIPOREG == "Liquida"	.AND. (nCtt := ASCAN(_XaChkCpo,"DESDOBRA"))>0
		_cDESDOBRA	:=	UPPER(ALLTRIM(_XlinLida[nCtt]))
	Else
		_cDESDOBRA	:=	"S"
	Endif
	// EEQ_VL - Todos os tipos
	If (nCtt := ASCAN(_XaChkCpo,"EEQ_VL"))>0
		_XVarTrab	:=	ALLTRIM(_XlinLida[nCtt])
		If (! EMPTY(_XlinLida[nCtt]) .AND. ! IsDigit(_XVarTrab))
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Vl.da Parc. informado não é um valor válido")
		Else
			_nEEQVL		:=	VlSemPont(_XlinLida[nCtt])
			If ! _lNewParc	// Desconta o valor da baixa do ?? para identificar se ira desdobrar ou não
				AADD(_aParcsEEQ, {cFilAnt+_cEEQPREEMB,	SOMA1(EEC83E(cFilAnt,_cEEQPREEMB),2),	EEQ->EEQ_VL-_nEEQVL  })
				_TmpEEQ_VL	:=	EEQ->EEQ_VL
			Else
				// Atualiza valor pois estará posicionado no Array
				_TmpEEQ_VL					:=	_aParcsEEQ[nPosItCtb][3]
				_aParcsEEQ[nPosItCtb][3]	-=	_nEEQVL
			Endif
			If	_cTIPOREG	$	"Baixa|Liquida" .AND. EEQ->(FOUND())
				If _nEEQVL == 0
					Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Vl.da Parc. informado não é um valor válido")
				ElseIf _cTIPOREG	<>	"Adto"
					If	_nEEQVL > _TmpEEQ_VL
						Inc_aCols(_XcTipo, @_aAchouErr, _cMsgErr:="Valor "+Iif(_cTIPOREG=="Baixa","de Cambio a Receber","do Evento") + ;
							" ($ "+AllTrim(Transf(EEQ->EEQ_VL,"@E 999,999,999.99"))+") é menor que o informado no arquivo")
					ElseIf	_nEEQVL < _TmpEEQ_VL
						If 	_cDESDOBRA	==	"S"
							_lDesDobra	:=	.T.	// Altera antes - Desdobra via Msexecauto
						Else
							Inc_aCols(_XcTipo, @_aAchouErr, _cMsgErr:="Valor "+Iif(_cTIPOREG=="Baixa","de Cambio a Receber","do Evento") + ;
								" ($ "+AllTrim(Transf(EEQ->EEQ_VL,"@E 999,999,999.99"))+") é maior que o informado no arquivo")
							Return
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif
	// EEQ_DESCON
	If _cTIPOREG == "Baixa"	.AND. (nCtt := ASCAN(_XaChkCpo,"EEQ_DESCON"))>0
		If (! EMPTY(_XlinLida[nCtt]) .AND. ! IsDigit( ALLTRIM(_XlinLida[nCtt]))) .OR. (_nEEQDESCON:=VlSemPont(_XlinLida[nCtt])) < 0
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Vl.do Desconto informado não é um valor válido")
		Endif
	Endif
	// EEQ_DTCTE
	If (nCtt := ASCAN(_XaChkCpo,"EEQ_DTCE"))>0	.AND. _cTIPOREG $ "Adto|Baixa"
		_dEEQDTCE	:=	CTOD(_XlinLida[nCtt])
		If EMPTY(_dEEQDTCE)
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Dt.Cred.Ext. não está preenchida")
		ElseIf _dEEQDTCE > dDataBase
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Dt.Cred.Ext. está maior que a data atual")
		Endif
	Endif
	// EEQ_PGT - Todos os tipos
	If (nCtt := ASCAN(_XaChkCpo,"EEQ_PGT"))>0  .AND. _cTIPOREG $ "Adto|Liquida"
		_dEEQPGT :=	CTOD(_XlinLida[nCtt])
		If	! (_cTIPOREG == "Adto"	.AND. EMPTY(_dEEQPGT))
			//Else
			If EMPTY(_dEEQPGT)
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Dt.Liq.Cont. não está preenchida")
			ElseIf _dEEQPGT > dDataBase
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Dt.Liq.Cont. está maior que a data atual")
			ElseIf	_cTIPOREG	==	"Adto" .AND. _dEEQPGT < _dEEQDTCE
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Dt.Liq.Cont. está menor que Dt.Cred.Ext")
			Endif
		Endif
	Endif
	// EEQ_NROP
	If _cTIPOREG == "Adto"	.AND. (nCtt := ASCAN(_XaChkCpo,"EEQ_NROP"))>0
		_cEEQNROP:=	_XlinLida[nCtt]
		If EMPTY(_cEEQNROP)
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Número da operação não está preenchido")
		EndIf
	Endif
	// CONTRATO
	If _cTIPOREG == "Liquida" .AND. (nCtt := ASCAN(_XaChkCpo,"CONTRATO"))>0
		If EMPTY(_XlinLida[nCtt])
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Número de Contrato não informado")
		Else
			_cEEQNROP	:=	ALLTRIM(SUBS(_XlinLida[nCtt],01,20))
			_cEEQRFBC	:=	_cEEQNROP
			_cEEQZOBS	:=	_cEEQNROP
		Endif
	Endif
	If _cTIPOREG == "Liquida" .AND. (nCtt := ASCAN(_XaChkCpo,"EEQ_TX"))>0 .AND. ;
			(_nEEQTX := VlSemPont(_XlinLida[nCtt])) == 0
		Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Taxa Cambio informada no arquivo é inválida")
	Endif
	// BANCO, AGENCIA E CONTA
	If	_cTIPOREG	$	"Adto|Liquida"	// Adto e Liquidação
		// Banco Obrigatório somente para Liquida
		If (nCtt := ASCAN(_XaChkCpo,"EEQ_BANC"))>0	.AND. EMPTY(_cEEQBANC:=_XlinLida[nCtt])	.AND. _cTIPOREG == "Liquida"
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Banco não está preenchido")
			_lAchaBco	:=	.F.
		Else
			_cKeySA6	+= Padr(_XlinLida[nCtt],TamSx3("EEQ_BANC")[1] )
		Endif
		//
		If ! EMPTY(_cEEQBANC)
			If (nCtt := ASCAN(_XaChkCpo,"EEQ_AGEN"))>0	.AND. EMPTY(_cEEQAGEN:=_XlinLida[nCtt])
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Nro. Agencia não está preenchido")
				_lAchaBco	:=	.F.
			Else
				_cKeySA6	+= Padr(_XlinLida[nCtt],TamSx3("EEQ_AGEN")[1] )
			Endif
			If (nCtt := ASCAN(_XaChkCpo,"EEQ_NCON"))>0	.AND. EMPTY(_cEEQNCON:=_XlinLida[nCtt])
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Nro. Conta não está preenchido")
				_lAchaBco	:=	.F.
			Else
				_cKeySA6	+= Padr(_XlinLida[nCtt],TamSx3("EEQ_NCON")[1] )
			Endif
			If (_lAchaBco)	.AND. ! SA6->(DBSEEK(XFILIAL("SA6") + _cKeySA6 ))
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Banco/Agencia/Conta informados não são válidos")
			Else
				_cEEQNOMBC	:=	SA6->A6_NOME
			Endif
		Endif
	Endif
	// EEQ_RFBC
	If _cTIPOREG	==	"Adto"	.AND. (nCtt := ASCAN(_XaChkCpo,"EEQ_RFBC"))>0
		If ! EMPTY(_cEEQBANC)	.AND.	EMPTY(_cEEQRFBC:=_XlinLida[nCtt])
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Referência não está preenchida")
		EndIf
	Endif
	// EEQ_MOTIVO
	If	_cTIPOREG $ "Baixa|Liquida" .AND. (nCtt := ASCAN(_XaChkCpo,"EEQ_MOTIVO"))>0
		If ! (_cEEQMOTIVO:= PADR(_XlinLida[nCtt],3)) $"NOR|COL|DEV|CN |SUD|BXA"
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Motivo Baixa informado não é válido")
		Endif
	Endif
	// EEQ_ACRESC
	If _cTIPOREG $ "Baixa"	.AND. (nCtt := ASCAN(_XaChkCpo,"EEQ_ACRESC"))>0
		If (! EMPTY(_XlinLida[nCtt]) .AND. ! IsDigit( ALLTRIM(_XlinLida[nCtt]))) .OR. (_nEEQACRESC:=VlSemPont(_XlinLida[nCtt])) < 0
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Acrescimo informado não é um valor válido")
		EndIf
	Endif
	// EEQ_DECRES
	If _cTIPOREG $ "Baixa"	.AND. (nCtt := ASCAN(_XaChkCpo,"EEQ_DECRES"))>0
		If (! EMPTY(_XlinLida[nCtt]) .AND. ! IsDigit( ALLTRIM(_XlinLida[nCtt]))) .OR. (_nEEQDECRES:=VlSemPont(_XlinLida[nCtt])) < 0
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Decréscimo informado não é um valor válido")
		EndIf
	Endif
	If	_cTIPOREG $ "Adto|Baixa"
		// EEQ_ZREFBC
		If (nCtt := ASCAN(_XaChkCpo,"EEQ_ZREFBC"))>0 .AND. EMPTY(_cEEQZREFBC:=_XlinLida[nCtt])
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Ref. Banca não está preenchida")
		EndIf
		// EEQ_ZORDNT
		If (nCtt := ASCAN(_XaChkCpo,"EEQ_ZORDNT"))>0	.AND. EMPTY(_cEEQZORDNT:=_XlinLida[nCtt])
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Ordenante não está preenchido")
		EndIf
		// EEQ_ZDESP
		If (nCtt := ASCAN(_XaChkCpo,"EEQ_ZDESP"))>0
			If (! EMPTY(_XlinLida[nCtt]) .AND. ! IsDigit( ALLTRIM(_XlinLida[nCtt]))) .OR. (_nEEQZDESP:=VlSemPont(_XlinLida[nCtt])) < 0
				Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Classe Valor informado não é um valor válido")
			Endif
		EndIf
		// BANCO, AGENCIA E CONTA (GERENCIAL)
		_lAchaBco	:=	.T.
		_cKeySA6	:=	""
		If (nCtt := ASCAN(_XaChkCpo,"EEQ_ZBANCO"))>0	.AND. EMPTY(_cEEQZBANCO:=_XlinLida[nCtt])
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Banco Bx Ger não está preenchido")
			_lAchaBco	:=	.F.
		Else
			_cKeySA6	+= _XlinLida[nCtt]
		Endif
		If (nCtt := ASCAN(_XaChkCpo,"EEQ_ZAGENC"))>0	.AND. EMPTY(_cEEQZAGENC:=_XlinLida[nCtt])
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Agencia Bx G não está preenchido")
			_lAchaBco	:=	.F.
		Else
			_cKeySA6	+= _XlinLida[nCtt]
		Endif
		If (nCtt := ASCAN(_XaChkCpo,"EEQ_ZCONTA"))>0	.AND. EMPTY(_cEEQZCONTA:=_XlinLida[nCtt])
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Conta Bx Ger não está preenchido")
			_lAchaBco	:=	.F.
		Else
			_cKeySA6	+= _XlinLida[nCtt]
		Endif
		If (_lAchaBco)	.AND. ! SA6->(DBSEEK(XFILIAL("SA6") + _cKeySA6 ))
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Banco Bx Ger / Agencia Bx G / Conta Bx Ger informados não são válidos")
		Endif
		// 	EEQ_ZOBS
		If 	(nCtt := ASCAN(_XaChkCpo,"EEQ_ZOBS"))>0 .AND. EMPTY(_cEEQZOBS:=_XlinLida[nCtt])
			Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Obs.Bx.Geren não está preenchida")
		EndIf
	Endif

	If ! EMPTY(_cMsgErr)	// Se achar alguma mensagem, houve erro e nao continua para execauto
		Return
	Endif
	// Identifica qual será o campo de ID
	If _cTIPOREG == "Liquida"
		_cEEQZID000	:=	"EEQ_ZID002"
	Else
		_cEEQZID000	:=	"EEQ_ZID001"
	Endif
	// 1a.linha do Array _aTrabalho identifica filial e oq fazer
	If _lDesDobra	// Opc altera parcela para realizar um desdobramento da parcela principal
		If _cTIPOREG == "Liquida" 	.AND. _cEEQ_FIL <> "90001"
			_cEEQZREFBC	:=	"@" + EEQ->EEQ_ZREFBC
			aAdd(_aTrabalho, {_cEEQ_FIL, 5, "Alteração|Liquida" , _cEEQPREEMB, _cEEQEVENT})
		Else
			aAdd(_aTrabalho, {_cEEQ_FIL, 5, "Alteração" , _cEEQPREEMB, _cEEQEVENT})
		Endif
		aAdd( _aTrabalho , { "EEQ_PREEMB"	, _cEEQPREEMB	, Nil })
		aAdd( _aTrabalho , { "EEQ_EVENT"	, _cEEQEVENT	, Nil })
//		aAdd( _aTrabalho , { "EEQ_NRINVO"	, _cEEQNRINVO	, Nil })
		aAdd( _aTrabalho , { "EEQ_NRINVO"	, _cEEQPREEMB	, Nil })
		aAdd( _aTrabalho , { "EEQ_PARC"		, _cEEQPARC		, Nil })
		aAdd( _aTrabalho , { "EEQ_VL"		, _nEEQVL		, Nil })
		aAdd( _aTrabalho , { "EEQ_ZREFBC"	, _cEEQZREFBC	, Nil })
		aAdd( _aTrabalho , { _cEEQZID000	, _cZGHID		, Nil })
		//
		aAdd(_aProcBxLq, _aTrabalho)
		_aTrabalho	:=	{}
	Endif
	If _cTIPOREG == "Adto"
		aAdd(_aTrabalho, {_cEEQ_FIL, 3, _cTIPOREG, _cEEQPREEMB, "" })
	ElseIf _cTIPOREG == "Baixa"
		aAdd(_aTrabalho, {_cEEQ_FIL, 5, _cTIPOREG, _cEEQPREEMB, _cEEQEVENT })	// Opc Baixa
	ElseIf _cTIPOREG == "Liquida"
		aAdd(_aTrabalho, {_cEEQ_FIL, 99, _cTIPOREG, _cEEQPREEMB, _cEEQEVENT })	// Opc Liquidacao
	Endif
	aAdd( _aTrabalho , { "EEQ_PREEMB"	, _cEEQPREEMB	, Nil })
	aAdd( _aTrabalho , { "EEQ_EVENT"	, _cEEQEVENT	, Nil })
//	aAdd( _aTrabalho , { "EEQ_NRINVO"	, _cEEQNRINVO	, Nil })
	aAdd( _aTrabalho , { "EEQ_NRINVO"	, _cEEQPREEMB	, Nil })
	If _cTIPOREG $ "Baixa|Liquida"
		aAdd( _aTrabalho , { "EEQ_PARC"		, _cEEQPARC		, Nil })
		aAdd( _aTrabalho , { "EEQ_MOTIVO"	, _cEEQMOTIVO	, Nil })
	Endif
	If _cTIPOREG $ "Adto|Baixa"
		aAdd( _aTrabalho , { "EEQ_VL"		, _nEEQVL		, Nil })
		aAdd( _aTrabalho , { "EEQ_DTCE"		, _dEEQDTCE		, Nil })
	Endif
	If _cTIPOREG == "Adto"
		aAdd( _aTrabalho , { "EEQ_MODAL"	, "1"			, Nil})
	Endif
	If _cTIPOREG $ "Adto|Liquida"
		aAdd( _aTrabalho , { "EEQ_PGT"		, _dEEQPGT		, Nil })

		If _cTIPOREG == "Adto"
			aAdd( _aTrabalho , { "EEQ_NROP"		, _cEEQNROP		, Nil })
		Else
			aAdd( _aTrabalho , { "EEQ_NROP"		, " "			, Nil })
		Endif

		aAdd( _aTrabalho , { "EEQ_BANC"		, _cEEQBANC		, Nil })
		aAdd( _aTrabalho , { "EEQ_AGEN"		, _cEEQAGEN		, Nil })
		aAdd( _aTrabalho , { "EEQ_NCON"		, _cEEQNCON		, Nil })
		If _cTIPOREG $ "Adto|Liquida"
			aAdd( _aTrabalho , { "EEQ_NOMEBC"	, _cEEQNOMBC	, Nil })
		Endif
		aAdd( _aTrabalho , { "EEQ_RFBC"		, _cEEQRFBC		, Nil })
	Endif
	If _cTIPOREG $ "Liquida"
		aAdd( _aTrabalho , { "EEQ_TX"		, _nEEQTX		, Nil })
		aAdd( _aTrabalho , { "EEQ_OBS"		, _cEEQZOBS		, Nil })
	Endif
	If _cTIPOREG == "Baixa"
		aAdd( _aTrabalho , { "EEQ_DESCON"	, _nEEQDESCON	, Nil })
		aAdd( _aTrabalho , { "EEQ_ACRESC"	, _nEEQACRESC	, Nil })
		aAdd( _aTrabalho , { "EEQ_DECRES"	, _nEEQDECRES	, Nil })
	Endif
	If _cTIPOREG $ "Adto|Baixa"
		aAdd( _aTrabalho , { "EEQ_ZREFBC"	, _cEEQZREFBC	, Nil })
		aAdd( _aTrabalho , { "EEQ_ZORDNT"	, _cEEQZORDNT	, Nil })
		aAdd( _aTrabalho , { "EEQ_ZDESP"	, _nEEQZDESP	, Nil })
		aAdd( _aTrabalho , { "EEQ_ZBANCO"	, _cEEQZBANCO	, Nil })
		aAdd( _aTrabalho , { "EEQ_ZAGENC"	, _cEEQZAGENC	, Nil })
		aAdd( _aTrabalho , { "EEQ_ZCONTA"	, _cEEQZCONTA	, Nil })
		aAdd( _aTrabalho , { "EEQ_ZOBS"		, _cEEQZOBS		, Nil })
	Endif
	aAdd( _aTrabalho , { _cEEQZID000		, _cZGHID		, Nil })
	//
	If _cTIPOREG $ "Baixa|Liquida"
		aAdd(_aProcBxLq, _aTrabalho)
	Else
		aAdd(_aProcAdto, _aTrabalho)
	Endif
	_aTrabalho	:=	{}
Return

/*/
==============================================================================================================================================================================
{Protheus.doc} ExecRotAuto()
Efetua a execucao dos Msexecauto

@author Renato Junior @since 30/06/2020  @type Function

@param 	_cQualProc	- 1=Adto/Baixa ; 2-Liquidacao
        _oArray		- conteudo do log de processamento
		_aProcAdto	- Array com Adiantamento
		_aProcBxLq	- Array com Alteração/Baixa/Liquidações
/*/
Static Function ExecRotAuto( _cQualProc, _oArray, _aProcAdto, _aProcBxLq )
	Local _nCti			:=	_nCtj	:=	0
	Local _cMsgLog		:=	""
	local _cTPREG		:=	_cEEQPREEMB := _cEEQEVENT := ""
	Local _aCab     	:= {}
	Local _aEEQ     	:= {}
	Local aErro 		:= {}
	Local cErro 		:= ""
	Local nI        	:= 0
	Local cNameLog		:= ""
	Local _cEEQPARC		:=  ""
	Local _nRECNOTRB	:=  0
	Local _nPosEEQ		:=	0
	Local _lAborta		:=	.F.

	Private lMsHelpAuto     := .T.
	Private lMsErroAuto     := .F.
	Private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	// Adiantamento
	For _nCti	:=	1	TO LEN(_aProcAdto)
		_aEEQ	:=	_aProcAdto[_nCti]

		cFilBkp	:=	cFilAnt //
		cFilAnt		:=	_aEEQ[1][1]
		aAreaSM0	:=	SM0->( GetArea() )	//
		SM0->(DbSeek("01"+cFilAnt)) //é utilizado o 01, por grupo de empresas, caso necessário rotina pode ser adaptada

		nOpc		:=	_aEEQ[1][2]
		_cTPREG		:=	_aEEQ[1][3]
		_cEEQPREEMB	:=  _aEEQ[1][4]
		If nOpc	== 5	// Exclusao
			_cEEQPARC	:=  _aEEQ[1][6]
			_nRECNOTRB	:=  _aEEQ[1][7]
		Endif
		_aCab      := {}	//Dados do Cliente/Importador
		ADEL(_aEEQ, 1)
		aSize(_aEEQ,Len(_aEEQ)-1)

		If ! EE7->( DbSetOrder(1) , DbSeek( XFILIAL("EE7") + _cEEQPREEMB ))
			_cMsgLog	:= "Nao encontrou EE7 : "+ XFILIAL("EE7") + _cEEQPREEMB
		Else
			If ! SA1->( DbSetOrder(1) , DbSeek( XFILIAL("SA1") + EE7->(EE7_IMPORT+EE7_IMLOJA) ))	// posicionar no cliente para exclusao
				_cMsgLog	:= "Nao encontrou Cliente : "+ XFILIAL("SA1") + EE7->(EE7_IMPORT+EE7_IMLOJA)
			Else
				//Begin Transaction
				If nOpc	== 5	// Exclusao - Retorna conteudos padroes do Execauto Adiantamento Cliente
					_nBkEEQPGT	:=	EEQ->EEQ_PGT
					_nBkEEQTX	:=	EEQ->EEQ_TX
					/*/
					EEQ->( DbSetOrder(1) , DbSeek( XFILIAL("EEQ") + _cEEQPREEMB + _cEEQPARC))
					EEQ->(RECLOCK("EEQ",.F.))
					EEQ->EEQ_PREEMB	:=	EE7->(EE7_IMPORT+EE7_IMLOJA)	// Retorna Cliente + Loja
					EEQ->EEQ_FASE	:=	"C"								// Adiantamento Fase Cliente (unico execauto existente)
					EEQ->EEQ_PGT	:=	STOD("")						// Necessario limpar antes
					EEQ->EEQ_TX		:=	0								// Necessario limpar antes
					EEQ->(MSUNLOCK())
					/*/
					_nPosEEQ		:=	EEC83F(cFilAnt, _cEEQPREEMB, ZGH->ZGH_ID )
					EEQ->( DBGOTO( _nPosEEQ ))
					EEQ->(RECLOCK("EEQ",.F.))
					EEQ->EEQ_PREEMB	:=	EE7->(EE7_IMPORT+EE7_IMLOJA)	// Retorna Cliente + Loja
					EEQ->EEQ_FASE	:=	"C"								// Adiantamento Fase Cliente (unico execauto existente)
					EEQ->EEQ_PGT	:=	STOD("")						// Necessario limpar antes
					EEQ->EEQ_TX		:=	0								// Necessario limpar antes
					EEQ->EEQ_PROCES	:=	_cEEQPREEMB						// Para evitar Duplicate Key, usado somente para estornar
					EEQ->(MSUNLOCK())
				Endif
				aAdd(_aCab, {"A1_COD"	, EE7->EE7_IMPORT	, Nil})
				aAdd(_aCab, {"A1_LOJA"	, EE7->EE7_IMLOJA	, Nil})
				MsAguarde({|| MSExecAuto( {|X,Y,Z,Aux| EECAC100(x,,y,z,"AC100ADIAN") }, _aCab, nOpc , _aEEQ) }, "Adiantamento Automático ("+STR(_nCti,3)+"/"+STR(LEN(_aProcAdto),3)+")")
				If lMsErroAuto
					aErro := GetAutoGRLog() // Retorna erro em array
					cErro := ""
					for nI := 1 to len(aErro)
						cErro += aErro[nI] + CRLF
					next nI
					cNameLog := ALLTRIM(XFILIAL("EE7")+_cEEQPREEMB)
					memoWrite(_cDirCsv+"Erro\" + cNameLog+"_"+strTran(time(),":")+".TXT" , cErro)
					_cMsgLog	:= "Erro de Execução : "+_cTPREG
					If nOpc	== 5	.AND. EEQ->EEQ_FASE	==	"C"	// Se ocorrer Erro Exclusao e ainda estiver como Adto cliente - Retorna conteudos antes do Execauto
//						EEQ->( DbSetOrder(1) , DbSeek( XFILIAL("EEQ") + _cEEQPREEMB + _cEEQPARC))
						EEQ->( DBGOTO( _nPosEEQ ))
						EEQ->(RECLOCK("EEQ",.F.))
						EEQ->EEQ_PREEMB	:=	EEQ->EEQ_NRINVO
						EEQ->EEQ_FASE	:=	"P"
						EEQ->EEQ_PGT	:=	_nBkEEQPGT
						EEQ->EEQ_TX		:=	_nBkEEQTX
						EEQ->EEQ_PROCES	:=	""
						EEQ->(MSUNLOCK())
						_cMsgLog	:= "Atenção, Processo Cancelado ! Verifique a Filial/EXP : "+EEQ->EEQ_FILIAL+"/"+EEQ->EEQ_PREEMB
						_lAborta	:=	.T.
					Endif
				Else
					If nOpc	<> 5
						//Begin Transaction - nao utilizar pois ocorre erro
						// Ajusta adiantamento para o padrao de EECAP100 , pois este nao tem EXECAUTO especifico
						If EEQ->(RECLOCK("EEQ",.F.))
							EEQ->EEQ_PARC	:=	SOMA1(EEC83E(EEQ->EEQ_FILIAL, EEQ->EEQ_PREEMB, "602"),2)
							EEQ->EEQ_EVENT	:=	"602"
							EEQ->EEQ_FASE	:=	"P"
							EEQ->(MSUNLOCK())
						Else
							//DisarmTransaction()
							_cMsgLog	:= "Não foi possível ajustar parcela na EEQ"
						Endif
						//Endif
					Endif
					//
					_cMsgLog	:= Iif(nOpc	== 5,"Estorno","Inclusão") +" realizada com Sucesso"
					//End Transaction
				Endif
			EndIf
		Endif
		aAdd(_oArray, {_cTPREG, cFilAnt , _cEEQPREEMB, _cMsgLog, _nRECNOTRB  })
		cFilAnt	:=	cFilBkp
		RestArea(aAreaSM0)
		If _lAborta
			Return Nil
		Endif
	Next
	// Alteração (Desdobramento) / Baixa / Liquidação
	For _nCti	:=	1	TO LEN(_aProcBxLq)
		_aEEQ		:=	_aProcBxLq[_nCti]
		cFilBkp	:=	cFilAnt
		cFilAnt		:=	_aEEQ[1][1]
		aAreaSM0	:=	SM0->( GetArea() )	//
		SM0->(DbSeek("01"+cFilAnt)) //é utilizado o 01, por grupo de empresas, caso necessário rotina pode ser adaptada
		//
		nOpc		:=	_aEEQ[1][2]
		_cTPREG		:=	_aEEQ[1][3]
		_cEEQPREEMB :=	_aEEQ[1][4]
		_cEEQEVENT	:=	_aEEQ[1][5]
		If LEN( _aEEQ[1]) > 5 // Estorno Baixa ou Liquidação
			_cEEQPARC	:=  _aEEQ[1][6]
			_nRECNOTRB	:=  _aEEQ[1][7]
		Endif
		ADEL(_aEEQ, 1)
		aSize(_aEEQ,Len(_aEEQ)-1)
		_aCab      := {}
		aAdd( _aCab , { "EEC_FILIAL" , cFilAnt		, Nil })
		aAdd( _aCab , { "EEC_PREEMB" , _cEEQPREEMB	, Nil })

		If ! EEC->( DbSetOrder(1) , DbSeek( XFILIAL("EEC") + _cEEQPREEMB ))
			_cMsgLog	:= "Nao encontrou EEC : "+XFILIAL("EEC") + _cEEQPREEMB
		Else
			//Begin Transaction  - nao utilizar pois ocorre erro
			MsAguarde({|| MsExecAuto({|a,b,c,d| EECAF200(a,b,c,d) }, _aCab, 3, _aEEQ, nOpc) }, "Baixa/Liquidação Automático ("+STR(_nCti,3)+"/"+STR(LEN(_aProcBxLq),3)+")")
			If lMsErroAuto
				aErro := GetAutoGRLog() // Retorna erro em array
				cErro := ""
				for nI := 1 to len(aErro)
					cErro += aErro[nI] + CRLF
				next nI
				cNameLog := ALLTRIM(XFILIAL("EEC")+_cEEQPREEMB)
				memoWrite(_cDirCsv+"Erro\" + cNameLog+"_"+strTran(time(),":")+".TXT" , cErro)
				_cMsgLog	:= "Erro de Execução : "+_cTPREG
			Else
				If _nRECNOTRB > 0	// No Estorno precisa reposicionar pois retorna no proximo registro.
					EEQ->( DbSetOrder(1) ,  DBSEEK(XFILIAL("EEQ") + _cEEQPREEMB + _cEEQPARC))
				Endif
				If ! EEQ->(RECLOCK("EEQ",.F.))	// Grava o campo Id e ajusta EEQ_ZREFBC, pois o Execauto não o faz.
					_cMsgLog	:= "Não foi possível ajustar EEQ_ZID00 na EEQ : "+_cTPREG
				Else
					If "Alteração" $ _cTPREG	// Este é o novo registro desdobrado na EEQ, com campos em branco.
						If "Liquida" $ _cTPREG
							EEQ->EEQ_ZREFBC	:=	"@"+EEQ->EEQ_ZREFBC
							EEQ->EEQ_ZID002	:=	_cZGHID
						Else
							EEQ->EEQ_ZID001	:=	_cZGHID
						Endif
					ElseIf _nRECNOTRB > 0	//"Estorno"
						If _cTPREG	==	"Liquidação"
							EEQ->EEQ_ZID002	:=	""
							EEQ->EEQ_BANC	:=	""	//Execauto nao limpa estes campos
							EEQ->EEQ_AGEN	:=	""
							EEQ->EEQ_NCON	:=	""
							EEQ->EEQ_NOMEBC	:=	""
							EEQ->EEQ_RFBC	:=	""
							EEQ->EEQ_NROP	:=	""
							EEQ->EEQ_OBS	:=	""
						Else
							EEQ->EEQ_ZID001	:=	""
						Endif
					Endif
					EEQ->(MSUNLOCK())
				Endif
				_cMsgLog	:= Iif(_nRECNOTRB>0,"Estorno","") +" Realizado com Sucesso : "+_cTPREG
			EndIf
			//End Transaction
		Endif
		If _cQualProc	==	"1"
			aAdd(_oArray, {_cTPREG, cFilAnt, _cEEQPREEMB, _cMsgLog, _nRECNOTRB })
		Else
			aAdd(_oArray, {cFilAnt, _cEEQPREEMB, _cEEQEVENT, _cMsgLog, _nRECNOTRB })
		Endif
		//
		cFilAnt	:=	cFilBkp
		RestArea(aAreaSM0)
	Next
Return Nil

/*/
==============================================================================================================================================================================
{Protheus.doc} Inc_aCols()
Função intermediária de exemplo, descrição resumida em uma linha

@author Renato Junior  @since 25/06/2020  @type Function

@param	_cTpLin - Tipo : 1 Adto/Baixa ; Liquidacao
		_oArray - Referencia, contem resultado dos erroa para o U_MGListBox()
		_cTextoErr - Conteudo da Inconsistencia ou Erro de processamento
/*/
Static Function Inc_aCols( _cTpLin, _oArray, _cTextoErr)

	If _cTpLin	==	"1"
		aAdd(_oArray, {_cTIPOREG,_cEEQ_FIL, _cEEQPREEMB, _cTextoErr  })
	Else
		aAdd(_oArray, {_cEEQ_FIL, _cEEQPREEMB, _cEEQEVENT, _cTextoErr  })
	Endif
Return nil

/*/
==============================================================================================================================================================================
{Protheus.doc} VlSemPont( )
Função que remove caracter ponto e altera virgula para ponto, formatando no padrao numerico

@author Renato Junior  @since 08/07/2020  @type Function
@param	_cColValor
/*/
Static Function VlSemPont( _cColValor)
	Local _YVarTrab	:=	STRTRAN(_cColValor,".","")	//Remove ponto do milhar
	_YVarTrab	:=	STRTRAN(_YVarTrab,",",".")	// Virgula decimal para Ponto
Return( VAL(_YVarTrab) )

//-------------------------------------------------------------------
/*/{Protheus.doc} EEC83SETDIR
Rotina para "setar" o caminho do arquivo de retorno
@author Renato Junior
/*/
//-------------------------------------------------------------------
User Function EEC83SETDIR()
	cRetDir := cGetFile("Todos os Arquivos|*.csv",OemToAnsi("Informe o diretório onde se encontra o arquivo."),0,"SERVIDOR\",.T.,,.F.)
Return !Empty(cRetDir)
//-------------------------------------------------------------------
/*/{Protheus.doc} EEC83GETDIR
Rotina para retornar o caminho do arquivo de retorno para o mv_par da pergunta
@author Renato Junior
/*/
//-------------------------------------------------------------------
User Function EEC83GETDIR()
	Local cRet := cRetDir
Return cRet
//-------------------------------------------------------------------
/*/{Protheus.doc} EEC83ADIAN
Rotina para alimentar o conteudo do campo EEQ_PREEMB se este estiver com
conteudo incorreto, ou seja, igual ao Cliente + Loja (Importador)
Solução temporaria , pois foi aberto chamado na Totvs em 3/7 sobre a gravação
do campo EEQ_PREEMB no execauto EECAC100

@author Renato Junior
/*/
User Function EEC83ADIAN()
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))

	If cParam == "GRAVANDO_EEQ"
		If EEQ->(EEQ_IMPORT+EEQ_IMLOJA)	== ALLTRIM(EEQ->EEQ_PREEMB)
			EEQ->EEQ_PREEMB	:=	EEQ->EEQ_NRINVO
		Endif
	Endif
Return

/*/
==============================================================================================================================================================================
{Protheus.doc} ValidPerg()
Cria perguntas de acordo com o tipo do arquivo

@author Renato Junior @since 24/06/2020  @type Function
/*/
Static Function ValidPerg()
	Local _sAlias       := Alias()
	Local aPerguntas    := {}
	Local aRegs         := {}
	Local i,j
	Local aHelpPor	:= {}
	Local aHelpSpa	:= {}
	Local aHelpEng	:= {}

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	If cPerg	== "MGFEEC83_1"
		aAdd(aRegs,{cPerg,"01","Arquivo de Entrada ?"      ,"","","mv_ch1" ,"C",60,0,0,"G","NaoVazio()","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","DIRCSV","","", ".MGFEEC83_101." ,""})
	Else
		aAdd(aRegs,{cPerg,"01","Arquivo de Entrada ?"      ,"","","mv_ch1" ,"C",60,0,0,"G","NaoVazio()","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","DIRCSV","","", ".MGFEEC83_201." ,""})
		aAdd(aRegs,{cPerg,"02","Valor de Contrato ?"       ,"","","mv_ch2" ,"N",13,2,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","", ".MGFEEC83_202.","@E 9,999,999,999.99"})
	Endif

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			//Se tiver Help da Pergunta
			If !Empty(aRegs[i,41])
				X1_HELP    := ""
				If aRegs[i,41] == ".MGFEEC83_101."
					cHelp	:=	"Informe o caminho e o nome do arquivo que contÃ©m os adiantamentos e baixas de cÃ¢mbio"
				ElseIf aRegs[i,41] == ".MGFEEC83_201."
					cHelp	:= "Informe o caminho e o nome do arquivo que contÃ©m as informaÃ§Ãµes de liquidaÃ§Ã£o de cÃ¢mbio"
				ElseIf aRegs[i,41]	==	".MGFEEC83_202."
					cHelp	:=	"Informe o valor deste contrato"
				Endif
				fPutHelp(aRegs[i,41], cHelp)
			EndIf
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
Return()

/*---------------------------------------------------*
| FunÃ§Ã£o: fPutHelp                                  |
| Desc:   FunÃ§Ã£o que insere o Help do Parametro     |
*---------------------------------------------------*/
Static Function fPutHelp(cKey, cHelp, lUpdate)
	Local cFilePor  := "SIGAHLP.HLP"
	Local cFileEng  := "SIGAHLE.HLE"
	Local cFileSpa  := "SIGAHLS.HLS"
	Local nRet      := 0
	Default cKey    := ""
	Default cHelp   := ""
	Default lUpdate := .F.
	//Se a Chave ou o Help estiverem em branco
	If Empty(cKey) .Or. Empty(cHelp)
		Return
	EndIf
	//**************************** PortuguÃªs
	nRet := SPF_SEEK(cFilePor, cKey, 1)
	//Se nÃ£o encontrar, serÃ¡ inclusÃ£o
	If nRet < 0
		SPF_INSERT(cFilePor, cKey, , , cHelp)
		//SenÃ£o, serÃ¡ atualizaÃ§Ã£o
	Else
		If lUpdate
			SPF_UPDATE(cFilePor, nRet, cKey, , , cHelp)
		EndIf
	EndIf
	//**************************** InglÃªs
	nRet := SPF_SEEK(cFileEng, cKey, 1)
	//Se nÃ£o encontrar, serÃ¡ inclusÃ£o
	If nRet < 0
		SPF_INSERT(cFileEng, cKey, , , cHelp)
		//SenÃ£o, serÃ¡ atualizaÃ§Ã£o
	Else
		If lUpdate
			SPF_UPDATE(cFileEng, nRet, cKey, , , cHelp)
		EndIf
	EndIf
	//**************************** Espanhol
	nRet := SPF_SEEK(cFileSpa, cKey, 1)
	//Se nÃ£o encontrar, serÃ¡ inclusÃ£o
	If nRet < 0
		SPF_INSERT(cFileSpa, cKey, , , cHelp)
		//SenÃ£o, serÃ¡ atualizaÃ§Ã£o
	Else
		If lUpdate
			SPF_UPDATE(cFileSpa, nRet, cKey, , , cHelp)
		EndIf
	EndIf

Return


/*/
==============================================================================================================================================================================
Descrição   : Tela para Estorno dos Movimentos

@description
Seleciona as operações executadas pela rotina, atraves de filtro no campo EEQ_ZID001
Permite marcar apenas os que se deseja Estornar
Monta a Tabela Temporária

@author     : Renato Junior
@since      : 07/08/2020
@type       : User Function

@table
ZGH -   LOG DE ARQUIVOS IMPORTADOS
EEQ -	EVENTOS DA EXPORTACAO

@param
@return
@menu
Financeiro - Atualizações-Especificos MARFRIG

@history
/*/
User Function EEC83A()
	Local aPergs	:= {}
	local _aStruEEQ :=  {}
	local _aStrut   :=  {}
	local _aCampos  :=  {}
	local _ni       :=  0

	Private _cLayout  :=  ""
	Private _aRet	:= {}
	If ZGH->ZGH_TIPO == '2'
		_cLayout  :=  "Liquidação"
	Else
		aAdd(aPergs,{3,"Estorno de"             ,1,{"Adto","Baixa"},50,"",.F.})
		If !ParamBox(aPergs ,"Layout do Relatório",_aRet)
			Help( ,, 'Relatório',, 'Processamento Cancelado', 1, 0 )
			Return
		EndIf
		If _aRet[1]	==	1
			_cLayout  :=  "Adiantamento"
		Else
			_cLayout  :=  "Baixa"
		Endif
		_aRet		:= {}
	Endif

	_aStruEEQ	:= EEQ->(DBSTRUCT())
	_aCampos    :=  {"EEQ_FILIAL","EEQ_PREEMB","EEQ_NRINVO","EEQ_EVENT","EEQ_PARC","EEQ_DTCE","EEQ_ZORDNT","EEQ_ZREFBC","EEQ_ZDESP", ;
		"EEQ_VL","EEQ_DESCON","EEQ_ACRESC","EEQ_MOTIVO","EEQ_ZOBS","EEQ_ZBANCO","EEQ_ZAGENC","EEQ_ZCONTA","EEQ_DECRES", ;
		"EEQ_PGT","EEQ_RFBC","EEQ_NROP","EEQ_TX","EEQ_BANC","EEQ_AGEN","EEQ_NCON","EEQ_SOL","EEQ_MOEDA","EEQ_FASE" }
	_cCpoSQL	:=	""
	for _ni := 1 to len(_aStruEEQ)
		if aScan(_aCampos, _aStruEEQ[_ni][1]) > 0
			aadd(_aStrut, _aStruEEQ[_ni])
			If _ni > 1
				_cCpoSQL	+=	", "
			Endif
			_cCpoSQL	+=	_aStruEEQ[_ni][1] + " "
		endif
	next _ni
	aadd(_aStrut, {'EEQ_OK'		,'C',02 ,0})

	EEC83B(	_aStrut, _cCpoSQL )
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
Static Function EEC83B(strTab, _cCpoSQL)
	local _aStruLib	    :=  strTab //Estrutura da tabela de Aprovação GW3
	local _cTmp		    :=  GetNextAlias()
	local _cAliasTmp
	local _aColumns	    :=  {}
	local _cInsert      :=  ''
	local _nx           :=  0
	local _ni           :=  0
	local _cFim         :=  CHR(13) + CHR(10)

	dbSelectarea("EEQ")
	Dbsetorder(1)
	//Instancio o objeto que vai criar a tabela temporária no BD para poder utilizar posteriormente
	oTmpE := FWTemporaryTable():New( _cTmp )
	//Defino os campos da tabela temporária
	oTmpE:SetFields(_aStruLib)
	//Criação da tabela temporária no BD
	oTmpE:Create()
	//Obtenho o nome "verdadeiro" da tabela no BD (criada como temporária)
	_cTable := oTmpE:GetRealName()
	//Preparo o comando para alimentar a tabela temporária
	_cInsert += "INSERT INTO " + _cTable + _cFim
	_cInsert += "( " + _cFim
	_cInsert += _cCpoSQL

	_cInsert += ") " + _cFim

	_cInsert += "SELECT " + _cFim
	_cInsert += _cCpoSQL

	_cInsert += "FROM "+ RetSQLName("EEQ") +" EEQ " + _cFim
	_cInsert += "WHERE  " + _cFim

	If	_cLayout	==	"Liquidação"
		_cInsert += "EEQ_ZID002 " + _cFim
	Else
		_cInsert += "EEQ_ZID001 " + _cFim
	Endif

	_cInsert += " = '"+ZGH->ZGH_ID+"' AND EEQ.D_E_L_E_T_ = ' '  " + _cFim

	_cInsert += "AND EEQ_EVENT "
	If	_cLayout	==	"Adiantamento"
		_cInsert += " = '602'  " + _cFim
	Else
		_cInsert += " <> '602'  " + _cFim
	Endif

	If	_cLayout	==	"Liquidação"
		_cInsert += " AND EEQ_PGT <> ' ' "
	ElseIf	_cLayout	==	"Baixa"
		_cInsert += " AND EEQ_DTCE <> ' ' "
	Endif
//	_cInsert += "ORDER BY EEQ_NRINVO "
	_cInsert += "ORDER BY EEQ_PREEMB "

	//memowrite("c:\totvs\RVBJ_MGFEEC83.TXT", _cInsert  )// remover
	_cInsert := strTran(_cInsert, _cFim, '')
	Processa({|| TcSQLExec(_cInsert)})	// Alimenta a tabela temporária

	For _nx := 1 To Len(_aStruLib)
		if !(_aStruLib[_nx][1] $ CAMPOEXCL)
			aadd(_aColumns,FWBrwColumn():New())
			_aColumns[Len(_aColumns)]:SetData( &("{||"+_aStruLib[_nx][1]+"}") )
			_aColumns[Len(_aColumns)]:SetTitle(RetTitle(_aStruLib[_nx][1]))
			_aColumns[Len(_aColumns)]:SetPicture(PesqPict("EEQ",_aStruLib[_nx][1]))
			_aColumns[Len(_aColumns)]:SetSize(_aStruLib[_nx][3])
			_aColumns[Len(_aColumns)]:SetDecimal(_aStruLib[_nx][4])
		EndIf
	Next _nx

	_aRetBotao	:= FWFormBrowse():GetButton()	// --> aButtons

	_cAliasTmp := oTmpE:GetAlias()

	If (_cAliasTmp)->(RECCOUNT())	==	0
		Help( ,, 'Estorno',, 'Sem dados', 1, 0 )
	Else
		oBrowEs:= FWMarkBrowse():New()
		oBrowEs:SetAlias( _cAliasTmp )
		oBrowEs:SetDescription( 'Estorno dos Processos Selecionados - '+_cLayout )
		oBrowEs:SetTemporary(.T.)
		oBrowEs:SetLocate()
		oBrowEs:SetUseFilter(.T.)
		oBrowEs:SetDBFFilter(.T.)
		oBrowEs:SetFilterDefault( "" )
		oBrowEs:DisableDetails()
		oBrowEs:ForceQuitButton( )          // Força exibição do botão [Sair]
		oBrowEs:AddButton("Confirma", {|| MsgRun('Estornando '+_cLayout,'Processando',{|| EEC83C() , oBrowEs:refresh(.T.) }) },,,, .F., 2 )
		oBrowEs:AddButton("Marca/Desmarca", {|| xMarkAll()},,,, .F., 2 )

		oBrowEs:SetFieldMark("EEQ_OK")
		oBrowEs:SetCustomMarkRec({||xMark()})

		oBrowEs:SetAllMark({|| xMarkAll() })

		// Definição da legenda
		oBrowEs:AddLegend( "! EMPTY(EEQ_OK)", "BR_VERDE"	, "Selecionado" )
		oBrowEs:AddLegend( "EMPTY(EEQ_OK) ", "BR_VERMELHO"	, "Não Selecionado" )

		oBrowEs:SetColumns(_aColumns)

		oBrowEs:SetMenuDef('EEC83C')

		oBrowEs:Activate()
	Endif
	oTmpE:Delete()
Return Nil

/*/{Protheus.doc} xMark()
// Marca todas as opções com Zero de diferença

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return lRet
/*/
static function xMark()
	local cAlias    :=  oBrowEs:Alias()
	local lRet      :=  .T.

	If (!oBrowEs:IsMark())
		RecLock(cAlias,.F.)
		(cAlias)->EEQ_OK  := oBrowEs:Mark()
		(cAlias)->(MsUnLock())
	Else
		RecLock(cAlias,.F.)
		(cAlias)->EEQ_OK  := ""
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
static function xMarkAll(XcOqfazer)
	local lRet      :=  .T.
	local cAlias	:= oBrowEs:Alias()
	local aRest		:= GetArea()

	(cAlias)->(DbGoTop())
	While (cAlias)->(!Eof())
		RecLock(cAlias,.F.)
		If (!oBrowEs:IsMark())
			(cAlias)->EEQ_OK  := oBrowEs:Mark()
		Else
			(cAlias)->EEQ_OK  := ""
		EndIf
		(cAlias)->(MsUnLock())
		(cAlias)->(DbSkip())
	EndDo
	RestArea(aRest)
	oBrowEs:refresh(.F.)
Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} EEC83C()
Efetua o Estorno dos registros selecionados

@author Renato Junior

@since 10/08/2020
@version 1.0
@return Nil
/*/
//-------------------------------------------------------------------
Static function EEC83C()
	local cAlias		:= oBrowEs:Alias()
	local aRest			:= GetArea()
	local _aheader		:=	{}
	local _acols		:=	{}
	Local _aProcAdto:=  {}
	Local _aProcBxLq :=	{}
	Local nCtA	:=	0
	Local lContinua	:=	.T.

	Private _cDirCsv	:=	STRTRAN(ZGH->ZGH_ARQUIV, RetNmCurto(ZGH->ZGH_ARQUIV),"")

	(cAlias)->(DbGoTop())
	While (cAlias)->(!Eof())
		If oBrowEs:IsMark()
			EEC83D( cAlias, _cLayout, @_aProcAdto, @_aProcBxLq, @_acols )	// Carrega Array para o Execauto
			RecLock(cAlias,.F.)
			(cAlias)->(DBDELETE())	// Exclui da lista todos os que foram processados, com ou sem erro
		EndIf
		(cAlias)->(DbSkip())
	EndDo
	oBrowEs:refresh(.T.)
	//
	RestArea(aRest)
	If Len(_acols)	> 0	// Tem inconsistencias
		// Colunas do Log
		If	!	_cLayout	==	"Liquidação"
			_aheader := {"Tipo Registro","Filial","Processo","Inconsistência"}
		Else
			_aheader := {"Filial","Processo","Evento","Inconsistência"}
		Endif

		U_MGListBox( "Log de Leitura do Arquivo de Estorno ("+_cLayout+")" , _aheader , _acols , .T. , 1 )
	Endif

	If LEN(_aProcAdto)+LEN(_aProcBxLq) > 0
		lContinua := .T.
	Else
		lContinua := .F.
	EndIf
	// Se tem algo correto e tambem com erro, verifica se vai continuar. Se tudo com erro encerra
	If (lContinua)
		_acols:=	{}
		ExecRotAuto( Iif( _cLayout=="Liquidação","2","1" ), @_acols, @_aProcAdto, @_aProcBxLq )
		If Len(_acols)	> 0	// Se Tem inconsistencias alimenta Colunas do Log
			If ! _cLayout=="Liquidação"
				_aheader := {"Tipo Registro","Filial","Processo","Retorno"}
			Else
				_aheader := {"Filial","Processo","Evento","Retorno"}
			Endif
			U_MGListBox( "Log de Processamento ("+_cLayout+")" , _aheader , _acols , .T. , 1 )
		Endif
	Endif
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} EEC83D()
Preenche Arrays de Adiantamento e Baixa para o EXECAUTO

@author Renato Junior

@since 13/08/2020
@version 1.0
@param
_cTIPOREG
_aProcAdto - array com Adiantamentos
_aProcBxLq - array com Baixas e Liquidações
_aAchouErr - Array que ira receber os erros

EEQ	G 16	EEQ_FILIAL+EEQ_PREEMB+EEQ_EVENT+EEQ_FASE+EEQ_FORN+EEQ_FOLOJA+EEQ_PARC

@return Nil
/*/
//-------------------------------------------------------------------
static function EEC83D(cAlias, XcTIPOREG, _aProcAdto, _aProcBxLq, _aAchouErr)
	Local _aTrabalho	:=	{}
	Local _cMsgErr		:=	""
	Local _XcTipo		:=	IIf(XcTIPOREG	==	"Liquidação", "2","1")

	Private _cQualProc	:=	_XcTipo
	Private	_cTIPOREG	:=	XcTIPOREG
	Private	_cEEQ_FIL	:=	(cAlias)->EEQ_FILIAL
	Private	_cEEQPREEMB	:=	(cAlias)->EEQ_PREEMB
	Private	_cEEQEVENT	:=	(cAlias)->EEQ_EVENT

	If _cTIPOREG == "Adiantamento" .AND. EEQ->( DbSetOrder(16) ,  DBSEEK( (cAlias)->(EEQ_FILIAL+EEQ_PREEMB) + "603"))	//EEQ_FILIAL+EEQ_PREEMB+EEQ_EVENT+EEQ_FASE+EEQ_FORN+EEQ_FOLOJA+EEQ_PARC
		Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Evento 603 de compensação existente")
		Return
	Endif

	If _cTIPOREG == "Baixa"	.AND.  ! EMPTY( (cAlias)->EEQ_PGT)	//	Pre-validacao 2 - estorno baixa nao pode estar liquidado
		Inc_aCols(_XcTipo, @_aAchouErr,  _cMsgErr:="Evento liquidado não pode ser Estornado")
		Return
	Endif

	If ! EMPTY(_cMsgErr)	// Se achar alguma mensagem, houve erro e nao continua para execauto
		Return
	Endif
	If _cTIPOREG == "Adiantamento"
		aAdd(_aTrabalho, { (cAlias)->EEQ_FILIAL, 5, _cTIPOREG, (cAlias)->EEQ_PREEMB, ""					,(cAlias)->EEQ_PARC, (cAlias)->(RECNO()) })
	ElseIf _cTIPOREG == "Baixa"
		aAdd(_aTrabalho, { (cAlias)->EEQ_FILIAL, 5, _cTIPOREG, (cAlias)->EEQ_PREEMB, (cAlias)->EEQ_EVENT,(cAlias)->EEQ_PARC, (cAlias)->(RECNO()) })
		aAdd( _aTrabalho, { "EEQ_PREEMB"	, (cAlias)->EEQ_PREEMB	, Nil })

	ElseIf _cTIPOREG == "Liquidação"
		aAdd(_aTrabalho, { (cAlias)->EEQ_FILIAL, 98, _cTIPOREG, (cAlias)->EEQ_PREEMB, (cAlias)->EEQ_EVENT,(cAlias)->EEQ_PARC, (cAlias)->(RECNO()) })
		aAdd( _aTrabalho, { "EEQ_PREEMB"	, (cAlias)->EEQ_PREEMB	, Nil })
	Endif

	aAdd( _aTrabalho, { "EEQ_EVENT"		, (cAlias)->EEQ_EVENT	, Nil })
	aAdd( _aTrabalho, { "EEQ_NRINVO"	, (cAlias)->EEQ_NRINVO	, Nil })
	aAdd( _aTrabalho, { "EEQ_PARC"		, (cAlias)->EEQ_PARC	, Nil })
	If _cTIPOREG == "Adiantamento"
		aAdd( _aTrabalho, {"EEQ_VL"		, (cAlias)->EEQ_VL		, Nil })
		aAdd( _aTrabalho, {"EEQ_MODAL"	, "1"					, Nil })
		aAdd( _aTrabalho, {"EEQ_MOEDA"	, (cAlias)->EEQ_MOEDA	, Nil })
		aAdd( _aTrabalho, {"EEQ_DTNEGO"	, (cAlias)->EEQ_DTCE	, Nil })
		aAdd( _aTrabalho, {"EEQ_NROP"	, (cAlias)->EEQ_NROP	, Nil})
		aAdd( _aTrabalho, {"EEQ_PGT"	, (cAlias)->EEQ_PGT		, Nil})
		aAdd( _aTrabalho, {"EEQ_TX"		, (cAlias)->EEQ_TX		, Nil})
		aAdd( _aTrabalho, {"EEQ_BANC"	, (cAlias)->EEQ_BANC	, Nil})
		aAdd( _aTrabalho, {"EEQ_AGEN"	, (cAlias)->EEQ_AGEN	, Nil})
		aAdd( _aTrabalho, {"EEQ_NCON"	, (cAlias)->EEQ_NCON	, Nil})
		aAdd( _aTrabalho, {"EEQ_RFBC"	, (cAlias)->EEQ_RFBC	, Nil})
		aAdd( _aTrabalho, {"EEQ_MOEBCO"	, (cAlias)->EEQ_MOEDA	, Nil })
	Endif
	If _cTIPOREG == "Baixa"
		aAdd( _aTrabalho, {"EEQ_DTCE"		, STOD("")	, Nil })
		aAdd( _aTrabalho, {"EEQ_SOL"		, STOD("")	, Nil })
		aAdd( _aTrabalho, {"EEQ_ZREFBC"		, ""		, Nil })
		aAdd( _aTrabalho, {"EEQ_ZORDNT"		, ""		, Nil })
		aAdd( _aTrabalho, {"EEQ_ZDESP"		, 0			, Nil })
		aAdd( _aTrabalho, {"EEQ_ZBANCO"		, ""		, Nil })
		aAdd( _aTrabalho, {"EEQ_ZAGENC"		, ""		, Nil })
		aAdd( _aTrabalho, {"EEQ_ZCONTA"		, ""		, Nil })
		aAdd( _aTrabalho, {"EEQ_ZNOMEB"		, ""		, Nil })
		aAdd( _aTrabalho, {"EEQ_ZOBS"		, ""		, Nil })
		aAdd( _aTrabalho, {"EEQ_DESCON"		, 0			, Nil })
		aAdd( _aTrabalho, {"EEQ_ACRESC"		, 0			, Nil })
		aAdd( _aTrabalho, {"EEQ_DECRES"		, 0			, Nil })
	Endif
	//
	If _cTIPOREG $ "Baixa|Liquidação"
		aAdd(_aProcBxLq, _aTrabalho)
	Else
		aAdd(_aProcAdto, _aTrabalho)
	Endif
Return Nil

/*/
==============================================================================================================================================================================
{Protheus.doc} RetNmCurto()
Remove somente o nome do arquivo, ignorando o caminho

@author Renato Junior
@since 13/08/2020
@type Function

@param 	_cQualArq   - "C:\TOTVS\ADTO\ADTO_D030303.CSV"
@return cRetorno - conteudo do nome do arquivo CSV

_cNmCurto	:=	RetNmCurto(_cArqNome)

/*/
Static Function RetNmCurto(_cArqNome)
	Local _cRetorno		:=	""
	Local  _nPosCara	:=	0

	If (_nPosCara	:=	RAT("\", _cArqNome)) > 0	// Encontrou a \
		_cRetorno	:=	SUBSTR(_cArqNome, _nPosCara+1, LEN(_cArqNome))

	ElseIf (_nPosCara := RAT(":", _cArqNome))	// Encontrou o :
		_cRetorno	:=	SUBSTR(_cArqNome, _nPosCara+1, LEN(_cArqNome))
	Endif

Return( _cRetorno)


/*/{Protheus.doc} EEC83E
Função para retornar a ultima parcela da EXp informada
Utilizado na inclusao do adiantamento e na baixa com sequencia ??

@author Renato Bandeira
@since 09/10/2020

@param - Xanivel - array com os niveis + grupos
/*/
Static Function EEC83E(cEEQFILIAL,cEEQPREEMB, cEEQEVENT /*cEEQPARC*/)
	Local cQuery		:= ''
	Local cNextAlias	:= GetNextAlias()
	Local cRetParc		:=	"01"
	local aRest			:= GetArea()

	cQuery  += " SELECT NVL(MAX(EEQ_PARC),'00') AS ULTPARC FROM "+RetSqlName("EEQ")+" EEQ  "
	cQuery  += " WHERE D_E_L_E_T_ = ' ' AND EEQ_FILIAL = '"+cEEQFILIAL+"' AND EEQ_PREEMB = '"+cEEQPREEMB+"' "
	If !Empty(cEEQEVENT)
		cQuery  += " AND EEQ_EVENT = '"+cEEQEVENT+"' "
	Endif
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
	dbSelectArea(cNextAlias)
	(cNextAlias)->(dbGoTop())
	If ! (cNextAlias)->(Eof())
		cRetParc	:=	(cNextAlias)->ULTPARC
	Endif
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	RestArea(aRest)
Return(cRetParc)

/*/{Protheus.doc} EEC83F
Função para retornar o RECNO do Adiantamento incluido pela rotina automatica

@author Renato Bandeira
@since 05/11/2020

@param - Xanivel - array com os niveis + grupos
/*/
Static Function EEC83F(cEEQFILIAL,cEEQPREEMB, cEEQZID001 )
	Local cQuery		:= ''
	Local cNextAlias	:= GetNextAlias()
	Local nRetRecno		:=	0
	local aRest			:= GetArea()

	cQuery  += " SELECT R_E_C_N_O_ AS POS_EEQ FROM "+RetSqlName("EEQ")+" EEQ  "
	cQuery  += " WHERE D_E_L_E_T_ = ' ' AND EEQ_FILIAL = '"+cEEQFILIAL+"' AND EEQ_PREEMB = '"+cEEQPREEMB+"' "
	cQuery  += " AND EEQ_EVENT = '602' AND EEQ_ZID001 = '"+cEEQZID001+"' "
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
	dbSelectArea(cNextAlias)
	(cNextAlias)->(dbGoTop())
	If ! (cNextAlias)->(Eof())
		nRetRecno	:=	(cNextAlias)->POS_EEQ
	Endif
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	RestArea(aRest)
Return(nRetRecno)

