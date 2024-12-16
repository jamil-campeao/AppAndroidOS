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
    imgIconeCliente: TImage;
    imgIconeData: TImage;
    imgIconeSincronizar: TImage;
    procedure imgAbaDashBoardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure fAbrirAba(pImg: TImage);
    procedure fAdicionaPedidoListView(pOSLocal, pOSOficial, pCliente,
pDataOS, pIndSincronizar: String; pValor: Double);
    procedure fListarOS(pPagina: Integer; pBusca: String; pIndClear: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses DataModule.OS;

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

  fListarOS(0, '', True);
end;

procedure TfrmPrincipal.imgAbaDashBoardClick(Sender: TObject);
begin
  fAbrirAba(TImage(Sender));
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
begin
  DMOS.fListarOS(pPagina, pBusca);

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
end;



end.
