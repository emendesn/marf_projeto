#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'

/*/
==============================================================================================================================================================================
{Protheus.doc} MTA107MNU
PE de inclusão de itens no menu da MATA107 (Lib SA)

@author Josué Danich Prestes
@since 04/10/2019 
@type Function  

@history 
    04/10/2019 - Criado com RTASK0010069
 /*/   
User Function MTA107MNU()

If Findfunction("U_MGFEST63")
	 aadd( aRotina, {"Log Aprovacao", "U_MGFEST63" , 0, 4, 0, nil} ) //Relatório log de aprovação de solicitação ao armazém                                                                 
Endif

Return