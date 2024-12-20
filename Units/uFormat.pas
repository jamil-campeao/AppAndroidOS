/////////////////////////////////////////////////////////////////////////////
{
    Unit Format
    Criação: 99 Coders (Heber Stein Mazutti - heber@99coders.com.br)
    Versão: 1.4
}
/////////////////////////////////////////////////////////////////////////////

unit uFormat;

interface

uses System.SysUtils, FMX.Edit, Classes, System.MaskUtils, FMX.StdCtrls;

type
    TFormato = (CNPJ, CPF, InscricaoEstadual, CNPJorCPF, TelefoneFixo, Celular, Personalizado,
                Valor, Money, CEP, Dt, Peso);

procedure fFormatar(Obj: TObject; Formato : TFormato; Extra : string = '');
function fSomenteNumero(str : string) : string;

implementation

function fSomenteNumero(str : string) : string;
var
    x : integer;
begin
    Result := '';
    for x := 0 to Length(str) - 1 do
        if (str.Chars[x] In ['0'..'9']) then
            Result := Result + str.Chars[x];
end;

function fFormataValor(str : string) : string;
begin
    if Str = '' then
        Str := '0';

    try
        Result := FormatFloat('#,##0.00', strtofloat(str) / 100);
    except
        Result := FormatFloat('#,##0.00', 0);
    end;
end;

function fFormataPeso(str : string) : string;
begin
    if Str.IsEmpty then
        Str := '0';

    try
        Result := FormatFloat('#,##0.000', strtofloat(str) / 1000);
    except
        Result := FormatFloat('#,##0.000', 0);
    end;
end;

function fMask(Mascara, Str : string) : string;
var
    x, p : integer;
begin
    p := 0;
    Result := '';

    if Str.IsEmpty then
        exit;

    for x := 0 to Length(Mascara) - 1 do
    begin
        if Mascara.Chars[x] = '#' then
        begin
            Result := Result + Str.Chars[p];
            inc(p);
        end
        else
            Result := Result + Mascara.Chars[x];

        if p = Length(Str) then
            break;
    end;
end;

function fFormataIE(Num, UF: string): string;
var
    Mascara : string;
begin
    Mascara := '';
    IF UF = 'AC' Then Mascara := '##.###.###/###-##';
    IF UF = 'AL' Then Mascara := '#########';
    IF UF = 'AP' Then Mascara := '#########';
    IF UF = 'AM' Then Mascara := '##.###.###-#';
    IF UF = 'BA' Then Mascara := '######-##';
    IF UF = 'CE' Then Mascara := '########-#';
    IF UF = 'DF' Then Mascara := '###########-##';
    IF UF = 'ES' Then Mascara := '#########';
    IF UF = 'GO' Then Mascara := '##.###.###-#';
    IF UF = 'MA' Then Mascara := '#########';
    IF UF = 'MT' Then Mascara := '##########-#';
    IF UF = 'MS' Then Mascara := '#########';
    IF UF = 'MG' Then Mascara := '###.###.###/####';
    IF UF = 'PA' Then Mascara := '##-######-#';
    IF UF = 'PB' Then Mascara := '########-#';
    IF UF = 'PR' Then Mascara := '########-##';
    IF UF = 'PE' Then Mascara := '##.#.###.#######-#';
    IF UF = 'PI' Then Mascara := '#########';
    IF UF = 'RJ' Then Mascara := '##.###.##-#';
    IF UF = 'RN' Then Mascara := '##.###.###-#';
    IF UF = 'RS' Then Mascara := '###/#######';
    IF UF = 'RO' Then Mascara := '###.#####-#';
    IF UF = 'RR' Then Mascara := '########-#';
    IF UF = 'SC' Then Mascara := '###.###.###';
    IF UF = 'SP' Then Mascara := '###.###.###.###';
    IF UF = 'SE' Then Mascara := '#########-#';
    IF UF = 'TO' Then Mascara := '###########';

    Result := fMask(mascara, Num);
end;

function fFormataData(str : string): string;
begin
    str := Copy(str, 1, 8);

    if Length(str) < 8 then
        Result := fMask('##/##/####', str)
    else
    begin
        try
            str := fMask('##/##/####', str);
            strtodate(str);
            Result := str;
        except
            Result := '';
        end;
    end;
end;

procedure fFormatar(Obj: TObject; Formato : TFormato; Extra : string = '');
var
    texto : string;
begin
    TThread.Queue(Nil, procedure
    begin
        if obj is TEdit then
            texto := TEdit(obj).Text
        else if obj is TLabel then
            texto := TLabel(obj).Text;

        // Telefone Fixo...
        if formato = TelefoneFixo then
            texto := fMask('(##) ####-####', fSomenteNumero(texto));

        // Celular...
        if formato = Celular then
            texto := fMask('(##) #####-####', fSomenteNumero(texto));

        // CNPJ...
        if formato = CNPJ then
            texto := fMask('##.###.###/####-##', fSomenteNumero(texto));

        // CPF...
        if formato = CPF then
            texto := fMask('###.###.###-##', fSomenteNumero(texto));

        // Inscricao Estadual (IE)...
        if formato = InscricaoEstadual then
            texto := fFormataIE(fSomenteNumero(texto), Extra);

        // CNPJ ou CPF...
        if formato = CNPJorCPF then
            if Length(fSomenteNumero(texto)) <= 11 then
                texto := fMask('###.###.###-##', fSomenteNumero(texto))
            else
                texto := fMask('##.###.###/####-##', fSomenteNumero(texto));

        // Personalizado...
        if formato = Personalizado then
            texto := fMask(Extra, fSomenteNumero(texto));

        // Valor...
        if Formato = Valor then
            texto := fFormataValor(fSomenteNumero(texto));

        // Money (com simbolo da moeda)...
        if Formato = Money then
        begin
            if Extra = '' then
                Extra := 'R$';

            texto := Extra + ' ' + fFormataValor(fSomenteNumero(texto));
        end;

        // CEP...
        if Formato = CEP then
            texto := fMask('##.###-###', fSomenteNumero(texto));

        // Data...
        if formato = Dt then
            texto := fFormataData(fSomenteNumero(texto));

        // Peso...
        if Formato = Peso then
            texto := fFormataPeso(fSomenteNumero(texto));


        if obj is TEdit then
        begin
            TEdit(obj).Text := texto;
            TEdit(obj).CaretPosition := TEdit(obj).Text.Length;
        end
		else if obj is TLabel then
            TLabel(obj).Text := texto;



    end);

end;

end.
