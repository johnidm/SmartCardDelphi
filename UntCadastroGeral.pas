unit UntCadastroGeral;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frmModelo, ComCtrls, StdCtrls, Buttons, ExtCtrls,

  ISCFuncoes, ISCGlobal;

type
  TFrmCadastroGeral = class(TFrmModelos)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel7: TPanel;
    Label1: TLabel;
    EdtNome: TEdit;
    Label2: TLabel;
    EdtTelefone: TEdit;
    MnmObservacoes: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    EdtPIN: TEdit;
    Label5: TLabel;
    procedure MnmObservacoesKeyPress(Sender: TObject; var Key: Char);
    procedure MnmObservacoesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
  private
    { Private declarations }
    bJaLeuOsDadosDoCartao: Boolean;

bAlterouNome


    procedure LerDadosDoCartao;
    procedure GravarDadosNoCartao;
    function VerificarDados: boolean;

  public
    { Public declarations }
  end;

var
  FrmCadastroGeral: TFrmCadastroGeral;

implementation

uses UntDtmGeral;

{$R *.dfm}

{ TFrmCadastroGeral }

procedure TFrmCadastroGeral.BitBtn1Click(Sender: TObject);
begin
  inherited;
  LerDadosDoCartao;
end;

procedure TFrmCadastroGeral.BtnFecharClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmCadastroGeral.BtnSalvarClick(Sender: TObject);
begin
  inherited;
  if not bJaLeuOsDadosDoCartao then
  begin
    MessageDlg('� necess�rio ler os dados do cart�o antes de salvar.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  inherited;
  GravarDadosNoCartao
end;

procedure TFrmCadastroGeral.FormCreate(Sender: TObject);
begin
  inherited;
  bJaLeuOsDadosDoCartao:= False;
end;

procedure TFrmCadastroGeral.GravarDadosNoCartao;
begin

  if not(VerificarDados) then
    Exit;

  if not DtmGeral.PCSCConnector1.Connect then
    raise EErroGeralISC.Create('Cart�o n�o est� conectado');

  TFuncoes.ValidarRetorno9000(TFuncoes.Bin2HexExt(DtmGeral.PCSCConnector1.GetResponseFromCard
    (TFuncoes.Hex2Bin(APDU.APDU_SELECT)), True, True, False));


  APDU.ResultarAPDUVerificarPIN(TFuncoes.StrToBin(EdtPIN.Text));
  TFuncoes.ValidarRetorno9000(TFuncoes.Bin2HexExt(DtmGeral.PCSCConnector1.GetResponseFromCard
    (TFuncoes.Hex2Bin(APDU.APDU_VERIFICAR_PIN)), True, True, False));

  if (Trim(edtNome.Text) <> '') then
  begin
    APDU.ResultarAPDUGravarNome(TFuncoes.StrToBin(TFuncoes.AdicionarCaracteresADireita(Trim(EdtNome.Text), 50, ' ')));
    TFuncoes.ValidarRetorno9000(TFuncoes.Bin2HexExt(DtmGeral.PCSCConnector1.GetResponseFromCard
      (TFuncoes.Hex2Bin(APDU.APDU_GRAVAR_NOME)), True, True, False));
  end;
  {
  APDU.ResultarAPDUGravarTelefone(TFuncoes.StrToBin(TFuncoes.AdicionarCaracteresADireita(EdtTelefone.Text, 11, ' ')));
  TFuncoes.ValidarRetorno9000(TFuncoes.Bin2HexExt(DtmGeral.PCSCConnector1.GetResponseFromCard
    (TFuncoes.Hex2Bin(APDU.APDU_GRAVAR_TELEFONE)), True, True, False));

  }
  if ( Trim(MnmObservacoes.Text)  <> '') then
  begin

    APDU.ResultarAPDUGravarObservacao(TFuncoes.StrToBin(TFuncoes.AdicionarCaracteresADireita(Trim(MnmObservacoes.Text), 127,' ')));

    TFuncoes.ValidarRetorno9000(TFuncoes.Bin2HexExt(DtmGeral.PCSCConnector1.GetResponseFromCard
      (TFuncoes.Hex2Bin(APDU.APDU_GRAVAR_OBSERVACAO)), True, True, False));

  end;
end;

procedure TFrmCadastroGeral.LerDadosDoCartao;
begin

  if not VerificarDados() then
    Exit;

  if not DtmGeral.PCSCConnector1.Connect then
    raise EErroGeralISC.Create('Cart�o n�o est� conectado');

  TFuncoes.ValidarRetorno9000(TFuncoes.Bin2HexExt(DtmGeral.PCSCConnector1.GetResponseFromCard
    (TFuncoes.Hex2Bin(APDU.APDU_SELECT)), True, True, False));

  APDU.ResultarAPDUVerificarPIN(TFuncoes.StrToBin(EdtPIN.Text));
  TFuncoes.ValidarRetorno9000(TFuncoes.Bin2HexExt(DtmGeral.PCSCConnector1.GetResponseFromCard
    (TFuncoes.Hex2Bin(APDU.APDU_VERIFICAR_PIN)), True, True, False));

   EdtNome.Text := Trim(
   TFuncoes.HexToString(
   TFuncoes.ValidarRetorno9000(TFuncoes.Bin2HexExt(DtmGeral.PCSCConnector1.GetResponseFromCard
     (TFuncoes.Hex2Bin(APDU.APDU_LE_NOME)), True, True, False))));

  EdtNome.Text := Trim( EdtNome.Text);
  {
  EdtTelefone.Text :=
   TFuncoes.HexToString(
   TFuncoes.ValidarRetorno9000(TFuncoes.Bin2HexExt(DtmGeral.PCSCConnector1.GetResponseFromCard
     (TFuncoes.Hex2Bin(APDU.APDU_LE_TELEFONE)), True, True, False)));
  }


  MnmObservacoes.Text:= Trim(
  TFuncoes.HexToString(
  TFuncoes.ValidarRetorno9000(TFuncoes.Bin2HexExt(DtmGeral.PCSCConnector1.GetResponseFromCard
    (TFuncoes.Hex2Bin(APDU.APDU_LE_OBSERCACAO)), True, True, False))));

   MnmObservacoes.Text:= Trim( MnmObservacoes.Text);

  bJaLeuOsDadosDoCartao:= True;  

end;

procedure TFrmCadastroGeral.MnmObservacoesChange(Sender: TObject);
begin
  inherited;
  Label4.Caption:= 'Total de caracteres [' + IntToStr(Length(MnmObservacoes.Text)) + ']';
end;

procedure TFrmCadastroGeral.MnmObservacoesKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Length(MnmObservacoes.Text) >= 127 then
  begin
    MessageDlg('N�o � permitido ultrapassar 127 caracteres', mtInformation, [mbOK], 0);
    Key := #0;
  end;
  
end;

function TFrmCadastroGeral.VerificarDados: boolean;
begin
  Result:= True;
  if Trim(EdtPIN.Text) = '' then
  begin
    MessageDlg('Informe o n�mero do PIN', mtInformation, [mbOK], 0);
    Result:= False;
    EdtPIN.SetFocus;
    Exit;
  end;

  if Length(Trim(EdtPIN.Text)) <> 3 then
  begin
    MessageDlg('O n�mero do PIN deve ser 3 (tr�s) caracteres', mtInformation, [mbOK], 0);
    Result:= False;
    EdtPIN.SetFocus;
    Exit;
  end;

end;

end.
