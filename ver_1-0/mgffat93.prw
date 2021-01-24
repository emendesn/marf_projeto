#include "protheus.ch"

//---------------------------------------------------------------------------------
/*/{Protheus.doc} MGFFAT93 - Reenvio NF para Taura - Chamado por MA410MNU e OM200US
@author  Totvs
@since Agosto/2018
/*/

User Function MGFFAT93()

Local aArea := {SC6->(GetArea()),SF2->(GetArea()),GetArea()}
Local cGrupoPar := GetMv("MGF_INTNF")
Local aGrupo := UsrRetGrp(UsrRetName(RetCodUsr())) //Carrega Grupos do usuario
Local nCnt := 0
Local acampos := {}
Private _atots := {}

BEGIN SEQUENCE

// verifica se grupo do usuario estah contido nos grupos do parametro da Marfrig
For nCnt:=1 To Len(aGrupo)
	If Alltrim(aGrupo[nCnt]) $ Alltrim(cGrupoPar)
		lContinua := .T.
		Exit
	Endif
Next

If !lContinua

	u_mgfmsg("Grupo de acesso do usuário não está cadastrado no parâmetro 'MGF_INTNF'"+CRLF+;
				"Não será permitido acessar a rotina.","Atenção",,1)
	Break

Endif


If alltrim(funname()) = "OMSA200"

	If u_MGFmsg("Deseja reenviar NFs da carga " + DAK->DAK_FILIAL + "/" + DAK->DAK_COD + " para o Taura?","Atenção",,1,2,2)

		MGFFAT93C() //Envia para pedidos da carga posicionada

	Else

		u_mgfmsg("Processo Cancelado!","Atenção",,1)

	Endif

Else

	If u_MGFmsg("Deseja reenviar NF do pedido " + SC5->C5_FILIAL + "/" + SC5->C5_NUM + " para o Taura?","Atenção",,1,2,2)

		MGFFAT93E()	//Envia somente pedido de vendas posicionado

	Else

		u_mgfmsg("Processo Cancelado!","Atenção",,1)

	Endif
	

Endif	

AADD(aCampos,"Filial")
AADD(aCampos,"PV")
AADD(aCampos,"NF")
AADD(aCampos,"Status")

If len(_atots) > 0

	U_MGListBox( "Resultado do processamento" , aCampos , _atots )   

Endif
	
END SEQUENCE


aEval(aArea,{|x| RestArea(x)})	

Return()

//---------------------------------------------------------------------------------
/*/{Protheus.doc} MGFFAT93E - Execução de envio com SC5 posicionada
@author  Totvs
@since 21/09/2020
/*/
Static Function MGFFAT93E()

Local _aresults := {}

	SD2->(Dbsetorder(8)) //D2_FILIAL+D2_PEDIDO+D2_ITEMPV
	
	If !(SD2->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM)))
		aadd(_aresults,{SC5->C5_FILIAL,SC5->C5_NUM,"N/C","Pedido não está faturado."})
	Else	

		SF2->(Dbsetorder(1)) //F2_FILIAL+F2_DOC_F2_SERIE
		
		If SF2->(Dbseek(SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE))

			While SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE
				SF2->(RecLock("SF2",.F.))
				SF2->F2_ZTAUREE := "S"
				SF2->(MsUnLock())
				SF2->(dbSkip())
				aadd(_aresults,{SC5->C5_FILIAL,SC5->C5_NUM,SF2->F2_FILIAL+"/"+SF2->F2_DOC,"Pedido marcado para reenviar NF"})
			Enddo		

		Else

			aadd(_aresults,{SC5->C5_FILIAL,SC5->C5_NUM,"N/C","Falha em localizar NF Saída"})

		Endif

	Endif	

	_atots := _aresults

Return 

//---------------------------------------------------------------------------------
/*/{Protheus.doc} MGFFAT93C - Execução de envio por carga
@author  Totvs
@since 21/09/2020
/*/
Static Function MGFFAT93C()

Local _aresults := {}

DAI->(Dbsetorder(1)) //DAI_FILIAL+DAI_COD

If DAI->(Dbseek(DAK->DAK_FILIAL+DAK->DAK_COD))

	Do while DAK->DAK_FILIAL+DAK->DAK_COD == DAI->DAI_FILIAL+DAI->DAI_COD

		SC5->(Dbsetorder(1)) //C5_FILIAL+C5_NUM

		If SC5->(Dbseek(DAI->DAI_FILIAL+DAI->DAI_PEDIDO))

			MGFFAT93E()	//Envia somente pedido de vendas posicionado

			aadd(_aresults,_atots[1])

		Else

			aadd(_aresults,{DAI->DAI_FILIAL,DAI->DAI_PEDIDO,"N/C","Falha em pedido de vendas!"})

		Endif

		DAI->(Dbskip())

	Enddo

Else

	aadd(_aresults,{DAK->DAK_FILIAL,DAK->DAK_COD,"N/C","Falha em localizar itens da carga!"})

Endif

_atots := _aresults

Return
