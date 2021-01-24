#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function MT410TOK()
	Local lRet     := .T.
	Local nOpc     := PARAMIXB[1] //2-Visualiza��o, 3-Inclus�o, 4-Altera��o, 1-Exclus�o

//PE para validar a exclus�o do pedido, mais detalhes no PE MGFTATBJ.PRW
	if lRet
		if nOpc == 1	//Exclus�o
			if FindFunction("U_MGFFATBJ")
				lRet := U_MGFFATBJ()
			endif
		endif
	endif

	If lRet
		If FindFunction("U_MGFFATAL")
			_cPoscmen  	:= ""
			_cPoscZmen 	:= ""
			_cPoscZmex 	:= ""
			cMen 		:= ""
			cZmen 		:= ""
			cZmex 		:= ""

			lRet := U_MGFFATAL(M->C5_MENNOTA,M->C5_ZMENNOT,M->C5_ZMENEXP,nOpc)

		Endif
	EndIf

	If lRet
		if FindFunction("U_MGFCRM34")
			lRet := U_MGFCRM34()
		endif
	EndIf

	If lRet
		If FindFunction("U_Fis19PV")
			lRet := U_Fis19PV()
		Endif
	Endif

	If lRet
		if FindFunction("U_MGFFAT55")
			lRet := U_MGFFAT55( nOpc )
		endif
	EndIf

//Verifica com o Taura se � permitido realizar Altera��o ou Exclus�o
//Na Abertura da Tela � realizada a mesma valida��o, porem caso o Usuario deixe a tela muito tempo
//aberta e depois confirme, fazemos novamente a valida��o para evitar problemas na integra��o
	If lRet .and. (Altera .or. (!Inclui .and. !Altera))
		If FindFunction("U_TAS01StatPV")
			lRet := U_TAS01StatPV({SC5->C5_NUM,IIf(Altera,2,IIf((!Inclui .and. !Altera),3,0))})
		Endif
	Endif

// recalcula tes baseado nas configuracoes atuais de tes inteligente
	If lRet
		if FindFunction("U_MGFFATAB")
			lRet := U_MGFFATAB()
		endif
	EndIf

// Rotina que pede o motivo de exclusao do pedido de venda. - Obrigatorio
	If lret .and. FindFunction("U_MGFFATB9") .and. nOpc == 1
		lret := U_MGFFATB9()
	endif
Return lRet

Static Function Fvalmennt(_cmen,_cmenerr,_cparusu)
	Local _lret:=.T.
	Local _xx

	For _xx:=1 To Len(_cmen)
		If At(SubStr(_cmen,_xx,01),_cparusu)>0 .And. SubStr(_cmen,_xx,01)<>Space(1)
			MsgStop("O Campo "+_cmenerr+" possui o caracter especial ==> "+SubStr(_cmen,_xx,01)+" n�o Valido,Favor verificar.","Valida��o Mensagem Nota")
			_lret    := .F.
			Exit
		EndIf
	Next _xx
Return _lret