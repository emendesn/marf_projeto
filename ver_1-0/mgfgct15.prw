/*
=====================================================================================
Programa.:              MGFGCT15
Autor....:              Atilio Amarilla
Data.....:              03/10/2017
Descricao / Objetivo:   Altera query na consulta de contratos, F3.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamado por PE CN120ESY, rotina CNTA120.
=====================================================================================
*/
User Function MGFGCT15()

Local cCod		:= RetCodUsr()
Local aGrp 		:= UsrRetGrp(UsrRetName(cCod)) //Carrega Grupos do usuario
Local cGrps     := ""

Local lVldVige  := GetNewPar("MV_CNFVIGE","N") == "N"

Local cQuery    := ""
Local cQuery1   := ""
Local cQuery2   := ""
Local cQuery3   := ""
Local cQuery4   := ""
Local cQuery5   := ""

Local nX

//Local lAutForn	:= Cn121GAutF()

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Carrega Grupos do usuario                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
For nX:=1 to len(aGrp)
	cGrps += "'"+aGrp[nX]+"',"
Next
cGrps := SubStr(cGrps,1,len(cGrps)-1)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁGAP 75_82 - AlteraГЦo de query para inclusЦo de nome de fornecedor      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cQuery1 := " SELECT "
cQuery1 += " CN9_NUMERO,"
cQuery1 += " MAX(CN9_REVISA) AS CN9_REVISA,"
cQuery1 += " CN9_FILCTR, "

// GAP 75_82 - InclusЦo de nome de fornecedor
cQuery1 += " CASE WHEN A2_NOME IS NOT NULL THEN A2_NOME ELSE CASE WHEN A1_NOME IS NOT NULL THEN A1_NOME ELSE ' ' END END AS CN9_ZNOME  "

cQuery1 += " FROM "
cQuery1 += RetSqlName("CN9") + " CN9 "


// GAP 75_82 - InclusЦo de nome de fornecedor
/*
cQuery1 += " INNER JOIN " + RetSqlName("CN1") + " CN1 ON CN1.D_E_L_E_T_ = ' ' "
cQuery1 += " AND CN1.CN1_FILIAL = CN9.CN9_FILCTR "
cQuery1 += " AND CN1.CN1_CODIGO = CN9.CN9_TPCTO  "
cQuery1 += " AND CN1.CN1_ESPCTR = 1 			 "
*/
/*
If IsInCallStack('CNTA121') .And. lAutForn
	cQuery1 += " CN1.D_E_L_E_T_ = ' ' "
	cQuery1 += " CN1.CN1_FILIAL = CN9.CN9_FILCTR AND "
	cQuery1 += " CN1.CN1_CODIGO = CN9.CN9_TPCTO  AND "
	cQuery1 += " CN1.CN1_ESPCTR = 1 			 AND "
EndIF
*/

cQuery1 += " INNER JOIN "+RetSqlName("CNN") + " CNN ON CNN.D_E_L_E_T_	= ' ' "
cQuery1+= " AND CNN.CNN_FILIAL = CN9_FILIAL "
cQuery1+= " AND CNN.CNN_CONTRA = CN9_NUMERO "

cQuery1 += " INNER JOIN "+RetSqlName("CPD") + " CPD ON CPD.D_E_L_E_T_	= ' ' "
cQuery1 += " AND CPD.CPD_FILAUT = '"+cFilAnt+"' "
cQuery1 += " AND CPD.CPD_FILIAL = CN9.CN9_FILIAL "
cQuery1 += " AND CPD.CPD_CONTRA = CN9.CN9_NUMERO "

cQuery1 += " INNER JOIN "+RetSqlName("CNC") + " CNC ON CNC.D_E_L_E_T_ = ' ' " 
cQuery1 += "     AND CNC_FILIAL = CN9_FILIAL "
cQuery1 += "     AND CNC_NUMERO = CN9_NUMERO "

cQuery1 += " LEFT JOIN "+RetSqlName("SA1") + " SA1 ON SA1.D_E_L_E_T_ = ' ' "
cQuery1 += "    AND A1_COD = CNC_CLIENT "
cQuery1 += "    AND A1_LOJA = CNC_LOJACL "

cQuery1 += " LEFT JOIN "+RetSqlName("SA2") + " SA2 ON SA2.D_E_L_E_T_ = ' ' "
cQuery1 += "    AND A2_COD = CNC_CODIGO "
cQuery1 += "    AND A2_LOJA = CNC_LOJA "

cQuery1 += " WHERE "
cQuery1 += " CN9.CN9_SITUAC =  '05' AND "
cQuery1 += " CN9.CN9_FILCTR <> ' '   AND "
cQuery1 += " CN9.CN9_REVATU   = ' ' AND "

If lVldVige
	cQuery1 += " ('"+DToS(dDataBase)+"' BETWEEN CN9_DTINIC AND CN9_DTFIM )  AND "
EndIf

cQuery2 := " CN9_VLDCTR ='2' "
cQuery3 := " CN9_VLDCTR IN(' ','1') AND (CNN.CNN_USRCOD   = '"+ cCod +"'"
If len(aGrp) > 0
	cQuery3 += " OR CNN.CNN_GRPCOD IN ("+ cGrps +"))"
Else
    cQuery3 += ")"
EndIf


cQuery4 += " AND CN9.D_E_L_E_T_	= ' ' "

cQuery4 += " GROUP BY CN9_NUMERO"

cQuery4 += ", CN9_FILCTR "

cQuery4 += ", A2_NOME, A1_NOME "

cQuery5 := " ORDER BY CN9_NUMERO,CN9_REVISA"

cQuery5 += ", CN9_FILCTR "

cQuery := cQuery1
cQuery += cQuery2+" "+cQuery4
cQuery += " UNION "
cQuery += cQuery1
cQuery += cQuery3+" "+cQuery4+" "+cQuery5

Return cQuery