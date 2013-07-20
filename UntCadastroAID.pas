unit UntCadastroAID;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frmModelo, StdCtrls, Buttons, ExtCtrls, ComCtrls, EditAlignR,

  ISCFuncoes, ISCConstantes, ISCGlobal;

type
  TFrmCadastroAID = class(TFrmModelos)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel7: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EdtAIDPacote01: TEditAlignR;
    EdtAIDPacote02: TEditAlignR;
    EdtAIDPacote03: TEditAlignR;
    EdtAIDPacote04: TEditAlignR;
    EdtAIDPacote05: TEditAlignR;
    EdtAIDPacote06: TEditAlignR;
    EdtAIDPacote07: TEditAlignR;
    EdtAIDPacote08: TEditAlignR;
    EdtAIDPacote09: TEditAlignR;
    EdtAIDPacote10: TEditAlignR;
    EdtAIDPacote11: TEditAlignR;
    EdtAIDPacote12: TEditAlignR;
    EdtAIDApplet12: TEditAlignR;
    EdtAIDApplet11: TEditAlignR;
    EdtAIDApplet10: TEditAlignR;
    EdtAIDApplet09: TEditAlignR;
    EdtAIDApplet08: TEditAlignR;
    EdtAIDApplet07: TEditAlignR;
    EdtAIDApplet06: TEditAlignR;
    EdtAIDApplet05: TEditAlignR;
    EdtAIDApplet04: TEditAlignR;
    EdtAIDApplet03: TEditAlignR;
    EdtAIDApplet02: TEditAlignR;
    EdtAIDApplet01: TEditAlignR;
    BtnSalvar: TBitBtn;
    procedure BtnSalvarClick(Sender: TObject);
  private
    { Private declarations }

    procedure GravarEmArquivoDeConfiguracao;
    procedure LerCongifuracaoDoArquivo;
  public
    { Public declarations }
  end;

var
  FrmCadastroAID: TFrmCadastroAID;

implementation

{$R *.dfm}



procedure TFrmCadastroAID.BtnSalvarClick(Sender: TObject);
begin
  inherited;
  try
    GravarEmArquivoDeConfiguracao;

    APDU.Inicializar;

  except
    on E:Exception do
    begin
      MessageDlg('Falha ao salvar os dados'+#13+#10+''+#13+#10+
        'Erro: ' + E.Message +#13+#10+
        'Classe: ' + E.ClassName, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TFrmCadastroAID.GravarEmArquivoDeConfiguracao;
var
  sAIDPacote, sAIDApplet: string;
begin

  sAIDPacote:= Trim(EdtAIDPacote01.Text + EdtAIDPacote02.Text + EdtAIDPacote03.Text +
    EdtAIDPacote04.Text + EdtAIDPacote05.Text + EdtAIDPacote06.Text + EdtAIDPacote07.Text +
    EdtAIDPacote08.Text + EdtAIDPacote09.Text + EdtAIDPacote10.Text + EdtAIDPacote11.Text +
    EdtAIDPacote12.Text);
    
  sAIDApplet:= Trim(EdtAIDApplet01.Text + EdtAIDApplet02.Text + EdtAIDApplet03.Text +
    EdtAIDApplet04.Text + EdtAIDApplet05.Text + EdtAIDApplet06.Text + EdtAIDApplet07.Text +
    EdtAIDApplet08.Text + EdtAIDApplet09.Text + EdtAIDApplet10.Text + EdtAIDApplet11.Text +
    EdtAIDApplet12.Text);

  TFuncoes.GravarEmArquivoIni(ARQUIVO_CONFIGURACAO, SECAO_AID, CHAVE_AID_PACOTE,
    sAIDPacote);
  TFuncoes.GravarEmArquivoIni(ARQUIVO_CONFIGURACAO, SECAO_AID, CHAVE_AID_APPLET,
    sAIDApplet);
end;

procedure TFrmCadastroAID.LerCongifuracaoDoArquivo;
begin
  
end;

end.
