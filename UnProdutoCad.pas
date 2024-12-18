unit UnProdutoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, uActionSheet, u99Permissions,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns;

type
  TfrmProdutoCad = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSalvar: TSpeedButton;
    Layout1: TLayout;
    imgFoto: TImage;
    Label1: TLabel;
    Image1: TImage;
    rectDescricao: TRectangle;
    Label2: TLabel;
    Image4: TImage;
    lblDescricao: TLabel;
    rectValor: TRectangle;
    Label3: TLabel;
    Image3: TImage;
    lblValor: TLabel;
    rectEstoque: TRectangle;
    Label4: TLabel;
    Image5: TImage;
    lblEstoque: TLabel;
    ActionList1: TActionList;
    ActCamera: TTakePhotoFromCameraAction;
    ActBibliotecaFotos: TTakePhotoFromLibraryAction;
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgFotoClick(Sender: TObject);
    procedure ActBibliotecaFotosDidFinishTaking(Image: TBitmap);
    procedure ActCameraDidFinishTaking(Image: TBitmap);
    procedure rectDescricaoClick(Sender: TObject);
    procedure rectValorClick(Sender: TObject);
    procedure rectEstoqueClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    vMenu      : TActionSheet;
    vPermissao : T99Permissions;
    FCod_produto: Integer;
    FModo: String;
    procedure fClickBibliotecaFotos(Sender: TObject);
    procedure fClickTirarFoto(Sender: TObject);
    procedure fErroPermissaoFotos(Sender: TObject);
    { Private declarations }
  public
  property Modo: String read FModo write FModo;
  property Cod_Produto: Integer read FCod_produto write FCod_produto;
    { Public declarations }
  end;

var
  frmProdutoCad: TfrmProdutoCad;

implementation

{$R *.fmx}

uses UnPrincipal, UnEdicaoPadrao, DataModule.Produto, uFunctions, Data.DB;

procedure TfrmProdutoCad.ActBibliotecaFotosDidFinishTaking(Image: TBitmap);
begin
  imgFoto.Bitmap := Image;
end;

procedure TfrmProdutoCad.ActCameraDidFinishTaking(Image: TBitmap);
begin
  imgFoto.Bitmap := Image;
end;

procedure TfrmProdutoCad.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProdutoCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action        := TCloseAction.caFree;
  FrmProdutoCad := nil;
end;

procedure TfrmProdutoCad.FormCreate(Sender: TObject);
begin
  vMenu      := TActionSheet.Create(frmProdutoCad);
  vPermissao := T99Permissions.Create;

  vMenu.TitleFontSize     := 12;
  vMenu.TitleMenuText     := 'O que deseja fazer?';
  vMenu.TitleFontColor    := $FF404040;
  vMenu.CancelMenuText    := 'Cancelar';
  vMenu.CancelFontSize    := 15;
  vMenu.CancelFontColor   := $FFFB4747;
  vMenu.BackgroundOpacity := 0.5;
  vMenu.MenuColor         := $FFFFFFFF;

  vMenu.fAddItem('', 'Carregar Foto', fClickBibliotecaFotos, $FF585F5A, 15);
  vMenu.fAddItem('', 'Tirar Foto', fClickTirarFoto, $FF585F5A, 15);
end;

procedure TfrmProdutoCad.FormDestroy(Sender: TObject);
begin
  vMenu.DisposeOf;
  vPermissao.DisposeOf;
end;

procedure TfrmProdutoCad.FormShow(Sender: TObject);
begin
  try
    if Modo = 'A' then
    begin
      DMProduto.fListarProdutoId(Cod_Produto);

      if DMProduto.QryProduto.FieldByName('FOTO').AsString <> '' then
        fLoadBitmapFromBlob(imgFoto.Bitmap, TBlobField(DMProduto.QryProduto.FieldByName('FOTO')));


      lblDescricao.Text := DMProduto.QryProduto.FieldByName('PROD_DESCRICAO').AsString;
      lblValor.Text     := FormatFloat('#,##0.00', DMProduto.QryProduto.FieldByName('PROD_VALORVENDA').AsFloat);
      lblEstoque.Text   := FormatFloat('#,##0', DMProduto.QryProduto.FieldByName('PROD_ESTOQUE').AsFloat);
      lblTitulo.Text    := 'Editar Produto';
    end;
  except on E:Exception do
    ShowMessage('Erro ao carregar dados do produto: ' + e.Message);

  end;
end;

procedure TfrmProdutoCad.imgFotoClick(Sender: TObject);
begin
  vMenu.fShowMenu;
end;

procedure TfrmProdutoCad.rectDescricaoClick(Sender: TObject);
begin
  FrmEdicaoPadrao.fEditar(lblDescricao,
                          TTipoCampo.Memo,
                          'Descrição do Produto',
                          'Informe a descrição do produto',
                          lblDescricao.Text,
                          True,
                          200
                          );
end;

procedure TfrmProdutoCad.rectEstoqueClick(Sender: TObject);
begin
  FrmEdicaoPadrao.fEditar(lblEstoque,
                          TTipoCampo.Inteiro,
                          'Quantidade em estoque',
                          '',
                          lblEstoque.Text,
                          True,
                          0
                          );
end;

procedure TfrmProdutoCad.rectValorClick(Sender: TObject);
begin
  FrmEdicaoPadrao.fEditar(lblValor,
                          TTipoCampo.Valor,
                          'Valor do Produto',
                          '',
                          lblValor.Text,
                          True,
                          0
                          );
end;

procedure TfrmProdutoCad.fClickBibliotecaFotos(Sender: TObject);
begin
  vMenu.fHideMenu;

  vPermissao.fPhotoLibrary(ActBibliotecaFotos, fErroPermissaoFotos)
end;

procedure TfrmProdutoCad.fClickTirarFoto(Sender: TObject);
begin
  vMenu.fHideMenu;

  vPermissao.fCamera(ActCamera, fErroPermissaoFotos);
end;

procedure TfrmProdutoCad.fErroPermissaoFotos(Sender: TObject);
begin
  ShowMessage('Você não possui acesso a esse recurso no aparelho');
end;

end.
