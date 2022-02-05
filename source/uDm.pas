unit uDm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, IniFiles, Forms;

type
  TDm = class(TDataModule)
    FDConn: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dm: TDm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDm.DataModuleCreate(Sender: TObject);
var
  iConf: TIniFile;
  PathName, wIP, wBD, wPO, wUser, wPass, PathDB : AnsiString;
  nTentativas: word;
begin
  PathName := '';
  PathName := ExtractFilePath(Application.ExeName);
  FDPhysMySQLDriverLink1.VendorLib := PathName +'libmysql.dll';

  PathDB := '';
  PathDB := copy(ExtractFileDir(Application.ExeName),1, LastDelimiter('\', ExtractFileDir(Application.ExeName)));

  if not FileExists(PathName + 'conexao.ini') then
  begin
    iConf := TIniFile.Create(PathName+'conexao.ini');
    try
      iConf.WriteString('CONFIG','Driver','MySQL');
      iConf.WriteString('CONFIG','Host','localhost');
      iConf.WriteString('CONFIG','Base','vendaswk');
      iConf.WriteString('CONFIG','User','root');
      iConf.WriteString('CONFIG','Port','3306');
    finally
      wIP   := iConf.ReadString('CONFIG','Host',wIP);
      wBD   := iConf.ReadString('CONFIG','Base',wBD);
      wPO   := iConf.ReadString('CONFIG','Port',wPO);
      wUser := iConf.ReadString('CONFIG','User',wUser);
      iConf.Free;
    end;
  end
  else
  begin
    iConf := TIniFile.Create(PathName+'conexao.ini');
    try
      wIP   := iConf.ReadString('CONFIG','Host',wIP);
      wBD   := iConf.ReadString('CONFIG','Base',wBD);
      wPO   := iConf.ReadString('CONFIG','Port',wPO);
      wUser := iConf.ReadString('CONFIG','User',wUser);
    finally
      iConf.Free;
    end;
  end;

  try
    FDConn.Params.Clear;

    FDConn.Params.Add('DriverID=MySQL');
    FDConn.Params.Add('Database='+wBD);
    FDConn.Params.Add('User_Name='+wUser);
    FDConn.Params.Add('Password=root');
    FDConn.Params.Add('Server='+wIP);
    FDConn.Params.Add('Port='+wPO);

    FDConn.Connected := True;

  Except
    on E: Exception do
    begin
      Application.MessageBox('Não foi possivel conectar com o Banco de Dados!' + #13 +
                             'Verifique as configurações do arquivo de conexão e em seguida tente novamente.','Banco de Dados');
    end;

  end;

end;

end.
