#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"   
/*              
+-----------------------------------------------------------------------+
¦Programa  ¦MT107FIL    ¦ Autor ¦ WAGNER NEVES         ¦ Data ¦20.04.20 ¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦O objetivo deste fonte é mostrar no browse apenas as SA com ¦
¦           matricula em branco                                         ¦
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
User Function MT107FIL()
Local cFiltro := ''
If cFilAnt $GetMv("MGF_EPIFIL")
	cFiltro := " CP_ZMATFUN == ' ' .AND. CP_STATSA = 'B' " //.And. !SCR->(dbSeek(xFilial('SCR')+'SA'+PadR(SCP->CP_NUM,Len(SCR->CR_NUM))))"
else
	cFiltro := " CP_STATSA == 'B' .AND. !CP_ZSTATUS $'07|09' "//.And. !SCR->(dbSeek(xFilial('SCR')+'SA'+PadR(SCP->CP_NUM,Len(SCR->CR_NUM))))"
endif
Return (cFiltro)