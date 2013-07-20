unit UntDtmGeral;

interface

uses
  SysUtils, Classes, PCSCConnector;

type
  TDtmGeral = class(TDataModule)
    PCSCConnector1: TPCSCConnector;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DtmGeral: TDtmGeral;

implementation

{$R *.dfm}

end.
