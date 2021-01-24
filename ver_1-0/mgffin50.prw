#Include 'Protheus.ch'
                      
/*
=====================================================================================
Programa............: SE5FI331()
Autor...............: Flávio Dentello
Data................: 14/03/2017 
Descricao / Objetivo: Ponto de entrada no final da compensação do título a receber
Doc. Origem.........: Financeiro - CRE34
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/          
          
User function MGFFIN50()

   
	If SE5->E5_TIPO = "NCC"
	
		dbSelectArea("SE1")
		SE1->(dbSetOrder(1))
		If SE1->(dbSeek(XFILIAL("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))// E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		   
			RecLock("SE5",.F.)
			SE5->E5_HISTOR := SE1->E1_HIST
			MsUnLock()
				
		EndIf
	EndIf                                    


Return                    


/// Fução que grava dados bancários nas baixas manuais FIDIC
User Function xMGFFIN50()
      
Local cBanco //:= SuperGetMV("MGF_FIN43A",,"999/999/999/999")
Local cFil   := SE5->E5_FILIAL
Local cPrefi := SE5->E5_PREFIXO
Local cNum   := SE5->E5_NUMERO
Local cParc  := SE5->E5_PARCELA
Local cTipo  := SE5->E5_TIPO
Local cFor   := SE5->E5_CLIFOR
Local cLoja  := SE5->E5_LOJA 
Local cSeq   := SE5-> E5_SEQ   
Local cData  := DtoS(SE5->E5_DATA)
     
    If SE5->E5_MOTBX = "FID"

		// GDN - 28/08/2018 - Ajuste para tratar o Banco e 
		// definir qual parametro considerar para FIDC
		Do Case
			Case ALLTRIM(SE5->E5_BANCO) = '237'
		       cBanco := SuperGetMV("MGF_FIN44A",,"999/999/999/999")
			Otherwise
		       cBanco := SuperGetMV("MGF_FIN43A",,"999/999/999/999")
		EndCase
         
		RecLock("SE5",.F.)    
		SE5->E5_BANCO   := SUBSTR(cBanco,1,3) 
		SE5->E5_AGENCIA := SUBSTR(cBanco,5,4)
		SE5->E5_CONTA   := SUBSTR(cBanco,10,5)
		MsUnLock()                                                                                     
		
		SE5->(dbSetOrder(2)) // E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ
		If SE5->(dbSeek(cFil+"JR"+cPrefi+cNum+cParc+cTipo+cData+cFor+cLoja+cSeq))

			RecLock("SE5",.F.)    
			SE5->E5_BANCO   := SUBSTR(cBanco,1,3) 
			SE5->E5_AGENCIA := SUBSTR(cBanco,5,4)
			SE5->E5_CONTA   := SUBSTR(cBanco,10,5)
			MsUnLock()                         
        
		EndIf
    EndiF
Return

