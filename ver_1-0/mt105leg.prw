#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"   
/*              
+-----------------------------------------------------------------------+
¦Programa  ¦MTA105LEG   ¦ Autor ¦ WAGNER NEVES         ¦ Data ¦20.04.20 ¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦O objetivo deste fonte é nomear a legenda                   ¦
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
User Function MT105LEG()
Local aItLeg := ParamIXB[1]
Local aRet   := { { "BR_AMARELO"    , 'Aguardando Aprovação-EPI' },;
                  { "BR_BRANCO"     , 'Aprovado ADM-EPI' },;
                  { "BR_AZUL"       , 'Rejeitado Tecnico-EPI' },;
                  { "BR_MARROM"     , 'Rejeitado Adm-EPI' },;
                  { "BR_PRETO_0"    , 'Aprovação Técnica e Aguardando Aprovação de Funcionário' },;
                  { "BR_LARANJA"    , 'Aguardando Aprovação Gerente SA Embalagem' },;       
                  { "BR_AZUL_CLARO" , 'SA de embalagem aprovado pelo gerente' },;           
                  { "BR_VIOLETA"    , 'SA de embalagem reprovada pelo gerente' },;       
                  {" BR_VERDE_ESCURO", 'Aprovado RH'} }
                  
aEval( aItLeg, { |x| aAdd( aRet, x ) } )
Return aRet