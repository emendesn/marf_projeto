#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa.:              EICPPO01
Autor....:              Leo Kume
Data.....:              19/10/2016
Descricao / Objetivo:   Fonte chamado do Ponto de Entrada para filtrar o despachante logado
Doc. Origem:            Easy Import Control - GAP EIC07
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de entrada padrao MVC EICPPO01                   
=====================================================================================
*/


user function MGFEIC01()

	Local aArea 	:= {}
	Local aAreaSW2 	:= {}	
	Local cParam 	:= If(Type("ParamIxb") = "A",ParamIxb1,If(Type("ParamIxb") = "C",ParamIxb,""))
	Local cAliasSY5	:= GetNextAlias()
	Local cQuery	:= ""

	If cParam == "FILTRO"
	
		aArea := GetArea()
		aAreaSW2 := SW2->(GetArea())	
		
		cQuery := " SELECT '*' FROM "+RetSqlName("SY5")
		cQuery += " WHERE Y5_FILIAL = '"+xFilial("SY5")+"'"
		cQuery += " 	AND Y5_ZUSER = '"+RetCodUsr()+"'"
		cQuery += " 	AND Y5_COD <> ''"
		cQuery += " 	AND D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSY5)

		If !(cAliasSY5)->(Eof()) 
				      
			DbSelectArea("SW2")	
				
			cFiltro := "GetAdvFVal('SY5','Y5_ZUSER',xFilial('SY5')+W2_DESP,1,'') == '"+RetCodUsr()+"'"
			SET FILTER TO &cFiltro
			
		EndIf
		(cAliasSY5)->(DbCloseArea())
		
		RestArea(aAreaSW2)
		RestArea(aArea)

	EndIf
	
	
	
return