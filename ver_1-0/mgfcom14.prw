#Include 'Protheus.ch'
#include "totvs.ch"
#Include 'FWMVCDef.ch'

#define cr chr(13) + chr(10)

/*
==============================================================================================================================
Programa............: MGFCOM14
Autor...............: Joni Lima
Data................:
Descricao / Objetivo: Rotina para aprovacao e rejeicao de documentos
Doc. Origem.........: Solicitacao de compra - Pedido de compra - Contas a Pagar - Solicitacao Armazem - Lancamento Cont�bil
Solicitante.........: Cliente
Uso.................: 
==============================================================================================================================
Data da alteracao............: 18/12/2018
Autor........................: Caroline Cazela (caroline.cazela@totvspartners.com.br)
Descricao da alteracao.......: Inclusao de aprovacao de lan�amentos cont�beis. Utiliza o tipo LC e as tabelas SCR, DBM e CT2.
.............................: Nao  tem integracao com o Fluig.
==============================================================================================================================
*/
STATIC cOperID	:= 	"000"	// Variavel para armazenar a operacao que foi executada
STATIC oModelCT	:= NIL

#DEFINE OP_LIB   	"001"	// Liberado
#DEFINE OP_EST   	"002"	// Estornar
#DEFINE OP_SUP   	"003"	// Superior
#DEFINE OP_TRA   	"004"	// Transferir Superior
#DEFINE OP_EST	    "005"	// Estorna
#DEFINE OP_REJ	    "006"	// Rejeitado
#DEFINE OP_BLQ	    "007"	// Bloqueio

User Function MGFCOM14()

	Local aAreaSX3 := SX3->(GetArea())

	Local aStruSCR	:= {} //Estrutura da tabela de Aprovacao SCR
	Local cTmp		:= GetNextAlias()
	Local cAliasTmp
	Local aColumns	:= {}

	Local aFieldBrw		:= {}
	Local aFieFilter	:= {}
	Local aFldSeek		:= {}
	Local aSeek			:= {}
	Local nX
	Local nI
	Private  cPerg		:="MTA097X"

	Private aComboE 	:= {"1-Pendente","2-Todos","3-Bloqueados","4-Rejeitados","5-Aprovados"}
	Private aComboF 	:= {"1-Todos","2-Solicitacao Compra","3-Pedido de Compra","4-Pagamentos","5-Solicit.Armazem","6-Lanc.Contabil"}
	Private aComboT 	:= {"1=ZWA","2=ZWB"}
	Private aParamBox	:= {}
	Private aRet 		:= {}

	Private _cMatPar := ""
	Private _nQtdpar := 4
	Private oBrowse
	Private cInsert
	Private cCampos	:= "" //Pega campos que sao de contexto Real
	Private cQry	:= ""

	AtuSX6()

	If !Empty(GetMv("MGF_COM14A"))
		_cMatPar := Alltrim(GetMv("MGF_COM14A"))+Alltrim(GetMv("MGF_COM14B"))+Alltrim(GetMv("MGF_COM14C")) // parametro que contem os 6 numero do codigo do usuario e 2 de quantidade de perguntas
		// busca o codigo do usuario na string
		If AT( xxRetUser(), ALLTRIM(_cMatPar) ) > 0
			_nQtdpar := val(substr(_cMatPar,AT( xxRetUser(), ALLTRIM(_cMatPar) )+6,2))
		EndIf
	EndIf

	AADD(aParamBox,{2,"Exibir Documentos ? "	, 1			, aComboE, 100 ,".F.", .F. })		// MV_PAR01
	AADD(aParamBox,{2,"Tipo de Documento ?: "	, 1			, aComboF, 100 ,".F.", .F. })		// MV_PAR02
	AADD(aParamBox,{1,"Filial De ? "			,Space(06)	,"@C"	 ,".T.","SM0",,65,.F.})
	AADD(aParamBox,{1,"Filial Ate ?"			,Space(06)	,"@C"	 ,".T.","SM0",!EMPTY(MV_PAR03),65,.F.})
	AADD(aParamBox,{1,"Solicitante ? "			,Space(06)	,"@C"	 ,".T.","USR",,65,.F.})
	AADD(aParamBox,{1,"Documento cont�m ? "		,Space(10)	,"@C"	 ,".T.",,,65,.F.})
	_cValPar := ""
	For _np := 2 to _nQtdpar
		If Empty(_cValPar)
			_cValPar += " !EMPTY(MV_PAR"+strzero(6+_np-2,2)+")"
		Else
			_cValPar += ".AND.!EMPTY(MV_PAR"+strzero(6+_np-2,2)+")"
		EndIf
		AADD(aParamBox,{1,"ou Documento cont�m ? "	,Space(10)	,"@C"	 ,".T.",,"("+_cValPar+")",65,.F.})
	Next _np


	//	Parambox ( aParametros,@cTitle      ,@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] )
	If !ParamBox (aParamBox   ,"Filtros ...",@aRet,       ,            ,             ,         ,         ,              ,cPerg    ,.T.          ,.T.)
		Return()
	EndIf

	If ValType(aRet[1]) == "N"
		mv_par01 := aRet[1]
	Else
		mv_par01 := val(substr(aRet[1],1,1))
	EndIf

	If ValType(aRet[2]) == "N"
		mv_par02 := aRet[2]
	Else
		mv_par02 := val(substr(aRet[2],1,1))
	EndIf

	mv_par03 := aRet[3]
	mv_par04 := aRet[4]


	aStruSCR	:= SCR->(DBSTRUCT()) //Estrutura da tabela de Aprovacao SCR
	For nI := 1 to Len(aStruSCR)
		if aStruSCR[nI][1] == 'CR_FILIAL'
			aStruSCR[nI][3] := 50
		endif
	Next nI
	cCampos		:= xCmpQry("SCR") 	 //Pega campos que sao de contexto Real
	cQry 		:= xQryDads(cCampos)
	aIndices	:= xIndQry("SCR")
	cFieldBrw   := xCmpBrw("SCR") + ",CR_FILIAL,CR_ZNOMUSU,CR_ZDESCST,CR_ZDESTP"

	aAdd(aStruSCR, {'RECSCR','N',10,0})
	aAdd(aStruSCR, {'CR_ZNOMUSU','C',30,0})
	aAdd(aStruSCR, {'CR_ZDESCST','C',15,0})
	aAdd(aStruSCR, {'CR_ZDESTP', 'C',15,0})

//Instancio o objeto que vai criar a tabela temporaria no BD para poder utilizar posteriormente
	oTmp := FWTemporaryTable():New( cTmp )

//Defino os campos da tabela temporaria
	oTmp:SetFields(aStruSCR)

//Adiciono o indice da tabela temporaria
	For nX := 1 To Len(aIndices)

		aChave	:= StrToKarr(Alltrim(aindices[nX,2]),"+")
		cTmpIdx := "Tmp_Idx_" + StrZero(nX,2)

		oTmp:AddIndex(cTmpIdx,aChave)

		aFldSeek	:= {}

		For nI := 1 to Len(aChave)
			nPosFld  := aScan( aStruSCR, { |x| Alltrim(x[1]) == aChave[nI] })
			AADD(aFldSeek,{"",aStruSCR[ni,2],aStruSCR[ni,3],aStruSCR[ni,4],PesqPict("SCR",aStruSCR[ni,1])})
		Next nI

		//Campos que irao compor o combo de pesquisa na tela principal
		Aadd(aSeek,{aIndices[nX,3],aFldSeek,nX, .T.})

	Next nX

//Criacao da tabela temporaria no BD
	oTmp:Create()

//Obtenho o nome "verdadeiro" da tabela no BD (criada como temporaria)
	cTable := oTmp:GetRealName()

//Preparo o comando para alimentar a tabela temporaria
	cInsert := "INSERT INTO " + cTable + " (" + cCampos + " RECSCR ) " + cQry

	memoWrite("C:\qry\insertmgfcom14.SQL", cInsert)

//Executo o comando para alimentar a tabela temporaria
	Processa({|| TcSQLExec(cInsert)})

//Campos que irao compor a tela de filtro
	For nI := 1 to Len(aStruSCR)
		If aStruSCR[nI,1] $ cCampos
			Aadd(aFieFilter,{aStruSCR[nI,1],RetTitle(aStruSCR[nI,1]), aStruSCR[nI,2], aStruSCR[nI,3] , aStruSCR[nI,4],PesqPict("SCR",aStruSCR[ni,1])})
		Endif
	Next nI

//MarkBrowse
	For nX := 1 To Len(aStruSCR)
		If	aStruSCR[nX][1] $ cFieldBrw
			AAdd(aColumns,FWBrwColumn():New())

			aColumns[Len(aColumns)]:SetData( &("{||"+aStruSCR[nX][1]+"}") )
			If Alltrim(aStruSCR[nX][1]) == 'CR_ZDESCST'
				aColumns[Len(aColumns)]:SetTitle("Desc. Status")
				aColumns[Len(aColumns)]:SetPicture('@!')
			Else
				aColumns[Len(aColumns)]:SetTitle(RetTitle(aStruSCR[nX][1]))
				aColumns[Len(aColumns)]:SetPicture(PesqPict("SCR",aStruSCR[nX][1]))
			EndIf

			aColumns[Len(aColumns)]:SetSize(aStruSCR[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruSCR[nX][4])

		EndIf
	Next nX

	cAliasTmp := oTmp:GetAlias()

	xFldCust(cAliasTmp)

	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetAlias( cAliasTmp )
	oBrowse:SetDescription( 'Aprovacao da Grade Marfrig' )
	oBrowse:SetSeek(.T.,aSeek)
	oBrowse:SetTemporary(.T.)
	oBrowse:SetLocate()
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:SetFilterDefault( "" ) //Exemplo de como inserir um filtro padrao >>> "TR_ST == 'A'"
	oBrowse:oBrowse:SetFieldFilter(aFieFilter)
	oBrowse:DisableDetails()

	oBrowse:SetFieldMark("CR_ZOK")
	oBrowse:SetCustomMarkRec({||xMark()})

	oBrowse:SetAllMark({|| xMarkAll() })

// Definicao da legenda
	oBrowse:AddLegend( "CR_STATUS=='01'", "BR_AZUL"   , "Bloqueado (aguardando outros niveis)" )
	oBrowse:AddLegend( "CR_STATUS=='02'", "DISABLE"   , "Aguardando Liberacao do usuario"     )
	oBrowse:AddLegend( "CR_STATUS=='03'", "ENABLE"    , "Documento Liberado pelo usuario"     )
	oBrowse:AddLegend( "CR_STATUS=='04'", "BR_PRETO"  , "Documento Bloqueado pelo usuario"    )
	oBrowse:AddLegend( "CR_STATUS=='05'", "BR_CINZA"  , "Documento Liberado por outro usuario")
	oBrowse:AddLegend( "CR_STATUS=='06'", "BR_AMARELO",	"Documento Rejeitado pelo usuario"    )

	oBrowse:SetColumns(aColumns)

	oBrowse:Activate()

	oTmp:Delete()

//	EndIf
Return

Static Function xFldCust(cAlias)

	(cAlias)->(dbGoTop())

	While (cAlias)->(!EOF())
		RecLock((cAlias),.F.)
		(cAlias)->CR_ZDESCST := xDescStat((cAlias)->CR_STATUS, 'CR_STATUS')
		(cAlias)->CR_ZDESTP  := U_xMGFINITP(cAlias)
		(cAlias)->CR_ZNOMUSU := U_MGF8NomU((cAlias)->CR_USER)
		(cAlias)->(MsUnLock())
		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbGoTop())

Return

Static Function xIndQry(cxAlias)

	Local aRet := {}
	Local cNextAlias := GetNextAlias()

	BeginSql Alias cNextAlias

		SELECT
			ORDEM,
			CHAVE,
			DESCRICAO
		FROM SIX010 IX
		WHERE
			IX.%NotDel%
			AND IX.INDICE = %Exp:cxAlias%
		ORDER BY ORDEM

	EndSql

	While (cNextAlias)->(!EOF())
		AADD(aRet,{(cNextAlias)->ORDEM,(cNextAlias)->CHAVE,(cNextAlias)->DESCRICAO})
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

return aRet

Static Function xCmpQry(cxAlias)

	Local cRet := ""
	Local cNextAlias := GetNextAlias()

	BeginSql Alias cNextAlias

		SELECT
			X3_CAMPO
		FROM SX3010 X3
		WHERE
			X3.%NotDel%
			AND X3.X3_ARQUIVO = %Exp:cxAlias%
			AND X3.X3_CONTEXT IN (' ','R')
		ORDER BY X3_ORDEM

	EndSql

	While (cNextAlias)->(!EOF())
		cRet += (cNextAlias)->X3_CAMPO + ", "
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

return cRet

Static Function xCmpBrw(cxAlias)

	Local cRet := ""
	Local cNextAlias := GetNextAlias()

	BeginSql Alias cNextAlias

		SELECT
			X3_CAMPO
		FROM SX3010 X3
		WHERE
			X3.%NotDel%
			AND X3.X3_ARQUIVO = %Exp:cxAlias%
			AND X3.X3_CONTEXT IN (' ','R')
			AND X3.X3_BROWSE = 'S'
		ORDER BY X3_ORDEM

	EndSql

	While (cNextAlias)->(!EOF())
		cRet += (cNextAlias)->X3_CAMPO + ", "
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

return cRet

Static Function xQryDads(cCampos)
	local xcCampos := ''
	local cQry := ""

	xcCampos := StrTran(cCampos, 'CR_FILIAL ,', '')

	cQry := "SELECT CONCAT(CONCAT(CR_FILIAL, ' - '), M0_FILIAL) CR_FILIAL, " + xcCampos
	cQry +=  cr + " SCR.R_E_C_N_O_ RECSCR "
	cQry +=  cr + " FROM "+	RetSqlName("SCR") + " SCR "
	cQry +=  cr + " INNER JOIN (SELECT M0_CODFIL, M0_FILIAL FROM SYS_COMPANY WHERE R_E_C_D_E_L_ = 0 ) B ON "
	cQry +=  cr + " CR_FILIAL = M0_CODFIL "
	If mv_par02 == 2
		If !Empty(mv_par05)
			cQry +=  cr + " INNER JOIN " + RetSqlName("SC1") + " SC1 ON C1_FILIAL = CR_FILIAL AND CR_NUM = C1_NUM AND SC1.D_E_L_E_T_ = ' ' "
		EndIf
	EndIf
	cQry +=  cr + " WHERE "
	cQry +=  cr + " 	SCR.D_E_L_E_T_ = ' ' "
	cQry +=  cr + " 	AND " + xQFilUse()


	Do Case //Status
	Case mv_par01 == 1
		cQry += cr + " AND SCR.CR_STATUS = '02' "
	Case mv_par01 == 2
		cQry +=  cr + " AND SCR.CR_STATUS IN ('01','02','03','04','05','06') "
	Case mv_par01 == 3
		cQry += cr + " AND SCR.CR_STATUS = '04' "
	Case mv_par01 == 4
		cQry += cr + " AND SCR.CR_STATUS = '06' "
	Case mv_par01 == 5
		cQry += cr + " AND SCR.CR_STATUS IN ('03','05')"
	EndCase

	Do Case //Tipo do Registro
	Case mv_par02 == 1
		cQry +=  cr + " AND SCR.CR_TIPO IN ('SC','PC','ZC','SA','LC') "
	Case mv_par02 == 2
		cQry +=  cr + "  AND SCR.CR_TIPO = 'SC' "
	Case mv_par02 == 3
		cQry +=  cr + "  AND SCR.CR_TIPO = 'PC' "
	Case mv_par02 == 4
		cQry +=  cr + "  AND SCR.CR_TIPO = 'ZC' "
	Case mv_par02 == 5
		cQry +=  cr + "  AND SCR.CR_TIPO = 'SA' "
	Case mv_par02 == 6
		cQry +=  cr + "  AND SCR.CR_TIPO = 'LC' "
	EndCase

	If !Empty(mv_par03) .and. !Empty(mv_par04) //Filial
		cQry +=  cr + "  AND SCR.CR_FILIAL BETWEEN '" + mv_par03 + "' AND '" + mv_par04  + "'"
	EndIf

	If mv_par02 == 2 // SC
		If !Empty(mv_par05)
			cQry +=  cr + "  AND SCR.CR_USER = '" + mv_par05 + "' "
		EndIf
	EndIf

	If !Empty(mv_par06)
		cQry +=  cr + "  AND ( "
		For _np := 6 to Len(aRet)
			If !Empty(aRet[_np])
				cQry +=  cr + "  SCR.CR_NUM LIKE '%" + Alltrim(aRet[_np]) + "%' "
				If Len(aRet) > _np
					cQry +=  cr + "  OR"
				EndIf
			EndIf
		Next _np
	EndIf

	If substr(cQry, Len(cQry)-1, 2) == 'OR'
		cQry := substr(cQry, 1, Len(cQry)-2)
	EndIf

	If!Empty(mv_par06)
		cQry +=  cr + "  ) "
	EndIf
	memoWrite("C:\temp\MGFCOM14.SQL", cQry)

Return cQry

Static Function xDescStat(cChave, cCampo)

	Local aArea  := GetArea()
	local aCombo := RetSX3Box(GetSX3Cache(cCampo, "X3_CBOX"),,,1)
	Local nAtual := 1
	Local cRet	 := ""

	//Percorre as posicoes do combo
	For nAtual := 1 To Len(aCombo)
		//Se for a mesma chave, seta a descricao
		If cChave $ '0' + aCombo[nAtual][1]
			cRet := aCombo[nAtual][3]
			Exit
		EndIf
	Next

	RestArea(aArea)

Return cRet

Static function xFilUser()

	Local aArea 	:= GetArea()

	Local cxUseAp 	:= xxRetUser()
	Local cNextAlias:= GetNextAlias()

	Local cxFilSC1 := xFilial('SC1')
	Local cDtHoje  := dtoS(DATE())

	Local cRet := '(CR_USER == "' + cxUseAp + '"'

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT
			DISTINCT ZAA.ZAA_CODAPR
		FROM
			%Table:ZAA% ZAA
		WHERE
			ZAA.%NotDel% AND
			ZAA.ZAA_CODSUB = %Exp:cxUseAp% AND
			%Exp:cDtHoje% >= ZAA.ZAA_DTINIC AND
			%Exp:cDtHoje% <= ZAA.ZAA_DTFINA

		ORDER BY ZAA_CODAPR

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		cRet += '.OR. CR_USER == "' + (cNextAlias)->ZAA_CODAPR + '"'
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	cRet += ')'

	RestArea(aArea)

return cRet

Static function xQFilUse()

	Local aArea 	:= GetArea()

	Local cxUseAp 	:= xxRetUser()
	Local cNextAlias:= GetNextAlias()

	Local cxFilSC1 := xFilial('SC1')
	Local cDtHoje  := dtoS(DATE())

	Local cRet := "CR_USER IN ('" + cxUseAp + "'"

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT
			DISTINCT ZAA.ZAA_CODAPR
		FROM
			%Table:ZAA% ZAA
		WHERE
			ZAA.%NotDel% AND
			ZAA.ZAA_CODSUB = %Exp:cxUseAp% AND
			%Exp:cDtHoje% >= ZAA.ZAA_DTINIC AND
			%Exp:cDtHoje% <= ZAA.ZAA_DTFINA

		ORDER BY ZAA_CODAPR

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		cRet += ", '"  + (cNextAlias)->ZAA_CODAPR + "'"
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	cRet += ')'

	RestArea(aArea)

return cRet

Static function MenuDef()

	Local aRotina := {} //Array utilizado para controlar opcao selecionada

	ADD OPTION aRotina Title "Pesquisar"			Action 'PesqBrw'  		  						OPERATION 1 ACCESS 0 			//"Pesquisar"
	ADD OPTION aRotina Title "Liberar"				Action 'U_XMC14Libe'	  						OPERATION 2 ACCESS 0 ID OP_LIB	//"Liberar"
	ADD OPTION aRotina Title "Consulta PC/SC"       Action 'U_xMC1497()'  							OPERATION 4 ACCESS 0     		//"Consulta Docto"
	ADD OPTION aRotina Title "Consulta Titulos"		Action 'U_xMC14CTit()'	  						OPERATION 4 ACCESS 0     		//"Consulta Docto"
	ADD OPTION aRotina Title "Bloqueio"  			Action 'U_XMC14Bloqu'	   				 		OPERATION 4 ACCESS 0 			//"Bloqueio"
	ADD OPTION aRotina Title "Rejeitar"  			Action 'U_XMC14Rej()'	  				  		OPERATION 4 ACCESS 0 ID OP_REJ  //"Rejeitar"
	ADD OPTION aRotina Title "Log Aprovacao"  		Action 'U_xMC8LgAp()'	  				   		OPERATION 4 ACCESS 0 			//"Log Aprovacao"
	ADD OPTION aRotina Title "Liberacao Lote"  		Action 'U_xC14LLot()'	   				   		OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title "Bloqueio Lote"  		Action 'U_xC14BLot()'	   				  		OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title "Rejeicao Lote"  		Action 'U_xC14RLot()'	   				   		OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title "Mapa de Cota��o" 		Action 'U_MFCOM14A()'	   						OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title "Visualiza Lancto"		Action 'U_MGFCTB27()'							OPERATION 4 ACCESS 0			//Visualiza Lancamento Cont�bil
	ADD OPTION aRotina Title "Atualizacao tela"		Action 'U_xMC14Ref()'							OPERATION 3 ACCESS 0			//Atualizacao de tela

Return aRotina

User Function xMC14Ref()

	If !ParamBox(aParamBox,"Filtros ...",@aRet,,,,,,,cPerg,.T.,.T.)
		Return()
	EndIf

	If ValType(aRet[1]) == "N"
		mv_par01 := aRet[1]
	Else
		mv_par01 := val(substr(aRet[1],1,1))
	EndIf

	If ValType(aRet[2]) == "N"
		mv_par02 := aRet[2]
	Else
		mv_par02 := val(substr(aRet[2],1,1))
	EndIf

	mv_par03 := aRet[3]
	mv_par04 := aRet[4]


	cQry	:= xQryDads(cCampos)
//Preparo o comando para alimentar a tabela temporaria
	cInsert := "INSERT INTO " + cTable + " (" + cCampos + " RECSCR ) " + cQry
	u_xMC14Atu()

Return

User Function xMC14Atu()

	Local cNextAlias := GetNextAlias()
	Local cFiltraSCR := ""

	Local cAlias := oBrowse:Alias()

	(cAlias)->(dbGoTop())

	While (cAlias)->(!EOF())
		RecLock((cAlias),.F.)
		(cAlias)->(DbDelete())
		(cAlias)->(MsUnLock())

		(cAlias)->(dbSkip())
	EndDo

	Processa({|| TcSQLExec(cInsert)})

	xFldCust(cAlias)

	(cAlias)->(dbGoTop())

Return

User Function xMC14CTit()

	Local aArea := GetArea()
	Local cFilBkp := cFilAnt
	Local cAlias := oBrowse:Alias()

	dbSelectArea("SCR")
	SCR->(DbSetOrder(0))
	SCR->(DbGoTo((cAlias)->RECSCR))

	cFilAnt := (cAlias)->CR_FILIAL

	If AllTrim(SCR->CR_TIPO) == 'ZC'
		dbSelectArea('SE2')
		SE2->(dbSetOrder(1))
		If SE2->(dbSeek(xFilial('SE2') + AllTrim(SCR->CR_NUM)))
			U_MGFCOM34()
		EndIf
	EndIf

	cFilAnt := cFilBkp
	RestArea(aArea)

return

User Function xMC1497()

	Local aArea := GetArea()
	Local cFilBkp := cFilAnt
	Local cAlias := oBrowse:Alias()

	dbSelectArea("SCR")
	SCR->(DbSetOrder(0))
	SCR->(DbGoTo((cAlias)->RECSCR))

	cFilAnt := (cAlias)->CR_FILIAL

	A097Visual(,,2)

	cFilAnt := cFilBkp
	RestArea(aArea)

Return

User Function xMC8LgAp()

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaSCP	:= SCP->(GetArea())
	Local aAreaSE2	:= SE2->(GetArea())
	Local aAreaCT2	:= CT2->(GetArea())
	Local cFilBkp := cFilAnt
	Local cAlias := oBrowse:Alias()

	dbSelectArea("SCR")
	SCR->(DbSetOrder(0))
	SCR->(DbGoTo((cAlias)->RECSCR))

	cFilAnt := (cAlias)->CR_FILIAL

	If AllTrim(SCR->CR_TIPO) == 'SC'
		dbSelectArea('SC1')
		SC1->(dbSetOrder(1))
		If SC1->(dbSeek(xFilial('SC1') + AllTrim(SCR->CR_NUM)))
			U_MGFCOM17('SC')
		EndIf
	ElseIf AllTrim(SCR->CR_TIPO) == 'PC'
		dbSelectArea('SC7')
		SC7->(dbSetOrder(1))
		If SC7->(dbSeek(xFilial('SC7') + AllTrim(SCR->CR_NUM)))
			U_MGFCOM17('PC')
		EndIf
	ElseIf AllTrim(SCR->CR_TIPO) == 'SA'
		dbSelectArea('SCP')
		SCP->(dbSetOrder(1))
		If SCP->(dbSeek(xFilial('SCP') + AllTrim(SCP->CP_NUM)))
			U_MGFCOM17('SA')
		EndIf
	ElseIf AllTrim(SCR->CR_TIPO) == 'ZC'
		dbSelectArea('SE2')
		SE2->(dbSetOrder(1))
		If SE2->(dbSeek(xFilial('SE2') + AllTrim(SCR->CR_NUM)))
			U_MGFCOM17('ZC')
		EndIf
	ElseIf AllTrim(SCR->CR_TIPO) == 'LC'
		dbSelectArea('CT2')
		CT2->(dbSetOrder(17))
		If CT2->(dbSeek(xFilial('CT2') + DTOS(SCR->CR_EMISSAO) + AllTrim(SCR->CR_NUM)))
			U_MGFCOM17('LC')
		EndIf
	EndIf

	cFilAnt := cFilBkp

	RestArea(aAreaCT2)
	RestArea(aAreaSE2)
	RestArea(aAreaSC7)
	RestArea(aAreaSCP)
	RestArea(aAreaSC1)
	RestArea(aArea)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MFCOM14A
Chamada do Mapa de Cota��o a partir da Grade de Aprovacao

@author odair.ferraz

@since 26/10/2018
@version 12.7.17
/*/
//-------------------------------------------------------------------
User Function MFCOM14A()

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaSE2	:= SE2->(GetArea())
	Local aAreaSC8	:= SC8->(GetArea())
	Local cFilBkp := cFilAnt
	Local cAlias := oBrowse:Alias()

	// Parametros abaixo foram informados. Pois, atraves de testes verifiquei que nao influenciam em nada na rotina.// Odair Ferraz - Totvs
	Private MV_PAR01 	:= 	''                      // Do Produto
	Private MV_PAR02	:=	'ZZZZZZZZZZZZZZ'		// Ate Produto
	Private MV_PAR03 	:= 	1						// Traz Cota��o Marcada    - SIM / NAO --> 0 ou '' (erro)
	Private MV_PAR04	:=	1   					// Analisa Proposta por    - Item / Proposta --> 0 ou '' (erro)
	Private MV_PAR05	:=	1						// Peso Preco
	Private MV_PAR06	:=	1						// Peso Prazo
	Private MV_PAR07	:=	1						// Peso Nota

	dbSelectArea("SCR")
	SCR->(DbSetOrder(0))
	SCR->(DbGoTo((cAlias)->RECSCR))

	cFilAnt := (cAlias)->CR_FILIAL

	If AllTrim(SCR->CR_TIPO) == 'SC'
		dbSelectArea('SC8')
		SC8->(DbOrderNickName('NUMSC'))
		If SC8->(dbSeek(xFilial('SC8') + AllTrim(SCR->CR_NUM)))
			U_xM24MAPCot()
		Else
			MSGALERT('Nao  existe Mapa de Cota��o para o documento selecionado !!!','A T E N � � O !!!')
		EndIf
	ElseIf AllTrim(SCR->CR_TIPO) == 'PC'
		dbSelectArea('SC8')
		SC8->(DbOrderNickName('PDCOMPRAS'))
		If SC8->(dbSeek(xFilial('SC8') + AllTrim(SCR->CR_NUM)))
			U_xM24MAPCot()
		Else
			MSGALERT('Nao  existe Mapa de Cota��o para o documento selecionado !!!','A T E N � � O !!!')
		EndIf
	EndIf

	cFilAnt := cFilBkp

	RestArea(aAreaSE2)
	RestArea(aAreaSC7)
	RestArea(aAreaSC1)
	RestArea(aAreaSC8)
	RestArea(aArea)

Return()


//JONI
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definicao do modelo de Dados

@author leonardo.quintania

@since 27/08/2013
@version 1.0
/*/
//-------------------------------------------------------------------

Static function ModelDef()

	Local oModel
	Local oStr1 := FWFormStruct(1,'SCR',{|cCampo| AllTrim(cCampo) $ "CR_NUM|CR_TOTAL|CR_EMISSAO|CR_DATALIB|CR_OBS|CR_GRUPO|CR_ITGRP|CR_APROV|CR_STATUS|CR_ZUSELIB|CR_ZAPRLIB|CR_ZCODGRD|CR_ZVERSAO|CR_ZGRPPRD|CR_ZNATURE|CR_ZNATDES|CR_ZVENCIM|CR_ZNOMFOR|CR_ZCODSOL|CR_ZNOMSOL|CR_ZCODCOM|CR_ZNOMCOM"})
	//Local oStr2 := FWFormStruct(1,'DBL',{|cCampo| !AllTrim(cCampo) $ "DBL_GRUPO|DBL_ITEM"})
	Local oStr4 := NIL

	If SCR->CR_TIPO == 'IP'
		oStr4:= FWFormStruct(1,'SC7',{|cCampo| AllTrim(cCampo) $ "C7_ITEM|C7_PRODUTO|C7_DESCRI|C7_UM|C7_SEGUM|C7_QUANT|C7_PRECO|C7_TOTAL|C7_QTSEGUM|C7_OBSM"})
		oStr4:RemoveField( 'C7_DESC' )
	ElseIf SCR->CR_TIPO == 'SA'
		oStr4:= FWFormStruct(1,'SCP',{|cCampo| AllTrim(cCampo) $ "CP_ITEM|CP_PRODUTO|CP_DESCRI|CP_UM|CP_SEGUM|CP_QUANT|CP_QTSEGUM"})
	ElseIf SCR->CR_TIPO == 'SC'
		oStr4:= FWFormStruct(1,'SC1',{|cCampo| AllTrim(cCampo) $ "C1_NUM|C1_ITEM|C1_PRODUTO|C1_DESCRI|C1_UM|C1_SEGUM|C1_QUANT|C1_QTSEGUM|C1_ZGRPPRD|C1_CC|C1_CONTA|C1_ITEMCTA|C1_CLVL|C1_OBS"})
	ElseIf SCR->CR_TIPO $ 'IC|IR'
		oStr4:= FWFormStruct(1,'CNB',{|cCampo| AllTrim(cCampo) $ "CNB_ITEM|CNB_PRODUT|CNB_DESCRI|CNB_QUANT|CNB_VLUNIT|CNB_VLTOT"})
	ElseIf SCR->CR_TIPO $ 'IM|MD'
		oStr4:= FWFormStruct(1,'CNE',{|cCampo| AllTrim(cCampo) $ "CNE_ITEM|CNE_PRODUT|CNE_QUANT|CNE_VLUNIT|CNE_VLTOT"})
	ElseIf SCR->CR_TIPO == 'PC'
		oStr4:= FWFormStruct(1,'SC7',{|cCampo| AllTrim(cCampo) $ "C7_ITEM|C7_PRODUTO|C7_DESCRI|C7_UM|C7_SEGUM|C7_QUANT|C7_PRECO|C7_TOTAL|C7_QTSEGUM|C7_ZCC|C7_OBSM"})
	ElseIf SCR->CR_TIPO == 'LC'// Caroline Cazela
		oStr4:= FWFormStruct(1,'CT2',{|cCampo| AllTrim(cCampo) $ "CT2_FILIAL|CT2_DATA|CT2_DC|CT2_DEBITO|CT2_CREDIT|CT2_LOTE|CT2_SBLOTE|CT2_DOC|CT2_VALOR|CT2_HIST"})
	EndIf

	oModel := MPFormModel():New('XMGFCOM14',/*PreModel*/, {|oModel| A094TudoOk(oModel)}, { |oModel| A094Commit( oModel ) },/*Cancel*/)
	oModel:SetDescription("Aprovacao de Documentos")

	oModel:addFields('FieldSCR',,oStr1)

	If cOperID == OP_REJ
		oStr1:SetProperty( 'CR_OBS' , MODEL_FIELD_OBRIGAT,.T.)
	EndIf

	If SCR->CR_TIPO $ 'IP|SC|SA|IC|IM|IR|PC|LC|' .and. !(IsBlind()) // Caroline Cazela -> Adicionado tipo LC

		oModel:addGrid('GridDoc','FieldSCR',oStr4)

		If SCR->CR_TIPO == 'SC'
			oModel:SetRelation("GridDoc",{{"C1_FILIAL",'xFilial("SC1")'},{"C1_NUM","ALLTRIM(CR_NUM)"}},SC1->(IndexKey(1)))
		ElseIf SCR->CR_TIPO == 'PC'
			oModel:SetRelation("GridDoc",{{"C7_FILIAL",'xFilial("SC7")'},{"C7_NUM","ALLTRIM(CR_NUM)"}},SC7->(IndexKey(1)))
		ElseIf SCR->CR_TIPO == 'SA'
			oModel:SetRelation("GridDoc",{{"CP_FILIAL",'xFilial("SCP")'},{"CP_NUM","ALLTRIM(CR_NUM)"}},SCP->(IndexKey(1)))
		ElseIf SCR->CR_TIPO == 'LC'  // Caroline Cazela
			oModel:SetRelation("GridDoc",{{"CT2_FILIAL",'xFilial("CT2")'},{"CT2_DATA","SUBSTR(CR_NUM,1,8)"},{"CT2_LOTE","SUBSTR(CR_NUM,9,6)"},{"CT2_SBLOTE","SUBSTR(CR_NUM,15,3)"},{"CT2_DOC","SUBSTR(CR_NUM,18,6)"}},CT2->(IndexKey(1)))
		EndIf

		oModel:getModel('GridDoc'):setOptional(.T.)

		oModel:getModel('GridDoc'):SetOnlyQuery(.T.)
		oModel:getModel('GridDoc'):SetDescription("Itens")
	EndIf

	oModel:SetPrimaryKey( {} ) //Obrigatorio setar a chave primaria (mesmo que vazia)

	oModel:getModel('FieldSCR'):SetDescription("Detalhes da Aprovacao")

	//		Validacao para nao permitir execucao de registros ja processados
	oModel:SetVldActivate( {|oModel| A094VlMod(oModel) } )

	//		Realiza carga dos grids antes da exibicao
	oModel:SetActivate( { |oModel| A094FilPrd( oModel ) } )

return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definicao do interface

@author leonardo.quintania

@since 27/08/2013
@version 1.0
/*/
//-------------------------------------------------------------------
Static function ViewDef()

	Local oView
	Local oModel := ModelDef()
	Local oStr1  := FWFormStruct(2,'SCR',{|cCampo| AllTrim(cCampo) $ "CR_NUM|CR_TOTAL|CR_EMISSAO|CR_DATALIB|CR_OBS|CR_ZCODGRD|CR_ZVERSAO|CR_ZGRPPRD|CR_ZNATURE|CR_ZNATDES|CR_ZVENCIM|CR_ZNOMFOR|CR_ZCODSOL|CR_ZNOMSOL|CR_ZCODCOM|CR_ZNOMCOM"})
	//Local oStr2  := FWFormStruct(2,'DBL',{|cCampo| !AllTrim(cCampo) $ "DBL_GRUPO|DBL_ITEM"})
	Local oStr4  := NIL

	If SCR->CR_TIPO == 'IP'
		oStr4:= FWFormStruct(2,'SC7',{|cCampo| AllTrim(cCampo) $ "C7_ITEM|C7_PRODUTO|C7_DESCRI|C7_UM|C7_SEGUM|C7_QUANT|C7_PRECO|C7_TOTAL|C7_QTSEGUM|C7_OBSM"})
		oStr4:RemoveField( 'C7_DESC' )
	ElseIf SCR->CR_TIPO == 'SA'
		oStr4:= FWFormStruct(2,'SCP',{|cCampo| AllTrim(cCampo) $ "CP_ITEM|CP_PRODUTO|CP_DESCRI|CP_UM|CP_SEGUM|CP_QUANT|CP_QTSEGUM"})
	ElseIf SCR->CR_TIPO == 'SC'
		oStr4:= FWFormStruct(2,'SC1',{|cCampo| AllTrim(cCampo) $ "C1_ITEM|C1_PRODUTO|C1_DESCRI|C1_UM|C1_SEGUM|C1_QUANT|C1_QTSEGUM|C1_ZGRPPRD|C1_CC|C1_CONTA|C1_ITEMCTA|C1_CLVL|C1_OBS"})
	ElseIf SCR->CR_TIPO $ 'IC|IR'
		oStr4:= FWFormStruct(2,'CNB',{|cCampo| AllTrim(cCampo) $ "CNB_ITEM|CNB_PRODUT|CNB_DESCRI|CNB_QUANT|CNB_VLUNIT|CNB_VLTOT"})
	ElseIf SCR->CR_TIPO $ 'IM|MD'
		oStr4:= FWFormStruct(2,'CNE',{|cCampo| AllTrim(cCampo) $ "CNE_ITEM|CNE_PRODUT|CNE_QUANT|CNE_VLUNIT|CNE_VLTOT"})
	ElseIf SCR->CR_TIPO == 'PC'
		oStr4:= FWFormStruct(2,'SC7',{|cCampo| AllTrim(cCampo) $ "C7_ITEM|C7_PRODUTO|C7_DESCRI|C7_UM|C7_SEGUM|C7_QUANT|C7_PRECO|C7_TOTAL|C7_QTSEGUM|C7_ZCC|C7_OBSM"})
	ElseIf SCR->CR_TIPO == 'LC' // Caroline Cazela
		oStr4:= FWFormStruct(2,'CT2',{|cCampo| AllTrim(cCampo) $ "CT2_FILIAL|CT2_DATA|CT2_DC|CT2_DEBITO|CT2_CREDIT|CT2_LOTE|CT2_SBLOTE|CT2_DOC|CT2_VALOR|CT2_HIST"})
	EndIf

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('SCRField' , oStr1,'FieldSCR' )

	If SCR->CR_TIPO $ 'IP|SC|SA|IC|IR|IM|PC|LC|' // Caroline Cazela -> Adicionado tipo LC
		If SCR->CR_TIPO == "LC"
			oStr1:RemoveField('CR_ZGRPPRD')
			oStr1:RemoveField('CR_ZNATURE')
			oStr1:RemoveField('CR_ZNATDES')
			oStr1:RemoveField('CR_ZVENCIM')
			oStr1:RemoveField('CR_ZNOMFOR')
			oStr1:RemoveField('CR_ZCODCOM')
			oStr1:RemoveField('CR_ZNOMCOM')
			oStr1:RemoveField('CR_ZCODSOL')
			oStr1:RemoveField('CR_ZNOMSOL')
		EndIF

		oView:AddGrid('GridDoc'   , oStr4,'GridDoc')
		oStr4:SetProperty( '*' , MVC_VIEW_CANCHANGE ,.F.)
		If SCR->CR_TIPO == "PC"
			oStr4:SetProperty( 'C7_OBSM' , MVC_VIEW_CANCHANGE ,.T.)
		EndIf
		//If SCR->CR_TIPO == "SA"
		//oStr4:SetProperty( 'CP_OBS' , MVC_VIEW_CANCHANGE ,.T.)
		//EndIf
	EndIf

	If SCR->CR_TIPO $ 'IP|SC|SA|IC|IR|IM|PC|LC|' // Caroline Cazela -> Adicionado tipo LC
		oView:CreateHorizontalBox( 'CimaSCR' , 50)
		//oView:CreateHorizontalBox( 'MeioDBL' , 25)
		oView:CreateHorizontalBox( 'BaixoDOC', 50)
	Else
		oView:CreateHorizontalBox( 'CimaSCR' , 100)
	EndIf

	oView:SetOwnerView('SCRField','CimaSCR')
	oView:EnableTitleView('SCRField' , "Dados do Documento"  )

	If SCR->CR_TIPO $ 'IP|SC|SA|IC|IR|IM|PC|LC|'
		oView:SetOwnerView('GridDoc','BaixoDOC')

		oView:EnableTitleView('GridDoc' , "Itens" )
		//oView:SetViewProperty('GridDoc'  , 'ONLYVIEW' )
	EndIf

	oView:SetCloseOnOK({||.T.})

return oView

	//--------------------------------------------------------------------
	/*/{Protheus.doc} A094FilPrd()
	Realiza filtro para carregar os documentos com alcadas
	@author Leonardo Quintania
	@since 28/01/2013
	@version 1.0
	@return .T.
	/*/
//--------------------------------------------------------------------
Static function A094FilPrd(oModel)

	Local oView 		:= FWViewActive()
	Local oFieldSCR 	:= oModel:GetModel("FieldSCR")
	Local oModelGrid 	:= oModel:GetModel("GridDoc")
	Local cIdOption		:= cOperID
	Local cAprovS		:= ""
	Local cMed			:= ""
	Local nLinha		:= 1
	Local aSaldo		:= {}
	Local cDocBkp		:= ""
	Local lSeek     	:= .F.
	Local cNum			:= ""
	Local cRev			:= ""
	Local cPlan			:= ""
	Local cItem			:= ""
	Local cItemRa		:= ""
	Local cDocBkp		:= ""
	Local _dData		:= ""

	// Preenche o campos customizados CR_ZUSELIB,CR_ZAPRLIB
	oFieldSCR:SetValue('CR_ZUSELIB',xxRetUser())

	//oFieldSCR:LoadValue("CR_DATALIB"  , dDataBase   ) //Gatilha Data de liberacao

	oFieldSCR:LoadValue("CR_DATALIB"  , DATE()   ) //Gatilha Data de liberacao

	If cIdOption == OP_TRA .Or. cIdOption == OP_SUP
		aSaldo:= MaSalAlc(cAprovS,MaAlcDtRef(cAprovS,oFieldSCR:GetValue("CR_DATALIB"))) //Calcula saldo na data
	ElseIf cIdOption == OP_LIB
		aSaldo:= MaSalAlc(SCR->CR_APROV,MaAlcDtRef(SCR->CR_APROV,oFieldSCR:GetValue("CR_DATALIB"))) //Calcula saldo na data
	ElseIf cIdOption == OP_REJ .Or. cIdOption == OP_BLQ
		aSaldo:= MaSalAlc(SCR->CR_APROV,MaAlcDtRef(SCR->CR_APROV,oFieldSCR:GetValue("CR_DATALIB"))) //Calcula saldo na data
	EndIf

	If SCR->CR_TIPO $ 'IP|SC|SA|IC|IR|IM|'

		//Configura modelo
		oModelGrid:SetNoInsertLine( .F. )
		oModelGrid:SetNoDeleteLine( .F. )

		//Procura na tabela de Itens(DBM)
		BeginSQL Alias "DBMTMP"
			SELECT
				DBM.DBM_NUM,
				DBM.DBM_ITEM,
				DBM.DBM_ITEMRA
			FROM
				%Table:DBM% DBM
			WHERE
				DBM.DBM_FILIAL=%xFilial:DBM% AND
				DBM.DBM_NUM = %Exp:SCR->CR_NUM% AND
				DBM.DBM_ITGRP = %Exp:SCR->CR_ITGRP% AND
				DBM.DBM_GRUPO = %Exp:SCR->CR_GRUPO% AND
				DBM.DBM_USER = %Exp:SCR->CR_USER% AND
				DBM.DBM_USAPRO = %Exp:SCR->CR_APROV% AND
				DBM.%NotDel%
		EndSQL
	EndIf

	If SCR->CR_TIPO == 'IP'

		While !DBMTMP->(EOF())
			cNum	:= AllTrim(DBMTMP-> DBM_NUM)
			cItem	:= AllTrim(DBMTMP-> DBM_ITEM)
			cItemRa:= AllTrim(DBMTMP-> DBM_ITEMRA)

			If SC7->(dbSeek(xFilial("SC7")+ cNum + cItem ) )
				If cDocBkp <> cNum + cItem
					If nLinha # 1
						oModelGrid:AddLine()
					EndIf
					oModelGrid:GoLine( nLinha )
					oModelGrid:LoadValue("C7_ITEM"		, SC7->C7_ITEM    )
					oModelGrid:LoadValue("C7_PRODUTO" 	, SC7->C7_PRODUTO )
					oModelGrid:LoadValue("C7_DESCRI"	, SC7->C7_DESCRI  )
					oModelGrid:LoadValue("C7_UM"		, SC7->C7_UM      )
					oModelGrid:LoadValue("C7_SEGUM"		, SC7->C7_SEGUM   )
					oModelGrid:LoadValue("C7_PRECO"		, SC7->C7_PRECO   )
					//oFieldSCR:LoadValue("CR_FORNECE"  ,POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA ,"A2_NOME"))

					SCH->(dbSetOrder(2))
					If SCH->(dbSeek(xFilial("SCH")+ cNum + cItem + cItemRa ) )
						oModelGrid:LoadValue("C7_QUANT"		, SC7->C7_QUANT	* (SCH->CH_PERC/100) )
						oModelGrid:LoadValue("C7_TOTAL"		, SC7->C7_TOTAL	* (SCH->CH_PERC/100) )
						oModelGrid:LoadValue("C7_QTSEGUM"	, SC7->C7_QTSEGUM	* (SCH->CH_PERC/100) )
						cDocBkp:= cNum+cItem
					Else
						oModelGrid:LoadValue("C7_QUANT"		, SC7->C7_QUANT	)
						oModelGrid:LoadValue("C7_TOTAL"		, SC7->C7_TOTAL	)
						oModelGrid:LoadValue("C7_QTSEGUM"	, SC7->C7_QTSEGUM	)
						cDocBkp:= cNum+cItem
					EndIf
					nLinha++
				Else
					SCH->(dbSetOrder(2))
					If SCH->(dbSeek(xFilial("SCH")+ cNum + cItem + cItemRa ) )
						oModelGrid:LoadValue("C7_QUANT"		, oModelGrid:GetValue("C7_QUANT") 	 + ( SC7->C7_QUANT	*(SCH->CH_PERC/100) ) )
						oModelGrid:LoadValue("C7_TOTAL"		, oModelGrid:GetValue("C7_TOTAL") 	 + ( SC7->C7_TOTAL	*(SCH->CH_PERC/100) ) )
						oModelGrid:LoadValue("C7_QTSEGUM"	, oModelGrid:GetValue("C7_QTSEGUM") + ( SC7->C7_QTSEGUM	*(SCH->CH_PERC/100) ) )
						cDocBkp:= cNum+cItem
					EndIf
				EndIf
			EndIf
			DBMTMP->(dbSkip())
		EndDo
	ElseIf SCR->CR_TIPO == 'SA'

		While !DBMTMP->(EOF())
			cNum	:= AllTrim(DBMTMP-> DBM_NUM)
			cItem	:= AllTrim(DBMTMP-> DBM_ITEM)
			cItemRa:= AllTrim(DBMTMP-> DBM_ITEMRA)

			If SCP->(dbSeek(xFilial("SCP")+ cNum + cItem ) )
				If cDocBkp <> cNum + cItem
					If nLinha # 1
						oModelGrid:AddLine()
					EndIf
					oModelGrid:GoLine( nLinha )
					oModelGrid:LoadValue("CP_ITEM"		, SCP->CP_ITEM    )
					oModelGrid:LoadValue("CP_PRODUTO" 	, SCP->CP_PRODUTO )
					oModelGrid:LoadValue("CP_DESCRI"	, SCP->CP_DESCRI  )
					oModelGrid:LoadValue("CP_UM"		, SCP->CP_UM      )

					SGS->(dbSetOrder(1))
					If SGS->(dbSeek(xFilial("SGS")+ cNum + cItem + cItemRa ) )
						oModelGrid:LoadValue("CP_QUANT"		, SCP->CP_QUANT	* (SGS->GS_PERC/100) )
						oModelGrid:LoadValue("CP_QTSEGUM"	, SCP->CP_QTSEGUM	* (SGS->GS_PERC/100) )
						cDocBkp:= cNum+cItem
					Else
						oModelGrid:LoadValue("CP_QUANT"		, SCP->CP_QUANT	)
						oModelGrid:LoadValue("CP_QTSEGUM"	, SCP->CP_QTSEGUM	)
						cDocBkp:= cNum+cItem
					EndIf
					nLinha++
				Else
					SGS->(dbSetOrder(1))
					If SGS->(dbSeek(xFilial("SGS")+ cNum + cItem + cItemRa ) )
						oModelGrid:LoadValue("CP_QUANT"		, oModelGrid:GetValue("CP_QUANT") 	 + ( SCP->CP_QUANT	*(SGS->GS_PERC/100) ) )
						oModelGrid:LoadValue("CP_QTSEGUM"	, oModelGrid:GetValue("CP_QTSEGUM") + ( SCP->CP_QTSEGUM	*(SGS->GS_PERC/100) ) )
						cDocBkp:= cNum+cItem
					EndIf
				EndIf
			EndIf
			DBMTMP->(dbSkip())
		EndDo

	ElseIf SCR->CR_TIPO == 'SC'

		While !DBMTMP->(EOF())
			cNum	:= AllTrim(DBMTMP-> DBM_NUM)
			cItem	:= AllTrim(DBMTMP-> DBM_ITEM)
			cItemRa:= AllTrim(DBMTMP-> DBM_ITEMRA)

			If SC1->(dbSeek(xFilial("SC1")+ cNum + cItem ) )
				If cDocBkp <> cNum + cItem
					If nLinha # 1
						oModelGrid:AddLine()
					EndIf
					oModelGrid:GoLine( nLinha )
					oModelGrid:LoadValue("C1_ITEM"		, SC1->C1_ITEM    )
					oModelGrid:LoadValue("C1_PRODUTO" 	, SC1->C1_PRODUTO )
					oModelGrid:LoadValue("C1_DESCRI"	, SC1->C1_DESCRI  )
					oModelGrid:LoadValue("C1_UM"		, SC1->C1_UM      )

					SCX->(dbSetOrder(1))
					If SCX->(dbSeek(xFilial("SCX")+ cNum + cItem + cItemRa ) )
						oModelGrid:LoadValue("C1_QUANT"		, SC1->C1_QUANT	* (SCX->CX_PERC/100) )
						oModelGrid:LoadValue("C1_QTSEGUM"	, SC1->C1_QTSEGUM	* (SCX->CX_PERC/100) )
						cDocBkp:= cNum+cItem
					Else
						oModelGrid:LoadValue("C1_QUANT"		, SC1->C1_QUANT	)
						oModelGrid:LoadValue("C1_QTSEGUM"	, SC1->C1_QTSEGUM	)
						cDocBkp:= cNum+cItem
					EndIf
					nLinha++
				Else
					SCX->(dbSetOrder(1))
					If SCX->(dbSeek(xFilial("SCX")+ cNum + cItem + cItemRa ) )
						oModelGrid:LoadValue("C1_QUANT"		, oModelGrid:GetValue("C1_QUANT") 	 + ( SC1->C1_QUANT	*(SCX->CX_PERC/100) ) )
						oModelGrid:LoadValue("C1_QTSEGUM"	, oModelGrid:GetValue("C1_QTSEGUM") + ( SC1->C1_QTSEGUM	*(SCX->CX_PERC/100) ) )
						cDocBkp:= cNum+cItem
					EndIf
				EndIf
			EndIf
			DBMTMP->(dbSkip())
		EndDo

	ElseIf SCR->CR_TIPO $ 'IC|IR'
		While !DBMTMP->(EOF())
			cItem	:= AllTrim(DBMTMP->DBM_ITEM)
			cItemRa:= DBMTMP->DBM_ITEMRA

			If SCR->CR_TIPO = 'IC'
				cNum	:= Left(AllTrim(DBMTMP-> DBM_NUM),Len(CNB->CNB_CONTRA))
				cRev	:= "   "
				cPlan	:= SubStr(DBMTMP->DBM_NUM,Len(CNB->CNB_CONTRA)+1,Len(CNB->CNB_NUMERO))
				cItem	:= AllTrim(DBMTMP->DBM_ITEM)
				CNB->(dbSetOrder(3))
				lSeek	:= CNB->(dbSeek(xFilial("CNB")+cNum+cPlan+cItem))
				lComp	:= cDocBkp <> cNum+cPlan+cItem
			ElseIf SCR->CR_TIPO = 'IR'
				cNum	:= Left(AllTrim(DBMTMP-> DBM_NUM),Len(CNB->CNB_CONTRA)+Len(CNB->CNB_REVISA))
				cRev	:= ""
				cPlan	:= SubStr(DBMTMP->DBM_NUM,Len(CNB->CNB_CONTRA)+Len(CNB->CNB_REVISA)+1,Len(CNB->CNB_NUMERO))
				cItem	:= AllTrim(DBMTMP->DBM_ITEM)
				CNB->(dbSetOrder(1))
				lSeek := CNB->(dbSeek(xFilial("CNB")+cNum+cPlan+cItem))
				lComp	:= cDocBkp <> cNum+cPlan+cItem
			EndIf
			If lSeek
				If lComp
					If nLinha # 1
						oModelGrid:AddLine()
					EndIf
					oModelGrid:GoLine( nLinha )
					oModelGrid:LoadValue("CNB_ITEM"		, CNB->CNB_ITEM   )
					oModelGrid:LoadValue("CNB_PRODUT"  , CNB->CNB_PRODUT )
					oModelGrid:LoadValue("CNB_DESCRI"	, CNB->CNB_DESCRI )
					oModelGrid:LoadValue("CNB_VLUNIT"	, CNB->CNB_VLUNIT )

					CNZ->(dbSetOrder(1))
					If CNZ->(dbSeek(xFilial("CNZ")+cNum+cRev+cPlan+cItem+cItemRa))
						oModelGrid:LoadValue("CNB_QUANT"	, CNB->CNB_QUANT	* (CNZ->CNZ_PERC/100))
						oModelGrid:LoadValue("CNB_VLTOT"	, CNB->CNB_VLTOT	* (CNZ->CNZ_PERC/100))
					Else
						oModelGrid:LoadValue("CNB_QUANT"	, CNB->CNB_QUANT	)
						oModelGrid:LoadValue("CNB_VLTOT"	, CNB->CNB_VLTOT	)
					EndIf
					nLinha++
				Else
					CNZ->(dbSetOrder(1))
					If CNZ->(dbSeek(xFilial("CNZ")+cNum+cRev+cPlan+cItem+cItemRa))
						oModelGrid:LoadValue("CNB_QUANT"		, oModelGrid:GetValue("CNB_QUANT") 	 + ( CNB->CNB_QUANT	*(CNZ->CNZ_PERC/100) ) )
						oModelGrid:LoadValue("CNB_VLTOT"		, oModelGrid:GetValue("CNB_VLTOT") 	 + ( CNB->CNB_VLTOT	*(CNZ->CNZ_PERC/100) ) )
					EndIf
				EndIf
				cDocBkp:= cNum+cPlan+cItem
			EndIf
			DBMTMP->(dbSkip())
		EndDo

	ElseIf SCR->CR_TIPO $ 'IM'
		While !DBMTMP->(EOF())
			cItem	:= AllTrim(DBMTMP->DBM_ITEM)
			cItemRa:= DBMTMP->DBM_ITEMRA
			cNum := Left(AllTrim(DBMTMP->DBM_NUM),Len(CND->CND_NUMMED))

			CNE->(dbSetOrder(1))
			lSeek := CNE->(MsSeek(xFilial("CND")+CND->(CND_CONTRA+CND_REVISA+CND_NUMERO+CND_NUMMED)+cItem))
			lComp	:= cDocBkp <> cNum+cItem+cItemRa

			If lSeek
				If lComp
					If nLinha # 1
						oModelGrid:AddLine()
					EndIf
					oModelGrid:GoLine( nLinha )

					oModelGrid:LoadValue("CNE_ITEM"		, CNE->CNE_ITEM   )
					oModelGrid:LoadValue("CNE_PRODUT"  , CNE->CNE_PRODUT )
					oModelGrid:LoadValue("CNE_VLUNIT"	, CNE->CNE_VLUNIT )

					CNZ->(dbSetOrder(2))
					If CNZ->(dbSeek(xFilial("CNZ")+CNE->(CNE_CONTRA+CNE_REVISA+CNE_NUMMED)+cItem+cItemRa))
						oModelGrid:LoadValue("CNE_QUANT", CNE->CNE_QUANT	* (CNZ->CNZ_PERC/100))
						oModelGrid:LoadValue("CNE_VLTOT", CNE->CNE_VLTOT	* (CNZ->CNZ_PERC/100))

					Else
						CNZ->(dbSetOrder(1))
						If CNZ->(dbSeek(xFilial("CNZ")+CNE->(CNE_CONTRA+CNE_REVISA+CNE_NUMERO)+cItem+cItemRa))
							oModelGrid:LoadValue("CNE_QUANT", CNE->CNE_QUANT	* (CNZ->CNZ_PERC/100))
							oModelGrid:LoadValue("CNE_VLTOT", CNE->CNE_VLTOT	* (CNZ->CNZ_PERC/100))
						Else
							oModelGrid:LoadValue("CNE_QUANT", CNE->CNE_QUANT	)
							oModelGrid:LoadValue("CNE_VLTOT", CNE->CNE_VLTOT	)
						EndIf
					EndIf
					nLinha++
				Else
					CNZ->(dbSetOrder(2))
					If CNZ->(dbSeek(xFilial("CNZ")+CNE->(CNE_CONTRA+CNE_REVISA+CNE_NUMMED)+cItem+cItemRa))
						oModelGrid:LoadValue("CNE_QUANT", oModelGrid:GetValue("CNE_QUANT") + (CNE->CNE_QUANT * (CNZ->CNZ_PERC/100) ) )
						oModelGrid:LoadValue("CNE_VLTOT", oModelGrid:GetValue("CNE_VLTOT") + (CNE->CNE_VLTOT * (CNZ->CNZ_PERC/100) ) )
					Else
						CNZ->(dbSetOrder(1))
						If CNZ->(dbSeek(xFilial("CNZ")+CNE->(CNE_CONTRA+CNE_REVISA+CNE_NUMERO)+cItem+cItemRa))
							oModelGrid:LoadValue("CNE_QUANT", oModelGrid:GetValue("CNE_QUANT") + (CNE->CNE_QUANT * (CNZ->CNZ_PERC/100) ) )
							oModelGrid:LoadValue("CNE_VLTOT", oModelGrid:GetValue("CNE_VLTOT") + (CNE->CNE_VLTOT * (CNZ->CNZ_PERC/100) ) )
						EndIf
					EndIf
				EndIf
				cDocBkp:= cNum+cItem+cItemRa
			EndIf
			DBMTMP->(dbSkip())
		EndDo

	EndIf

	If SCR->CR_TIPO $ 'IP|SC|SA|IC|IR|IM'

		DBMTMP->(dbCloseArea())

		//--------------------------------------
		//		Configura permissao dos modelos
		//--------------------------------------
		oModelGrid:GoLine( 1 )
		oModelGrid:SetNoInsertLine( .T. )
		oModelGrid:SetNoDeleteLine( .T. )
	EndIf

	If SCR->CR_TIPO $ 'RV'
		//-- Atalho para config. dos parametros
		//-- mv_par01 - Mostra Lancamentos: S/N
		//-- mv_par02 - Aglut Lancamentos:  S/N
		//-- mv_par03 - Lancamentos Online: S/N
		SetKey(VK_F12,{|| Pergunte("CNT100",.T.)})
		Pergunte("CNT100",.F.)
	EndIf

return .T.

	//--------------------------------------------------------------------
	/*/{Protheus.doc} A094Commit()
	Realiza gravacao manual dos campos de filtros e realiza processamento de calculos
	@author Leonardo Quintania
	@since 30/08/2013
	@version 1.0
	@return NIL
	/*/
//--------------------------------------------------------------------
Static function A094Commit(oModel)
	Local cError    := ''
	//Local oView 		:= FWViewActive()
	Local cIdOption	:= cOperID
	Local aArea		:= GetArea()
	Local aAreaCND
	Local aCabCN120	:= {}
	Local aItCN120 	:= {}
	Local lRet			:= .T.

	PRIVATE lMsErroAuto := .F.

	BEGIN TRANSACTION
		If FWFormCommit(oModel)

			Do Case
			Case SCR->CR_TIPO == "NF"
				dbSelectArea("SF1")
				dbSetOrder(1)
				MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))

			Case SCR->CR_TIPO == "SC"
				dbSelectArea("SC1")
				dbSetOrder(1)
				MsSeek(xFilial("SC1",SCR->CR_FILIAL)+Substr(SCR->CR_NUM,1,len(SC1->C1_NUM)))

			Case SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
				dbSelectArea("SC7")
				dbSetOrder(1)
				MsSeek(xFilial("SC7",SCR->CR_FILIAL)+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))

			Case SCR->CR_TIPO == "SA"
				dbSelectArea("SCP")
				dbSetOrder(1)
				MsSeek(xFilial("SCP",SCR->CR_FILIAL)+Substr(SCR->CR_NUM,1,len(SCP->CP_NUM)))

			Case SCR->CR_TIPO == "CP"
				dbSelectArea("SC3")
				dbSetOrder(1)
				MsSeek(xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)))
				cGrupo := SC3->C3_APROV

			Case SCR->CR_TIPO == "ST"
				DbSelectArea("NNS")
				DbSetOrder(1)
				MsSeek(xFilial("NNS")+Substr(SCR->CR_NUM,1,Len(NNS->NNS_COD)))

			Case SCR->CR_TIPO == "CT"
				dbSelectArea("CN9")
				dbSetOrder(1)
				MsSeek(xFilial("CN9")+Substr(SCR->CR_NUM,1,len(CN9->CN9_NUMERO)))
				cGrupo := CN9->CN9_APROV

			CASE SCR->CR_TIPO $ "RV|IR|IC"
				dbSelectArea("CN9")
				dbSetOrder(1)
				MsSeek(xFilial("CN9")+Substr(SCR->CR_NUM,1,Len(CN9->CN9_NUMERO) + Len(CN9->CN9_REVISA)))
				cGrupo := CN9->CN9_APROV

			Case SCR->CR_TIPO $ "MD|IM"
				dbSelectArea("CND")
				dbSetOrder(4)
				MsSeek(xFilial("CND")+Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED)))
				cGrupo := CND->CND_APROV

			Case SCR->CR_TIPO $ "ZC"
				dbSelectArea("SE2")
				dbSetOrder(1)//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
				MsSeek(xFilial("SE2",SCR->CR_FILIAL) + Substr(SCR->CR_NUM,1,len(SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA))))
				cGrupo := SCR->CR_GRUPO

			Case SCR->CR_TIPO == "LC"
				dbSelectArea("CT2")
				dbSetOrder(1)
				MsSeek(xFilial("CT2",SCR->CR_FILIAL) + alltrim(SCR->CR_NUM))
			EndCase

			If cIdOption == OP_LIB //Liberacao
				If SCR->CR_TIPO $ "CT|IC|RV|IR|MD|IM"
					lRet := GCTAlcEnt(oModelCT,MODEL_OPERATION_UPDATE,4,SCR->CR_TIPO,SCR->CR_NUM,,)

					If lRet .AND. SCR->CR_TIPO $ "MD|IM" .AND. MtGLastDBM(SCR->CR_TIPO,SCR->CR_NUM) .AND. SuperGetMV("MV_CNMDEAT",.F.,.F.)

						aAdd(aCabCN120,{"CND_CONTRA",CND->CND_CONTRA,NIL})
						aAdd(aCabCN120,{"CND_REVISA",CND->CND_REVISA,NIL})
						aAdd(aCabCN120,{"CND_COMPET",CND->CND_COMPET,NIL})
						aAdd(aCabCN120,{"CND_NUMERO",CND->CND_NUMERO,NIL})
						aAdd(aCabCN120,{"CND_NUMMED",CND->CND_NUMMED,NIL})
						aAdd(aCabCN120,{"CND_PARCEL",CND->CND_PARCEL,NIL})
						MsExecAuto({|a,b,c|,CNTA120(a,b,c)},aCabCN120,aItCN120,6)

						If lMsErroAuto
							If (!IsBlind()) // COM INTERFACE GRAFICA
								MostraErro()
							Else // EM ESTADO DE JOB
								cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO

								ConOut(PadC("Automatic routine ended with error", 80))
								ConOut("Error: "+ cError)
							EndIf
							lMsErroAuto:= .F.
							DisarmTransaction()
						EndIf
					EndIf
				Else
					If SCR->CR_TIPO $ 'ZC|PC|SC|SA|LC|'
						xLIbZC(SCR->(Recno()),2,,,,,,oModelCT)
					Else
						A097ProcLib(SCR->(Recno()),2,,,,,,oModelCT)
					EndIf

					If SCR->CR_TIPO $ 'SC|PC|ZC|SA|LC|'
						If SCR->CR_TIPO == 'SC'
							dbSelectArea('SC1')
							SC1->(dbSetOrder(1))
							SC1->(dbSeek(xFilial('SC1',SCR->CR_FILIAL) + Substr(SCR->CR_NUM,1,len(SC1->C1_NUM))))
						ElseIf SCR->CR_TIPO == 'PC'
							dbSelectArea('SC7')
							SC7->(dbSetOrder(1))
							SC7->(dbSeek(xFilial('SC7',SCR->CR_FILIAL) + Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))))
						ElseIf SCR->CR_TIPO == 'SA'
							dbSelectArea('SCP')
							SCP->(dbSetOrder(1))
							SCP->(dbSeek(xFilial('SCP',SCR->CR_FILIAL) + Substr(SCR->CR_NUM,1,len(SCP->CP_NUM))))
						ElseIf SCR->CR_TIPO == 'ZC'
							dbSelectArea('SE2')
							SE2->(dbSetOrder(1))
							SE2->(dbSeek(xFilial('SE2',SCR->CR_FILIAL) + Substr(SCR->CR_NUM,1,Len(SE2->E2_PREFIXO) + Len(SE2->E2_NUM) + Len(SE2->E2_PARCELA) + Len(SE2->E2_TIPO) + Len(SE2->E2_FORNECE) + Len(SE2->E2_LOJA))))
						ElseIf SCR->CR_TIPO == 'LC'
							dbSelectArea('CT2')
							CT2->(dbSetOrder(1))
							CT2->(dbSeek(xFilial('CT2',SCR->CR_FILIAL) + alltrim(SCR->CR_NUM)))
						EndIf
					EndIf
				EndIf
			ElseIf cIdOption == OP_REJ //Rejeicao

				If SCR->CR_TIPO $ 'SC|PC|SA|LC|'
					U_xRejSCR({SCR->CR_NUM,SCR->CR_TIPO	, , , ,SCR->CR_GRUPO,,,,DATE(),FwFldGet("CR_OBS")}, DATE() ,7)
				Else
					MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO	, , , ,SCR->CR_GRUPO,,,,DATE(),FwFldGet("CR_OBS")}, DATE() ,7)
				EndIf

			ElseIf cIdOption == OP_BLQ //Bloqueio
				If SCR->CR_TIPO $ 'ZC|PC|SC|SA|LC|'
					xLIbZC(SCR->(Recno()),6,,,,FwFldGet("CR_OBS"))
				Else
					A097ProcLib(SCR->(Recno()),6,,,,FwFldGet("CR_OBS"))
				EndIf

			EndIf

		EndIf

	END TRANSACTION

	RestArea(aArea)

return .T.

Static function xIntFluig(cTpLib,cUserApr,cUserSub,cTpDoc)

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aItem 	:= {}

	Local oModel	:= FwModelActive()
	Local oMdlSCR	:= oModel:GetModel('FieldSCR')
	Local oObj 		:= WSECMWorkflowEngineServiceService():New()
	Local oResulObj := nil

	Local ni
	Local nf
	Local nChosse 	:= 0
	Local nTamChv	:= TamSx3('E2_PREFIXO')[1] + TamSx3('E2_NUM')[1] + TamSx3('E2_PARCELA')[1] + TamSx3('E2_TIPO')[1] + TamSx3('E2_FORNECE')[1] + TamSx3('E2_LOJA')[1]

	Local cCodFlg	:= ''
	Local cNumApr	:= ''
	Local cObs		:= oMdlSCR:GetValue('CR_OBS')
	Local cText		:= ''

	If cTpDoc == 'SC'
		dbSelectArea('SC1')
		SC1->(dbSetOrder(1))
		If SC1->(dbSeek(xFilial('SC1') + SUBSTR(SCR->CR_NUM,1,TamSX3('C1_NUM')[1])))
			While SC1->(!EOF()) .and. SC1->(C1_FILIAL + C1_NUM) == xFilial('SC1') + SUBSTR(SCR->CR_NUM,1,TamSX3('C1_NUM')[1])
				cCodFlg := SC1->C1_ZCODFLG

				RecLock('SC1')
				SC1->C1_ZBLQFLG := 'S'
				SC1->(MsUnlock())

				SC1->(dbSkip())
			EndDo
		EndIf
	ElseIf cTpDoc == 'PC'
		dbSelectArea('SC7')
		SC1->(dbSetOrder(1))
		If SC7->(dbSeek(xFilial('SC7') + SUBSTR(SCR->CR_NUM,1,TamSX3('C7_NUM')[1])))
			While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == xFilial('SC7') + SUBSTR(SCR->CR_NUM,1,TamSX3('C7_NUM')[1])
				cCodFlg := SC7->C7_ZCODFLG
				RecLock('SC7')
				SC7->C7_ZBLQFLG := 'S'
				SC7->(MsUnlock())
				SC7->(dbSkip())
			EndDo
		EndIf
	ElseIf cTpDoc == 'ZC'
		dbSelectArea('SE2')
		SE2->(dbSetOrder(1))
		If SE2->(dbSeek(xFilial('SE2') + SUBSTR(SCR->CR_NUM,1,nTamChv)))
			cCodFlg := SE2->E2_ZCODFLG
			RecLock('SE2')
			SE2->E2_ZBLQFLG := 'S'
			SC7->(MsUnlock())
			SC7->(dbSkip())
		EndIf
	EndIf

	If cTpLib == 'AP'
		nChosse := 9
		cText	:= "Aprovac�o via Protheus"
	ElseIf cTpLib == 'RP'
		nChosse := 10
		cText	:= "Reprovado via Protheus"
	ElseIf cTpLib == 'BL'
		nChosse := 35
		cText	:= "Bloqueado via Protheus"
	EndIf

	If cTpLib $ 'AP|RP|BL'

		oObj:cusername			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGUSR")		//("MV_FLGUSR",,"cristina.poffo@totvs.com.br")
		oObj:cpassword			:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
		oObj:cuserId			:= cUserApr//xxRetUser()//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
		oObj:ncompanyId			:= 1
		oObj:nProcessInstanceId	:= Val(cCodFlg)//"saveAndSendTaskClassic"
		oObj:nchoosedState		:= nChosse //9 = Aprovado, 10 = reprovado, 35 = Bloqueado
		oObj:ccomments 			:= cText
		oObj:lcompleteTask		:= .T.
		oObj:lmanagerMode		:= .F.
		oObj:nThreadSequence 	:= 0

		oObj:getInstanceCardData()
		aItem := oObj:oWSgetInstanceCardDataCardData:oWSitem

		//Indica que a solicitacao foi movimentada pelo Protheus
		For ni:= 1 to Len(aItem)

			If UPPER(AllTrim(aItem[ni]:cITEM[1])) == 'HUSERPROTHEUS'
				aItem[ni]:cITEM[2] := 'true'
				Exit
			EndIf

		Next ni

		//Inidica qual o Aprovador Atual
		For ni:= 1 to Len(aItem)

			If UPPER(AllTrim(aItem[ni]:cITEM[1])) == 'HIDXAPROVATUAL'
				cNumApr	:= aItem[ni]:cITEM[2]
				Exit
			EndIf

		Next ni

		//Atualiza a Observacao
		For ni:= 1 to Len(aItem)

			If UPPER(AllTrim(aItem[ni]:cITEM[1])) == 'TOBSAPROVADOR___' + Alltrim(cNumApr)
				aItem[ni]:cITEM[2] := cObs
				Exit
			EndIf

		Next ni

		If  Alltrim(cUserApr) == Alltrim(cUserSub)

			oObj:oWsSaveAndSendTaskAppointment := ECMWorkflowEngineServiceService_processTaskAppointmentDto():New()
			oObj:oWsSaveAndSendTaskAttachments := ECMWorkflowEngineServiceService_processAttachmentDto():New()
			oObj:oWsSaveAndSendTaskCardData:oWSItem := aItem

			oObj:saveAndSendTask()
			If Val(oObj:oWsSaveAndSendTaskResult:oWsItem[1]:cItem[2]) == nChosse
				Alert('Deu Fluigueira')
			Else
				Alert('Erro de integracao: ' + Alltrim(oObj:oWsSaveAndSendTaskResult:oWsItem[1]:cItem[2]) )
			EndIf

		Else

			oObj:oWsSaveAndSendTaskByReplacementAppointment := ECMWorkflowEngineServiceService_processTaskAppointmentDto():New()
			oObj:oWsSaveAndSendTaskByReplacementAttachments := ECMWorkflowEngineServiceService_processAttachmentDto():New()
			oObj:oWsSaveAndSendTaskByReplacementCardData:oWSItem := aItem

			oObj:cReplacementId := cUserSub
			oObj:saveAndSendTaskByReplacement()

			If Val(oObj:oWsSaveAndSendTaskByReplacementResult:oWsItem[1]:cItem[2]) == nChosse
				Alert('Deu Fluigueira')
			Else
				Alert('Erro de integracao: ' + Alltrim(oObj:oWsSaveAndSendTaskByReplacementResult:oWsItem[1]:cItem[2]) )
			EndIf

		EndIf

	EndIf

	RestArea(aAreaSC1)
	RestArea(aArea)

return

	//--------------------------------------------------------------------
	/*/{Protheus.doc} A094TudoOk()
	Efetua validacoes da aprovacao
	@author Leonardo Quintania
	@since 30/08/2013
	@version 1.0
	@return NIL
	/*/
//--------------------------------------------------------------------
Static function A094TudoOk(oModel)
	Local lRet 		:= .T.
	Local dDataBloq	:= GetNewPar("MV_ATFBLQM",CTOD("")) //Data de Bloqueio da Movimentacao - MV_ATFBLQM
	Local aSaldo 	:= {}
	Local nSaldo 	:= 0
	Local dDataRef	:= cTod("  /  /  ")

	If SCR->CR_TIPO == "RV"
		If CN9->(MsSeek(xFilial("CN9")+AllTrim(SCR->CR_NUM))) //Posiciona no contrato da aprovacao
			//--Popula model da tela de contrato para ser feito validacoes da aprovacao do contrato.
			oModelCT := FWLoadModel(If(CN9->CN9_ESPCTR == "1","CNTA300","CNTA301"))
			oModelCT:SetOperation(MODEL_OPERATION_UPDATE)

			A300SATpRv(Cn300RetSt("TIPREV"))
			oModelCT:Activate()

			If lRet:= cn300VlCau()
				CN0->(MsSeek(xFilial("CN0")+CN9->CN9_TIPREV))
				If lRet .And. CN0->CN0_TIPO == DEF_REV_PARAL
					lRet := CN100Doc(CN9->(Recno()),{DEF_SPARA,DEF_SREVS},.F.)
				Else
					lRet := CN100Doc(CN9->(Recno()),{DEF_SREVS},.F.)
				EndIf
			EndIf
			//--Gera Base Instalada e Ordem de Servico�
			If lRet .And. SuperGetMv("MV_CNINTFS",.F.,.F.) .And. CN9->CN9_ESPCTR == '2'
				lRet := CN100BIns(CN9->CN9_NUMERO,CN9->CN9_REVISA,CN9->CN9_DTASSI)
			EndIf
		EndIf
	ElseIf SCR->CR_TIPO == "CT"
		//Verifica se existe bloqueio contabil
		If lRet := CtbValiDt(Nil, dDataBase,/*.T.*/ ,Nil ,Nil ,{"COM001"}/*,"Data de apuracao bloqueada pelo calend�rio contabil."*/)
			If!Empty(dDataBloq) .AND. ( dDataBase <= dDataBloq)
				//Help(" ",1,"AF012ABLQM",,"Processo bloqueado pelo Calend�rio Cont�bil nesta data ou periodo. Caso possivel altere a data de referencia do processo ou contate o respons�vel pelo Modulo Cont�bil.",1,0) //"Processo bloqueado pelo Calend�rio Cont�bil nesta data ou periodo. Caso possivel altere a data de referencia do processo ou contate o respons�vel pelo Modulo Cont�bil."
				Help(" ",1,"ATFCTBBLQ") //P: Processo bloqueado pelo Calend�rio Cont�bil ou parametro de bloqueio nesta data ou periodo. S: Caso possivel altere a data de referencia do processo, verifique o parametro ou contate o respons�vel pelo Modulo Cont�bil.)
				lRet := .F.
			End
		EndIf


	EndIf

return lRet
	//--------------------------------------------------------------------
	/*/{Protheus.doc} A094VldSup()
	Efetua validacao quando superior mostrando tela de senha do superior
	@author Leonardo Quintania
	@since 23/10/2013
	@version 1.0
	@return NIL
	/*/
//--------------------------------------------------------------------
Static function A094VldSup()
	Local lRet			:= .T.
	Local cAprovS		:= ""
	Local cOriAprov	:= ""
	Local aArea		:= SAK->(GetArea())

	SAK->(dbSetOrder(1))
	SAK->(MsSeek(xFilial("SAK")+SCR->CR_APROV))
	cAprovS:= SAK->AK_APROSUP
	SAK->(dbSetOrder(1))
	SAK->(MsSeek(xFilial("SAK")+cAprovS))
	cOriAprov := SAK->AK_USER
	lRet := A097Pass(cOriAprov)

	RestArea(aArea)

return lRet

	//--------------------------------------------------------------------
	/*/{Protheus.doc} A094VlMod()
	Efetua validacao do modelo de dados
	@author Leonardo Quintania
	@since 28/08/2013
	@version 1.0
	@return lRet
	/*/
//--------------------------------------------------------------------
Static function A094VlMod(oModel)
	Local lRet 		:= .T.
	Local ca094User := xxRetUser()

	If lRet .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS $ "03#05"
		Help(" ",1,"A097LIB")  //Este documento j� foi liberado.#### Escolha outro item que nao foi liberado.
		lRet := .F.
	ElseIf lRet .And. SCR->CR_STATUS $ "01"
		Help(" ",1,"A097BLQ") // Esta operacao nao podera ser realizada pois este registro se encontra bloqueado pelo sistema
		lRet := .F.
	ElseIf lRet .And. SCR->CR_STATUS $ "06"
		Help(" ",1,"A094REJ") // Esta operacao nao podera ser realizada pois este registro se encontra rejeitado pelo sistema
		lRet := .F.

	EndIf


return lRet

Static function xVerFluig(cSolic)

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())

	Local lRet 		:= .T.

	If SCR->CR_TIPO == 'SC'
		dbSelectArea('SC1')
		SC1->(dbSetOrder(1))

		If SC1->(dbSeek(xFilial('SC1') + SUBSTR(cSolic,1,TamSx3('C1_NUM')[1])))
			lRet := SC1->C1_ZBLQFLG == 'N'
		EndIf
	EndIf

	RestArea(aAreaSC1)
	RestArea(aArea)

return lRet



	//--------------------------------------------------------------------
	/*/{Protheus.doc} A094Bloqu()
	Efetua o bloqueio do para os demais usuarios
	@author Leonardo Quintania
	@since 30/08/2013
	@version 1.0
	@return NIL
	/*/
//--------------------------------------------------------------------
User function XMC14Bloqu()

	Local lRet := .T.
	Local cFilBkp := cFilAnt
	Local cAlias := oBrowse:Alias()

	dbSelectArea("SCR")
	SCR->(DbSetOrder(0))
	SCR->(DbGoTo((cAlias)->RECSCR))

	cFilAnt := (cAlias)->CR_FILIAL

	cOperID:= OP_BLQ

	If SCR->CR_STATUS $ "02"
		If FWExecView ("Bloquear", "MGFCOM14", MODEL_OPERATION_UPDATE ,/*oDlg*/ , {||.T.},/*bOk*/ ,/*nPercReducao*/ ,/*aEnableButtons*/ , /*bCancel*/ , /*cOperatId*/ ,/*cToolBar*/,/*oModelAct*/) == 0//"Bloqueio"
			RecLock((cAlias),.F.)
			If mv_par01 == 1 .or. mv_par01 == 2 .or. mv_par01 == 5
				(cAlias)->(DbDelete())
			Else
				(cAlias)->CR_STATUS 	:= '04'
				(cAlias)->CR_ZOK	   := " "
			EndIf
			(cAlias)->(MsUnLock())
		EndIf
	Else
		Help(" ",1,"A097BLOQ")  //Nao e possivel bloquear o documento selecionado.
		lRet := .F.
	EndIf

	cFilAnt := cFilBkp

return .T.

	//--------------------------------------------------------------------
	/*/{Protheus.doc} A94ExLiber()
	Executa ExecView do MGFCOM14 para o botao Liberacao
	@author Leonardo Quintania
	@since 23/10/2013
	@version 1.0
	@alteracao
	********************
	2020-02-26 feature/RTASK0010611-trava-na-libercao-item-marcado
	Quando o registro estiver com flag precisa usar a funcao Liberar Lote,
	para utilizar a funcao Liberar, o registro deve estar com o cursor em
	cima dele, com ou sem flag.
	********************

	@return NIL
	/*/
	//--------------------------------------------------------------------
User function XMC14Libe()

	Local lRet 		:=	.T.
	Local oModel
	Local oMdlSCR
	Local cFilBkp 	:=	cFilAnt
	Local cAlias 	:=	oBrowse:Alias()
	local _mensagem	:=	''
	local _nRec		:=	0
	_nRec := recno(cAlias)
	dbSelectArea("SCR")
	SCR->(DbSetOrder(0))
	SCR->(DbGoTo((cAlias)->RECSCR))

	if !xValLib(1) .and. !IsBlind()
		return .F.
	endif
	(cAlias)->(DbGoTo(_nRec))
	cFilAnt := (cAlias)->CR_FILIAL

	cOperID:= OP_LIB
	If !IsBlind()
		If FWExecView ("Aprovacao de Documentos", "MGFCOM14", MODEL_OPERATION_UPDATE ,/*oDlg*/ , {||.T.},/*bOk*/ ,/*nPercReducao*/ ,/*aEnableButtons*/ , /*bCancel*/ , /*cOperatId*/ ,/*cToolBar*/,/*oModelAct*/) == 0//"Superior"
			RecLock((cAlias),.F.)
			If mv_par01 == 1 .or. mv_par01 == 4 .or. mv_par01 == 5
				(cAlias)->(DbDelete())
			Else
				(cAlias)->CR_STATUS 	:= '03'
				(cAlias)->CR_DATALIB	:= dDataBase
				(cAlias)->CR_ZOK	   := " "
			EndIf
			(cAlias)->(MsUnLock())
		EndIf
	Else

		oModel := FwLoadModel('MGFCOM14')
		oModel:SetOperation( MODEL_OPERATION_UPDATE )

		If oModel:Activate()

			oMdlSCR := oModel:GetModel('FieldSCR')
			oMdlSCR:SetValue('CR_OBS','Aprovado via Job')

			If oModel:VldData()
				oModel:CommitData()
				oModel:DeActivate()
				oModel:Destroy()
			Else
				JurShowErro(oModel:GetModel():GetErrormessage())
			EndIf

		EndIf

	EndIf


	cFilAnt := cFilBkp
return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} xValLib
	Esta funcao � para validar se o usuario esta liberando com o procedimento correto
	caso ele utulize o botao Liberar, nao podera ter nada com flag.
	RTASK0010611
	@type  Static Function
	@author Claudio Alves
	@since 06/02/2020
	@version
	@param 
	@return _lRet para validar a liberacao
	@example
	
	@see (links_or_references)
	/*/
//--------------------------------------------------------------------
Static Function xValLib(_cOrig)
	local _lRet		:=	.F.
	local _nConta	:=	0
	local cAlias 	:=	oBrowse:Alias()
	local _cOrigem	:=	_cOrig
	local _cMsg		:=	''

	dbSelectArea(cAlias)

	_cChave := (cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL)

	(cAlias)->(dbSetOrder(1))//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
	(cAlias)->(dbGoTop())

	While (cAlias)->(!EOF())
		If (cAlias)->CR_ZOK == oBrowse:Mark()
			_lRet	:=	.T.
			_nConta ++
		EndIf
		(cAlias)->(dbSkip())
	EndDo

	if _cOrigem == 1
		if _nConta == 1
			(cAlias)->(dbSeek(_cChave))
			if !((cAlias)->CR_ZOK == oBrowse:Mark())
				_cMsg	:=	 'Para resolver voce deve posicionar o cursor no item com Flag ou usar a "Liberacao Lote"'
				if !IsBlind()
					Help(NIL, NIL, 'MGFCOM14', NIL, 'POSICIONAMENTO DO CURSOR', 1, 0, NIL, NIL, NIL, NIL, NIL, {_cMsg})
					_lRet	:=	.F.
				else
					_lRet	:=	.F.
				endif
			endif
		elseif _nConta > 1
			_cMsg	:=	 'Voc� selecionou ' + alltrim(str(_nConta)) + ' registros, para estes casos deve-se usar a "Liberacao Lote"'
			if !IsBlind()
				Help(NIL, NIL, 'MGFCOM14', NIL, 'SELE��O MAIS DE UM REGISTRO', 1, 0, NIL, NIL, NIL, NIL, NIL, {_cMsg})
				_lRet	:=	.F.
			else
				_lRet	:=	.F.
			endif
		elseif _nConta == 0
			_lRet	:=	.T.
		endif
	else
		if _nConta == 0
			_cMsg	:=	'Nenhum registro selecionado'
		elseif _nConta == 1
			_cMsg	:=	'Foi selecionado ' + alltrim(str(_nConta)) + ' registro, deseja liber�-lo?'
		else
			_cMsg	:=	'Foram selecionados ' + alltrim(str(_nConta)) + ' registros, deseja liber�-los?'
		endif
		if !IsBlind()
			if _nConta == 0
				AVISO("REGISTROS SELECIONADOS", _cMsg, { "Fechar" }, 2)
				_lRet	:=	.F.
			else
				_lRet	:=	iif(AVISO("REGISTROS SELECIONADOS", _cMsg, { "Nao ", "Sim" }, 2) == 1, .F., .T.)
			endif
		else
			_lRet	:=	.T.
		endif
	endif
Return _lRet

//--------------------------------------------------------------------
	/*/{Protheus.doc} A094Rejeita()
	Rejeita a solicitacao de transferencia.
	@author Raphael Augustos
	@since 17/03/2014
	@version 1.0
	@return NIL
	/*/
//--------------------------------------------------------------------
User function XMC14Rej()

	Local lRet := .T.
	Local cFilBkp := cFilAnt
	Local cAlias := oBrowse:Alias()

	dbSelectArea("SCR")
	SCR->(DbSetOrder(0))
	SCR->(DbGoTo((cAlias)->RECSCR))

	cFilAnt := (cAlias)->CR_FILIAL

	cOperID:= OP_REJ

	If SCR->CR_STATUS <> "02"
		lRet := .F.
		Help("",1,"A094REJEIT",,"S� � possivel rejeitar um registro com o status aguardando liberacao.",1,0)
	EndIf

	If !(SCR->CR_TIPO $ "SC|PC|ST|SA|LC|")
		lRet := .F.
		Help("",1,"A094REJEIT",,"S� � possivel rejeitar um registro do tipo SC , SA , LC , PC OU ST.",1,0)
	EndIf

	If lRet
		If FWExecView ("Rejeitar Solicitia��o de Transfer�ncia", "MGFCOM14", MODEL_OPERATION_UPDATE ,/*oDlg*/ , {||.T.},/*bOk*/ ,/*nPercReducao*/ ,/*aEnableButtons*/ , /*bCancel*/ , "004",/*cToolBar*/,/*oModelAct*/) == 0//"Superior"
			// Validacao de gravacao de tipo de saldo 9 e mensagem descritiva da rejeicao conforme opcao escolhida pela pessoa que rejeitou.
			RecLock((cAlias),.F.)
			If mv_par01 == 1 .or. mv_par01 == 2 .or. mv_par01 == 4
				(cAlias)->(DbDelete())
			Else
				(cAlias)->CR_STATUS 	:= '06'
				(cAlias)->CR_DATALIB	:= dDataBase
				(cAlias)->CR_ZOK	   	:= " "
			EndIf
			(cAlias)->(MsUnLock())
		EndIf
	EndIf
	//xDesmark()//Rafael 08/11/2018

	cFilAnt := cFilBkp

return

//////////////////////////////////////////////////////////
// Funcao	| AjustaHlp()
// Autor	| Fernando Amorim(Cafu)
// Data		| 17/12/2015
// Uso		| Ajusta o dicion�rio e help.
//////////////////////////////////////////////////////////
Static function AjustaHlp()

	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	aHelpPor := aHelpEng := aHelpSpa := {'Saldo do aprovador insuficiente ','para aprovacao do documento.'}

	PutHelp("SLDAPROV",aHelpPor,aHelpEng,aHelpSpa,.T.)

return

Static function xxRetUser()

	Local cRet := ''//RetCodUsr()

	If IsBlind()
		If ValType('cxUserAprv') == 'C'
			cRet := cxUserAprv
		Else
			cRet := RetCodUsr()
		EndIf
	Else
		cRet := RetCodUsr()
	EndIf

return cRet

User function xRejSCR(aDocto,dDataRef,nOper,cDocSF1,lResiduo,cItGrp,aItens,lEstCred,aItensDBM)

	Local cDocto	:= aDocto[1]
	Local cTipoDoc	:= aDocto[2]
	Local nValDcto	:= aDocto[3]
	Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
	Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
	Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
	Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
	Local cObs      := If(Len(aDocto)>10,If(aDocto[11]==Nil, "",aDocto[11]),"")
	Local aArea		:= GetArea()
	Local aAreaSCS	:= SCS->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())
	Local aRetPe	:= {}
	Local aRetDBM	:= {.F.,0,0,0}
	Local nSaldo	:= 0
	Local cGrupo	:= If(aDocto[6]==Nil,"",aDocto[6])
	Local lFirstNiv:= .T.
	Local cAuxNivel:= ""
	Local cNextNiv := ""
	Local lBloqNextVn := .F.
	Local cAuxTPLib	:= ""
	Local cNivIgual:= ""
	Local cStatusAnt:= ""
	Local cAprovOri := ""
	Local cUserOri  := ""
	Local cObsBloq  := 'Realizado a Rejeicao'
	Local lAchou	:= .F.
	Local nRec		:= 0
	Local lRetorno	:= .T.
	Local aSaldo	:= {}
	Local aMTALCGRU := {}
	Local lDeletou  := .F.
	Local lBloqueio := .F.
	Local dDataLib := IIF(dDataRef==Nil,DATE(),dDataRef)
	Local lIntegDef  := FWHasEAI("MATA120",.T.,,.T.)
	Local lAltpdoc	:= SuperGetMv("MV_ALTPDOC",.F.,.F.)
	Local lCnAglFlg	:= SuperGetMV("MV_CNAGFLG",.F.,.F.)
	Local lNfLimAl	:= SuperGetMV("MV_NFLIMAL",.F.,.F.)
	Local lTipoDoc	:= .T.
	Local lFluig		:= !Empty(AllTrim(GetNewPar("MV_ECMURL",""))) .And. FWWFFluig()
	Local cGrupoSAL	:= ""
	Local cAprovDBM	:= ""
	Local cChaveSCR
	Local lAchouSCR
	Local cMTALCAPR	:= ""
	Local cMsg		:=""
	Local dPrazo	:= Ctod("//")
	Local dAviso	:= Ctod("//")
	Local nRecAprov	:= 0
	Local cObsrej 	:= " "

	PRIVATE cA120Num := ""

	default dDataRef := DATE()
	default cDocSF1 := cDocto
	default lResiduo := .F.
	default cItGrp	:= ""
	default aItens	:= {}
	default lEstCred := .T.
	cDocto := cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
	cDocSF1:= cDocSF1+Space(Len(SCR->CR_NUM)-Len(cDocSF1))

	If ExistBlock("MT097GRV")
		lRetorno := (Execblock("MT097GRV",.F.,.F.,{aDocto,dDataRef,nOper,cDocSF1,lResiduo}))
		If Valtype( lRetorno ) <> "L"
			lRetorno := .T.
		EndIf
	Endif

	//tarcisio galeano 04/12/18
	IF cTipoDoc ="SC"
		cUser := AllTrim(SC1->C1_SOLICIT)
	ElseIF cTipoDoc = "LC" //Caroline Cazela
		cUser := substr(Embaralha( CT2->CT2_USERGI, 1 ),3,6)
	Else
		cUser := AllTrim(SC7->C7_USER)
	Endif

	If nOper == 7  //Evento de rejeicao do documento
		cAuxNivel 	:= SCR->CR_NIVEL
		cGrupo 		:= SCR->CR_GRUPO
		cItGrp 		:= SCR->CR_ITGRP
		cAprovOri 	:= SCR->CR_APROV
		cUserOri 	:= SCR->CR_USER

		//-- Rejeita aprovacoes pendentes do mesmo nivel, grupo e item
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel))
		While !SCR->(EOF()) .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL) == xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel
			If SCR->(CR_GRUPO) == cGrupo
				RecLock("SCR",.F.)
				SCR->CR_DATALIB := DATE()
				SCR->CR_USERLIB := SCR->CR_ZUSELIB
				SCR->CR_ZHORAPR := Time()
				SCR->CR_STATUS := "06"

				SCR->(MsUnLock())

				If cTipoDoc $ "SC|PC|IP|SA|LC|"
					xRejDoc(SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_GRUPO,SCR->CR_ITGRP,SCR->CR_USER,,SCR->CR_USERORI,nOper,SCR->CR_APROV)
				EndIf
			EndIf

			If !Empty(SCR->CR_FLUIG) .And. SCR->CR_STATUS == "05"
				CancelProcess(Val(SCR->CR_FLUIG),FWWFUserID(Val(SCR->CR_FLUIG))," cancelado por conting�ncia!",.F.)
			EndIf

			cObsrej := alltrim(SCR->CR_OBS)


			SCR->(dbSkip())
		End

		//msgalert("aqui envia email"+xFilial("SCR")+" "+cDocto)
		cMail   := ''
		cNextAlias := GetNextAlias()

		// tarcisio galeano 04/12/18 - tratamento para email

		XFIL :=""
		XFIL := xFilial("SCR")


		IF cTipoDoc ="SC"
			BeginSql Alias cNextAlias

				SELECT
			USR_EMAIL
				FROM
			SYS_USR USR
				WHERE
			USR.D_E_L_E_T_ =' ' and
			USR.USR_CODIGO = %exp:cUser%
			EndSql
		ELSE
			BeginSql Alias cNextAlias

					SELECT
			USR_EMAIL
					FROM
			SYS_USR USR
					WHERE
			USR.D_E_L_E_T_ =' ' and
			USR.USR_ID = %exp:cUser%
			EndSql

		ENDIF
		//


		(cNextAlias)->(dbGoTop())

		While (cNextAlias)->(!EOF())
			cMail := (cNextAlias)->USR_EMAIL
			Exit
			(cNextAlias)->(dbSkip())
		EndDo

		//msgalert("soliitante"+SC1->C1_SOLICIT+"  "+cMail)


		//------------------------
		//Envia Email tarcisio galeano 23/11/18
		//------------------------
		//__CopyFile(cArq, "C:\Temp\" + cArq)



		xTo := cMail //AQUI EMAIL

		If !Empty(AllTrim(xTo)) .and. cTipoDoc $ ("SC|PC|SA|LC")
			Envmail(xto,cDocto,XFIL,cTipoDoc,cObsrej)
		Else
			Alert("Nao  existe destinat�rio cadastrado nessa selecao!")
		EndIf
		//-----------------------------------------
	EndIf

	If cTipoDoc $ "SC|PC|SA"
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(xFilial("SCR")+cTipoDoc+cDocto))
		While !SCR->(EOF()) .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_STATUS <> "06"
				RecLock("SCR",.F.)
				SCR->CR_DATALIB := DATE()
				SCR->CR_USERLIB := SCR->CR_ZUSELIB
				SCR->CR_ZHORAPR := Time()
				SCR->CR_STATUS := "06"
				SCR->(MsUnLock())
			EndIf
			SCR->(dbSkip())
		EndDO

		SCR->(dbSetOrder(1))
		SCR->(dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel))
	EndIf

	If cTipoDoc $ "LC"
		SCR->(dbSetOrder(4))
		SCR->(dbSeek(xFilial("SCR")+alltrim(cTipoDoc)+dtos(SCR->CR_EMISSAO)+alltrim(cDocto)))
		While !SCR->(EOF()) .And. SCR->(CR_FILIAL+CR_TIPO+dtos(SCR->CR_EMISSAO)+CR_NUM) == xFilial("SCR")+cTipoDoc+SCR->CR_EMISSAO+cDocto
			If SCR->CR_STATUS <> "06"
				RecLock("SCR",.F.)
				SCR->CR_DATALIB := DATE()
				SCR->CR_USERLIB := SCR->CR_ZUSELIB
				SCR->CR_ZHORAPR := Time()
				SCR->CR_STATUS := "06"
				SCR->(MsUnLock())

			EndIf
			SCR->(dbSkip())
		EndDO

		SCR->(dbSetOrder(1))
		SCR->(dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel))
	EndIf

	//Envia o pedido de compra ao TOTVS Colaboracao
	If cPaisLoc == "BRA" .And. lRetorno .And. cTipoDoc $ "PC#AE" .And. (nOper == 1 .Or. nOper == 4) .And.;
			SC7->C7_TPOP $ " F" .And. FWLSEnable(TOTVS_COLAB_ONDEMAND)
		ExpXML_PC(SC7->C7_NUM)
	EndIf

	If ExistBlock("MTALCDOC")
		Execblock("MTALCDOC",.F.,.F.,{aDocto,dDataRef,nOper})
	EndIf

	//Envia o pedido de compra direto para portal MarketPLace
	If lRetorno .And. cTipoDoc $ "PC" .And. (nOper == 1 .Or. nOper == 4)  .And. SC7->C7_TPOP $ " F" .And. ;
			lIntegDef .And. SuperGetMV("MV_MKPLACE",.F.,.F.) .And. !Empty(SC7->C7_ACCNUM)

		cA120Num := SC7->C7_NUM
		If SC7->(MsSeek(xFilial("SC7")+SC7->C7_NUM))
			Inclui:=.T.
			//Dispara thread
			StartJob("MaEnvPed",GetEnvServer(),.F.,cEmpAnt,cFilAnt,cA120Num)
		EndIf
	EndIf

	If ExistBlock("MTALCFIM")
		lCalculo := Execblock("MTALCFIM",.F.,.F.,{aDocto,dDataRef,nOper,cDocSF1,lResiduo})
		If Valtype( lCalculo ) == "L"
			lRetorno := lCalculo
		EndIf
	Endif

	dbSelectArea("SCR")
	RestArea(aAreaSCR)
	dbSelectArea("SCS")
	RestArea(aAreaSCS)
	RestArea(aArea)

return(lRetorno)

Static function xRejDoc(cDocto,cTpDoc,cGrp,cItGrp,cUsrApv,aItens,cUsrOld,nOper,cAprov,cAprOld,aItensDBM,cAprOri)

	Local aArea			:= GetArea()
	Local aTipCom		:= {}
	Local cItem			:= ""
	Local cRateio		:= ""
	Local cKeyDBM		:= ""
	Local cKeyDoc		:= ""
	Local cItOld	 	:= ""
	Local cRatOld 		:= ""
	Local cGrpOld		:= ""
	Local cItGrpOld		:= ""
	Local cTpComp		:= ""
	Local cTpCompOld	:= ""
	Local nValorIt  	:= 0
	Local nValorOld  	:= 0
	Local nValorTot		:= 0
	Local lOk			:= .T.
	Local nFor	 		:= 0
	Local nTamRateio 	:= TamSX3("DBM_ITEMRA")[1]
	Local nTamItem   	:= TamSX3("DBM_ITEM")[1]
	Local nTotal		:= 0
	Local nPrazo		:= 99
	Local nAviso		:= 99
	Local lGerouDBM		:= .F.
	Local lAprovEsp		:= .F.
	local cAprovBkp		:= "" //Rafael  18/12/2018
	default cGrp		:= Space(TamSX3("DBM_GRUPO")[1])
	default cItGrp		:= Space(TamSX3("DBM_ITGRP")[1])
	default cUsrApv		:= Space(TamSX3("DBM_USER")[1])
	default aItens		:= {}
	default cAprOld		:= ""
	default cUsrOld		:= ""
	default cAprov 		:= Space(TamSX3("DBM_USAPRO")[1])
	default aItensDBM	:= {}
	PRIVATE L185AUTO := .t. //Rafael  18/12/2018

	//default cMTALCAPR	:= ""

	//-- Rejeicao do documento
	If (nOper == 7)
		cKeyDBM := xFilial("DBM")+cTpDoc+cDocto+cGrp+cItGrp+cUsrApv+cUsrOld

		DBM->(dbSetOrder(1))
		DBM->(dbSeek(cKeyDBM))
		While !DBM->(EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USER+DBM_USEROR) == cKeyDBM
			RecLock("DBM",.F.)
			DBM->DBM_APROV := '3'
			DBM->(MsUnLock())

			If cTpDoc == 'SC'
				cKeyDoc := xFilial("SC1")+PadR(DBM->DBM_NUM,Len(SC1->C1_NUM))+PadR(DBM->DBM_ITEM,Len(SC1->C1_ITEM))
				SC1->(dbSetOrder(1))
				SC1->(MsSeek(cKeyDoc))
				While !SC1->(EOF()) .And. SC1->(C1_FILIAL+C1_NUM+C1_ITEM) == cKeyDoc
					cAprovBkp:= SC1->C1_APROV // Rafael 18/12/2018

					RecLock("SC1",.F.)
					SC1->C1_APROV := 'R'
					SC1->(MsUnlock())
					MaAvalSC("SC1",8,,,,,,cAprovBkp) //Rafael  18/12/2018
					SC1->(dbSkip())
				End
			ElseIf cTpDoc == 'PC'
				cKeyDoc := xFilial("SC7")+PadR(DBM->DBM_NUM,Len(SC7->C7_NUM))+PadR(DBM->DBM_ITEM,Len(SC7->C7_ITEM))
				SC7->(dbSetOrder(1))
				SC7->(MsSeek(cKeyDoc))
				While !SC7->(EOF()) .And. SC7->(C7_FILIAL+C7_NUM+C7_ITEM) == cKeyDoc
					MaAvalPC("SC7",2) //Rafael  18/12/2018
					RecLock("SC7",.F.)
					SC7->C7_CONAPRO := 'R'
					SC7->(MsUnlock())

					SC7->(dbSkip())
				End


			ElseIf cTpDoc == 'SA'
				cKeyDoc := xFilial("SCP")+PadR(DBM->DBM_NUM,Len(SCP->CP_NUM))+PadR(DBM->DBM_ITEM,Len(SCP->CP_ITEM))
				SCP->(dbSetOrder(1))
				SCP->(MsSeek(cKeyDoc))
				While !SCP->(EOF()) .And. SCP->(CP_FILIAL+CP_NUM+CP_ITEM) == cKeyDoc
					RecLock("SCP",.F.)
					SCP->CP_STATSA := 'C'
					SCP->(MsUnlock())
					A185Encer("SCP",SCP->(Recno()),7)//Rafael  18/12/2018
					SCP->(dbSkip())
				End
			ElseIf cTpDoc == 'LC'
				cKeyDoc := xFilial("CT2")+Dtos(SCR->CR_EMISSAO)+PadR(DBM->DBM_NUM,Len(CT2->CT2_DOC))
				CT2->(dbSetOrder(17))
				CT2->(MsSeek(cKeyDoc))
				While !CT2->(EOF()) .And. CT2->(CT2_FILIAL+dtos(CT2_DATA)+CT2_DOC) == cKeyDoc
					RecLock("CT2",.F.)
					CT2->CT2_ZAPROV := 'R'
					If MSGYESNO("O usuario devera excluir o lan�amento contabil? ")
						CT2->CT2_ZMSGAP := "Excluir Lancamento"
					Else
						CT2->CT2_ZMSGAP	:= "Refazer Lancamento"
					EndIF

					CT2->(MsUnlock())

					CT2->(dbSkip())
				End
			EndIf
			DBM->(dbSkip())
		EndDo

	EndIf

	If cTpDoc == 'SC'
		cKeyDoc := xFilial("SC1") + PadR(SC1->C1_NUM,Len(SC1->C1_NUM))
		SC1->(dbSetOrder(1))
		SC1->(MsSeek(cKeyDoc))
		While !SC1->(EOF()) .And. SC1->(C1_FILIAL+C1_NUM) == cKeyDoc
			cAprovBkp:= SC1->C1_APROV // Rafael 18/12/2018

			RecLock("SC1",.F.)
			SC1->C1_APROV := 'R'
			SC1->(MsUnlock())
			MaAvalSC("SC1",2,,,,,,cAprovBkp) //Rafael  18/12/2018
			SC1->(dbSkip())
		EndDo
	EndIf

	If cTpDoc == 'PC'
		cKeyDoc := xFilial("SC7") + PadR(SC7->C7_NUM,Len(SC7->C7_NUM))
		SC7->(dbSetOrder(1))
		SC7->(MsSeek(cKeyDoc))
		While !SC7->(EOF()) .And. SC7->(C7_FILIAL+C7_NUM) == cKeyDoc
			MaAvalPC("SC7",2) //Rafael  18/12/2018
			RecLock("SC7",.F.)
			SC7->C7_CONAPRO := 'R'
			SC7->C7_ZREJAPR := 'S'
			SC7->C7_QUJE 	:= SC7->C7_QUANT
			SC7->C7_QTDACLA := SC7->C7_QUANT
			SC7->(MsUnlock())
			SC7->(dbSkip())
		EndDo
	EndIf

	If cTpDoc == 'SA'
		cKeyDoc := xFilial("SCP") + PadR(SCP->CP_NUM,Len(SCP->CP_NUM))
		SCP->(dbSetOrder(1))
		SCP->(MsSeek(cKeyDoc))
		While !SCP->(EOF()) .And. SCP->(CP_FILIAL+CP_NUM) == cKeyDoc
			RecLock("SCP",.F.)
			SCP->CP_STATSA := 'C'
			SCP->(MsUnlock())
			A185Encer("SCP",SCP->(Recno()),7) //Rafael  18/12/2018
			SCP->(dbSkip())
		EndDo
	EndIf
	If cTpDoc == 'LC'
		cKeyDoc := xFilial("CT2")+Dtos(CT2->CT2_DATA)+PadR(CT2->CT2_DOC,Len(CT2->CT2_DOC))
		CT2->(dbSetOrder(17))
		CT2->(MsSeek(cKeyDoc))
		While !CT2->(EOF()) .And. CT2->(CT2_FILIAL+dtos(CT2_DATA)+CT2_DOC) == cKeyDoc
			RecLock("CT2",.F.)
			CT2->CT2_ZAPROV := 'R'
			CT2->(MsUnlock())
			CT2->(dbSkip())
		EndDo
	EndIf
	RestArea(aArea)

return {lGerouDBM,nTotal,nPrazo,nAviso}

Static function xLIbZC(nReg,nOpc,nTotal,cCodLiber,cGrupo,cObs,dRefer,oModelCT)

	Local aArea		:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	Local cChavSCR 	:= ''
	Local cChavSE2	:= ''
	Local cChavSC7	:= ''
	Local cChavSCP	:= ''
	Local cChavSC1	:= ''
	Local cChacCT2	:= ''

	Local lLiberou	:= .F.
	Local lTudLib	:= .T.
	Local lLbSeqZC	:= GetMv('MGF_LIBSEQ',,.T.)
	Local lRet 		:= .T.
	Local L107grv   := .T.
	Local cStatSA   := "L"
	Local cUsrCT2	:= ""
	Local aInfoSAI 	:= {}
	Local nTamChv	:=  0//TamSx3('E2_FILIAL')[1] + TamSx3('E2_PREFIXO')[1] + TamSx3('E2_NUM')[1] + TamSx3('E2_PARCELA')[1] + TamSx3('E2_TIPO')[1] + TamSx3('E2_FORNECE')[1] + TamSx3('E2_LOJA')[1]

	default nTotal		:= SCR->CR_TOTAL
	default cCodLiber	:= SCR->CR_APROV
	default cGrupo 		:= SCR->CR_GRUPO
	default cObs		:= SCR->CR_OBS
	default dRefer		:= SCR->CR_DATALIB
	default oModelCT	:= NIL

	SCR->(dbClearFilter())
	If ( Select("SCR") > 0 )
		SCR->(dbCloseArea())
	EndIf

	dbSelectArea("SCR")
	SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
	SCR->(dbGoTo(nReg))

	cChavSCR := SCR->CR_FILIAL + SCR->(CR_TIPO + CR_NUM)

	If SCR->CR_TIPO == 'ZC'
		cChavSE2 := xFilial('SE2',SCR->CR_FILIAL) + SCR->CR_NUM
		nTamChv	:=  TamSx3('E2_FILIAL')[1] + TamSx3('E2_PREFIXO')[1] + TamSx3('E2_NUM')[1] + TamSx3('E2_PARCELA')[1] + TamSx3('E2_TIPO')[1] + TamSx3('E2_FORNECE')[1] + TamSx3('E2_LOJA')[1]
	ElseIf SCR->CR_TIPO == 'PC'
		cChavSC7 := xFilial('SC7',SCR->CR_FILIAL) + SCR->CR_NUM
		nTamChv	:=  TamSx3('C7_FILIAL')[1] + TamSx3('C7_NUM')[1]
	ElseIf SCR->CR_TIPO == 'SA'
		cChavSCP := xFilial('SCP',SCR->CR_FILIAL) + SCP->CP_NUM
		nTamChv	:=  TamSx3('CP_FILIAL')[1] + TamSx3('CP_NUM')[1]
	ElseIf SCR->CR_TIPO == 'SC'
		cChavSC1 := xFilial('SC1',SCR->CR_FILIAL) + SCR->CR_NUM
		nTamChv	:=  TamSx3('C1_FILIAL')[1] + TamSx3('C1_NUM')[1]
	ElseIf SCR->CR_TIPO == 'LC'
		cChavCT2 := xFilial('SC1',SCR->CR_FILIAL) + alltrim(SCR->CR_NUM)
		nTamChv	:=  TamSx3('CT2_FILIAL')[1] + TamSx3('CT2_DATA')[1] + TamSx3('CT2_LOTE')[1] + TamSx3('CT2_SBLOTE')[1] + TamSx3('CT2_DOC')[1]
	EndIf

	aArTeSCR := SCR->(GetArea())

	nRec := SCR->(RECNO())

	SCR->(dbSeek(cChavSCR))

	If nOpc == 2
		While SCR->(!EOF()) .and. SCR->CR_FILIAL + SCR->(CR_TIPO + CR_NUM) == cChavSCR

			//Se um item estiver sem data de liberacao nao libera o titulo
			If (Empty(SCR->CR_DATALIB) .OR. SCR->CR_STATUS = '04' ) .and. SCR->(RECNO()) <> nRec
				lTudLib := .F.
				Exit
			EndIf

			SCR->(dbSkip())
		EndDo
	Else
		lTudLib := .F.
	EndIf

	SCR->(RestArea(aArTeSCR))

	Begin Transaction

		If SCR->CR_TIPO <> 'ZC' .or. lLbSeqZC
			lLiberou := U_xAlcAprov({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
		Else
			lLiberou := U_xAlcSApro({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
		EndIf

		If lLiberou

			dbSelectArea("SCR")
			SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

			If SCR->(dbSeek(cChavSCR))

				SCR->(dbGoTo(nReg))

				If lTudLib
					If SCR->CR_TIPO == 'ZC'
						SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
						If (SE2->(dbSeek(SubStr(cChavSE2,1,nTamChv))))
							RecLock('SE2',.F.)
							SE2->E2_DATALIB := DATE()
							SE2->E2_APROVA  := SubStr(UsrFullName(SCR->CR_ZUSELIB),1,20)
							SE2->E2_CODAPRO := SCR->CR_ZAPRLIB
							SE2->(MsUnlock())
						EndIf
					ElseIf SCR->CR_TIPO == 'PC'
						SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN
						If (SC7->(dbSeek(SubStr(cChavSC7,1,nTamChv))))
							While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) = SubStr(cChavSC7,1,nTamChv)

								RecLock('SC7',.F.)
								SC7->C7_CONAPRO := 'L'
								SC7->(MsUnLock())

								If !Empty(SC7->C7_PO_EIC)
									dbSelectArea("SW2")
									SW2->(dbSetOrder(1))//W2_FILIAL+W2_PO_NUM
									If SW2->(MsSeek(xFilial("SW2") + SC7->C7_PO_EIC))
										Reclock("SW2",.F.)
										SW2->W2_CONAPRO := "L"
										MsUnlock()

										TPO_NUM := SW2->W2_PO_NUM
										EICFI400("ANT_GRV_PO","E")
										EICFI400("POS_GRV_PO","E")

										Reclock("SW2",.F.)
										SW2->W2_CONAPRO := "L"
										MsUnlock()

									EndIf
								EndIf

								SC7->(dbSkip())

							EndDo
						EndIf

					ElseIf SCR->CR_TIPO == 'SA'
						SCP->(dbSetOrder(1))//CP_FILIAL, CP_NUM
						If (SCP->(dbSeek(SubStr(cChavSCP,1,nTamChv))))
							//cStatSA := "C"
							While SCP->(!EOF()) .and. SCP->(CP_FILIAL + CP_NUM) = SubStr(cChavSCP,1,nTamChv)
								If Existblock("MT107LIB")
									lRet:= Execblock("MT107LIB",.F.,.F.)
									If ValType(lRet) # "L"
										lRet :=.T.
									EndIf
								EndIf

								If lRet
									Begin Transaction
										dbSelectArea("SCP")
										RecLock("SCP",.F.)
										SCP->CP_STATSA := cStatSA
										MsUnlock()

										MaVldSolic(SCP->CP_PRODUTO,UsrRetGrp(),RetCodUsr(),.F.,0,,@aInfoSAI)
										If !Empty(aInfoSAI)
											AtuSalSCW(aInfoSAI[1], aInfoSAI[2], aInfoSAI[3], aInfoSAI[4], aInfoSAI[6])
										EndIf

										If l107Grv
											ExecBlock("MT107GRV",.f.,.f.)
										EndIf

									End Transaction
								EndIf
								SCP->(dbSkip())
							EndDo
						EndIf
					ElseIf SCR->CR_TIPO == 'LC'
						CT2->(dbSetOrder(1))//CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC
						If CT2->(DbSeek(xFilial("CT2") + Alltrim(SCR->CR_NUM)))

							//Dispara thread: xAtuCT2 autoexec CT2
							//Definida a atualizacao por startJob, pois o saldo das contas nao atualizava quando se loga em uma filial, mas aprova o Doc. de outra.
							StartJob("U_xAtuCT2",GetEnvServer(),.T.,{cEmpAnt,CT2->CT2_FILIAL,Alltrim(SCR->CR_NUM)})

							//Atualiza o saldo do aprovador.
							U_xMC26Som(CT2->CT2_FILIAL,CT2->CT2_ZCDUSE,SCR->CR_TOTAL)

						EndIf
					ElseIf SCR->CR_TIPO == 'SC'
						SC1->(dbSetOrder(1))//C1_FILIAL, C1_NUM, C1_ITEM, C7_SEQUEN
						If (SC1->(dbSeek(SubStr(cChavSC1,1,nTamChv))))
							While SC1->(!EOF()) .and. SC1->(C1_FILIAL + C1_NUM) = SubStr(cChavSC1,1,nTamChv)
								RecLock('SC1',.F.)
								SC1->C1_APROV := 'L'
								SC1->(MsUnLock())
								SC1->(dbSkip())
							EndDo
							// Customiza��o - COM03 - Flavio
							If FindFunction('U_MGFCOM28')
								U_MGFCOM28()
							EndIf
							//Fim COM03
						EndIf
					EndIf
				EndIf
			EndIf
			//Else
			//Alert('Problema funcao MaAlcDoc Fonte: MGFCOM14, Linha: 1712')
		EndIf

	End Transaction

	RestArea(aAreaSCR)
	RestArea(aArea)

Return

User Function xAlcSApro(aDocto,dDataRef,nOper,cDocSF1,lResiduo,cItGrp,aItens,lEstCred)

	Local cDocto		:= aDocto[1]
	Local cTipoDoc		:= aDocto[2]
	Local nValDcto		:= aDocto[3]
	Local cAprov		:= If(aDocto[4]==Nil,"",aDocto[4])
	Local cUsuario		:= If(aDocto[5]==Nil,"",aDocto[5])
	Local nMoeDcto		:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
	Local nTxMoeda		:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
	Local cObs      	:= If(Len(aDocto)>10,If(aDocto[11]==Nil, "",aDocto[11]),"")
	Local aArea			:= GetArea()
	Local aAreaSCS		:= SCS->(GetArea())
	Local aAreaSCR		:= SCR->(GetArea())
	Local aRetPe		:= {}
	Local nSaldo		:= 0
	Local cGrupo		:= If(aDocto[6]==Nil,"",aDocto[6])
	Local lFirstNiv		:= .T.
	Local cAuxNivel		:= ""
	Local cNextNiv 		:= ""
	Local lBloqNextVn 	:= .F.
	Local cAuxTPLib		:= ""
	Local cNivIgual		:= ""
	Local cStatusAnt	:= ""
	Local cAprovOri 	:= ""
	Local cUserOri  	:= ""
	Local cObsBloq  	:= 'Bloqueado'
	Local lAchou		:= .F.
	Local nRec			:= 0
	Local lRetorno		:= .T.
	Local aSaldo		:= {}
	Local aMTALCGRU 	:= {}
	Local lDeletou  	:= .F.
	Local lBloqueio 	:= .F.
	Local dDataLib  	:= IIF(dDataRef==Nil,DATE(),dDataRef)
	Local lIntegDef 	:= FWHasEAI("MATA120",.T.,,.T.)
	Local lAltpdoc		:= SuperGetMv("MV_ALTPDOC",.F.,.F.)
	Local lTipoDoc		:= .T.
	Local lFluig		:= !Empty(AllTrim(GetNewPar("MV_ECMURL",""))) .And. FWWFFluig() .And. (!IsInCallStack('WFMATA110') .OR. !IsInCallStack('WFMATA105') .OR. !IsInCallStack('WFMATA311'))
	Local cGrupoSAL		:= ""
	Local lNfLimAl		:= SuperGetMV ("MV_NFLIMAL", .F.,.F.)
	Local cAprovDBM		:= ""
	Local cxFil			:= SCR->CR_FILIAL

	Local cNextAlias 	:= GetNextAlias()

	PRIVATE cA120Num 	:= ""

	default dDataRef 	:= DATE()
	default cDocSF1 	:= cDocto
	default lResiduo	:= .F.
	default cItGrp		:= ""
	default aItens		:= {}
	default lEstCred 	:= .T.
	cDocto 				:= cDocto + Space(Len(SCR->CR_NUM) - Len(cDocto))
	cDocSF1				:= cDocSF1 + Space(Len(SCR->CR_NUM) - Len(cDocSF1))

	//Aprovacao
	If nOper == 4

		dbSelectArea("SCR")
		SCR->(dbSetOrder(1))//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL

		//Aprova o Registro
		cAuxNivel := SCR->CR_NIVEL
		If Reclock("SCR",.F.)
			SCR->CR_STATUS	:= "03"
			SCR->CR_OBS		:= If(Len(aDocto)>10,aDocto[11],"")
			SCR->CR_DATALIB	:= dDataLib
			SCR->CR_ZHORAPR := Time()
			SCR->CR_USERLIB	:= SCR->CR_ZUSELIB
			SCR->CR_VALLIB	:= nValDcto
			SCR->CR_TIPOLIM	:= 'D'
			SCR->(MsUnlock())
		Endif

	EndIf

	If nOper == 6  //Bloqueio manual

		Reclock("SCR",.F.)
		SCR->CR_STATUS 	:= "04"
		SCR->CR_OBS	   	:= If(Len(aDocto)>10,aDocto[11],"")
		SCR->CR_DATALIB	:= dDataRef
		SCR->CR_USERLIB	:= SCR->CR_ZUSELIB//SAK->AK_USER
		SCR->CR_ZHORAPR := Time()
		//SCR->CR_LIBAPRO	:= SAK->AK_COD
		cAuxNivel   	:= SCR->CR_NIVEL
		SCR->(MsUnlock())

		lRetorno 	:= .F.

		//�����������������������������������������Ŀ
		//� Bloqueia todos os Aprovadores do N�vel  �
		//�������������������������������������������
		SCR->(dbSeek(xFilial("SCR") + cTipoDoc + cDocto + cAuxNivel))
		nRec := RecNo()
		While !Eof() .And. xFilial("SCR") + cDocto + cTipoDoc + cAuxNivel == SCR->CR_FILIAL + SCR->CR_NUM + SCR->CR_TIPO + SCR->CR_NIVEL
			If SCR->CR_STATUS != "04"
				Reclock("SCR",.F.)
				SCR->CR_STATUS	:= "05"
				SCR->CR_OBS	    := 'Aprovador: ' + SCR->CR_ZUSELIB//SAK->AK_COD
				SCR->CR_DATALIB	:= dDataRef
				SCR->CR_ZHORAPR := Time()
				SCR->CR_USERLIB	:= SCR->CR_ZUSELIB//SAK->AK_USER
				SCR->(MsUnlock())
			EndIf
			SCR->(dbSkip())
		EndDo
	EndIf

	dbSelectArea("SCR")
	RestArea(aAreaSCR)
	dbSelectArea("SCS")
	RestArea(aAreaSCS)
	RestArea(aArea)

Return lRetorno

User function xAlcAprov(aDocto,dDataRef,nOper,cDocSF1,lResiduo,cItGrp,aItens,lEstCred)

	Local cDocto		:= aDocto[1]
	Local cTipoDoc		:= aDocto[2]
	Local nValDcto		:= aDocto[3]
	Local cAprov		:= If(aDocto[4]==Nil,"",aDocto[4])
	Local cUsuario		:= If(aDocto[5]==Nil,"",aDocto[5])
	Local nMoeDcto		:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
	Local nTxMoeda		:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
	Local cObs      	:= If(Len(aDocto)>10,If(aDocto[11]==Nil, "",aDocto[11]),"")
	Local aArea			:= GetArea()
	Local aAreaSCS		:= SCS->(GetArea())
	Local aAreaSCR		:= SCR->(GetArea())
	Local aRetPe		:= {}
	Local nSaldo		:= 0
	Local cGrupo		:= If(aDocto[6]==Nil,"",aDocto[6])
	Local lFirstNiv		:= .T.
	Local cAuxNivel		:= ""
	Local cNextNiv 		:= ""
	Local lBloqNextVn 	:= .F.
	Local cAuxTPLib		:= ""
	Local cNivIgual		:= ""
	Local cStatusAnt	:= ""
	Local cAprovOri 	:= ""
	Local cUserOri  	:= ""
	Local cObsBloq  	:= 'Bloqueado'
	Local lAchou		:= .F.
	Local nRec			:= 0
	Local lRetorno		:= .T.
	Local aSaldo		:= {}
	Local aMTALCGRU 	:= {}
	Local lDeletou  	:= .F.
	Local lBloqueio 	:= .F.
	Local dDataLib  	:= IIF(dDataRef==Nil,DATE(),dDataRef)
	Local lIntegDef 	:= FWHasEAI("MATA120",.T.,,.T.)
	Local lAltpdoc		:= SuperGetMv("MV_ALTPDOC",.F.,.F.)
	Local lTipoDoc		:= .T.
	Local lFluig		:= !Empty(AllTrim(GetNewPar("MV_ECMURL",""))) .And. FWWFFluig() .And. (!IsInCallStack('WFMATA110') .OR. !IsInCallStack('WFMATA105') .OR. !IsInCallStack('WFMATA311'))
	Local cGrupoSAL		:= ""
	Local lNfLimAl		:= SuperGetMV ("MV_NFLIMAL", .F.,.F.)
	Local cAprovDBM		:= ""
	Local cxFil			:= SCR->CR_FILIAL

	Local cNextAlias 	:= GetNextAlias()

	PRIVATE cA120Num 	:= ""

	default dDataRef 	:= DATE()
	default cDocSF1 	:= cDocto
	default lResiduo	:= .F.
	default cItGrp		:= ""
	default aItens		:= {}
	default lEstCred 	:= .T.
	cDocto 				:= cDocto + Space(Len(SCR->CR_NUM) - Len(cDocto))
	cDocSF1				:= cDocSF1 + Space(Len(SCR->CR_NUM) - Len(cDocSF1))

	//Aprovacao
	If nOper == 4

		dbSelectArea("SCR")
		SCR->(dbSetOrder(1))//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL

		//Aprova o Registro
		cAuxNivel := SCR->CR_NIVEL
		If Reclock("SCR",.F.)
			SCR->CR_STATUS	:= "03"
			SCR->CR_OBS		:= If(Len(aDocto)>10,aDocto[11],"")
			SCR->CR_DATALIB	:= dDataLib
			SCR->CR_ZHORAPR := Time()
			SCR->CR_USERLIB	:= SCR->CR_ZUSELIB
			SCR->CR_VALLIB	:= nValDcto
			SCR->CR_TIPOLIM	:= 'D'
			SCR->(MsUnlock())
		Endif

		nRec := SCR->(RecNo())

		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif

		BeginSql Alias cNextAlias

			SELECT
		CR1.R_E_C_N_O_ REC
			FROM
		%Table:SCR% CR1
			WHERE
		CR1.%NotDel% AND
		CR1.CR_FILIAL = %Exp:SCR->CR_FILIAL%  AND
		CR1.CR_TIPO = %Exp:SCR->CR_TIPO% AND
		CR1.CR_NUM = %Exp:SCR->CR_NUM% AND
		CR1.CR_STATUS = '01' AND
		CR1.CR_NIVEL = (SELECT
		MIN(CR_NIVEL)
			FROM
		%Table:SCR% CR
			WHERE
		CR.%NotDel% AND
		CR.CR_FILIAL = %Exp:SCR->CR_FILIAL%  AND
		CR_TIPO = %Exp:SCR->CR_TIPO% AND
		CR.CR_NUM = %Exp:SCR->CR_NUM% AND
		CR_STATUS = '01')

		EndSql

		(cNextAlias)->(DbGoTop())

		While (cNextAlias)->(!Eof())
			SCR->(DbGoto((cNextAlias)->REC))

			If Reclock("SCR",.F.)
				SCR->CR_STATUS := "02"
				SCR->(MsUnlock())
			EndIf

			(cNextAlias)->(dbSkip())
		EndDo

		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif

		//Reposiciona
		SCR->(MsGoto(nRec))

	EndIf

	If nOper == 6  //Bloqueio manual

		Reclock("SCR",.F.)
		SCR->CR_STATUS 	:= "04"
		SCR->CR_OBS	   	:= If(Len(aDocto)>10,aDocto[11],"")
		SCR->CR_DATALIB	:= dDataRef
		SCR->CR_USERLIB	:= SCR->CR_ZUSELIB//SAK->AK_USER
		SCR->CR_ZHORAPR := Time()
		//SCR->CR_LIBAPRO	:= SAK->AK_COD
		cAuxNivel   	:= SCR->CR_NIVEL
		SCR->(MsUnlock())

		lRetorno 	:= .F.

		//�����������������������������������������Ŀ
		//� Bloqueia todos os Aprovadores do N�vel  �
		//�������������������������������������������
		SCR->(dbSeek(xFilial("SCR") + cTipoDoc + cDocto + cAuxNivel))
		nRec := RecNo()
		While !Eof() .And. xFilial("SCR") + cDocto + cTipoDoc + cAuxNivel == SCR->CR_FILIAL + SCR->CR_NUM + SCR->CR_TIPO + SCR->CR_NIVEL
			If SCR->CR_STATUS != "04"
				Reclock("SCR",.F.)
				SCR->CR_STATUS	:= "05"
				SCR->CR_OBS	    := 'Aprovador: ' + SCR->CR_ZUSELIB//SAK->AK_COD
				SCR->CR_DATALIB	:= dDataRef
				SCR->CR_ZHORAPR := Time()
				SCR->CR_USERLIB	:= SCR->CR_ZUSELIB//SAK->AK_USER
				//SCR->CR_LIBAPRO	:= SAK->AK_COD
				SCR->(MsUnlock())
			EndIf

			SCR->(dbSkip())
		EndDo
	EndIf

	dbSelectArea("SCR")
	RestArea(aAreaSCR)
	dbSelectArea("SCS")
	RestArea(aAreaSCS)
	RestArea(aArea)

Return lRetorno

User Function xMGFINITP(cAlias)

	Local cRet := ''

	If AllTrim((cAlias)->CR_TIPO) == 'SC'
		cRet := 'SOLICITACAO'
	ElseIf AllTrim((cAlias)->CR_TIPO) == 'PC'
		cRet := 'PEDIDO'
	ElseIf AllTrim((cAlias)->CR_TIPO) == 'SA'
		cRet := 'SOL_ARMAZEM'
	ElseIf AllTrim((cAlias)->CR_TIPO) == 'ZC'
		cRet := 'TITULO'
	ElseIf AllTrim((cAlias)->CR_TIPO) == 'LC'
		cRet := 'LANCTO_CONTABIL'
	EndIf

Return cRet

Static Function xMark()

	Local cAlias := oBrowse:Alias()

	If (!oBrowse:IsMark())
		//if 1==1
		if (cAlias)->CR_STATUS $ '02|04'
			RecLock(cAlias,.F.)
			(cAlias)->CR_ZOK  := oBrowse:Mark()
			(cAlias)->CR_ZUMARK:= RetCodUsr() //Rafael 08/11/2018
			(cAlias)->(MsUnLock())
		Else
			MsgAlert("S� � permitido a Marcacao de itens que estejam parado com esse usuario")
		EndIf
	Else
		RecLock(cAlias,.F.)
		(cAlias)->CR_ZOK  := ""
		(cAlias)->CR_ZUMARK:= "" //Rafael 08/11/2018
		(cAlias)->(MsUnLock())
	EndIf

Return .T.

Static Function xDesMark()

	Local aArea	 := GetArea()
	Local cAlias := oBrowse:Alias()

	local cFiltro := "(CR_TIPO = 'SC' .or. CR_TIPO = 'PC' .or. CR_TIPO = 'SA' .or. CR_TIPO = 'ZC' .or. CR_TIPO = 'LC' ) .and. " + xFilUser() //alterado Rafael 08/11/2018

	(cAlias)->(DBSetFilter(&('{||' + cFiltro + '}'),cFiltro)) //alterado Rafael 08/11/2018
	(cAlias)->(dbGoTop())

	cQuery:= "UPDATE " + retSQLName("SCR")+ CRLF  //alterado Rafael 30/11/2018
	cQuery+= "SET CR_ZOK =' ' , CR_ZUMARK=' ' WHERE "
	cQuery+= "D_E_L_E_T_<>'*' AND  CR_ZUMARK = '" + RETCODUSR()+"'"

	tcSQLExec(cQuery)
	/*	While (cAlias)->(!EOF()) //alterado Rafael 30/11/2018

	RecLock(cAlias,.F.)
	(cAlias)->CR_ZOK  := ""
	(cAlias)->CR_ZUMARK:= "" //Rafael 08/11/2018
	(cAlias)->(MsUnLock())

	(cAlias)->(dbSkip())
EndDo
	*/
RestArea(aArea)

Return

Static Function xMarkAll()

	Local cAlias	:= oBrowse:Alias()
	Local aRest		:= GetArea()

	(cAlias)->(DbGoTop())
	While (cAlias)->(!Eof())
		If (!oBrowse:IsMark())
			If (cAlias)->CR_STATUS $ '02|04'
				RecLock(cAlias,.F.)
				(cAlias)->CR_ZOK  := oBrowse:Mark()
				(cAlias)->CR_ZUMARK:= RetCodUsr() //Rafael 08/11/2018
				(cAlias)->(MsUnLock())
			EndIf
		Else
			RecLock(cAlias,.F.)
			(cAlias)->CR_ZOK  := ""
			(cAlias)->CR_ZUMARK:= "" //Rafael 08/11/2018
			(cAlias)->(MsUnLock())
		EndIf
		(cAlias)->(DbSkip())
	EndDo

	RestArea(aRest)

	oBrowse:refresh(.F.)
Return .T.

// funcao abaixo conforme estava anteriormente em Produ��o, devera ser excluido apos descomentar acima. Odair 09/11/18
User Function xC14LLot()
	Processa({|| xProLote('L')},"Aguarde....","Processando Liberacao")
	//If MsgYesNo( 'Deseja Atualizar a Tela', 'Atualizacao' )
	//	Processa({|| U_xMC14Atu()},"Aguarde....","Atualizando a Tela")
	//EndIF
Return
// EXCLUIR AT� AQUI. Apos o comentado acima ser homologado.

User Function xC14BLot()
	Processa({|| xProLote('B')},"Aguarde....","Processando Bloqueio")
	//If MsgYesNo( 'Deseja Atualizar a Tela', 'Atualizacao' )
	//	Processa({|| U_xMC14Atu()},"Aguarde....","Atualizando a Tela")
	//EndIf
Return

User Function xC14RLot()
	Processa({|| xProLote('R')},"Aguarde....","Processando Rejeicao")
	//If MsgYesNo( 'Deseja Atualizar a Tela', 'Atualizacao' )
	//	Processa({|| U_xMC14Atu()},"Aguarde....","Atualizando a Tela")
	//EndIf
Return

Static Function xOldProLote(cxTp)

	Local aArea	 := GetArea()
	Local cAlias := oBrowse:Alias()
	Local cObs	 := ''

	If cxTp == 'L'
		cOperID:= OP_LIB
		cObs	 := 'Liberado em Lote'
	ElseIf cxTp == 'B'
		cOperID:= OP_BLQ
		cObs	 := 'Bloqueio em Lote'
	ElseIf cxTp == 'R'
		cOperID:= OP_REJ
		cObs	 := 'Rejeitado em Lote'
	EndIf

	(cAlias)->(dbGoTop())

	While (cAlias)->(!EOF())

		If (cAlias)->CR_ZOK  == oBrowse:Mark() .and. (cAlias)->CR_ZUMARK == RetCodUsr() //Rafael 08/11/2018
			If !(cxTp == 'R' .and. SCR->CR_TIPO == 'ZC')
				oModel := FwLoadModel('MGFCOM14')
				oModel:SetOperation( MODEL_OPERATION_UPDATE )
				If oModel:Activate()
					oMdlSCR := oModel:GetModel('FieldSCR')
					oMdlSCR:LoadValue('CR_OBS',cObs)

					If oModel:VldData()
						oModel:CommitData()
						oModel:DeActivate()
						oModel:Destroy()
					Else
						JurShowErro(oModel:GetModel():GetErrormessage())
					EndIf
				EndIf
			EndIf
		EndIf

		(cAlias)->(dbSkip())
	EndDo

	xDesMark()
	RestArea(aArea)

Return



//--------------------------------------------------------------------
	/*/{Protheus.doc} xProLote()
	Executa ExecView do MGFCOM14 para os botoes Liberado em Lote, bloqueio em Lote, rejeicao em Lote
	@author Leonardo Quintania
	@since 23/10/2013
	@version 1.0
	@alteracao
	********************
	2020-02-26 feature/RTASK0010611-trava-na-libercao-item-marcado
	Quando o registro estiver com flag precisa usar a funcao Liberar Lote,
	para utilizar a funcao Liberar, o registro deve estar com o cursor em
	cima dele, com ou sem flag.
	********************

	@return NIL
	/*/
//--------------------------------------------------------------------
Static Function xProLote(cxTp)

	Local aArea	 	:=	GetArea()
	Local aAreaSCR	:=	SCR->(GetArea())
	Local cQry	 	:=	{}//xQryLote()
	Local cObs	 	:=	''
	Local cMsgProc	:=	""
	Local cFilBkp	:=	cFilAnt
	Local cAlias 	:=	oBrowse:Alias()
	local _nCount	:=	0

	If cxTp == 'L'
		if xValLib(2)
			cOperID:= OP_LIB
			cObs	 := 'Liberado em Lote'
			cMsgProc := 'Liberando Documento'
		else
			return
		endif
	ElseIf cxTp == 'B'
		cOperID:= OP_BLQ
		cObs	 := 'Bloqueio em Lote'
		cMsgProc := 'Bloqueando Documento'
	ElseIf cxTp == 'R'
		cOperID:= OP_REJ
		cObs	 := 'Rejeitado em Lote'
		cMsgProc := 'Rejeitando Documento'
	EndIf

	nTotReg := Contar(cAlias,"!Eof()")
	ProcRegua(nTotReg)

	dbSelectArea('SCR')
	SCR->(dbSetOrder(1))//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL

	(cAlias)->(dbGoTop())

	While (cAlias)->(!EOF())
		If (cAlias)->CR_ZOK == oBrowse:Mark() .AND. (cAlias)->CR_ZUMARK == RetCodUsr()
			_nCount++
			IncProc(cMsgProc + ": " + Alltrim((cAlias)->CR_NUM))

			cFilAnt := (cAlias)->CR_FILIAL
			SCR->(dbGoTo((cAlias)->RECSCR))

			If !(cxTp == 'R' .and. SCR->CR_TIPO == 'ZC')
				oModel := FwLoadModel('MGFCOM14')
				oModel:SetOperation( MODEL_OPERATION_UPDATE )
				If oModel:Activate()
					oMdlSCR := oModel:GetModel('FieldSCR')
					oMdlSCR:LoadValue('CR_OBS',cObs)

					If oModel:VldData()
						oModel:CommitData()
						oModel:DeActivate()
						oModel:Destroy()
					Else
						JurShowErro(oModel:GetModel():GetErrormessage())
					EndIf
				EndIf
			EndIf

			RecLock('SCR',.F.)
			SCR->CR_ZOK  := ""
			SCR->CR_ZUMARK:= "" //Rafael 08/11/2018
			SCR->(MsUnLock())

			If cOperID == OP_LIB
				RecLock((cAlias),.F.)
				(cAlias)->CR_STATUS 	:= '03'
				(cAlias)->CR_DATALIB	:= dDataBase
				(cAlias)->CR_ZOK	   := " "
				(cAlias)->(MsUnLock())
			ElseIf cOperID == OP_BLQ
				RecLock((cAlias),.F.)
				(cAlias)->CR_STATUS 	:= '04'
				(cAlias)->CR_ZOK	   := " "
				(cAlias)->(MsUnLock())
			ElseIf cOperID == OP_REJ
				RecLock((cAlias),.F.)
				(cAlias)->CR_STATUS 	:= '06'
				(cAlias)->CR_DATALIB	:= dDataBase
				(cAlias)->CR_ZOK	   := " "
				(cAlias)->(MsUnLock())
			EndIf
		EndIf
		(cAlias)->(dbSkip())
	EndDo


	if _nCount == 0
		_mensagem	:=	 'Atencao, voce nao selecionou nenhum registro para Liberacao'
		Help(NIL, NIL, 'MGFCOM14', NIL, 'Aprovacao de Grade Marfrig', 1, 0, NIL, NIL, NIL, NIL, NIL, {_mensagem})
	endif
	//xDesMark()

	cFilAnt := cFilBkp
	//RestArea(aAreaSCR)
	//RestArea(aArea)

Return

Static Function xQryLote()

	Local cNextAlias:= GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT
			SCR.R_E_C_N_O_ REC,
			SCR.CR_TIPO
		FROM
			%Table:SCR% SCR
		WHERE
			SCR.CR_ZOK = %Exp:oBrowse:Mark()% AND
			SCR.CR_ZUMARK = %Exp:RetCodUsr()% AND
			SCR.%NotDel%

	EndSql

return (cNextAlias)


User Function MGF8NomU(cUser)

	Local aArea 	:= GetArea()
	Local cAlias	:= GetNextAlias()
	Local cRet		:= ''

	BeginSQL Alias cAlias

		SELECT USR_NOME
		FROM SYS_USR
		WHERE D_E_L_E_T_ = ' '
			AND USR_ID = %Exp:cUser%

	EndSQL

	cRet	:= 	( cAlias )->USR_NOME

	dbSelectArea(cAlias)
	dbCloseArea()

	RestArea( aArea )
Return cRet

/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Acompanhamento de cobranca
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Envia Email
=====================================================================================
*/

/*
========================================================
Funcao que Envia E-mail do erro (EnvMail())
========================================================
*/
Static Function EnvMail(xto,cDocto,XFIL,cTipoDoc,cObsrej) //tarcisio galeano 23/11/18

	Local oMail, oMessage
	Local nErro		:= 0
	Local lRetMail 	:= .T.
	Local cSmtpSrv  := GETMV("MGF_SMTPSV")
	Local cCtMail   := GETMV("MGF_CTMAIL")
	Local cPwdMail  := GETMV("MGF_PWMAIL")
	Local nMailPort := GETMV("MGF_PTMAIL")
	Local nParSmtpP := GETMV("MGF_PTSMTP")
	Local nSmtpPort
	Local nTimeOut  := GETMV("MGF_TMOUT")
	Local cEmail    := GETMV("MGF_EMAIL")
	Local cErrMail

	oMail := TMailManager():New()

	if nParSmtpP == 25
		oMail:SetUseSSL( .F. )
		oMail:SetUseTLS( .F. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nParSmtpP)
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
		Alert(cErrMail)
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
	oMessage:cTo                    := alltrim(xto) //"tarcisio.galeano@totvspartners.com.br"
	oMessage:cCc                    := ""
	//--------------------- tarcisio galeano 23/11/18
	IF cTipoDoc = "SC"
		oMessage:cSubject               := "Aviso de Rejeicao de Solicitacao de Compras"
		oMessage:cBody                  := "A Sua solicitacao numero "+cDocto+"da filial "+XFIL+" foi rejeitada, Motivo :("+cObsrej+") "
		oMessage:cBody                  += "favor contatar o aprovador." //cHtml
	ELSE
		oMessage:cSubject               := "Aviso de Rejeicao de Pedido de Compras"
		oMessage:cBody                  := "O Seu pedido numero "+cDocto+"da filial "+XFIL+" foi rejeitado, Motivo :("+cObsrej+") "
		oMessage:cBody                  += "favor contatar o aprovador." //cHtml
	ENDIF
	//-----------------------------
	nErro := oMessage:Send( oMail )

	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		Alert(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarkSCR  � Autor �Geronimo B Alves	 � Data �   13/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Monta uma tela de markbrowse, mostrando os Produtos         ���
���			� selecionados pela query recebida por parametro, nos campos ���
���			� tambem recebidos por parametro, para que o usuario marque  ���
���			� quais serao processadas									���
�������������������������������������������������������������������������͹��
���Parametros� _cQuery		- Query para selecao dos registros			���
���			� aCpoMostra[1] - Campo a ser mostrado						���
���			� aCpoMostra[2] - Titulo do Campo							���
���			� aCpoMostra[3] - Tamanho do Campo em caracteres				���
���			� cTitulo		- Titulo dq tela de selecao					���
���			� nPosRetorn	- Numero da posicao do campo na MarkBrowse	���
���			�				- que sera retornado. Ex. Pode ser retornado ���
���			�				- o primeiro, segundo, terceiro ou outro		���
���			�				- campo do MarkBrowse						���
���			� _lBtnCance	- Parametro recebido como referencia. Define se deve(.T.) ou  nao deve(.F.) cancelar todo o processamento caso o usuario ���
���			�					clicar no botao cancelar. O _lBtnCance � visivel no programa chamador e se retornou como.T., indica que o botao		���
���			�					foi teclado. Ent�o o programa deve ser finalizado																		���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MarkSCR(_cQuery, aCpoMostra, cTitulo, nPosRetorn, _lCancProg )
	Local aArea			:= GetArea()
	Local _nRecno		:= Recno()
	Local _cTmp01		:= GetNextAlias()
	Local aListMarca	:= {}
	Local nLinEncont	:= 0
	Local aEncontrad	:= {}
	Local aLinhaAux		:= {}
	Local lExibe		:= .T.
	Local nI 			:= 0
	Local nOpc  		:= 0
	Local oOk			:= LoadBitMap(GetResources(),"LBOK")
	Local oNo			:= LoadBitMap(GetResources(),"LBNO")
	Local aTitulo		:= { }
	Local aTam			:= { }
	Local oSay
	Local oDlg
	Local nListTam1		:= 600	//400					//380	//340	//280	//250
	Local nListTam2		:= 230					//220	//200	//170
	Local nI
	//	Nesta versao, a variavel lChk � criada como private no MGF06R20 para ser tratada l�, caso retrne marcada.
	Local _nI			:= 0
	Local oButProd		:= ""

	Private aList		:= {}
	Private oListBox

	Private _oCodDoc
	Private _cCodDoc	:= Space(tamSx3("CR_NUM")[1])

	Private _lCodDoc	:= .T. 			// Na Come�a a digitacao por codigo
	Private _nPosCpCHK	:= 2			// Posicao do campo a checar no array. Pode ser 2 para por Codigo

	cTitulo  			:= OemToAnsi(cTitulo)

	Aadd(aTitulo, " " )								// {" ", "Codigo", "Empresa", " " }
	Aadd(aTam	, 120  )									// {10, 30, 200, 01 }
	For _nI := 1 to len(aCpoMostra)
		Aadd(aTitulo, aCpoMostra[_nI,2] )			// Titulo do campo {" ", "Codigo", "Empresa", " " }
		Aadd(aTam	, aCpoMostra[_nI,3] * 1 )		// Tamanho do campo em Pixel {10, 30, 200, 01 } Em media, o Aria 12 tem a largyra de 11 pixel para cada letra
	Next

	If Select(_cTmp01) > 0
		dbSelectArea(_cTmp01)
		dbCloseArea()
	EndIf
	dbusearea(.T.,"TOPCONN",TcGenQry(	,,_cQuery),_cTmp01,.T.,.F.)
	dbSelectArea(_cTmp01)
	dbGoTop()

	If !eof()
		dbGoTop()
		While !eof()
			aLinhaAux		:= {}
			Aadd(aLinhaAux,  .F. )
			For _nI := 1 to len(aCpoMostra)
				//If _ni := 1															// Na Coluna B1_COD
				//	If AllTrim( &(aCpoMostra[_nI,1]) ) $ "817979/758711/855659"	// Se encontrado algum destes produtos
				//		aLinhaAux[1] := .T.											// Marca-o como selecionado
				//	Endif
				//Endif

				Aadd(aLinhaAux	,&(aCpoMostra[_nI,1]) )
			Next
			Aadd(aLinhaAux	," " )
			Aadd(aList , aLinhaAux )
			DbSkip()
		Enddo
	Else
		MsgStop( "Nao foi encontrado nenhum registro para montar esta tela de selecao de registros" )
		Aadd(aEncontrad , " " )
	Endif

	//������������������������������������������������������������������������Ŀ
	//� Monta a tela de selecao dos arquivos a serem importados				�
	//��������������������������������������������������������������������������
	If Len(aList) > 0 .and. lExibe ==.T.
		DEFINE MSDIALOG oDlg TITLE cTitulo From 005,005 TO 040,160 OF oMainWnd		// 040,100 OF oMainWnd
		@ 03,  05 Say "Lista de Documentos. Por isto, eles nao aparecem na selecao abaixo "    of oDlg Pixel
		//@ 07,  15 Say "Tecle <F7> para pesquisar/Marcar os produtos "    of oDlg Pixel

		If Len(aTitulo) == 2
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]) SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		ElseIf Len(aTitulo) == 3
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]) SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		ElseIf Len(aTitulo) == 4
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]), OemtoAnsi(aTitulo[4]) SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		ElseIf Len(aTitulo) > 4
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]), OemtoAnsi(aTitulo[4]), OemtoAnsi(aTitulo[5])  SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		Endif

		oListBox:bHeaderClick := {|x,nColuna| If(nColuna=1,(InvSelecao( @aList, oListBox, @lChk, oChk ), VerTodos( aList, @lChk, oChk ) ),NIL) }

		oListBox:SetArray(aList)
		oListBox:aColSizes := aTam

		If Len(aTitulo) == 2
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2] }}
		ElseIf Len(aTitulo) == 3
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2], aList[oListBox:nAt,3]}}
		ElseIf Len(aTitulo) == 4
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2], aList[oListBox:nAt,3], aList[oListBox:nAt,4]}}
		ElseIf Len(aTitulo) > 4
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2], aList[oListBox:nAt,3], aList[oListBox:nAt,4], aList[oListBox:nAt,5]}}
		Endif

		SetKey(VK_F4,{|| MarcaTodF4( @lChk, @aList, oListBox ) })			// Cria a associa��o da tecla F4, � func�o MarcaTodF4()
		SetKey(VK_F7,{|| F7_Documen( @lChk, oChk ) })						// Cria a associa��o da tecla F7, � func�o F7_Documen()

		@ 250, 010 CHECKBOX oChk Var lChk Prompt "&Marca/Desmarca Todos - < F4 >" Message "&Marca/Desmarca Todos < F4 >" SIZE 90,007 PIXEL OF oDlg ON CLICK MarcaTodos( lChk, @aList, oListBox )

		@ 250, 130 BUTTON	oButInv Prompt '&Inverter'  Size 30, 12 Pixel        Action ( InvSelecao( @aList, oListBox, @lChk, oChk ), VerTodos( aList, @lChk, oChk ) ) Message 'Inverter Selecao' Of oDlg
		DEFINE SBUTTON oBtnOk	FROM 250,180 TYPE 1 ACTION (nOpc := 1,oDlg:End())		ENABLE OF oDlg
		DEFINE SBUTTON oBtnCan	FROM 250,220 TYPE 2 ACTION (nOpc := 0,oDlg:End())		ENABLE OF oDlg
		@ 250, 290 BUTTON	oButProd Prompt '&Pesquisar Doc. <F7>'  Size 60, 12 Pixel Action ( F7_Documento( @lChk, oChk )  ) Message 'Procura Documento' Of oDlg

		ACTIVATE MSDIALOG oDlg CENTERED
		SetKey( VK_F4 , {||} )					// Cancela a associa��o da tecla F4, � func�o MarcaTodF4()	//Keyboard chr(27)
		SetKey( VK_F7 , {||} )					// Cancela a associa��o da tecla F7, � func�o F7_Documen()

		If nOpc == 0
			aList := {}
			If _lCancProg				// Se deve abandonar processamanto caso clique no botao cancelar, e ele foi cancelado (nOpc == 0)
				_lCancProg	:= .T.		// Cancelar o programa
				MsgStop("Processamento foi cancelado pelo usuario")
			Else
				_lCancProg	:=.F.		// Nao  cancelar o programa. Foi clicado o botao cancelar, porem o parametro _lCancProg recebido diz para nao abandonar o programa se isto ocorrese, mas somente limpar/desconsiderar as marca��es
			Endif
		Else
			_lCancProg	:=.F.			// Nao  cancelar o programa. Nao  foi clicado o botao cancelar.
		Endif
	Endif

	If Len(aList) <= 0 .or. Ascan(aList,{|x| x[1] ==.T.}) <= 0
		//Aviso("Inconsist�ncia", "Nao  foi selecionado nenhum registro. ",{"Ok"}	,,"Atencao:")
		aList := {}
	EndIf

	For _nI := 1 to len(aList)
		If aList[_Ni,1]
			If ValType( aList[_Ni,nPosRetorn + 1] ) == "C"
				//  No retornco de campos caracteres retiro os espa�os. Se o registro esta vazio retorno Space(1), pois no Oracle a clausula In
				//  nao encontra o conteudo ""
				If Empty( aList[_Ni,nPosRetorn + 1] )
					aList[_Ni,nPosRetorn + 1]	:= Space(1)
				Else
					aList[_Ni,nPosRetorn + 1]	:= AllTrim( aList[_Ni,nPosRetorn + 1])
				Endif
			Endif

			Aadd(aListMarca, aList[_Ni,nPosRetorn + 1] )	// nPosRetorn eh o campo que desejo retornar.  Aqui, Somo 1, devido ao campo para checkbox que foi incluido no come�o de cada linha.
		Endif
	Next

	If lChk						// Se Marquei listar todos
		aListMarca	:= {}		// Deixo o array de marcacao vazio, para nao implementar o filtro.
	Endif

	DbGoto(_nRecno)
	RestArea(aArea)
Return aListMarca

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F7_Documen �Autor  �Geronimo B Alves 	 � Data  �  13/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Ao ser teclado F7, abre janela para localizar e marcar      ���
���			� produto pesquisando-o atraves do codigo ou da descricao     ���
���			� Chamo a consulta padrao do SB1 de forma autometica colocando���
���			� a tecla F3 no teclado atraves do comando Keyboard chr(114)  ���
�������������������������������������������������������������������������͹��
���Uso		� AP														  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F7_Documen( lChk, oChk  )

	Local _nI := oListBox:nAt
	local oDlgPesq 	// , oBtOk , oBtCan, oOrdem, oBtPar
	Local oBuSemacao
//Local oButMarca, oButDesMar
	Local nOpcao
	nOpcao := 0
//Local cOrdem
//Local aOrdens := {}
//Local nOrdem := 1

//AAdd( aOrdens, "Codigo" )

	SetKey(VK_F7,{|| MarcaDesma() })						// Cria a associa��o da tecla F7, � func�o MarcaDesma()

	DEFINE MSDIALOG oDlgPesq TITLE "Digite o Documento" FROM 00,00 TO 140,360 PIXEL			// 100,500  // 050,200  // 075,300
	@ 002, 002 Say    "Digite o Documento a ser Pesquisado ou Marcado" of oDlgPesq Pixel

	@ 020, 002 Say    "Documento    :" of oDlgPesq Pixel
	@ 020, 040 MSGET  _oCodDoc VAR _cCodDoc Picture "@!" SIZE 070,09   F3 "SB1"    Valid chkCodDoc( ) When .T. OF oDlgPesq PIXEL	//When WhenCodigo() OF oDlgPesq PIXEL

	@ 050, 002 Say    "Tecle F7 para Marcar ou Desmarcar a Linha Atual."          of oDlgPesq Pixel
	@ 050, 300 BUTTON	oBuSemacao Prompt ' ' Size 001, 001 Pixel Action ( nOpcao := 99  ) Message ' ' // Of oDlgPesq

	If	_lCodDoc						// Se atualmente esta configurado para digitacao por codigo.
		_oCodDoc:LVISIBLECONTROL	:= .T.
		_oCodDoc:SetFocus()

	Else
		_oCodDoc:LVISIBLECONTROL	:= .F.

	Endif

	ACTIVATE MSDIALOG oDlgPesq //CENTER

	SetKey(VK_F7,{|| F7_Documento( @lChk, oChk ) })						// Cria a associa��o da tecla F7, � func�o F7_Documento(), que eera a funcao original da F7

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �chkCodDoc �Autor  �Geronimo B Alves 	 � Data  �  13/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Se encontro o codigo de produto digitado marco a linha.     ���
���			� Se nao for encontrar, navego ate que a linha do listBox seja���
���			� maior do que o codigo que foi digitado.                     ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function chkCodDoc()
	Local _nJ
	Local lRet := ! _lCodDoc		// Quando digitado o codigo do documento, retorno .F. para nao perder o foco. Quando for digitar a descricao, retorno .T. para perder o foco e ir para o campo Descricao
	Local lPosicionou := .T.

	For _nJ := 1 to len(aList)
		If _cCodDoc == aList[_nJ ,_nPosCpCHK ]	// Se encontrei o produto digitado

			If !empty( _cCodDoc )		// Se o _oCodDoc, estiver com brancos, nao marco a linha. Para evitar marcac��es involuntarias na 1� Linha.
				aList[ _nJ ,1]	:= .T.
			Endif
			oListBox:nAt	:= _nJ
			oListBox:Refresh()
			lPosicionou := .T.
			Exit

		ElseIf alltrim(_cCodDoc) $  aList[_nJ ,_nPosCpCHK ]		// Se a linha do ListBox contem o docuemtno digitado

			If !empty( _cCodDoc )		// Se o _oCodDoc, estiver com brancos, nao marco a linha. Para evitar marcac��es involuntarias na 1� Linha.
				aList[ _nJ ,1]	:= .T.
			Endif
			oListBox:nAt	:= _nJ
			oListBox:Refresh()
			lPosicionou := .T.
			Exit

		ElseIf _cCodDoc <  aList[_nJ ,_nPosCpCHK ]		// Se a linha do ListBox for maior que o docuemtno digitado
			oListBox:nAt	:= _nJ				// posiciono na linha
			oListBox:Refresh()
			lPosicionou := .T.
			Exit

		Endif
	Next

	If !lPosicionou									// Se nao achou nenhum elemento,
		oListBox:nAt	:= Len(aList)				// posiciono no ultimo elemento
		oListBox:Refresh()
	Endif

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarcaDesma �Autor  �Geronimo B Alves 	 � Data  �  14/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Marca/Desmarca o produto da linha atual do Browse.  (F7)    ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MarcaDesma( )
	aList[ oListBox:nAt ,1]	:= !aList[ oListBox:nAt ,1]	// Marco/Desmarco a linha atual
	oListBox:Refresh()									// Atualizo a tela
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina	�INVSELECAO�Autor  � Ernani Forastieri  � Data �  27/09/04	���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar para inverter selecao do ListBox Ativo		���
�������������������������������������������������������������������������͹��
���Uso		� Generico													���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function InvSelecao( aVetor, oLbx )
	Local  nI := 0
	_nDesmarca	:= 0		// Contador para identificar se existe linhas desmarcadas depois que o botao "Marcar Todos" foi ativado

	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := !aVetor[nI][1]

		If !aVetor[nI][1]		// Se encontrar linha que ficou desmarcada,
			_nDesmarca++		// Incremento _nDesmarca
		Endif
	Next nI

	oLbx:Refresh()

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina	� VERTODOS �Autor  � Ernani Forastieri  � Data �  20/11/04	���
�������������������������������������������������������������������������͹��
���Descricao � Funcao auxiliar para verificar se estao todos marcardos	���
���			� ou nao														���
�������������������������������������������������������������������������͹��
���Uso		� Generico													���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VerTodos( aVetor, lChk, oChkMar )
	Local lTTrue :=.T.
	Local nI		:= 0

	For nI := 1 To Len( aVetor )
		lTTrue := IIf( !aVetor[nI][1],.F., lTTrue )
	Next nI

	lChk := IIf( lTTrue,.T.,.F. )
	oChkMar:Refresh()

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina	�MARCATODOS�Autor  � Ernani Forastieri  � Data �  27/09/04	���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar para marcar/desmarcar todos os itens do	���
���			� ListBox ativo												���
�������������������������������������������������������������������������͹��
���Uso		� Generico													���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
	Local  nI := 0

	If lMarca							// Quando marco todos,
		_nDesmarca	:= 0				// _nDesmarca � zero
	Else								// Quando Desmarco todos,
		_nDesmarca	:= Len( aVetor )	// _nDesmarca � igual � quantidade de todas as linhas
	Endif

	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := lMarca
	Next nI

	oLbx:Refresh()

Return NIL

/*
�����������������������������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������ͻ��
���Rotina	�MarcaTodF4�Autor  �Geronimo Benedito Alves										� Data �	08/05/18  ���
�������������������������������������������������������������������������������������������������������������������͹��
���Descricao � Esta funcao � executada, quando o usuario tecla F4.													���
���			� 01 - Executa MarcaTodos com lChk invertido para alterar todas as linhas							  ���
���			� 02 - Executa VerTodos para ajustar lMarca (lChk) com o novo valor, que devera ser o inverso do atual ���
�������������������������������������������������������������������������������������������������������������������͹��
���Uso		� Generico																								���
�������������������������������������������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������������������������
*/

Static Function MarcaTodF4( lChk, aList, oListBox )
	lChk	:= ! lChk
	MarcaTodos( lChk,  @aList, oListBox )		 // Executa MarcaTodos com lChk invertido para alterar todas as linhas
	VerTodos  ( aList, @lChk,  oChk )			 // Executa VerTodos para ajustar lMarca (lChk) com o novo valor, que devera ser o inverso do anterior
Return NIL

// Atualiza o dicionario de Dados com o parametro correto
Static Function AtuSX6()

	If SX6->(!DbSeek(xFilial()+"MGF_COM14A"))
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_COM14A"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Cod Usuario + Qtd de Parametros de perguntas"
		SX6->X6_DESC1  := ""
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= "00000010;00329008;"
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif

	If SX6->(!DbSeek(xFilial()+"MGF_COM14B"))
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_COM14B"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Cod Usuario + Qtd de Parametros de perguntas"
		SX6->X6_DESC1  := ""
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= ""
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif

	If SX6->(!DbSeek(xFilial()+"MGF_COM14C"))
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_COM14C"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Cod Usuario + Qtd de Parametros de perguntas"
		SX6->X6_DESC1  := ""
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= ""
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif
Return




/*/{Protheus.doc} xAtuCT2
Rotina de atualzia��o dos lan�amentos cont�beis (CT2)
@type  Function
@author Joni Lima / Natanael Filho
@since 01/11/2019
@version 12
@param cxFil, c, Filial do lan�amento
@param cChave, c, Chave de 
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function xAtuCT2(aParam)

	Local cError    := ''

	Local cxEmp		:= aParam[1]
	Local cxFil		:= aParam[2]
	Local cChave	:= aParam[3]

	Local aCab 		:= {}
	Local aItem		:= {}
	Local aLinhas	:= {}

	Local lRet 		:= .T.

	Local cChavCT2
	Local nTamChv

	Private lMsErroAuto		:= .F.
	Private lMsHelpAuto		:= .T.
	Private CTF_LOCK		:= 0
	Private lSubLote		:= .T.


	RpcSetType( 3 )
	RpcSetEnv( cxEmp, cxFil,,,"CTB")

	ConOut("********************************************************************************************************************"+ CRLF)
	ConOut("----------- Inicio do processamento - xAtuCT2 - Aprov. Lanc Contabil - " + DTOC(dDATABASE) + " - " + TIME() + "------" )


	cChavCT2 	:= cxFil + cChave
	nTamChv		:= TamSx3('CT2_FILIAL')[1] + TamSx3('CT2_DATA')[1] + TamSx3('CT2_LOTE')[1] + TamSx3('CT2_SBLOTE')[1] + TamSx3('CT2_DOC')[1]
	cChavCT2	:= SubStr(cChavCT2,1,nTamChv)


	dbSelectArea("CT2")
	CT2->(dbSetOrder(1))//CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC

	If CT2->(DbSeek(cChavCT2))


		aAdd(aCab,  {'DDATALANC'     ,CT2->CT2_DATA   	,NIL} )
		aAdd(aCab,  {'CLOTE'         ,CT2->CT2_LOTE     ,NIL} )
		aAdd(aCab,  {'CSUBLOTE'      ,CT2->CT2_SBLOTE   ,NIL} )
		aAdd(aCab,  {'CDOC'          ,CT2->CT2_DOC      ,NIL} )
		aAdd(aCab,  {'CPADRAO'       ,''             	,NIL} )
		aAdd(aCab,  {'NTOTINF'       ,0                 ,NIL} )
		aAdd(aCab,  {'NTOTINFLOT'    ,0                 ,NIL} )

		While CT2->(!EOF()) .and. CT2->CT2_FILIAL + DTOS(CT2->CT2_DATA) + CT2->CT2_LOTE + CT2->CT2_SBLOTE + CT2->CT2_DOC = cChavCT2

			aItem:={}
			aAdd(aItem,  {'CT2_FILIAL'	,CT2->CT2_FILIAL   		,NIL} )
			aAdd(aItem,  {'CT2_LINHA'	,CT2->CT2_LINHA   		,NIL} )
			aAdd(aItem,  {'CT2_MOEDLC'	,CT2->CT2_MOEDLC   		,NIL} )
			aAdd(aItem,  {'CT2_DC'		,CT2->CT2_DC   			,NIL} )
			aAdd(aItem,  {'CT2_DEBITO'	,CT2->CT2_DEBITO   		,NIL} )
			aAdd(aItem,  {'CT2_CREDIT'	,CT2->CT2_CREDIT   		,NIL} )
			aAdd(aItem,  {'CT2_VALOR'	,CT2->CT2_VALOR   		,NIL} )
			aAdd(aItem,  {'CT2_ORIGEM'	,CT2->CT2_ORIGEM   		,NIL} )
			aAdd(aItem,  {'CT2_HP'		,CT2->CT2_HP   			,NIL} )
			aAdd(aItem,  {'CT2_EMPORI'	,CT2->CT2_EMPORI   		,NIL} )
			aAdd(aItem,  {'CT2_FILORI'	,CT2->CT2_FILORI   		,NIL} )
			aAdd(aItem,  {'CT2_HIST'	,CT2->CT2_HIST   		,NIL} )
			aAdd(aItem,  {'CT2_ZAPRO'	,"L"   					,NIL} )
			aAdd(aItem,  {'CT2_TPSALD'	,"1"   					,NIL} )
			aAdd(aItem,  {'CT2_ZMSGAP'	,"Lancamento Aprovado"  ,NIL} )
			aAdd(aItem,  {'LINPOS'		,"CT2_LINHA"   			,CT2->CT2_LINHA} )

			aAdd(aLinhas,aItem)

			CT2->(dbSkip())
		EndDo

		ConOut("[xAtuCT2]************************************************************************************************************"+ CRLF)
		Conout("Chamada de MsExecAuto. Array aLinha: " + Alltrim(Str(Len(aLinhas))) + ", " + "Array aCab: " + Alltrim(Str(Len(aCab))))
		Conout("Chave utilizada : " + cChavCT2)


		MSExecAuto({|x, y,z| CTBA102(x,y,z)}, aCab ,aLinhas, 4)

		If lMsErroAuto
			lMsErroAuto := .F.
			lRet := .F.
			If IsBlind()
				ConOut("[xAtuCT2]************************************************************************************************************"+ CRLF)
				Conout("ERRO Lancamento: Aprovacao Padrao")
			Else
				MsgAlert("ERRO Lancamento" , "Aprovacao Padrao")
			EndIf
		Else
			If IsBlind()
				ConOut("[xAtuCT2]************************************************************************************************************"+ CRLF)
				Conout("Lancamento Conclu�do: Aprovacao Padrao")
			Else
				MsgAlert("Lancamento Conclu�do" , "Aprovacao Padrao")
			EndIf
		Endif

		cFileLog := NomeAutoLog()
		cPath := ""

		If !Empty(cFileLog) .And. !lRet
			If (!IsBlind()) // COM INTERFACE GRAFICA
				MostraErro(cPath,cFileLog)
			Else // EM ESTADO DE JOB
				cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO

				ConOut(PadC("Automatic routine ended with error", 80))
				ConOut("Error: "+ cError)
			EndIf

		Endif

	EndIf


	ConOut('---------------------- Fim do processamento - xAtuCT2 - Aprov. Lanc Contabil - ' + DTOC(dDATABASE) + " - " + TIME()  )
	ConOut("********************************************************************************************************************"+ CRLF)

	RPCClearEnv()

Return