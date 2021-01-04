#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"   
/*              
+-----------------------------------------------------------------------+
�Programa  �MTA105LEG   � Autor � WAGNER NEVES         � Data �20.04.20 �
+----------+------------------------------------------------------------�
�Descricao �O objetivo deste fonte � nomear a legenda                   �
+----------+------------------------------------------------------------�
� Uso      � ESPECIFICO PARA CLIENTE			                        �
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
Local aRet   := { { "BR_AMARELO", 'Aguardando Aprovacao-EPI' },;
                  { "BR_BRANCO",  'Aprovado ADM-EPI' },;
                  { "BR_AZUL",    'Rejeitado Tecnico-EPI' },;
                  { "BR_MARROM",  'Rejeitado Adm-EPI' },;
                  { "BR_PRETO_0", 'Aprovacao Tecnica e Aguardando Aprovacao de Funcionario' },;
                  {"BR_VERDE_ESCURO",'Aprovado RH'} }
aEval( aItLeg, { |x| aAdd( aRet, x ) } )
Return aRet