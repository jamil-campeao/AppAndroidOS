unit UnSincronizacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, UnPrincipal, FMX.Layouts;

type
  TfrmSincronizacao = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSincronizar: TSpeedButton;
    lytSinc: TLayout;
    lblCliente: TLabel;
    lytCliente: TLayout;
    Image3: TImage;
    Label2: TLabel;
    Label3: TLabel;
    lytProduto: TLayout;
    Image1: TImage;
    lblProduto: TLabel;
    Label5: TLabel;
    lytOS: TLayout;
    Image4: TImage;
    lblOS: TLabel;
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSincronizacao: TfrmSincronizacao;

implementation

{$R *.fmx}

procedure TfrmSincronizacao.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSincronizacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action           := TCloseAction.caFree;
  frmSincronizacao := nil;
end;

end.
