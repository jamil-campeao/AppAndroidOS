unit UnClienteBusca;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  uFancyDialog, uFunctions;

type
  TExecuteOnClick = procedure(pCodClienteLocal: Integer; pNome: String) of Object;

  TfrmClienteBusca = class(TForm)
    rectToolBar: TRectangle;
    Label3: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    rectBusca: TRectangle;
    edBuscaCliente: TEdit;
    btBuscaCliente: TSpeedButton;
    lvCliente: TListView;
    imgSemCliente: TImage;
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvClienteUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvClientePaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure FormShow(Sender: TObject);
    procedure btBuscaClienteClick(Sender: TObject);
    procedure lvClienteItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    vFancy : TFancyDialog;
    FExecuteOnClick: TExecuteOnClick;
    procedure fAdicionaClienteListView(pCodClienteLocal: Integer; pNome, pEndereco, pNumero, pCompl, pBairro,
pCidade, pUF, pCPFCNPJ: String; pCodCidade: Integer);
    procedure fLayoutListViewCliente(pAItem: TListViewItem);
    procedure fListarClientes(pPagina: Integer; pBusca: String;
      pIndClear: Boolean);
    procedure fThreadClientesTerminate(Sender: TObject);
    { Private declarations }
  public
  property ExecuteOnClick: TExecuteOnClick read FExecuteOnClick write FExecuteOnClick;

    { Public declarations }
  end;

var
  frmClienteBusca: TfrmClienteBusca;

implementation

{$R *.fmx}

uses UnPrincipal, uConstantes, DataModule.Cliente;

procedure TfrmClienteBusca.btBuscaClienteClick(Sender: TObject);
begin
  fListarClientes(1, Trim(edBuscaCliente.Text), True);
end;

procedure TfrmClienteBusca.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmClienteBusca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmClienteBusca := nil;
end;

procedure TfrmClienteBusca.FormCreate(Sender: TObject);
begin
  vFancy := TFancyDialog.Create(frmClienteBusca);
end;

procedure TfrmClienteBusca.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
end;

procedure TfrmClienteBusca.FormShow(Sender: TObject);
begin
  fListarClientes(1, '', True);
end;

procedure TfrmClienteBusca.lvClienteItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if Assigned(ExecuteOnClick) then
    ExecuteOnClick(AItem.Tag, AItem.TagString);

  Close;
end;

procedure TfrmClienteBusca.lvClientePaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  //Verifico se a rolagem atingiu o limite para uma nova carga de registros
  if (lvCliente.Items.Count >= cQTD_REG_PAGINA_CLIENTE) and
  (lvCliente.Tag >= 0) then
    if lvCliente.GetItemRect(lvCliente.Items.Count - 5).Bottom <= lvCliente.Height then
      fListarClientes(lvCliente.Tag + 1, edBuscaCliente.Text, False);
end;

procedure TfrmClienteBusca.lvClienteUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  fLayoutListViewCliente(AItem);
end;

procedure TfrmClienteBusca.fAdicionaClienteListView(pCodClienteLocal: Integer; pNome, pEndereco, pNumero, pCompl, pBairro,
pCidade, pUF, pCPFCNPJ: String; pCodCidade: Integer);
var
  vItem: TListViewItem;
  vTxt : TListItemText;
  vImg : TListItemImage;
begin
  try
    vItem := lvCliente.Items.Add;
    vItem.Height := 85;

    vItem.TagString := pNome;
    vItem.Tag       := pCodClienteLocal;

    //Nome Cliente
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtNome'));
    vTxt.Text := pNome;

    //Endereco Completo
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtEndereco'));
    vTxt.Text := pEndereco;

    if pNumero <> '' then
      vTxt.Text := vTxt.Text + ', ' + pNumero;

    if pCompl <> '' then
      vTxt.Text := vTxt.Text + ', ' + pCompl;

    if pBairro <> '' then
      vTxt.Text := vTxt.Text + ', ' + pBairro;

    if pCidade <> '' then
      vTxt.Text := vTxt.Text + ', ' + pCidade;

    if pUF <> '' then
      vTxt.Text := vTxt.Text + ', ' + pUF;

    //CPF/CNPJ
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtCPFCNPJ'));
    vTxt.Text := 'CPF/CNPJ: ' + pCPFCNPJ;

    fLayoutListViewCliente(vItem);

  except on e:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao inserir cliente na lista: ' + e.Message, 'OK');
  end;

end;

procedure TfrmClienteBusca.fLayoutListViewCliente(pAItem: TListViewItem);
var
  vTxt: TListItemText;
begin
  vTxt          := TListItemText(pAItem.Objects.FindDrawable('txtEndereco'));
  vTxt.Width    := lvCliente.Width - 100;
  vTxt.Height   := fGetTextHeight(vTxt, vTxt.Width, vTxt.Text) + 5;

  pAItem.Height := Trunc(vTxt.PlaceOffset.Y + vTxt.Height);

end;

procedure TfrmClienteBusca.fListarClientes(pPagina: Integer; pBusca: String; pIndClear: Boolean);
var
  vThread: TThread;
begin
  imgSemCliente.Visible := False;

  //Evito processamento concorrente
  if lvCliente.TagString = 'S' then
    exit;

  // Em processamento..
  lvCliente.TagString := 'S';

  lvCliente.BeginUpdate;

  //limpo a lista
  if pIndClear then
  begin
    pPagina := 1;
    lvCliente.ScrollTo(0);
    lvCliente.Items.Clear;
  end;

  {
    Tag: contém a página atual solicitada ao servidor
    Quando a Tag for >= 1: faz o request para buscar mais dados
                      -1 : Indica que não tem mais dados
  }

  //Salvo a página atual a ser exibida
  lvCliente.Tag := pPagina;

  //Faço a requisição por mais dados
  vThread := TThread.CreateAnonymousThread(procedure
  begin
    DMCliente.fListarClientes(pPagina, pBusca);
  end);

  vThread.OnTerminate := fThreadClientesTerminate;
  vThread.Start;

end;

procedure TfrmClienteBusca.fThreadClientesTerminate(Sender: TObject);
begin
  // Não carregar mais dados..
  if DMCliente.QryConsCliente.RecordCount < cQTD_REG_PAGINA_CLIENTE then
    lvCliente.Tag := -1;

  while not DMCliente.QryConsCliente.Eof do
  begin
    fAdicionaClienteListView(DMCliente.QryConsCliente.FieldByName('CLI_CODIGO_LOCAL').AsInteger,
                             DMCliente.QryConsCliente.FieldByName('CLI_NOME').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_ENDERECO').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_NUMERO').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_COMPLEMENTO').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_BAIRRO').AsString,
                             DMCliente.QryConsCliente.FieldByName('CID_NOME').AsString,
                             DMCliente.QryConsCliente.FieldByName('CID_UF').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_CPF').AsString,
                             DMCliente.QryConsCliente.FieldByName('CID_CODIGO').AsInteger
                             );

    DMCliente.QryConsCliente.Next;

  end;

  lvCliente.EndUpdate;

  // Marco que o processo terminou
  lvCliente.TagString := '';

  //Verifico se a tela esta vazia, se estiver, ele habilita a imagem de tela vazia
  imgSemCliente.Visible := lvCliente.ItemCount = 0;

  //Caso e algum erro na Thread
  if Sender is TThread then
  begin
    if Assigned(TThread(Sender).FatalException) then
    begin
      vFancy.fShow(TIconDialog.Error, 'Erro', Exception(TThread(sender).FatalException).Message, 'OK');

      exit;
    end;
  end;
end;





end.
