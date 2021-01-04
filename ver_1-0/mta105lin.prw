#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"   
/*              
+-----------------------------------------------------------------------+
¦Programa  ¦MTA105LIN   ¦ Autor ¦ WAGNER NEVES         ¦ Data ¦20.04.20 ¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦O objetivo deste fonte é chamar o ponto de entrada na       |
¦		   ¦linha da solciitação ao armazem                             ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA MARFRIG			                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR      ¦ DATA       ¦ MOTIVO DA ALTERACAO                    ¦
+-----------------------------------------------------------------------¦
¦                 ¦            ¦ 				                        ¦
+-----------------------------------------------------------------------+
*/

User Function MTA105LIN()

If FindFunction( "U_MGFEST60" )

	lRet := U_MGFEST60()

Endif

Return(lRet)