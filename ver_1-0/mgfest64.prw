#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFEST64 
Gravação de log de SA chamada pelo PE MT107GRV, visualizacao de log por campos virtuais da SCP

@author Josué Danich Prestes
@since 03/10/2019 
@type Function  

@history 
    03/10/2019 - Criado com RTASK0010069
 /*/   
User Function MGFEST64()

Reclock("ZEZ",.T.)
ZEZ->ZEZ_FILIAL := SCP->CP_FILIAL
ZEZ->ZEZ_NUM    := SCP->CP_NUM
ZEZ->ZEZ_ITEM   := SCP->CP_ITEM
ZEZ->ZEZ_USER   := cusername
ZEZ->ZEZ_CODU   := retcodusr(cusername)
ZEZ->ZEZ_HORA   := time()
ZEZ->ZEZ_DATA   := date()
ZEZ->ZEZ_STATUS := SCP->CP_STATSA
ZEZ->(Msunlock())

Return

/*/
==============================================================================================================================================================================
{Protheus.doc} MGEST62V 
Visualizacao de log por campos virtuais da SCP

@author Josué Danich Prestes
@since 03/10/2019 
@type Function  

@history 
    03/10/2019 - Criado com RTASK0010069
 /*/  
User Function MGEST62V(_ccampo)

Local _cret := "       "


If SCP->CP_STATSA == "L"

    ZEZ->(Dbsetorder(5)) //ZEZ_FILIAL+ZEZ_NUM+ZEZ_ITEM
    If ZEZ->(Dbseek(SCP->CP_FILIAL+SCP->CP_NUM+SCP->CP_ITEM))

        If _ccampo == "CP_USERLIB"

            _cret := ZEZ->ZEZ_USER

        Endif

        If _ccampo == "CP_HORALIB"

            _cret := ZEZ->ZEZ_HORA

        Endif
  
        If _ccampo == "CP_DATALIB"

            _cret := dtoc(ZEZ->ZEZ_DATA)

        Endif

    Endif

Endif

Return _cret

    
