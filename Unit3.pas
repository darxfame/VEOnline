unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, ExtCtrls, TeeProcs, Chart, StdCtrls, unit1, unit4, Series,
  SDL_plot3d,SDL_sdlbase,SDL_math2, SDL_filesys, SDL_matrix, SDL_NumLab;

type
  TForm3 = class(TForm)
    Chart1: TChart;
    rash1: TScrollBar;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Series1: TLineSeries;
    CheckBox1: TCheckBox;
    Help: TButton;
    CheckBox2: TCheckBox;
    NLabMag: TNumLab;
    ScrBarMagnif: TScrollBar;
    datab: TButton;
    Panel1: TPanel;
    Button5: TButton;
    Button4: TButton;
    Button3: TButton;
    Label3: TLabel;
    Panel2: TPanel;
    Label4: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Series2: TLineSeries;
    Plot3D1: TPlot3D;
    procedure rash1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Chart1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HelpClick(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Plot3D1BeforeRenderPolygon(Sender: TObject; Canvas: TCanvas;
      var Handled: Boolean; CellX, CellY: Integer; quad: TQuad;
      var color: TColor);
      procedure ScrBarMagnifChange(Sender: TObject);
    procedure databClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  mouse:string;
  mint:integer;
  hiy:integer;
  loy:integer;
  mins, maxs : array[1..3] of double;
  databuf: array[0..16,0..16] of string;    //����� ��� ������ ���������
 const
  HoleXLow = 16;
  HoleXHigh = 16;
  HoleYLow = 17;
  HoleYHigh = 17;
 type
 tSmoothLevel = (Smooth3, Smooth5, Smooth7);
 taSmooth = array [0..1023] of Double;
implementation

{$R *.dfm}

function HexToStr(hex: string): string;
var
  i: Integer;
begin
  hex:= StringReplace(hex, ' ', '', [rfReplaceAll]);
  for i:= 1 to Length(hex) div 2 do
    Result:= Result + Char(StrToInt('$' + Copy(hex, (i-1) * 2 + 1, 2)));
end;

(******************************************************************************)
Function Smooth (MaxI: SmallInt; Level: tSmoothLevel; Yi: taSmooth): taSmooth;
var i: SmallInt;
   Smoo: taSmooth;
begin
 Case Level of
   Smooth3 : begin
 for i:=0 to MaxI-1 do begin
   If i = 0 then Smoo[i] := (5*Yi[i] + 2*Yi[i+1] - Yi[i+2]) / 6
   else if i = MaxI-1 then Smoo[i] := (5*Yi[i] + 2*Yi[i-1] - Yi[i-2]) / 6
   else  Smoo[i] := (Yi[i] + Yi[i-1] + Yi[i+1]) / 3;
 end;
      end;
   Smooth5 : begin
 for i:=0 to MaxI-1 do begin
   If i = 0 then
     Smoo[i] := (3*Yi[i] + 2*Yi[i+1] + Yi[i+2] - Yi[i+4]) / 5
   else If i = MaxI-1 then
     Smoo[i] := (3*Yi[i] + 2*Yi[i-1] + Yi[i-2] - Yi[i-4]) / 5
   else if i = 1 then
     Smoo[i] := (4*Yi[i-1] + 3*Yi[i] + 2*Yi[i+1] + Yi[i+2]) / 10
   else if i = MaxI-2 then
     Smoo[i] := (4*Yi[i+1] + 3*Yi[i] + 2*Yi[i-1] + Yi[i-2]) / 10
   else Smoo[i] := (Yi[i-2] + Yi[i-1] + Yi[i] + Yi[i+1] + Yi[i+2]) / 5;
 end;
      end;
   Smooth7 : begin
 for i:=0 to MaxI-1 do begin
   If i = 0 then Smoo[i] :=
     (39*Yi[i] + 8*Yi[i+1] - 4*(Yi[i+2] + Yi[i+3] - Yi[i+4]) + Yi[i+5] - 2*Yi[i+6]) / 42
   else if i = MaxI-1 then Smoo[i] :=
     (39*Yi[i] + 8*Yi[i-1] - 4*(Yi[i-2] + Yi[i-3] - Yi[i-4]) + Yi[i-5] - 2*Yi[i-6]) / 42
   else if i = 1 then Smoo[i] :=
     ( 8*Yi[i-1] + 19*Yi[i] + 16*Yi[i+1] + 6*Yi[i+2] - 4*Yi[i+3] - 7*Yi[i+4] + 4*Yi[i+5]) / 42
   else if i = MaxI-2 then Smoo[i] :=
     ( 8*Yi[i+1] + 19*Yi[i] + 16*Yi[i-1] + 6*Yi[i-2] - 4*Yi[i-3] - 7*Yi[i-4] + 4*Yi[i-5]) / 42
   else if i = 2 then Smoo[i] :=
     (-4*Yi[i-2] + 16* Yi[i-1] + 19*Yi[i] + 12*Yi[i+1] + 2*Yi[i+2] - 4*Yi[i+3] + Yi[i+4]) / 42
   else if i = MaxI-3 then Smoo[i] :=
     (-4*Yi[i+2] + 16* Yi[i+1] + 19*Yi[i] + 12*Yi[i-1] + 2*Yi[i-2] - 4*Yi[i-3] + Yi[i-4]) / 42
   else Smoo[i] :=
     ( 7*Yi[i] + 6*(Yi[i+1] + Yi[i-1]) + 3*(Yi[i-2] + Yi[i+2]) - 2*(Yi[i-3] + Yi[i+3])) / 21;
   end;
      end;
 end;
 Result := Smoo;
end;

(******************************************************************************)
procedure TForm3.databClick(Sender: TObject);
var i,j:integer; znac:string; zn:real;
begin
for i:= 2 to form1.stringGrid2.Rowcount do
   for j := 2 to form1.stringGrid2.colcount do begin
 zn:=strtofloat(form1.stringGrid2.Cells[j-1,i-1]);
 znac:=floattostrf(zn,fffixed,3,2);
  databuf[j-2,i-2]:=znac;
end;
end;

procedure TForm3.Button1Click(Sender: TObject);
var i,j,e,l,rcout,s:integer; x,y,z:real;
begin
Plot3D1.Gridmat.Fill(0);
rcout:=form1.stringGrid2.rowcount;
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//

Plot3D1.GridMat.Resize(rcout,rcout);
Plot3D1.SetRange (1, 16, loy, hiy, 0, 1.4);
Plot3D1.CaptionX:='�������';
Plot3D1.CaptionY:='�������';
Plot3D1.CaptionZ:='����������';
e:=1;
while e<form1.StringGrid2.ColCount do
  for j := 1 to form1.StringGrid2.RowCount-1 do
  begin
  FormatSettings.DecimalSeparator := '.';
  z:=strtofloat(form1.StringGrid2.Cells[e,j]);
  x:=strtofloat(form1.StringGrid2.Cells[0,j]);
   Plot3D1.GridMat.Elem[e,j] := z;
  if j=form1.StringGrid2.RowCount-1 then inc(e);
    end;

Plot3D1.ColorLow := clFuchsia;
Plot3D1.ColorHigh := clBlue;
Plot3D1.ColorScaleHigh := 1;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//

for i:=1 to form1.StringGrid2.ColCount-1 do
     begin
       if checkbox1.Checked=false then
       begin
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        with Chart1 do
  begin
Label1.Caption:='������:';
Label2.Caption:=inttostr(rash1.Position);
label2.left:=107;
rash1.Min:=1;
rash1.Max:=16;
//���� ���������� ������ ������  min X , max Y,   min Y , max Y
      BottomAxis.Automatic:= True;
      LeftAxis.Automatic := False;
      LeftAxis.Increment := 1;
      LeftAxis.Maximum := 2;
      LeftAxis.Minimum := 0;

   UndoZoom;//�������������� �������� �������
   Title.Text.Clear;
   Title.Text.Add('������ '+inttostr(form3.rash1.Position));//GRAPHIC
   LeftAxis.AxisValuesFormat := '0.##';//
   BottomAxis.Title.Caption  := '�������';//����������� X
   LeftAxis.Title.Caption    := '��������';//����������� Y
   Repaint;
  end;

 with Chart1 do
  begin
  Series1.Clear;
///������ �����
 (Series1 as TLineSeries).LinePen.Width:=2;//�������
 Series1.XValues.Order:= LoNone;               //����� ����������� ����� ��� ��� �� ������!!!
 Series1.Marks.Visible:= True;
 Series1.Marks.Style:=smsValue;
 x:=0;
 y:=0;
for j := 1 to form1.StringGrid2.RowCount-1 do
  begin
  FormatSettings.DecimalSeparator := '.';
  y:=strtofloat(form1.StringGrid2.Cells[rash1.Position,j]);
  x:=j;
   Series1.AddXY(x,y, form1.StringGrid2.Cells[0,j],clRed);
    end;
Series1.Title := ''; //
 Series1.Active := True;
  end;

  with Chart1 do
  begin
  Series2.Clear;
///������ �����
 (Series2 as TLineSeries).LinePen.Width:=2;//�������
 Series2.XValues.Order:= LoNone;               //����� ����������� ����� ��� ��� �� ������!!!
 Series2.Marks.Visible:= False;
 Series2.Marks.Style:=smsValue;
 x:=0;
 y:=0;
for j := 1 to form1.StringGrid2.RowCount-1 do
  begin
  FormatSettings.DecimalSeparator := '.';
  y:=strtofloat(databuf[rash1.Position-1,j-1]);
  x:=j;
   Series2.AddXY(x,y, form1.StringGrid2.Cells[0,j],clAqua);
    end;
Series2.Title := ''; //
 Series2.Active := True;
  end;

       end
      else
     begin
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        with Chart1 do
  begin
 if rcout=15 then  rash1.max:=14;
if rcout=17 then  rash1.max:=16;
Label1.Caption:='�������:';
label2.left:=104;
case rash1.Position of
  1:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  2:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  3:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  4:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  5:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  6:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  7:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  8:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  9:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  10:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  11:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  12:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  13:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  14:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  15:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
  16:Label2.Caption:=form1.StringGrid2.Cells[0,rash1.Position];
end;
rash1.Min:=1;
rash1.Max:=rcout-1;
//���� ���������� ������ ������  min X , max Y,   min Y , max Y
      BottomAxis.Automatic:= True;
      BottomAxis.Minimum := 1;
      BottomAxis.Maximum := 16;
      LeftAxis.Automatic := False;
      LeftAxis.Maximum := 2;
      LeftAxis.Minimum := 0;

   UndoZoom;//�������������� �������� �������
   Title.Text.Clear;
   Title.Text.Add('������� '+Label2.Caption);//GRAPHIC
   LeftAxis.AxisValuesFormat := '0.##';//
   BottomAxis.Title.Caption  := '������';//����������� X
   LeftAxis.Title.Caption    := '��������';//����������� Y
   Repaint;
  end;
 with form3.Chart1 do
  begin
  Series1.Clear;
  //legend.Visible:=false;
///������ �����
// Series1:=TFastLineSeries.Create(Chart1); //��� FastLine
 //Series1.ParentChart := Chart1;             //���������� ������������� �������
 (Series1 as TLineSeries).LinePen.Width:=2;//�������
 Series1.XValues.Order:= LoNone;               //����� ����������� ����� ��� ��� �� ������!!!
 Series1.Marks.Visible:= True;
 Series1.Marks.Style:=smsValue;
 x:=0;
 y:=0;
for j := 1 to form1.StringGrid2.ColCount-1 do
  begin
  FormatSettings.DecimalSeparator := '.';
  y:=strtofloat(form1.StringGrid2.Cells[j,rash1.Position]);
  x:=j;
   Series1.AddXY(x,y, form1.StringGrid2.Cells[0,j],clRed);
    end;
Series1.Title := ''; //
 Series1.Active := True;
  end;

    with form3.Chart1 do
  begin
  Series2.Clear;
  //legend.Visible:=True;
///������ �����
 (Series2 as TLineSeries).LinePen.Width:=2;//�������
 Series2.XValues.Order:= LoNone;               //����� ����������� ����� ��� ��� �� ������!!!
 Series2.Marks.Visible:= False;
 Series2.Marks.Style:=smsValue;
 x:=0;
 y:=0;
for j := 1 to form1.StringGrid2.RowCount-1 do
  begin
  FormatSettings.DecimalSeparator := '.';
  y:=strtofloat(databuf[j-1,rash1.Position-1]);
  x:=j;
   Series2.AddXY(x,y, form1.StringGrid2.Cells[0,j],clAqua);
    end;
Series2.Title := ''; //
 Series2.Active := True;
  end;
     end;
     end;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
end;
 (******************************************************************************)

procedure TForm3.Button2Click(Sender: TObject);
begin
form3.Visible:=false;
end;
 (******************************************************************************)
procedure TForm3.Button3Click(Sender: TObject);  //Smooth3
var j:integer; y:taSmooth; znac:string;
begin
if checkbox1.Checked=false then begin for j := 2 to form1.StringGrid2.RowCount do
  y[j-2]:=strtofloat(form1.StringGrid2.Cells[rash1.Position,j-1]);
y:=Smooth(16,Smooth3, y);
for j := 2 to form1.StringGrid2.RowCount do  begin
 znac:=floattostrf(y[j-2],fffixed,3,2);
  form1.StringGrid2.Cells[rash1.Position,j-1]:=znac;
end;
end
else begin for j := 2 to form1.StringGrid2.ColCount do
  y[j-2]:=strtofloat(form1.StringGrid2.Cells[j-1,rash1.Position]);
  y:=Smooth(16,Smooth3, y);
for j := 2 to form1.StringGrid2.ColCount do  begin
 znac:=floattostrf(y[j-2],fffixed,3,2);
  form1.StringGrid2.Cells[j-1,rash1.Position]:=znac;
end;
end;
Button1Click(Sender);
rash1Change(Sender);
end;
 (******************************************************************************)
procedure TForm3.Button4Click(Sender: TObject);   //Smooth5
var j:integer; y:taSmooth; znac:string;
begin
if checkbox1.Checked=false then begin for j := 2 to form1.StringGrid2.RowCount do
  y[j-2]:=strtofloat(form1.StringGrid2.Cells[rash1.Position,j-1]);
y:=Smooth(16,Smooth5, y);
for j := 2 to form1.StringGrid2.RowCount do  begin
 znac:=floattostrf(y[j-2],fffixed,3,2);
  form1.StringGrid2.Cells[rash1.Position,j-1]:=znac;
end;
end
else begin for j := 2 to form1.StringGrid2.ColCount do
  y[j-2]:=strtofloat(form1.StringGrid2.Cells[j-1,rash1.Position]);
  y:=Smooth(16,Smooth5, y);
for j := 2 to form1.StringGrid2.ColCount do  begin
 znac:=floattostrf(y[j-2],fffixed,3,2);
  form1.StringGrid2.Cells[j-1,rash1.Position]:=znac;
end;
end;
Button1Click(Sender);
rash1Change(Sender);
end;
 (******************************************************************************)
procedure TForm3.Button5Click(Sender: TObject);   //Smooth7
var j:integer; y:taSmooth; znac:string;
begin
if checkbox1.Checked=false then begin for j := 2 to form1.StringGrid2.RowCount do
  y[j-2]:=strtofloat(form1.StringGrid2.Cells[rash1.Position,j-1]);
y:=Smooth(16,Smooth7, y);
for j := 2 to form1.StringGrid2.RowCount do  begin
 znac:=floattostrf(y[j-2],fffixed,3,2);
  form1.StringGrid2.Cells[rash1.Position,j-1]:=znac;
end;
end
else begin for j := 2 to form1.StringGrid2.ColCount do
  y[j-2]:=strtofloat(form1.StringGrid2.Cells[j-1,rash1.Position]);
  y:=Smooth(16,Smooth7, y);
for j := 2 to form1.StringGrid2.ColCount do  begin
 znac:=floattostrf(y[j-2],fffixed,3,2);
  form1.StringGrid2.Cells[j-1,rash1.Position]:=znac;
end;
end;
Button1Click(Sender);
rash1Change(Sender);
end;

(******************************************************************************)
procedure TForm3.Chart1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 mint:=series1.GetCursorValueIndex();
if (Button = mbLeft) then mouse:='mbLeft';
if (Button = mbRight) then mouse:='mbRight';
end;
(******************************************************************************)

procedure TForm3.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var xX, yY: Double;
  snt,vs,rs,he:string;
begin
      with form3.Chart1 do
  begin
if (ssCtrl in Shift) and (mouse='mbLeft') and (mint <> -1)then
  begin
  Series1.GetCursorValues(xX, yY);
  if (0<=yY) and (yY<=2) then  begin
   Series1.YValue[mint]:=strtofloat(FormatFloat( '0.##',(yY)));
  if (checkbox1.Checked=false)
    then begin form1.StringGrid2.Cells[rash1.Position,mint+1]:=FormatFloat( '0.##',(yY));
     vs:=form1.StringGrid2.Cells[rash1.Position,mint+1];
     rs:=inttohex(17-rash1.Position-1,1)+inttohex(mint+1-1,1);    //rs:='f'+inttohex(i-1,1);
     end
    else begin form1.StringGrid2.Cells[mint+1,rash1.Position]:=FormatFloat( '0.##',(yY));
       vs:=form1.StringGrid2.Cells[mint+1,rash1.Position];
       rs:=inttohex(17-mint+1-1,1)+inttohex(rash1.Position-1,1);    //rs:='f'+inttohex(i-1,1);
       end;
he:=he+inttohex(trunc(strtofloat(vs)*128),2);
snt:= '217b05'+rs+he+'0d';  //snt:='!{'+'05'+rs+#13#10;
snt:=hextostr(snt);
form1.ComPort.WriteStr(snt);

  end;
  end;
  end;
end;
 (******************************************************************************)

procedure TForm3.Chart1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
mouse:='';
Form1.editClick(sender);
end;
(******************************************************************************)

procedure TForm3.CheckBox2Click(Sender: TObject);
begin
if checkbox2.Checked=true then
       begin
       Button1Click(Sender);
        Plot3D1.Visible:=true;
        Chart1.Visible:=false;
        label1.Visible:=false;
        label2.Visible:=false;
        rash1.Visible:=false;
        ScrBarMagnif.Enabled:=true;
       end
       else begin
        Plot3D1.Visible:=false;
        ScrBarMagnif.Enabled:=false;
        Chart1.Visible:=true;
        label1.Visible:=true;
        label2.Visible:=true;
        rash1.Visible:=true;
       end;
end;
(******************************************************************************)
procedure TForm3.CheckBox3Click(Sender: TObject);
begin
if (CheckBox3.Checked = True) and (Series1.Visible= True) then
begin Series2.Visible:= False; CheckBox4.Enabled:=false;
end
else begin Series2.Visible:= True; CheckBox4.Enabled:=True;
end;
end;
(******************************************************************************)
procedure TForm3.CheckBox4Click(Sender: TObject);
begin
if (CheckBox4.Checked = True) and (Series2.Visible= True) then begin
Series1.Visible:= False;  CheckBox3.Enabled:=false; Series2.Marks.Visible:= True;
end else begin
  Series1.Visible:= True;  CheckBox3.Enabled:=True; Series2.Marks.Visible:= False;
end;
end;

(******************************************************************************)

procedure TForm3.FormCreate(Sender: TObject);
var
  i, j : integer;
begin
Label1.Caption:='������';
rash1.Min:=1;
rash1.Max:=16;
hiy:=0;
loy:=0;
for i:= 2 to form1.stringGrid2.Rowcount do
   for j := 2 to form1.stringGrid2.colcount do
  databuf[j-2,i-2]:=form1.Edit1.Text;
Button1Click(Sender);

    loy:=strtoint(Form4.edit1.text);
    hiy:=strtoint(Form4.edit16.text);
   ScrBarMagnif.Enabled:=false;
end;
(******************************************************************************)

procedure TForm3.HelpClick(Sender: TObject);
begin
Showmessage('��� �������������� ����� ������� Ctrl,����� ������ ���� � ������ �����');
end;

(******************************************************************************)
procedure TForm3.ScrBarMagnifChange(Sender: TObject);
begin
Plot3D1.Magnification := ScrBarMagnif.position/100;
NLabMag.Value := ScrBarMagnif.position/100;
end;
(******************************************************************************)
procedure TForm3.Plot3D1BeforeRenderPolygon(Sender: TObject;
  canvas: Tcanvas; var Handled: Boolean; CellX, CellY: Integer;
  quad: TQuad; var color: TColor);

begin
if (CellX >= HoleXLow) and (CellX <= HoleXHigh) and (CellY >= HoleYLow) and (CellY <= HoleYHigh) then
  Handled := true;
end;
(******************************************************************************)

procedure TForm3.rash1Change(Sender: TObject);
begin
label2.Caption:=inttostr(rash1.Position);
Button1Click(Sender);
if CheckBox3.Checked=true then CheckBox3Click(Sender);
if CheckBox4.Checked=true then CheckBox4Click(Sender);
end;
(******************************************************************************)

end.
