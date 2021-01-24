#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"

/*/{Protheus.doc} MGFEEC86 
Exportacao de campos na tela de Orcamento
@type  User Function
@author - Anderson Reis
@since 05/10/2020
@version 2020.01
@obs RTASK0011703 
/*/

User Function MGFEEC86 ()

Local oModel     := FWModelActive()
Local oModelCAB  := oModel:GetModel( 'EEC19MASTER' )
Local oModelIT   := oModel:GetModel( 'EEC19DETAIL' )
Local _lRet      := .t.
Local ncalc      := 0


If oModel:GetValue('EEC19MASTER','ZZC_INTERM') = "2"  .AND. ; //NAO
    oModel:GetValue('EEC19MASTER','ZZC_PERC')   > 0   
    
    APMsgInfo("Percentual nao pode ser maior que zero pois o campo OFFSHORE -NAO . Será zerado o campo % OFFSHORE ")
  
Endif

If oModel:GetValue('EEC19MASTER','ZZC_INTERM') = "2"  .AND. _lret
    
    For nx := 1 to oModelIT:Length()
        oModelIT:GoLine(nX)
        oModelIT:loadValue('ZZD_PRENEG',0)
    Next nx

Endif

If oModel:GetValue('EEC19MASTER','ZZC_INTERM') = "2"  //.or. M->ZZC_INTERM = "2"
    M->ZZC_PERC := 0
      
Endif


If oModel:GetValue('EEC19MASTER','ZZC_INTERM') = "1"    .AND. ;
        oModel:GetValue('EEC19MASTER','ZZC_PERC') > 0  .AND. ;
        oModel:GetValue('EEC19DETAIL','ZZD_PRECO') >= oModel:GetValue('EEC19DETAIL','ZZD_PRENEG')           .AND. ;
        oModel:GetValue('EEC19DETAIL','ZZD_PRECO')  > 0                                                     .AND. ;
        oModel:GetValue('EEC19DETAIL','ZZD_PRENEG')  > 0   .AND. ;
         __readvar = "M->ZZD_PRENEG"                                               
   
        oModelIT:LoadValue('ZZD_PRECO', M->ZZD_PRENEG * (1 -  (FWFLDGET("ZZC_PERC") / 100))  )
                                                      
    
            If oModel:GetValue('EEC19DETAIL','ZZD_PRECO') >= oModel:GetValue('EEC19DETAIL','ZZD_PRENEG') 
                APMsgInfo("Preço Unitario não pode ser maior ou igual ao Preço negociado , pois o campo  OFFSHORE- SIM")
                _lRet := .f.
            Endif

ElseIf oModel:GetValue('EEC19MASTER','ZZC_INTERM') = "1"                                                   .AND. ;
       oModel:GetValue('EEC19DETAIL','ZZD_PRECO')  >= oModel:GetValue('EEC19DETAIL','ZZD_PRENEG')          .AND. ;
       oModel:GetValue('EEC19DETAIL','ZZD_PRECO')  > 0                                                     .AND. ;
       oModel:GetValue('EEC19DETAIL','ZZD_PRENEG') > 0                                                     .AND. ; 
       oModel:GetValue('EEC19MASTER','ZZC_PERC') = 0  .AND. ;
       __readvar = "M->ZZD_PRENEG"

           oModelIT:LoadValue('ZZD_PRECO', M->ZZD_PRENEG * (1 -  (FWFLDGET("ZZC_PERC") / 100))  )
                                                   
    
                If oModel:GetValue('EEC19DETAIL','ZZD_PRECO') >= oModel:GetValue('EEC19DETAIL','ZZD_PRENEG') 
                    APMsgInfo("Preço Unitario não pode ser maior ou igual ao Preço negociado , pois o campo  OFFSHORE- SIM")
                    _lRet := .f.
                Endif

EndIf



Return _lRet

