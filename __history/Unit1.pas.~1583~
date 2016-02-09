unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls,Masks, Grids, ExtCtrls,TeeProcs, TeEngine,Chart,math,IniFiles,unit2,
  Buttons, AdPort, OoMisc, ADTrmEmu, AdPacket, CPort, CPortCtl;

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
    EEPROM1: TMenuItem;
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
    ComPort: TComPort;
    ComLed1: TComLed;
    Memo1: TMemo;
    ComComboBox2: TComComboBox;
    ComComboBox1: TComComboBox;
    Label3: TLabel;
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
    procedure ComPortRxChar(Sender: TObject; Count: Integer);

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

var
  Form1: TForm1;
  List:TStringList;
  Lst:TStringList;
  ar: array of array of string;
  rash:array of array of real;
  rc:integer;
  gEditCol : Integer = -1;
  fname,frname:string;
    r: integer;  //hint
    c: integer;
    nvhod: array[0..16,0..16] of integer;
implementation

uses Unit3, Unit4;
Const
Ix=50;  Iy=50;  //величины отступов от краев поля вывода
ndx=10;
ndy=50; //число разбиений по осям (x, y), сетка графика
nc=7; mc=2; // константы для вывода оцифровки осей
  BUF_SZ = 2048;
  NAMEN_SZ = 326;
  NAMEE_SZ = 342;
  VE_SZ=646;
  VEE_SZ=902;
Var
  eeprom:string;       //Буфер для записи в *.bin
  buf: array [0..BUF_SZ-1] of byte; // буфер чтения
  hexname:string;   //Имя прошивки
  loglen:integer;
  data: array of array of real;
  databuf: array[0..16,0..16] of string;    //Буфер для показа изменений
  stsum:array [0..15,0..15] of real; //Суммы изменений после пересчета

{$R *.dfm}

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
function AsToAc(arrChars: array of byte) : string;       //Перевод ASCII в ANSI
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

procedure TabClear(n,r,k:integer);                 //Очистка таблиц
var iStroki,iStolbca:integer;
begin
if k=1 then  begin

end;
if k=2 then  begin
//очистка ячеек таблицы
for iStolbca:=n to Form1.StringGrid2.ColCount do
for iStroki:=r to Form1.StringGrid2.RowCount do
  Form1.StringGrid2.Cells[iStolbca,iStroki]:='';
end;
end;

(******************************************************************************)

procedure TForm1.StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);                    //Перерисовка STRGRD2
var Flag : Integer;
begin
//Читаем значение флага, которое записано под видом указателя на объект.
  Flag := Integer(StringGrid2.Rows[ARow].Objects[ACol]);
  //Если флаг не равен
  if (Flag <> 1) and (Flag <> 2) and (Flag <> 4) and (Flag <> 5)then Exit;
with StringGrid2 do
  begin
  if (ACol>0) and(ARow>0) then begin
   try
if not (edit1.Text = Cells[ACol, ARow])then begin
Canvas.Brush.Color:=clYellow;
end;
if (Flag = 2) then begin Canvas.Brush.Color:=cllime; end;
if (Flag = 4) then begin Canvas.Brush.Color:=claqua; end;
if (Flag = 5) then begin Canvas.Brush.Color:=clred; end;
   except
   end;
   Canvas.FillRect(Rect); //Текст тоже будет закрашен, его нужно перерисовать:
   Canvas.TextOut(Rect.Left+2, Rect.Top+2, Cells[ACol, ARow]);
  end;
  end;
end;

(******************************************************************************)

procedure TForm1.StringGrid2MouseDown(Sender: TObject; Button: TMouseButton;   //Фиксация точек по клику
  Shift: TShiftState; X, Y: Integer);
var
  Col, Row : Integer;
  Flag : Integer;
begin
//Определяем координаты ячейки, на которой произошёл щелчок мыши.
  StringGrid2.MouseToCell(X, Y, Col, Row);
  Flag := Integer(StringGrid2.Rows[Row].Objects[Col]);
  with StringGrid2 do
  begin
  //Если произошёл щелчок левой кнопкой мыши - устанавливаем флаг.
  if (Flag <> 2) and (Flag <> 4) and (Flag <> 1)then Exit else
  if (Button = mbLeft)and (ssShift in Shift)then begin
    //Под видом указателя на объект, который связан с ячейкой, записываем
    //значение флага. Значение флага, равное 1, означает, что цвет ячейки изменён.
    Rows[Row].Objects[Col] := TObject(4);
  //Если произошёл щелчок правой кнопкой мыши - сбрасываем флаг.
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
      //StringGrid2.Hint:=inttostr(nvhod[c,r-1]);
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
poi:=InputBox('Редактирование значения', 'Введите значение', StringGrid2.Cells[ACol,ARow]);
if not (strtofloat(poi)>0) or not (strtofloat(poi)<2) then
MessageDlg('Ошибка, выход за границы диапазона',mtError, mbOKCancel, 0)
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
    ShowMessage('Secu-3t недоступен');
end;

(******************************************************************************)
procedure TForm1.VEtxt1Click(Sender: TObject);
var f1:textfile; i,k: Integer; fname:string;
begin
  saveDialog2.InitialDir := form2.Edit2.Text;

// Разрешаем сохранять файлы типа .txt и .doc
  saveDialog2.Filter := 'VE Text|*.txt|';

  // Установка расширения по умолчанию
  saveDialog2.DefaultExt := '*.txt';
   SaveDialog2.FileName:=FormatDateTime('dd.mm.yyyy_hh.nn.ss', Now)+'.txt';
  // Выбор текстовых файлов как стартовый тип фильтра
  saveDialog2.FilterIndex := 1;
//сохранить текст из Memo1-рабочей области редактора
if Form1.SaveDialog2.Execute then begin
  //Если файл выбран,
  //то S присвоить спецификацию файла,

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
procedure UpdateResults();      //Занесение значений в Secu
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
procedure TForm1.Button1Click(Sender: TObject);      //Базовое заполнение ячеек
var i,j,k:integer; iTmp:integer;
buttonSelected:integer;
begin
iTmp:=17;
stringGrid2.ColCount := iTmp;
stringGrid2.RowCount := iTmp;
if not (strtofloat(edit1.Text)>0) or not (strtofloat(edit1.Text)<2) then
MessageDlg('Ошибка, выход за границы диапазона',mtError, mbOKCancel, 0)
else begin
   //Загружаем в листинг список значений из edit1
buttonSelected:= MessageDlg('Заменить значения?',mtInformation, [mbYes,mbCancel], 0);
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

procedure TForm1.EditClick(Sender: TObject); //Занесение изменений таблицы в массив
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
      ShowMessage(E.ClassName+'Edit ошибка с сообщением : '+E.Message);
end;
end;


procedure TForm1.EEPROM1Click(Sender: TObject);
begin
form1.Log1.Caption:='Status:';
UpdateResults();
end;

(******************************************************************************)

procedure TForm1.Button2Click(Sender: TObject);     //Открыть Порт
begin
Button3.Enabled:=true;
N3DPlot1.Enabled:=true;
N3DPlot2.Enabled:=true;
N10.Enabled:=true;
//TabClear(1,1,2);   //очистка окна
if not ComPort.Connected then begin
    ComPort.Open;
    form1.ComPort.WriteStr('!h{'+#13#10);
     end
    else
    ShowMessage('Secu-3t недоступен');
end;
(******************************************************************************)

procedure TForm1.Button3Click(Sender: TObject);     //Закрыть порт
begin
  if ComPort.Connected then
    ComPort.Close
    else
    ShowMessage('Secu-3t уже отключен');
end;

(******************************************************************************)
procedure TForm1.Button4Click(Sender: TObject);
begin
with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini') do
   WriteString('TUNEUP', 'StartPoint', edit1.text);
   StringGrid2.Refresh;
end;

(******************************************************************************)

function scan(const str:string;scstr:string):integer;
begin
result := AnsiPos(scstr, str);
end;
(******************************************************************************)
procedure load_ve(str:string);   //Загрузка VE
var Sl: TStringList;
sdl:string;
i,j,r:integer;
begin
Sl := TStringList.Create;
Sl.Delimiter := ' '; // <-- разделитель
if (scan(strtohex(str),'40 7B 05')<>0)then begin
   // if (scan(strtohex(str),'0A 82')<>0) then begin
       str:=strtohex(str);
       str:=StringReplace(str, '0A 82', '40',[rfReplaceAll, rfIgnoreCase]);

/////////////// Парсинг
sdl:= str;
Delete(sdl, 1, 9);   //Удаляем начальные биты
r:=16-strtoint('$'+Copy(sdl, 1, 1)); //Вычисляем расход
Delete(sdl, 1, 3);   //Удаляем биты расхода
Delete(sdl, 48, 3);   //Удаляем биты конца строки
Sl.DelimitedText := sdl; // <-- строка
   ////////////////////   Заполнение
   for i:= 1 to form1.stringGrid2.Rowcount-1 do begin
    form1.stringGrid2.Cells[r,i]:=FormatFloat('0.##', strtoint('$'+Sl[i-1])/128);
end;
Sl.Free;
   ///
      //end else
      // form1.Memo1.Lines.Add(strtohex(str));
if scan(str,'40 7B 05 F0')<>0 then form1.ComPort.WriteStr('!hq'+#13#10);
end;
end;
(******************************************************************************)
procedure lambda_obr(str:string);
var Sl: TStringList;
sdl:string;
i,r:integer;
begin
Sl := TStringList.Create;
Sl.Delimiter := ' '; // <-- разделитель
if (scan(strtohex(str),'40 71')<>0)then begin
       str:=strtohex(str);
       str:=StringReplace(str, '0A 82', '40',[rfReplaceAll, rfIgnoreCase]);
/////////////// Парсинг
sdl:= str;
Delete(sdl, 1, 6);   //Удаляем начальные биты
r:=16-strtoint('$'+Copy(sdl, 1, 1)); //Вычисляем расход
Delete(sdl, 165, 3);   //Удаляем биты конца строки
Sl.DelimitedText := sdl; // <-- строка
   ////////////////////   Заполнение
   //form1.Memo1.Lines.Add(sl[48]+sl[49]);
   i:=strtoint('$'+sl[46]+sl[47]);
   if strtoint('$'+sl[12])<>0 then
   form1.Memo1.Lines.Add(floattostr((i/512)*100));
   // form1.stringGrid2.Cells[r,i]:=FormatFloat('0.##', strtoint('$'+Sl[i-1])/128);
Sl.Free;
   ///
end;
end;
(******************************************************************************)

procedure TForm1.ComPortRxChar(Sender: TObject; Count: Integer);
var
  Str: String;
begin
  ComPort.ReadStr(Str, Count);
  load_ve(str);
  stringgrid2.Enabled:=true;
  lambda_obr(str);
end;

(******************************************************************************)

procedure TForm1.FormCreate(Sender: TObject);
var i,j,k,d,razm:integer; filename:string;
begin
fileName := ExtractFilePath(ParamStr(0)) + 'Config.ini';
if not FileExists(fileName)
  then with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini') do
  begin
   WriteString('DIR', 'EESAVE', ExtractFilePath(ParamStr(0)));
   WriteString('DIR', 'EEPROM', ExtractFilePath(ParamStr(0)));
   WriteString('DIR', 'LOG', ExtractFilePath(ParamStr(0)));
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

with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini') do
  begin
    openDialog2.InitialDir := ReadString('DIR', 'EEPROM', '');
    openDialog1.InitialDir := ReadString('DIR', 'LOG', '');
    saveDialog1.InitialDir := ReadString('DIR', 'EESAVE', '');
    //VE.txt
    saveDialog2.InitialDir := ReadString('DIR', 'EEPROM', '');
    openDialog3.InitialDir := ReadString('DIR', 'EEPROM', '');
    edit1.Text:=ReadString('TUNEUP', 'StartPoint', '');
 //разметка столбцов
  for d:=1 to 16 do
  begin
   stringGrid2.Cells[0,d]:=ReadString('GridRPM', inttostr(d), '');
  end;

    Free;
  end;
// Разрешаем сохранять файлы типа .txt и .doc
OpenDialog1.Filter := 'Secu3 Logfile|*.csv|';

  // Установка расширения по умолчанию
 OpenDialog1.DefaultExt := '*.csv';

  // Выбор текстовых файлов как стартовый тип фильтра
 OpenDialog1.FilterIndex := 1;
//Обработчик события СОЗДАНИЯ ФОРМЫ
//Записываем разметку stringGrid2
//разметка строк
stringGrid2.Cells[0,0]:='Об.\Расх.';
j:=1;
for i:= 1 to 16 do begin
    k:=0;
      stringGrid2.Cells[i,k]:=inttostr(j);
      inc(j)
    end;
//Загружаем в листинг список начальных значений
for i:= 1 to 17 do begin
    k:=1;
      for j:=1 to 17 do begin
      stringGrid2.Cells[k,i]:=edit1.Text;
      form1.StringGrid2.Rows[i].Objects[j] := TObject(0);
      inc(k)
      end;
    end;
    StringGrid2.Hint := '0 0';
    StringGrid2.ShowHint := True;
end;
(******************************************************************************)

procedure TForm1.Help1Click(Sender: TObject);
begin
Showmessage('Информация временно недоступна'+#13#10);
end;
(******************************************************************************)
procedure TForm1.N3DPlot1Click(Sender: TObject);
begin
form3.Visible:=true;
Form3.Button1Click(Sender);
end;
(******************************************************************************)

procedure TForm1.N8Click(Sender: TObject);           //Завершение работы
begin
Close;
end;
procedure TForm1.N9Click(Sender: TObject);
begin
form2.show;
end;

(******************************************************************************)
procedure smlst(arh:Pointer;n:integer;k:integer);    //Пересчет значений в STRGRD2
var i,cs,Flag:integer;
n1:array [0..15] of integer;
ranges: array of array of Integer;
 s1:array [0..15] of real;
 sr1:array [0..15] of real;
  arr: array of array of real;
  znac:string;
  zn:real;
  MyComponent,MyComponent1: TComponent;
  d:integer;
  const
  RANGE_LEFT = 0;
  RANGE_RIGTH = 1;

  procedure SetRangeValue(Number: Integer; EditLeft, EditRigth: TEdit);
  begin
    // заполняем диапозон
    if number=15 then begin
    ranges[Number - 1][RANGE_LEFT] := StrToIntDef(EditLeft.Text, 0);
    ranges[Number - 1][RANGE_RIGTH] := StrToIntDef('9000', 0);
    end
    else begin
    ranges[Number - 1][RANGE_LEFT] := StrToIntDef(EditLeft.Text, 0);
    ranges[Number - 1][RANGE_RIGTH] := StrToIntDef(EditRigth.Text, 0)-1;
    end;
  end;

   procedure ProcessRangeValue(AValue: Integer;AD: Integer);
  var
    I: Integer;
  begin
    // ищем по диапозону и сохраняем результат
    for I := 0 to Length(ranges) - 1 do
    begin
      if (AValue >= ranges[I][RANGE_LEFT]) and (AValue <= ranges[I][RANGE_RIGTH]) then
      begin
        s1[i]:=s1[i]+arr[1,AD]; inc(n1[i]);
        Break;
      end;
    end;
  end;

begin
Pointer(arr) := arh;
for i:=0 to 15 do  begin
  n1[i]:=0;
  s1[i]:=0;
  sr1[i]:=0;
end;
Try

 // готовим диапозон
  SetLength(ranges, 16);
  for I := 0 to 15 do
  begin
    SetLength(ranges[I], 2);
  end;
  //Заполняем
  for d:=2 to 16 do
  begin
   MyComponent := Form4.FindComponent('Edit'+IntToStr(d-1));
   MyComponent1 := Form4.FindComponent('Edit'+IntToStr(d));
   if MyComponent <> nil then if d=16 then begin
   SetRangeValue(d-1, TEdit(MyComponent), TEdit(MyComponent1));
   SetRangeValue(15, TEdit(MyComponent1), TEdit(MyComponent1));
   end else  SetRangeValue(d-1, TEdit(MyComponent), TEdit(MyComponent1));
  end;
  // проверяем значения
  for I := 0 to N do begin
  begin
    cs := Floor(arr[0, I] / 1);
    ProcessRangeValue(cs,i);
  end;
  end
Except
      ShowMessage('Неизвестная ошибка');
  end;

//Нахождение среднего арифметического и перевод в сотые
for i := 0 to 15 do
 begin
   if n1[i]>0 then begin
   sr1[i]:=(s1[i]/n1[i]);
   end;
 end;
/// Выбираем поле куда вставлять значения
for i:= 2 to form1.stringGrid2.Rowcount do begin
Flag := Integer(form1.StringGrid2.Rows[i-1].Objects[k]);
if not (sr1[i-2]=0) and (Flag<>4) then begin
//array[столбец,строка]
  zn:=strtofloat(form1.stringGrid2.Cells[k,i-1])+sr1[i-2];
  znac:=floattostrf(zn,fffixed,3,2);
     if (zn<0) or (zn>2)then begin
        MessageDlg('Ошибка, выход за границы диапазона',mtError, mbOKCancel, 0);
           //Cells[i, j] := st;      //Оставлять старое значение
          form1.StringGrid2.Cells[k,i-1] := '0.00';         //Менять на 0
          form1.StringGrid2.Rows[i-1].Objects[k] := TObject(5);
         end
    else
     if not (form1.stringGrid2.Cells[k,i-1]=znac) then
    begin
        nvhod[k,i-2]:=n1[i-2];
       if not (Flag=4) then stsum[k,i-2]:=sr1[i-2];
      form1.StringGrid2.Rows[i-1].Objects[k] := TObject(2);
      form1.stringGrid2.Cells[k,i-1]:=znac;
    end;
end;
end;

znac:='';
arr:=nil;
for i:=0 to 15 do  begin
  n1[i]:=0;
  s1[i]:=0;
  sr1[i]:=0;
end;
end;

(******************************************************************************)

procedure TForm1.N10Click(Sender: TObject);   //Запуск пересчета значений
var i:integer; OldCursor: TCursor;
logname,lname,eename,ee:string;
buttonSelected:integer;
begin
buttonSelected:= MessageDlg('Запустить Online редактирование?',mtInformation, [mbYes,mbCancel], 0);
   if buttonSelected = mrYes    then begin
 OldCursor := Screen.Cursor;
 //Screen.Cursor := crHourGlass;
//
 // Screen.Cursor := OldCursor;
    // form1.Caption:=form1.Caption+ ' - Изменено';
     Button3.Enabled:=true;
     N3DPlot1.Enabled:=true;
     N3DPlot2.Enabled:=true;
     N10.Enabled:=false;
   end;


end;
(******************************************************************************)
procedure TForm1.N12Click(Sender: TObject);
var f1:textfile; i,j,iTmp: Integer; st,fname:string;
begin
  OpenDialog3.InitialDir := form2.Edit2.Text;
// Разрешаем сохранять файлы типа .txt и .doc
  OpenDialog3.Filter := 'VE Text|*.txt|';

  // Установка расширения по умолчанию
 OpenDialog3.DefaultExt := '*.txt';

  // Выбор текстовых файлов как стартовый тип фильтра
 OpenDialog3.FilterIndex := 1;
openDialog3.InitialDir := form2.Edit1.Text;

if Form1.OpenDialog3.Execute then begin//если выбран файл
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
         MessageDlg('Ошибка, выход за границы диапазона',mtError, mbOKCancel, 0);
         //Cells[i, j] := st;      //Оставлять старое значение
         Cells[i, j] := '0.00';         //Менять на 0
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

