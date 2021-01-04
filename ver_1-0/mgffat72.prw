/*
=====================================================================================
Programa.:              MGFFAT72
Autor....:              Atilio Amarilla
Data.....:              11/04/2018
Descricao / Objetivo:   Verifica C6_PRCVEN na montagem do aCols na Devolucao de Compras.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              Chamado por PE M410PCDV, rotina MATA410. A410Devol.
=====================================================================================
*/
User Function MGFFAT72()

Local nPPrcVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPQtdVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPValVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPPosLin	:= Len( aCols )
//������������������������������������������������������������������������Ŀ
//�Verificacao de C6_PRCVEN na montagem do aCols			   �
//��������������������������������������������������������������������������
If IsInCallStack("A410Devol")
	If aCols[nPPosLin][nPQtdVen] > 0 .and. a410Arred(aCols[nPPosLin][nPPrcVen] * aCols[nPPosLin][nPQtdVen],"C6_VALOR") <>  aCols[nPPosLin][nPValVen]
		If aCols[nPPosLin][nPPrcVen] <> a410Arred(aCols[nPPosLin][nPValVen]/aCols[nPPosLin][nPQtdVen],"C6_PRCVEN")
			aCols[nPPosLin][nPPrcVen] := a410Arred(aCols[nPPosLin][nPValVen]/aCols[nPPosLin][nPQtdVen],"C6_PRCVEN")
		EndIf
	EndIf
EndIf

Return