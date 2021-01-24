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

Local nPosDtUtil  := aScan(aHeader,{|x| Alltrim(x[2])="CP_ZDTUTIL"})
Local _lEst76  := .F.
Local _lFilaut := ''
Local _lEst76  :=  SuperGetMv( "MGF_EST76A" , ,".F." ) // Ativa ou não execução da rotina
Local _lFilAut :=  SuperGetMv( "MGF_EST76F" , ,"010003")   // Filial autorizada a executar essa rotina

If FindFunction( "U_MGFEST60" )
	lRet := U_MGFEST60()
Endif

If _lEST76	// Tratamento Embalagem	
	IF SB1->B1_TIPO='EM'
	/*
		IF ! cFilAnt $_lFilAut
			MSGINFO("Filial não autorizada ")
	    	lRet := .F.
			Return lRet
		EndIf
	*/
		IF cFilAnt $_lFilAut
			IF GDDeleted() = .F. .And. EMPTY(ACOLS[N,nPosDtUtil]) // SA em aprovação pelo gerente industrial
				MSGALERT("[MTA105LIN] Favor preencher a data de utilização do insumo!!!","Data Utilização Vazia !!!")
				lRet := .F.
			ENDIF
		Endif
	ENDIF
EndIf
Return(lRet)