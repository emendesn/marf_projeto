#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
===============================================================================================
Programa.:              MGFFATB5
Autor....:              Paulo Henrique
Data.....:              19/08/2019
Descricao / Objetivo:   Atualizar tabela CDG, quando houver a inclusao das TAGS nProc e indProc
Doc. Origem:            Chamado RITM0024388 - TAGS
Solicitante:            Cliente
Uso......:              
Obs......:
===============================================================================================
*/
User Function MGFFATB5()

Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSF2	:= SF2->(GetArea())
Local cChvItNf  := ""
Local cChvPvNp  := ""
Local cChvPvTp  := ""
Local cItProc   := ""


dbSelectArea("SD2")
SD2->(dbSetOrder(3))
If SD2->(dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE)))
   
   While !SD2->(Eof()) .AND. SD2->(D2_DOC+D2_SERIE) == SF2->(F2_DOC+F2_SERIE)
      
      cChvItNf := SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
      cChvPvNp := Posicione("SC5",1,xFilial("SC5")+SD2->D2_PEDIDO,"C5_XNUMPRC")
      
      If !Empty(cChvPvNp)
      
         cChvPvTp := Posicione("SC5",1,xFilial("SC5")+SD2->D2_PEDIDO,"C5_XTIPPRC")
         cItProc  := Posicione("CCF",1,xFilial("CCF")+cChvPvNp+cChvPvTp,"CCF_IDITEM")
         
         dbSelectArea("CDG")
         CDG->(dbSetOrder(2))
         
         If CDG->(!dbSeek(xFilial("CDG")+"S"+cChvItNf+cChvPvNp+cChvPvTp))
            CDG->(RecLock("CDG",.T.))
            CDG->CDG_FILIAL  := xFilial("CDG")
            CDG->CDG_TPMOV   := "S"
            CDG->CDG_DOC     := SD2->D2_DOC
            CDG->CDG_SERIE   := SD2->D2_SERIE
            CDG->CDG_CLIFOR  := SD2->D2_CLIENTE
            CDG->CDG_LOJA    := SD2->D2_LOJA
            CDG->CDG_PROCESS := cChvPvNp
            CDG->CDG_TPPROC  := cChvPvTp
            CDG->CDG_SDOC    := SD2->D2_SERIE
            CDG->CDG_ITEM    := SD2->D2_ITEM
            CDG->CDG_ITPROC  := cItProc
            MsUnLock()
         EndIf

      Else
         Exit   
      EndIf  
           
      dbSelectArea("SD2")
	  SD2->(dbSkip())
	  
   EndDo  

EndIf

SD2->(RestArea(aAreaSD2))
SF2->(RestArea(aAreaSF2))

Return