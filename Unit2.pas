unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,IniFiles, FileCtrl,PDirSelected, CPortCtl, CPort;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    DirDialog1: TDirDialog;
    ComPort1: TComPort;
    ComComboBox2: TComComboBox;
    ComComboBox1: TComComboBox;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
 with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini') do
  begin
    WriteString('DIR', 'COMB', inttostr(ComComboBox2.itemindex));
    WriteString('DIR', 'COMP', inttostr(ComComboBox1.itemindex));
    WriteString('POINTS', 'ENABLED', inttostr(Ord(checkbox1.Checked)));
    Free;
  end;
  form2.close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini') do
  begin
    ComComboBox2.itemindex := strtoint(ReadString('DIR', 'COMB', ''));
    ComComboBox1.itemindex := strtoint(ReadString('DIR', 'COMP', ''));
    if ReadString('POINTS', 'ENABLED', '')<>'0' then checkbox1.Checked:=true;
    Free;
  end;
end;


end.
