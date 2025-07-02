unit StudentDetailsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, StudentModels, StudentValidators;

type
  TStudentDetailsForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    
    // Personal Information Tab
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edtStudentId: TEdit;
    edtFirstName: TEdit;
    edtLastName: TEdit;
    edtFullName: TEdit;
    dtpDateOfBirth: TDateTimePicker;
    edtAge: TEdit;
    cmbGrade: TComboBox;
    edtClassName: TEdit;
    edtEmail: TEdit;
    edtPhoneNumber: TEdit;
    
    // Address Information
    GroupBox2: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    edtAddress: TEdit;
    edtCity: TEdit;
    edtState: TEdit;
    edtZipCode: TEdit;
    cmbCountry: TComboBox;
    edtEmergencyContact: TEdit;
    edtEmergencyPhone: TEdit;
    cmbRelationship: TComboBox;
    
    // Academic Information Tab
    GroupBox3: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    dtpEnrollmentDate: TDateTimePicker;
    edtAcademicYear: TEdit;
    edtGPA: TEdit;
    cmbStatus: TComboBox;
    edtCreditsEarned: TEdit;
    edtCreditsRequired: TEdit;
    dtpExpectedGradDate: TDateTimePicker;
    
    GroupBox4: TGroupBox;
    ListView1: TListView;
    btnAddCourse: TButton;
    btnRemoveCourse: TButton;
    btnViewGrades: TButton;
    
    // Notes Tab
    GroupBox5: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    memoNotes: TMemo;
    memoComments: TMemo;
    
    // Bottom Panel
    Panel1: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    
    // Form Events
    procedure FormCreate(Sender: TObject);
    procedure dtpDateOfBirthChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnAddCourseClick(Sender: TObject);
    procedure btnRemoveCourseClick(Sender: TObject);
    procedure btnViewGradesClick(Sender: TObject);
    procedure edtFirstNameChange(Sender: TObject);
    procedure edtLastNameChange(Sender: TObject);
    
  private
    { Private declarations }
    FStudent: TStudent;
    FValidator: TStudentValidator;
    FIsModified: Boolean;
    
    procedure UpdateFullName;
    procedure CalculateAge;
    procedure InitializeForm;
    procedure LoadStudentData;
    procedure SaveStudentData;
    function ValidateData: Boolean;
    procedure ShowValidationErrors(const AErrors: TArray<string>);
    procedure SetModified(const AValue: Boolean);
    procedure UpdateCourseList;
    
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AStudent: TStudent = nil); overload;
    destructor Destroy; override;
    
    property Student: TStudent read FStudent write FStudent;
    property IsModified: Boolean read FIsModified;
    
    class function ShowStudentDialog(AOwner: TComponent; AStudent: TStudent = nil): TModalResult;
  end;

var
  StudentDetailsForm: TStudentDetailsForm;

implementation

{$R *.dfm}

uses
  System.DateUtils, Vcl.Dialogs;

constructor TStudentDetailsForm.Create(AOwner: TComponent; AStudent: TStudent);
begin
  inherited Create(AOwner);
  FValidator := TStudentValidator.Create;
  FIsModified := False;
  
  if Assigned(AStudent) then
  begin
    FStudent := TStudent.Create;
    FStudent.Assign(AStudent);
  end
  else
  begin
    FStudent := TStudent.Create;
  end;
  
  InitializeForm;
  LoadStudentData;
end;

destructor TStudentDetailsForm.Destroy;
begin
  FStudent.Free;
  FValidator.Free;
  inherited Destroy;
end;

class function TStudentDetailsForm.ShowStudentDialog(AOwner: TComponent; AStudent: TStudent): TModalResult;
var
  Dialog: TStudentDetailsForm;
begin
  Dialog := TStudentDetailsForm.Create(AOwner, AStudent);
  try
    Result := Dialog.ShowModal;
    if (Result = mrOk) and Assigned(AStudent) then
      AStudent.Assign(Dialog.Student);
  finally
    Dialog.Free;
  end;
end;

procedure TStudentDetailsForm.FormCreate(Sender: TObject);
begin
  // Additional initialization if needed
  Caption := 'Student Details - ' + FStudent.GetFullName;
end;

procedure TStudentDetailsForm.InitializeForm;
begin
  // Initialize combo boxes
  cmbGrade.Items.Clear;
  cmbGrade.Items.AddStrings(['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12']);
  
  cmbCountry.Items.Clear;
  cmbCountry.Items.AddStrings(['United States', 'Canada', 'United Kingdom', 
    'Australia', 'Germany', 'France', 'Japan', 'Other']);
  
  cmbRelationship.Items.Clear;
  cmbRelationship.Items.AddStrings(['Parent', 'Guardian', 'Sibling', 'Grandparent', 'Other']);
  
  cmbStatus.Items.Clear;
  cmbStatus.Items.AddStrings(['Active', 'Inactive', 'Suspended', 'Graduated', 'Transferred', 'Withdrawn']);
  
  // Initialize ListView columns
  with ListView1 do
  begin
    Columns.Clear;
    Columns.Add.Caption := 'Course ID';
    Columns.Add.Caption := 'Course Name';
    Columns.Add.Caption := 'Credits';
    Columns.Add.Caption := 'Grade';
    Columns.Add.Caption := 'Status';
    Columns.Add.Caption := 'Semester';
    
    Columns[0].Width := 80;
    Columns[1].Width := 200;
    Columns[2].Width := 60;
    Columns[3].Width := 60;
    Columns[4].Width := 80;
    Columns[5].Width := 70;
  end;
  
  // Set default dates
  dtpDateOfBirth.Date := Now - (18 * 365); // 18 years ago
  dtpEnrollmentDate.Date := Now - (365 * 2); // 2 years ago
  dtpExpectedGradDate.Date := Now + (365 * 2); // 2 years from now
end;

procedure TStudentDetailsForm.LoadStudentData;
begin
  if not Assigned(FStudent) then
    Exit;
    
  // Personal Information
  edtStudentId.Text := FStudent.StudentId;
  edtFirstName.Text := FStudent.FirstName;
  edtLastName.Text := FStudent.LastName;
  edtEmail.Text := FStudent.Email;
  edtPhoneNumber.Text := FStudent.PhoneNumber;
  
  if FStudent.DateOfBirth > 0 then
    dtpDateOfBirth.Date := FStudent.DateOfBirth;
    
  cmbGrade.ItemIndex := cmbGrade.Items.IndexOf(IntToStr(FStudent.Grade));
  edtClassName.Text := FStudent.ClassName;
  
  UpdateFullName;
  CalculateAge;
  UpdateCourseList;
  
  SetModified(False);
end;

procedure TStudentDetailsForm.SaveStudentData;
begin
  if not Assigned(FStudent) then
    Exit;
    
  // Save personal information
  FStudent.StudentId := edtStudentId.Text;
  FStudent.FirstName := edtFirstName.Text;
  FStudent.LastName := edtLastName.Text;
  FStudent.Email := edtEmail.Text;
  FStudent.PhoneNumber := edtPhoneNumber.Text;
  FStudent.DateOfBirth := dtpDateOfBirth.Date;
  FStudent.Grade := StrToIntDef(cmbGrade.Text, 1);
  FStudent.ClassName := edtClassName.Text;
  
  SetModified(False);
end;

procedure TStudentDetailsForm.UpdateFullName;
begin
  edtFullName.Text := Trim(edtFirstName.Text + ' ' + edtLastName.Text);
end;

procedure TStudentDetailsForm.CalculateAge;
var
  Age: Integer;
begin
  Age := YearsBetween(Now, dtpDateOfBirth.Date);
  edtAge.Text := IntToStr(Age);
end;

procedure TStudentDetailsForm.dtpDateOfBirthChange(Sender: TObject);
begin
  CalculateAge;
  SetModified(True);
end;

procedure TStudentDetailsForm.edtFirstNameChange(Sender: TObject);
begin
  UpdateFullName;
  SetModified(True);
end;

procedure TStudentDetailsForm.edtLastNameChange(Sender: TObject);
begin
  UpdateFullName;
  SetModified(True);
end;

function TStudentDetailsForm.ValidateData: Boolean;
var
  TempStudent: TStudent;
  Errors: TArray<string>;
begin
  Result := False;
  
  // Create temporary student for validation
  TempStudent := TStudent.Create;
  try
    TempStudent.StudentId := edtStudentId.Text;
    TempStudent.FirstName := edtFirstName.Text;
    TempStudent.LastName := edtLastName.Text;
    TempStudent.Email := edtEmail.Text;
    TempStudent.PhoneNumber := edtPhoneNumber.Text;
    TempStudent.DateOfBirth := dtpDateOfBirth.Date;
    TempStudent.Grade := StrToIntDef(cmbGrade.Text, 1);
    TempStudent.ClassName := edtClassName.Text;
    
    Errors := FValidator.GetValidationErrors(TempStudent);
    if Length(Errors) > 0 then
    begin
      ShowValidationErrors(Errors);
      Exit;
    end;
    
    Result := True;
  finally
    TempStudent.Free;
  end;
end;

procedure TStudentDetailsForm.ShowValidationErrors(const AErrors: TArray<string>);
var
  ErrorMsg: string;
  I: Integer;
begin
  ErrorMsg := 'Please correct the following errors:' + #13#10#13#10;
  for I := 0 to High(AErrors) do
    ErrorMsg := ErrorMsg + '• ' + AErrors[I] + #13#10;
    
  MessageDlg(ErrorMsg, mtError, [mbOK], 0);
end;

procedure TStudentDetailsForm.SetModified(const AValue: Boolean);
begin
  FIsModified := AValue;
  
  // Update caption to show modified state
  if FIsModified then
    Caption := 'Student Details - ' + FStudent.GetFullName + ' *'
  else
    Caption := 'Student Details - ' + FStudent.GetFullName;
    
  btnApply.Enabled := FIsModified;
end;

procedure TStudentDetailsForm.UpdateCourseList;
var
  I: Integer;
  ListItem: TListItem;
begin
  ListView1.Items.Clear;
  
  if not Assigned(FStudent) then
    Exit;
    
  // Add enrolled courses to ListView
  for I := 0 to FStudent.EnrolledCourses.Count - 1 do
  begin
    ListItem := ListView1.Items.Add;
    ListItem.Caption := FStudent.EnrolledCourses[I];
    ListItem.SubItems.Add('Course Name ' + IntToStr(I + 1));
    ListItem.SubItems.Add('3');
    ListItem.SubItems.Add(Format('%.1f', [FStudent.GetGrade(FStudent.EnrolledCourses[I])]));
    ListItem.SubItems.Add('Active');
    ListItem.SubItems.Add('Fall 2024');
  end;
end;

procedure TStudentDetailsForm.btnSaveClick(Sender: TObject);
begin
  if ValidateData then
  begin
    SaveStudentData;
    ModalResult := mrOk;
  end;
end;

procedure TStudentDetailsForm.btnCancelClick(Sender: TObject);
begin
  if FIsModified then
  begin
    case MessageDlg('You have unsaved changes. Do you want to save them?',
                    mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        begin
          if ValidateData then
          begin
            SaveStudentData;
            ModalResult := mrOk;
          end;
        end;
      mrNo:
        ModalResult := mrCancel;
      mrCancel:
        Exit;
    end;
  end
  else
    ModalResult := mrCancel;
end;

procedure TStudentDetailsForm.btnApplyClick(Sender: TObject);
begin
  if ValidateData then
  begin
    SaveStudentData;
    ShowMessage('Changes saved successfully!');
  end;
end;

procedure TStudentDetailsForm.btnAddCourseClick(Sender: TObject);
begin
  // Implementation for adding courses
  ShowMessage('Add Course functionality - to be implemented');
end;

procedure TStudentDetailsForm.btnRemoveCourseClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  begin
    if MessageDlg('Remove selected course?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      ListView1.DeleteSelected;
      SetModified(True);
    end;
  end
  else
    ShowMessage('Please select a course to remove.');
end;

procedure TStudentDetailsForm.btnViewGradesClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then
    ShowMessage('View Grades for: ' + ListView1.Selected.Caption)
  else
    ShowMessage('Please select a course to view grades.');
end;

end.
