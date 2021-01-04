#ifdef SPANISH
	#define STR0001 "Proceso"
	#define STR0002 "En edicion"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Autorizar proceso"
	#define STR0008 "Copiar proceso"
	#define STR0009 "Proceso"
	#define STR0010 "Proceso"
	#define STR0011 "Descripcion del Proceso"
	#define STR0012 "Etapas subsecuentes"
	#define STR0013 "Etapas subsecuentes"
	#define STR0014 "Crear Dataset"
	#define STR0015 "Proceso de compras"
	#define STR0016 "Actualizando carpeta"
	#define STR0017 "Actualizando proceso"
	#define STR0018 "Actualizando dataset"
	#define STR0019 "Solamente es posible autorizar procesos en edicion"
	#define STR0020 "La modificacion de ese proceso hara con que se necesite otra autorizacion, ¿desea continuar?"
	#define STR0021 "Atencion"
	#define STR0022 "Actividad"
	#define STR0023 "Error en el flujo - Grid "
	#define STR0024 "Subproceso "
	#define STR0025 "Autorizacion de proceso"
	#define STR0026 "Copia de proceso"
	#define STR0027 "Modificacion de carpeta"
	#define STR0028 "Atencion"
	#define STR0029 "Este modulo no existe. Por favor, seleccione un modulo existente."
	#define STR0030 "Una etapa no debe referenciarse a si misma"
	#define STR0031 "Liberado"
	#define STR0032 "Bloqueado"
	#define STR0033 "Bloquear"
	#define STR0034 "Desbloquear"
	#define STR0035 "Box"
	#define STR0036 "No se puede autorizar procesos bloqueados"
	#define STR0037 "¿Desea realmente bloquear ese proceso?"
	#define STR0038 "¿Desea realmente desbloquear ese proceso?"
	#define STR0039 "El proceso ya esta bloqueado."
	#define STR0040 "El proceso ya esta desbloqueado."
#else
	#ifdef ENGLISH
		#define STR0001 "Process"
		#define STR0002 "In edition"
		#define STR0003 "View"
		#define STR0004 "Add"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "Release Process"
		#define STR0008 "Copy Process"
		#define STR0009 "Process"
		#define STR0010 "Process"
		#define STR0011 "Process Activity"
		#define STR0012 "Subsequent Stages"
		#define STR0013 "Subsequent Stages"
		#define STR0014 "Create Dataset"
		#define STR0015 "Purchase Process"
		#define STR0016 "Updating file"
		#define STR0017 "Updating process"
		#define STR0018 "Updating dataset"
		#define STR0019 "You can only release process in edition"
		#define STR0020 "Upon editing this process, you will need another release, continue? "
		#define STR0021 "Attention"
		#define STR0022 "Activity"
		#define STR0023 "Error in Flow - Grid "
		#define STR0024 "Sub-process "
		#define STR0025 "Process Release"
		#define STR0026 "Process Copy"
		#define STR0027 "File Change"
		#define STR0028 "Attention"
		#define STR0029 "This module does not exist. Please, select an existent module."
		#define STR0030 "A stage must not refers to themselves "
		#define STR0031 "Released"
		#define STR0032 "Blocked"
		#define STR0033 "Block"
		#define STR0034 "Unblock"
		#define STR0035 "Box"
		#define STR0036 "Blocked procedures cannot be approved"
		#define STR0037 "Do you really wish to block this procedure?"
		#define STR0038 "Do you really wish to unblock this procedure?"
		#define STR0039 "The procedure is already blocked."
		#define STR0040 "The procedure is already unblocked."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Processo" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Em edição" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Liberar Processo" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Copiar Processo" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Processo" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Processo" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Atividade do Processo" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Etapas Subsequentes" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Etapas Subsequentes" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Criar Dataset" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Processo de Compras" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Atualizando fichário" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Atualizando processo" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Atualizando dataset" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Somente é possível liberar processos em edição" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "A alteração desse processo fará com que seja necessário outra liberação, deseja continuar?" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Atenção" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Atividade" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Erro no Fluxo - Grid " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Sub-processo " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Liberação de Processo" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Copia de Processo" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Alteração de Fichário" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Atenção" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Este módulo não existe. Favor selecionar um módulo existente." )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Um etapa não deve referenciar ela mesmas" )
		#define STR0031 "Liberado"
		#define STR0032 "Bloqueado"
		#define STR0033 "Bloquear"
		#define STR0034 "Desbloquear"
		#define STR0035 "Box"
		#define STR0036 "Não é possível liberar processos bloqueados"
		#define STR0037 "Deseja realmente bloquear esse processo?"
		#define STR0038 "Deseja realmente desbloquear esse processo?"
		#define STR0039 "O processo já está bloqueado."
		#define STR0040 "O processo já está desbloqueado."
	#endif
#endif
