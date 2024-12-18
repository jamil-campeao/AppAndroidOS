unit UnProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, Data.DB;

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
    procedure FormShow(Sender: TObject);
    procedure btBuscaProdutoClick(Sender: TObject);
  private
    procedure fAdicionaProdutoListView(pCodProdutoLocal, pDescricao: String;
      pValor, pEstoque: Double; pFoto: TStream);
    procedure fListarProdutos(pPagina: Integer; pBusca: String;
      pIndClear: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProduto: TfrmProduto;

implementation

{$R *.fmx}

uses UnPrincipal, DataModule.Produto;

procedure TfrmProduto.btBuscaProdutoClick(Sender: TObject);
begin
  fListarProdutos(1, Trim(edBuscaProduto.Text), True);
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

    //Descrição
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

  except on e:Exception do
    ShowMessage('Erro ao inserir produto na lista: ' + e.Message);

  end;

end;


procedure TfrmProduto.fListarProdutos(pPagina: Integer; pBusca: String; pIndClear: Boolean);
var
  vFoto : TStream;
begin
  if pIndClear then
    lvProduto.Items.Clear;

  DMProduto.fListarProdutos(pPagina, pBusca);

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
                             nil
                             );


    DMProduto.QryConsProduto.Next;
  end;
end;

procedure TfrmProduto.FormShow(Sender: TObject);
begin
  fListarProdutos(1, '', True);
end;

end.
