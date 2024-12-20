unit UnProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, Data.DB,
  uFancyDialog;

type
  TfrmProduto = class(TForm)
    rectToolBar: TRectangle;
    Label3: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    rectBusca: TRectangle;
    edBuscaProduto: TEdit;
    btBuscaProduto: TSpeedButton;
    btAdicionarProduto: TSpeedButton;
    Image1: TImage;
    lvProduto: TListView;
    imgIconeEstoque: TImage;
    imgIconeValor: TImage;
    imgIconeSemFoto: TImage;
    imgSemProduto: TImage;
    procedure FormShow(Sender: TObject);
    procedure btBuscaProdutoClick(Sender: TObject);
    procedure lvProdutoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lvProdutoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btAdicionarProdutoClick(Sender: TObject);
    procedure lvProdutoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btVoltarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  vFancy : TFancyDialog;
    procedure fAdicionaProdutoListView(pCodProdutoLocal, pDescricao: String;
      pValor, pEstoque: Double; pFoto: TStream);
    procedure fListarProdutos(pPagina: Integer; pBusca: String;
      pIndClear: Boolean);
    procedure fThreadProdutosTerminate(Sender: TObject);
    procedure fLayoutListViewProduto(pAItem: TListViewItem);
    procedure fRefreshListagem;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProduto: TfrmProduto;

implementation

{$R *.fmx}

uses UnPrincipal, DataModule.Produto, uConstantes, uFunctions, UnProdutoCad;

procedure TfrmProduto.btAdicionarProdutoClick(Sender: TObject);
begin
  if not Assigned(FrmProdutoCad) then
    Application.CreateForm(TFrmProdutoCad, FrmProdutoCad);

  FrmProdutoCad.Modo := 'I';
  FrmProdutoCad.Cod_Produto := 0;
  frmProdutoCad.ExecuteOnClose := fRefreshListagem;
  FrmProdutoCad.Show;
end;

procedure TfrmProduto.btBuscaProdutoClick(Sender: TObject);
begin
  fListarProdutos(1, Trim(edBuscaProduto.Text), True);
end;

procedure TfrmProduto.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProduto.fAdicionaProdutoListView(pCodProdutoLocal, pDescricao: String;
pValor, pEstoque: Double;
pFoto: TStream);
var
  vItem: TListViewItem;
  vTxt : TListItemText;
  vImg : TListItemImage;
  vBmp : TBitmap;
begin
  try
    vItem := lvProduto.Items.Add;
    vItem.Height := 85;

    vItem.TagString := pCodProdutoLocal;

    //Descri��o
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtDescricao'));
    vTxt.Text := pDescricao;

    //Valor
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtValor'));
    vTxt.Text := FormatFloat('R$#,##0.00', pValor);

    //Estoque
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtEstoque'));
    vTxt.Text := FormatFloat('#,##0.00', pEstoque);

    //Icone Valor
    vImg        := TListItemImage(vItem.Objects.FindDrawable('imgValor'));
    vImg.Bitmap := imgIconeValor.Bitmap;

    //Icone Estoque
    vImg        := TListItemImage(vItem.Objects.FindDrawable('imgEstoque'));
    vImg.Bitmap := imgIconeEstoque.Bitmap;

    //Foto
    vImg        := TListItemImage(vItem.Objects.FindDrawable('imgFoto'));
    if pFoto <> nil then
    begin
      vBmp := TBitMap.Create;
      vBmp.LoadFromStream(pFoto);

      vImg.OwnsBitmap := True;
      vImg.Bitmap     := vBmp;
    end
    else
      vImg.Bitmap := imgIconeSemFoto.Bitmap;

    fLayoutListViewProduto(vItem);

  except on e:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao inserir produto na lista: ' + e.Message, 'OK');

  end;

end;


procedure TfrmProduto.fListarProdutos(pPagina: Integer; pBusca: String; pIndClear: Boolean);
var
  vThread : TThread;
begin
  imgSemProduto.Visible := False;

  //Evito processamento concorrente
  if lvProduto.TagString = 'S' then
    exit;

  // Em processamento..
  lvProduto.TagString := 'S';

  lvProduto.BeginUpdate;

  //limpo a lista
  if pIndClear then
  begin
    pPagina := 1;
    lvProduto.ScrollTo(0);
    lvProduto.Items.Clear;
  end;

  {
    Tag: cont�m a p�gina atual solicitada ao servidor
    Quando a Tag for >= 1: faz o request para buscar mais dados
                      -1 : Indica que n�o tem mais dados
  }

  //Salvo a p�gina atual a ser exibida
  lvProduto.Tag := pPagina;

  //Fa�o a requisi��o por mais dados
  vThread := TThread.CreateAnonymousThread(procedure
  begin
    DMProduto.fListarProdutos(pPagina, pBusca);
  end);

  vThread.OnTerminate := fThreadProdutosTerminate;
  vThread.Start;

end;

procedure TfrmProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action     := TCloseAction.caFree;
  FrmProduto := nil;
end;

procedure TfrmProduto.FormCreate(Sender: TObject);
begin
  vFancy := TFancyDialog.Create(frmProduto);
end;

procedure TfrmProduto.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
end;

procedure TfrmProduto.FormShow(Sender: TObject);
begin
  fListarProdutos(1, '', True);
end;

procedure TfrmProduto.fThreadProdutosTerminate(Sender: TObject);
var
  vFoto   : TStream;
begin
  // N�o carregar mais dados..
  if DMProduto.QryConsProduto.RecordCount < cQTD_REG_PAGINA_PRODUTO then
    lvProduto.Tag := -1;

  while not DMProduto.QryConsProduto.Eof do
  begin
    if DMProduto.QryConsProduto.FieldByName('FOTO').AsString <> '' then
      vFoto := DMProduto.QryConsProduto.CreateBlobStream(DMProduto.QryConsProduto.FieldByName('FOTO'), TBlobStreamMode.bmRead)
    else
      vFoto := nil;

    fAdicionaProdutoListView(DMProduto.QryConsProduto.FieldByName('PROD_CODIGO_LOCAL').AsString,
                             DMProduto.QryConsProduto.FieldByName('PROD_DESCRICAO').AsString,
                             DMProduto.QryConsProduto.FieldByName('PROD_VALORVENDA').AsFloat,
                             DMProduto.QryConsProduto.FieldByName('PROD_ESTOQUE').AsFloat,
                             vFoto
                             );


    DMProduto.QryConsProduto.Next;
  end;

  lvProduto.EndUpdate;

  // Marco que o processo terminou
  lvProduto.TagString := '';

  //Verifico se a tela esta vazia, se estiver, ele habilita a imagem de tela vazia
  imgSemProduto.Visible := lvProduto.ItemCount = 0;


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


procedure TfrmProduto.lvProdutoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if not Assigned(FrmProdutoCad) then
    Application.CreateForm(TFrmProdutoCad, FrmProdutoCad);

  FrmProdutoCad.Modo           := 'A';
  FrmProdutoCad.Cod_Produto    := AItem.TagString.ToInteger;
  FrmProdutoCad.ExecuteOnClose := fRefreshListagem;
  FrmProdutoCad.Show;
end;

procedure TfrmProduto.lvProdutoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  //Verifico se a rolagem atingiu o limite para uma nova carga de registros
  if (lvProduto.Items.Count >= cQTD_REG_PAGINA_PRODUTO) and
  (lvProduto.Tag >= 0) then
    if lvProduto.GetItemRect(lvProduto.Items.Count - 5).Bottom <= lvProduto.Height then
      fListarProdutos(lvProduto.Tag + 1, Trim(edBuscaProduto.Text), False);
end;

procedure TfrmProduto.lvProdutoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  fLayoutListViewProduto(AItem);
end;

procedure TfrmProduto.fLayoutListViewProduto(pAItem: TListViewItem);
var
  vTxt      : TListItemText;
  vImg      : TListItemImage;
  vPosicaoY : Extended;
begin
  vTxt         := TListItemText(pAItem.Objects.FindDrawable('txtDescricao'));
  vTxt.Width   := lvProduto.Width - 84;
  vTxt.Height  := fGetTextHeight(vTxt, vTxt.Width, vTxt.Text) + 3;

  vPosicaoY    := vTxt.PlaceOffset.Y + vTxt.Height;

  TListItemText(pAItem.Objects.FindDrawable('txtValor')).PlaceOffset.Y   := vPosicaoY;
  TListItemText(pAItem.Objects.FindDrawable('txtEstoque')).PlaceOffset.Y := vPosicaoY;
  TListItemText(pAItem.Objects.FindDrawable('imgEstoque')).PlaceOffset.Y := vPosicaoY;
  TListItemText(pAItem.Objects.FindDrawable('imgValor')).PlaceOffset.Y   := vPosicaoY;

  pAItem.Height := Trunc(vPosicaoY + 30);

end;

procedure TfrmProduto.fRefreshListagem;
begin
  fListarProdutos(1, Trim(edBuscaProduto.Text), True);
end;


end.
