unit UnProdutoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts;

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
  private
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

end.
