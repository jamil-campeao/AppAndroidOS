unit UnOSCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, UnPrincipal,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListBox, FMX.TabControl, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, uFancyDialog;

type
  TExecuteOnClose = procedure of object;
  TfrmOSCad = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSalvar: TSpeedButton;
    Image1: TImage;
    lytAbas: TLayout;
    rectAbaOS: TRectangle;
    rectAbaItem: TRectangle;
    lblAbaDadosOS: TLabel;
    lblAbaItensOS: TLabel;
    TabControl1: TTabControl;
    tabOS: TTabItem;
    tabItem: TTabItem;
    ListBox1: TListBox;
    lbiCliente: TListBoxItem;
    Label3: TLabel;
    lblCliente: TLabel;
    Image4: TImage;
    Line1: TLine;
    lbiTipoOS: TListBoxItem;
    Label4: TLabel;
    lblTipoOS: TLabel;
    Line2: TLine;
    lbiData: TListBoxItem;
    Label5: TLabel;
    lblData: TLabel;
    Image5: TImage;
    Line3: TLine;
    lbiSolicitacao: TListBoxItem;
    Label6: TLabel;
    lblSolicitacao: TLabel;
    Image6: TImage;
    Line4: TLine;
    lbiOBS: TListBoxItem;
    Label8: TLabel;
    lblOBS: TLabel;
    Image7: TImage;
    Line5: TLine;
    lbiResponsavelVendedor: TListBoxItem;
    Label10: TLabel;
    lblResponsavelVendedor: TLabel;
    Image8: TImage;
    Line6: TLine;
    Layout1: TLayout;
    btExcluir: TSpeedButton;
    Image15: TImage;
    lbiEndereco: TListBoxItem;
    Label7: TLabel;
    lblEndereco: TLabel;
    Line7: TLine;
    lvItemProduto: TListView;
    imgIconeMais: TImage;
    imgIconeSemFoto: TImage;
    imgIconeMenos: TImage;
    imgIconeExcluir: TImage;
    rectTotal: TRectangle;
    btInserirItem: TSpeedButton;
    Label9: TLabel;
    Label11: TLabel;
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rectAbaOSClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btInserirItemClick(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    vFancy : TFancyDialog;
    FCod_OS: Integer;
    FModo: String;
    FExecuteOnClose: TExecuteOnClose;
    procedure fAbrirAba(pRect: TRectangle);
    procedure fSelecionarCliente(pCodClienteLocal: Integer; pNome: String);
    { Private declarations }
  public
  property Modo: String read FModo write FModo;
  property Cod_OS: Integer read FCod_OS write FCod_OS;
  property ExecuteOnClose: TExecuteOnClose read FExecuteOnClose write FExecuteOnClose;
    { Public declarations }
  end;

var
  frmOSCad: TfrmOSCad;

implementation

{$R *.fmx}

uses UnOSItemCad, UnClienteBusca, DataModule.OS;

procedure TfrmOSCad.btInserirItemClick(Sender: TObject);
begin
  if not Assigned(frmOSItemCad) then
    Application.CreateForm(TfrmOSItemCad, frmOSItemCad);

  frmOSItemCad.Show;

end;

procedure TfrmOSCad.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOSCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action   := TCloseAction.caFree;
  FrmOSCad := nil;
end;

procedure TfrmOSCad.FormCreate(Sender: TObject);
begin
  TabControl1.ActiveTab := tabOS;
  vFancy                := TFancyDialog.Create(frmOSCad);
end;

procedure TfrmOSCad.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
end;

procedure TfrmOSCad.FormShow(Sender: TObject);
begin
  try
    btExcluir.Visible := Modo = 'A';

    if Modo = 'A' then
    begin
      DMOS.fListarOSId(Cod_OS);

      lblCliente.Tag              := DMOS.QryOS.FieldByName('CLI_CODIGO_LOCAL').AsInteger;
      lblCliente.Text             := DMOS.QryOS.FieldByName('CLI_NOME').AsString;
      lblEndereco.Text            := DMOS.QryOS.FieldByName('CLI_ENDERECO_COMPLETO').AsString;
      lblTipoOS.Text              := DMOS.QryOS.FieldByName('OS_TIPO').AsString;
      lblData.Text                := DMOS.QryOS.FieldByName('OS_DATAABERTURA').AsString;
      lblSolicitacao.Text         := DMOS.QryOS.FieldByName('OS_SOLICITACAO').AsString;
      lblOBS.Text                 := DMOS.QryOS.FieldByName('OS_OBSINTERNA').AsString;
      lblResponsavelVendedor.Text := DMOS.QryOS.FieldByName('FUNC_NOME').AsString;

      lblTitulo.Text := 'Editar OS';
    end;
  except on E:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao carregar dados da OS: ' + e.Message, 'OK');

  end;
end;

procedure TfrmOSCad.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if Item.Name = 'lbiCliente' then
  begin
    if not assigned(frmClienteBusca) then
      Application.CreateForm(TfrmClienteBusca, frmClienteBusca);

    FrmClienteBusca.ExecuteOnClick := fSelecionarCliente;
    frmClienteBusca.Show;
  end;
end;

procedure TfrmOSCad.fSelecionarCliente(pCodClienteLocal: Integer; pNome: String);
begin
  lblCliente.Text := pNome;
  lblCliente.Tag  := pCodClienteLocal;
end;

procedure TfrmOSCad.rectAbaOSClick(Sender: TObject);
begin
  fAbrirAba(TRectangle(Sender));
end;

procedure TfrmOSCad.fAbrirAba(pRect: TRectangle);
begin
  rectAbaOS.Fill.Color    := $FFFFFFFF;
  rectAbaItem.Fill.Color  := $FFFFFFFF;
  lblAbaDadosOS.FontColor := $FF585F5A;
  lblAbaItensOS.FontColor := $FF585F5A;

  if pRect.Tag = 0 then
  begin
    rectAbaOS.Fill.Color    := $FF585F5A;
    lblAbaDadosOS.FontColor := $FFFFFFFF;
  end
  else
  begin
    rectAbaItem.Fill.Color    := $FF585F5A;
    lblAbaItensOS.FontColor   := $FFFFFFFF;
  end;

  TabControl1.GotoVisibleTab(pRect.Tag);

end;


end.
