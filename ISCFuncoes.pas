unit ISCFuncoes;

interface

uses
  IniFiles, SysUtils, Dialogs,

  ISCConstantes;

type
  EErroGeralISC = class(Exception);
  ERespostaSW = class(Exception);

  TFuncoes = class
  public
    class function GravarEmArquivoIni(const AArquivo, ASecao, AChave, AValor: Variant): Boolean;
    class function LerEmArquivoIni(const AArquivo, ASecao, AChave: string): Variant;


    class function RetornarTamanhoEmHexadecimalAPDU(const ADados: string): string;
    class function HexToString(H: String): String;
    class function Bin2HexExt(const input:string; const spaces, upcase, remove_retornos: boolean): string;
    class function Hex2Bin(input: string): string;

    class function ValidarRetorno9000(const ARespostaAPDU: string): string;
    class function ToHexadecimalInt(ADados: string): string;
    class function StrToBin(const ADados: string): string;

    class function AdicionarCaracteresADireita(const ADados: string; const AQuantidade: Integer;
      const ACaracter: Char): string ;

    class function AdicionarCaracteresAEsquerda(const ADados: string; const AQuantidade: Integer;
      const ACaracter: Char): string ;



  end;

implementation

{ TFuncoes }


class function TFuncoes.AdicionarCaracteresADireita(const ADados: string;
  const AQuantidade: Integer; const ACaracter: Char): string;
begin
  Result:= ADados + StringOfChar(ACaracter,  AQuantidade - Length(ADados));

// Result:= StringOfChar()

end;

class function TFuncoes.AdicionarCaracteresAEsquerda(const ADados: string;
  const AQuantidade: Integer; const ACaracter: Char): string;
begin
  Result:= StringOfChar(ACaracter,  AQuantidade - Length(ADados)) + ADados;
end;

class function TFuncoes.Bin2HexExt(const input: string; const spaces, upcase,
  remove_retornos: boolean): string;
var
   loop, loop1      : integer;
   hexresult : string;
begin
     loop1:= 0;
     if remove_retornos then
       loop1 := 2;

     hexresult := '';
     for loop := 1 to Length(input) - loop1 do
        begin
        hexresult := hexresult + IntToHex(Ord(input[loop]),2);
        if spaces then hexresult := hexresult + ' ';
        end;
     if upcase then result := AnsiUpperCase(hexresult)
               else result := AnsiLowerCase(hexresult);

end;

class function TFuncoes.GravarEmArquivoIni(const AArquivo, ASecao, AChave,
  AValor: Variant): Boolean;
var
  oIniFile: TIniFile;
begin
  oIniFile:= TIniFile.Create(AArquivo);
  try
     oIniFile.WriteString(ASecao, AChave, AValor);

  finally
    FreeAndNil(oIniFile)
  end;
end;



class function TFuncoes.Hex2Bin(input: string): string;
var
hex, output: string;
loop       : integer;
begin
     for loop := 1 to Length(input) do if Pos(input[loop], HEX_CHARS) > 0 then hex := hex + AnsiUpperCase(input[loop]);
     loop := 1;
     if Length(hex) > 0 then
        repeat
        output := output + Chr(StrToInt('$'+Copy(hex,loop,2)));
        loop := loop + 2;
        until loop > Length(hex);
     Result := output;

end;

class function TFuncoes.HexToString(H: String): String;
var
  I : Integer;
  sSoNumeros: string;
begin

  h := StringReplace(h,' ','',[rfReplaceAll]);
  Result:= '';
  for I := 1 to length (H) div 2 do
    Result:= Result+Char(StrToInt('$'+Copy(H,(I-1)*2+1,2)));

  // Necessario para remover quando for somente números
  //sSoNumeros := StringReplace(Result,'#','',[rfReplaceAll]);

  //result := sSoNumeros;

  //ShowMessage(sSoNumeros)

end;

class function TFuncoes.ToHexadecimalInt(ADados: String): string;
var
  n: Integer;
  sDados: string;
begin


  result:= IntToHex(StrToInt (ADados),2);

end;

class function TFuncoes.LerEmArquivoIni(const AArquivo, ASecao,
  AChave: string): Variant;
var
  oIniFile: TIniFile;
begin
  oIniFile:= TIniFile.Create(AArquivo);
  try
    Result:= oIniFile.ReadString(ASecao, AChave, ''); 
  finally
    FreeAndNil(oIniFile)
  end;   
end;



class function TFuncoes.RetornarTamanhoEmHexadecimalAPDU(
  const ADados: string): string;
var
  iTamanho: Real;
begin
  if (Length(ADados) Mod 2) <> 0 then     
    raise EErroGeralISC.Create('Tamanho do campo Applet AID não válido - Valor(' +
      ADados+ ')');

  iTamanho:= Length(ADados) / 2;

  Result:= ToHexadecimalInt(FloatToStr(iTamanho));



  if Length(Result) <> 2 then
    raise EErroGeralISC.Create('Retorno do campo tamanho do APDU não é válido - Valor(' +
      Result + ')');


end;

class function TFuncoes.StrToBin(const ADados: string): string;
var
  n: integer;
begin

  Result := '';
  for n := 1 to Length(ADados) do
    Result := LowerCase(Result + IntToHex(Ord(ADados[n]), 2));
 
  //Result:= Bin2HexExt(result, false, true, false);

end;

class function TFuncoes.ValidarRetorno9000(
  const ARespostaAPDU: string): string;
var
  sRetornoAPDU, sSW: string;

begin
  sRetornoAPDU:= StringReplace(ARespostaAPDU,' ','',[rfReplaceAll]);

  sSW:= Copy(sRetornoAPDU, Length(sRetornoAPDU) - 3, 4);

  if sSW <> '9000' then
    raise ERespostaSW.Create('Retorno do comando APDU ' +  sSW);

  Result:= ARespostaAPDU;
  
end;

end.
