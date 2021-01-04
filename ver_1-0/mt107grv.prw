#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'

/*/
==============================================================================================================================================================================
{Protheus.doc} MT107GRV 
PE ap�s grava��o de libera��o de solicita��o ao armaz�m

@author Josu� Danich Prestes
@since 03/10/2019 
@type Function  

@history 
    03/10/2019 - Criado com RTASK0010069
 /*/   
User Function MT107GRV()

If Findfunction("U_MGFEST64")
	 U_MGFEST64() //Grava log de aprova��o de solicita��o ao armaz�m                                                                 
Endif

Return