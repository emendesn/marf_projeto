#include 'protheus.ch'
#include 'parmtype.ch'

static cFiltro
/*
=====================================================================================
Programa.:              MGFEIC02
Autor....:              Leo Kume
Data.....:              19/10/2016
Descricao / Objetivo:   Fonte chamado do Ponto de Entrada para filtrar o despachante logado
Doc. Origem:            Easy Import Control - GAP EIC07
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de entrada padrao MVC EICDI500                   
=====================================================================================
*/

user function MGFEIC02()
	Local cRet := ""
	Local aArea := {}
	Local aAreaSW6 := {}
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb1,If(Type("ParamIxb") = "C",ParamIxb,""))
	Local cAliasSY5	:= GetNextAlias()
	Local cQuery	:= ""


	If cParam == "FILTRO" .or.cParam == "FILTRA_BROWSE"
		
		aArea := GetArea()
		aAreaSW6 := SW6->(GetArea())
		
	
		
		cQuery := " SELECT '*' FROM "+RetSqlName("SY5")
		cQuery += " WHERE Y5_FILIAL = '"+xFilial("SY5")+"'"
		cQuery += " 	AND Y5_ZUSER = '"+RetCodUsr()+"'"
		cQuery += " 	AND Y5_COD <> ''"
		cQuery += " 	AND D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSY5)
		
		If !(cAliasSY5)->(Eof())      

			DbSelectArea("SW6")
		
			cFiltro := "Alltrim(GetAdvFVal('SY5','Y5_ZUSER',xFilial('SY5')+W6_DESP,1,'')) == '"+Alltrim(RetCodUsr())+"'"
			SET FILTER TO &cFiltro
			cRet := cFiltro
		EndIf
		
		RestArea(aAreaSW6)
		RestArea(aArea)
	EndIf
	
	
	
return cRet