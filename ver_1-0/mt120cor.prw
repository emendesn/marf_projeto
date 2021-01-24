#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT120COR
Autor...............: Joni Lima
Data................: 11/04/2017
Descrição / Objetivo: Após a montagem do Filtro da tabela SC7 e antes da execução da mBrowse do PC, utilizado para manipular o Array com as regras para apresentação das cores dos estatus na mBrowse.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/display/public/PROT/MT120COR+-+Manipula+regras+de+cores+de+status+na+mBrowse
Historico...........: 01/11/2018 - Odair Ferraz - Incluído cores no Browse, do Pedido de Compras, para AEs
=====================================================================================
*/

 User Function MT120COR() 

Local aCores := aClone(ParamIxb[1])
Local aCoresNew := {}
Local nCnt := 0


// Odair Ferraz - 01/11/2018
// retira rotina padrao de AE, para usar somente a customizada
If (nPos := aScan(aCores,{|x| Alltrim(x[2])=='BR_PRETO'})) > 0 
	aDel(aCores,nPos)
	aCores := asize(aCores,Len(aCores)-1)
Endif	
If (nPos := aScan(aCores,{|x| Alltrim(x[2])=='BR_CANCEL'})) > 0 
	aDel(aCores,nPos)
	aCores := asize(aCores,Len(aCores)-1)
Endif
aadd(aCoresNew,{'(C7_TIPO == 2 .and. C7_QTDACLA <> 0)','BR_PINK'})  				      			// AE em Recebimento (Pré-nota)
aadd(aCoresNew,{'(C7_TIPO == 2 .and. C7_QUJE<>0 .and.(C7_QUANT-C7_QUJE)>0)','BR_MARRON_OCEAN'})  	// AE Recebida Parcialmente   // 'BR_VERDE_ESCURO'
aadd(aCoresNew,{'(C7_TIPO == 2 .and. (C7_QUANT-C7_QUJE)<=0)','BR_MARRON'})          				// AE Recebida
If IsInCallStack("MATA121")
	aadd(aCoresNew,{'(C7_TIPO == 2 .and. C7_QUJE==0 .and. (C7_QUANT-C7_QUJE)>0)','BR_PRETO'})  		// AE Pendente
EndIf

//Joni
aadd(aCoresNew,{'C7_ZCANCEL=="S" ','BR_CANCEL'}) // bloqueio por divergencia de valor total

aadd(aCoresNew,{'C7_CONAPRO=="R" ','BR_VIOLETA'}) // Pedido rejeitado

//Adiciono as cores padroes do sistema
For nCnt:=1 to Len(aCores)
	aAdd(aCoresNew,{aCores[nCnt][1],aCores[nCnt][2]})
Next

Return(aCoresNew)


