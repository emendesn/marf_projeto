#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"  
#INCLUDE 'TOTVS.CH' 
/*
============================================================================================================================
Programa.:              MGFCOM59 
Autor....:              Antonio Carlos        
Data.....:              10/11/2017                                                                                                            
Descricao / Objetivo:   Exclusão na tabela de amarração Contrato de Parceria x Filial de Entrega
Doc. Origem:            Compras - GAP ID104
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada executado no progama MATA125 
============================================================================================================================
*/  
User Function MGFCOM59()

    DbSelectArea("ZD5") 
   	ZD5->(dbSetOrder(1))   
    ZD5->(dBGotop())
    IF dBseek(xFilial("ZD5")+cA125Num)
       While !ZD5->( EOF() )  .AND.  cA125Num = ZD5->ZD5_CONTRA
             RecLock("ZD5",.F.)
             ZD5->(Dbdelete())
             MsUnLock()
             ZD5->(DbSkip())
       END
    ENDIF
 
Return()