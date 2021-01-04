/*
=====================================================================================
Programa.:              MGFEST25
Autor....:              Atilio Amarilla
Data.....:              25/01/2017
Descricao / Objetivo:   Chamado por PE A103CLAS. Manipulacao de aCols da Classificacao
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFEST25()

//Local cAlias	:= ParamIXB[1]
Local nPosTes
Local nPosZTes

//������������������������������������������������������������������������Ŀ
//�GAP MGFPER03 - Automacao de Vendas e Transferencias                     �
//�               Copia conteudo de D1_ZTES p/ D1_TES no aCols             �
//��������������������������������������������������������������������������
If SD1->( FieldPos( "D1_ZTES" ) ) > 0
	nPosTes := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
	nPosZTes := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ZTES"})
	
	If !Empty( aCols[Len(aCols),nPosZTES] )
		aCols[Len(aCols),nPosTES] := aCols[Len(aCols),nPosZTES]
	EndIf
EndIf

If l103Class .And. nPosTes > 0 .And. !Empty(aCols[Len(aCols),nPosTes])
	MaFisLoad("IT_TES","",Len(aCols))
	MaFisAlt("IT_TES",aCols[Len(aCols)][nPosTes],Len(aCols))
	MaFisToCols(aHeader,aCols,Len(aCols),"MT100")
	If ExistTrigger("D1_TES")
		RunTrigger(2,Len(aCols),,"D1_TES")
	EndIf
EndIf

Return