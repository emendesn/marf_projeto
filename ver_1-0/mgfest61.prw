#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*
=====================================================================================
Programa............: MGFCTB13
Autor...............: 
Data................: 01/01/2019
Descri√ß√£o / Objetivo: Manuten√ß√£o de Fechamento
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function MGFEST61()

Local aRet := {}
Local aParamBox := {}

Local dDatfec	:= GetMV("MV_ULMES")
Local dDatactb	:= ddatabase
Local cUserlib 	:= SuperGetMV('MGF_ABREST',.T.,'000000') //C√≥digos de usu√°rio que podem acessar a rotina

Local oDlg
Local lRet := .T.
    
If (__cuserid $ cUserlib)


	aAdd(aParamBox,{1,"Data Ultimo Fechamento v√°lido"	,dDatactb,"","","","",50,.T.})

	//aAdd(aParamBox,{2,"Atualiza Saldos CTB",1,IIF(cAtuaSal=="N",{"N√£o","Sim"},{"Sim","N√£o"}),40,"",.T.})

	If ParamBox(aParamBox,"Data Ultimo fechamento v√°lido",@aRet)

		
		nDias :=0
		nDias := ddatabase-aRet[1]
		
		cDat := ""
		cDat := substr(dtos(aRet[1]),7,2)
		
		//TRATA PRAZO PARA DIAS E DATAS
		If nDias < 40 .AND. cDat $ "28|29|30|31"
		
		
			// AJUSTA PARAMETRO
			PutMV("MV_ULMES",aRet[1])
        
			// LIMPA SB9
			_cQryB9	:= " "
			_cQryB9	:= " DELETE " + RetSqlName("SB9") + "  "
			_cQryB9	+= " WHERE B9_FILIAL= '" +xFilial("SB9") +"' AND B9_DATA > '"+dtos(aRet[1])+"' "
			TcSqlExec(_cQryB9)

			// LIMPA SBK
			_cQryBK	:= " "
			_cQryBK	:= " DELETE " + RetSqlName("SBK") + "  "
			_cQryBK	+= " WHERE BK_FILIAL= '" +xFilial("SBK") +"' AND BK_DATA > '"+dtos(aRet[1])+"' "
			TcSqlExec(_cQryBK)
			
			// LIMPA SBJ
			_cQryBK	:= " "
			_cQryBK	:= " DELETE " + RetSqlName("SBJ") + "  "
			_cQryBK	+= " WHERE BJ_FILIAL= '" +xFilial("SBJ") +"' AND BJ_DATA > '"+dtos(aRet[1])+"' "
			TcSqlExec(_cQryBK)
			
			// RESTAURA C2_VINI (VALOR EM PROCESSO) E C2_APRINI (VALOR APROPRIADO) CONSIDERANDO A DATA DO ⁄LTIMO FECHAMENTO
			_cQryBK	:= " UPDATE " +RetSQLName("SC2") +" SET C2_VINI1 = "
			
			//-- SOMA/SUBTRAI CUSTOS DE TODAS AS REQUISI«’ES/DEVOLU«’ES AT… DATA DO FECHAMENTO
			_cQryBK	+= " 	(	SELECT COALESCE(SUM(CASE SUBSTRING(D3_CF,1,2) WHEN 'RE' THEN D3_CUSTO1 ELSE -D3_CUSTO1 END),0) "
			_cQryBK	+= " 		FROM " +RetSQLName("SD3") +" "
			_cQryBK	+= " 		WHERE D_E_L_E_T_ = ' ' AND "
			_cQryBK	+= " 			D3_FILIAL = '" +xFilial("SD3") +"' AND "
			_cQryBK	+= " 			D3_OP = C2_NUM||C2_ITEM||C2_SEQUEN||C2_ITEMGRD AND "
			_cQryBK	+= " 			SUBSTRING(D3_CF,1,2) IN ('RE','DE') AND "
			_cQryBK	+= " 			SUBSTRING(D3_CF,3,1) <> '9' AND "
			_cQryBK	+= " 			D3_ESTORNO <> 'S' AND "
			_cQryBK	+= " 			D3_EMISSAO BETWEEN ' ' AND '" +DToS(aRet[1]) +"' ) - "
			
			//-- SUBTRAI CUSTO J¡ APROPRIADO EM PRODU«’ES AT… A DATA DO FECHAMENTO
			_cQryBK	+= " 	(	SELECT COALESCE(SUM(D3_CUSTO1),0) "
			_cQryBK	+= " 		FROM " +RetSQLName("SD3") +" "
			_cQryBK	+= " 		WHERE D_E_L_E_T_ = ' ' AND "
			_cQryBK	+= " 			D3_FILIAL = '" +xFilial("SD3") +"' AND "
			_cQryBK	+= " 			D3_OP = C2_NUM||C2_ITEM||C2_SEQUEN||C2_ITEMGRD AND "
			_cQryBK	+= " 			SUBSTRING(D3_CF,1,2) = 'PR' AND "
			_cQryBK	+= " 			D3_ESTORNO <> 'S' AND "
			_cQryBK	+= " 			D3_EMISSAO BETWEEN ' ' AND '" +DToS(aRet[1]) +"' ) , "
			
			//-- CALCULA VALOR APROPRIADO INICIAL DA OP CONSIDERANDO A DATA DO ⁄LTIMO FECHAMENTO 
			_cQryBK	+= " C2_APRATU1 = "
			
			//-- SOMA CUSTO J¡ APROPRIADO EM PRODU«’ES AT… A DATA DO FECHAMENTO
			_cQryBK	+= " 	(	SELECT COALESCE(SUM(D3_CUSTO1),0) "
			_cQryBK	+= " 		FROM " +RetSQLName("SD3") +" "
			_cQryBK	+= " 		WHERE D_E_L_E_T_ = ' ' AND "
			_cQryBK	+= " 			D3_FILIAL = '" +xFilial("SD3") +"' AND "
			_cQryBK	+= " 			D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD AND "
			_cQryBK	+= " 			SUBSTRING(D3_CF,1,2) = 'PR' AND "
			_cQryBK	+= " 			D3_ESTORNO <> 'S' AND "
			_cQryBK	+= " 			D3_EMISSAO BETWEEN ' ' AND '" +DToS(aRet[1]) +"' ) "
			
			//-- FILTRA OPS A SEREM CONSIDERADAS (EM ABERTO OU ENCERRADAS AP”S DATA DO ⁄LTIMO FECHAMENTO
			_cQryBK	+= " WHERE D_E_L_E_T_ = ' ' AND "
			_cQryBK	+= "	C2_FILIAL = '" +xFilial("SC2") +"' AND "
			_cQryBK	+= " 	(C2_DATRF = ' ' OR C2_DATRF > '" +DToS(aRet[1]) +"') "
			
			TcSqlExec(_cQryBK)

			Aviso("Marfrig - Par√¢metros de Fechamento","Atualiza√ß√£o finalizada",{"Ok"})
  		
  		else  
			Msgalert("Data inv√°lida para altera√ß√£o ")
		
        Endif
	Endif

Else
		Help( ,, 'MGFEST61',, 'Usu√°rio sem permiss√£o de acesso, par√¢metro MGF_ABREST', 1, 0)
EndIf


Return

