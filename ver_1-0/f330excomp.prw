#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
==========================================================================================
Programa............: F330EXCOMP
Autor...............: Paulo Fernandes
Data................: 26/04/2018
Descricao / Objetivo: Ponto de Entrada na rotina de compensação recebimento(FINA330).
Doc. Origem.........:
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Devido a lentidão na compensação de CR, foi solicitado pelo
                      Analista Cláudio o desvínculo da tabela SE5 com as tabelas FK1 e FKA
==========================================================================================
*/
User Function F330EXCOMP()
Local aArea			:= GetArea()
Local aAreaSE1		:= SE1->(GetArea())
Local aAreaSE5		:= SE5->(GetArea())
Local aTitSE1		:= PARAMIXB[1]			// array contendo os títulos a compensar
Local aRecnoSE5		:= PARAMIXB[2]			// array contendo o RECNO da tabela SE5
Local nRecnoSE5		:= SE5->(Recno())
Local nOpcA			:= PARAMIXB[3]			// 4=Exclusão; 5=Estorno
Local nX			:= 0					// controle loop FOR...NEXT
Local cAliasSE5		:= GetNextAlias()
Local cUpdSE1
Local cE5DOCUMEN	:= ""
Local lRet			:= .T.

/*
==========================================================
Estrutura do array aTitSE1
aTitSE1[nX,1],;//Prefixo
aTitSE1[nX,2],;//Numero
aTitSE1[nX,3],;//Parcela
aTitSE1[nX,4],;//Tipo
aTitSE1[nX,5],;//Loja
aTitSE1[nX,6],;//Data de vencimento
If(aTitSE1[nX,8],aTitSE1[nX,7],Transform(0,PesqPict("SE1","E1_SALDO"))),;//Saldo Compensar
aTitSE1[nX,25],;//Limite de Compensacao
aTitSE1[nX,13],;//Acréscimos
aTitSE1[nX,14],;//Decréscimos
aTitSE1[nX,10],;//CLiente+Loja
aTitSE1[nX,11],;//Nome CLiente
aTitSE1[nX,12],;//CGC
aTitSE1[nX,15],;//Historico
aTitSE1[nX,16],;//FIlial
aTitSE1[nX,17],;//Pis
aTitSE1[nX,18],;//Cofins
aTitSE1[nX,19],;//Csll
aTitSE1[nX,20]}}//Irrf
==========================================================
*/
dbSelectArea("FK1")
dbSetOrder(1)         			//FK1_FILIAL+FK1_IDFK1
dbSelectArea("FKA")
dbSetOrder(3)      				//FKA_FILIAL+FKA_TABORI+FKA_IDORIG

dbSelectArea("SE5")

For nX:=1 To Len( aRecnoSE5 )
	SE5->(dbGoTo(aRecnoSE5[nX]))
	MGLINKFK(aRecnoSE5[nX])
Next

SE5->(dbSetOrder(7))
For nX:=1 To Len(aTitSE1)
	cE5Documen := aTitSE1[nX][1]+aTitSE1[nX][2]+aTitSE1[nX][3]
	BeginSql Alias cAliasSE5
		SELECT SE5.R_E_C_N_O_ AS SE5RECNO
		  FROM %TABLE:SE5% SE5
		 WHERE SE5.E5_FILIAL  = %EXP:aTitSE1[nX][12]%
		   AND SE5.E5_PREFIXO = %EXP:SubStr(aTitSE1[nX][7],1,3)%
		   AND SE5.E5_NUMERO  = %EXP:SubStr(aTitSE1[nX][7],4,9)%
		   AND SE5.E5_PARCELA = %EXP:SubStr(aTitSE1[nX][7],13,2)%
		   AND SE5.E5_DATA    = %EXP:DTOS(CTOD(aTitSE1[nX][6]))%
		   AND SE5.E5_CLIFOR  = %EXP:SA1->A1_COD%
		   AND SE5.E5_LOJA    = %EXP:aTitSE1[nX][5]%
		   AND SUBSTRING(SE5.E5_DOCUMEN,1,14) = %EXP:cE5Documen%
		   AND SE5.%NOTDEL%
	EndSql
	TcSetField(cAliasSE5,"SE5RECNO","N",10,0)
	If (cAliasSE5)->SE5RECNO > 0
		SE5->(dbGoTo((cAliasSE5)->SE5RECNO))
		MGLINKFK((cAliasSE5)->SE5RECNO)
	Endif
	(cAliasSE5)->(dbCloseArea())

	begin transaction

		// Atualiza o adiantamento para encio ao SF
		cUpdSE1 := "UPDATE " + retSQLName("SE1") + " SE1"
		cUpdSE1 += " SET "
		cUpdSE1 += "	SE1.E1_XINTSFO = 'P'"
		cUpdSE1 += " WHERE"
		cUpdSE1 += "		SE1.SE1_PREFIXO	= '" + SubStr(aTitSE1[nX][7],1,3) + "'"
		cUpdSE1 += "		SE1.SE1_NUM	=     '" + SubStr(aTitSE1[nX][7],4,9) + "'"
		cUpdSE1 += "		SE1.SE1_PARCELA	= '" + SubStr(aTitSE1[nX][7],13,2) + "'"

		tcSQLExec( cUpdSE1 )

		// Atualiza o titulo no qual ocorreu o estorno
		cUpdSE1 := "UPDATE " + retSQLName("SE1") + " SE1"
		cUpdSE1 += " SET "
		cUpdSE1 += "	SE1.E1_XINTSFO = 'P'"
		cUpdSE1 += " WHERE"
		cUpdSE1 += "		SE1.SE1_PREFIXO	= '" + aTitSE1[nX][1] + "'"
		cUpdSE1 += "		SE1.SE1_NUM	=     '" + aTitSE1[nX][2] + "'"
		cUpdSE1 += "		SE1.SE1_PARCELA	= '" + aTitSE1[nX][3] + "'"

		tcSQLExec( cUpdSE1 )		

	end transaction 

Next

SE5->(dbGoTo(nRecnoSE5))

RestArea(aAreaSE1)
RestArea(aAreaSE5)
RestArea(aArea)

Return(lRet)

Static procedure MGLINKFK(nRecnoSE5)
Local cQuery            					// sentença SQL para update dos campos na SE5,FK1 e FKA
Local nRetSql		:= ""					// retorno execução sentença SQL
Local cCodFil		:= ""
Local cMovFKS		:= ""
Local cIDorig		:= ""
Local cTabOri		:= ""

// salva valores de link entre FK1 e FKA
cCodFil	:= SE5->E5_FILIAL
cIDorig := SE5->E5_IDORIG
cTabOri	:= SE5->E5_TABORI
// desvincula SE5 das tabelas FK1 e FKA
SE5->(RecLock("SE5",.F.))
SE5->E5_MOVFKS = ''
SE5->E5_IDORIG = ''
SE5->E5_TABORI = ''
SE5->(MsUnLock())
// exclui link na FK1
cQuery := "DELETE "
cQuery += RetSqlName("FK1")+" FK1 "
cQuery += "WHERE FK1.FK1_FILIAL = '" + cCodFil + "' "
cQuery += "  AND FK1.FK1_IDFK1 = '" + cIDOrig + "'"

nRetSql := tcSqlExec(cQuery)
If nRetSql == 0
	If "ORACLE" $ tcGetDB()
		tcSqlExec( "COMMIT" )
	EndIf
Else
	Aviso("Desvincula SE5->FK1->FKA","Problemas na exclusão do vínculo com a tabela FK1.",{"Ok"})
EndIf

// exclui link na FKA
cQuery := "DELETE "
cQuery += RetSqlName("FKA")+" FKA "
cQuery += "WHERE FKA.FKA_FILIAL = '" + cCodFil + "' "
cQuery += "  AND FKA.FKA_TABORI = '" + cTabOri + "' "
cQuery += "  AND FKA.FKA_IDORIG = '" + cIDOrig + "' "

nRetSql := tcSqlExec(cQuery)
If nRetSql == 0
	If "ORACLE" $ tcGetDB()
		tcSqlExec( "COMMIT" )
	EndIf
Else
	Aviso("Desvincula SE5->FK1->FKA","Problemas na exclusão do vínculo com a tabela FKA.",{"Ok"})
EndIf

Return
