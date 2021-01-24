#INCLUDE 'PROTHEUS.CH'
#include "TOPCONN.CH"

/*/{Protheus.doc} MGFCTB05
//TODO Fonte para replicar cadastro de fórmulas para outras filiais
@author leonardo.kume
@since 26/09/2017
@version 6

@type function
/*/
User Function MGFCTB05()

	aAdd(aRotina,{   "Replicar Formula","u_xCTB05()",0 , 5,0,NIL} )

Return aRotina

/*/{Protheus.doc} xCTB05
//TODO Função Principal replica do formulas para filiais selecionada
@author leonardo.kume
@since 26/09/2017
@version 6

@type function
/*/
User Function xCTB05()

	Local cPerg 	:= "MGFCTB05"
	Local aFiliais 	:= {}

	If Pergunte(cPerg,.t.)

		aFiliais := CTB05FIL()
		If Len(aFiliais) > 0
			CTB05REP(aFiliais)
		EndIF
	EndIf	
Return

/*/{Protheus.doc} CTB05FIL
//TODO Seleciona Filiais para replicar fórmula
@author leonardo.kume
@since 26/09/2017
@version 6

@type function
/*/
Static function CTB05FIL()
	local aAreaSM0	:= SM0->(GetArea())
	local aLstFil	:= {}
	local aFiliais	:= {}
	local cOpcoes	:= ""
	local nI		:= 0
	local cTitulo	:= "Seleção de filiais para replicar"
	local MvPar		:= "" //&(Alltrim(ReadVar()))		// Carrega Nome da Variavel do Get em Questao

	SM0->(DbGoTop())
	while !SM0->(EOF())
		If SM0->M0_CODIGO == cEmpAnt
			aadd(aLstFil,  allTrim(SM0->M0_FILIAL))
			cOpcoes += ALLTRIM(SM0->M0_CODFIL)
		EndIf
		SM0->(DBSkip())
	enddo

	If Len(aLstFil) == 0
		aadd(aLstFil,"-")
		cOpcoes := "-"
	EndIf

	if f_Opcoes(    @MvPar		,;    //Variavel de Retorno
	cTitulo		,;    //Titulo da Coluna com as opcoes
	@aLstFil	,;    //Opcoes de Escolha (Array de Opcoes)
	@cOpcoes	,;    //String de Opcoes para Retorno
	NIL			,;    //Nao Utilizado
	NIL			,;    //Nao Utilizado
	.F.			,;    //Se a Selecao sera de apenas 1 Elemento por vez
	6 ,; //TamSx3("A6_COD")[1],; //
	900,;				//No maximo de elementos na variavel de retorno
	)
		For nI := 1 to Len(MvPar) Step 6
			If !"*" $ Substr(MvPar,nI,6) 
				aAdd(aFiliais,Substr(MvPar,nI,6))
			EndIf
		Next nI
	endif


	SM0->(restArea(aAreaSM0))
return aFiliais

/*/{Protheus.doc} CTB05REP
//TODO Replicar para outras filiais
@author leonardo.kume
@since 26/09/2017
@version 6
@param aFiliais, array, Filiais que serão replicados a formula
@type function
/*/
Static Function CTB05REP(aFiliais)
	Local aAreaSM4 	:= SM4->(GetArea())
	Local cPar01 	:= iif(MV_PAR01 < MV_PAR02,MV_PAR01,MV_PAR02)
	Local cPar02 	:= iif(MV_PAR01 < MV_PAR02,MV_PAR02,MV_PAR01)
	Local aFormula 	:= {}
	Local nI 		:= 0
	Local nY 		:= 0

	DbSelectArea("SM4")
	SM4->(DbSetOrder(1))
	If SM4->(DbSeek(xFilial("SM4")+cPar01))
		While !SM4->(Eof()) .and. SM4->M4_CODIGO <= cPar02
			aAdd(aFormula,{SM4->M4_CODIGO,SM4->M4_DESCR,SM4->M4_FORMULA})
			SM4->(DbSkip())
		EndDo
	EndIf

	For nI 	:= 1 to Len(aFiliais)
		For nY := 1 to Len(aFormula)
			lInclui := !SM4->(DbSeek(aFiliais[nI]+aFormula[nY][1]))
			RecLock("SM4",lInclui)
			SM4->M4_FILIAL 	:= aFiliais[nI]
			SM4->M4_CODIGO 	:= aFormula[nY][1]
			SM4->M4_DESCR	:= aFormula[nY][2]
			SM4->M4_FORMULA	:= aFormula[nY][3]
			MsUnlock()
		Next nY
	Next nI

	ApMsgInfo("Registros replicados com sucesso!","Formulas")

	SM4->(RestArea(aAreaSM4))
Return

/*/{Protheus.doc} CTB05CHK
//TODO Verificar se existe formula e excluir nas outras filias
@author leonardo.kume
@since 26/09/2017
@version 6
@param cFormula, characters, Codigo com a formula 
@type function
/*/
User Function CTB05CHK(cFormula)

	Local cAliasSM4 := GetNextAlias()
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[3],If(Type("ParamIxb") = "C",ParamIxb,""))
	
	If cParam == 5

		BeginSQL Alias cAliasSM4
		SELECT R_E_C_N_O_ recsm4
		FROM 
		%table:SM4% SM4
		WHERE SM4.%notDel%
		AND SM4.M4_FILIAL <> %xFilial:SM4% 
		AND SM4.M4_CODIGO = %Exp:cFormula%
		EndSQL
	
		If !(cAliasSM4)->(Eof())
			If MsgYesNo("Deseja excluir para as demais filiais?")
				DbSelectArea("SM4")
				While !(cAliasSM4)->(Eof())	
					SM4->(DbGoTo((cAliasSM4)->recsm4))
					RecLock("SM4",.F.)
					SM4->(DbDelete())
					SM4->(MsUnlock())
					(cAliasSM4)->(DbSkip())
				EndDO
				ApMsgInfo("Registros Excluídos com sucesso!","Formulas")
			EndIf
		EndIf
		
		
		(cAliasSM4)->(DbCloseArea())
	EndIf

Return