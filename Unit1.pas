{ VETune and VEOnline  - An open source, free editor engine tables unit
   Copyright (C) 2015 Artem E. Kochegizov. Russia, Moscow
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
   contacts:
              http://secu-3.org
              email: akochegizov@gmail.com
}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls,Masks, Grids, ExtCtrls,TeeProcs, TeEngine,Chart,math,IniFiles,unit2,
  Buttons, CPort, CPortCtl, SDL_Gauge;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    N1: TMenuItem;
    N8: TMenuItem;
    StringGrid2: TStringGrid;
    OpenDialog2: TOpenDialog;
    N3DPlot1: TMenuItem;
    Help1: TMenuItem;
    N9: TMenuItem;
    Log1: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    VEtxt1: TMenuItem;
    OpenDialog3: TOpenDialog;
    SaveDialog2: TSaveDialog;
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Panel2: TPanel;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    Panel3: TPanel;
    N10: TButton;
    N3DPlot2: TButton;
    BitBtn1: TBitBtn;
    Button4: TButton;
    ComLed1: TComLed;
    Label3: TLabel;
    ComDataPacket1: TComDataPacket;
    ComPort: TComPort;
    Panel4: TPanel;
    Button5: TButton;
    Label4: TLabel;
    Button6: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Timer1: TTimer;
    Scalelb: TScaleGauge;
    procedure FormCreate(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure N3DPlot1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure StringGrid2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StringGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N9Click(Sender: TObject);
    procedure editClick(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure VEtxt1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure StringGrid2SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure EEPROM1Click(Sender: TObject);
    procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
    procedure Button6Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure lambda_obr(str:string);
    procedure load_ve(str:string);
    procedure load_RPM(str:string);

  private
    { Private declarations }


  public
    { Public declarations }
    a:integer; s:string;
  end;
     type
  TSave = record
    FontColor : TColor;
    FontStyle : TFontStyles;
    BrColor : TColor;
  end;
  TMyThread = class(TThread)
    private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  Form1: TForm1;
  MyThread: TMyThread;
  List:TStringList;
  Lst:TStringList;
  ar: array of array of string;
  rash:array of array of real;
  rc:integer;
  gEditCol : Integer = -1;
  fname,frname,statusline:string;
    r: integer;  //hint
    c: integer;
    nvhod: array[0..16,0..16] of integer;
    ranges: array of array of Integer;
    MyComponent,MyComponent1: TComponent;
implementation

uses Unit3, Unit4;
Const
Ix=50;  Iy=50;  //âåëè÷èíû îòñòóïîâ îò êðàåâ ïîëÿ âûâîäà
ndx=10;
ndy=50; //÷èñëî ðàçáèåíèé ïî îñÿì (x, y), ñåòêà ãðàôèêà
nc=7; mc=2; // êîíñòàíòû äëÿ âûâîäà îöèôðîâêè îñåé
  BUF_SZ = 2048;
  NAMEN_SZ = 326;
  NAMEE_SZ = 342;
  VE_SZ=646;
  VEE_SZ=902;
  RANGE_LEFT = 0;
  RANGE_RIGTH = 1;
Var
  eeprom:string;       //Áóôåð äëÿ çàïèñè â *.bin
  buf: array [0..BUF_SZ-1] of byte; // áóôåð ÷òåíèÿ
  hexname:string;   //Èìÿ ïðîøèâêè
  loglen:integer;
  data: array of array of real;
  databuf: array[0..16,0..16] of real;    //Áóôåð äëÿ ïîêàçà èçìåíåíèé
  stsum:array [0..15,0..15] of real; //Ñóììû èçìåíåíèé ïîñëå ïåðåñ÷åòà
  ve_loaded:array[1..16] of boolean; //ïðîâåðêà çàãðóçêè òàáëèö
  starttune,obrab:boolean; //Ïðîâåðêà çàïóñêà ïåðåñ÷åòà

{$R *.dfm}

procedure SetRangeValue(Number: Integer; EditLeft, EditRigth: TEdit);
  begin
    // çàïîëíÿåì äèàïîçîí
    if number=15 then begin
    ranges[Number - 1][RANGE_LEFT] := StrToIntDef(EditLeft.Text, 0);
    ranges[Number - 1][RANGE_RIGTH] := StrToIntDef('9000', 0);
    end
    else begin
    ranges[Number - 1][RANGE_LEFT] := StrToIntDef(EditLeft.Text, 0);
    ranges[Number - 1][RANGE_RIGTH] := StrToIntDef(EditRigth.Text, 0)-1;
    end;
  end;

   function ProcessRangeValue(AValue: Integer):integer;
  var
    I: Integer;
  begin
    // èùåì ïî äèàïîçîíó è ñîõðàíÿåì ðåçóëüòàò
    for I := 0 to Length(ranges) - 1 do
    begin
      if (AValue >= ranges[I][RANGE_LEFT]) and (AValue <= ranges[I][RANGE_RIGTH]) then
      begin
         result:=i;
        Break;
      end;
    end;
  end;

function StrToHex(source: String): String;
var i:integer;
c:Char;
s:String;
begin
s := '';
for i:=1 to Length(source) do
begin
  c := source[i];
  s := s +  IntToHex(Integer(c),2)+' ';
end;
result := s;
end;
(******************************************************************************)
function HexToStr(hex: string): string;
var
  i: Integer;
begin
  hex:= StringReplace(hex, ' ', '', [rfReplaceAll]);
  for i:= 1 to Length(hex) div 2 do
    Result:= Result + Char(StrToInt('$' + Copy(hex, (i-1) * 2 + 1, 2)));
end;

(******************************************************************************)
function AsToAc(arrChars: array of byte) : string;       //Ïåðåâîä ASCII â ANSI
 Var
   i,kod: byte;
   arrTemp: array of byte;
 begin
  SetLength(arrTemp, Length(arrChars));
  for i:=0 to length(arrChars)-1 do
  begin
    kod:=arrChars[i];
    if (kod=240) then
      arrTemp[i]:=168;
    if (kod=241) then
      arrTemp[i]:=184;
    if (kod>=128) and (kod<=175) then
      arrTemp[i]:=kod+64
    else
      if (kod>=224) and (kod<=239) then
        arrTemp[i]:=kod+16
      else
        arrTemp[i]:=kod;
  end;
  SetString(Result, PAnsiChar(arrTemp), Length(arrTemp));
 end;

(******************************************************************************)

procedure TabClear(n,r,k:integer);                 //Î÷èñòêà òàáëèö
var iStroki,iStolbca:integer;
begin
if k=1 then  begin

end;
if k=2 then  begin
//î÷èñòêà ÿ÷ååê òàáëèöû
for iStolbca:=n to Form1.StringGrid2.ColCount do
for iStroki:=r to Form1.StringGrid2.RowCount do
  Form1.StringGrid2.Cells[iStolbca,iStroki]:='';
end;
end;

(******************************************************************************)

procedure TForm1.StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);                    //Ïåðåðèñîâêà STRGRD2
var Flag : Integer;
begin
//×èòàåì çíà÷åíèå ôëàãà, êîòîðîå çàïèñàíî ïîä âèäîì óêàçàòåëÿ íà îáúåêò.
  Flag := Integer(StringGrid2.Rows[ARow].Objects[ACol]);
  //Åñëè ôëàã íå ðàâåí
  if (Flag < 1) and (Flag > 5)then Exit;
with StringGrid2 do
  begin
  if (ACol>0) and(ARow>0) then begin
   try
if not (edit1.Text = Cells[ACol, ARow])then begin
Canvas.Brush.Color:=clYellow;
end;
if (Flag = 2) then begin Canvas.Brush.Color:=cllime; end;
if (Flag = 3) then begin Canvas.Brush.Color:=clteal; end;
if (Flag = 4) then begin Canvas.Brush.Color:=claqua; end;
if (Flag = 5) then begin Canvas.Brush.Color:=clred; end;
   except
   end;
   Canvas.FillRect(Rect); //Òåêñò òîæå áóäåò çàêðàøåí, åãî íóæíî ïåðåðèñîâàòü:
   Canvas.TextOut(Rect.Left+2, Rect.Top+2, Cells[ACol, ARow]);
  end;
  end;
end;

(******************************************************************************)

procedure TForm1.StringGrid2MouseDown(Sender: TObject; Button: TMouseButton;   //Ôèêñàöèÿ òî÷åê ïî êëèêó
  Shift: TShiftState; X, Y: Integer);
var
  Col, Row : Integer;
  Flag : Integer;
begin
//Îïðåäåëÿåì êîîðäèíàòû ÿ÷åéêè, íà êîòîðîé ïðîèçîø¸ë ùåë÷îê ìûøè.
  StringGrid2.MouseToCell(X, Y, Col, Row);
  Flag := Integer(StringGrid2.Rows[Row].Objects[Col]);
  with StringGrid2 do
  begin
  //Åñëè ïðîèçîø¸ë ùåë÷îê ëåâîé êíîïêîé ìûøè - óñòàíàâëèâàåì ôëàã.
  if (Flag < 1) and (Flag > 5) then Exit else
  if (Button = mbLeft)and (ssShift in Shift)then begin
    //Ïîä âèäîì óêàçàòåëÿ íà îáúåêò, êîòîðûé ñâÿçàí ñ ÿ÷åéêîé, çàïèñûâàåì
    //çíà÷åíèå ôëàãà. Çíà÷åíèå ôëàãà, ðàâíîå 1, îçíà÷àåò, ÷òî öâåò ÿ÷åéêè èçìåí¸í.
    Rows[Row].Objects[Col] := TObject(4);
  //Åñëè ïðîèçîø¸ë ùåë÷îê ïðàâîé êíîïêîé ìûøè - ñáðàñûâàåì ôëàã.
  end
  else
  if (Button = mbRight)and (ssShift in Shift)then begin
    Rows[Row].Objects[Col] := TObject(1);
  end;
  end;
end;

(******************************************************************************)

procedure TForm1.StringGrid2MouseMove(Sender: TObject; Shift: TShiftState; X,  //Hint
  Y: Integer);
var
  ARow: integer;
  ACol: integer;
begin
StringGrid2.MouseToCell(X, Y, ACol, ARow);
with StringGrid2 do
try
  if ((ACol<>C) or (ARow<>R)) then
    begin
      C:=ACol; R:=ARow;
      Application.CancelHint;
     // StringGrid2.Hint:=inttostr(nvhod[c,r-1]);
      StringGrid2.Selection := TGridRect(rect(C, R, c, r));
    end;
except
end;
end;
(******************************************************************************)
procedure TForm1.StringGrid2SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
  var poi:string;
  var i,j,k:integer;
snt,vs,rs,he:string;
begin
if ComPort.Connected then begin
poi:=InputBox('Ðåäàêòèðîâàíèå çíà÷åíèÿ', 'Ââåäèòå çíà÷åíèå', StringGrid2.Cells[ACol,ARow]);
if not (strtofloat(poi)>0) or not (strtofloat(poi)<2) then
MessageDlg('Îøèáêà, âûõîä çà ãðàíèöû äèàïàçîíà',mtError, mbOKCancel, 0)
else begin
StringGrid2.Cells[ACol,ARow] := poi;
vs:=form1.stringGrid2.Cells[ACol,ARow];
he:=he+inttohex(trunc(strtofloat(vs)*128),2);
rs:=inttohex(17-ACol-1,1)+inttohex(ARow-1,1);    //rs:='f'+inttohex(i-1,1);
snt:= '217b05'+rs+he+'0d';  //snt:='!{'+'05'+rs+#13#10;
snt:=hextostr(snt);
form1.ComPort.WriteStr(snt);
end;
end
else
    ShowMessage('Secu-3t íåäîñòóïåí');
end;
(******************************************************************************)
procedure TForm1.VEtxt1Click(Sender: TObject);
var f1:textfile; i,k: Integer; fname:string;
begin

// Ðàçðåøàåì ñîõðàíÿòü ôàéëû òèïà .txt è .doc
  saveDialog2.Filter := 'VE Text|*.txt|';

  // Óñòàíîâêà ðàñøèðåíèÿ ïî óìîë÷àíèþ
  saveDialog2.DefaultExt := '*.txt';
   SaveDialog2.FileName:=FormatDateTime('dd.mm.yyyy_hh.nn.ss', Now)+'.txt';
  // Âûáîð òåêñòîâûõ ôàéëîâ êàê ñòàðòîâûé òèï ôèëüòðà
  saveDialog2.FilterIndex := 1;
//ñîõðàíèòü òåêñò èç Memo1-ðàáî÷åé îáëàñòè ðåäàêòîðà
if Form1.SaveDialog2.Execute then begin
  //Åñëè ôàéë âûáðàí,
  //òî S ïðèñâîèòü ñïåöèôèêàöèþ ôàéëà,

  fname:=SaveDialog2.FileName;

AssignFile(F1, fname);
Rewrite(F1);
with StringGrid2 do
   begin
     // Write number of Columns/Rows
    Writeln(f1, ColCount);
     Writeln(f1, RowCount);
     // loop through cells
    for i := 1 to ColCount - 1 do
       for k := 1 to RowCount - 1 do
         Writeln(F1, Cells[i, k]);
   end;
CloseFile(F1);
end;
end;

(******************************************************************************)


procedure TForm1.BitBtn1Click(Sender: TObject);
begin
form4.show;
end;
(******************************************************************************)
procedure UpdateResults();      //Çàíåñåíèå çíà÷åíèé â Secu
var i,j,k:integer;
snt,vs,rs,he:string;
begin
snt:='';
k:=15;
 for i := 1 to 17 do
begin
he:='';
      for j := 1 to 16 do begin
vs:=form1.stringGrid2.Cells[i,j];
he:=he+inttohex(trunc(strtofloat(vs)*128),2);
      end;
rs:=inttohex(k,1)+'0';
snt:= '217B05'+rs+he+'0D';
snt:=hextostr(snt);
form1.ComPort.WriteStr(snt);
dec(k);
snt:='';
 end;
 form1.ComPort.WriteStr('!u'+#13#10);
 form1.ComPort.WriteStr('!hq'+#13#10);
 form1.Log1.Caption:='Status: Sucsess';
end;
(******************************************************************************)
procedure TForm1.Button1Click(Sender: TObject);      //Áàçîâîå çàïîëíåíèå ÿ÷ååê
var i,j,k:integer; iTmp:integer;
buttonSelected:integer;
begin
iTmp:=17;
stringGrid2.ColCount := iTmp;
stringGrid2.RowCount := iTmp;
if not (strtofloat(edit1.Text)>0) or not (strtofloat(edit1.Text)<2) then
MessageDlg('Îøèáêà, âûõîä çà ãðàíèöû äèàïàçîíà',mtError, mbOKCancel, 0)
else begin
   //Çàãðóæàåì â ëèñòèíã ñïèñîê çíà÷åíèé èç edit1
buttonSelected:= MessageDlg('Çàìåíèòü çíà÷åíèÿ?',mtInformation, [mbYes,mbCancel], 0);
   if buttonSelected = mrYes    then begin
for i:= 1 to iTmp do begin
    k:=1;
      for j:=1 to iTmp do begin
      stringGrid2.Cells[k,i]:=edit1.Text;
        inc(k)
      end;
    end;
   end;
   with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini') do
   WriteString('TUNEUP', 'StartPoint', edit1.text);
end;
end;


(******************************************************************************)

procedure TForm1.EditClick(Sender: TObject); //Çàíåñåíèå èçìåíåíèé òàáëèöû â ìàññèâ
 var i,j,k:integer;
      hexve:real;
begin
eeprom:='';
k:=VE_SZ; try
for i := Form1.stringgrid2.Colcount-1 downto 1 do
for j := 1 to Form1.stringgrid2.Rowcount-1 do begin
HexVE :=strtofloat(Form1.stringgrid2.Cells[i,j]);
buf[k]:=round(HexVE*128);
inc(k);
end;
except
on E : Exception do
      ShowMessage(E.ClassName+'Edit îøèáêà ñ ñîîáùåíèåì : '+E.Message);
end;
end;


procedure TForm1.EEPROM1Click(Sender: TObject);
begin
form1.Log1.Caption:='Status:';
UpdateResults();
end;

(******************************************************************************)

procedure TForm1.Button2Click(Sender: TObject);      //Îòêðûòü Ïîðò
var i,d:integer;
begin
Button3.Enabled:=true;
N3DPlot1.Enabled:=true;
N3DPlot2.Enabled:=true;
N10.Enabled:=true;
ComDataPacket1.StartString:=hextostr('40');
ComDataPacket1.StopString:=hextostr('0D');
ComPort.Port:=form2.Comcombobox1.Text;
ComPort.BaudRate:=strtobaudrate(form2.Comcombobox2.Text);
if not ComPort.Connected then begin
try
    ComPort.Open;
   if ComPort.Connected then begin
   form1.ComPort.WriteStr('!h"'+#13#10);
    end
   else
   ShowMessage('Íå óäàëîñü ïîäêëþ÷èòüñÿ ê Secu-3T');
except
on E : Exception do
      ShowMessage(E.Message+' '+form1.ComPort.Port);
end;
     end
    else
    ShowMessage('Secu-3T íåäîñòóïåí');
end;
(******************************************************************************)

procedure TForm1.Button3Click(Sender: TObject);     //Çàêðûòü ïîðò
begin
  if ComPort.Connected then begin
  starttune:=false;
    ComPort.Close;
  end
    else
    ShowMessage('Secu-3t óæå îòêëþ÷åí');
end;

(******************************************************************************)
procedure TForm1.Button4Click(Sender: TObject);
begin
with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini') do
   WriteString('TUNEUP', 'StartPoint', edit1.text);
   StringGrid2.Refresh;
end;

procedure TForm1.Button6Click(Sender: TObject);                //SaveFixed
var fixed:string;
i,j,flag:integer;
begin
if form2.CheckBox1.Checked then begin
fixed:='';
     /// Âûáèðàåì Òî÷êè ñ ôëàãîì 4
for i:= 1 to form1.stringGrid2.Rowcount-1 do begin
for j:= 1 to form1.stringGrid2.Colcount-1 do begin
Flag := Integer(form1.StringGrid2.Rows[i].Objects[j]);
if (Flag=4) then begin
        fixed:=fixed+inttostr(i)+':'+inttostr(j)+' ';
         end
end;
end;
with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini') do
  begin
    WriteString('POINTS', 'FIXED', fixed);
    Free;
  end;
end;
end;

(******************************************************************************)
function scan(const str:string;scstr:string):integer;
begin
result := AnsiPos(scstr, str);
end;
(******************************************************************************)
procedure TForm1.load_ve(str:string);   //Çàãðóçêà VE
var Sl: TStringList;
sdl:string;
i,j,r:integer;
point:real;
begin
Sl := TStringList.Create;
Sl.Delimiter := ' '; // <-- ðàçäåëèòåëü
if (scan(str,'40 7B 05')<>0)then begin
/////////////// Ïàðñèíã
sdl:= str;
Delete(sdl, 1, 9);   //Óäàëÿåì íà÷àëüíûå áèòû
r:=16-strtoint('$'+Copy(sdl, 1, 1)); //Âû÷èñëÿåì ðàñõîä
Delete(sdl, 1, 3);   //Óäàëÿåì áèòû ðàñõîäà
Delete(sdl, length(sdl)-3, 4);   //Óäàëÿåì áèòû êîíöà ñòðîêè
Sl.DelimitedText := sdl; // <-- ñòðîêà
   ////////////////////   Çàïîëíåíèå
   for i:= 1 to form1.stringGrid2.Rowcount-1 do begin
    point:=strtoint('$'+Sl[i-1])/128;
    form1.stringGrid2.Cells[r,i]:=FormatFloat('0.##', point);
    if point<>strtofloat(form1.edit1.text) then
    if form1.StringGrid2.Rows[i].Objects[r]<>TObject(4) then
    form1.StringGrid2.Rows[i].Objects[r] := TObject(1); //1-æåëòûé,2-çåëåíûé,4-ãîëóáîé(çàïðåò),5-êðàñíûé(îøèáêà)
end;
ve_loaded[r]:=true;
Sl.Free;
if (scan(str,'40 7B 05 F0')<>0) and (ve_loaded[1]=true) then form1.ComPort.WriteStr('!hq'+#13#10);
end;
end;
(******************************************************************************)
                                                                               //Ïðîöåäóðà çàïóñêà êîððåêöèè
procedure TForm1.lambda_obr(str:string);
var Sl: TStringList;
sdl:string;
l,ob,obt,r:integer;
begin
sdl:='';
Sl := TStringList.Create;
Sl.Delimiter := ' '; // <-- ðàçäåëèòåëü
if (scan(str,'40 71')<>0)then begin
form1.StringGrid2.Enabled:=false;
/////////////// Ïàðñèíã
sdl:= str;
Delete(sdl, 1, 6);   //Óäàëÿåì íà÷àëüíûå áèòû
Delete(sdl, length(sdl)-3, 4);   //Óäàëÿåì áèòû êîíöà ñòðîêè
Sl.DelimitedText := sdl; // <-- ñòðîêà
r:=strtoint('$'+sl[14]); //Âû÷èñëÿåì ðàñõîä
ob:=strtoint('$'+sl[0]+sl[1]); //îáîðîòû
obt:=ProcessRangeValue(ob);
 statusline:=sdl;
 if obt=15 then obt:=0;
      form1.StringGrid2.Selection := TGridRect(rect(r, obt+1, r, obt+1));
     MyThread:=TMyThread.Create(False);
     MyThread.Priority:=tpNormal;
    end;
Sl.Free;
end;
////////////////////////////////

procedure TMyThread.Execute;                                              //Çàïîëíåíèå ìàññèâà êîððåêöèè
var sl,s1:TStringList;
l,ob,obt,r:integer;
lf,data:real;
begin
Sl := TStringList.Create;
Sl.Delimiter := ' '; // <-- ðàçäåëèòåëü
Sl.DelimitedText:=statusline; // <-- ñòðîêà
r:=strtoint('$'+sl[14]); //Âû÷èñëÿåì ðàñõîä
   ////////////////////   Çàïîëíåíèå
   l:=smallint(StrToInt('$'+sl[46]+sl[47]));
   //l:=smallint($FFC8);   r:=1;
   lf:=l/512.0;
   ob:=strtoint('$'+sl[0]+sl[1]); //îáîðîòû
   obt:=ProcessRangeValue(ob);
   if obt=15 then obt:=0;
   if not form1.timer1.Enabled then form1.timer1.Enabled:=true;
   if obt<>0 then begin  //Ïðîâåðêà íà íàëè÷èå îáîðîòîâ
   form1.Label5.Caption:='Îáîðîòû: '+inttostr(ob);
   form1.Label6.Caption:='Êîððåêöèÿ: '+FormatFloat('0.##', lf*100)+'% ';
   form1.Scalelb.Value:=lf*100;
  /// Îáðàáîòêè
  if not obrab then
if abs(lf*100)>5 then
   if form1.StringGrid2.Rows[obt+1].Objects[r]<>TObject(4) then
    begin
      databuf[r,obt+1]:=databuf[r,obt+1]+lf;
      nvhod[r,obt+1]:=nvhod[r,obt+1]+1;
end;
end;
Sl.Free;
MyThread.Terminate;
end;

(******************************************************************************)

procedure TForm1.Timer1Timer(Sender: TObject);                          //Îáðàáîòêà êîððåêöèè
var sdl,l1:string;
snt,rs,he:string;
l,ob,obt,r:integer;
poi,lf:real;
  i: Integer;
  j: Integer;
begin
for i := 1 to 16 do
for j := 1 to 16 do
if nvhod[i,j]>150 then  begin
obrab:=true;
poi:=databuf[i,j]/nvhod[i,j];
poi:=poi-sqrt(((poi*poi)+((poi/2)*(poi/2)))/2);                   //Êîýôèöèåíò
poi:=poi+strtofloat(form1.stringGrid2.Cells[i,j]);
if (poi>0) and (poi<2) then begin
if form1.StringGrid2.Rows[j].Objects[i]<>TObject(4) then
    begin
form1.stringGrid2.Cells[i,j]:=FormatFloat('0.##', poi);
form1.StringGrid2.Rows[j].Objects[i] := TObject(2);
he:=he+inttohex(trunc(poi*128),2);
rs:=inttohex(17-i-1,1)+inttohex(j-1,1);    //rs:='f'+inttohex(i-1,1);
snt:= '217B05'+rs+he+'0D';  //snt:='!{'+'05'+rs+#13#10;
snt:=hextostr(snt);
form1.ComPort.WriteStr(snt);
    end;
end;
databuf[i,j]:=0;
nvhod[i,j]:=0;
poi:=0;
obrab:=false;
end;

end;

(******************************************************************************)
procedure TForm1.load_RPM(str:string);   //Çàãðóçêà RPM
var Sl: TStringList;
sdl,rpm:string;
i,j,r,d:integer;
point:real;
begin
Sl := TStringList.Create;
Sl.Delimiter := ' '; // <-- ðàçäåëèòåëü
if (scan(str,'40 22 00')<>0)then begin
/////////////// Ïàðñèíã
sdl:= str;
Delete(sdl, 1, 9);   //Óäàëÿåì íà÷àëüíûå áèòû
Delete(sdl, length(sdl)-3, 4);   //Óäàëÿåì áèòû êîíöà ñòðîêè
Sl.DelimitedText := sdl; // <-- ñòðîêà
   ////////////////////   Çàïîëíåíèå
   i:=0;
   d:=1;
   while i<Sl.count do begin
   r:=smallint(StrToInt('$'+sl[i+1]+sl[i]));
    i:=i+2;
    rpm:=inttostr(r);
    if length(rpm)=3 then rpm:='0'+rpm;    
    form1.stringGrid2.Cells[0,d]:=rpm;  //Çíà÷åíèå îáîðîòîâ
    MyComponent := Form4.FindComponent('Edit'+IntToStr(d));
    TEdit(MyComponent).Text:=rpm;
    inc(d);
end;

   // ãîòîâèì äèàïîçîí
  SetLength(ranges, 16);
  for I := 0 to 15 do
  begin
    SetLength(ranges[I], 2);
  end;
  //Çàïîëíÿåì
  for d:=2 to 16 do
  begin
   MyComponent := Form4.FindComponent('Edit'+IntToStr(d-1));
   MyComponent1 := Form4.FindComponent('Edit'+IntToStr(d));
   if MyComponent <> nil then if d=16 then begin
   SetRangeValue(d-1, TEdit(MyComponent), TEdit(MyComponent1));
   SetRangeValue(15, TEdit(MyComponent1), TEdit(MyComponent1));
   end else  SetRangeValue(d-1, TEdit(MyComponent), TEdit(MyComponent1));
  end;


Sl.Free;
form1.ComPort.WriteStr('!h{'+#13#10)
end;
end;

(******************************************************************************)

procedure TForm1.ComDataPacket1Packet(Sender: TObject; const Str: string);
var str1:string;
begin
str1:=strtohex(str);
  str1:=StringReplace(str1, '0A 81', '21',[rfReplaceAll, rfIgnoreCase]);
  str1:=StringReplace(str1, '0A 82', '40',[rfReplaceAll, rfIgnoreCase]);
  str1:=StringReplace(str1, '0A 83', '0D',[rfReplaceAll, rfIgnoreCase]);
  str1:=StringReplace(str1, '0A 84', '0A',[rfReplaceAll, rfIgnoreCase]);
  load_RPM(str1);
  load_ve(str1);
  stringgrid2.Enabled:=true;
  if starttune then lambda_obr(str1);
end;

(******************************************************************************)

procedure TForm1.FormCreate(Sender: TObject);
var i,j,k,d,razm:integer; filename:string;
Sl,s1: TStringList;
begin
fileName := ExtractFilePath(ParamStr(0)) + 'Config.ini';
if not FileExists(fileName)
  then with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini') do
  begin
    WriteString('DIR', 'COMB', '57600');
    WriteString('DIR', 'COMP', '1');
   WriteString('TUNEUP', 'StartPoint', inttostr(1));
  for d:=1 to 16 do
  begin
   case d of
    1:razm:=600;
    2:razm:=720;
    3:razm:=840;
    4:razm:=990;
    5:razm:=1170;
    6:razm:=1380;
    7:razm:=1650;
    8:razm:=1950;
    9:razm:=2310;
    10:razm:=2730;
    11:razm:=3210;
    12:razm:=3840;
    13:razm:=4530;
    14:razm:=5370;
    15:razm:=6360;
    16:razm:=7500;
    end;
    if Length(inttostr(razm)) =3 then WriteString('GridRPM', inttostr(d), '0'+inttostr(razm)) else
    WriteString('GridRPM', inttostr(d), inttostr(razm));
  end;
    Free;
end;


/////////////////////////////////
Sl := TStringList.Create;
S1 := TStringList.Create;
Sl.Delimiter := ' '; // <-- ðàçäåëèòåëü
S1.Delimiter := ':'; // <-- ðàçäåëèòåëü
///
with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini') do
  begin
    //VE.txt
    edit1.Text:=ReadString('TUNEUP', 'StartPoint', '');
    Sl.DelimitedText := ReadString('POINTS', 'FIXED', ''); // <-- ñòðîêà
 //ðàçìåòêà ñòîëáöîâ
  for d:=1 to 16 do
  begin
   stringGrid2.Cells[0,d]:=ReadString('GridRPM', inttostr(d), '');
  end;

    Free;
  end;

// Ðàçðåøàåì ñîõðàíÿòü ôàéëû òèïà .txt è .doc
OpenDialog1.Filter := 'Secu3 Logfile|*.csv|';

  // Óñòàíîâêà ðàñøèðåíèÿ ïî óìîë÷àíèþ
 OpenDialog1.DefaultExt := '*.csv';

  // Âûáîð òåêñòîâûõ ôàéëîâ êàê ñòàðòîâûé òèï ôèëüòðà
 OpenDialog1.FilterIndex := 1;
//Îáðàáîò÷èê ñîáûòèÿ ÑÎÇÄÀÍÈß ÔÎÐÌÛ
//Çàïèñûâàåì ðàçìåòêó stringGrid2
//ðàçìåòêà ñòðîê
stringGrid2.Cells[0,0]:='Îá.\Ðàñõ.';
j:=1;
for i:= 1 to 16 do begin
    k:=0;
      stringGrid2.Cells[i,k]:=inttostr(j);
      inc(j)
    end;
//Çàãðóæàåì â ëèñòèíã ñïèñîê íà÷àëüíûõ çíà÷åíèé
for i:= 1 to 17 do begin
    k:=1;
      for j:=1 to 17 do begin
      stringGrid2.Cells[k,i]:=edit1.Text;
      form1.StringGrid2.Rows[i].Objects[j] := TObject(0);
      inc(k)
      end;
    end;

      ////////////////////////////////////
for i := 0 to sl.count-1 do
  begin
S1.DelimitedText :=sl[i];
form1.StringGrid2.Rows[strtoint(s1[0])].Objects[strtoint(s1[1])] := TObject(4);
  end;
///////////////

    StringGrid2.Hint := '0 0';
    StringGrid2.ShowHint := True;
end;
(******************************************************************************)

procedure TForm1.Help1Click(Sender: TObject);
begin
Showmessage('Èíôîðìàöèÿ âðåìåííî íåäîñòóïíà'+#13#10);
end;
(******************************************************************************)
procedure TForm1.N3DPlot1Click(Sender: TObject);
begin
form3.Visible:=true;
Form3.Button1Click(Sender);
end;
(******************************************************************************)

procedure TForm1.N8Click(Sender: TObject);           //Çàâåðøåíèå ðàáîòû
begin
Close;
end;
procedure TForm1.N9Click(Sender: TObject);
begin
form2.show;
end;

(******************************************************************************)

procedure TForm1.N10Click(Sender: TObject);   //Çàïóñê ïåðåñ÷åòà çíà÷åíèé
var buttonSelected:integer;
begin
if N10.caption<>'Ñòîï' then
buttonSelected:= MessageDlg('Çàïóñòèòü Online ðåäàêòèðîâàíèå?',mtInformation, [mbYes,mbCancel], 0);
   if buttonSelected = mrYes    then begin
     Button3.Enabled:=true;
     N3DPlot1.Enabled:=true;
     N3DPlot2.Enabled:=true;
     N10.caption:='Ñòîï';
     obrab:=false;
     if not starttune then starttune:=true;
   end
   else
       begin
     form1.StringGrid2.Enabled:=true;
      starttune:=false;
      if timer1.Enabled then timer1.Enabled:=false;
      N10.caption:='Çàïóñê';
       end;

end;
(******************************************************************************)
procedure TForm1.N12Click(Sender: TObject);
var f1:textfile; i,j,iTmp: Integer; st,fname:string;
begin
// Ðàçðåøàåì ñîõðàíÿòü ôàéëû òèïà .txt è .doc
  OpenDialog3.Filter := 'VE Text|*.txt|';

  // Óñòàíîâêà ðàñøèðåíèÿ ïî óìîë÷àíèþ
 OpenDialog3.DefaultExt := '*.txt';

  // Âûáîð òåêñòîâûõ ôàéëîâ êàê ñòàðòîâûé òèï ôèëüòðà
OpenDialog3.FilterIndex := 1;

if Form1.OpenDialog3.Execute then begin//åñëè âûáðàí ôàéë
  fname:=OpenDialog3.FileName;
AssignFile(F1, fname);
Reset(F1);

with StringGrid2 do
   begin
     // Get number of columns
    Readln(f1, iTmp);
     ColCount := iTmp;
     // Get number of rows
    Readln(f1, iTmp);
     RowCount := iTmp;
     // loop through cells & fill in values
    for i := 1 to ColCount-1 do
       for j := 1 to RowCount-1 do
       begin
         Readln(f1, st);
         if (strtofloat(st)<0) or (strtofloat(st)>2)then begin
         MessageDlg('Îøèáêà, âûõîä çà ãðàíèöû äèàïàçîíà',mtError, mbOKCancel, 0);
         //Cells[i, j] := st;      //Îñòàâëÿòü ñòàðîå çíà÷åíèå
         Cells[i, j] := '0.00';         //Ìåíÿòü íà 0
         Rows[j].Objects[i] := TObject(5);
         end else  begin
           Cells[i, j] := st;
         Rows[j].Objects[i] := TObject(1);
         end;
       end;
   end;
CloseFile(F1);
end;
end;
(******************************************************************************)


end.

