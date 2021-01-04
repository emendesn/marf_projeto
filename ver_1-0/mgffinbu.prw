/*/{Protheus.doc} MGFFINBU
    //Descrição: (Função chamada pelo PE F240MARK desenvolvido para permitir a alteração da ordem 
    //dos campos na tela de bordero pagamentos.)
    @type  Function
    @author William Silva
    @since 10/07/2020
    @version 1.0
    /*/
#include 'protheus.ch'

User Function MGFFINBU()
  
Local aRet 		:= {}
Local aArea 	:= GetArea()

AADD(aRet,{"E2_OK",""," ",""})
	
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
dbSeek ("SE2")

	While !EOF() .And. (X3_ARQUIVO == "SE2")
		IF Alltrim(X3_CAMPO) == "E2_FILIAL" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_PREFIXO" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_NUM" 		.OR. ;
			Alltrim(X3_CAMPO) == "E2_PARCELA" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_TIPO" 		.OR. ;
			Alltrim(X3_CAMPO) == "E2_NATUREZ"	.OR. ;			
			Alltrim(X3_CAMPO) == "E2_FORNECE" 	.OR.;
			Alltrim(X3_CAMPO) == "E2_LOJA"	 	.OR.;
			Alltrim(X3_CAMPO) == "E2_NOMFOR" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_ZDTNPR"	.OR. ;
			Alltrim(X3_CAMPO) == "E2_EMISSAO" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_VENCTO" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_VENCREA" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_VALOR" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_VLCRUZ"	.OR.;
			Alltrim(X3_CAMPO) == "E2_VALLIQ" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_SALDO"		.OR. ;
			Alltrim(X3_CAMPO) == "E2_HIST" 		.OR. ;
			Alltrim(X3_CAMPO) == "E2_XOBS" 		.OR. ;
			Alltrim(X3_CAMPO) == "E2_ACRESC" 	.OR. ;			
			Alltrim(X3_CAMPO) == "E2_DECRESC" 	.OR.;
			Alltrim(X3_CAMPO) == "E2_ZJURBOL"	.OR.;
			Alltrim(X3_CAMPO) == "E2_IDCNAB" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_CODBAR"	.OR. ;
			Alltrim(X3_CAMPO) == "E2_LINDIG" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_FORBCO" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_FORAGE" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_FAGEDV" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_FORCTA"	.OR.;
			Alltrim(X3_CAMPO) == "E2_FCTADV" 	.OR. ;			
			Alltrim(X3_CAMPO) == "E2_XFINALI" 	.OR.;
			Alltrim(X3_CAMPO) == "E2_ZCODFAV"	.OR.;
			Alltrim(X3_CAMPO) == "E2_ZLOJFAV" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_ZPTAURA"	.OR. ;
			Alltrim(X3_CAMPO) == "E2_ZBCOFAV" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_ZAGEFAV" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_ZDVAFAV" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_ZCTAFAV" 	.OR. ;
			Alltrim(X3_CAMPO) == "E2_ZDVCFAV"	.OR.;
			Alltrim(X3_CAMPO) == "E2_ZCGCFAV"
					
		AADD(aRet,{X3_CAMPO,"",AllTrim(X3Titulo()),X3_PICTURE})

		ENDIF
	SX3->(dbSkip())
	Enddo

RestArea(aArea)

Return(aRet)