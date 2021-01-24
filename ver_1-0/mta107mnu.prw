#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'

/*/
==============================================================================================================================================================================
{Protheus.doc} MTA107MNU
PE de inclus�o de itens no menu da MATA107 (Lib SA)

@author Josu� Danich Prestes
@since 04/10/2019 
@type Function  

@history 
    04/10/2019 - Criado com RTASK0010069
 /*/   
User Function MTA107MNU()

If Findfunction("U_MGFEST63")
	 aadd( aRotina, {"Log Aprovacao", "U_MGFEST63" , 0, 4, 0, nil} ) //Relat�rio log de aprova��o de solicita��o ao armaz�m                                                                 
Endif

Return