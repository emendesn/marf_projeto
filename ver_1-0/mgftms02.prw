#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"

#DEFINE _Chr Chr(13)+Chr(10)
/*
=====================================================================================
Programa............: MGFTMS02
Autor...............: Geronimo Benedito Alves
Data................: 26/09/2018
Descricao / Objetivo: Integração Protheus-TMS, para envio de PV
Doc. Origem.........: Integração Protheus-TMS, para envio de PV
Solicitante.........: Cliente
Uso.................: Marfrig
Fontes do FAT14 são : MGFFAT10.prw e MGFFAT16.prw	Tabelas de bloqueio : SZJ-CADASTRO DE TIPO DE PEDIDO  
																			SZT-Bloqueios  e  SZV-Bloqueios por Pedidos
=====================================================================================
*/


/*/{Protheus.doc} TMSJASPV
//Inicia o StartJob para enviar o PV e a ação informada ao TMS.
@author Geronimo Benedito Alves
@since 27/09/18
@version 1
@type function
@param aParam,     Array contendo : { (cAliasTrb)->C5_NUM,  IIf((cAliasTrb)->DELET=="*",3,1),  (cAliasTrb)->SC5_RECNO  }
@param _xC5TMSACA, caracter, m-> ou SC5->C5_ZTMSACA
@param _lTela,     boolean,  Se .T. Abre uma tela para informar o pedido de Venda, e a ação a ser enviada ao TMS (Inclusao, alteração ou exclusão)
/*/

USER Function TMSJASPV( aParam, _xC5TMSACA, _lTela, _cFunc )	//aParam == {(cAliasTrb)->C5_NUM, IIf((cAliasTrb)->DELET=="*",3,1), (cAliasTrb)->SC5_RECNO}  )
	Local aEmpFilial := { }
	Default _cFunc := ""

	SC5->(dbGoto(aParam[3]))
	_lContinua	:= SC5->(Recno()) == aParam[3]

	aEmpFilial := { cEmpAnt , SC5->C5_FILIAL }			// {"01","010003"}

	IF cFilAnt $GetMv("MGF_TMSGER")
		_lTela := .F.
		U_TMSVLPV(SC5->C5_FILIAL,SC5->C5_NUM,_xc5Tmsaca,_lTela,'')		
	Endif

	If _ltela
		fwmsgrun(,{|| U_TMSJAWPV(aParam, _xC5TMSACA, _lTela, aEmpFilial,_cFunc)},"Aguarde...","Enviando pedido " + SC5->C5_NUM + " para TMS-Transwide...")
	Else
		U_TMSJAWPV(aParam, _xC5TMSACA, _lTela, aEmpFilial,_cFunc )		
	Endif

Return()


/*/{Protheus.doc} TMSJAWPV
// Envia o PV e a ação informada ao TMS.  Antes do envio valida os dados
@author Geronimo Benedito Alves
@since 17/10/18
@version 1
@type function
@param aParam,     Array contendo : { (cAliasTrb)->C5_NUM,  IIf((cAliasTrb)->DELET=="*",3,1),  (cAliasTrb)->SC5_RECNO  }
@param _xC5TMSACA, caracter, m-> ou SC5->C5_ZTMSACA
@param _lTela,     boolean,  Se .T. Abre uma tela para informar o pedido de Venda, e a ação a ser enviada ao TMS (Inclusao, alteração ou exclusão)
/*/
USER Function TMSJAWPV( aParam ,_xC5TMSACA ,_lTela ,aEmpFilial,_cFunName )	//aParam == {(cAliasTrb)->C5_NUM, IIf((cAliasTrb)->DELET=="*",3,1), (cAliasTrb)->SC5_RECNO}  )
	Local aArea := {  }
	Local cURLPost
	Local cPV
	Local cStatus
	Local oItens
	Local lRet
	Local nCnt
	Local cChave
	Local nRet
	Local cQ
	Local cTamErro
	Local bTms
	Local cQuant
	Local aRecnoSC6
	Local _cFiliaisProcessar
	Local _lContinua
	Default _cFunName := ""

	If _ltela
		aArea := {SC5->(GetArea()),SC6->(GetArea()),SA1->(GetArea()),GetArea()}		// Se não for JOB, Grava as areas, para no retorno não ficar deposiionado.
	Endif

	cURLPost := Alltrim(GetMv("MGF_TMSUR2"))

	AtuSX6()
	AtuSZ2()
	AtuSZ3()

	cPV      := aParam[1]
	cStatus  := Alltrim(Str(aParam[2]))
	oItens   := Nil
	lRet     := .F.
	nCnt     := 0
	cChave   := ""
	nRet     := 0
	cQ       := ""
	cTamErro := 100		//TAMSX3("C5_ZTMSERR")[1]
	bTms		:= .F.
	cQuant 				:= ''
	aRecnoSC6 			:= {}
	_cFiliaisProcessar	:= GetMv("MGF_TMSFIL") + "," + GetMv("MGF_TMSFI2") 	// Parametros com as filiais que executam o processo de envio do pedido de vendas e exportação ao TMS

	SC5->(dbGoto(aParam[3]))
	_lContinua	:= SC5->(Recno()) == aParam[3]

	If !(_lcontinua) .and. _lTela
		msgstop("Falha em localizar o pedido para envio.")
	Endif


	If _lContinua
		If _cFunName $ 'U_TMSENVPV/U_TMSENVP2' // somente usa as filiais
			_cFiliaisProcessar := _cFiliaisProcessar + "," +  GetMv("MGF_TMSFI3")
		EndIf

		_lContinua			:= SC5->C5_FILIAL $ _cFiliaisProcessar

		If !(_lcontinua) .and. _lTela
			msgstop("Filial não executa envio manual de pedidos, verifique parâmetro MGF_TMSFI3")
		Endif

	Endif

	If !_lContinua							// Se não for NAS filiais liberadas e também o pedido DE filial liberada para o TMS, abandono a rotina
		aEval(aArea,{|x| RestArea(x)})
		Return(lRet)
	Endif

	Private oPV    := Nil
	Private oWSPV  := Nil
	Private _cC5TMSACA := _xC5TMSACA		// Transformo o escopo da variavel de local para private

	DbSelectArea("SZJ")
	DbSelectArea("SC5")
	DbSelectArea("SC6")
	DbSelectArea("SA2")
	DbSelectArea("SA1")

	conOut("***********************************************************************************************************"+ CRLF)
	conOut('Inicio do MGFTMS02 - integração Protheus x TMS Transwide - Filial/pedido = ' +SC5->C5_FILIAL + SC5->C5_NUM + " - " + DTOC(dDATABASE) + " - " + TIME() + CRLF)
	conOut("***********************************************************************************************************"+ CRLF)

	If _lContinua
		_lContinua	:= U_TMS_SZJ(SC5->C5_ZTIPPED)		// Verifica se tipo de pedido esta cadastrado para transmissão ao TMS na tabela SZJ
		If !(_lcontinua) .and. _lTela
			msgstop("Tipo de pedido não cadastrado para transmissão ao TMS")
		Endif
	Endif

	If _lContinua 										//.or. SC5->( Deleted() )	Registro Excluido, deve sempre ser envio para o TMS ?
		cQrySZVRet	:= GetNextAlias()
		getSZV( SC5->C5_FILIAL ,SC5->C5_NUM )
		_lContinua	:= (cQrySZVRet)->(EOF())		// Se vazio, não tem bloqueio, continua. Verifiquei por bloqueio ja existente na tabela SZV
		If !(_lcontinua) .and. _lTela
			msgstop("Pedido com bloqueio de pedido/cliente/produto não será transmitido")
		Endif
		(cQrySZVRet)->( DBCloseArea() )				// ZT_TIPO: 1=Pedido de Venda (BLOQUEIO DO PEDIDO)  2=Cliente (BLOQUEIO DO PEDIDO)  3=Produto (BLOQUEIO DO ITEM DO PEDIDO)
	Endif

	If !_lContinua
		aEval(aArea,{|x| RestArea(x)})
		Return(lRet)
	Endif

	If _lContinua

		cChave := cPV

		oPV := Nil
		oPV := GravaPVTMS():New()
		oPV:GravarPVCab(cStatus)

		aRecnoSC6 := ItensSC6(cStatus)

		For nCnt:=1 To Len(aRecnoSC6)
			SC6->(dbGoto(aRecnoSC6[nCnt]))
			If SC6->(Recno()) == aRecnoSC6[nCnt]
				oItens := Nil
				oItens := ItensPVTMS():New()
				oPV:GravarPVItens(oItens)

				//Metodo para analisar se é tipo Carne com osso (Gancho)
				//Deve ser verificar apenas o primeiro produto.
				If nCnt = 1
					oPV:CarneOsso(SC6->C6_PRODUTO)
				EndIf
			Endif
		Next

		oWSPV := MGFINT53():new(cURLPost,oPV/*oObjToJson*/,SC5->(Recno())/*nKeyRecord*/,/*cTblUpd*/,/*cFieldUpd*/,Get("MGF_TMS02B")/*cIntegra*/,Get("MGF_TMS02C")/*cTypeInte*/, cChave, .F., .F., .T.)
		
		cSavcInternet := Nil
		cSavcInternet := __cInternet
		__cInternet := "AUTOMATICO"

		oWSPV:SendByHttpPost()

		__cInternet := cSavcInternet
		
		If oWSPV:lOk
			IF oWSPV:nStatus == 1
				ConOut("Integração completada com sucesso")
				cQ := "UPDATE "+ RetSqlName("SC5")+" "
				cQ += "SET   "
				cQ += "     C5_ZTMSERR = ' ', "
				cQ += "     C5_ZTMSREE = 'N', "
				cQ += "		C5_ZTMSINT = 'S', "
				cQ += "		C5_ZTMSACA = '" + _cC5TMSACA + "' "
				cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SC5->(Recno())))
			ElseIF oWSPV:nStatus == 2
				If bTms
					ConOut("Falha na integração -> " + SUBSTR(oWSPV:cDetailInt,1,cTamErro))
					cQ := "UPDATE "+ RetSqlName("SC5")+" "
					cQ += "SET   "
					cQ += "     C5_ZTMSREE = 'N',"
					cQ += "     C5_ZTMSERR   = '"+SUBSTR(oWSPV:cDetailInt,1,cTamErro)+"'"
					cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SC5->(Recno())))
				Endif
			EndIF
		Else
			IF oWSPV:lErro500

				ConOut("Falha na integração -> " + SUBSTR(oWSPV:cDetailInt,1,cTamErro))

				IF SC5->C5_ZTMSREE $ "S N"
					cQuant := '1'
				ElseIF SC5->C5_ZTMSREE $ '123456789'
					cQuant := SOMA1(SC5->C5_ZTMSREE)
				Else
					cQuant := '1'
				EndIF

				cQ := "UPDATE "+ RetSqlName("SC5")+" "
				cQ += "SET   C5_ZTMSREE = '"+cQuant+"' "
				cQ += "     ,C5_ZTMSERR   = '"+SUBSTR(oWSPV:cDetailInt,1,cTamErro)+"'"
				cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SC5->(Recno())))

			EndIF
		Endif

		nRet := tcSqlExec(cQ)
		If nRet != 0
			ConOut("Problemas na gravação dos campos do pedido de venda, para registro de envio ao Tms-Transwide.")
		EndIf

	Endif
	conOut("************************************************************************************************************"+ CRLF)
	conOut('Final do MGFTMS02 - integração Protheus x TMS Transwide - Filial/pedido = ' +SC5->C5_FILIAL + SC5->C5_NUM + " - " + DTOC(dDATABASE) + " - " + TIME() + CRLF)
	conOut("************************************************* **********************************************************"+ CRLF)
	aEval(aArea,{|x| RestArea(x)})

	If _ltela .and. oWSPV:lOk
		msginfo("Pedido " + SC5->C5_NUM  + " enviado com sucesso ao TMS Transwide.")
	Elseif _ltela
		msgstop("Pedido " + SC5->C5_NUM  + " falhou o envio ao TMS Transwide. - " + SUBSTR(oWSPV:cDetailInt,1,cTamErro))
	Endif

Return(lRet)


// rotina chamada pelo ponto de entrada M410AGRV
User Function TMS01M41(ParamIxb)

	Local aArea := {GetArea()}
	Local aParam, _cC5TMSACA, _lTela

	If GetMv("MGF_TMS02A")
		Return
	EndIf

	// envia exclusao do PV para o Tms-Transwide
	If ParamIxb[1] == 3 // exclusao
		aParam		:= { SC5->C5_NUM, 3, SC5->( RECNO()) } 	// Informo sempre 3, pois PV é excluido quando ParamIxb[1] == 3
		_cC5TMSACA	:= "C"									// PV Cancelado
		_lTela		:= .F.
		U_TMSJASPV( aParam, _cC5TMSACA, _lTela, "" )			//aParam == {(cAliasTrb)->C5_NUM, IIf((cAliasTrb)->DELET=="*",3,1), (cAliasTrb)->SC5_RECNO}  )

		aEval(aArea,{|x| RestArea(x)})
	Endif
Return()


// rotina chamada pelo ponto de entrada M410STTS
User Function TMSM410STTS()
	Local aArea := {GetArea()}
	Local aParam, _cC5TMSACA, _lTela

	If GetMv("MGF_TMS02A")
		Return
	EndIf

	aParam		:= { SC5->C5_NUM, IIf( Deleted(),3,1), SC5->( RECNO()) }
	_cC5TMSACA	:= SC5->C5_ZTMSACA
	_lTela		:= .F.
	If SC5->( Deleted() )		// PV Cancelado
		_cC5TMSACA	:= "C"
	ElseIf SC5->C5_ZTMSACA == " "
		_cC5TMSACA	:= "I"
	ElseIf SC5->C5_ZTMSACA == "I" .OR. SC5->C5_ZTMSACA == "A"
		_cC5TMSACA	:= "A"
	Else
		_cC5TMSACA	:= "I"		// Se houver um caracter inesperado neste campo, envio como inclusão
	Endif
	U_TMSJASPV( aParam, _cC5TMSACA, _lTela, "" )	//aParam == {(cAliasTrb)->C5_NUM, IIf((cAliasTrb)->DELET=="*",3,1), (cAliasTrb)->SC5_RECNO}  )
	aEval(aArea,{|x| RestArea(x)})
Return()


// rotina para carregar os itens do pv usando query, para nao usar seek na tabela, pois eh necessario carregar itens deletados tb
// sc5 estah posicionado e pode estar deletado
Static Function ItensSC6(cStatus)
	Local aArea := {GetArea()}
	Local cAliasTrb := GetNextAlias()
	Local cQ := ""
	Local aRecno := {}

	cQ := "SELECT SC6.R_E_C_N_O_ SC6_RECNO "
	cQ += "FROM "+RetSqlName("SC6")+" SC6 "
	cQ += "WHERE "
	If cStatus != "3"
		cQ += "SC6.D_E_L_E_T_ <> '*' "
	Else
		cQ += "SC6.D_E_L_E_T_ = '*' "
	Endif
	cQ += "AND C6_FILIAL = '"+SC5->C5_FILIAL+"' "
	cQ += "AND C6_NUM = '"+SC5->C5_NUM+"' "

	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	(cAliasTrb)->(dbGoTop())

	While (cAliasTrb)->(!Eof())
		aAdd(aRecno,(cAliasTrb)->SC6_RECNO)
		(cAliasTrb)->(dbSkip())
	Enddo
	(cAliasTrb)->(dbCloseArea())
	aEval(aArea,{|x| RestArea(x)})
Return(aRecno)



/*/{Protheus.doc} TMSENVPV
//TODO Envia para o TMS via JASON o PV informado nos parametos. Se os parametros estiverem vazio, envia o registro SC58 sobre o qual estiver posicionado.
@author Geronimo Benedito Alves
@since 27/09/18
@version 1
@type function
@param aParam,     Array contendo : { (cAliasTrb)->C5_NUM,  IIf((cAliasTrb)->DELET=="*",3,1),  (cAliasTrb)->SC5_RECNO  }
@param _xC5TMSACA, caracter, m-> ou SC5->C5_ZTMSACA
@param _lTela,     boolean,  deve receber nil, para não abrir tela. Ou receber .T. para abrir uma tela para informar o pedido EXP, e a ação a ser enviada ao TMS (Inclusao, Alteração ou Cancelamento )
/*/

User Function TMSENVPV( aParam, _xC5TMSACA, _lTela )
	Local _cFiliaisProcessar	:= GetMv("MGF_TMSFIL") + "|" + GetMv("MGF_TMSFI2") + "|" + GetMv("MGF_TMSFI3")	// Parametros com as filiais que executam o processo de envio do pedido de vendas e exportação ao TMS
	Local _lContinua			:= .T.
	Local aArea					:= GetArea()
	Local aAreaSC5				:= SC5->(GetArea())
	Local _oC5_FILIAL
	Local _oC5_NUM
	Local _oC5TMSACA
	Local _oC5_PROVIS
	Local aButtons    			:= {{"WEB",{|| U_TMSSELPV("U_TMSENVPV",oDlg2)},OemtoAnsi("Transmitir Varios Pedidos ao TMS"),OemtoAnsi("Envia Varios Pedidos ao TMS")}}
	Private oDlg2				:= ""

	Private _nRecnoSC5, _cFilialPV

	if bloqTrfTms() > 60
		SC5->(RestArea(aAreaSC5))
		RestArea(aArea)
		Return()
	endif
	// Se receber _cC5TMSACA por parametro, utilizo o seu conteudo.
	If Valtype( aParam ) == "A"
		_cC5_FILIAL    	:= SC5->C5_FILIAL
		_cC5_NUM      	:= aParam[1]
		_cC5_PROVIS		:= SPACE(06)
		_cC5TMSACA  	:= Alltrim(Str(aParam[2]))
		_nRecnoSC5		:= aParam[3]
		SC5->( dbGoto(_nRecnoSC5) )
		_cFilialPV		:= SC5->C5_FILIAL
		_cC5TMSACA		:= _xC5TMSACA

	Else
		// Se não receber _cC5TMSACA por parametro, leio a base de dados e uso a logica abaixo para defini-lo  (devo estar posicionado no SC5.)
		_cC5_FILIAL    	:= SC5->C5_FILIAL
		_cC5_NUM		:= SC5->C5_NUM
		_cC5TMSACA		:= SC5->C5_ZTMSACA						//Deixo-a vazia, para defini-la conforme conteudo da base de dados
		_cC5_Provis		:= Space(06)
		_cFilialPV		:= SC5->C5_FILIAL
		_nRecnoSC5		:= SC5->( Recno() )

		If SC5->( Deleted() )		// PV Cancelado
			_cC5TMSACA	:= "C"
		ElseIf SC5->C5_ZTMSACA == " "
			_cC5TMSACA	:= "I"
		ElseIf SC5->C5_ZTMSACA == "I" .OR. SC5->C5_ZTMSACA == "A"
			_cC5TMSACA	:= "A"
		Else
			_cC5TMSACA	:= "?"		// Se houver um caracter inesperado neste campo, insiro o caracter "?", qe deve ser substituido por "I","A" ou "C"
		Endif

	Endif

	_lContinua	:= _cFilialPV $ _cFiliaisProcessar

	If _lContinua

		If ValType(_lTela) <> "L" .or. _lTela		// Se _lTela for .F., Empty(_lTela) retorna .F.
			_lTela	:= .T.
		Endif
		
		If _lTela

			If cFilAnt $GetMv("MGF_TMSGER")
				DEFINE 	MSDIALOG oDlg2 TITLE "Pedido de venda a ser enviado ao TMS MultiSoftware" From 0,0 to 350,400 of oMainWnd PIXEL
				@ 35,005 SAY   "Filial:"           							  SIZE 100,8                                         PIXEL OF oDlg2
				@ 35,100 MSGET _oC5_FILIAL            						  VAR _cC5_FILIAL WHEN .F.  PICTURE "@!" SIZE 55,8  F3 "SC5"  PIXEL OF oDlg2
				@ 55,005 SAY   "Pedido:"           							  SIZE 100,8                                         PIXEL OF oDlg2
				@ 55,100 MSGET _oC5_NUM            							  VAR _cC5_NUM     PICTURE "@!" SIZE 55,8  F3 "SC5"  PIXEL OF oDlg2		
				_oC5_NUM:Enable()

				ACTIVATE MSDIALOG oDlg2 CENTERED ON INIT EnchoiceBar( oDlg2, ;
					{|| IF(U_TMSVLPV(SC5->C5_FILIAL,_cC5_NUM,_cC5TMSACA,_lTela,_cC5_PROVIS), U_TMSPVJA({SC5->C5_NUM, IIf( SC5->(Deleted()),3,1), SC5->(Recno())},_cC5TMSACA,_lTela,"U_TMSENVPV",oDlg2) , .T. ) } ,;
					{|| oDlg2:End()}  , ,aButtons )
				return

			else

				DEFINE 	MSDIALOG oDlg2 TITLE "Pedido de venda a ser enviado ao TMS Transwide" From 0,0 to 350,400 of oMainWnd PIXEL
				@ 35,005 SAY   "Filial:"           							  SIZE 100,8                                         PIXEL OF oDlg2
				@ 35,100 MSGET _oC5_FILIAL            						  VAR _cC5_FILIAL WHEN .F.  PICTURE "@!" SIZE 55,8  F3 "SC5"  PIXEL OF oDlg2
				@ 55,005 SAY   "Pedido:"           							  SIZE 100,8                                         PIXEL OF oDlg2
				@ 55,100 MSGET _oC5_NUM            							  VAR _cC5_NUM     PICTURE "@!" SIZE 55,8  F3 "SC5"  PIXEL OF oDlg2
				@ 95,005 SAY   "Ação (I=Incluido, A=Alterado ou C=Cancelado)" SIZE 150,8                                         PIXEL OF oDlg2
				@ 95,135 MSGET _oC5TMSACA          							  VAR _cC5TMSACA   PICTURE "@!" SIZE 10,8 Valid U_TMSVLPV(  SC5->C5_FILIAL, _cC5_NUM,  _cC5TMSACA, _lTela )  PIXEL OF oDlg2

				_oC5_NUM:Enable()
				_oC5TMSACA:Enable()

				ACTIVATE MSDIALOG oDlg2 CENTERED ON INIT EnchoiceBar( oDlg2, ;
					{|| IF(U_TMSVLPV(SC5->C5_FILIAL,_cC5_NUM,_cC5TMSACA,_lTela,_cC5_PROVIS), U_TMSPVJA({SC5->C5_NUM, IIf( SC5->(Deleted()),3,1), SC5->(Recno())},_cC5TMSACA,_lTela,"U_TMSENVPV",oDlg2) , .T. ) } ,;
					{|| oDlg2:End()}  , ,aButtons )
			endif
		Else

			IF  U_TMSVLPV ( SC5->C5_FILIAL, _cC5_NUM,  _cC5TMSACA, _lTela,_cC5_PROVIS )
				U_TMSJASPV( {SC5->C5_NUM, IIf( SC5->(Deleted()),3,1), SC5->(Recno()) } ,_cC5TMSACA ,_lTela,"" )
			Endif

		Endif

	Endif

	SC5->(RestArea(aAreaSC5))
	RestArea(aArea)

Return


/*/
	{Protheus.doc} bloqTrfTms
	(Função para retornar um bloqueio quando for integrar EXP com mais de 60 dias)
	@type  Static Function
	@author Cláudio Alves
	@since 14/01/2020
	@return _nDias, numerico, qtde de dias
/*/
Static Function bloqTrfTms()
	local _cTitulo		:=	'Integração Protheus vs TMS'
	local _mensagem		:=	''
	local _nDias		:=	0
	local _cDias		:=	''
	local _dDias		:=	cTod('  /  /    ')
	local _x			:=	0
	local _aCampos		:=	{'SC5->C5_ZDTEMBA','SC5->C5_FECENT'}
	local _aNomes		:=	{'Dt. Emb. Prv','Dt. Entrega'}

	_mensagem := 'Os Campos abaixo estão mais de 60 dias' + _Chr
	for _x := 1 to len(_aCampos)
		_dDias := &(_aCampos[_x])
		if !empty(_dDias)
			if date() - _dDias > 60
				_nDias += date() - _dDias
				_cDias := AllTrim(str(date() - _dDias))
				_mensagem	+= _aNomes[_x] + ' com ' + _cDias + ' dias' + _Chr
			endif
		else
			_mensagem	+= _aNomes[_x] + ' está em branco ' + _Chr
			_nDias += 61
		endif
	next
	if _nDias > 60
		AVISO( _cTitulo, _mensagem, { 'Fechar' }, 1)
	endif

Return _nDias

/*/{Protheus.doc} TMSENVP2
//TODO Envia para o TMS via JASON os PV em massa informado no parameto.
@author Eduardo A Donatoea
@since 09/01/19
@version 1
@type function
@param aParam,     Array contendo : { (cAliasTrb)->C5_NUM,  IIf((cAliasTrb)->DELET=="*",3,1),  (cAliasTrb)->SC5_RECNO  }
@param _xC5TMSACA, caracter, m-> ou SC5->C5_ZTMSACA
@param _lTela,     boolean,  deve receber nil, para não abrir tela. Ou receber .T. para abrir uma tela para informar o pedido EXP, e a ação a ser enviada ao TMS (Inclusao, Alteração ou Cancelamento )
/*/

User Function TMSENVP2( aParam, _xC5TMSACA, _lTela )
	Local _cFiliaisProcessar	:= GetMv("MGF_TMSFIL") + "|" + GetMv("MGF_TMSFI2") + "|" + GetMv("MGF_TMSFI3")	// Parametros com as filiais que executam o processo de envio do pedido de vendas e exportação ao TMS
	Local _lContinua			:= .T.
	Local aArea					:= GetArea()
	Local aAreaSC5				:= SC5->(GetArea())
	Local _oC5_FILIAL
	Local _oC5_NUM
	Local _oC5TMSACA
	Local _oC5_PROVIS
	Local aButtons    			:= {}
	Local oDlg2					:= ""
	Local aParamBox	:= {}
	Local cPerg		:="TMSENVPV"
	Local aArea			:= GetArea()
	Local cAliasTrb		:= GetNextAlias()
	Local _nContaReg	:= 0
	Local _aParambox	:= {}
	Local _aRet			:= {}
	Local aParam, _cC5TMSACA, _lTela
	Local _cC5filial	:= xFilial("SC5")
	Local _aPed := {}
	Local _VerTela	:= SuperGetMv("MGF_TMSTEL",.F.,.F.) // Parametros que mostra tela pedido de vendas marcados para exportação ao TMS

	// log de erro
	Local cTxtLog := ""

	Local 	aLog		:= {}				//-- Log de Ocorrencias
	Local 	aLogTitle 	:= {}
	Local 	bMakeLog	:= { || NIL }
	Local	cMensagem	:= ""
	Local	cMsgLog		:= ""

	//novo metodo
	LOCAL oUsado,nUsado:=0
	LOCAL aSize := MsAdvSize()
	LOCAL aObjects := {}
	Local aCores   := {}
	Private lInverte  :=.F.
	Private nopca := 0
	// fim do novo metodo

	Private cMarca    := GetMark()
	Private aRotina   := {}
	Private aCampos   := {}
	Private cCadastro := "Seleção de Pedidos para Integração TMS"
	Private _cTMSSC5 := "SC5_"+__cUserId
	Private _lExec := .F.
	Private _nRecnoSC5, _cFilialPV

	// Se receber _cC5TMSACA por parametro, utilizo o seu conteudo.
	If Valtype( aParam ) == "A"
		_cC5_FILIAL    	:= SC5->C5_FILIAL
		_cC5_NUM      	:= aParam[1]
		_cC5TMSACA  	:= Alltrim(Str(aParam[2]))
		_nRecnoSC5		:= aParam[3]
		SC5->( dbGoto(_nRecnoSC5) )
		_cFilialPV		:= SC5->C5_FILIAL
		_cC5TMSACA		:= _xC5TMSACA

	Else
		// Se não receber _cC5TMSACA por parametro, leio a base de dados e uso a logica abaixo para defini-lo  (devo estar posicionado no SC5.)
		_cC5_FILIAL    	:= SC5->C5_FILIAL
		_cC5_NUM		:= SC5->C5_NUM
		_cC5TMSACA		:= SC5->C5_ZTMSACA						//Deixo-a vazia, para defini-la conforme conteudo da base de dados
		_cFilialPV		:= SC5->C5_FILIAL
		_nRecnoSC5		:= SC5->( Recno() )

		If SC5->( Deleted() )		// PV Cancelado
			_cC5TMSACA	:= "C"
		ElseIf SC5->C5_ZTMSACA == " "
			_cC5TMSACA	:= "I"
		ElseIf SC5->C5_ZTMSACA == "I" .OR. SC5->C5_ZTMSACA == "A"
			_cC5TMSACA	:= "A"
		Else
			_cC5TMSACA	:= "?"		// Se houver um caracter inesperado neste campo, insiro o caracter "?", qe deve ser substituido por "I","A" ou "C"
		Endif

	Endif

	_lContinua	:= _cFilialPV $ _cFiliaisProcessar

	cTxtLog += "Integração de Pedido de Vendas para o TMS "

	If _lContinua

		cTxtLog += CRLF+" ## Filial "+Alltrim(_cFilialPV)+' pertence ao grupo de Filiais a processar.'+CRLF

		If ValType(_lTela) <> "L" .or. _lTela		// Se _lTela for .F., Empty(_lTela) retorna .F.
			_lTela	:= .T.
		Endif

		cTxtLog += If(_lTela,"[via Client]","[via Schedule]")+CRLF

		If _lTela
			//	11 - MultiGet (Memo)
			//  [2] : Descrição
			//  [3] : Inicializador padrao
			//  [4] : String contendo a validação
			//  [5] : String contendo a validação When
			//  [6] : Flag .T./.F. Parâmetro Obrigatório ?

			aAdd(_aParambox,{9,"Cole os pedidos aqui :    "						,200,10													,.T.})
			aAdd(_aParambox,{11,"->"	,"","","",.F.})

			lRet := ParamBox(_aParambox, "Pedidos de Vendas à exportar ao TMS", @_aRet	,,	,,	,,	,,.T.,.T. )	// Executa funcao PARAMBOX p/ obter os parametros da query que gerará exportará os Pedidos de vendas

			If lRet

				If !Empty(_aRet[2])
					If substr(_aRet[2],len(_aRet[2])-1,2) == chr(13)+chr(10)
						_aRet[2] := FwCutOff(formatIn(substr(_aRet[2],1,len(_aRet[2])-2),chr(13)+chr(10)))
					Else
						_aRet[2] := FwCutOff(formatIn(_aRet[2],chr(13)+chr(10)))
					EndIf

					//Cria um array para termos os pedidos que foram copiados do excel
					_aPed := Strtokarr2( _aRet[2], chr(13)+chr(10))
				EndIf

				_cQuery := " SELECT C5_NUM ,SC5.R_E_C_N_O_ SC5_RECNO , C5_ZBLQRGA ,C5_ZTIPPED ,C5_ZTMSACA ,SC5.D_E_L_E_T_ DELET "
				_cQuery += " FROM "+RetSqlName("SC5")+" SC5 "
				_cQuery += " WHERE "
				_cQuery += "    C5_FILIAL = '" +xFilial("SC5") +"' "
				_cQuery += " AND (C5_NOTA =' '  ) "			//_cQuery += " AND (C5_NOTA =' ' OR  C5_NOTA  like 'XXXX%') "
				If !Empty(_aRet[2])
					_cQuery += " AND C5_NUM IN "+_aRet[2]+""
				EndIf
				_cQuery += " ORDER BY C5_NUM "

				_cQuery := ChangeQuery(_cQuery)
				dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQuery),cAliasTrb,.T.,.T.)
				(cAliasTrb)->(dbGoTop())
				While (cAliasTrb)->(!Eof())
					_nContaReg++
					If !Empty(_aRet[2])
						AADD(_aPed,(cAliasTrb)->C5_NUM)
					EndIf
					(cAliasTrb)->(dbSkip())
				Enddo

				If _nContaReg == 0
					cTxtLog += CRLF+"Não foram encontrados pedido para integração."+CRLF
					MsgStop("Não foram encontrados Pedidos que atendam os parâmetros acima na filial " + xfilial("SC5") )
				Else
					If MsgYesNo("Confirma os dados de " + AllTrim(str(_nContaReg)) + " pedidos, encontrados na filial " + xfilial("SC5") + ", ao TMS ? ","Transmissão de Pedidos ao TMS!!")

						// montando tela com os pedidos selecionados
						_aStru := {}
						aTam   := {}
						aadd(_aStru,{"TA_MARK"     , "C", 02, 0}) //PARA O MARKBROWSE
						aTam := TamSX3("C5_NUM")
						aadd(_aStru,{"TA_PEDIDO"  , aTam[3],aTam[1],aTam[2]}) //NUMERO PEDIDO
						aTam := TamSX3("C5_ZOBS")
						aadd(_aStru,{"TA_OBS", aTam[3],aTam[1],aTam[2]}) //OBSERVACAO
						aadd(_aStru,{"TA_RECNO"  , "N"    ,     10,      0}) //Recno
						aadd(_aStru,{"TA_DELET"  , "C"    ,     1,      0}) //Delete
						aTam := TamSX3("C5_ZTMSACA")
						aadd(_aStru,{"TA_TMSACAO" , aTam[3],aTam[1],aTam[2]}) //TMS ACAO

						_cArq1 := CriaTrab(_aStru, .T.)
						dbUseArea(.T., ,_cArq1, _cTMSSC5, .F., .F.)

						DbSelectArea(cAliasTrb)
						(cAliasTrb)->(dbGoTop())
						While !(cAliasTrb)->(EOF())
							Reclock(_cTMSSC5,.T.)
							(_cTMSSC5)->TA_PEDIDO   := (cAliasTrb)->C5_NUM

							(_cTMSSC5)->TA_MARK := cMarca

							// colocar as validações que estão no sistema
							If  ASCAN(_aPed, { |x| alltrim(UPPER(x)) == (cAliasTrb)->C5_NUM }) == 0
								(_cTMSSC5)->TA_OBS 	:= "Pedido não existente no Protheus"
								(_cTMSSC5)->TA_MARK := SPACE(2)
							EndIf

							If (cAliasTrb)->C5_ZBLQRGA == 'B'
								(_cTMSSC5)->TA_OBS 	:= "Pedido encontra-se com status Inativo"
								(_cTMSSC5)->TA_MARK := SPACE(2)
							EndIf

							If !U_TMS_SZJ((cAliasTrb)->C5_ZTIPPED)		// Verifica se tipo de pedido esta cadastrado para transmissão ao TMS na tabela SZJ
								(_cTMSSC5)->TA_OBS 	:= "Tipo de Pedido não parametrizado para envio ao TMS"
								(_cTMSSC5)->TA_MARK := SPACE(2)
							EndIf

							(_cTMSSC5)->TA_RECNO   	:= (cAliasTrb)->SC5_RECNO

							If (cAliasTrb)->DELET = "*"		// PV Cancelado
								(_cTMSSC5)->TA_DELET   	:= (cAliasTrb)->DELET
								(_cTMSSC5)->TA_TMSACAO 	:= "C"
								(_cTMSSC5)->TA_OBS 	:= "Pedido encontra-se cancelado, deletado"
							ElseIf (cAliasTrb)->C5_ZTMSACA == " "
								(_cTMSSC5)->TA_TMSACAO 	:= "I"
								(_cTMSSC5)->TA_OBS 	:= "Enviado Pedido como (I) para o TMS."
							ElseIf (cAliasTrb)->C5_ZTMSACA == "I" .OR. (cAliasTrb)->C5_ZTMSACA == "A"
								(_cTMSSC5)->TA_TMSACAO 	:= "A"
								(_cTMSSC5)->TA_OBS 	:= "Enviado Pedido como (A) para o TMS."
							Else
								(_cTMSSC5)->TA_TMSACAO 	:= "I"
								(_cTMSSC5)->TA_OBS 	:= "Enviado Pedido como (I) para o TMS."
							Endif

							(_cTMSSC5)->(MsUnLock())

							DbSelectArea(cAliasTrb)
							(cAliasTrb)->(DbSkip())
						EndDo

						(cAliasTrb)->(dbCloseArea())

						If Select(_cTMSSC5) > 0

							If _VerTela
								aRotina := {{"Confirma		 ", "U_EXECRCM", 0, 4},;
									{"Marcar Todos	 ", "U_MARKCM ", 0, 4},;
									{"Desmarcar Todos", "U_DESMACM", 0, 4},;
									{"Inverter Todos ", "U_MARKACM", 0, 4}}

								AADD(aCampos,{"TA_MARK"   	, "", " "        	, ""}) //PARA O MARKBROWSE
								AADD(aCampos,{"TA_PEDIDO"  	, "", "Num. Pedido" , ""}) //Pedido
								AADD(aCampos,{"TA_OBS"		, "", "Observação" 	, ""}) //Observação
								AADD(aCampos,{"TA_RECNO"	, "", "ID Pedido"	, ""}) //Recno SC5
								AADD(aCampos,{"TA_DELET"	, "", "Cancelado"	, ""}) //Deletado
								AADD(aCampos,{"TA_TMSACAO"	, "", "Ação TMS"	, ""}) //Ação TMS

								DbSelectArea(_cTMSSC5)
								dbGoTop()
								MarkBrow(_cTMSSC5,"TA_MARK",                ,aCampos,lInverte,cMarca,'U_MARKACM()'  ,,,,'U_MARK()'  ,{||U_DESMACM()})
							Else
								_lExec := .T.
							EndIf

						Else
							_lExec := .F.
						EndIf

						If _lExec
							dbSelectArea(_cTMSSC5)
							(_cTMSSC5)->(dbGoTop())
							While !Eof()
								If !Empty((_cTMSSC5)->TA_MARK)
									_cQuery := "SELECT C5_NUM ,SC5.R_E_C_N_O_ SC5_RECNO ,C5_ZTMSACA ,SC5.D_E_L_E_T_ DELET "
									aParam		:= { (_cTMSSC5)->TA_PEDIDO, IIf((_cTMSSC5)->TA_DELET=="*",3,1), (_cTMSSC5)->TA_RECNO }
									_cC5TMSACA	:= (_cTMSSC5)->TA_TMSACAO
									_lTela		:= .F.

									MsgRun("Aguarde, Transmitindo ao TMS o Pedido : " + (_cTMSSC5)->TA_PEDIDO 	,,{ || U_TMSJASPV( aParam, _cC5TMSACA, _lTela, "U_TMSENVP2" ) })		//aParam == {(cAliasTrb)->C5_NUM, IIf((cAliasTrb)->DELET=="*",3,1), (cAliasTrb)->SC5_RECNO}  )

									cTxtLog += 'Pedido No.'+(_cTMSSC5)->TA_PEDIDO+' - Enviado Pedido como ('+_cC5TMSACA+') para o TMS.'+ CRLF
								Else
									cTxtLog += 'Pedido No.'+(_cTMSSC5)->TA_PEDIDO+' - '+Alltrim((_cTMSSC5)->TA_OBS) + CRLF
								EndIf
								dbSelectArea(_cTMSSC5)
								(_cTMSSC5)->(DbSkip())
							EndDo
						EndIf
						(_cTMSSC5)->(dbCloseArea())

						// Mostra Log
						fShowLog(cTxtLog)
						// apaga a tabela temporário
						MsErase(_cArq1+GetDBExtension(),,"DBFCDX")
					EndIf
				EndIf
			EndIf
		Else

			IF  U_TMSVLPV ( SC5->C5_FILIAL, _cC5_NUM,  _cC5TMSACA, _lTela,_cC5_PROVIS )
				U_TMSJASPV( {SC5->C5_NUM, IIf( SC5->(Deleted()),3,1), SC5->(Recno()) } ,_cC5TMSACA ,_lTela )
			Endif

		Endif

	Else

		cTxtLog += CRLF+" ## Filial "+Alltrim(_cFilialPV)+' nao pertence ao grupo de Filiais a processar.'+CRLF

	EndIf

	SC5->(RestArea(aAreaSC5))
	RestArea(aArea)

Return

//{Protheus.doc} U_TMSPVJA
// 	chama a rotina que envia o pedido de venda e depois fecha a ODLG
//@author Geronimo Benedito Alves
//@since 27/09/18

User Function TMSPVJA ( aParam, _xC5TMSACA, _lTela ,_cFunc, oDlg2  )
	U_TMSJASPV( aParam, _xC5TMSACA, _lTela, _cFunc)
	oDlg2:End()
Return

/*/ {Protheus.doc} TMSVLPV
//TODO Valida o PEDIDO e a ação informada.  Se for exclusão, o registro deve estar excluido. Caso contrario, NÃO deve estar excluido
	@author Geronimo Benedito Alves
	@since 27/09/18
	@version 1
	@type function
	@param _cFilialPV,   caracter, m-> ou SC5->C5_FILIAL
	@param _cC5_NUM,   caracter, m-> ou SC5->C5_NUM
	@param _cC5TMSACA, caracter, m-> ou SC5->C5_ZTMSACA
	@param _lTela,     boolean,  Se .T. Abre uma tela para informar o pedido EXP, e a ação a ser enviada ao TMS (Inclusao, alteração ou exclusão)
/*/

User Function TMSVLPV( _cFilialPV, _cC5_NUM, _cC5TMSACA, _lTela,_cC5_PROVIS )		// SC5->C5_FILIAL, _cC5_NUM,  _cC5TMSACA, _lTela

	Local _lRet		:= .T.
	Local cAliasTr2 := GetNextAlias()

	If cFilAnt $GetMv("MGF_TMSGER")
	
		IF IsInCallStack("A410COPIA")  // copia de pedido
			If _ltela 
				oDlg2:End()
			ENDIF
			Return
		EndIf

		If SC5->C5_ZTIPPED = "EX"
			MSGINFO("O pedido "+SC5->C5_NUM+" é de exportação. Não será enviado ao TMS MultiSoftware.","Pedido Inválido")
			RETURN
		ENDIF

		if IsInCallStack("A410ALTERA") //ALTERA 
			if ! Empty(SC5->C5_ZTMSID)
				_xC5TMSACA := 'A'	
			else
				Return
			endif
		endif
		Processa({|| U_MNUFATBO()},"Processando","Aguarde........Enviando pedido ao TMS MultiSoftWare.",.F.)
		If _ltela 
			oDlg2:End()
		ENDIF
		Return
	endif

	IF _cC5TMSACA $ "IAC"

		cQ := "SELECT SC5.R_E_C_N_O_ SC5_RECNO,C5_FILIAL,C5_NUM,C5_ZTMSACA, SC5.D_E_L_E_T_ DELET "
		cQ += "FROM "+RetSqlName("SC5")+" SC5 "
		cQ += "WHERE "
		cQ += "C5_FILIAL = '"+_cFilialPV+"'  AND "
		cQ += "C5_NUM = '"+_cC5_NUM+"' "
		If _cC5TMSACA == "C"
			cQ += " AND SC5.D_E_L_E_T_ = '*' " // OBS: processa linhas deletadas
		Else
			cQ += " AND SC5.D_E_L_E_T_ = ' ' " // OBS: processa as linhas NAO deletadas
		Endif

		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTr2,.T.,.T.)
		(cAliasTr2)->(dbGoTop())

		If (cAliasTr2)->(Eof())
			If _lTela
				If _cC5TMSACA == "C"
					MsgStop("Não foi excluido a filial / pedido :  "+ _cFilialPV +" / " + _cC5_NUM , "Aviso")
				Else
					MsgStop("Não foi encontrado na filial "+ _cFilialPV +" o Pedido de venda : " + _cC5_NUM , "Aviso")
				Endif
			Endif
			_lRet	:= .F.
		Else
			SC5->( DbGoto( (cAliasTr2)->SC5_RECNO ) )		// Posiciono no pedido digitado. O usuario pode altera o Nº, e preciso reposicionar sobre o novo recno
		Endif

		(cAliasTr2)->(dbCloseArea())

	Else
		If _lTela
			MsgStop("O campo ação foi preenchido com " + _cC5TMSACA + ", que é invalido. O conteudo valido é I, A ou C. Inclusão, Alteração ou Cancelameno. não será enviada ao TMS TransWide o Pedido : "  + _cC5_NUM, "Aviso")
		Endif
		_lRet	:= .F.

	Endif

Return _lRet


/*/{Protheus.doc} PesoBruPed
//TODO Retorna o peso bruto do pedido de venda
@author Geronimo Benedito Alves
@since 11/10/18
@version 1
@type function
@param _cChave,   caracter,    //SC5->C5_FILIAL + SC5->C5_NUM
/*/
Static Function PesoBruPed( _cC5FILIAL,  _cC5NUM )		//SC5->C5_FILIAL + SC5->C5_NUM
	Local aArea		:= {GetArea()}
	Local cAliasTrb := GetNextAlias()

	_nRet	:= 0

	If SC5->C5_PBRUTO <> 0
		_nRet	:= SC5->C5_PBRUTO
	Else

		_cQuery := " SELECT SUM(SC6.C6_QTDVEN) PESO_TOTAL  "
		_cQuery += " FROM "       + RetSqlName("SC6") + " SC6 "
		_cQuery += " WHERE  C6_FILIAL = '"+_cC5FILIAL+"' "
		_cQuery += " AND C6_NUM = '" +_cC5NUM+ "' "
		_cQuery += " AND SC6.D_E_L_E_T_ <> '*'   "
		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQuery),cAliasTrb,.T.,.T.)
		(cAliasTrb)->(dbGoTop())
		While (cAliasTrb)->(!Eof())
			_nRet += (cAliasTrb)->PESO_TOTAL
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())
	ENDIF

	aEval(aArea,{|x| RestArea(x)})
Return _nRet


/*/{Protheus.doc} TMS_SZJ
//TODO Retorna .T. se o tipo de pedido permite o seu envio ao TMS
@author Geronimo Benedito Alves
@since 11/10/18
@version 1
@type function
@param _cChave,   caracter,    //SC5->C5_FILIAL + SC5->C5_NUM
/*/

User Function TMS_SZJ( _C5ZTIPPED )
	Local aArea		:= {GetArea()}
	Local cAliasTrb := GetNextAlias()
	Local _lRet	:= .T.

	_cQuery := " SELECT ZJ_COD  "
	_cQuery += " FROM "       + RetSqlName("SZJ") + " SZJ "
	_cQuery += " WHERE  ZJ_COD = '"+_C5ZTIPPED+"' "
	_cQuery += " AND ZJ_TMS = 'S' "
	_cQuery += " AND SZJ.D_E_L_E_T_ = ' '   "
	_cQuery := ChangeQuery(_cQuery)

	dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQuery),cAliasTrb,.T.,.T.)
	(cAliasTrb)->(dbGoTop())
	If Eof()
		_lRet	:= .F.
	Endif
	(cAliasTrb)->(dbCloseArea())

	aEval(aArea,{|x| RestArea(x)})
Return _lRet


/*
=====================================================================================
Programa............: TMSBlSZT
Autor...............: Geronimo Benedito Alves
Data................: 11/10/2018
Descrição / Objetivo: Faz Laco para as regras do SZT que atuam sobre o TMS e executa a Regra para o pedido verificando se tem bloqueio
Doc. Origem.........: Integracao Protheus x TMS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Faz a Verificação de bloqueio de regras para enviar ou não o pedido de venda para a integração TMS.
=====================================================================================
*/
User Function TMSBlSZT(cPedido)

	Local aArea 	:= GetArea()
	Local aAreaSZT 	:= SZT->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSC6	:= SC6->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local bFunc		:= nil
	Local lBlq		:= .F.

	//Default cCodRga := ''

	dbSelectArea('SZT')
	SZT->(dbSetOrder(1))//ZT_FILIAL+ZT_CODIGO

	DbSelectArea('SC5')
	SC5->(dbSetOrder(1))//C5_FILIAL+C5_NUM

	DbSelectArea('SC6')
	SC6->(dbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO

	dbSelectArea('SZT')
	SZT->(dbSeek(xFilial('SZT') )) //Posiciona na Regra inicial da filial/empresa
	If SC5->(DbSeek(xFilial('SC5') + cPedido)) .and. SA1->(DbSeek(xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI)))//Posiciona no Pedido e no Cliente
		While !SZT->(eof()) .and. SZT->ZT_FILIAL == xFilial('SZT')
			If SZT->ZT_MSBLQL <> '1' .and. SZT->ZT_TMS == "S" 	//Verifica se Regra não esta Bloqueada, e se atua sobre o tms
				If SZT->ZT_TIPO == '1' .or. SZT->ZT_TIPO == '2' //Pedido de Venda ou Cliente
					bFunc := &('{||' + Alltrim(SZT->ZT_FUNCAO) + '}')
					lBlq := Eval(bFunc)							//ExecBlock(SZT->ZT_FUNCAO,.F.,.F.)
					If ValType(lBlq) == 'L'
						If lBlq										// Se voltar .T., tem bloqueio
							Exit                                    // Entao abandono o loop
						EndIf
					Endif
				EndIf
			Endif
			SZT->( DbSkip() )
		Enddo
	EndIf

	RestArea(aAreaSB1)
	RestArea(aAreaSC6)
	RestArea(aAreaSA1)
	RestArea(aAreaSC5)
	RestArea(aAreaSZT)
	RestArea(aArea)

Return lBlq



//---------------------------------------------------------------------
// Seleciona Bloqueio do PV, que afeta o TMS, lendo a tabela SZV
//---------------------------------------------------------------------
static function getSZV( _cC5_FILIAL, _cC5_NUM )
	local cQrySZV	:= ""

	cQrySZV += " SELECT C5_FILIAL ,C5_NUM, ZT_TIPO ,ZT_DESCRI ,ZV_CODRGA  ,'00' C6_ITEM "		+ CRLF
	cQrySZV += " FROM "			+ retSQLName("SC5") + " SC5"									+ CRLF
	cQrySZV += " INNER JOIN "	+ retSQLName("SZV") + " SZV"									+ CRLF
	cQrySZV += " ON"																			+ CRLF
	cQrySZV += " 		SZV.ZV_ITEMPED  =   '01'"												+ CRLF // SOMENTE BLOQUEIOS DO PEDIDO
	cQrySZV += " 	AND SZV.ZV_PEDIDO	=	SC5.C5_NUM"											+ CRLF
	cQrySZV += " 	AND	SZV.ZV_FILIAL	=	'" + xFilial("SZV") + "'"							+ CRLF
	cQrySZV += " 	AND	SZV.D_E_L_E_T_	<>	'*'"												+ CRLF
	cQrySZV += " INNER JOIN "	+ retSQLName("SZT") + " SZT"									+ CRLF
	cQrySZV += " ON"																			+ CRLF
	cQrySZV += " 		SZV.ZV_CODRGA	=	SZT.ZT_CODIGO"										+ CRLF
	cQrySZV += " 	AND	SZT.ZT_FILIAL	=	'" + xFilial("SZT") + "'"							+ CRLF
	cQrySZV += " 	AND	SZT.ZT_TMS	    =	'S' "												+ CRLF
	cQrySZV += " 	AND	SZT.D_E_L_E_T_	<>	'*'"												+ CRLF
	cQrySZV += " WHERE"																			+ CRLF
	cQrySZV += " 		SZV.ZV_CODAPR	=	' '"												+ CRLF // BLOQUEIOS AINDA NAO LIBERADOS
	cQrySZV += " 	AND	SC5.C5_FILIAL	=	'" + _cC5_FILIAL + "'"								+ CRLF
	cQrySZV += " 	AND	SC5.C5_NUM		=	'" + _cC5_NUM + "'"									+ CRLF
	cQrySZV += " 	AND	SC5.D_E_L_E_T_	<>	'*'"												+ CRLF
	cQrySZV += " UNION ALL"																		+ CRLF
	cQrySZV += " SELECT C5_FILIAL ,C5_NUM, ZT_TIPO ,ZT_DESCRI ,ZV_CODRGA , C6_ITEM "			+ CRLF
	cQrySZV += " FROM "			+ retSQLName("SC5") + " SC5"									+ CRLF
	cQrySZV += " INNER JOIN " 	+ retSQLName("SC6") + " SC6"									+ CRLF
	cQrySZV += " ON"																			+ CRLF
	cQrySZV += " 		SC6.C6_NUM		=	SC5.C5_NUM"											+ CRLF
	cQrySZV += " 	AND	SC6.C6_FILIAL	=	SC5.C5_FILIAL"										+ CRLF
	cQrySZV += " 	AND	SC6.D_E_L_E_T_	<>	'*'"												+ CRLF
	cQrySZV += " INNER JOIN "	+ retSQLName("SZV") + " SZV"									+ CRLF
	cQrySZV += " ON"																			+ CRLF
	cQrySZV += " 		SZV.ZV_ITEMPED  =   SC6.C6_ITEM "										+ CRLF // SOMENTE BLOQUEIOS DOS ITENS
	cQrySZV += " 	AND SZV.ZV_PEDIDO	=   SC5.C5_NUM "										+ CRLF
	cQrySZV += " 	AND	SZV.ZV_FILIAL	=	'" + xFilial("SZV") + "'"							+ CRLF
	cQrySZV += " 	AND	SZV.D_E_L_E_T_	<>	'*'"												+ CRLF
	cQrySZV += " INNER JOIN "	+ retSQLName("SZT") + " SZT"									+ CRLF
	cQrySZV += " ON"																			+ CRLF
	cQrySZV += " 		SZV.ZV_CODRGA	=	SZT.ZT_CODIGO"										+ CRLF
	cQrySZV += " 	AND	SZT.ZT_FILIAL	=	'" + xFilial("SZT") + "'"							+ CRLF
	cQrySZV += " 	AND	SZT.ZT_TMS	    =	'S' "												+ CRLF
	cQrySZV += " 	AND	SZT.D_E_L_E_T_	<>	'*'"												+ CRLF
	cQrySZV += " WHERE"																			+ CRLF
	cQrySZV += " 		SZV.ZV_CODAPR	=	' '"												+ CRLF // BLOQUEIOS AINDA NAO LIBERADOS
	cQrySZV += " 	AND	SC5.C5_FILIAL	=	'" + xFilial("SC5") + "'"							+ CRLF
	cQrySZV += " 	AND	SC5.C5_NUM		=	'" + _cC5_NUM + "'"									+ CRLF
	cQrySZV += " 	AND	SC5.D_E_L_E_T_	<>	'*'"												+ CRLF
	cQrySZV += " ORDER BY C5_FILIAL, C5_NUM, ZT_TIPO, C6_ITEM, ZV_CODRGA"						+ CRLF

	TcQuery cQrySZV New Alias (cQrySZVRet)
return


/*/{Protheus.doc} TMSSELPV
//Seleciona Pedidos de Venda conforme os parametros recebidos, e os transmite ao TMS
@author Geronimo Benedito Alves
@since 13/10/18
@version 1
@type function
/*/

User function TMSSELPV(_cFunc,oDlg2)
	Local aArea			:= GetArea()
	Local cAliasTrb		:= GetNextAlias()
	Local _nContaReg	:= 0
	Local _aParambox	:= {}
	Local _aRet			:= {}
	Local aParam, _cC5TMSACA, _lTela
	Local _cC5filial	:= xFilial("SC5")

	aAdd(_aParambox,{9,"Filial processada :    " + _cC5filial						,200,10													,.T.})
	aAdd(_aParambox,{1,"Pedido inicial a transmitir",Space(tamSx3("C5_NUM")[1])		,""	,""												 	,""	,""		,050,.F.})
	aAdd(_aParambox,{1,"Pedido final   a transmitir",Space(tamSx3("C5_NUM")[1])		,""	,"U_VLFIMMAI(MV_PAR02,MV_PAR03,'Pedido de Venda')"	,""	,""		,050,.F.})
	aAdd(_aParambox,{1,"Dt emissão pedido inicial"	,Ctod("")						,""	,"" 										 		,""	,""		,050,.F.})
	aAdd(_aParambox,{1,"Dt emissão pedido final"	,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR04, MV_PAR05, 'Data de Emissão')",""	,""		,050,.F.})
	aAdd(_aParambox,{3,"Seleciona os pedidos não excluidos ou só os excluidos?"	,Iif(Set(_SET_DELETED),1,2), {"Não excluidos","excluidos" }, 100, "",.F.})
	aAdd(_aParambox,{11,"Cole os pedidos aqui :   "		,""	,""												 	,""	,""		,050,.F.})

	lRet := ParamBox(_aParambox, "Pedidos de Vendas à exportar ao TMS Transwide", @_aRet	,,	,,	,,	,,.T.,.T. )	// Executa funcao PARAMBOX p/ obter os parametros da query que gerará exportará os Pedidos de vendas

	If lRet
		_aRet[4] := Dtos(_aRet[4])
		_aRet[5] := Dtos(_aRet[5])

		_cQuery := " SELECT C5_NUM ,SC5.R_E_C_N_O_ SC5_RECNO ,C5_ZTMSACA ,SC5.D_E_L_E_T_ DELET "
		_cQuery += " FROM "+RetSqlName("SC5")+" SC5 "
		_cQuery += " WHERE "
		_cQuery += "    C5_FILIAL = '" +xFilial("SC5") +"' "
		_cQuery += " AND C5_NUM BETWEEN '"     + _aRet[2] + "' AND '" + _aRet[3] + "' "  +CRLF
		_cQuery += " AND C5_EMISSAO BETWEEN '" + _aRet[4] + "' AND '" + _aRet[5] + "' "  +CRLF
		_cQuery += " AND C5_ZTIPPED in ( Select ZJ_COD from "+RetSqlName("SZJ")+" SZJ Where SZJ.D_E_L_E_T_	=	' ' AND ( ZJ_TMS='S' )) "
		_cQuery += " AND (C5_NOTA =' '  ) "			//_cQuery += " AND (C5_NOTA =' ' OR  C5_NOTA  like 'XXXX%') "
		_cQuery += Iif(_aRet[6] == 1, " AND SC5.D_E_L_E_T_  = ' ' " , " AND SC5.D_E_L_E_T_  = '*' " ) 	// OBS: Conforme o processa só a linhas deletadas ou só as não deletadas
		_cQuery += " ORDER BY C5_NUM "
	
		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQuery),cAliasTrb,.T.,.T.)
		(cAliasTrb)->(dbGoTop())
		While (cAliasTrb)->(!Eof())
			_nContaReg++
			(cAliasTrb)->(dbSkip())
		Enddo

		If _nContaReg == 0
			MsgStop("Não foram encontrados Pedidos que atendam os parâmetros acima na filial " + xfilial("SC5") )
		Else
			If MsgYesNo("Confirma a Transmissão de " + AllTrim(str(_nContaReg)) + " pedidos, encontrados na filial " + xfilial("SC5") + ", ao TMS Transwide ? ","Transmissão de Pedidos ao TMS!!")
				(cAliasTrb)->(dbGoTop())
				While (cAliasTrb)->(!Eof())
					_cQuery := "SELECT C5_NUM ,SC5.R_E_C_N_O_ SC5_RECNO ,C5_ZTMSACA ,SC5.D_E_L_E_T_ DELET "

					aParam		:= { (cAliasTrb)->C5_NUM, IIf((cAliasTrb)->DELET=="*",3,1), (cAliasTrb)->SC5_RECNO }
					_cC5TMSACA	:= (cAliasTrb)->C5_ZTMSACA
					_lTela		:= .F.
					If (cAliasTrb)->DELET="*"		// PV Cancelado
						_cC5TMSACA	:= "C"
					ElseIf (cAliasTrb)->C5_ZTMSACA == " "
						_cC5TMSACA	:= "I"
					ElseIf (cAliasTrb)->C5_ZTMSACA == "I" .OR. (cAliasTrb)->C5_ZTMSACA == "A"
						_cC5TMSACA	:= "A"
					Else
						_cC5TMSACA	:= "I"		// Se houver um caracter inesperado neste campo, envio como inclusão
					Endif
					MsgRun("Aguarde, Transmitindo ao TMS o Pedido : " + C5_NUM 	,,{ || U_TMSJASPV( aParam, _cC5TMSACA, _lTela,_cFunc ) })		//aParam == {(cAliasTrb)->C5_NUM, IIf((cAliasTrb)->DELET=="*",3,1), (cAliasTrb)->SC5_RECNO}  )

					(cAliasTrb)->(dbSkip())
				Enddo
			Endif
		Endif

		(cAliasTrb)->(dbCloseArea())

		// Se o usuario informou os parametros de selecao do processamento, depois do processamento, fecho todas as janelas e volto ao browse
		If Valtype(oDlg2) == "O"
			oDlg2:End()					// Fecho a tela anterior, de digitação dos parâmetros de envio de um OV por vez
		Endif

	Endif

	RestArea(aArea)
Return


// funcao de filtragem dos PV´s que serao enviados ao Tms-Transwide
// serah chamada por job
// ******************************
//OBS: nao deixar nenhum reclock neste fonte e nem nos fontes chamados por este, pois esta rotina eh executada em job, e caso algum registro do cadastro
//esteja em alteracao pelo usuario, o job vai parar aguardando o final da alteracao do usuario, bloqueando toda a execucao do job, o qual eh executado
// para este e demais cadastros e movimentos.
// ******************************
User Function TMS02FiP(aEmpSel, _lTela )

	Local cQ 		:= ""
	Local cEmpSav	:= cEmpAnt
	Local cFilSav 	:= cFilAnt
	Local cAliasTrb := GetNextAlias()
	Local lRet 		:= .F.
	Local nRet 		:= 0
	Local cIDTms 	:= GetMV("MGF_TMSIDV",.F.,) // 0000000001
	Local cTMSFIL 	:= GetMV("MGF_TMSFIL",.F.,)  + "|" + GetMv("MGF_TMSFI2") // "010003,010022" - Promissão e Promissão Curtume - Filiais que processam o envio do PV ao cliente
	Local cEmpSel   := "'x'"
	Local nI		:= 0
	Local nVezes    := GetMv("MGF_TMSVEZ",,5)
	Local cVezes    := ''

	cQ := "SELECT SC5.R_E_C_N_O_ SC5_RECNO,C5_FILIAL,C5_NUM,C5_ZTMSINT, C5_ZTMSACA, SC5.D_E_L_E_T_ DELET "
	cQ += "FROM "+RetSqlName("SC5")+" SC5 "
	cQ += "WHERE C5_FILIAL = '010003' AND C5_NUM = '385359' AND C5_TIPO <> 'B' AND D_E_L_E_T_ = ' ' "
	cQ += "ORDER BY C5_FILIAL,C5_NUM "

	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	(cAliasTrb)->(dbGoTop())

	While (cAliasTrb)->(!Eof())

		cEmpAnt := Subs((cAliasTrb)->C5_FILIAL,1,2)
		cFilAnt := Subs((cAliasTrb)->C5_FILIAL,1,6)

		_cC5TMSACA	:= (cAliasTrb)->C5_ZTMSACA
		lRet := U_TMSJASPV( {(cAliasTrb)->C5_NUM,IIf((cAliasTrb)->DELET=="*",3,1),(cAliasTrb)->SC5_RECNO}, _cC5TMSACA,"", nil   ) // USER Function TMSJASPV( aParam, _xC5TMSACA, _lTela )	//aParam == {(cAliasTrb)->C5_NUM, IIf((cAliasTrb)->DELET=="*",3,1), (cAliasTrb)->SC5_RECNO}  )

		(cAliasTrb)->(dbSkip())

	Enddo

	(cAliasTrb)->(dbCloseArea())

	cEmpAnt := cEmpSav
	cFilAnt := cFilSav

Return()

// AdmAbreSM0 - Retorna um array com as informacoes das filias das empresas
Static Function AbreSM0(_cEmpresa, _cFilial )
	Local aArea			:= GetArea()
	Local aAreaSM0		:= SM0->( GetArea() )
	Local _nRecnoSM0	:= SM0->( Recno() )
	Local _lEncontrou	:= .F.
	Local aAux			:= {}
	Local aRetSM0		:= {}

	DbSelectArea( "SM0" )
	SM0->( DbGoTop() )
	While SM0->( !Eof() )
		If _cEmpresa + _cFilial == SM0->M0_CODIGO + SM0->M0_CODFIL
			_lEncontrou := .T.
			Exit
		Endif
		SM0->( DbSkip() )
	End
	If !_lEncontrou
		SM0->( DbGoTo(_nRecnoSM0) )
	Endif

	aRetSM0 := {SM0->M0_CGC              ,;
		SM0->M0_FILIAL           ,;
		Alltrim(SM0->M0_ENDCOB)  ,;
		Alltrim(SM0->M0_COMPCOB) ,;
		Alltrim(SM0->M0_BAIRCOB) ,;
		Alltrim(SM0->M0_CIDCOB)  ,;
		SM0->M0_ESTCOB           ,;
		SM0->M0_CEPCOB            }

	RestArea( aAreaSM0 )
	RestArea( aArea )
Return aRetSM0

/*
=====================================================================================
Programa............: TMS01Cpy
Autor...............: Geronimo Benedito Alves
Data................: 14/11/2018
Descricao...........: rotina chamada pelo ponto de entrada MT410CPY. Limpa os campos da integracao com o TMS TransWide
Objetivo............: Na copia de PV, limpa principalmente o campo C5_ZTMSACA para ele ser enviado ao TMS como inclusão, ao inves de alteração.
Solicitante.........: Cliente
Uso.................: Marfrig
=====================================================================================
*/
User Function TMS01Cpy()
	M->C5_ZTMSERR := CriaVar("C5_ZTMSERR")
	M->C5_ZTMSREE := CriaVar("C5_ZTMSREE")
	M->C5_ZTMSINT := CriaVar("C5_ZTMSINT")
	M->C5_ZTMSACA := CriaVar("C5_ZTMSACA")
	M->C5_ZTMSID  := CriaVar("C5_ZTMSID")
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MARKCM  ºAutor  ³Higor Emanuel     º Data ³  30/05/2016    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Subrotina para marcar todos no markBrowser				   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa Principal 								          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MARKCM()

	Local oMark := GetMarkBrow()

	dbSelectArea(_cTMSSC5)
	(_cTMSSC5)->(dbGotop())
	While !(_cTMSSC5)->(EOF())
		If RecLock(_cTMSSC5,.F.)
			(_cTMSSC5)->TA_MARK := cMarca
			(_cTMSSC5)->(MsUnLock())
		EndIf
		dbSelectArea(_cTMSSC5)
		(_cTMSSC5)->(dbSkip())
	Enddo

	MarkBRefresh()				// atualiza o browse
	oMark:oBrowse:GoTop()		// força o posicionamento do browse no primeiro registro

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DESMACM ºAutor  ³Higor Emanuel     º Data ³  30/05/2016    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Subrotina para desmarcar todos no markBrowser			   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa Principal						                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DESMACM()

	Local oMark := GetMarkBrow()

	dbSelectArea(_cTMSSC5)
	(_cTMSSC5)->(dbGotop())
	While !(_cTMSSC5)->(Eof())
		If RecLock(_cTMSSC5,.F.)
			(_cTMSSC5)->TA_MARK := cMarca
			(_cTMSSC5)->(MsUnLock())
		EndIf
		dbSelectArea(_cTMSSC5)
		(_cTMSSC5)->(dbSkip())
	Enddo

	MarkBRefresh()				// atualiza o browse
	oMark:oBrowse:GoTop()		// força o posicionamento do browse no primeiro registro

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Mark    ºAutor  ³Higor Emanuel       º Data ³  30/05/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Subrotina para gravar marca no campo se não estiver marcado ±±
±±º			 ³ ou limpar a marca se estiver marcado no markBrowser         ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa Principal						                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Mark()

	Local oMark := GetMarkBrow()

	If IsMark("TA_MARK",cMarca)
		If RecLock(_cTMSSC5,.F.)
			(_cTMSSC5)->TA_MARK := Space(2)
			(_cTMSSC5)->(MsUnLock())
		EndIf
	Else
		If RecLock(_cTMSSC5,.F.)
			(_cTMSSC5)->TA_MARK := cMarca
			(_cTMSSC5)->(MsUnLock())
		EndIf
	EndIf

	MarkBRefresh()				// atualiza o browse
	oMark:oBrowse:GoTop()		// força o posicionamento do browse no primeiro registro

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MARKACM ºAutor  ³Higor Emanuel     º Data ³  30/05/2016    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Subrotina para gravar\limpar marca em todos os registros    ±±
±±º			 ³ do markBrowser									           ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa Principal						                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MARKACM()

	Local oMark := GetMarkBrow()

	dbSelectArea(_cTMSSC5)
	(_cTMSSC5)->(dbGotop())
	While !(_cTMSSC5)->(EOF())
		U_Mark()
		dbSelectArea(_cTMSSC5)
		(_cTMSSC5)->(dbSkip())
	EndDo

	MarkBRefresh()				// atualiza o browse
	oMark:oBrowse:GoTop()		// força o posicionamento do browse no primeiro registro

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EXECRCM ºAutor  ³ Higor Emanuel    º Data ³  30/05/2016     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa o mestre de inventario para os endereços           º±±
±±º          ³ selecionados.                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa Principal						                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EXECRCM()

	_lExec := .T.
	CloseBrowse()

Return


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//  Funcoes de impressao de log/erros
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡…o    ³fRContErr ºAutor  ³Felipe Nathan Welterº Data ³  14/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do log de erros na importacao de quilometragem    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³NGPimsRCnt                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRContErr(aProb)

	Local nX
	Local cTxt := ''

	If Len(aProb) > 0
		For nX := 1 To Len(aProb)
			cTxt += ' - '+aProb[nX] + CHR(13)+CHR(10)
		Next nX
	EndIf

	If !Empty(cTxt)
		fShowLog(cTxt)
	EndIf

Return !Empty(cTxt)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³fShowLog  ³ Autor ³ Felipe Nathan Welter  ³ Data ³ 09/09/10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Apresentacao do log de processo/erro em tela                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³1.cTxtLog - texto de log para apresentacao                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³NGPimsCst                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fShowLog(cTxtLog)

	Local cPrograma := Substr(ProcName(1),1,Len(ProcName(1)))
	Local cMask := "Arquivos Texto (*.TXT) |*.txt|"
	Local oFont, oDlg
	Local aLog := Array(1)

	Local cArq   := cPrograma + "_" + SM0->M0_CODIGO + SM0->M0_CODFIL + "_" + Dtos(Date()) + "_" + StrTran(Time(),":","") + ".LOG"
	Local __cFileLog := MemoWrite(cArq,cTxtLog)

	lSched := If(Type("lSched")<>"L",.F.,lSched)

	If !lSched .And. !Empty(cArq)
		cTxtLog := MemoRead(AllTrim(cArq))
		aLog[1] := {cTxtLog}
		DEFINE FONT oFont NAME "Courier New" SIZE 5,0
		DEFINE MSDIALOG oDlg TITLE "Log de Processo" From 3,0 to 340,417 COLOR CLR_BLACK,CLR_WHITE PIXEL
		@ 5,5 GET oMemo  VAR cTxtLog MEMO SIZE 200,145 OF oDlg PIXEL
		oMemo:bRClicked := {||AllwaysTrue()}
		oMemo:oFont := oFont
		oMemo:lReadOnly := .T.

		DEFINE SBUTTON FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL
		DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,OemToAnsi("Salvar Como...")),If(cFile="",.t.,MemoWrite(cFile,cTxtLog)),oDlg:End()) ENABLE OF oDlg PIXEL
		DEFINE SBUTTON  FROM 153,115 TYPE 6 ACTION fLogPrint(aLog,cPrograma) ENABLE OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED
	EndIf

Return Nil


Static Function AtuSX6()

	If SX6->(!DbSeek(xFilial()+"MGF_TMS02A"))
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_TMS02A"
		SX6->X6_TIPO   := "L"
		SX6->X6_DESCRIC:= "Desativa Integração TMS Inclusao"
		SX6->X6_DESC1  := "do Pv PE M410AGRV/M410STTS"
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= ".F."
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif

	If SX6->(!DbSeek(xFilial()+"MGF_TMS02B"))
		_nSZ2 := U_GETSZ2()
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_TMS02B"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Cod Integração TMS Monitoramento"
		SX6->X6_DESC1  := ""
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= strzero(_nSZ2,3)
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif

	If SX6->(!DbSeek(xFilial()+"MGF_TMS02C"))
		_nSZ3 := U_GETSZ3(strzero(_nSZ2,3))
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_TMS02C"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Cod do Tipo Integração TMS Monitoramento "
		SX6->X6_DESC1  := ""
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= strzero(_nSZ3,3)
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif
Return

Static Function AtuSZ2()

	If SZ2->(!DbSeek(xFilial("SZ2")+Get("MGF_TMS02B")))
		RecLock("SZ2",.T.)
		SZ2->Z2_FILIAL := xFilial("SZ2")
		SZ2->Z2_CODIGO := Get("MGF_TMS02B")
		SZ2->Z2_NOME   := "TMS"
		MsUnlock()
	EndIf
Return

Static Function AtuSZ3()

	If SZ3->(!DbSeek(xFilial("SZ3")+Get("MGF_TMS02B")+Get("MGF_TMS02C")))
		RecLock("SZ3",.T.)
		SZ3->Z3_FILIAL := xFilial("SZ3")
		SZ3->Z3_CODINTG := Get("MGF_TMS02B")
		SZ3->Z3_CODTINT := Get("MGF_TMS02C")
		SZ3->Z3_TPINTEG := 'Integracao Pedido de Venda TMS TransWide'
		SZ3->Z3_EMAIL	:= ''
		SZ3->Z3_FUNCAO	:= ''
		MsUnlock()
	EndIf
Return

User Function GetSZ2()
	Local _nNumSZ2 := 0
	Local cAliasTrb := GetNextAlias()

	BeginSQL Alias cAliasTrb
		SELECT MAX(Z2_CODIGO) COD FROM %TABLE:SZ2% SZ2
		WHERE Z2_FILIAL = %XFILIAL:SZ2%
		AND SZ2.%NOTDEL%

	EndSQL

	If !Eof()
		_nNumSZ2 :=VAL((cAliasTrb)->COD) + 1
	Endif

Return(_nNumSZ2)

User Function GetSZ3(_nNumSZ2)
	Local _nNumSZ3 := 1
	Local cAliasTrb := GetNextAlias()
	Default _nNumSZ2 := '001'

	BeginSQL Alias cAliasTrb
		SELECT MAX(Z3_CODTINT) COD FROM %TABLE:SZ3% SZ3
		WHERE Z3_FILIAL = %XFILIAL:SZ3%
		AND Z3_CODINTG = %Exp:_nNumSZ2%
		AND SZ3.%NOTDEL%

	EndSQL

	If !Eof()
		_nNumSZ3 := VAL((cAliasTrb)->COD) + 1
	Endif

Return(_nNumSZ3)
/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³fLogPrint ³ Autor ³ Felipe Nathan Welter  ³ Data ³ 09/09/10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Apresentacao do log de processo/erro em tela                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³1.aLog - array contendo o conteudo para impressao           ³±±
	±±³          ³2.cProg - programa que chama a impressao                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³NGPimsCst                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fLogPrint(aLog,cProg)
	Local aTitle   := {""}

	aTitle := {"Integração de Pedido de Vendas para TMS"}

	CursorWait()
	fMakeLog( aLog,aTitle,,.T.,cProg,aTitle[1],"P","P",,.F.)
	CursorArrow()
Return Nil

	Class GravaPVTMS

		Data action						as String
		Data codigocliente				as String
		Data nomecliente				as String
		Data dataembarque				as String
		Data dataemissao				as String
		Data dataentrega				as String
		Data enderecoentrega			as String
		Data municipioenderecoentrega	as String
		Data cependeroentrega			as String
		Data ufenderecoentrega			as String
		Data paisenderecoentrega		as String
		Data codigofilial				as String
		Data cnpjfilial					as String
		Data nomefilial					as String
		Data enderecofilial				as String
		Data municipiofilial			as String
		Data uffilial					as String
		Data cepfilial					as String
		Data paisfilial					as String
		Data numeropedido				as String
		Data statuspedido				as String		// Não se aplica
		Data codigotipopedido			as String
		Data observacaopedido			as String
		Data numeroEXP					as String
		Data nomevendedor				as String
		Data QTDETOTAL					as Float
		Data unidademedidatotal     	as String
		Data tipodeproduto				as String

		Data ApplicationArea			as ApplicationArea

		Data Itens	  					as Array

		Method New()
		Method GravarPVCab()
		Method GravarPVItens()
		Method CarneOsso()

	EndClass

Method New() Class GravaPVTMS

	::ApplicationArea := ApplicationArea():New()

Return


Method GravarPVCab(cStatus) Class GravaPVTMS

	Local cStringTime := "T00:00:00"
	Local cCliente := ""
	Local cLoja := ""
	Local cNomeClien := ""
	Local cAliasSC5
	Local _cNumerEXP	:= ""

	Local cCGC 			:= ""
	Local _cEnderEnt	:= ""
	Local _cMunicEnt	:= ""
	Local _cepEnt		:= ""
	Local _cEstadEnt	:= ""

	Local _cPais_Ent	:= ""
	Local _aSM0			:= AbreSM0( cEmpAnt, SC5->C5_FILIAL )
	Local _nI

	If SC5->C5_TIPO $ ("D/B")
		SA2->(dbSetOrder(1))
		If SA2->(dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			If !Empty(SA2->A2_CGC)
				cCliente	:= SA2->A2_CGC
			ElseIf !Empty(SA2->A2_ZCODMGF)
				cCliente := SA2->A2_ZCODMGF
			Else
				cCliente := SA2->A2_COD
				cLoja := SA2->A2_LOJA
			Endif
			cNomeClien	:= AllTrim(SA2->A2_NREDUZ) + "  - " + AllTrim(SA2->A2_MUN)
			cCGC 		:= SA2->A2_CGC

			_cEnderEnt	:= SA2->A2_END
			_cMunicEnt	:= SA2->A2_MUN
			_cepEnt		:= SA2->A2_CEP
			_cEstadEnt	:= SA2->A2_EST
			_cEstadEnt	:= IF(_cEstadEnt == "EX" ,"  " ,_cEstadEnt )
			_cPais_Ent	:= GetAdvFVal("SYA","YA_ZSIGLA",xFilial("SYA")+SA2->A2_PAIS,1,"")

		Endif

	Else
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			If !Empty(SA1->A1_CGC)
				cCliente	:= SA1->A1_CGC
			ElseIf !Empty(SA1->A1_ZCODMGF) // campo que conterah o codigo do cliente no sistema da Marfrig. ***verificar o nome que este campo serah criado
				cCliente := SA1->A1_ZCODMGF
			Else
				cCliente := SA1->A1_COD
				cLoja := SA1->A1_LOJA
			Endif

			cNomeClien	:= AllTrim(SA1->A1_NREDUZ) + "  - " + AllTrim(SA1->A1_MUN)
			cCGC		:= SA1->A1_CGC
			_cEnderEnt	:= IF(Empty(SA1->A1_ENDENT), SA1->A1_END, SA1->A1_ENDENT )
			_cMunicEnt	:= IF(Empty(SA1->A1_MUNE),   SA1->A1_MUN, SA1->A1_MUNE   )
			_cepEnt		:= IF(Empty(SA1->A1_CEPE),   SA1->A1_CEP, SA1->A1_CEPE )
			_cEstadEnt	:= IF(Empty(SA1->A1_ESTE),   SA1->A1_EST, SA1->A1_ESTE )
			_cEstadEnt	:= IF(_cEstadEnt == "EX" ,"  " ,_cEstadEnt )
			_cPais_Ent	:= GetAdvFVal("SYA","YA_ZSIGLA",xFilial("SYA")+SA1->A1_PAIS,1,"")

			// Se houver endereço cadastrado na SZ9, uso-o
			If !Empty(SC5->C5_ZIDEND)
				DbSelectArea("SZ9")
				SZ9->(dbsetOrder(1))
				IF SZ9->(DbSeek(xFilial("SZ9")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_ZIDEND ))
					_cCNPJSZ9 :=  if(len(alltrim(SZ9->Z9_ZCGC)) = 11, Transform(alltrim(SZ9->Z9_ZCGC),"@! 999.999.999-99"), Transform(SZ9->Z9_ZCGC,"@! 99.999.999.9999/99"))
					_cNomeSZ9 := Alltrim(SZ9->Z9_ZRAZEND)

					_cEnderEnt  := ALLTRIM(SZ9->Z9_ZENDER)
					_cBairEnt	:= ALLTRIM(SZ9->Z9_ZBAIRRO)
					_cMunicEnt  := ALLTRIM(SZ9->Z9_ZMUNIC)
					_cepEnt		:= ALLTRIM(SZ9->Z9_ZCEP)
					_cEstadEnt  := ALLTRIM(SZ9->Z9_ZEST)
					_cPais_Ent	:= If(Empty( SZ9->Z9_ZCODMUN) , "" , "BR" )
				Endif
			Endif
		Endif
	Endif

	cAliasZB8 := GetNextAlias()
	BeginSql Alias cAliasZB8
		SELECT ZB8_FILIAL, ZB8_EXP, ZB8_ANOEXP, ZB8_SUBEXP, R_E_C_N_O_ REC
		FROM %Table:ZB8% ZB8
		WHERE
		ZB8.ZB8_FILVEN = %Exp:SC5->C5_FILIAL% AND
		ZB8.ZB8_PEDFAT = %Exp:SC5->C5_NUM%    AND
		ZB8.D_E_L_E_T_ = ' '
	EndSql													// AND ZB8.ZB8_MOTEXP = '7'

	If !(cAliasZB8)->(Eof())
		_cNumerEXP	:= ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP
	EndIf

	_cNumerEXP	:= StrTran( _cNumerEXP, "EXP", "" )

	::action					:= Alltrim( U_TMSAcao( _cC5TMSACA ) )
	::codigocliente				:= cCliente
	::nomecliente				:= cNomeClien
	::dataembarque				:= Alltrim( IIf(!Empty(SC5->C5_ZDTEMBA),Subs(dTos(SC5->C5_ZDTEMBA),1,4)+"-"+Subs(dTos(SC5->C5_ZDTEMBA),5,2)+"-"+Subs(dTos(SC5->C5_ZDTEMBA),7,2)+cStringTime,"") )
	::dataemissao				:= Alltrim( IIf(!Empty(SC5->C5_EMISSAO),Subs(dTos(SC5->C5_EMISSAO),1,4)+"-"+Subs(dTos(SC5->C5_EMISSAO),5,2)+"-"+Subs(dTos(SC5->C5_EMISSAO),7,2)+cStringTime,"") )
	::dataentrega				:= Alltrim( IIf(!Empty(SC5->C5_FECENT) ,Subs(dTos(SC5->C5_FECENT) ,1,4)+"-"+Subs(dTos(SC5->C5_FECENT) ,5,2)+"-"+Subs(dTos(SC5->C5_FECENT) ,7,2)+cStringTime,"") )
	::enderecoentrega			:= _cEnderEnt
	::municipioenderecoentrega	:= _cMunicEnt
	::cependeroentrega			:= _cepEnt
	::ufenderecoentrega			:= _cEstadEnt
	::paisenderecoentrega		:= _cPais_Ent
	::codigofilial				:= SC5->C5_FILIAL
	::cnpjfilial				:= _aSM0[01]	// SM0->M0_CGC
	::nomefilial				:= _aSM0[02]	// SM0->M0_FILIAL
	::enderecofilial			:= Alltrim(_aSM0[03]) + " " + Alltrim(_aSM0[04]) + "-" + Alltrim(_aSM0[05])		// Alltrim(SM0->M0_ENDCOB) + " " + Alltrim(SM0->M0_COMPCOB) + "-" + Alltrim(SM0->M0_BAIRCOB)
	::municipiofilial			:= _aSM0[06]	// SM0->M0_CIDCOB
	::uffilial					:= _aSM0[07]	// SM0->M0_ESTCOB
	::cepfilial					:= _aSM0[08]	// SM0->M0_CEPCOB
	::paisfilial				:= "BR"
	::numeropedido				:= SC5->C5_NUM + SC5->C5_FILIAL
	::statuspedido				:= IIf(!Empty(SC5->C5_PEDEXP),"N",IIf(SC5->C5_ZBLQRGA=="B","B","N")) // B=bloqueado,N=Liberado
	::codigotipopedido			:= Alltrim(SC5->C5_ZTIPPED) //"VE"
	::observacaopedido			:= Alltrim(SC5->C5_XOBSPED)		// C5_ZOBS
	::numeroEXP					:= _cNumerEXP
	::nomevendedor				:= POSICIONE('SA3',1,xFilial('SA3')+SC5->C5_VEND1,'A3_NOME')
	::QTDETOTAL					:= PesoBruPed(SC5->C5_FILIAL , SC5->C5_NUM)
	::unidademedidatotal     	:= "KG"
	::tipodeproduto				:= Alltrim(SC5->C5_XTPROD)


	::Itens	:= {}

Return()


	Class ItensPVTMS
		Data codigoproduto			as String
		Data descricaoproduto		as String
		Data observacaoproduto		as String
		Data qtdeproduto			as float
		Data precounitarioproduto	as float
		Data unidademedidaproduto	as String

		Method New()

	endclass
Return


Method New() Class ItensPVTMS

	Local cStringTime := "T00:00:00"

	::codigoproduto			:= Alltrim(SC6->C6_PRODUTO)
	::descricaoproduto		:= ALLTRIM(Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC"))
	::observacaoproduto		:= ALLTRIM(Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_ZOBS"))
	::qtdeproduto			:= SC6->C6_QTDVEN
	::precounitarioproduto	:= SC6->C6_PRCVEN				// NÃO SE APLICA
	::unidademedidaproduto	:= Alltrim(SC6->C6_UM)

Return()


Method GravarPVItens(oItens) Class GravaPVTMS

	aAdd(::Itens,oItens)

Return()

/*/{Protheus.doc} CarneOsso
	Metodo criado conforme feature/PRB0040216-Protheus-TMS-Carne-c-Osso
	Onde o sistema verificará se a embalagem está para transpote com cancho/Carne com osso.
	@author Natanael Filho
	@since 20/08/2019
	@version 1
	@param _cProduto, Caractere, Código do produto
	@return nil
	/*/
Method CarneOsso(_cProduto) Class GravaPVTMS
	Local _lGancho := .F.

	//Posiciona no cadastro de embalagens (EE5) e retorna se é gancho ou não.
	If '1' == Posicione("EE5",1,xFilial("EE5")+SB1->B1_CODEMB,"EE5_ZGANCH")
		::tipodeproduto := "CARNE COM OSSO" //Texto definido onde o TMS saberá que o produto é transportado com gancho
	EndIf

Return
