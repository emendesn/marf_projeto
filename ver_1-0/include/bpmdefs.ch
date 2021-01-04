
#define	BPM_SHAPE_TAREFA		"001"
#define	BPM_SHAPE_SUBPROC		"002"
#define	BPM_SHAPE_LOOP			"003"
#define	BPM_SHAPE_SUBLOOP		"004"
#define	BPM_SHAPE_TIMEOUT		"005"
#define	BPM_SHAPE_TIMER		"006"
#define	BPM_SHAPE_MENSAGEM	"007"
#define	BPM_SHAPE_XOR			"008"
#define	BPM_SHAPE_AND			"009"
#define	BPM_SHAPE_INICIO		"010"
#define	BPM_SHAPE_FIM			"011"
#define	BPM_SHAPE_COMENTARIO	"012"
#define	BPM_SHAPE_DADO			"013"
#define	BPM_SHAPE_RISCO		"014"
#define	BPM_SHAPE_MELHORIA	"015"


/**
*	Definicoes para codigo de erro
**/

#define	BPM_ERROR_NONE				0

#define	BPM_ERROR_PROCLOCKED		1001
#define	BPM_ERROR_PROCCANCELED	1002
#define	BPM_ERROR_PROCFINISHED	1003
#define	BPM_ERROR_TASKFINISHED	1004

#define	BPM_ERROR_NOACTIVITIES	1005

/**
*	Definicoes para uso de funcoes de usuario
**/
#define	USERFUNC_ONLOAD	1
#define	USERFUNC_ONEXIT	2
