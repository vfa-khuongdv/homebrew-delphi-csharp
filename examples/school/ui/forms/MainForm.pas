unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.Samples.Spin, Vcl.Menus,
  SchoolManager, StudentManager, TeacherManager, CourseManager,
  StudentModels, TeacherModels, CourseModels;

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    
    // Student Tab Controls
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtStudentId: TEdit;
    edtFirstName: TEdit;
    edtLastName: TEdit;
    edtEmail: TEdit;
    
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cmbGrade: TComboBox;
    edtClassName: TEdit;
    dtpDateOfBirth: TDateTimePicker;
    edtPhoneNumber: TEdit;
    
    btnAddStudent: TButton;
    btnEditStudent: TButton;
    btnDeleteStudent: TButton;
    btnClearStudent: TButton;
    StringGrid1: TStringGrid;
    
    // Teacher Tab Controls
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edtTeacherId: TEdit;
    edtTeacherFirstName: TEdit;
    edtTeacherLastName: TEdit;
    edtTeacherEmail: TEdit;
    cmbDepartment: TComboBox;
    
    GroupBox4: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    edtSubject: TEdit;
    edtSalary: TEdit;
    dtpTeacherDOB: TDateTimePicker;
    dtpHireDate: TDateTimePicker;
    edtTeacherPhone: TEdit;
    
    btnAddTeacher: TButton;
    btnEditTeacher: TButton;
    btnDeleteTeacher: TButton;
    StringGrid2: TStringGrid;
    
    // Course Tab Controls
    GroupBox5: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    edtCourseId: TEdit;
    edtCourseName: TEdit;
    cmbCourseDepartment: TComboBox;
    spnCredits: TSpinEdit;
    cmbInstructor: TComboBox;
    
    GroupBox6: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    edtSchedule: TEdit;
    edtClassroom: TEdit;
    spnMaxEnrollment: TSpinEdit;
    memoDescription: TMemo;
    
    btnAddCourse: TButton;
    btnEditCourse: TButton;
    btnDeleteCourse: TButton;
    StringGrid3: TStringGrid;
    
    // Common Controls
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    SelectAll1: TMenuItem;
    Copy1: TMenuItem;
    N2: TMenuItem;
    Find1: TMenuItem;
    Tools1: TMenuItem;
    GenerateReports1: TMenuItem;
    ImportData1: TMenuItem;
    ExportData1: TMenuItem;
    N3: TMenuItem;
    Settings1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    
    // Form Events
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    
    // Student Events
    procedure btnAddStudentClick(Sender: TObject);
    procedure btnEditStudentClick(Sender: TObject);
    procedure btnDeleteStudentClick(Sender: TObject);
    procedure btnClearStudentClick(Sender: TObject);
    
    // Teacher Events
    procedure btnAddTeacherClick(Sender: TObject);
    procedure btnEditTeacherClick(Sender: TObject);
    procedure btnDeleteTeacherClick(Sender: TObject);
    
    // Course Events
    procedure btnAddCourseClick(Sender: TObject);
    procedure btnEditCourseClick(Sender: TObject);
    procedure btnDeleteCourseClick(Sender: TObject);
    
    // Menu Events
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure GenerateReports1Click(Sender: TObject);
    procedure ImportData1Click(Sender: TObject);
    procedure ExportData1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    
  private
    { Private declarations }
    FSchoolManager: TSchoolManager;
    FCurrentStudentRow: Integer;
    FCurrentTeacherRow: Integer;
    FCurrentCourseRow: Integer;
    
    // Student methods
    procedure InitializeStudentGrid;
    procedure RefreshStudentGrid;
    procedure ClearStudentFields;
    function ValidateStudentData: Boolean;
    procedure LoadStudentFromGrid(ARow: Integer);
    
    // Teacher methods
    procedure InitializeTeacherGrid;
    procedure RefreshTeacherGrid;
    procedure ClearTeacherFields;
    function ValidateTeacherData: Boolean;
    procedure LoadTeacherFromGrid(ARow: Integer);
    procedure LoadInstructorComboBox;
    
    // Course methods
    procedure InitializeCourseGrid;
    procedure RefreshCourseGrid;
    procedure ClearCourseFields;
    function ValidateCourseData: Boolean;
    procedure LoadCourseFromGrid(ARow: Integer);
    
    // Common methods
    procedure UpdateStatusBar;
    procedure ShowMessage(const AMessage: string);
    procedure ShowError(const AError: string);
    
  public
    { Public declarations }
    property SchoolManager: TSchoolManager read FSchoolManager;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  StudentValidators, TeacherValidators, CourseValidators;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FSchoolManager := TSchoolManager.Create('Demo High School', 'DHS001');
  FCurrentStudentRow := -1;
  FCurrentTeacherRow := -1;
  FCurrentCourseRow := -1;
  
  InitializeStudentGrid;
  InitializeTeacherGrid;
  InitializeCourseGrid;
  
  LoadInstructorComboBox;
  UpdateStatusBar;
  
  // Set default dates
  dtpDateOfBirth.Date := Now - (18 * 365); // 18 years ago
  dtpTeacherDOB.Date := Now - (30 * 365);  // 30 years ago
  dtpHireDate.Date := Now;
  
  ShowMessage('School Management System initialized successfully!');
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FSchoolManager.Free;
end;

// Student Grid Management
procedure TMainForm.InitializeStudentGrid;
begin
  with StringGrid1 do
  begin
    Cells[0, 0] := 'Student ID';
    Cells[1, 0] := 'First Name';
    Cells[2, 0] := 'Last Name';
    Cells[3, 0] := 'Email';
    Cells[4, 0] := 'Grade';
    Cells[5, 0] := 'Class';
    Cells[6, 0] := 'Date of Birth';
    Cells[7, 0] := 'Phone';
    
    RowCount := 1;
  end;
end;

procedure TMainForm.RefreshStudentGrid;
var
  Students: TObjectList<TStudent>;
  I: Integer;
  Student: TStudent;
begin
  Students := FSchoolManager.StudentManager.GetStudentsByGrade(0); // Get all students
  try
    with StringGrid1 do
    begin
      RowCount := Students.Count + 1;
      
      for I := 0 to Students.Count - 1 do
      begin
        Student := Students[I];
        Cells[0, I + 1] := Student.StudentId;
        Cells[1, I + 1] := Student.FirstName;
        Cells[2, I + 1] := Student.LastName;
        Cells[3, I + 1] := Student.Email;
        Cells[4, I + 1] := IntToStr(Student.Grade);
        Cells[5, I + 1] := Student.ClassName;
        Cells[6, I + 1] := DateToStr(Student.DateOfBirth);
        Cells[7, I + 1] := Student.PhoneNumber;
      end;
    end;
  finally
    Students.Free;
  end;
end;

procedure TMainForm.btnAddStudentClick(Sender: TObject);
var
  Student: TStudent;
begin
  if not ValidateStudentData then
    Exit;
    
  Student := TStudent.Create;
  try
    Student.StudentId := edtStudentId.Text;
    Student.FirstName := edtFirstName.Text;
    Student.LastName := edtLastName.Text;
    Student.Email := edtEmail.Text;
    Student.Grade := StrToIntDef(cmbGrade.Text, 1);
    Student.ClassName := edtClassName.Text;
    Student.DateOfBirth := dtpDateOfBirth.Date;
    Student.PhoneNumber := edtPhoneNumber.Text;
    
    if FSchoolManager.StudentManager.AddStudent(Student) then
    begin
      RefreshStudentGrid;
      ClearStudentFields;
      UpdateStatusBar;
      ShowMessage('Student added successfully!');
    end
    else
    begin
      Student.Free;
      ShowError('Failed to add student. Student ID may already exist.');
    end;
  except
    on E: Exception do
    begin
      Student.Free;
      ShowError('Error adding student: ' + E.Message);
    end;
  end;
end;

procedure TMainForm.btnEditStudentClick(Sender: TObject);
var
  Student: TStudent;
  UpdatedStudent: TStudent;
begin
  if FCurrentStudentRow < 0 then
  begin
    ShowError('Please select a student to edit.');
    Exit;
  end;
  
  if not ValidateStudentData then
    Exit;
    
  Student := FSchoolManager.StudentManager.FindStudent(StringGrid1.Cells[0, FCurrentStudentRow + 1]);
  if Student = nil then
  begin
    ShowError('Student not found.');
    Exit;
  end;
  
  UpdatedStudent := TStudent.Create;
  try
    UpdatedStudent.StudentId := edtStudentId.Text;
    UpdatedStudent.FirstName := edtFirstName.Text;
    UpdatedStudent.LastName := edtLastName.Text;
    UpdatedStudent.Email := edtEmail.Text;
    UpdatedStudent.Grade := StrToIntDef(cmbGrade.Text, 1);
    UpdatedStudent.ClassName := edtClassName.Text;
    UpdatedStudent.DateOfBirth := dtpDateOfBirth.Date;
    UpdatedStudent.PhoneNumber := edtPhoneNumber.Text;
    
    if FSchoolManager.StudentManager.UpdateStudent(Student.StudentId, UpdatedStudent) then
    begin
      RefreshStudentGrid;
      ClearStudentFields;
      UpdateStatusBar;
      ShowMessage('Student updated successfully!');
    end
    else
    begin
      ShowError('Failed to update student.');
    end;
  finally
    UpdatedStudent.Free;
  end;
end;

procedure TMainForm.btnDeleteStudentClick(Sender: TObject);
var
  StudentId: string;
begin
  if FCurrentStudentRow < 0 then
  begin
    ShowError('Please select a student to delete.');
    Exit;
  end;
  
  StudentId := StringGrid1.Cells[0, FCurrentStudentRow + 1];
  
  if MessageDlg(Format('Are you sure you want to delete student "%s"?', [StudentId]),
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if FSchoolManager.StudentManager.RemoveStudent(StudentId) then
    begin
      RefreshStudentGrid;
      ClearStudentFields;
      UpdateStatusBar;
      ShowMessage('Student deleted successfully!');
    end
    else
    begin
      ShowError('Failed to delete student.');
    end;
  end;
end;

procedure TMainForm.btnClearStudentClick(Sender: TObject);
begin
  ClearStudentFields;
  FCurrentStudentRow := -1;
end;

procedure TMainForm.ClearStudentFields;
begin
  edtStudentId.Text := '';
  edtFirstName.Text := '';
  edtLastName.Text := '';
  edtEmail.Text := '';
  cmbGrade.ItemIndex := -1;
  edtClassName.Text := '';
  dtpDateOfBirth.Date := Now - (18 * 365);
  edtPhoneNumber.Text := '';
end;

function TMainForm.ValidateStudentData: Boolean;
var
  Validator: TStudentValidator;
  Student: TStudent;
  Errors: TArray<string>;
  ErrorMsg: string;
  I: Integer;
begin
  Result := False;
  
  // Basic field validation
  if Trim(edtStudentId.Text) = '' then
  begin
    ShowError('Student ID is required.');
    edtStudentId.SetFocus;
    Exit;
  end;
  
  if Trim(edtFirstName.Text) = '' then
  begin
    ShowError('First Name is required.');
    edtFirstName.SetFocus;
    Exit;
  end;
  
  if Trim(edtLastName.Text) = '' then
  begin
    ShowError('Last Name is required.');
    edtLastName.SetFocus;
    Exit;
  end;
  
  // Create temporary student for validation
  Student := TStudent.Create;
  Validator := TStudentValidator.Create;
  try
    Student.StudentId := edtStudentId.Text;
    Student.FirstName := edtFirstName.Text;
    Student.LastName := edtLastName.Text;
    Student.Email := edtEmail.Text;
    Student.Grade := StrToIntDef(cmbGrade.Text, 1);
    Student.ClassName := edtClassName.Text;
    Student.DateOfBirth := dtpDateOfBirth.Date;
    Student.PhoneNumber := edtPhoneNumber.Text;
    
    Errors := Validator.GetValidationErrors(Student);
    if Length(Errors) > 0 then
    begin
      ErrorMsg := 'Validation errors:' + #13#10;
      for I := 0 to High(Errors) do
        ErrorMsg := ErrorMsg + '- ' + Errors[I] + #13#10;
      
      ShowError(ErrorMsg);
      Exit;
    end;
    
    Result := True;
  finally
    Student.Free;
    Validator.Free;
  end;
end;

// Teacher methods (similar structure)
procedure TMainForm.btnAddTeacherClick(Sender: TObject);
begin
  // Implementation similar to btnAddStudentClick
  ShowMessage('Add Teacher functionality - to be implemented');
end;

procedure TMainForm.btnEditTeacherClick(Sender: TObject);
begin
  ShowMessage('Edit Teacher functionality - to be implemented');
end;

procedure TMainForm.btnDeleteTeacherClick(Sender: TObject);
begin
  ShowMessage('Delete Teacher functionality - to be implemented');
end;

// Course methods (similar structure)
procedure TMainForm.btnAddCourseClick(Sender: TObject);
begin
  ShowMessage('Add Course functionality - to be implemented');
end;

procedure TMainForm.btnEditCourseClick(Sender: TObject);
begin
  ShowMessage('Edit Course functionality - to be implemented');
end;

procedure TMainForm.btnDeleteCourseClick(Sender: TObject);
begin
  ShowMessage('Delete Course functionality - to be implemented');
end;

// Menu events
procedure TMainForm.New1Click(Sender: TObject);
begin
  if MessageDlg('Create new database? This will clear all current data.',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FSchoolManager.Free;
    FSchoolManager := TSchoolManager.Create('New School', 'NEW001');
    
    RefreshStudentGrid;
    RefreshTeacherGrid;
    RefreshCourseGrid;
    UpdateStatusBar;
    
    ShowMessage('New database created.');
  end;
end;

procedure TMainForm.Open1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    // Load database from file
    ShowMessage('Load database functionality - to be implemented');
  end;
end;

procedure TMainForm.Save1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    // Save database to file
    ShowMessage('Save database functionality - to be implemented');
  end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.SelectAll1Click(Sender: TObject);
begin
  ShowMessage('Select All functionality - to be implemented');
end;

procedure TMainForm.Copy1Click(Sender: TObject);
begin
  ShowMessage('Copy functionality - to be implemented');
end;

procedure TMainForm.Find1Click(Sender: TObject);
begin
  ShowMessage('Find functionality - to be implemented');
end;

procedure TMainForm.GenerateReports1Click(Sender: TObject);
begin
  ShowMessage('Generate Reports functionality - to be implemented');
end;

procedure TMainForm.ImportData1Click(Sender: TObject);
begin
  ShowMessage('Import Data functionality - to be implemented');
end;

procedure TMainForm.ExportData1Click(Sender: TObject);
begin
  ShowMessage('Export Data functionality - to be implemented');
end;

procedure TMainForm.Settings1Click(Sender: TObject);
begin
  ShowMessage('Settings functionality - to be implemented');
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  ShowMessage('School Management System v1.0' + #13#10 +
              'Developed with Delphi' + #13#10 +
              'Copyright (c) 2025');
end;

// Helper methods
procedure TMainForm.InitializeTeacherGrid;
begin
  with StringGrid2 do
  begin
    Cells[0, 0] := 'Teacher ID';
    Cells[1, 0] := 'First Name';
    Cells[2, 0] := 'Last Name';
    Cells[3, 0] := 'Email';
    Cells[4, 0] := 'Department';
    Cells[5, 0] := 'Subject';
    Cells[6, 0] := 'Salary';
    Cells[7, 0] := 'Hire Date';
    Cells[8, 0] := 'Phone';
    
    RowCount := 1;
  end;
end;

procedure TMainForm.InitializeCourseGrid;
begin
  with StringGrid3 do
  begin
    Cells[0, 0] := 'Course ID';
    Cells[1, 0] := 'Course Name';
    Cells[2, 0] := 'Department';
    Cells[3, 0] := 'Credits';
    Cells[4, 0] := 'Instructor';
    Cells[5, 0] := 'Schedule';
    Cells[6, 0] := 'Classroom';
    Cells[7, 0] := 'Enrollment';
    
    RowCount := 1;
  end;
end;

procedure TMainForm.RefreshTeacherGrid;
begin
  // Implementation for refreshing teacher grid
end;

procedure TMainForm.RefreshCourseGrid;
begin
  // Implementation for refreshing course grid
end;

procedure TMainForm.ClearTeacherFields;
begin
  // Implementation for clearing teacher fields
end;

procedure TMainForm.ClearCourseFields;
begin
  // Implementation for clearing course fields
end;

function TMainForm.ValidateTeacherData: Boolean;
begin
  Result := True; // Placeholder
end;

function TMainForm.ValidateCourseData: Boolean;
begin
  Result := True; // Placeholder
end;

procedure TMainForm.LoadStudentFromGrid(ARow: Integer);
begin
  // Implementation for loading student from grid
end;

procedure TMainForm.LoadTeacherFromGrid(ARow: Integer);
begin
  // Implementation for loading teacher from grid
end;

procedure TMainForm.LoadCourseFromGrid(ARow: Integer);
begin
  // Implementation for loading course from grid
end;

procedure TMainForm.LoadInstructorComboBox;
begin
  // Load teachers into instructor combobox
  cmbInstructor.Items.Clear;
  cmbInstructor.Items.Add('John Smith');
  cmbInstructor.Items.Add('Mary Johnson');
  cmbInstructor.Items.Add('Robert Brown');
end;

procedure TMainForm.UpdateStatusBar;
begin
  StatusBar1.Panels[0].Text := 'Ready';
  StatusBar1.Panels[1].Text := Format('Students: %d', [FSchoolManager.GetTotalStudents]);
  StatusBar1.Panels[2].Text := Format('Teachers: %d', [FSchoolManager.GetTotalTeachers]);
  StatusBar1.Panels[3].Text := Format('Courses: %d', [FSchoolManager.GetTotalCourses]);
end;

procedure TMainForm.ShowMessage(const AMessage: string);
begin
  Vcl.Dialogs.ShowMessage(AMessage);
end;

procedure TMainForm.ShowError(const AError: string);
begin
  MessageDlg(AError, mtError, [mbOK], 0);
end;

end.
