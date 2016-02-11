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
