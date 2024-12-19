unit UnCidade;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  uFancyDialog, uFunctions, UnClienteCad;

type
  TfrmCidade = class(TForm)
    StyleBook1: TStyleBook;
    Rectangle3: TRectangle;
    Label3: TLabel;
    Rectangle6: TRectangle;
    edBuscaCidade: TEdit;
    btBuscaCidade: TSpeedButton;
    lvCidade: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvCidadePaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lvCidadeUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btBuscaCidadeClick(Sender: TObject);
    procedure lvCidadeItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    vFancy : TFancyDialog;
    procedure fListarCidades(pPagina: Integer; pBusca: String;
      pIndClear: Boolean);
    procedure fThreadCidadesTerminate(Sender: TObject);
    procedure fAdicionaCidadeListView(pCodCidade, pNome, pUF, pCEP: String);
    procedure fLayoutListViewCidade(pAItem: TListViewItem);
    { Private declarations }
  public

    { Public declarations }
  end;

var
  frmCidade: TfrmCidade;

implementation

{$R *.fmx}

uses DataModule.Cidade, uConstantes;

procedure TfrmCidade.fListarCidades(pPagina: Integer; pBusca: String; pIndClear: Boolean);
var
  vThread: TThread;
begin
//  imgSemCliente.Visible := False;

  //Evito processamento concorrente
  if lvCidade.TagString = 'S' then
    exit;

  // Em processamento..
  lvCidade.TagString := 'S';

  lvCidade.BeginUpdate;

  //limpo a lista
  if pIndClear then
  begin
    pPagina := 1;
    lvCidade.ScrollTo(0);
    lvCidade.Items.Clear;
  end;

  {
    Tag: contém a página atual solicitada ao servidor
    Quando a Tag for >= 1: faz o request para buscar mais dados
                      -1 : Indica que não tem mais dados
  }

  //Salvo a página atual a ser exibida
  lvCidade.Tag := pPagina;

  //Faço a requisição por mais dados
  vThread := TThread.CreateAnonymousThread(procedure
  begin
    DMCidade.fListarCidades(pPagina, pBusca);
  end);

  vThread.OnTerminate := fThreadCidadesTerminate;
  vThread.Start;

end;

procedure TfrmCidade.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action     := TCloseAction.caFree;
  FrmCidade  := nil;
end;

procedure TfrmCidade.FormCreate(Sender: TObject);
begin
  vFancy := TFancyDialog.Create(frmCidade);
end;

procedure TfrmCidade.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
end;

procedure TfrmCidade.fThreadCidadesTerminate(Sender: TObject);
begin
  // Não carregar mais dados..
  if DMCidade.QryConsCidade.RecordCount < cQTD_REG_PAGINA_CIDADE then
    lvCidade.Tag := -1;

  while not DMCidade.QryConsCidade.Eof do
  begin
    fAdicionaCidadeListView(DMCidade.QryConsCidade.FieldByName('CID_CODIGO').AsString,
                            DMCidade.QryConsCidade.FieldByName('CID_NOME').AsString,
                            DMCidade.QryConsCidade.FieldByName('CID_UF').AsString,
                            DMCidade.QryConsCidade.FieldByName('CID_CEP').AsString
                            );

    DMCidade.QryConsCidade.Next;

  end;

  lvCidade.EndUpdate;

  // Marco que o processo terminou
  lvCidade.TagString := '';

  //Verifico se a tela esta vazia, se estiver, ele habilita a imagem de tela vazia
//  imgSemCliente.Visible := lvCidade.ItemCount = 0;

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

procedure TfrmCidade.lvCidadeItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  DMCidade.fListarCidadeID(AItem.TagString.ToInteger);

  if not DMCidade.QryConsCidade.IsEmpty then
  begin
    frmClienteCad.Cod_Cidade  := DMCidade.QryConsCidade.FieldByName('CID_CODIGO').AsInteger;
    frmClienteCad.Nome_Cidade := DMCidade.QryConsCidade.FieldByName('CID_NOME').AsString;
    frmClienteCad.UF          := DMCidade.QryConsCidade.FieldByName('CID_UF').AsString;
    frmClienteCad.CEP         := DMCidade.QryConsCidade.FieldByName('CID_CEP').AsString;
  end;

  Close;
end;

procedure TfrmCidade.lvCidadePaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  //Verifico se a rolagem atingiu o limite para uma nova carga de registros
  if (lvCidade.Items.Count >= cQTD_REG_PAGINA_CIDADE) and
  (lvCidade.Tag >= 0) then
    if lvCidade.GetItemRect(lvCidade.Items.Count - 5).Bottom <= lvCidade.Height then
      fListarCidades(lvCidade.Tag + 1, Trim(edBuscaCidade.Text), False);
end;

procedure TfrmCidade.lvCidadeUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  fLayoutListViewCidade(AItem);
end;

procedure TfrmCidade.btBuscaCidadeClick(Sender: TObject);
begin
  fListarCidades(1, Trim(edBuscaCidade.Text), True);
end;

procedure TfrmCidade.fAdicionaCidadeListView(pCodCidade, pNome, pUF, pCEP: String);
var
  vItem: TListViewItem;
  vTxt : TListItemText;
begin
  try
    vItem := lvCidade.Items.Add;
    vItem.Height := 60;

    vItem.TagString := pCodCidade;

    //Nome Cidade
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtCidadeUf'));
    vTxt.Text := pNome;

    if pUF <> '' then
      vTxt.Text := vTxt.Text + ' - ' + pUF;

    //CEP
    vTxt := TListItemText(vItem.Objects.FindDrawable('txtCep'));
    vTxt.Text := 'CEP: ';
    vTxt.Text := vTxt.Text + pCEP;

    fLayoutListViewCidade(vItem);

  except on e:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao inserir cliente na lista: ' + e.Message, 'OK');
  end;

end;

procedure TfrmCidade.fLayoutListViewCidade(pAItem: TListViewItem);
var
  vTxt: TListItemText;
begin
  vTxt          := TListItemText(pAItem.Objects.FindDrawable('txtCidadeUf'));
  vTxt.Width    := lvCidade.Width - 100;
  vTxt.Height   := fGetTextHeight(vTxt, vTxt.Width, vTxt.Text) + 5;

  pAItem.Height := Trunc(vTxt.PlaceOffset.Y + vTxt.Height);

end;





end.
