#Include 'Protheus.ch'

/*/ {Protheus.doc} FA100ROT
P.E para manipular abuttons antes da montagem do browser 

@author Henrique Vidal
@since 02/02/2020
@return array 
/*/	

User Function FA100ROT()

    Local aRet := aClone(PARAMIXB[1])
	
    AADD(aRet, {'Importar Movimentos Bancários'   ,"U_MGFINT82",   0 , 1 }) 
	
Return aRet
