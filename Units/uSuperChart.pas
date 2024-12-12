unit uSuperChart;

interface

uses FMX.Objects, FMX.Layouts, System.JSON, System.NetEncoding, System.SysUtils,
     FMX.Types, System.UITypes, FMX.Graphics, System.Classes, FMX.StdCtrls,
     Data.DB, System.Generics.Collections, System.Types;

type
    TPoints = Record
      pt: TPointF;
      vl: double;
      field: string;
end;

type
  TChartType = (HorizontalBar, VerticalBar, Lines);

type
  TSuperChart = class
  private
    Bar, BarBackground: TRectangle;
    Line: TLine;
    LineCircle: TCircle;
    LabelValue, LabelArg: TLabel;
    BarCount: Integer;
    MaxValue: double;
    CountComp: integer;
    Pontos: TList<TPoints>;
    spaceBetweenPoints: Integer;

    FLayout: TLayout;
    FChartType: TChartType;
    FShowValues: Boolean;
    FFontSizeValues: Integer;
    FFontColorValues: Cardinal;
    FBarColor: Cardinal;
    FBackgroundColor: Cardinal;
    FShowBackground: Boolean;
    FFormatValues: String;
    FFontSizeArgument: Integer;
    FFontColorArgument: Cardinal;
    FRoundedBotton: Boolean;
    FRoundedTop: Boolean;
    FLineColor: Cardinal;

    procedure AddBar(vl: double; field: string);
    procedure BarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure BarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure BarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure BarMouseLeave(Sender: TObject);
    procedure AddLine(vlFrom, vlTo: Double);
    procedure AddLinePoint(vl: double; field: string);
  public
    constructor Create(Layout: TLayout; ChartType: TChartType);
    procedure LoadFromJSON(jsonString: string; var error: string);
    procedure LoadFromDataset(ds: TDataSet; FieldValue, FieldArgument: string;
                              var error: string);
    procedure ClearChart;
    property ShowValues: Boolean read FShowValues write FShowValues;
    property FontSizeValues: Integer read FFontSizeValues write FFontSizeValues;
    property FontColorValues: Cardinal read FFontColorValues write FFontColorValues;
    property BarColor: Cardinal read FBarColor write FBarColor;
    property ShowBackground: Boolean read FShowBackground write FShowBackground;
    property BackgroundColor: Cardinal read FBackgroundColor write FBackgroundColor;
    property FormatValues: String read FFormatValues write FFormatValues;
    property FontSizeArgument: Integer read FFontSizeArgument write FFontSizeArgument;
    property FontColorArgument: Cardinal read FFontColorArgument write FFontColorArgument;
    property RoundedBotton: Boolean read FRoundedBotton write FRoundedBotton;
    property RoundedTop: Boolean read FRoundedTop write FRoundedTop;

    property LineColor: Cardinal read FLineColor write FLineColor;
end;


implementation

constructor TSuperChart.Create(Layout: TLayout; ChartType: TChartType);
begin
    CountComp := 0;
    FLayout := Layout;
    FChartType := ChartType;


    // Default values...
    FShowValues := true;
    FFontSizeValues := 12;
    FFontColorValues := $FF424242;
    FBarColor := $FF2A8FF7;
    FShowBackground := false;
    FBackgroundColor := $FFF3F3F3;
    FFormatValues := '';
    FFontSizeArgument := 12;
    FFontColorArgument := $FF424242;
    FRoundedBotton := false;
    FRoundedTop := false;

    FLineColor := $FF2A8FF7;


    ClearChart;
end;

procedure DrawLineBetweenPoints(L: TLine; p1, p2: TPointF);
begin
    L.LineType := TLineType.Diagonal;
    L.RotationCenter.X := 0.0;
    L.RotationCenter.Y := 0.0;

    if (p2.X >= p1.X) then
    begin
        // Line goes left to right, what about vertical?
        if (p2.Y > p1.Y) then begin
            // Case #1 - Line goes high to low, so NORMAL DIAGONAL
            L.RotationAngle := 0;
            L.Position.X := p1.X;
            L.Width := p2.X - p1.X;
            L.Position.Y := p1.Y;
            L.Height := p2.Y - p1.Y;
        end
        else
        begin
            // Case #2 - Line goes low to high, so REVERSE DIAGONAL
            // X and Y are now upper left corner and width and height reversed
            L.RotationAngle := -90;
            L.Position.X := p1.X;
            L.Width := p1.Y - p2.Y;
            L.Position.Y := p1.Y;
            L.Height := p2.X - p1.X;
        end;
    end
    else
    begin
        // Line goes right to left
        if (p1.Y > p2.Y) then
        begin
            // Case #3 - Line goes high to low (but reversed) so NORMAL DIAGONAL
            L.RotationAngle := 0;
            L.Position.X := p2.X;
            L.Width := p1.X - p2.X;
            L.Position.Y := p2.Y;
            L.Height := p1.Y - p2.Y;
        end
        else
        begin
            // Case #4 - Line goes low to high, REVERSE DIAGONAL
            // X and Y are now upper left corner and width and height reversed
            L.RotationAngle := -90;
            L.Position.X := p2.X;
            L.Width := p2.Y - p1.Y;
            L.Position.Y := p2.Y;
            L.Height := p1.X - p2.X;
        end;
    end;

    if (L.Height < 0.01) then
        L.Height := 0.1;
    if (L.Width < 0.01) then
        L.Width := 0.1;
end;

procedure TSuperChart.ClearChart;
var
    x : Integer;
begin
    // Destroy all componentes...
    for x := FLayout.ComponentCount - 1 downto 0 do
        FLayout.Components[x].DisposeOf;
end;

procedure TSuperChart.BarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    //
end;

procedure TSuperChart.BarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    //
end;

procedure TSuperChart.BarMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
var
    lbl : TLabel;
begin
    TRectangle(Sender).Opacity := 0.9;

    if TRectangle(Sender).Tag = 0 then
    begin
        // A tagstring da barra armazena o nome da label dos valores
        lbl := TRectangle(Sender).FindComponent(TRectangle(Sender).TagString) as TLabel;

        if lbl <> nil then
            lbl.Visible := true;
    end;
end;

procedure TSuperChart.BarMouseLeave(Sender: TObject);
var
    lbl : TLabel;
begin
    TRectangle(Sender).Opacity := 1;

    if TRectangle(Sender).Tag = 0 then
    begin
        lbl := TRectangle(Sender).FindComponent(TRectangle(Sender).TagString) as TLabel;

        if lbl <> nil then
            lbl.Visible := false;
    end;
end;

procedure TSuperChart.AddLine(vlFrom, vlTo: Double);
var
    ptFrom, ptTo: TPointF;
begin
    // Calculate bar proportion...
    if MaxValue > 0 then
    begin
        ptFrom.Y := (1 - (vlFrom / MaxValue)) * (FLayout.Height - 40);
        ptFrom.X := CountComp * spaceBetweenPoints;

        ptTo.Y := (1 - (vlTo / MaxValue)) * (FLayout.Height - 40);
        ptTo.X := (CountComp + 1) * spaceBetweenPoints;

        ptFrom.Y := ptFrom.Y + 10;
        ptTo.Y := ptTo.Y + 10;
    end
    else
    begin
        ptFrom.Y := FLayout.Height - 30;
        ptFrom.X := CountComp * spaceBetweenPoints;

        ptTo.Y := FLayout.Height - 30;
        ptTo.X := (CountComp + 1) * spaceBetweenPoints;
    end;

    Line := TLine.Create(FLayout);
    Line.Parent := FLayout;
    Line.Stroke.Kind := TBrushKind.Solid;
    Line.Stroke.Color := FLineColor;
    Line.Stroke.Thickness := 2;
    Line.Opacity := 0;

    Line.AnimateFloatDelay('Opacity', 1, 0.3, (CountComp * 0.15) + 0.2,
                           TAnimationType.InOut,
                           TInterpolationType.Circular);


    DrawLineBetweenPoints(Line, ptFrom, ptTo);
    inc(CountComp);

end;

procedure TSuperChart.AddLinePoint(vl: double; field: string);
var
    posY : double;
begin
    // Calculate posicao Y...
    if vl > 0 then
        posY := (1 - (vl / MaxValue)) * (FLayout.Height - 40)
    else
        posY := FLayout.Height - 40;


    posY := posY - 7 + 10;

    LineCircle := TCircle.Create(FLayout);
    LineCircle.Parent := FLayout;
    LineCircle.Stroke.Kind := TBrushKind.None;
    LineCircle.Fill.Kind := TBrushKind.Solid;
    LineCircle.Fill.Color := FLineColor;
    LineCircle.Width := 14;
    LineCircle.Height := 14;
    LineCircle.Position.X := CountComp * spaceBetweenPoints - Trunc(LineCircle.Width / 2);
    LineCircle.Position.Y := FLayout.Height - 35;


    LineCircle.AnimateFloat('Position.Y', posY, 0.5,
                            TAnimationType.InOut,
                            TInterpolationType.Circular);


    // Label values...
    LabelValue := TLabel.Create(LineCircle);
    LabelValue.Parent := LineCircle;

    if FFormatValues <> '' then
        LabelValue.Text := FormatFloat(FFormatValues, vl)
    else
        LabelValue.Text := vl.ToString;


    LabelValue.Align := TAlignLayout.Center;
    LabelValue.Margins.Bottom := 45;
    LabelValue.TextSettings.HorzAlign := TTextAlign.Center;


    LabelValue.StyledSettings := LabelValue.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
    LabelValue.Font.Size := FFontSizeValues;
    LabelValue.FontColor := FFontColorValues;
    LabelValue.Visible := ShowValues;
    LabelValue.Name := 'lblSuperChatValues_' + CountComp.ToString;



    // Label Arguments...
    LabelArg := TLabel.Create(FLayout);
    LabelArg.Parent := FLayout;
    LabelArg.Text := field;

    LabelArg.Width := spaceBetweenPoints;
    LabelArg.Position.X := (CountComp * spaceBetweenPoints - Trunc(LineCircle.Width / 2)) - Trunc(spaceBetweenPoints / 2) + 7;
    LabelArg.Position.Y := FLayout.Height - 25;
    LabelArg.Margins.Bottom := -20;
    LabelArg.TextSettings.HorzAlign := TTextAlign.Center;

    LabelArg.StyledSettings := LabelArg.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
    LabelArg.Font.Size := FFontSizeArgument;
    LabelArg.Height := 20;
    LabelArg.FontColor := FFontColorArgument;


    inc(CountComp);
end;

procedure TSuperChart.AddBar(vl: double; field: string);
var
    porc : double;
begin
    inc(CountComp);

    // Calculate bar proportion...
    if MaxValue > 0 then
        porc := vl / MaxValue
    else
        porc := 0;

    if porc = 0 then
        porc := 0.03;

    // Bar Background...
    BarBackground := TRectangle.Create(FLayout);
    BarBackground.Parent := FLayout;

    if FChartType = HorizontalBar then
    begin
        BarBackground.Align := TAlignLayout.Left;
        BarBackground.Margins.Bottom := 15;
        BarBackground.Margins.Left  := 5;
        BarBackground.Margins.Top   := 0;
        BarBackground.Margins.Right := 5;
        BarBackground.Height := FLayout.Height;
        BarBackground.Width := (FLayout.Width / BarCount) - 10;

        BarBackground.XRadius := Trunc(BarBackground.Width / 2);
        BarBackground.YRadius := BarBackground.XRadius;

        if (FRoundedBotton and FRoundedTop) then
            BarBackground.Corners := [TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight]
        else if (FRoundedBotton) then
            BarBackground.Corners := [TCorner.BottomLeft, TCorner.BottomRight]
        else if (FRoundedTop) then
            BarBackground.Corners := [TCorner.TopLeft, TCorner.TopRight];
    end;

    if FChartType = VerticalBar then
    begin
        BarBackground.Align := TAlignLayout.Top;
        BarBackground.Margins.Bottom := 5;
        BarBackground.Margins.Left  := 40;
        BarBackground.Margins.Top   := 5;
        BarBackground.Margins.Right := 0;
        BarBackground.width := FLayout.Width;
        BarBackground.Height := (FLayout.Height / BarCount) - 10;

        BarBackground.XRadius := Trunc(BarBackground.Height / 2);
        BarBackground.YRadius := BarBackground.XRadius;

        if (FRoundedBotton and FRoundedTop) then
            BarBackground.Corners := [TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight]
        else if (FRoundedBotton) then
            BarBackground.Corners := [TCorner.TopLeft, TCorner.BottomLeft]
        else if (FRoundedTop) then
            BarBackground.Corners := [TCorner.TopRight, TCorner.BottomRight];
    end;

    BarBackground.Size.PlatformDefault := False;

    if ShowBackground then
    begin
        BarBackground.Fill.Kind := TBrushKind.Solid;
        BarBackground.Fill.Color := FBackgroundColor;
    end
    else
        BarBackground.Fill.Kind := TBrushKind.None;


    BarBackground.Stroke.Kind := TBrushKind.None;


    // Bar...
    Bar := TRectangle.Create(BarBackground);
    Bar.Parent := BarBackground;

    Bar.Corners := [];

    if FChartType = HorizontalBar then
    begin
        Bar.XRadius := Trunc(BarBackground.Width / 2);
        Bar.YRadius := Bar.XRadius;
        Bar.Align := TAlignLayout.Bottom;

        if (FRoundedBotton and FRoundedTop) then
            Bar.Corners := [TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight]
        else if (FRoundedBotton) then
            Bar.Corners := [TCorner.BottomLeft, TCorner.BottomRight]
        else if (FRoundedTop) then
            Bar.Corners := [TCorner.TopLeft, TCorner.TopRight];
    end
    else if FChartType = VerticalBar then
    begin
        Bar.XRadius := Trunc(BarBackground.Height / 2);
        Bar.YRadius := Bar.XRadius;
        Bar.Align := TAlignLayout.Left;

        if (FRoundedBotton and FRoundedTop) then
            Bar.Corners := [TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight]
        else if (FRoundedBotton) then
            Bar.Corners := [TCorner.TopLeft, TCorner.BottomLeft]
        else if (FRoundedTop) then
            Bar.Corners := [TCorner.TopRight, TCorner.BottomRight];
    end;



    Bar.Fill.Kind := TBrushKind.Solid;
    Bar.Fill.Color := FBarColor;
    Bar.Height := 0;
    Bar.Stroke.Kind := TBrushKind.None;
    Bar.Hint := field;
    Bar.ShowHint := True;
    Bar.TagFloat := porc;
    //Bar.OnMouseDown := BarMouseDown;
    //Bar.OnMouseUp := BarMouseUp;
    //Bar.OnMouseMove := BarMouseMove;
    //Bar.OnMouseLeave := BarMouseLeave;
    Bar.Tag := FShowValues.ToInteger;
    Bar.HitTest := true;

    Bar.Name := FLayout.Name + 'SuperChatValues_' + CountComp.ToString;

    if FChartType = HorizontalBar then
        Bar.AnimateFloat('Height',
                         Trunc(BarBackground.Height * porc),
                         0.7,
                         TAnimationType.InOut,
                         TInterpolationType.Cubic)
    else if FChartType = VerticalBar then
        Bar.AnimateFloat('Width',
                         Trunc(BarBackground.Width * porc),
                         0.7,
                         TAnimationType.InOut,
                         TInterpolationType.Cubic);

    if porc <= 0.03 then
        Bar.Fill.Color := BarBackground.Fill.Color;

    // Label values...
    LabelValue := TLabel.Create(Bar);
    LabelValue.Parent := Bar;

    if FFormatValues <> '' then
        LabelValue.Text := FormatFloat(FFormatValues, vl)
    else
        LabelValue.Text := vl.ToString;

    if FChartType = HorizontalBar then
    begin
        LabelValue.Align := TAlignLayout.Top;
        LabelValue.Margins.Top := -20;
        LabelValue.Margins.Left := -30;
        LabelValue.Margins.Right := -30;
        LabelValue.TextSettings.HorzAlign := TTextAlign.Center;
    end
    else if FChartType = VerticalBar then
    begin
        LabelValue.Width := 100;
        LabelValue.Align := TAlignLayout.Right;

        if porc < 0.8 then
        begin
            LabelValue.Margins.Right := -110;
            LabelValue.TextSettings.HorzAlign := TTextAlign.Leading;
        end
        else
        begin
            LabelValue.Margins.Right := 10;
            LabelValue.TextSettings.HorzAlign := TTextAlign.Trailing;
        end;
    end;


    LabelValue.StyledSettings := LabelValue.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
    LabelValue.Font.Size := FFontSizeValues;
    LabelValue.FontColor := FFontColorValues;
    LabelValue.Visible := ShowValues;
    LabelValue.Name := FLayout.Name + 'lblSuperChatValues_' + CountComp.ToString;


    Bar.TagString := LabelValue.Name;



    // Label Arguments...
    LabelArg := TLabel.Create(Bar);
    LabelArg.Parent := Bar;
    LabelArg.Text := field;

    if FChartType = HorizontalBar then
    begin
        LabelArg.Align := TAlignLayout.Bottom;
        LabelArg.Margins.Bottom := -20;
        LabelArg.TextSettings.HorzAlign := TTextAlign.Center;
    end
    else if FChartType = VerticalBar then
    begin
        LabelArg.Align := TAlignLayout.Left;
        LabelArg.Margins.Left := -40;
        LabelArg.TextSettings.HorzAlign := TTextAlign.Leading;
    end;


    LabelArg.StyledSettings := LabelArg.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
    LabelArg.Font.Size := FFontSizeArgument;
    LabelArg.Height := 20;
    LabelArg.FontColor := FFontColorArgument;
end;

procedure TSuperChart.LoadFromJSON(jsonString: string; var error: string);
var
    jsonArray: TJsonArray;
    x : integer;
    p: TPoints;
begin
    error := '';
    ClearChart;

    try
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(jsonString), 0) as TJSONArray;
    except
        error := 'Invalid JSON array';
        exit;
    end;


    if jsonArray = nil then
    begin
        error := 'Invalid JSON array';
        exit;
    end;


    BarCount := jsonArray.Size;
    MaxValue := 0;

    for x := jsonArray.Size - 1 downto 0 do
        if MaxValue < jsonArray.Get(x).GetValue<double>('valor') then
            MaxValue := jsonArray.Get(x).GetValue<double>('valor');

    MaxValue := MaxValue * 1.1;

    if (FChartType = HorizontalBar) or (FChartType = VerticalBar) then
    begin
        for x := jsonArray.Size - 1 downto 0 do
        begin
            AddBar(jsonArray.Get(x).GetValue<double>('valor'),
                   jsonArray.Get(x).GetValue<string>('field'));
        end;
    end
    else if (FChartType = Lines) then
    begin
        pontos := TList<TPoints>.Create;
        CountComp := 0;
        spaceBetweenPoints := Trunc(FLayout.Width / (BarCount - 1));

        for x := 0 to jsonArray.Size - 2 do
            AddLine(jsonArray.Get(x).GetValue<double>('valor'),
                    jsonArray.Get(x+1).GetValue<double>('valor'));


        CountComp := 0;
        for x := 0 to jsonArray.Size - 1 do
            AddLinePoint(jsonArray.Get(x).GetValue<double>('valor'),
                         jsonArray.Get(x).GetValue<string>('field'));

        pontos.DisposeOf;
    end;

    jsonArray.DisposeOf;
end;

procedure TSuperChart.LoadFromDataset(ds: TDataSet; FieldValue, FieldArgument : string;
                                      var error: string);
var
    x: integer;
    p1, p2: double;
begin
    error := '';
    ClearChart;

    if NOT ds.Active then
    begin
        error := 'Dataset is empty';
        exit;
    end;


    BarCount := ds.RecordCount;

    MaxValue := 0;
    ds.First;
    while NOT ds.Eof do
    begin
        if MaxValue < ds.FieldByName(FieldValue).AsFloat then
            MaxValue := ds.FieldByName(FieldValue).AsFloat;

        ds.next;
    end;

    MaxValue := MaxValue * 1.1;

    //---------------

    if (FChartType = HorizontalBar) or (FChartType = VerticalBar) then
    begin
        ds.Last;
        while NOT ds.Bof do
        begin
            AddBar(ds.FieldByName(FieldValue).AsFloat,
                   ds.FieldByName(FieldArgument).AsString);

            ds.Prior;
        end;
    end
    else if (FChartType = Lines) then
    begin
        pontos := TList<TPoints>.Create;
        CountComp := 0;
        spaceBetweenPoints := Trunc(FLayout.Width / (BarCount - 1));

        ds.First;
        for x := 0 to ds.RecordCount - 2 do
        begin
            p1 := ds.FieldByName(FieldValue).AsFloat;
            ds.Next;
            p2 := ds.FieldByName(FieldValue).AsFloat;
            ds.Prior;

            AddLine(p1, p2);

            ds.Next;
        end;

        CountComp := 0;
        ds.First;
        while NOT ds.Eof do
        begin
            AddLinePoint(ds.FieldByName(FieldValue).AsFloat,
                         ds.FieldByName(FieldArgument).AsString);

            ds.Next;
        end;

        pontos.DisposeOf;
    end;

    FLayout.Repaint;


end;


end.
