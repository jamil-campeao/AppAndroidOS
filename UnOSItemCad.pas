unit UnOSItemCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, uFancyDialog, uFunctions;

type
  TExecuteOnClose = procedure of object;
  TfrmOSItemCad = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSalvar: TSpeedButton;
    Image1: TImage;
    rectProduto: TRectangle;
    Label2: TLabel;
    Image4: TImage;
    lblDescricao: TLabel;
    rectUnitario: TRectangle;
    Label4: TLabel;
    Image5: TImage;
    lblValorUnitario: TLabel;
    rectQuantidade: TRectangle;
    Label3: TLabel;
    Image7: TImage;
    lblQuantidade: TLabel;
    rectTotal: TRectangle;
    Label1: TLabel;
    Image3: TImage;
    lblValorTotal: TLabel;
    btMenos: TSpeedButton;
    imgIconeMenos: TImage;
    btMais: TSpeedButton;
    imgIconeMais: TImage;
    procedure rectQuantidadeClick(Sender: TObject);
    procedure rectUnitarioClick(Sender: TObject);
    procedure rectTotalClick(Sender: TObject);
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure rectProdutoClick(Sender: TObject);
    procedure btMaisClick(Sender: TObject);
  private
    vFancy : TFancyDialog;
    FCod_Item: Integer;
    FModo: String;
    FExecuteOnClose: TExecuteOnClose;
    procedure fSelecionaProduto(pCodProdutoLocal: Integer; pDescricao: String; pValor: Double);
    procedure fCalcularQtd(pQtd: Integer);
    procedure fCalcularTotalItem;
    procedure fCalcularUnitarioItem;
    procedure fClickTotalItem(Sender: TObject);
    procedure fClickUnitarioItem(Sender: TObject);
    { Private declarations }
  public
  property Modo: String read FModo write FModo;
  property Cod_Item: Integer read FCod_Item write FCod_Item;
  property ExecuteOnClose: TExecuteOnClose read FExecuteOnClose write FExecuteOnClose;

    { Public declarations }
  end;

var
  frmOSItemCad: TfrmOSItemCad;

implementation

{$R *.fmx}

uses UnEdicaoPadrao, DataModule.OS, UnProdutoBusca;

procedure TfrmOSItemCad.btMaisClick(Sender: TObject);
begin
  fCalcularQtd(TSpeedButton(Sender).Tag);
end;

procedure TfrmOSItemCad.btSalvarClick(Sender: TObject);
begin
  if lblDescricao.Text = '' then
  begin
    vFancy.fShow(TIconDialog.Warning, 'Aviso', 'Informe um produto', 'OK');
    Exit;
  end;

  if lblQuantidade.Text = '0,00' then
  begin
    vFancy.fShow(TIconDialog.Warning, 'Aviso', 'Informe uma quantidade válida', 'OK');
    Exit;
  end;

  if lblValorUnitario.Text = '0,00' then
  begin
    vFancy.fShow(TIconDialog.Warning, 'Aviso', 'Informe o valor unitário', 'OK');
    Exit;
  end;

  try
    if Modo = 'I' then
      DMOS.fInserirItemProduto(lblDescricao.Tag,
                               fStringToFloat(lblQuantidade.Text),
                               fStringToFloat(lblValorUnitario.Text),
                               fStringToFloat(lblValorTotal.Text)
                               )
    else
      DMOS.fEditarItemProduto(Cod_Item,
                              lblDescricao.Tag,
                              fStringToFloat(lblQuantidade.Text),
                              fStringToFloat(lblValorUnitario.Text),
                              fStringToFloat(lblValorTotal.Text)
                              );

    if Assigned(ExecuteOnClose) then
      ExecuteOnClose;

    Close;
  except on E:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao salvar dados do item: ' + e.Message, 'OK');

  end;
end;

procedure TfrmOSItemCad.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOSItemCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmOSItemCad := nil;
end;

procedure TfrmOSItemCad.FormCreate(Sender: TObject);
begin
  vFancy := TFancyDialog.Create(frmOSItemCad);
end;

procedure TfrmOSItemCad.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
end;

procedure TfrmOSItemCad.FormShow(Sender: TObject);
begin
  try
    if Modo = 'A' then
    begin
      DMOS.fListarItensOSID(Cod_Item);

      lblDescricao.Text     := DMOS.QryItem.FieldByName('PROD_DESCRICAO').AsString;
      lblDescricao.Text     := DMOS.QryItem.FieldByName('PROD_DESCRICAO').AsString;

      lblQuantidade.Text    := FormatFloat('#,##0.00', DMOS.QryItem.FieldByName('OSP_QUANTIDADE').AsFloat);
      lblValorUnitario.Text := FormatFloat('#,##0.00', DMOS.QryItem.FieldByName('OSP_VALOR').AsFloat);
      lblValorTotal.Text    := FormatFloat('#,##0.00', DMOS.QryItem.FieldByName('OSP_TOTAL').AsFloat);
      lblTitulo.Text        := 'Editar Item';
    end;
  except on E:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao carregar dados do item: ' + e.Message, 'OK');

  end;
end;

procedure TfrmOSItemCad.rectProdutoClick(Sender: TObject);
begin
  if not Assigned(frmProdutoBusca) then
    Application.CreateForm(TfrmProdutoBusca, frmProdutoBusca);

  frmProdutoBusca.ExecuteOnClick := fSelecionaProduto;
  frmProdutoBusca.Show;

end;

procedure TfrmOSItemCad.fSelecionaProduto(pCodProdutoLocal: Integer; pDescricao: String; pValor: Double);
begin
  lblDescricao.Text     := pDescricao;
  lblDescricao.Tag      := pCodProdutoLocal;
  lblValorUnitario.Text := FormatFloat('#,##0.00', pValor);
  fCalcularTotalItem;
end;

procedure TfrmOSItemCad.rectQuantidadeClick(Sender: TObject);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TFrmEdicaoPadrao, frmEdicaoPadrao);

  FrmEdicaoPadrao.fEditar(lblQuantidade,
                          TTipoCampo.Valor,
                          'Quantidade do item',
                          'Informe a quantidade do item',
                          lblQuantidade.Text,
                          True,
                          0
                          );
end;

procedure TfrmOSItemCad.rectTotalClick(Sender: TObject);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TFrmEdicaoPadrao, frmEdicaoPadrao);

  FrmEdicaoPadrao.fEditar(lblValorTotal,
                          TTipoCampo.Valor,
                          'Valor Total do Item',
                          'Informe o valor total do item',
                          lblValorTotal.Text,
                          True,
                          0,
                          fClickTotalItem
                          );
end;

procedure TfrmOSItemCad.rectUnitarioClick(Sender: TObject);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TFrmEdicaoPadrao, frmEdicaoPadrao);

  FrmEdicaoPadrao.fEditar(lblValorUnitario,
                          TTipoCampo.Valor,
                          'Quantidade do item',
                          'Informe o valor unitário do item',
                          lblValorUnitario.Text,
                          True,
                          0,
                          fClickUnitarioItem
                          );
end;

procedure TfrmOSItemCad.fCalcularQtd(pQtd: Integer);
var
  vAux : Integer;
begin
  try
    vAux := lblQuantidade.Text.ToInteger + pQtd;

    if vAux < 1 then
      vAux := 1;

  except
    vAux := 1;

  end;

  lblQuantidade.Text := vAux.ToString;

  fCalcularTotalItem;
end;

procedure TfrmOSItemCad.fCalcularTotalItem;
var
  vQtd, vUnitario : Double;
begin
  try
    vQtd      := lblQuantidade.Text.ToDouble;
    vUnitario := fStringToFloat(lblValorUnitario.Text);
  except
    vQtd      := 0;
    vUnitario := 0;
  end;

  lblValorTotal.Text := FormatFloat('#,#0.00', vQtd * vUnitario);

end;

procedure TfrmOSItemCad.fCalcularUnitarioItem;
var
  vQtd, vTotal : Double;
begin
  try
    vQtd      := lblQuantidade.Text.ToDouble;
    vTotal := fStringToFloat(lblValorTotal.Text);
  except
    vQtd   := 0;
    vTotal := 0;
  end;

  if vQtd > 0 then
    lblValorUnitario.Text := FormatFloat('#,#0.00', vTotal / vQtd)
  else
    lblValorUnitario.Text := FormatFloat('#,#0.00', 0);

end;

procedure TfrmOSItemCad.fClickTotalItem(Sender: TObject);
begin
  fCalcularUnitarioItem;
end;

procedure TfrmOSItemCad.fClickUnitarioItem(Sender: TObject);
begin
  fCalcularTotalItem;
end;


end.
