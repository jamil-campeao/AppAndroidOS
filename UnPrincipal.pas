unit UnPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.TabControl, FMX.Ani,
  FMX.Layouts, FMX.Edit, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.ListBox;

type
  TfrmPrincipal = class(TForm)
    RectAbas: TRectangle;
    imgAbaDashBoard: TImage;
    imgAbaOS: TImage;
    imgAbaCliente: TImage;
    imgAbaNotificacao: TImage;
    imgAbaMais: TImage;
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    TabItem5: TTabItem;
    CirculoNotificacao: TCircle;
    RectAnimation1: TRectAnimation;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Rectangle3: TRectangle;
    Label3: TLabel;
    Rectangle4: TRectangle;
    Label4: TLabel;
    Rectangle5: TRectangle;
    Label5: TLabel;
    Layout1: TLayout;
    Label6: TLabel;
    Layout2: TLayout;
    VertScrollBox1: TVertScrollBox;
    Label7: TLabel;
    Layout3: TLayout;
    rectBuscaOS: TRectangle;
    StyleBook1: TStyleBook;
    edBuscaOS: TEdit;
    btBuscaOS: TSpeedButton;
    lvOS: TListView;
    btnAdicionarOS: TSpeedButton;
    Image1: TImage;
    btAdicionarCliente: TSpeedButton;
    Image2: TImage;
    lvNotificacao: TListView;
    Rectangle6: TRectangle;
    edBuscaCliente: TEdit;
    SpeedButton1: TSpeedButton;
    lvCliente: TListView;
    ListBox1: TListBox;
    lbiProdutos: TListBoxItem;
    lbiPerfil: TListBoxItem;
    lbiSenha: TListBoxItem;
    lbiSincronizar: TListBoxItem;
    lbiLogout: TListBoxItem;
    Image3: TImage;
    Label8: TLabel;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Label10: TLabel;
    Image8: TImage;
    Image9: TImage;
    Label11: TLabel;
    Image10: TImage;
    Image11: TImage;
    Label12: TLabel;
    Image12: TImage;
    Line1: TLine;
    Label9: TLabel;
    Line2: TLine;
    Line3: TLine;
    Line4: TLine;
    Line5: TLine;
    imgIconeCliente: TImage;
    imgIconeData: TImage;
    imgIconeSincronizar: TImage;
    imgIconeEndereco: TImage;
    imgIconeFone: TImage;
    procedure imgAbaDashBoardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btBuscaOSClick(Sender: TObject);
    procedure lvOSPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
  private
    procedure fAbrirAba(pImg: TImage);
    procedure fAdicionaPedidoListView(pOSLocal, pOSOficial, pCliente,
pDataOS, pIndSincronizar: String; pValor: Double);
    procedure fListarOS(pPagina: Integer; pBusca: String; pIndClear: Boolean);
    procedure fThreadOSTerminate(Sender: TObject);
    procedure fAdicionaClienteListView(pCodClienteLocal, pNome, pEndereco, pNumero, pCompl, pBairro,
pCidade, pUF, pFone, pIndSincronizar: String);
    procedure fListarClientes(pPagina: Integer; pBusca: String;
      pIndClear: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses DataModule.OS, uConstantes;

procedure TfrmPrincipal.btBuscaOSClick(Sender: TObject);
begin
  fListarOS(1, Trim(edBuscaOS.Text), True);
end;

procedure TfrmPrincipal.fAbrirAba(pImg: TImage);
begin
  imgAbaDashBoard.Opacity    := 0.5;
  imgAbaOS.Opacity           := 0.5;
  imgAbaCliente.Opacity      := 0.5;
  imgAbaNotificacao.Opacity  := 0.5;
  imgAbaMais.Opacity         := 0.5;

  pImg.Opacity := 1;

  TabControl.GotoVisibleTab(pImg.Tag);

  //Aba Cliente
  if pImg.Name = 'imgAbaCliente' then
    fListarClientes(1, Trim(edBuscaCliente.Text), True);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  fAbrirAba(imgAbaDashBoard);

  fListarOS(1, '', True);
end;

procedure TfrmPrincipal.imgAbaDashBoardClick(Sender: TObject);
begin
  fAbrirAba(TImage(Sender));
end;


procedure TfrmPrincipal.lvOSPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  //Verifico se a rolagem atingiu o limite para uma nova carga de registros
  if (lvOS.Items.Count >= cQTD_REG_PAGINA_OS) and
  (lvOS.Tag >= 0) then
    if lvOS.GetItemRect(lvOS.Items.Count - 5).Bottom <= lvOS.Height then
      fListarOS(lvOS.Tag + 1, edBuscaOS.Text, False);



end;

procedure TfrmPrincipal.fAdicionaPedidoListView(pOSLocal, pOSOficial, pCliente,
pDataOS, pIndSincronizar: String; pValor: Double);
var
  vItem: TListViewItem;
  vTxt : TListItemText;
  vImg : TListItemImage;
begin
  try
    vItem := lvOS.Items.Add;
    vItem.Height := 80;

    vItem.TagString := pOSLocal;

    //Numero da OS
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtOS'));
    if pOSOficial <> '' then
      vTxt.Text := 'OS #' + pOSOficial
    else
      vTxt.Text := 'Orçamento #' + pOSLocal;

    //Cliente
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtCliente'));
    vTxt.Text := pCliente;

    //DataOS
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtData'));
    vTxt.Text := pDataOS;

    //Valor
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtValor'));
    vTxt.Text := FormatFloat('R$#,##0.00', pValor);

    //Icone Cliente
    vImg        := TListItemImage(vItem.Objects.FindDrawable('imgCliente'));
    vImg.Bitmap := imgIconeCliente.Bitmap;

    //Icone Data
    vImg        := TListItemImage(vItem.Objects.FindDrawable('imgData'));
    vImg.Bitmap := imgIconeData.Bitmap;

    //Icone Sincronização
    if pIndSincronizar = 'S' then
    begin
      vImg        := TListItemImage(vItem.Objects.FindDrawable('imgSincronizar'));
      vImg.Bitmap := imgIconeSincronizar.Bitmap;
    end;


  except on e:Exception do
    ShowMessage('Erro ao inserir pedido na lista: ' + e.Message);

  end;

end;

procedure TfrmPrincipal.fListarOS(pPagina: Integer; pBusca: String; pIndClear: Boolean);
var
  vThread: TThread;
begin
  //Evito processamento concorrente
  if lvOS.TagString = 'S' then
    exit;

  // Em processamento..
  lvOS.TagString := 'S';

  lvOS.BeginUpdate;

  //limpo a lista
  if pIndClear then
  begin
    pPagina := 1;
    lvOS.ScrollTo(0);
    lvOS.Items.Clear;
  end;

  {
    Tag: contém a página atual solicitada ao servidor
    Quando a Tag for >= 1: faz o request para buscar mais dados
                      -1 : Indica que não tem mais dados
  }

  //Salvo a página atual a ser exibida
  lvOs.Tag := pPagina;

  //Faço a requisição por mais dados
  vThread := TThread.CreateAnonymousThread(procedure
  begin
    DMOS.fListarOS(pPagina, pBusca);
  end);

  vThread.OnTerminate := fThreadOSTerminate;
  vThread.Start;

end;

procedure TfrmPrincipal.fThreadOSTerminate(Sender: TObject);
begin
  // Não carregar mais dados..
  if DMOS.QryConsOS.RecordCount < cQTD_REG_PAGINA_OS then
    lvOS.Tag := -1;

  while not DMOS.QryConsOS.Eof do
  begin
    fAdicionaPedidoListView(DMOS.QryConsOS.FieldByName('OS_CODIGOLOCAL').AsString,
                            DMOS.QryConsOS.FieldByName('OS_CODIGO').AsString,
                            DMOS.QryConsOS.FieldByName('CLI_NOME').AsString,
                            FormatDateTime('dd/mm/yyyy', DMOS.QryConsOS.FieldByName('OS_DATAABERTURA').AsDateTime),
                            DMOS.QryConsOS.FieldByName('OS_IND_SINCRONIZAR').AsString,
                            DMOS.QryConsOS.FieldByName('OS_TOTALGERAL').AsFloat);

    DMOS.QryConsOS.Next;
  end;

  lvOS.EndUpdate;

  // Marco que o processo terminou
  lvOS.TagString := '';

  //Caso e algum erro na Thread
  if Sender is TThread then
  begin
    if Assigned(TThread(Sender).FatalException) then
    begin
      ShowMessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;
  end;
end;

procedure TfrmPrincipal.fAdicionaClienteListView(pCodClienteLocal, pNome, pEndereco, pNumero, pCompl, pBairro,
pCidade, pUF, pFone, pIndSincronizar: String);
var
  vItem: TListViewItem;
  vTxt : TListItemText;
  vImg : TListItemImage;
begin
  try
    vItem := lvCliente.Items.Add;
    vItem.Height := 85;

    vItem.TagString := pCodClienteLocal;

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

    //Fone
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtFone'));
    vTxt.Text := pFone;

    //Icone Endereco
    vImg        := TListItemImage(vItem.Objects.FindDrawable('imgEndereco'));
    vImg.Bitmap := imgIconeEndereco.Bitmap;

    //Icone Fone
    vImg        := TListItemImage(vItem.Objects.FindDrawable('imgFone'));
    vImg.Bitmap := imgIconeFone.Bitmap;

    //Icone Sincronização
    if pIndSincronizar = 'S' then
    begin
      vImg        := TListItemImage(vItem.Objects.FindDrawable('imgSincronizar'));
      vImg.Bitmap := imgIconeSincronizar.Bitmap;
    end;


  except on e:Exception do
    ShowMessage('Erro ao inserir cliente na lista: ' + e.Message);

  end;

end;


procedure TfrmPrincipal.fListarClientes(pPagina: Integer; pBusca: String; pIndClear: Boolean);
var
  vThread: TThread;
begin

  fAdicionaClienteListView('1233', 'Pop Move', 'Av. Paulista', '500', 'Apt 302',
  'Jardins', 'São Paulo', 'SP', '(11) 9929843', 'S');

  fAdicionaClienteListView('1233', 'Seara', 'Av. Paulista', '500', 'Apt 302',
  'Jardins', 'São Paulo', 'SP', '(11) 9929843', 'N');

  {
  //Evito processamento concorrente
  if lvOS.TagString = 'S' then
    exit;

  // Em processamento..
  lvOS.TagString := 'S';

  lvOS.BeginUpdate;

  //limpo a lista
  if pIndClear then
  begin
    pPagina := 1;
    lvOS.ScrollTo(0);
    lvOS.Items.Clear;
  end;
  }

  {
    Tag: contém a página atual solicitada ao servidor
    Quando a Tag for >= 1: faz o request para buscar mais dados
                      -1 : Indica que não tem mais dados
  }
  {
  //Salvo a página atual a ser exibida
  lvOs.Tag := pPagina;

  //Faço a requisição por mais dados
  vThread := TThread.CreateAnonymousThread(procedure
  begin
    DMOS.fListarOS(pPagina, pBusca);
  end);

  vThread.OnTerminate := fThreadOSTerminate;
  vThread.Start;
  }

end;



end.
