unit StudentManagement;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.JSON,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls,
  Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup, Vcl.ComCtrls,
  Vcl.ToolWin, Vcl.Bind.Editors, Vcl.Bind.DBEngExt, FileCtrl, Data.Bind.EngExt,
  System.Rtti, System.Bindings.Outputs, Data.Bind.Components,
  System.ImageList, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.IOUtils, System.Actions, Vcl.ActnList,
  Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus;

type
  TDb = class(TObject)
  private
    JsonData                :TJSONObject;
    Students                :TJSONArray;
    Classes                 :TJSONArray;
    Scores                  :TJSONObject;
    IsUpdated               :Boolean;

  public

    constructor Create(FileName :string); overload;
    destructor  Destroy; overload;

    procedure LoadData(FileName :string);
    procedure SaveData(FileName :string);

    function  GetScore(StudentName: string; ClassName: string): Integer;
    procedure UpdateScore(StudentName: string; ClassName: string; Score: Integer);

    function  GetStudent(index: Integer): string;
    procedure PostStudent(StudentName: string);
    procedure DeleteStudent(index: Integer);
    function  StudentCount(): Integer;

    function  GetClass(index: Integer): string;
    procedure PostClass(ClassName: string);
    procedure DeleteClass(index: Integer);
    function  ClassCount(): Integer;

    function  GetClassAvg(ClassName: string)     :Double;
    function  GetStudentAvg(StudentName: string) :Double;
  end;

  TForm4 = class(TForm)
    ListBox_students        :TListBox;
    ListBox_classes         :TListBox;
    Edit_score              :TEdit;
    Edit_avgStudentScore    :TEdit;
    Edit_avgClassScore      :TEdit;
    Edit_addStudent         :TEdit;
    Edit_addClass           :TEdit;
    Label1                  :TLabel;
    Label2                  :TLabel;
    Label3                  :TLabel;
    Label4                  :TLabel;
    Label_student           :TLabel;
    Label_class             :TLabel;
    BindingsList1           :TBindingsList;
    Btn_updateStudentScore  :TButton;
    Btn_addStudent          :TButton;
    Btn_addClass            :TButton;
    Btn_deleteStudent       :TButton;
    Btn_deleteClass         :TButton;

    MainMenu                :TMainMenu;
    Open1                   :TMenuItem;
    File1                   :TMenuItem;
    Save1                   :TMenuItem;
    SaveAs1                 :TMenuItem;

    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;

    LinkFillControlToPropertyCaption: TLinkFillControlToProperty;
    LinkFillControlToPropertyCaption2: TLinkFillControlToProperty;

    ActionManager1: TActionManager;
    Action_open: TAction;
    Action_Save: TAction;
    Action_SaveAs: TAction;

    procedure FormCreate(Sender: TObject);
    procedure Btn_addStudentClick(Sender: TObject);
    procedure Btn_updateStudentScoreClick(Sender: TObject);
    procedure Btn_addClassClick(Sender: TObject);
    procedure Btn_saveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

    procedure OnStudentSelectionChange(Sender: TObject);
    procedure OnClassSelectionChange(Sender: TObject);
    procedure Btn_deleteStudentClick(Sender: TObject);
    procedure Btn_deleteClassClick(Sender: TObject);

    procedure LoadData(FileName :string);
    procedure SaveData(FileName :string);
    procedure Action_openExecute(Sender: TObject);
    procedure Action_SaveExecute(Sender: TObject);
    procedure Action_SaveAsExecute(Sender: TObject);

  private
    Scores                  :TJSONObject;
    DbPath                  :String;
    Db                      :TDb;

  public
    { Public devlarations }
  end;
var
  Form4   :TForm4;

implementation

{$R *.dfm}

//TDB
constructor TDb.Create(FileName: string);
begin
  LoadData(FileName);
end;

destructor TDb.Destroy();
begin
  //????
  Scores.Destroy();
  Classes.Destroy();
  Students.Destroy();
  JsonData.Destroy();
end;

procedure TDb.SaveData(FileName: String);
var
  FileStream    :TFileStream;
  byts          :Tarray<Byte>;
  I             :string;
begin
  byts          := TEncoding.UTF8.GetBytes(JsonData.Format(2));
  FileStream    := TFileStream.Create(FileName, fmCreate);

  FileStream.Write(byts, Length(byts));
  FileStream.Destroy;
  IsUpdated     := False;
end;

procedure TDb.LoadData(FileName: String);
var
  LoadedJsonData    :TJSONObject;
  LoadedJsonValue   :TJSONValue;
  FileStream        :TFileStream;
  StringStream      :TStringStream;
  I                 :Integer;
begin
  If FileExists(FileName) then
    FileStream      := TFileStream.Create(FileName, fmOpenRead)
  Else
    FileStream      := TFileStream.Create(FileName, fmCreate);

  StringStream      := TStringStream.Create;
  StringStream.CopyFrom(FileStream, FileStream.Size);
  StringStream.Position := 0;

  LoadedJsonValue   := TJSONObject.ParseJSONValue(StringStream.DataString);
  LoadedJsonData    := TJSONObject(LoadedJsonValue);

  Students          := LoadedJsonData.GetValue<TJSONArray>('students', TJSONarray.Create);
  Classes           := LoadedJsonData.GetValue<TJSONArray>('classes', TJSONarray.Create);
  Scores            := LoadedJsonData.GetValue<TJsonValue>('scores', TJSONObject.Create) as TJSONObject;
  JsonData          := TJSONObject.Create;

  JsonData.AddPair('students', Students);
  JsonData.AddPair('classes', Classes);
  JsonData.AddPair('scores', Scores);
  IsUpdated := false;

  //???
  FileStream.Destroy;
  StringStream.Destroy;
end;

function  TDb.GetScore(StudentName: string; ClassName: string): Integer;
begin
  Result := Scores.GetValue<TJSONObject>(StudentName)
                  .GetValue<Integer>(ClassName, -1);
end;

procedure TDb.UpdateScore(StudentName: string; ClassName: string; Score: Integer);
begin
  IsUpdated := True;
  Scores.GetValue<TJSONObject>(StudentName)
        .RemovePair(ClassName);

  Scores.GetValue<TJSONObject>(StudentName)
        .AddPair(ClassName, Score);
end;

function  TDb.StudentCount() :Integer;
begin
  Result := Students.Count;
end;

function  TDb.GetStudent(index: Integer) :string;
begin
  Result := Students.Items[index].Value;
end;

procedure TDb.PostStudent(StudentName: string);
begin
  IsUpdated := True;
  Students.Add(StudentName);
  Scores.AddPair(StudentName, TJSONObject.Create)
end;

procedure TDb.DeleteStudent(index: Integer);
begin
  IsUpdated := True;
  Scores.RemovePair(GetStudent(index));
  Students.Remove(index);
end;

function  TDb.GetClass(index: Integer) :string;
begin
  Result := Classes.Items[index].Value;
end;

procedure TDb.PostClass(ClassName: string);
begin
  IsUpdated := True;
  Classes.Add(ClassName);
end;

procedure TDb.DeleteClass(index: Integer);
var
  I: Integer;
begin
  IsUpdated := True;
  for I := 0 to StudentCount-1 do
    Scores.GetValue<TJSONObject>(GetStudent(I)).RemovePair(GetClass(index));

  Classes.Remove(index);
end;

function  TDb.ClassCount() :Integer;
begin
  Result := Classes.Count;
end;

function  TDb.GetClassAvg(ClassName: string) :Double;
var
  TotalScore,
  Count,
  Score,
  I         :Integer;
begin
  TotalScore  := 0;
  Count       := 0;

  for I := 0 to StudentCount()-1 do
  begin
    Score      := GetScore(GetStudent(I), ClassName);
    if Score = -1 then Continue;
    TotalScore := TotalScore + Score;
    Count      := Count + 1;
  end;

  if Count = 0 then
  begin
    Result := 0;
    Exit;
  end;

  Result := TotalScore / Count;
end;

function  TDb.GetStudentAvg(StudentName: string) :Double;
var
  TotalScore,
  Score,
  Count         :Integer;
  pair          :TJSONPair;
begin
  TotalScore    := 0;
  Count         := 0;

  for pair in Scores.GetValue<TJSONObject>(StudentName) do
  begin
    Score       := StrToInt(pair.JsonValue.Value);
    TotalScore  := TotalScore + Score;
    Count       := Count + 1;
  end;

  if Count = 0 then
  begin
    Result := 0;
    Exit;
  end;

  Result := TotalScore / Count;
end;

//TFORM
procedure TForm4.Action_openExecute(Sender: TObject);
begin
  Showmessage('openselected');
  if OpenDialog.Execute then
    LoadData(OpenDialog.FileName);
end;

procedure TForm4.Action_SaveAsExecute(Sender: TObject);
begin
  Showmessage('Save As executed');
  if SaveDialog.Execute then
    SaveData(SaveDialog.FileName);
end;

procedure TForm4.Action_SaveExecute(Sender: TObject);
begin
  ShowMessage('Save Executed');
  SaveData(DbPath);
end;

procedure TForm4.Btn_addClassClick(Sender: TObject);
var
ClassName       :string;
begin
  ClassName     := Trim(Edit_addClass.Text);
  if ClassName  = '' then Exit;

  Db.PostClass(ClassName);
  ListBox_classes.AddItem(ClassName, nil);
  Edit_addClass.Text := '';
end;

procedure TForm4.Btn_addStudentClick(Sender: TObject);
var
  StudentName   :string;
begin
  StudentName := Trim(Edit_addStudent.Text);
  if StudentName = '' then Exit;

  Db.PostStudent(StudentName);
  ListBox_students.AddItem(StudentName, nil);
  Edit_addStudent.Text := '';
end;

procedure TForm4.Btn_deleteClassClick(Sender: TObject);
begin
  Db.DeleteClass(ListBox_Classes.ItemIndex);
  ListBox_classes.DeleteSelected;
end;

procedure TForm4.Btn_deleteStudentClick(Sender: TObject);
begin
  Db.DeleteStudent(ListBox_students.ItemIndex);
  ListBox_students.DeleteSelected;
end;

procedure TForm4.Btn_saveClick(Sender: TObject);
begin
  Db.SaveData(DbPath);
end;

procedure TForm4.Btn_updateStudentScoreClick(Sender: TObject);
var
  ClassName,
  StudentName       :string;
  Score             :Integer;
begin
  Score             := StrToInt(Edit_score.Text);
  if (Score < 0) or (Score > 100) then
  begin
    ShowMessage('Scoure value must be between 0 and 100');
    exit;
  end;

  ClassName         := ListBox_classes.Items[ListBox_classes.ItemIndex];
  StudentName       := ListBox_students.Items[Listbox_students.ItemIndex];

  Db.UpdateScore(StudentName, ClassName, Score);
end;

procedure TForm4.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Selection :Integer;
begin
  if not Db.IsUpdated then Exit;

  Selection := MessageDlg('Do you want to save your changes?',
                  TMsgDlgType.mtWarning , [mbYes, mbNo, mbCancel], 0);

  if selection = mrYes then Db.SaveData(DbPath)
  else if selection = mrCancel then CanClose := False;
end;

procedure TForm4.FormCreate(Sender: TObject);
var
  I     :Integer;
begin
  DbPath  := 'C:\Users\deniz\OneDrive\Masa�st�\StudentManagement\db.json';
  LoadData(DbPath);
end;

procedure TForm4.OnClassSelectionChange(Sender: TObject);
var
  iClass,
  iStudent,
  Score             :Integer;
  AvgClassScore     :double;
  StudentName,
  ClassName         :string;
begin
  iClass            := ListBox_classes.ItemIndex;
  iStudent          := ListBox_students.ItemIndex;

  if (iClass < 0) or (iStudent < 0) then Exit;

  ClassName         := ListBox_classes.Items[iClass];
  StudentName       := ListBox_students.Items[iStudent];

  Score             := Db.GetScore(StudentName, ClassName);
  AvgClassScore     := Db.GetClassAvg(ClassName);

  Edit_avgClassScore.Text := FormatFloat('#00.##', AvgClassScore);
  Edit_score.Text   := IntToStr(Score);

end;

procedure TForm4.OnStudentSelectionChange(Sender: TObject);
var
  iClass,
  iStudent,
  Score             :Integer;
  AvgStudentScore   :double;
  StudentName,
  ClassName         :string;
begin
  iClass            := ListBox_classes.ItemIndex;
  iStudent          := ListBox_students.ItemIndex;

  if (iClass < 0) or (iStudent < 0) then Exit;

  ClassName         := ListBox_classes.Items[iClass];
  StudentName       := ListBox_students.Items[iStudent];

  Score             := Db.GetScore(StudentName, ClassName);
  AvgStudentScore   := Db.GetStudentAvg(StudentName);

  Edit_avgStudentScore .Text := FormatFloat('#00.##', AvgStudentScore);
  Edit_score.Text   := IntToStr(Score);
end;

procedure TForm4.LoadData(FileName :string);
var
  I     :Integer;
begin
  //Destroy vs Free
  if Assigned(Db) then Db.Free;

  DbPath  := FileName;
  Db      := TDb.Create(FileName);
  ListBox_students.Clear;
  ListBox_classes.Clear;
  for I := 0 to Db.StudentCount-1 do
    ListBox_students.AddItem(Db.GetStudent(I), nil);

  for I := 0 to Db.ClassCount-1 do
    ListBox_classes.AddItem(Db.GetClass(I), nil);
end;

procedure TForm4.SaveData(FileName :string);
begin
  DbPath := FileName;
  Db.SaveData(DbPath);
end;

// TODO
// load data t�rk�e karakter sorunu
// Tasar�m
// sort
// Ayn� dersi tekrar ekleme

// --de�i�im yap�lmad�ysa kaydetmeyi sorma
// --None numerik de�il ama update etmeyi deniyor
// --index bounds student V class -1
end.
