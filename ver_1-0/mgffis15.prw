#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
====================================================================================================
Programa.:              MGFFIS15
Autor....:              Marcelo Carneiro         
Data.....:              02/02/2017 
Descricao / Objetivo:   GAP FIS20 - FUNDEPEC
Doc. Origem:            MIT044- Customizacoes Marfrig  Modulo Fiscal -GAP FIS20 - Fundepec_Assinada
Solicitante:            Cliente
Uso......:              
Obs......:              Criar Parametros 
====================================================================================================
*/


User Function MGFFIS15
/*local nRet := 0
Local cCalculo := PARAMIXB[1]
Local nItem := PARAMIXB[2] 
Local nVlrUPF := 100
Local nAlq := 19.21
Do Case
       Case cCalculo=="B"
            nRet := nVlrUPF
       Case cCalculo=="A"
            nRet := nAlq
       Case cCalculo=="V"
            nRet := nVlrUPF*MafisRet(nItem,"IT_QUANT")*(nAlq/100)
Endcase
*/
Local nRet       := 0 
Local cCalculo   := PARAMIXB[1]
Local nItem      := PARAMIXB[2]              
Local cFILFIS20  := GetMV('MGF_FIS20F',.F.,'01') // 010001 Filiais que tem o Imposto.
Local cAliqFIS20 := GetMV('MGF_FIS20A',.F.,0.25) // Aliquota do Imposto
Local cTESFIS20  := allTrim(GetMV('MGF_FIS20T',.F.,'001')) // TES que determina se � compra de Gado
Local cProduto   := ''
Local nPauta     := 0 
Local cTes       := ''
Local cUFForn    := ''							//UF do Fornecedor

//Se a rotina for o Doc. de entrada (Mata103) usa a variavel CUFORIG, se for Pedido de Compra usa o campo A2_ESTADO 
IIF(FUNNAME()=='MATA103',cUFForn := CUFORIG,cUFForn := SA2->A2_EST)


           
IF	cFilAnt $ cFILFIS20 .AND. cUFForn == 'GO'
	
    cTES     := MaFisRet(nItem,'IT_TES')
    IF cTES $ cTESFIS20
	    cProduto := MaFisRet(nItem,'IT_PRODUTO')
	    nPauta   := GetAdvFVal("SB1","B1_ZFUNDEP",xFilial("SB1")+cProduto,1,0)
	    IF nPauta <> 0 
		    IF cCalculo == 'B'
		    	nRet := MaFisRet(nItem,'IT_QUANT') * nPauta
		    ELSEIF cCalculo == 'A'                         
		    	nRet := cAliqFIS20
		    ELSEIF cCalculo == 'V' 
		        nRet := (cAliqFIS20/100)*(MaFisRet(nItem,'IT_QUANT') * nPauta)
		    EndIF 
		EndIF
		//msgAlert(nRet)
    EndIF
EndIF
Return nRet                      
******************************************************************************************************************************************
User Function FIS20_TXT(xTexto,xTipo)
Local cQuery := ''

default xTipo := 'X'

If xTipo != "0"
	Return xTexto
Endif
		
cQuery := " SELECT SUM(D1_VALIMPF)  FUNDEPEC  "
cQuery += " FROM "+RetSQLName("SD1") 
cQuery += " WHERE D1_FILIAL  = '" + SF1->F1_FILIAL + "' " 
cQuery += "   AND D1_FORNECE = '" + SF1->F1_FORNECE + "' " 
cQuery += "   AND D1_LOJA    = '" + SF1->F1_LOJA + "' " 
cQuery += "   AND D1_DOC     = '" + SF1->F1_DOC + "' " 
cQuery += "   AND D1_SERIE   = '" + SF1->F1_SERIE + "' " 
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_FUNDEPEC") > 0
	QRY_FUNDEPEC->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_FUNDEPEC",.T.,.F.)
dbSelectArea("QRY_FUNDEPEC")
QRY_FUNDEPEC->(dbGoTop())
IF QRY_FUNDEPEC->(!EOF()) .aND. QRY_FUNDEPEC->FUNDEPEC > 0 
     xTexto += CRLF
     xTexto += 'FUNDEPEC ............: '+ Transform(QRY_FUNDEPEC->FUNDEPEC,'@E 99,999,999.99') + CRLF
EndIF
// Colocar no NFESEFAZ cMensFis := U_FIS20_TXT(cMensFis)
QRY_FUNDEPEC->(dbCloseArea())                  

Return xTexto 


