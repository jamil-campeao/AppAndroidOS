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
    edLogin: TEdit;
    btLogin: TSpeedButton;
    lvOS: TListView;
    btnAdicionarOS: TSpeedButton;
    Image1: TImage;
    btAdicionarCliente: TSpeedButton;
    Image2: TImage;
    lvNotificacao: TListView;
    Rectangle6: TRectangle;
    Edit1: TEdit;
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
    procedure imgAbaDashBoardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure fAbrirAba(pImg: TImage);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

procedure TfrmPrincipal.fAbrirAba(pImg: TImage);
begin
  imgAbaDashBoard.Opacity    := 0.5;
  imgAbaOS.Opacity           := 0.5;
  imgAbaCliente.Opacity      := 0.5;
  imgAbaNotificacao.Opacity  := 0.5;
  imgAbaMais.Opacity         := 0.5;

  pImg.Opacity := 1;

  TabControl.GotoVisibleTab(pImg.Tag);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  fAbrirAba(imgAbaDashBoard);
end;

procedure TfrmPrincipal.imgAbaDashBoardClick(Sender: TObject);
begin
  fAbrirAba(TImage(Sender));
end;

end.
