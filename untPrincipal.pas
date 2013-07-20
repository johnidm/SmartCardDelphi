unit untPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CoolTrayIcon, ActnList, Menus, PCSCConnector, ExtCtrls,  ComCtrls, StdCtrls,

  ISCGlobal, ISCClasses, ISCFuncoes;

type
  ESCardException = class(Exception);

  TFrmPrincipal = class(TForm)
    CoolTrayIcon1: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    ActionList1: TActionList;
    ActSair: TAction;
    ActAID: TAction;
    ActPIN: TAction;
    ActGeral: TAction;
    Sair1: TMenuItem;
    Configurao1: TMenuItem;
    DefinirAIDs1: TMenuItem;
    Geral1: TMenuItem;
    DefinirPIN1: TMenuItem;
    Timer1: TTimer;
    ActConsole: TAction;
    Console1: TMenuItem;
    actInformacao: TAction;
    Informao1: TMenuItem;
    actSobre: TAction;
    Sobre1: TMenuItem;
    ActCadastro: TAction;
    StatusBar1: TStatusBar;
    Cadastro1: TMenuItem;
    procedure ActSairExecute(Sender: TObject);
    procedure Inicializar;
    procedure IncializarLeitora;
    procedure FecharLeitora;
    procedure FormShow(Sender: TObject);
    procedure PCSCConnector1CardInserted(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure PCSCConnector1CardActive(Sender: TObject);
    procedure PCSCConnector1CardInvalid(Sender: TObject);
    procedure PCSCConnector1Error(Sender: TObject; ErrSource: TErrSource;
      ErrCode: Cardinal);
    procedure PCSCConnector1CardRemoved(Sender: TObject);
    procedure ActAIDExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActCadastroExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses UntCadastroAID, UntDtmGeral, UntCadastroGeral;

{$R *.dfm}

procedure TFrmPrincipal.ActAIDExecute(Sender: TObject);
var
  oFrmCadastroAID: TFrmCadastroAID;

begin
  oFrmCadastroAID:= TFrmCadastroAID.Create(Self);
  try
    oFrmCadastroAID.ShowModal;

  finally
    FreeAndNil(oFrmCadastroAID)
  end;
end;

procedure TFrmPrincipal.ActCadastroExecute(Sender: TObject);
var
  oFrmCadastroGeral: TFrmCadastroGeral;
begin
  oFrmCadastroGeral:= TFrmCadastroGeral.Create(Self);
  try
    oFrmCadastroGeral.ShowModal;

  finally
    FreeAndNil(oFrmCadastroGeral)

  end;


end;

procedure TFrmPrincipal.ActSairExecute(Sender: TObject);
begin
  if (MessageDlg('Deseja realmente fechar a aplicação?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    Close;
  end;

end;

procedure TFrmPrincipal.FecharLeitora;
begin
  if DtmGeral.PCSCConnector1.Connect then
  begin
    DtmGeral.PCSCConnector1.Close;
    DtmGeral.PCSCConnector1.Disconnect;
  end;
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FecharLeitora;

  if Assigned(APDU) then
    FreeAndNil(APDU);
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  APDU:= TAPDU.Create;
  APDU.Inicializar;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  Inicializar;

  Timer1.Enabled:= True
end;

procedure TFrmPrincipal.IncializarLeitora;
begin
  if not DtmGeral.PCSCConnector1.Init then
    raise ESCardException.Create('Leitora não inicializada');

  DtmGeral.PCSCConnector1.UseReaderNum:= 0;

  if not DtmGeral.PCSCConnector1.Open then
    raise ESCardException.Create('Não foi possível abrir a leitora');

  if not DtmGeral.PCSCConnector1.Connect then
  begin
    raise ESCardException.Create('Não foi possível conectar a leitora');
  end; 

  StatusBar1.Panels[0].Text:= 'Leitora inicializada';

end;

procedure TFrmPrincipal.Inicializar;
begin
  CoolTrayIcon1.IconVisible:= True;
  CoolTrayIcon1.PopupMenu:= PopupMenu1;

end;

procedure TFrmPrincipal.PCSCConnector1CardActive(Sender: TObject);
begin
  CoolTrayIcon1.ShowBalloonHint('SCard', 'Incializando comunicação com a leitora', bitInfo, 10);
end;

procedure TFrmPrincipal.PCSCConnector1CardInserted(Sender: TObject);
begin
  CoolTrayIcon1.ShowBalloonHint('Cartão inserido', 'Cartão inserido com sucesso', bitInfo, 10);
end;

procedure TFrmPrincipal.PCSCConnector1CardInvalid(Sender: TObject);
begin
  CoolTrayIcon1.ShowBalloonHint('Cartão inválido', 'Cartão inserido inválido', bitWarning, 10);
end;

procedure TFrmPrincipal.PCSCConnector1CardRemoved(Sender: TObject);
begin
  CoolTrayIcon1.ShowBalloonHint('Cartão removido', 'Cartão removido com sucesso', bitInfo, 10)
end;

procedure TFrmPrincipal.PCSCConnector1Error(Sender: TObject;
  ErrSource: TErrSource; ErrCode: Cardinal);
begin
  CoolTrayIcon1.ShowBalloonHint('SCard', 'Erro fatal (Código do erro ' + IntToStr(ErrCode) + ')', bitError, 10);
end;

procedure TFrmPrincipal.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:= False;
 try
    IncializarLeitora

  except
    on E:ESCardException do
    begin
      CoolTrayIcon1.ShowBalloonHint('Atenção', E.Message, bitWarning, 10);
      StatusBar1.Panels[0].Text:= 'Leitora não inicializada';
    end;
    on E:Exception do
    begin
      CoolTrayIcon1.ShowBalloonHint('Erro', E.Message, bitError, 10);
      StatusBar1.Panels[0].Text:= 'Leitora não inicializada';
    end;

  end;

end;

end.
