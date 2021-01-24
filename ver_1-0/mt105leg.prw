#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"   
/*              
+-----------------------------------------------------------------------+
�Programa  �MTA105LEG   � Autor � WAGNER NEVES         � Data �20.04.20 �
+----------+------------------------------------------------------------�
�Descri��o �O objetivo deste fonte � nomear a legenda                   �
+----------+------------------------------------------------------------�
� Uso      � ESPECIFICO PARA MARFRIG			                        �
+-----------------------------------------------------------------------�
�           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            �
+-----------------------------------------------------------------------�
�PROGRAMADOR      � DATA       � MOTIVO DA ALTERACAO                    �
+-----------------------------------------------------------------------�
�                 �            � 				                        �
+-----------------------------------------------------------------------+
*/
User Function MT105LEG()
Local aItLeg := ParamIXB[1]
Local aRet   := { { "BR_AMARELO"    , 'Aguardando Aprova��o-EPI' },;
                  { "BR_BRANCO"     , 'Aprovado ADM-EPI' },;
                  { "BR_AZUL"       , 'Rejeitado Tecnico-EPI' },;
                  { "BR_MARROM"     , 'Rejeitado Adm-EPI' },;
                  { "BR_PRETO_0"    , 'Aprova��o T�cnica e Aguardando Aprova��o de Funcion�rio' },;
                  { "BR_LARANJA"    , 'Aguardando Aprova��o Gerente SA Embalagem' },;       
                  { "BR_AZUL_CLARO" , 'SA de embalagem aprovado pelo gerente' },;           
                  { "BR_VIOLETA"    , 'SA de embalagem reprovada pelo gerente' },;       
                  {" BR_VERDE_ESCURO", 'Aprovado RH'} }
                  
aEval( aItLeg, { |x| aAdd( aRet, x ) } )
Return aRet