unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Imaging.pngimage;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtnroPedido: TEdit;
    edtcodCliente: TEdit;
    edtnomeCliente: TEdit;
    edtCidade: TEdit;
    edtUF: TEdit;
    Label5: TLabel;
    Panel7: TPanel;
    GroupBox1: TGroupBox;
    edtcodProduto: TEdit;
    edtDescricao: TEdit;
    edtQde: TEdit;
    edtVlrUnitario: TEdit;
    btnAcao: TButton;
    Label6: TLabel;
    edtVlrTotal: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    dsItens: TDataSource;
    Label11: TLabel;
    edtTotalPedido: TEdit;
    Label12: TLabel;
    edtdtEmissao: TEdit;
    Button2: TButton;
    btnBuscarPedido: TButton;
    btnCancelarPedido: TButton;
    Image1: TImage;
    qryItens: TFDQuery;
    qryClientes: TFDQuery;
    qryProdutos: TFDQuery;
    qryPedidos: TFDQuery;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    FDSchemaAdapter1: TFDSchemaAdapter;
    qryTotal: TFDQuery;
    qryAux: TFDQuery;
    btnGravarPedido: TButton;
    qryProdutoscodproduto: TFDAutoIncField;
    qryProdutosdescricao: TStringField;
    qryProdutosprvenda: TBCDField;
    qryItensid_pedido: TFDAutoIncField;
    qryItensnropedido: TIntegerField;
    qryItenscodproduto: TIntegerField;
    qryItensqde: TBCDField;
    qryItensvlrunitario: TBCDField;
    qryItensvlrtotal: TBCDField;
    qryItensdescricao: TStringField;
    Button1: TButton;
    procedure edtcodClienteExit(Sender: TObject);
    procedure edtcodProdutoExit(Sender: TObject);
    procedure edtcodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edtcodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure edtQdeExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtQdeKeyPress(Sender: TObject; var Key: Char);
    procedure edtVlrUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure btnAcaoClick(Sender: TObject);
    procedure edtVlrUnitarioExit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure dsItensDataChange(Sender: TObject; Field: TField);
    procedure btnBuscarPedidoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
  private
    { Private declarations }

    wDadosOK: Boolean;

    procedure LimparTela;
    procedure LimparItem;

    procedure validarCampos;

    procedure AtualizaItens;
    procedure TotalizarPedido;

  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses uDm;

procedure TfrmPrincipal.AtualizaItens;
begin
  with qryItens do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select a.*, b.descricao from pedidos_itens a, produtos b ' +
            'where a.codproduto = b.codproduto and a.nropedido = :nropedido');
    ParamByName('nropedido').Value := StrToInt(edtnroPedido.Text);
    Open;
  end;
end;

procedure TfrmPrincipal.btnAcaoClick(Sender: TObject);
begin
  validarCampos;

  if wDadosOK = False then
  Exit;

  if not Dm.FDConn.InTransaction then
  Dm.FDConn.StartTransaction;

  if btnAcao.Caption = 'Incluir' then
  begin

    with qryAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select nropedido from pedidos where nropedido = :nropedido');
      ParamByName('nropedido').Value := strtoint(edtnroPedido.Text);
      Open;
    end;

    if qryAux.Eof then
    begin  //Insert
      with qryPedidos do
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into pedidos ' +
                '(nropedido, dtemissao, codcliente, vlrtotal ' +
                ') values ('+
                ':nropedido, :dtemissao, :codcliente, :vlrtotal)');
        ParamByName('nropedido').Value  := strtoint(edtnroPedido.Text);
        ParamByName('dtemissao').Value  := FormatDateTime('yyyy-mm-dd',now);
        ParamByName('codcliente').Value := strtoint(edtcodCliente.Text);
        ParamByName('vlrtotal').Value   := 0;
        ExecSQL;
      end;

    end;


    with qryItens do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into pedidos_itens '+
              '(nropedido, codproduto, qde, vlrunitario, vlrtotal '+
              ') values ('+
              ':nropedido, :codproduto, :qde, :vlrunitario, :vlrtotal)');
      ParamByName('nropedido').Value   := strtoint(edtnroPedido.Text);
      ParamByName('codproduto').Value  := strtoint(edtcodProduto.Text);
      ParamByName('qde').Value         := strtofloat(StringReplace(edtQde.Text, '.', ',',[]));
      ParamByName('vlrunitario').Value := strtofloat(StringReplace(edtVlrUnitario.Text, '.', ',',[]));
      ParamByName('vlrtotal').Value    := strtofloat(StringReplace(edtVlrTotal.Text, '.', ',',[]));
      ExecSQL;
    end;

    LimparItem;
    AtualizaItens;
    TotalizarPedido;
  end;

  if btnAcao.Caption = 'Alterar' then
  begin

    with qryItens do
    begin
      Close;
      SQL.Clear;
      SQL.Add('update pedidos_itens set qde = :qde, vlrunitario = :vlrunitario, '+
              'vlrtotal = :vlrtotal where nropedido = :nropedido and codproduto = :codproduto');
      ParamByName('nropedido').value   := strtoint(edtnroPedido.Text);
      ParamByName('codproduto').value  := strtoint(edtcodProduto.Text);
      ParamByName('qde').Value         := strtofloat(StringReplace(edtQde.Text, '.', ',',[]));
      ParamByName('vlrunitario').Value := strtofloat(StringReplace(edtVlrUnitario.Text, '.', ',',[]));
      ParamByName('vlrtotal').Value    := strtofloat(StringReplace(edtVlrTotal.Text, '.', ',',[]));
      ExecSQL;
    end;

    AtualizaItens;
    TotalizarPedido;
    LimparItem;

    btnAcao.Caption := 'Incluir';
  end;

  edtcodProduto.SetFocus;
end;

procedure TfrmPrincipal.btnBuscarPedidoClick(Sender: TObject);
var
  uPedido: String;
begin
  Tag := 2;

  uPedido := InputBox('Pedido','Informe o número do pedido.',EmptyStr);
  if uPedido.Trim.IsEmpty then
  raise Exception.Create('O número do pedido precisa ser informado!');

  with qryPedidos do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from pedidos where nropedido = :nropedido');
    Params[0].Value := StrToInt(uPedido);
    Open;
  end;

  if not qryPedidos.eof then
  begin
    edtnroPedido.Text := qrypedidos.FieldByName('nropedido').AsString;
    edtcodCliente.Text := qryPedidos.FieldByName('codcliente').AsString;
    edtcodClienteExit(Sender);
    edtdtEmissao.Text := DateToStr(qryPedidos.FieldByName('dtemissao').Value);

    with qryitens do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select a.*, b.descricao from pedidos_itens a, produtos b ' +
              'where a.codproduto = b.codproduto and a.nropedido = :nropedido');
      ParamByName('nropedido').Value := StrToInt(edtnroPedido.Text);
      Open;
    end;

    if not qryItens.Eof then
    begin

    end;

    TotalizarPedido;
  end
  else
  Application.MessageBox('Pedido não localizado, verifique se o número digitado está correto.','Aviso',MB_ICONEXCLAMATION+MB_OK);
end;

procedure TfrmPrincipal.btnCancelarPedidoClick(Sender: TObject);
var
  uPedido: String;
begin
  uPedido := InputBox('Pedido','Informe o número do pedido.',EmptyStr);
  if uPedido.Trim.IsEmpty then
  raise Exception.Create('O número do pedido precisa ser informado!');

  with qryAux do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from pedidos where nropedido = :nropedido');
    Params[0].Value := StrToInt(uPedido);
    Open;
  end;

  if not qryAux.Eof then
  begin
    if not Dm.FDConn.InTransaction then
    Dm.FDConn.StartTransaction;

    with qryItens do
    begin
      Close;
      SQL.Clear;
      SQL.Add('delete from pedidos_itens where nropedido = :nropedido');
      ParamByName('nropedido').value := strtoint(upedido);
      ExecSQL;
    end;

    with qryPedidos do
    begin
      Close;
      SQL.Clear;
      SQL.Add('delete from pedidos where nropedido = :nropedido');
      ParamByName('nropedido').value := strtoint(upedido);
      ExecSQL;
    end;

    try
      Dm.FDConn.Commit;

    except
      on E: Exception do
      begin
        Application.MessageBox('Erro ao tentar cancelar o pedido, tente novamente.','Aviso',MB_ICONINFORMATION);
        Dm.FDConn.Rollback;
      end;
    end;

  end
  else
  Application.MessageBox('Pedido não localizado, verifique se o número digitado está correto.','Aviso',MB_ICONEXCLAMATION+MB_OK);

end;

procedure TfrmPrincipal.btnGravarPedidoClick(Sender: TObject);
begin
  try
    Dm.FDConn.Commit;

    Application.MessageBox('Pedido gravado com sucesso!','Ebaaa',MB_ICONINFORMATION+MB_OK);
    qryItens.Close;
    LimparTela;
    btnGravarPedido.Visible := False;
    edtcodCliente.SetFocus;
  except
    on E: Exception do
    begin
      Application.MessageBox('Erro ao tentar Gravar o Pedido, tente novamente.','Aviso',MB_ICONINFORMATION);
      Dm.FDConn.Rollback;
    end;
  end;
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  Tag := 1;
  qryItens.Close;
  LimparTela;
  edtcodCliente.SetFocus;
end;

procedure TfrmPrincipal.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TfrmPrincipal.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if MessageDlg('Confirma a exclusão do registro selecionado?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    begin
      qryItens.Delete;
      qryItens.ApplyUpdates(0);
      AtualizaItens;
      TotalizarPedido;
    end;
  end;

  if Key = VK_RETURN then
  begin

    edtcodProduto.Text := qryItenscodproduto.AsString;
    edtcodProdutoExit(Sender);
    edtQde.Text := qryItensqde.AsString;
    edtVlrUnitario.Text := qryItensvlrunitario.AsString;
    edtVlrTotal.Text    := qryItensvlrtotal.AsString;
    edtQde.SetFocus;

    btnAcao.Caption := 'Alterar';
  end;

end;

procedure TfrmPrincipal.dsItensDataChange(Sender: TObject; Field: TField);
begin
  if qryItens.RecordCount > 0 then
    btnGravarPedido.Visible := true
  else
  btnGravarPedido.Visible := False;
end;

procedure TfrmPrincipal.edtcodClienteExit(Sender: TObject);
begin
  if Length(trim(edtcodCliente.Text)) > 0  then
  begin
    with qryClientes do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select nome, cidade, uf from clientes where codcliente = :p');
      Params[0].Value := StrToInt(edtcodCliente.Text);
      Open;
    end;

    if not qryClientes.Eof then
    begin
      edtnomeCliente.Text := qryClientes.Fields[0].AsString;
      edtCidade.Text      := qryClientes.Fields[1].AsString;
      edtUF.Text          := qryClientes.Fields[2].AsString;

      edtdtEmissao.Text := DateToStr(Now);

      if Tag = 1 then
      edtnroPedido.Text := Dm.FDConn.ExecSQLScalar('select IFNULL(MAX(nropedido),0)+1 from pedidos');

      edtcodProduto.SetFocus;
    end
    else
    begin
      Application.MessageBox('Cliente não localizado, verifique o código informado e tente novamente.','Aviso',MB_ICONINFORMATION);
      edtcodCliente.SetFocus;
    end;
  end;
end;


procedure TfrmPrincipal.edtcodClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  edtcodClienteExit(Sender);
end;

procedure TfrmPrincipal.edtcodProdutoExit(Sender: TObject);
begin
  if Length(trim(edtcodProduto.Text)) > 0  then
  begin
    with qryProdutos do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select codproduto, descricao, prvenda from produtos where codproduto = :codproduto');
      ParamByName('codproduto').Value := StrToInt(edtcodProduto.Text);
      Open;
    end;

    if not qryProdutos.Eof then
    begin
      edtDescricao.Text   := qryProdutos.Fields[1].AsString;
      edtVlrUnitario.Text := FormatFloat('0.000', qryProdutos.Fields[2].Value);

      edtQde.SetFocus;
    end
    else
    begin
      Application.MessageBox('Produto não localizado, verifique se o código informado está correto.','Aviso',MB_ICONINFORMATION);
      edtcodProduto.SetFocus;
    end;
  end;
end;

procedure TfrmPrincipal.edtcodProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  edtcodProdutoExit(Sender);
end;

procedure TfrmPrincipal.edtQdeExit(Sender: TObject);
begin
  edtVlrTotal.Text := FormatFloat('0.00', StrToFloatDef(edtQde.Text,0) * StrToFloatDef(edtVlrUnitario.Text,0));
  edtVlrUnitario.Text := FormatFloat('0.00',StrToFloatDef(edtVlrUnitario.Text,0));
end;

procedure TfrmPrincipal.edtQdeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  edtVlrUnitario.SetFocus;
end;

procedure TfrmPrincipal.edtVlrUnitarioExit(Sender: TObject);
begin
  edtVlrTotal.Text := FormatFloat('0.00', StrToFloatDef(edtQde.Text,0) * StrToFloatDef(edtVlrUnitario.Text,0));
  edtVlrUnitario.Text := FormatFloat('0.00',StrToFloatDef(edtVlrUnitario.Text,0));
end;

procedure TfrmPrincipal.edtVlrUnitarioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  btnAcao.SetFocus;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  Tag := 1;
  LimparTela;
  edtcodCliente.SetFocus;
end;

procedure TfrmPrincipal.LimparItem;
begin
  edtcodProduto.Clear;
  edtDescricao.Clear;
  edtQde.Text := '1,000';
  edtVlrUnitario.Clear;
  edtVlrTotal.Clear;
end;

procedure TfrmPrincipal.LimparTela;
begin
  edtcodCliente.Clear;
  edtnroPedido.Clear;
  edtnomeCliente.Clear;
  edtCidade.Clear;
  edtUF.Clear;
  edtdtEmissao.Clear;
  edtcodProduto.Clear;
  edtDescricao.Clear;
  edtQde.Text := '1,000';
  edtVlrUnitario.Clear;
  edtVlrTotal.Clear;
  edtTotalPedido.Text := '0,00';
end;

procedure TfrmPrincipal.TotalizarPedido;
begin
  with qryTotal do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(vlrtotal) as total from pedidos_itens where nropedido = :nropedido');
    ParamByName('nropedido').Value := StrToInt(edtnroPedido.Text);
    Open;
  end;

  edtTotalPedido.Text := FormatFloat(',##0.00',qryTotal.FieldByName('total').Value);


  with qryPedidos do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update pedidos set vlrtotal = :vlrtotal where nropedido = :nropedido');
    ParamByName('nropedido').value := strtoint(edtnroPedido.Text);
    ParamByName('vlrtotal').Value  := qryTotal.FieldByName('total').Value;
    ExecSQL;
  end;

end;

procedure TfrmPrincipal.validarCampos;
begin
  wDadosOK := True;
  if Length(trim(edtcodCliente.Text)) = 0  then
  begin
    Application.MessageBox('Código do Cliente não informado.','Aviso',MB_ICONERROR);
    edtcodCliente.SetFocus;
    wDadosOK := False;
    exit;
  end;

  if Length(trim(edtcodProduto.Text)) = 0  then
  begin
    Application.MessageBox('Código do Produto não informado.','Aviso',MB_ICONERROR);
    edtcodProduto.SetFocus;
    wDadosOK := False;
    exit;
  end;


  if StrToFloatDef(edtQde.Text,0) <= 0 then
  begin
    Application.MessageBox('A quantidade do item não pode ser menor ou igual a zero.','Aviso',MB_ICONERROR);
    edtQde.SetFocus;
    wDadosOK := False;
    exit;
  end;

  if StrToFloatDef(edtVlrUnitario.Text,0) <= 0 then
  begin
    Application.MessageBox('O Valor Unitário do item não pode ser menor ou igual a zero.','Aviso',MB_ICONERROR);
    edtVlrUnitario.SetFocus;
    wDadosOK := False;
    exit;
  end;

end;

end.
