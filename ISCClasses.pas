unit ISCClasses;

interface

uses
  SysUtils, Dialogs,

  ISCFuncoes, ISCConstantes;


type
  EValidacaoAPDU = class(Exception);

  TAPDU = class

  private
    FAppletAID: string;
    FPacoteAID: string;
    FAPDU_LE_NOME: string;
    FAPDU_LE_TELEFONE: string;
    FAPDU_GRAVAR_NOME: string;
    FAPDU_GRAVAR_TELEFONE: string;
    FAPDU_GRAVAR_OBSERVACAO: string;
    FAPDU_LE_OBSERCACAO: string;
    FAPDU_VERIFICAR_PIN: string;

    function GetAPDU_SELECT: string;
    procedure SetAppletAID(const Value: string);


  published


  public
    property APDU_SELECT: string read GetAPDU_SELECT;

    property APDU_LE_NOME:       string read FAPDU_LE_NOME;
    property APDU_LE_TELEFONE:   string read FAPDU_LE_TELEFONE;
    property APDU_LE_OBSERCACAO: string read FAPDU_LE_OBSERCACAO;

    property APDU_GRAVAR_NOME:       string read FAPDU_GRAVAR_NOME;
    property APDU_GRAVAR_TELEFONE:   string read FAPDU_GRAVAR_TELEFONE;
    property APDU_GRAVAR_OBSERVACAO: string read FAPDU_GRAVAR_OBSERVACAO;
    property APDU_VERIFICAR_PIN:     string read FAPDU_VERIFICAR_PIN;
                             
    property AppletAID: string read FAppletAID write SetAppletAID;
    property PacoteAID: string read FPacoteAID write FPacoteAID;

    procedure Inicializar;
    procedure ResultarAPDUGravarTelefone(const ADados: string);
    procedure ResultarAPDUGravarNome(const ADados: string);
    procedure ResultarAPDUGravarObservacao(const ADados: string);
    procedure ResultarAPDUVerificarPIN(const ADados: string);

    constructor Create;
    destructor Destroy; overload;
  end;

implementation

{ TAPDU }

constructor TAPDU.Create;
begin
  FAPDU_LE_NOME       := '0801000000';
  FAPDU_LE_TELEFONE   := '0802000000';
  FAPDU_LE_OBSERCACAO := '0805000000';
end;



destructor TAPDU.Destroy;
begin
  //
end;



function TAPDU.GetAPDU_SELECT: string;
begin
  Result:= '00A40400' + TFuncoes.RetornarTamanhoEmHexadecimalAPDU(AppletAID) + AppletAID;
  //Result:= '00A4040009617070696463617264';       
end;



procedure TAPDU.Inicializar;
begin
  //AppletAID:= TFuncoes.LerEmArquivoIni(ARQUIVO_CONFIGURACAO, SECAO_AID, CHAVE_AID_APPLET);
  //PacoteAID:= TFuncoes.LerEmArquivoIni(ARQUIVO_CONFIGURACAO, SECAO_AID, CHAVE_AID_PACOTE);
  AppletAID:= '617070696463617264';
end;



procedure TAPDU.ResultarAPDUGravarNome(const ADados: string);
begin
  FAPDU_GRAVAR_NOME:= '08030000' + TFuncoes.RetornarTamanhoEmHexadecimalAPDU(ADados) +
    ADados;
  //
end;



procedure TAPDU.ResultarAPDUGravarObservacao(const ADados: string);
begin
  FAPDU_GRAVAR_OBSERVACAO:= '08060000' + TFuncoes.RetornarTamanhoEmHexadecimalAPDU(ADados) +
     ADados;
end;



procedure TAPDU.ResultarAPDUGravarTelefone(const ADados: string);
begin
   FAPDU_GRAVAR_TELEFONE:= '08040000' + TFuncoes.RetornarTamanhoEmHexadecimalAPDU(ADados) +
     ADados;
end;



procedure TAPDU.ResultarAPDUVerificarPIN(const ADados: string);
begin
  FAPDU_VERIFICAR_PIN:= '08090000' + TFuncoes.RetornarTamanhoEmHexadecimalAPDU(ADados) +
     ADados;
end;



procedure TAPDU.SetAppletAID(const Value: string);
begin
  if Trim(Value) = '' then
    EValidacaoAPDU.Create('Applet AID incorreto - Valor (' + Trim(Value) + ')' );
    
  FAppletAID := Value;
end;



end.
