#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FINA550.CH"


Static lPmsInt:= IsIntegTop(,.T.)
//Permite reposição manual do caixinha com valores acima do limite: 1 - Permite; 2 - Não permite.
STATIC lRpMnAcLim	:= SuperGetMV("MV_RPCXMN",.T.,"1") == "1"
//Permite que sejam realizadas reposições acima do valor do caixinha: T - Permite; F - Não Permite
STATIC lRpAcVlCx	:= SuperGetMV("MV_RPVLMA",.T.,.F.)




/*
=====================================================================================
Programa............: MGFFIN98
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Aprovação da Unidade
Doc. Origem.........: Contrato - GAP Caixinha
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela para Aprovação do Caixinha
=====================================================================================
*/
user function MGFFIN98()

	Local cFiltro	:= "Empty(ZE0_APRUNI)"
	Local cPerg		:= "MGFFINCAIX"

	Private oBrowse

	If Pergunte(cPerg,.T.)

		cFiltro	:= "!Empty(ZE0_APRUNI) .and. Empty(ZE0_APRCPA) .and. ZE0_CAIXA == '" + Alltrim(MV_PAR01) + "'"

		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias('ZE0')

		oBrowse:SetFilterDefault(cFiltro)

		oBrowse:SetDescription('Aprovação CAP')

		oBrowse:Activate()	
	EndIf

return

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Modelo de Dados
=====================================================================================
*/
Static Function ModelDef()

	local oModel := nil

	Local oStrZE1 	:= FWFormStruct(1,"ZE1")
	Local oStrZE0 	:= FWFormStruct(1,"ZE0",{ |x| ALLTRIM(x) $ 'ZE0_FILIAL,ZE0_VIAGEM;ZE0_ITEM,ZE0_MARKCP,ZE0_EMISSA;ZE0_NATURE;ZE0_DESCNA;ZE0_NRCOMP;ZE0_VALOR;ZE0_OBSLIN;ZE0_APRCPA' })

	Local bActive	:= {|oModel|xActivMdl(oModel)}
	Local bCommit	:= {|oModel|xCommit(oModel)}

	oModel := MPFormModel():New("XMGFFIN98", /*bPreValidacao*/,/*bPosValid*/,/*bCommit*/bCommit,/*bCancel*/ )

	oModel:AddFields("ZE1MASTER",/*cOwner*/,oStrZE1, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	oModel:AddGrid("ZE0DETAIL","ZE1MASTER",oStrZE0, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )

	oModel:GetModel("ZE0DETAIL"):SetDescription("Itens Para Aprovação")

	oModel:AddCalc("CALC", "ZE1MASTER", "ZE0DETAIL", "ZE0_VALOR", "ZE0__TOT", "SUM", {|oModel|xVldSum(oModel)}, ,"Total")

	oModel:SetRelation("ZE0DETAIL",{{"ZE1_FILIAL","xFilial('ZE1')"},{"ZE0_NAPRCP ", "ZE1_NUMAPR"}},ZE0->(IndexKey(3)))

	oModel:GetModel("ZE0DETAIL"):SetOnlyQuery()

	oModel:SetDescription("Aprovacao CAP")
	oModel:SetPrimaryKey({"ZE1_FILIAL","ZE1_NUMAPR"})

	oModel:SetActivate(bActive)

return oModel

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: View da Tela
=====================================================================================
*/
Static Function ViewDef()

	Local oView := nil

	Local oModel  	:= FWLoadModel('MGFFIN98')

	Local oStrZE1  := FWFormStruct( 2, "ZE1")
	Local oStrZE0  := FWFormStruct( 2, 'ZE0',{ |x| ALLTRIM(x) $ 'ZE0_MARKCP,ZE0_VIAGEM,ZE0_EMISSA;ZE0_NATURE;ZE0_DESCNA;ZE0_NRCOMP;ZE0_VALOR;ZE0_OBSLIN' },/*lViewUsado*/ )

	Local oCalc1	:= FWCalcStruct( oModel:GetModel( 'CALC') )

	oStrZE0:SetProperty( 'ZE0_MARKCP' , MVC_VIEW_ORDEM,'01')

	oStrZE0:SetProperty( '*' , MVC_VIEW_CANCHANGE,.F.)
	oStrZE0:SetProperty( 'ZE0_MARKCP' , MVC_VIEW_CANCHANGE,.T.)

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZE1' , oStrZE1, 'ZE1MASTER' )
	oView:AddGrid( 'VIEW_ZE0'  , oStrZE0, 'ZE0DETAIL' )
	oView:AddField( 'VIEW_CALC', oCalc1, 'CALC' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 25 )
	oView:CreateHorizontalBox( 'MEIO' 	  , 65 )
	oView:CreateHorizontalBox( 'INFERIOR' , 10 )

	oView:SetOwnerView( 'VIEW_ZE1' , 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZE0' , 'MEIO' )
	oView:SetOwnerView( 'VIEW_CALC', 'INFERIOR' )

return oView

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Menu da Tela do Caixinha
=====================================================================================
*/
Static function MenuDef()

	Local aRotina := {}

	//ADD OPTION aRotina Title "Liberacao Lote"  	Action 'U_xMGF98Apv()'		OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Aprovar"    		ACTION "VIEWDEF.MGFFIN98" OPERATION MODEL_OPERATION_INSERT ACCESS 0

Return aRotina

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Preenchimento da Tela para Aprovação
=====================================================================================
*/
Static Function xActivMdl(oModel)

	Local oMdlZE1 := oModel:GetModel("ZE1MASTER")
	Local oMdlZE0 := oModel:GetModel("ZE0DETAIL")
	Local nLine		:= 1
	Local nx		:= 0
	Local cQry	 	:= xQryLote()

	Local oStrZE0   := oMdlZE0:GetStruct() 

	Local cField	:= ""
	Local cConte	:= ""
	Local cFldQry	:= ""

	If oModel:GetOperation() == MODEL_OPERATION_INSERT

		oMdlZE1:LoadValue("ZE1_NUMAPR",GetSXENUM("ZE1","ZE1_NUMAPR"))
		oMdlZE1:LoadValue("ZE1_TIPO","C")
		oMdlZE1:LoadValue("ZE1_CAIXA",ZE0->ZE0_CAIXA)
		oMdlZE1:LoadValue("ZE1_DATA",dDataBase)						

		(cQry)->(dbGoTop())

		While (cQry)->(!EOF())			

			If nLine <> 1
				oMdlZE0:AddLine()
			EndIf			

			For nx := 1 to Len(oStrZE0:aFields)
				If !oStrZE0:aFields[nx,14] //Verifica Se não é Virtual

					cField  := oStrZE0:aFields[nx,3]//Pega o Id do Campo
					cFldQry := "(cQry)->" + cField //Monta Expressão para macro execução
					cConte  := &( cFldQry ) //Pega o Conteudo da Query

					If !Empty(cConte) //.and. Alltrim(cField) <> "ZE0_MARKCP"//Verifica se o existe conteudo
						oMdlZE0:GoLine(nLine)

						If oStrZE0:aFields[nx,4] == 'D'
							oMdlZE0:SetValue(cField,StoD(cConte))
						ElseIf oStrZE0:aFields[nx,4] == 'L'
							oMdlZE0:SetValue(cField,IIf(ALLTRIM(cConte)=="T",.T.,.F.))
						Else
							oMdlZE0:SetValue(cField,cConte)
						EndIf

					EndIf
				EndIf
			Next nx

			nLine ++

			(cQry)->(dbSkip())
		EndDo

	EndIf

return .t.

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Encontra os Titulos que precisam ser aprovados
=====================================================================================
*/
Static Function xQryLote()

	Local cNextAlias:= GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT ZE0.*
		FROM
		%Table:ZE0% ZE0
		WHERE
		ZE0.ZE0_APRUNI <> ' ' AND
		ZE0.ZE0_APRCPA = ' ' AND
		ZE0.ZE0_CAIXA = %Exp:ZE0->ZE0_CAIXA% AND
		ZE0.%NotDel%

	EndSql

return (cNextAlias)

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Validação para soma do Total
=====================================================================================
*/
Static Function xVldSum(oModel)

	Local oMldZE0 := oModel:GetModel("ZE0DETAIL")

	Local lRet := .F.

	If (oMldZE0:GetValue("ZE0_MARKCP"))
		lRet := .T.
	EndIf

return lRet

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Commit do modelo de dados
=====================================================================================
*/
Static Function xCommit(oModel)
	Local aArea	 	:= GetArea()
	Local oMdlZE1 	:= oModel:GetModel("ZE1MASTER")
	Local oMdlZE0 	:= oModel:GetModel("ZE0DETAIL")

	Local ni
	Local nx

	Local cConte

	Local lRet 		:= .T.

	Local cNumApr 	:= oMdlZE1:GetValue("ZE1_NUMAPR")

	Local aRet		:= {}
	Local _lFaz     := .F.
	For ni := 1  to oMdlZE0:Length()
		oMdlZE0:GoLine(ni)//Posiciona na Linha por garantia
		If (oMdlZE0:GetValue("ZE0_MARKCP"))
			xMGF98Apv(oMdlZE0:GetValue("ZE0_FILIAL"),oMdlZE0:GetValue("ZE0_VIAGEM"),oMdlZE0:GetValue("ZE0_ITEM"),oMdlZE1:GetValue("ZE1_NUMAPR"))
			_lFaz  := .T.
		EndIf
	Next ni	

	If oModel:VldData()

		If _lFaz

			FWFormCommit(oModel)
			confirmSX8()
			//aRet :=  xMGFGerSE2(cNumApr)
			//xMGFGerSEU(cNumApr,aRet)

			If Select("SEZTMP") > 0
				("SEZTMP")->(DbClosearea())
			Endif

			aAux	 	:= GetArea()
			Processa({|| aRet :=  xMGFGerSE2(cNumApr)},"Aguarde...","Gerando Titulo Financeiro...",.F.)
			Processa({|| xMGFGerSEU(cNumApr,aRet)},"Aguarde...","Gerando Movimento no Caixinha...",.F.)
			//xMGFGerSEU(cNumApr,aRet)
			RestArea(aAux)

			ni:=1

			oModel:DeActivate()

		Else
			Help(" ",1,'ERRO',,'Não Houve Marcação de Item no Grid da Aprovação' ,1,0,,,,,,{'Verifique A Marcação no Grid' } ) 
			RollBackSX8()
			lRet := .F.
			DisarmTransaction()
		EndIf
	Else
		RollBackSX8()
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf	

	RestArea(aArea)

return lRet

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Grava o Aprovador
=====================================================================================
*/
Static Function xMGF98Apv(cFilZE0,cViagem,cItem,cNumApr)

	Local aArea	 	:= GetArea()
	Local aAreaZE0	:= ZE0->(GetArea())

	dbSelectArea('ZE0')
	ZE0->(dbSetOrder(2))//ZE0_FILIAL+ZE0_VIAGEM+ZE0_ITEM

	If ZE0->(dbSeek(cFilZE0 + cViagem + cItem))
		RecLock("ZE0")
		ZE0->ZE0_MARKCP := .T.
		ZE0->ZE0_APRCPA := USRRETNAME(RETCODUSR())
		ZE0->ZE0_NAPRCP := cNumApr
		ZE0->ZE0_DTBAIX := dDataBase
		ZE0->(MsUnLock())
	EndIf

	RestArea(aAreaZE0)
	RestArea(aArea)	

Return

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Gera a Movimentação do caixinha
=====================================================================================
*/
Static Function xMGFGerSEU(cNumApr,aSE2)

	Local aArea := GetArea()
	Local aAreaSE0 := SE0->(GetArea())

	Local cNextAlias:= GetNextAlias()
	Local aDados	:= {}

	// Local cCaixa    := ""

	PRIVATE cCadastro := OemtoAnsi("Geraçao Automática de Caixinhas")  // "Manutencao de Caixinhas"
	Private lArgTAL   :=  (cPaisLoc == "ARG" .And. SEU->(FieldPos("EU_TALAO"))>0 ) 

	Pergunte("FIA550",.F.)

	dbSelectArea("SET")
	dbSetOrder(1)

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT ZE0.*
		FROM
		%Table:ZE0% ZE0
		WHERE
		ZE0.ZE0_NAPRCP = %Exp:cNumApr% AND
		ZE0.ZE0_FILIAL = %Exp:ZE0->ZE0_FILIAL% AND
		ZE0.ZE0_CAIXA = %Exp:ZE0->ZE0_CAIXA% AND
		ZE0.%NotDel%

	EndSql	

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())

		// If Empty(cCaixa)
		//  	cCaixa:= (cNextAlias)->ZE0_CAIXA
		// EndIf

		aDados	:= {}

		AADD(aDados,{"EU_CAIXA"  , (cNextAlias)->ZE0_CAIXA    , NIL})
		AADD(aDados,{"EU_TIPO"   , "00"                  	  , NIL}) //00 - Despesa, 01 - Adiantamento
		AADD(aDados,{"EU_HISTOR" , (cNextAlias)->ZE0_HISTOR   , NIL})
		AADD(aDados,{"EU_NRCOMP" , (cNextAlias)->ZE0_NRCOMP   , NIL})
		AADD(aDados,{"EU_VALOR"  , (cNextAlias)->ZE0_VALOR    , NIL})
		AADD(aDados,{"EU_ZCODF"  , (cNextAlias)->ZE0_ZCODF    , NIL})
		AADD(aDados,{"EU_ZLOJF"  , (cNextAlias)->ZE0_ZLJFUN   , NIL})
		AADD(aDados,{"EU_CCD"    , (cNextAlias)->ZE0_CCD      , NIL})
		AADD(aDados,{"EU_ZNATUR" , (cNextAlias)->ZE0_NATURE   , NIL})
		AADD(aDados,{"EU_ZNUMAPR", (cNextAlias)->ZE0_NAPRCP   , NIL})
		AADD(aDados,{"EU_ZRECSE2", aSE2[1]   				  , NIL})
		AADD(aDados,{"EU_ZNUMTIT", aSE2[2]   				  , NIL})

		U_MG97I560(aDados,3)

		(cNextAlias)->(dbSkip())
	EndDo


	(cNextAlias)->(DbClosearea())

	/*
	//************************
	// Gerando Reposição -> Não será mais aqui e sim na Baixa de Título
	//************************
	dbSelectArea("SET")
	dbSetOrder(1)  // filial + caixa
	dbSeek( xFilial()+cCaixa)
	U_MGFRepos("SET",SET->(RECNO()),4,.T.) // cAlias,nReg,nOpc,lAutomato=.T. não mostra Tela de Reposição!!!
	*/	 

	RestArea(aAreaSE0)
	RestArea(aArea)

return(Nil)

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Gera Titulo a Pagar
=====================================================================================
*/
Static Function xMGFGerSE2(cNumApr)

	Local aArea := GetArea()
	Local aAreaSE0 := SE0->(GetArea())

	Local aRet		:={}

	Local cNextAlias:= GetNextAlias()
	Local aDados	:= {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega funcao Pergunte									         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte("FIA550",.F.)


	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT 
		ZE0.ZE0_FILIAL,
		ZE0.ZE0_CAIXA,
		ZE0.ZE0_NAPRCP,
		SET1.ET_FORNECE,
		SET1.ET_LOJA,
		SUM(ZE0.ZE0_VALOR) ZE0_VALOR
		FROM 
		%Table:ZE0% ZE0
		INNER JOIN %Table:SET% SET1
		ON ZE0.ZE0_FILIAL = SET1.ET_FILIAL
		AND ZE0.ZE0_CAIXA = SET1.ET_CODIGO
		WHERE
		ZE0.ZE0_NAPRCP = %Exp:cNumApr% AND 
		ZE0.ZE0_FILIAL = %Exp:ZE0->ZE0_FILIAL% AND
		ZE0.ZE0_CAIXA = %Exp:ZE0->ZE0_CAIXA% AND 
		ZE0.%NotDel% AND
		SET1.%NotDel%

		GROUP BY ZE0_FILIAL,ZE0_CAIXA,ZE0_NAPRCP,ET_FORNECE,ET_LOJA

	EndSql	

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())


		aDados	:= {}

		AADD(aDados,{"E2_PREFIXO"	, "CXA"   							, NIL})
		AADD(aDados,{"E2_NUM"		, GETSXENUM("SE2","E2_NUM") 		, NIL})
		AADD(aDados,{"E2_TIPO"		, "DP"    							, NIL})
		AADD(aDados,{"E2_NATUREZ"	, "22213"    						, NIL})
		AADD(aDados,{"E2_FORNECE"	, (cNextAlias)->ET_FORNECE  		, NIL})
		AADD(aDados,{"E2_LOJA"		, (cNextAlias)->ET_LOJA    			, NIL})
		AADD(aDados,{"E2_EMISSAO"	, dDataBase   						, NIL})
		AADD(aDados,{"E2_VENCTO"	, dDataBase + 2   					, NIL})
		AADD(aDados,{"E2_VALOR"		, (cNextAlias)->ZE0_VALOR   		, NIL})
		AADD(aDados,{"E2_CCUSTO"	, "1411"    						, NIL})
		AADD(aDados,{"E2_HIST"	    , "CXA-"+(cNextAlias)->ZE0_CAIXA+"REPOSICAO"  	, NIL})

		aRet := U_MG97I050(aDados,3)
		confirmSX8()

		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(dbCloseArea())


	RestArea(aAreaSE0)
	RestArea(aArea)


return aRet