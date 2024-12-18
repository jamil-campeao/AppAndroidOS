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
  private
    vMenu      : TActionSheet;
    vPermissao : T99Permissions;
    procedure fClickBibliotecaFotos(Sender: TObject);
    procedure fClickTirarFoto(Sender: TObject);
    procedure fErroPermissaoFotos(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProdutoCad: TfrmProdutoCad;

implementation

{$R *.fmx}

uses UnPrincipal;

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

procedure TfrmProdutoCad.imgFotoClick(Sender: TObject);
begin
  vMenu.fShowMenu;
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
