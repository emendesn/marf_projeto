#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH' 

/*
=====================================================================================
Programa............: MGFFIN95
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Doc. Origem.........: Contrato - GAP Caixinha
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela para inclusão dos titulos
=====================================================================================
*/
user function MGFFIN95()

	Local oBrowse

	oBrowse := FWMBrowse():New()

	oBrowse:AddLegend( "Empty(ZE0_APRUNI).and.Empty(ZE0_APRCPA)"  , "RED"  , "Aguardando Aprovações" )
	oBrowse:AddLegend( "!Empty(ZE0_APRUNI).and.Empty(ZE0_APRCPA)" , "YELLOW" , "Aguardando Aprovação do CP" )
	oBrowse:AddLegend( "!Empty(ZE0_APRUNI).and.!Empty(ZE0_APRCPA)", "GREEN"    , "Titulo Aprovado" )

	oBrowse:SetAlias('ZE0')
	oBrowse:SetDescription('Titulos Caixinha')
	oBrowse:Activate()

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

	Local oModel	:= Nil

	Local oStrZDZ 	:= FWFormStruct(1,"ZDZ")
	Local oStrZE0 	:= FWFormStruct(1,"ZE0")

	Local bCommit	:= {|oModel|xCommit(oModel)}

	//oStrZDZ:SetProperty("ZDZ_VIAGEM",MODEL_FIELD_INIT,{||GETSXENUM("ZDZ","ZDZ_VIAGEM")})

	oStrZE0:SetProperty("*",MODEL_FIELD_WHEN,{|oMdlZE0,cField,xValue,nLine|MGF95When(oMdlZE0,cField,xValue,nLine)})

	oModel := MPFormModel():New("XMGFFIN95", /*bPreValidacao*/,{|oModel| TotCxa(oModel)}/*bPosValid*/,/*bCommit*/bCommit,/*bCancel*/ )

	oModel:AddFields("ZDZMASTER",/*cOwner*/,oStrZDZ, /*bPreValid*/,/*bPosValid*/, /*bCarga*/ )

	oModel:AddGrid("ZE0DETAIL"  ,"ZDZMASTER",oStrZE0, /*bLinePreValid*/, /*bLinePosValid*/, /*bPreValid*/, {|oMdlZE0, nLine, cAction, cField|xValDelGr(oMdlZE0, nLine, cAction, cField)},/*bPosValid*/, /*bCarga*/ )

	oModel:GetModel("ZE0DETAIL"):SetDescription("Itens Caixinhas")

	oModel:AddCalc("CALC"   , "ZDZMASTER", "ZE0DETAIL", "ZE0_VALOR" , "ZE0__TOT", "SUM",     {||.T.} , ,"Caixinha")

	oModel:SetRelation("ZE0DETAIL",{{"ZE0_FILIAL","xFilial('ZE0')"},{"ZE0_VIAGEM", "ZDZ_VIAGEM"}},ZE0->(IndexKey(1)))

	oModel:SetDescription("Titulos Caixinha")
	oModel:SetPrimaryKey({"ZDZ_FILIAL","ZDZ_VIAGEM"})

Return oModel




/*=====================================================================================
Autor...............: Joni Lima
Data................: 17/12/2018
Descrição / Objetivo: Consistir na Confirmação de TudoOK o valor Total das Despesas
Obs.................: o Total de Despesas não deve ultrapassar o saldo do Caixinha
=====================================================================================
*/

Static Function TotCxa(oMod)
	Local _lRet		:= .T.
	Local _nTotCxa	:= oMod:GetValue('CALC','ZE0__TOT')
	Local _cNumCxa	:= oMod:GetValue('ZDZMASTER','ZDZ_CAIXA')
	Local _nSaldo	:= 0
	Local cNextAlias:= GetNextAlias()

	If oMod:GetOperation() == MODEL_OPERATION_INSERT .OR. oMod:GetOperation() == MODEL_OPERATION_UPDATE

		If !Empty(_cNumCxa)
			dbSelectArea("SET")
			dbSetOrder(1)  // filial + caixa
			If dbSeek( xFilial()+_cNumCxa)
			
				If oMod:GetOperation() == MODEL_OPERATION_INSERT
					If Select(cNextAlias) > 0
						(cNextAlias)->(DbClosearea())
					Endif

					BeginSql Alias cNextAlias

						COLUMN SOMAZE0 AS NUMERIC(17,4)
						SELECT 
						Sum(ZE0.ZE0_VALOR) SOMAZE0 // SELECT ZE0.*
						FROM
						%Table:ZE0% ZE0
						WHERE
						ZE0.ZE0_APRUNI = ' ' AND
						ZE0.ZE0_CAIXA = %Exp:_cNumCxa% AND
						ZE0.%NotDel%

					EndSql

					_nSaldo	:= SET->ET_SALDO - (cNextAlias)->SOMAZE0
				Else
					_nSaldo	:= SET->ET_SALDO
				EndIF
				
				If _nSaldo <= 0
					Help(" ",1,'ERRO',,'Valor Total de Despesas Abertas Acima do Saldo da Caixinha',1,0,,,,,,{"Saldo de Caixinha Zerado de R$ " + Transform(_nSaldo, "@E 999,999,999,999.99")}) 
					_lRet:= .F.
				Else
					If _nTotCxa > _nSaldo 
						Help(" ",1,'ERRO',,'Valor Total de Despesas Abertas Acima do Saldo da Caixinha',1,0,,,,,,{"Favor corrigir as Despesas dentro do Saldo de R$ " + Transform(_nSaldo, "@E 999,999,999,999.99")}) 
						_lRet:= .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Return _lRet 


/*=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: View da Tela
=====================================================================================
*/
Static Function ViewDef()

	Local oView := nil

	Local oModel  	:= FWLoadModel('MGFFIN95')

	Local oStrZDZ 	:= FWFormStruct( 2, "ZDZ")
	Local oStrZE0  := FWFormStruct( 2, 'ZE0',{ |x| ALLTRIM(x) $ 'ZE0_ITEM,ZE0_EMISSA;ZE0_NATURE;ZE0_DESCNA;ZE0_NRCOMP;ZE0_VALOR;ZE0_OBSLIN;ZE0_LOGIN ' },/*lViewUsado*/ )

	Local oCalc1	:= FWCalcStruct( oModel:GetModel( 'CALC') )

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZDZ' , oStrZDZ, 'ZDZMASTER' )
	oView:AddGrid( 'VIEW_ZE0'  , oStrZE0, 'ZE0DETAIL' )
	oView:AddField( 'VIEW_CALC', oCalc1, 'CALC' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 45 )
	oView:CreateHorizontalBox( 'MEIO' 	  , 45 )
	oView:CreateHorizontalBox( 'INFERIOR' , 10 )

	oView:SetOwnerView( 'VIEW_ZDZ' , 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZE0' , 'MEIO' )
	oView:SetOwnerView( 'VIEW_CALC', 'INFERIOR' )

	oView:AddIncrementField( 'VIEW_ZE0', 'ZE0_ITEM' )

return oView

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Menu da Tela do Caixinha
=====================================================================================
*/	
Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "U_xMGFI95V()" 	  OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFFIN95" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "U_xMGFI95A()" 	  OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	    ACTION "U_xMGFI95E()" 	  OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Opção para Alteração do titulo de Caixinha
=====================================================================================
*/	
User Function xMGFI95A()

	Local aArea := GetArea()
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}

	If xValAlt()
		dbSelectArea("ZDZ")
		ZDZ->(dbSetOrder(1))//ZDZ_FILIAL+ZDZ_VIAGEM

		If ZDZ->(dbSeek(ZE0->(ZE0_FILIAL+ZE0_VIAGEM)))
			FWExecView('Alteração','MGFFIN95', MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons )
		EndIf
	Else
		Help(" ",1,'ERROALTER',,'Todos os Titulos desse processo já estão Baixados',1,0)
	EndIf

	RestArea(aArea)

Return

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Opção para Exclusão de titulo do Caixinha
=====================================================================================
*/	
User Function xMGFI95E()

	Local aArea := GetArea()
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}	

	If xValExcl()

		dbSelectArea("ZDZ")
		ZDZ->(dbSetOrder(1))//ZDZ_FILIAL+ZDZ_VIAGEM

		If ZDZ->(dbSeek(ZE0->(ZE0_FILIAL+ZE0_VIAGEM)))
			FWExecView('Exclusão','MGFFIN95', MODEL_OPERATION_DELETE, , { || .T. }, , ,aButtons )
		EndIf

	Else

		Help(" ",1,'ERROEXCLUS',,'Existem Titulos Baixados',1,0)	

	EndIf

	RestArea(aArea)

Return

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Opção para Visualização de titulo do Caixinha
=====================================================================================
*/
User Function xMGFI95V()

	Local aArea := GetArea()
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}	

	dbSelectArea("ZDZ")
	ZDZ->(dbSetOrder(1))//ZDZ_FILIAL+ZDZ_VIAGEM

	If ZDZ->(dbSeek(ZE0->(ZE0_FILIAL+ZE0_VIAGEM)))
		FWExecView('Exclusão','MGFFIN95', MODEL_OPERATION_VIEW, , { || .T. }, , ,aButtons )
	EndIf


	RestArea(aArea)

Return

/*
=====================================================================================
Autor...............: xCommit
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Commit customizado para salavar os campos conforme necessidade
=====================================================================================
*/
Static Function xCommit(oModel)

	Local oMdlMast := oModel:GetModel("ZDZMASTER")
	Local oMdlDeta := oModel:GetModel("ZE0DETAIL")

	Local oStrZDZ  := oMdlMast:GetStruct()
	Local cField   := '' 

	Local ni
	Local nx

	Local cConte

	Local lRet := .T.

	if oModel:GetOperation() <> MODEL_OPERATION_DELETE
		//Adiciona os dados do cabeçalho no Grid
		For ni := 1  to oMdlDeta:Length()
			For nx := 1 to Len(oStrZDZ:aFields)

				If !oStrZDZ:aFields[nx,14] //Verifica Se não é Virtual
					cField := oStrZDZ:aFields[nx,3]//Pega o Id do Campo
					cConte := oMdlMast:GetValue(cField) //Pega o Conteudo do Campo do Cabeçalho

					If !Empty(cConte)//Verifica se o existe conteudo
						cField := STRTRAN(cField,"ZDZ","ZE0") //Altera o nome do Campo do Cabeçalho para o campo do Grid
						oMdlDeta:GoLine(ni)//Posiciona na Linha por garantia
						oMdlDeta:LoadValue(cField,cConte)//Coloca o valor do cabeçalho no Grid
					EndIf

				EndIf

			Next nx

			//Limpa flegs para retornar para Aprovação
			If Empty(oMdlDeta:GetValue("ZE0_APRCPA"))
				oMdlDeta:LoadValue("ZE0_APRUNI","")
				oMdlDeta:LoadValue("ZE0_MARKUN",.F.)
				oMdlDeta:LoadValue("ZE0_NAPRUN","")
			EndIf

		Next ni	
	EndIf

	If oModel:VldData()
		FWFormCommit(oModel)
		oModel:DeActivate()
		confirmSX8()
	Else
		RollBackSX8()
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf	

return lRet

/*
=====================================================================================
Autor...............: MGF95When
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: When do Campo
=====================================================================================
*/
Static Function MGF95When(oMdlZE0,cField,xValue,nLine)

	Local lRet := Empty(oMdlZE0:GetValue("ZE0_APRCPA"))

	If !lRet
		Help(" ",1,'BAIXADO',,'Despesa Já Baixada',1,0)	
	EndIf

return lRet

/*
=====================================================================================
Autor...............: xValExcl
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Validação para Permissão da Exclusão
=====================================================================================
*/
Static Function xValExcl()

	Local aArea 	:= GetArea()
	Local aAreaZE0	:= ZE0->(GetArea())

	Local cNextAlias	:= GetNextAlias()
	Local lRet			:= .T.

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT ZE0.*
		FROM
		%Table:ZE0% ZE0
		WHERE
		ZE0.ZE0_APRCPA <> ' ' AND
		ZE0.ZE0_FILIAL = %Exp:ZE0->ZE0_FILIAL% AND
		ZE0.ZE0_CAIXA = %Exp:ZE0->ZE0_CAIXA% AND
		ZE0.ZE0_VIAGEM = %Exp:ZE0->ZE0_VIAGEM% AND
		ZE0.%NotDel%

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!Eof())
		lRet := .F.
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aAreaZE0)
	RestArea(aArea)

return lRet

/*
=====================================================================================
Autor...............: xValAlt
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Validação para permissão de Alteração
=====================================================================================
*/
Static Function xValAlt()

	Local aArea 	:= GetArea()
	Local aAreaZE0	:= ZE0->(GetArea())

	Local cNextAlias	:= GetNextAlias()
	Local lRet			:= .F.

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT ZE0.*
		FROM
		%Table:ZE0% ZE0
		WHERE
		ZE0.ZE0_APRCPA = ' ' AND
		ZE0.ZE0_FILIAL = %Exp:ZE0->ZE0_FILIAL% AND
		ZE0.ZE0_CAIXA = %Exp:ZE0->ZE0_CAIXA% AND
		ZE0.ZE0_VIAGEM = %Exp:ZE0->ZE0_VIAGEM% AND
		ZE0.%NotDel%

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!Eof())
		lRet := .T.
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aAreaZE0)
	RestArea(aArea)

return lRet

/*
=====================================================================================
Autor...............: xValDelGr
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Validação Deleção de Linha ja baixadas
=====================================================================================
*/
Static Function xValDelGr(oMdlZE0, nLine, cAction, cField)

	Local lRet := .T.

	If Alltrim(cAction) == "DELETE"
		If !Empty(oMdlZE0:GetValue("ZE0_APRCPA"))
			lRet := .F.
			Help(" ",1,'BAIXADO',,'Despesa Já Baixada',1,0)	
		EndIf
	EndIf

return lRet


