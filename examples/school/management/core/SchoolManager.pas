unit SchoolManager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  StudentManager, TeacherManager, CourseManager;

type
  TSchoolManager = class
  private
    FStudentManager: TStudentManager;
    FTeacherManager: TTeacherManager;
    FCourseManager: TCourseManager;
    FSchoolName: string;
    FSchoolCode: string;
  public
    constructor Create(const ASchoolName, ASchoolCode: string);
    destructor Destroy; override;
    
    // Property accessors
    property SchoolName: string read FSchoolName write FSchoolName;
    property SchoolCode: string read FSchoolCode write FSchoolCode;
    property StudentManager: TStudentManager read FStudentManager;
    property TeacherManager: TTeacherManager read FTeacherManager;
    property CourseManager: TCourseManager read FCourseManager;
    
    // Core management methods
    function GetSchoolInfo: string;
    function GetTotalStudents: Integer;
    function GetTotalTeachers: Integer;
    function GetTotalCourses: Integer;
    
    // Statistics and reporting
    function GenerateSchoolReport: string;
    function GetEnrollmentStatistics: TStringList;
    
    // Administrative functions
    procedure InitializeSchoolYear(const AYear: Integer);
    procedure BackupSchoolData(const ABackupPath: string);
    function ValidateSchoolData: Boolean;
  end;

implementation

constructor TSchoolManager.Create(const ASchoolName, ASchoolCode: string);
begin
  inherited Create;
  FSchoolName := ASchoolName;
  FSchoolCode := ASchoolCode;
  FStudentManager := TStudentManager.Create;
  FTeacherManager := TTeacherManager.Create;
  FCourseManager := TCourseManager.Create;
end;

destructor TSchoolManager.Destroy;
begin
  FStudentManager.Free;
  FTeacherManager.Free;
  FCourseManager.Free;
  inherited Destroy;
end;

function TSchoolManager.GetSchoolInfo: string;
begin
  Result := Format('School: %s (Code: %s)', [FSchoolName, FSchoolCode]);
end;

function TSchoolManager.GetTotalStudents: Integer;
begin
  Result := FStudentManager.GetStudentCount;
end;

function TSchoolManager.GetTotalTeachers: Integer;
begin
  Result := FTeacherManager.GetTeacherCount;
end;

function TSchoolManager.GetTotalCourses: Integer;
begin
  Result := FCourseManager.GetCourseCount;
end;

function TSchoolManager.GenerateSchoolReport: string;
var
  Report: TStringBuilder;
begin
  Report := TStringBuilder.Create;
  try
    Report.AppendLine('=== SCHOOL REPORT ===');
    Report.AppendLine(GetSchoolInfo);
    Report.AppendLine(Format('Total Students: %d', [GetTotalStudents]));
    Report.AppendLine(Format('Total Teachers: %d', [GetTotalTeachers]));
    Report.AppendLine(Format('Total Courses: %d', [GetTotalCourses]));
    Report.AppendLine('=====================');
    Result := Report.ToString;
  finally
    Report.Free;
  end;
end;

function TSchoolManager.GetEnrollmentStatistics: TStringList;
begin
  Result := TStringList.Create;
  Result.Add(Format('Students Enrolled: %d', [GetTotalStudents]));
  Result.Add(Format('Active Teachers: %d', [GetTotalTeachers]));
  Result.Add(Format('Available Courses: %d', [GetTotalCourses]));
end;

procedure TSchoolManager.InitializeSchoolYear(const AYear: Integer);
begin
  // Initialize new school year data
  FStudentManager.InitializeYear(AYear);
  FTeacherManager.InitializeYear(AYear);
  FCourseManager.InitializeYear(AYear);
end;

procedure TSchoolManager.BackupSchoolData(const ABackupPath: string);
begin
  // Create backup of all school data
  FStudentManager.BackupData(ABackupPath + '\Students');
  FTeacherManager.BackupData(ABackupPath + '\Teachers');
  FCourseManager.BackupData(ABackupPath + '\Courses');
end;

function TSchoolManager.ValidateSchoolData: Boolean;
begin
  Result := FStudentManager.ValidateData and 
            FTeacherManager.ValidateData and 
            FCourseManager.ValidateData;
end;

end.
