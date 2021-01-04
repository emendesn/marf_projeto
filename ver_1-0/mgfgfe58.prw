#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MGFGFE58
Cancelamento de Carga no MultiEmbarcador

@type function
@author Paulo da Mata
@since 21/01/2020
@version P12.1.17
@return Nil
/*/

User Function MGFGFE58

Local oproc := nil

If APMsgYesNo(OemToAnsi("Confirma o Cancelamento da Carga "+DAK->DAK_COD+" no MultiEmbarcador? "))
	fwmsgrun(,{|oproc| MGFGFE58C(oproc)}, "Aguarde...","Cancelando Carga...")
ELSE
	ApMsgAlert(OemToAnsi("Processo Cancelado Pelo Usuário!"))
Endif

Return

/*/{Protheus.doc} MGFGFE58C
Função que cancela a carga no MultiEmbarcador

@type function
@author Paulo da Mata
@since 21/01/2020
@version P12.1.17
@return Nil
/*/

Static Function MGFGFE58C(oproc)

	Local aAreaDAI := DAI->(GetArea())
   Local aAreaSF2 := SF2->(GetArea())
   Local aAreaDAK := DAK->(GetArea())

   Local cChv01 := DAK->(xFilial("DAK")+DAK_COD+DAK_SEQCAR)
   Local cCarga := ""
   Local cNfisc := ""
   Local aChv02 := {}
   Local nChv02 := 0
   
   // Processa os Itens da Carga (DAI)
   DAI->(dbSetOrder(1))

   If DAI->(dbSeek(cChv01))
 
      While DAI->(xFilial("DAI")+DAI_COD+DAI_SEQCAR) == cChv01 .And. DAI->(!Eof())

         AADD(aChv02,{DAI->(xFilial("DAI")+DAI_COD+DAI_SEQCAR+DAI_SERIE+DAI_NFISCA)})

         If valtype(oproc) == "O"
	         oproc:cCaption := ("Processando Cancelamento da Carga : "+AllTrim(DAI->DAI_COD)+;
                                " Padido : "+AllTrim(DAI->DAI_PEDIDO))
	         processmessages()
	      Endif

         DAI->(RecLock("DAI"),.F.)
         
         DAI->DAI_XINTME := " "
         DAI->DAI_XOPEME := "C"
         
         DAI->(MsUnlock())
         DAI->(dbSkip())

      EndDo

   EndIf
    
   // Processa o Cabeçalho de Notas Fiscais de Saída (SF2)
   SF2->(dbSetOrder(14))

   For nChv02 := 1 to Len(aChv02)

       cCarga := SubStr(aChv02[nChv02][1],07,6)
       cNfisc := SubStr(aChv02[nChv02][1],18,9)

       If ValType(oproc) == "O"
          oproc:cCaption := ("Processando Cancelamento da Carga : "+AllTrim(cCarga)+;
                             " Nota Fiscal : "+AllTrim(cNfisc))
	       processmessages()
	    Endif

       If SF2->(dbSeek(aChv02[nChv02][1]))

         SF2->(RecLock("SF2"),.F.)
         SF2->F2_XSTCANC := "S"
         SF2->(MsUnlock())
         SF2->(dbSkip())

      EndIf

   Next

	DAK->(RestArea(aAreaDAK))
	DAI->(RestArea(aAreaDAI))
   SF2->(RestArea(aAreaSF2))

   ApMsgInfo(OemToAnsi("Carga marcada para cancelamento no Multiembarcador. "+;
                       "Por favor aguardar 10 minutos para processamento, "+;
                       "e realizar reenvio"),OemToAnsi("ATENÇÂO"))

Return