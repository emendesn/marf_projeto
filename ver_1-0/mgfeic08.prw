#Include 'Protheus.ch'
#Include 'Totvs.ch'

/*/{Protheus.doc} MGFEIC08
Gatilho para Atualização do campo de natureza na inclusão das despesas de importação

Demanda : RTASK0010962

@author Paulo da Mata
@since 07/04/2020
@version 6

@type function
/*/
User Function MGFEIC08()  

Local cVar    := AllTrim(M->E2_PREFIXO)
Local cPrefix := AllTrim(SuperGetMv("MGF_EIC08A",,"EIC"))
Local cNatFin := ""

If INCLUI
   If cVar == cPrefix
      cNatFin := "22401"
   EndIf
EndIf

Return(cNatFin)

/*/{Protheus.doc} MGFEIC8A
Gatilho para Atualização do campo de centro de custo, na inclusão das despesas de importação

Demanda : RTASK0010962

@author Paulo da Mata
@since 07/04/2020
@version 6

@type function
/*/
User Function MGFEIC8A()

Local cVar    := AllTrim(M->E2_PREFIXO)
Local cPrefix := AllTrim(SuperGetMv("MGF_EIC08A",,"EIC"))
Local cCstFin := ""

If INCLUI
   If cVar == cPrefix
      cCstFin := "2212"
   EndIf
EndIf

Return(cCstFin)