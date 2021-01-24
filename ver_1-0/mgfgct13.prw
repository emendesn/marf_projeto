#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa............: MGFGCT13
Autor...............: Marcos Andrade         
Data................: 25/08/2017 
Descricao / Objetivo: Apresentar Nome do Fornecedor no Browse do Contrato
Doc. Origem.........: Contrato - GAP MGFCGT12
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Inicializador de Browse no campo virtual CN9_NOME
=====================================================================================
*/
User Function MGFGCT13() 
LOCAL cNome   := Space(40)  
LOCAL cCodigo := Space(06)  
LOCAL cLoja   := Space(02)    

IF !Empty(CNA->CNA_FORNEC)     //Compra
     cCodigo := CNA->CNA_FORNEC
     cLoja   := CNA->CNA_LJFORN
     cNome   := POSICIONE("SA2",1,xFilial("SA2")+cCodigo+cLoja,"A2_NOME") 
ELSEIF !Empty(CNA->CNA_CLIENT)//Venda
     cCodigo := CNA->CNA_CLIENT
     cLoja   := CNA->CNA_LOJACL
     cNome   := POSICIONE("SA1",1,xFilial("SA1")+cCodigo+cLoja,"A1_NOME")     
ENDIF

RETURN(cNome)   