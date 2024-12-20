unit UnOSCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, UnPrincipal,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListBox, FMX.TabControl;

type
  TfrmOSCad = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSalvar: TSpeedButton;
    Image1: TImage;
    lytAbas: TLayout;
    rectAbaOS: TRectangle;
    rectAbaItem: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    TabControl1: TTabControl;
    tabOS: TTabItem;
    tabItem: TTabItem;
    ListBox1: TListBox;
    lbiCliente: TListBoxItem;
    Label3: TLabel;
    lblCliente: TLabel;
    Image4: TImage;
    Line1: TLine;
    lbiTipoOS: TListBoxItem;
    Label4: TLabel;
    lblTipoOS: TLabel;
    Line2: TLine;
    lbiData: TListBoxItem;
    Label5: TLabel;
    lblData: TLabel;
    Image5: TImage;
    Line3: TLine;
    lbiSolicitacao: TListBoxItem;
    Label6: TLabel;
    lblSolicitacao: TLabel;
    Image6: TImage;
    Line4: TLine;
    lbiOBS: TListBoxItem;
    Label8: TLabel;
    lblOBS: TLabel;
    Image7: TImage;
    Line5: TLine;
    lbiResponsavelVendedor: TListBoxItem;
    Label10: TLabel;
    lblResponsavelVendedor: TLabel;
    Image8: TImage;
    Line6: TLine;
    Layout1: TLayout;
    btExcluir: TSpeedButton;
    Image15: TImage;
    lbiEndereco: TListBoxItem;
    Label7: TLabel;
    lblEndereco: TLabel;
    Line7: TLine;
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOSCad: TfrmOSCad;

implementation

{$R *.fmx}

procedure TfrmOSCad.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOSCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action   := TCloseAction.caFree;
  FrmOSCad := nil;
end;

end.
