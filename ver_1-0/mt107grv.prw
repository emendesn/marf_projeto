#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'

/*/
==============================================================================================================================================================================
{Protheus.doc} MT107GRV 
PE após gravação de liberação de solicitação ao armazém

@author Josué Danich Prestes
@since 03/10/2019 
@type Function  

@history 
    03/10/2019 - Criado com RTASK0010069
 /*/   
User Function MT107GRV()

If Findfunction("U_MGFEST64")
	 U_MGFEST64() //Grava log de aprovação de solicitação ao armazém                                                                 
Endif

Return