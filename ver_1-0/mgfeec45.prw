#include 'protheus.ch'

/*/{Protheus.doc} MGFEEC45
//TODO Alterações de FFC para incluir campos nas telas e salvar motivo.
@author leonardo.kume
@since 16/02/2018
@version 6

@type function
/*/
user function MGFEEC45()

	If ValType(PARAMIXB) == "A" .And. ValType(PARAMIXB[1]) == "C" .And. PARAMIXB[1] == "BAIXA_FFC_CARREGA"

//		//Adiciona os campos na enchoice
		aAdd(aENCHOICE,'EEQ_MOTIVO')
//		//Habilita a edição
		aAdd(aALTERA,'EEQ_MOTIVO')

		//Adiciona os campos no grid
		Aadd(aHeader,{AvSx3("EEQ_DESCON" ,5),"EEQ_DESCON"  ,AvSx3("EEQ_DESCON" ,6),AvSx3("EEQ_DESCON" ,3),AvSx3("EEQ_DESCON" ,4),"","",AvSx3("EEQ_DESCON" ,2)})
//		Aadd(aHeader,{AvSx3("EEQ_MOTIVO" ,5),"EEQ_MOTIVO"  ,AvSx3("EEQ_MOTIVO" ,6),AvSx3("EEQ_MOTIVO" ,3),AvSx3("EEQ_MOTIVO" ,4),"","",AvSx3("EEQ_MOTIVO" ,2)})
		//Habilita a edição
		aAdd(aAlter, "EEQ_DESCON")
		//aAdd(aAlter, "EEQ_MOTIVO")

	EndIf

	If ValType(PARAMIXB) == "A" .And. PARAMIXB[1] == "BAIXA_FFC_GRAVA"
		TMP->EEQ_MOTIVO := M->EEQ_MOTIVO
	EndIf

return