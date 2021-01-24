#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFIN34
Autor...............: Mauricio Gresele
Data................: 18/10/2016 
Descricao / Objetivo: Rotina chamada pelo ponto de entrada MT103Fim
Doc. Origem.........: Financeiro - CRE34
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFIN34(ParamIxb)
                 
Local aArea := {SE1->(GetArea()),GetArea()}
Local nOpcARot := ParamIxb[1]
Local nOpcA := ParamIxb[2]
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local cMens := "" 
Local aMens := {}

If nOpcA == 1 // confirmado Botao OK	
	If nOpcaRot == 3 .or. nOpcaRot == 4 // inclusao ou classificacao
		If SF1->F1_TIPO == "D" .and. !Empty(SF1->F1_DUPL)
			If tcGetDb() == "ORACLE"
				cQ := "SELECT DISTINCT(D1_SERIORI||D1_NFORI) NFDEV "
			Else
				cQ := "SELECT DISTINCT(D1_SERIORI+D1_NFORI) NFDEV "
			Endif	
			cQ += "FROM "+RetSqlName("SD1")+" SD1 "
			cQ += "WHERE D1_FILIAL = '"+xFilial("SD1")+"' "
			cQ += "AND D1_SERIE = '"+SF1->F1_SERIE+"' "
			cQ += "AND D1_DOC = '"+SF1->F1_DOC+"' "
			cQ += "AND D1_TIPO = 'D' "
			cQ += "AND D1_FORNECE = '"+SF1->F1_FORNECE+"' "
			cQ += "AND D1_LOJA = '"+SF1->F1_LOJA+"' "
			cQ += "AND D1_DTDIGIT = '"+dTos(SF1->F1_DTDIGIT)+"' "
			cQ += "AND SD1.D_E_L_E_T_ = ' ' "
			cQ += "ORDER BY NFDEV "
			
			cQ := ChangeQuery(cQ)
			//MemoWrite("mgffin34.sql",cQ)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
			
			While (cAliasTrb)->(!Eof())
				aAdd(aMens,(cAliasTrb)->NFDEV)
				(cAliasTrb)->(dbSkip())
			Enddo
			
			(cAliasTrb)->(dbCloseArea())
			
			If !Empty(aMens)
				cMens := "Dev.Ref.:"
				aEval(aMens,{|x| cMens:=cMens+Alltrim(Subs(x,1,3))+IIf(Empty(Alltrim(Subs(x,1,3))),"","-")+Alltrim(Subs(x,4))+"/"})
				If !Empty(cMens)
					cMens := Subs(cMens,1,Len(cMens)-1)
				Endif
			Endif
			
			If !Empty(cMens)
				cQ := "SELECT R_E_C_N_O_ SE1_RECNO "
				cQ += "FROM "+RetSqlName("SE1")+" SE1 "
				cQ += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' "
				cQ += "AND E1_PREFIXO = '"+SF1->F1_SERIE+"' "
				cQ += "AND E1_NUM = '"+SF1->F1_DUPL+"' "
				cQ += "AND E1_TIPO = 'NCC' "
				cQ += "AND E1_CLIENTE = '"+SF1->F1_FORNECE+"' "
				cQ += "AND E1_LOJA = '"+SF1->F1_LOJA+"' "
				cQ += "AND E1_EMISSAO = '"+dTos(SF1->F1_DTDIGIT)+"' "
				cQ += "AND SE1.D_E_L_E_T_ = ' ' "
				
				cQ := ChangeQuery(cQ)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
				
				While (cAliasTrb)->(!Eof())
					SE1->(dbGoTo((cAliasTrb)->SE1_RECNO))
					If SE1->(Recno()) == (cAliasTrb)->SE1_RECNO
						SE1->(RecLock("SE1",.F.))
						SE1->E1_HIST := Alltrim(SE1->E1_HIST)+cMens
						SE1->(MsUnLock())
					Endif
					(cAliasTrb)->(dbSkip())
				Enddo
				
				(cAliasTrb)->(dbCloseArea())
			Endif
		Endif
	Endif
Endif					

aEval(aArea,{|x| RestArea(x)})						

Return()