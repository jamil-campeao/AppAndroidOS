unit UnPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.TabControl, FMX.Ani,
  FMX.Layouts, FMX.Edit, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.ListBox, FMX.TextLayout,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, uFancyDialog, uActionSheet, UnLogin,
  DataModule.Produto;

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
    btBuscaCliente: TSpeedButton;
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
    imgIconeMenu: TImage;
    imgSemOS: TImage;
    imgSemCliente: TImage;
    imgSemNotificacao: TImage;
    procedure imgAbaDashBoardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btBuscaOSClick(Sender: TObject);
    procedure lvOSPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure btBuscaClienteClick(Sender: TObject);
    procedure lvClientePaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lvNotificacaoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lvNotificacaoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvClienteUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lbiProdutosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btAdicionarClienteClick(Sender: TObject);
    procedure lvClienteItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvNotificacaoItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lbiPerfilClick(Sender: TObject);
    procedure lbiSenhaClick(Sender: TObject);
    procedure lbiLogoutClick(Sender: TObject);
    procedure lbiSincronizarClick(Sender: TObject);
    procedure btnAdicionarOSClick(Sender: TObject);
  private
    vFancy : TFancyDialog;
    vMenuNotificacao: TActionSheet;
    procedure fAbrirAba(pImg: TImage);
    procedure fAdicionaOSListView(pOSLocal, pOSOficial, pCliente,
pDataOS, pIndSincronizar: String; pValor: Double);
    procedure fListarOS(pPagina: Integer; pBusca: String; pIndClear: Boolean);
    procedure fThreadOSTerminate(Sender: TObject);
    procedure fAdicionaClienteListView(pCodClienteLocal, pNome, pEndereco, pNumero, pCompl, pBairro,
pCidade, pUF, pFone, pIndSincronizar: String; pCodCidade: Integer);
    procedure fListarClientes(pPagina: Integer; pBusca: String;
      pIndClear: Boolean);
    procedure fThreadClientesTerminate(Sender: TObject);
    procedure fAdicionaNotificacaoListView(pCodNotificacao, pData, pTitulo,
      pTexto, pIndLido: String);
    procedure fListarNotificacoes(pPagina: Integer; pIndClear: Boolean);
    procedure fThreadNotificacoesTerminate(Sender: TObject);
    procedure fLayoutListViewNotificacao(pAItem: TListViewItem);
    procedure fLayoutListViewCliente(pAItem: TListViewItem);
    procedure fRefreshListagemCliente;
    procedure fClickNotificacaoExcluir(Sender: TObject);
    procedure fClickNotificacaoLida(Sender: TObject);
    procedure fClickNotificacaoNaoLida(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses DataModule.OS, uConstantes, DataModule.Cliente, DataModule.Notificacao,
  uFunctions, UnProduto, UnClienteCad, UnPerfilCad, UnSenhaCad,
  DataModule.Usuario, UnSincronizacao, UnOSCad;

procedure TfrmPrincipal.btAdicionarClienteClick(Sender: TObject);
begin
  if not Assigned(FrmClienteCad) then
    Application.CreateForm(TFrmClienteCad, frmClienteCad);

  frmClienteCad.Modo := 'I';
  frmClienteCad.Cod_Cliente := 0;
  frmClienteCad.ExecuteOnClose := fRefreshListagemCliente;
  frmClienteCad.Show;
end;

procedure TfrmPrincipal.btBuscaClienteClick(Sender: TObject);
begin
  fListarClientes(1, Trim(edBuscaCliente.Text), True);
end;

procedure TfrmPrincipal.btBuscaOSClick(Sender: TObject);
begin
  fListarOS(1, Trim(edBuscaOS.Text), True);
end;

procedure TfrmPrincipal.btnAdicionarOSClick(Sender: TObject);
begin
  if not Assigned(FrmOSCad) then
    Application.CreateForm(TFrmOSCad, FrmOSCad);

  FrmOSCad.Show;
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

  //Aba Notificacoes
  if pImg.Name = 'imgAbaNotificacao' then
    fListarNotificacoes(1, True);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
{$REGION 'CRIAÇÃO DOS DATAMODULES'}
    if not Assigned(DMUsuario) then
      Application.CreateForm(TDMUsuario, DMUsuario);

    if not Assigned(DMNotificacao) then
      Application.CreateForm(TDMNotificacao, DMNotificacao);

    if not Assigned(DMOS) then
      Application.CreateForm(TDMOS, DMOS);

    if not Assigned(DMCliente) then
      Application.CreateForm(TDMCliente, DMCliente);

    if not Assigned(DMProduto) then
      Application.CreateForm(TDMProduto, DMProduto);
{$ENDREGION}


  vFancy           := TFancyDialog.Create(frmPrincipal);
  vMenuNotificacao := TActionSheet.Create(frmPrincipal);

  vMenuNotificacao.TitleFontSize     := 12;
  vMenuNotificacao.TitleMenuText     := 'O que deseja fazer?';
  vMenuNotificacao.TitleFontColor    := $FF404040;
  vMenuNotificacao.CancelMenuText    := 'Cancelar';
  vMenuNotificacao.CancelFontSize    := 15;
  vMenuNotificacao.CancelFontColor   := $FF585F5A;
  vMenuNotificacao.BackgroundOpacity := 0.5;
  vMenuNotificacao.MenuColor         := $FFFFFFFF;

  vMenuNotificacao.fAddItem('', 'Excluir', fClickNotificacaoExcluir, $FFFB4747, 15);
  vMenuNotificacao.fAddItem('', 'Marcar como lida', fClickNotificacaoLida, $FF585F5A, 15);
  vMenuNotificacao.fAddItem('', 'Marcar como não lida', fClickNotificacaoNaoLida, $FF585F5A, 15);

end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
  vMenuNotificacao.DisposeOf;
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


procedure TfrmPrincipal.lbiLogoutClick(Sender: TObject);
begin
  try
    DMUsuario.fLogout;

    if not Assigned(frmLogin) then
      Application.CreateForm(TfrmLogin, frmLogin);

    Application.MainForm := FrmLogin;

    FrmLogin.Show;
    FrmPrincipal.Close;

  except on e:exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao fazer logout: ' + e.Message, 'OK');


  end;
end;

procedure TfrmPrincipal.lbiPerfilClick(Sender: TObject);
begin
  if not Assigned(frmPerfilCad) then
    Application.CreateForm(TFrmPerfilCad, frmPerfilCad);

  frmPerfilCad.Show;
end;

procedure TfrmPrincipal.lbiProdutosClick(Sender: TObject);
begin
  if not Assigned(FrmProduto) then
    Application.CreateForm(TFrmProduto, frmProduto);

    FrmProduto.Show;
end;

procedure TfrmPrincipal.lbiSenhaClick(Sender: TObject);
begin
  if not Assigned(frmSenhaCad) then
    Application.CreateForm(TfrmSenhaCad, frmSenhaCad);

  frmSenhaCad.Show;
end;

procedure TfrmPrincipal.lbiSincronizarClick(Sender: TObject);
begin
  if not Assigned(frmSincronizacao) then
    Application.CreateForm(TfrmSincronizacao, frmSincronizacao);

  FrmSincronizacao.Show;
end;

procedure TfrmPrincipal.lvClienteItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if not Assigned(frmClienteCad) then
    Application.CreateForm(TFrmClienteCad, frmClienteCad);

  FrmClienteCad.Modo           := 'A';
  FrmClienteCad.Cod_Cliente    := Aitem.TagString.ToInteger;
  FrmClienteCad.Cod_Cidade     := DMCliente.fRetornaCidadeCliente(AItem.TagString.ToInteger);
  FrmCLienteCad.ExecuteOnClose := fRefreshListagemCliente;
  FrmClienteCad.Show;
end;

procedure TfrmPrincipal.lvClientePaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  //Verifico se a rolagem atingiu o limite para uma nova carga de registros
  if (lvCliente.Items.Count >= cQTD_REG_PAGINA_CLIENTE) and
  (lvCliente.Tag >= 0) then
    if lvCliente.GetItemRect(lvCliente.Items.Count - 5).Bottom <= lvCliente.Height then
      fListarClientes(lvCliente.Tag + 1, edBuscaCliente.Text, False);
end;

procedure TfrmPrincipal.lvClienteUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  fLayoutListViewCliente(AItem);
end;

procedure TfrmPrincipal.lvNotificacaoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if Assigned(ItemObject) then
    if ItemObject.Name = 'imgMenu' then
    begin
      vMenuNotificacao.TagString := ItemObject.TagString; // Código da notificação
      vMenuNotificacao.fShowMenu;
    end;
end;

procedure TfrmPrincipal.lvNotificacaoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  //Verifico se a rolagem atingiu o limite para uma nova carga de registros
  if (lvNotificacao.Items.Count >= cQTD_REG_PAGINA_NOTIFICACAO) and
  (lvNotificacao.Tag >= 0) then
    if lvNotificacao.GetItemRect(lvNotificacao.Items.Count - 5).Bottom <= lvNotificacao.Height then
      fListarNotificacoes(lvNotificacao.Tag + 1, False);
end;

procedure TfrmPrincipal.lvNotificacaoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  fLayoutListViewNotificacao(AItem);
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

procedure TfrmPrincipal.fAdicionaOSListView(pOSLocal, pOSOficial, pCliente,
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
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao inserir pedido na lista: ' + e.Message, 'OK');

  end;

end;

procedure TfrmPrincipal.fListarOS(pPagina: Integer; pBusca: String; pIndClear: Boolean);
var
  vThread: TThread;
begin
  imgSemOS.Visible := False;

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
    fAdicionaOSListView(DMOS.QryConsOS.FieldByName('OS_CODIGO_LOCAL').AsString,
                            DMOS.QryConsOS.FieldByName('OS_CODIGO_OFICIAL').AsString,
                            DMOS.QryConsOS.FieldByName('CLI_NOME').AsString,
                            FormatDateTime('dd/mm/yyyy', DMOS.QryConsOS.FieldByName('OS_DATAABERTURA').AsDateTime),
                            DMOS.QryConsOS.FieldByName('OS_IND_SINCRONIZAR').AsString,
                            DMOS.QryConsOS.FieldByName('OS_TOTALGERAL').AsFloat);

    DMOS.QryConsOS.Next;
  end;

  lvOS.EndUpdate;

  // Marco que o processo terminou
  lvOS.TagString := '';

  //Verifico se a tela esta vazia, se estiver, ele habilita a imagem de tela vazia
  imgSemOS.Visible := lvOS.ItemCount = 0;

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

procedure TfrmPrincipal.fAdicionaClienteListView(pCodClienteLocal, pNome, pEndereco, pNumero, pCompl, pBairro,
pCidade, pUF, pFone, pIndSincronizar: String; pCodCidade: Integer);
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

    fLayoutListViewCliente(vItem);

  except on e:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao inserir cliente na lista: ' + e.Message, 'OK');
  end;

end;


procedure TfrmPrincipal.fListarClientes(pPagina: Integer; pBusca: String; pIndClear: Boolean);
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

procedure TfrmPrincipal.fThreadClientesTerminate(Sender: TObject);
begin
  // Não carregar mais dados..
  if DMCliente.QryConsCliente.RecordCount < cQTD_REG_PAGINA_CLIENTE then
    lvCliente.Tag := -1;

  while not DMCliente.QryConsCliente.Eof do
  begin
    fAdicionaClienteListView(DMCliente.QryConsCliente.FieldByName('CLI_CODIGO_LOCAL').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_NOME').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_ENDERECO').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_NUMERO').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_COMPLEMENTO').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_BAIRRO').AsString,
                             DMCliente.QryConsCliente.FieldByName('CID_NOME').AsString,
                             DMCliente.QryConsCliente.FieldByName('CID_UF').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_CEL').AsString,
                             DMCliente.QryConsCliente.FieldByName('CLI_IND_SINCRONIZAR').AsString,
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

procedure TfrmPrincipal.fAdicionaNotificacaoListView(pCodNotificacao, pData, pTitulo, pTexto, pIndLido: String);
var
  vItem: TListViewItem;
  vTxt : TListItemText;
  vImg : TListItemImage;
begin
  try
    vItem := lvNotificacao.Items.Add;
    vItem.Height := 90;

    vItem.TagString := pCodNotificacao;

    //Titulo
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtTitulo'));
    vTxt.Text := pTitulo;
    vTxt.TagString := pIndLido;

    //Data
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtData'));
    vTxt.Text := pData;

    //Texto
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtMensagem'));
    vTxt.Text := pTexto;

    //Icone Data
    vImg        := TListItemImage(vItem.Objects.FindDrawable('imgData'));
    vImg.Bitmap := imgIconeData.Bitmap;

    //Icone Menu
    vImg        := TListItemImage(vItem.Objects.FindDrawable('imgMenu'));
    vImg.Bitmap := imgIconeMenu.Bitmap;

    vImg.TagString := pCodNotificacao; // Salvo o código da notificação na imagem para uso futuro

    fLayoutListViewNotificacao(vItem);

  except on e:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao inserir notificação na lista: ' + e.Message, 'OK');

  end;

end;

procedure TfrmPrincipal.fListarNotificacoes(pPagina: Integer; pIndClear: Boolean);
var
  vThread: TThread;
begin
  imgSemNotificacao.Visible := False;

  //Evito processamento concorrente
  if lvNotificacao.TagString = 'S' then
    exit;

  // Em processamento..
  lvNotificacao.TagString := 'S';

  lvNotificacao.BeginUpdate;

  //limpo a lista
  if pIndClear then
  begin
    pPagina := 1;
    lvNotificacao.ScrollTo(0);
    lvNotificacao.Items.Clear;
  end;

  {
    Tag: contém a página atual solicitada ao servidor
    Quando a Tag for >= 1: faz o request para buscar mais dados
                      -1 : Indica que não tem mais dados
  }

  //Salvo a página atual a ser exibida
  lvNotificacao.Tag := pPagina;

  //Faço a requisição por mais dados
  vThread := TThread.CreateAnonymousThread(procedure
  begin
    DMNotificacao.fListarNotificacoes(pPagina);
  end);

  vThread.OnTerminate := fThreadNotificacoesTerminate;
  vThread.Start;

end;

procedure TfrmPrincipal.fThreadNotificacoesTerminate(Sender: TObject);
begin
  // Não carregar mais dados..
  if DMNotificacao.QryConsNotificacao.RecordCount < cQTD_REG_PAGINA_NOTIFICACAO then
    lvNotificacao.Tag := -1;

  while not DMNotificacao.QryConsNotificacao.Eof do
  begin
    fAdicionaNotificacaoListView(DMNotificacao.QryConsNotificacao.FieldByName('NOT_CODIGO').AsString,
                                 FormatDateTime('dd/mm/yyyy hh:nn', DMNotificacao.QryConsNotificacao.FieldByName('NOT_DATA').AsDateTime),
                                 DMNotificacao.QryConsNotificacao.FieldByName('NOT_TITULO').AsString,
                                 DMNotificacao.QryConsNotificacao.FieldByName('NOT_TEXTO').AsString,
                                 DMNotificacao.QryConsNotificacao.FieldByName('NOT_IND_LIDO').AsString
                                 );

    DMNotificacao.QryConsNotificacao.Next;
  end;
  lvNotificacao.EndUpdate;

  // Marco que o processo terminou
  lvNotificacao.TagString := '';

  //Verifico se a tela esta vazia, se estiver, ele habilita a imagem de tela vazia
  imgSemNotificacao.Visible := lvNotificacao.ItemCount = 0;


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

procedure TfrmPrincipal.fLayoutListViewNotificacao(pAItem: TListViewItem);
var
  vTxt: TListItemText;
begin
  vtxt          := TListItemText(pAItem.Objects.FindDrawable('txtTitulo'));

  if vtxt.TagString = 'N' then //IND_LIDO
    vTxt.Font.Style := [TFontStyle.fsBold];

  vTxt          := TListItemText(pAItem.Objects.FindDrawable('txtMensagem'));
  vTxt.Width    := lvNotificacao.Width - 22;
  vTxt.Height   := fGetTextHeight(vTxt, vTxt.Width, vTxt.Text) + 5;

  pAItem.Height := Trunc(vTxt.PlaceOffset.Y + vTxt.Height);

end;

procedure TfrmPrincipal.fLayoutListViewCliente(pAItem: TListViewItem);
var
  vTxt: TListItemText;
begin
  vTxt          := TListItemText(pAItem.Objects.FindDrawable('txtEndereco'));
  vTxt.Width    := lvCliente.Width - 100;
  vTxt.Height   := fGetTextHeight(vTxt, vTxt.Width, vTxt.Text) + 5;

  pAItem.Height := Trunc(vTxt.PlaceOffset.Y + vTxt.Height);

end;

procedure TfrmPrincipal.fRefreshListagemCliente;
begin
  fListarClientes(1, Trim(edBuscaCliente.Text), True);
end;

procedure TfrmPrincipal.fClickNotificacaoExcluir(Sender: TObject);
begin
  vMenuNotificacao.fHideMenu;

  DMNotificacao.fExcluirNotificacao(vMenuNotificacao.TagString.ToInteger);

  fListarNotificacoes(1, true);

end;


procedure TfrmPrincipal.fClickNotificacaoLida(Sender: TObject);
begin
  vMenuNotificacao.fHideMenu;
  DMNotificacao.fMarcarNotificacaoLida(vMenuNotificacao.TagString.ToInteger);
  fListarNotificacoes(1, true);

end;


procedure TfrmPrincipal.fClickNotificacaoNaoLida(Sender: TObject);
begin
  vMenuNotificacao.fHideMenu;
  DMNotificacao.fMarcarNotificacaoNaoLida(vMenuNotificacao.TagString.ToInteger);
  fListarNotificacoes(1, true);
end;

end.
