unit UnProdutoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, uActionSheet;

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
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgFotoClick(Sender: TObject);
  private
    vMenu: TActionSheet;
    procedure fClickBibliotecaFotos(Sender: TObject);
    procedure fClickTirarFoto(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProdutoCad: TfrmProdutoCad;

implementation

{$R *.fmx}

uses UnPrincipal;

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
  vMenu := TActionSheet.Create(frmProdutoCad);

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
end;

procedure TfrmProdutoCad.imgFotoClick(Sender: TObject);
begin
  vMenu.fShowMenu;
end;

procedure TfrmProdutoCad.fClickBibliotecaFotos(Sender: TObject);
begin
  vMenu.fHideMenu;
end;

procedure TfrmProdutoCad.fClickTirarFoto(Sender: TObject);
begin
  vMenu.fHideMenu;
end;

end.
