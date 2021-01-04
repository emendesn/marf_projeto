#include "protheus.ch"

/*
==========================================================================================
Programa.:              MGFCOM86
Autor....:              Totvs
Data.....:              Jun/2018
Descricao / Objetivo:   Rotina chamada pelo PE MT100AG
Pedido Exportacao
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
==========================================================================================
*/
User Function MGFCOM86()

Local aArea := {SA2->(GetArea()),GU3->(GetArea()),GetArea()}        
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local cEstMun := ""

If cTipo $ "N/C" // normal/complementar
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+cA100For+cLoja))
		cEstMun	:= StaticCall(MGFTAC01,PesqCidade,SA2->A2_COD_MUN,SA2->A2_EST)
		If !Empty(cEstMun)
			cQ := "SELECT A2_CGC "
			cQ += "FROM "+RetSqlName("SA2")+" SA2 "
			cQ += "WHERE SA2.D_E_L_E_T_ = ' ' "
			cQ += "AND A2_CGC = '"+SA2->A2_CGC+"' "
			cQ += "GROUP BY A2_CGC "
			cQ += "HAVING COUNT(*) > 1 "
			
			cQ := ChangeQuery(cQ)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.F.)
			
			If (cAliasTrb)->(!Eof())
				GU3->(dbSetOrder(1))
				If GU3->(dbSeek(xFilial("GU3")+(cAliasTrb)->A2_CGC))
					// se estado+municipio do fornecedor estiver diferente do cadastrado na GU3, grava os dados do fornecedor atual na GU3
					If cEstMun != GU3->GU3_NRCID
						GU3->(RecLock("GU3",.F.))
						GU3->GU3_NRCID := cEstMun
						GU3->(MsUnLock())
					Endif
				Endif
			Endif			
						
			(cAliasTrb)->(dbCloseArea())
		Endif
	Endif
Endif

aEval(aArea,{|x| RestArea(x)})

Return()