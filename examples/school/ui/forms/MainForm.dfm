object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'School Management System'
  ClientHeight = 562
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 768
    Height = 546
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Students'
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 369
        Height = 137
        Caption = 'Student Information'
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 24
          Width = 55
          Height = 13
          Caption = 'Student ID:'
        end
        object Label2: TLabel
          Left = 16
          Top = 51
          Width = 57
          Height = 13
          Caption = 'First Name:'
        end
        object Label3: TLabel
          Left = 16
          Top = 78
          Width = 56
          Height = 13
          Caption = 'Last Name:'
        end
        object Label4: TLabel
          Left = 16
          Top = 105
          Width = 28
          Height = 13
          Caption = 'Email:'
        end
        object edtStudentId: TEdit
          Left = 88
          Top = 21
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object edtFirstName: TEdit
          Left = 88
          Top = 48
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object edtLastName: TEdit
          Left = 88
          Top = 75
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object edtEmail: TEdit
          Left = 88
          Top = 102
          Width = 201
          Height = 21
          TabOrder = 3
        end
      end
      object GroupBox2: TGroupBox
        Left = 383
        Top = 8
        Width = 369
        Height = 137
        Caption = 'Additional Information'
        TabOrder = 1
        object Label5: TLabel
          Left = 16
          Top = 24
          Width = 32
          Height = 13
          Caption = 'Grade:'
        end
        object Label6: TLabel
          Left = 16
          Top = 51
          Width = 29
          Height = 13
          Caption = 'Class:'
        end
        object Label7: TLabel
          Left = 16
          Top = 78
          Width = 69
          Height = 13
          Caption = 'Date of Birth:'
        end
        object Label8: TLabel
          Left = 16
          Top = 105
          Width = 75
          Height = 13
          Caption = 'Phone Number:'
        end
        object cmbGrade: TComboBox
          Left = 88
          Top = 21
          Width = 145
          Height = 21
          TabOrder = 0
          Items.Strings = (
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12')
        end
        object edtClassName: TEdit
          Left = 88
          Top = 48
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object dtpDateOfBirth: TDateTimePicker
          Left = 88
          Top = 75
          Width = 186
          Height = 21
          Date = 44927.000000000000000000
          Time = 0.364583333333333300
          TabOrder = 2
        end
        object edtPhoneNumber: TEdit
          Left = 88
          Top = 102
          Width = 121
          Height = 21
          TabOrder = 3
        end
      end
      object btnAddStudent: TButton
        Left = 8
        Top = 151
        Width = 75
        Height = 25
        Caption = 'Add Student'
        TabOrder = 2
        OnClick = btnAddStudentClick
      end
      object btnEditStudent: TButton
        Left = 89
        Top = 151
        Width = 75
        Height = 25
        Caption = 'Edit Student'
        TabOrder = 3
        OnClick = btnEditStudentClick
      end
      object btnDeleteStudent: TButton
        Left = 170
        Top = 151
        Width = 75
        Height = 25
        Caption = 'Delete Student'
        TabOrder = 4
        OnClick = btnDeleteStudentClick
      end
      object btnClearStudent: TButton
        Left = 251
        Top = 151
        Width = 75
        Height = 25
        Caption = 'Clear'
        TabOrder = 5
        OnClick = btnClearStudentClick
      end
      object StringGrid1: TStringGrid
        Left = 8
        Top = 182
        Width = 744
        Height = 328
        ColCount = 8
        FixedCols = 0
        RowCount = 2
        TabOrder = 6
        ColWidths = (
          80
          100
          100
          150
          60
          80
          100
          120)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Teachers'
      ImageIndex = 1
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 369
        Height = 169
        Caption = 'Teacher Information'
        TabOrder = 0
        object Label9: TLabel
          Left = 16
          Top = 24
          Width = 58
          Height = 13
          Caption = 'Teacher ID:'
        end
        object Label10: TLabel
          Left = 16
          Top = 51
          Width = 57
          Height = 13
          Caption = 'First Name:'
        end
        object Label11: TLabel
          Left = 16
          Top = 78
          Width = 56
          Height = 13
          Caption = 'Last Name:'
        end
        object Label12: TLabel
          Left = 16
          Top = 105
          Width = 28
          Height = 13
          Caption = 'Email:'
        end
        object Label13: TLabel
          Left = 16
          Top = 132
          Width = 60
          Height = 13
          Caption = 'Department:'
        end
        object edtTeacherId: TEdit
          Left = 88
          Top = 21
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object edtTeacherFirstName: TEdit
          Left = 88
          Top = 48
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object edtTeacherLastName: TEdit
          Left = 88
          Top = 75
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object edtTeacherEmail: TEdit
          Left = 88
          Top = 102
          Width = 201
          Height = 21
          TabOrder = 3
        end
        object cmbDepartment: TComboBox
          Left = 88
          Top = 129
          Width = 145
          Height = 21
          TabOrder = 4
          Items.Strings = (
            'Mathematics'
            'Science'
            'English'
            'History'
            'Physical Education'
            'Arts'
            'Music'
            'Computer Science')
        end
      end
      object GroupBox4: TGroupBox
        Left = 383
        Top = 8
        Width = 369
        Height = 169
        Caption = 'Additional Information'
        TabOrder = 1
        object Label14: TLabel
          Left = 16
          Top = 24
          Width = 41
          Height = 13
          Caption = 'Subject:'
        end
        object Label15: TLabel
          Left = 16
          Top = 51
          Width = 33
          Height = 13
          Caption = 'Salary:'
        end
        object Label16: TLabel
          Left = 16
          Top = 78
          Width = 69
          Height = 13
          Caption = 'Date of Birth:'
        end
        object Label17: TLabel
          Left = 16
          Top = 105
          Width = 54
          Height = 13
          Caption = 'Hire Date:'
        end
        object Label18: TLabel
          Left = 16
          Top = 132
          Width = 75
          Height = 13
          Caption = 'Phone Number:'
        end
        object edtSubject: TEdit
          Left = 88
          Top = 21
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object edtSalary: TEdit
          Left = 88
          Top = 48
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object dtpTeacherDOB: TDateTimePicker
          Left = 88
          Top = 75
          Width = 186
          Height = 21
          Date = 44927.000000000000000000
          Time = 0.364583333333333300
          TabOrder = 2
        end
        object dtpHireDate: TDateTimePicker
          Left = 88
          Top = 102
          Width = 186
          Height = 21
          Date = 44927.000000000000000000
          Time = 0.364583333333333300
          TabOrder = 3
        end
        object edtTeacherPhone: TEdit
          Left = 88
          Top = 129
          Width = 121
          Height = 21
          TabOrder = 4
        end
      end
      object btnAddTeacher: TButton
        Left = 8
        Top = 183
        Width = 75
        Height = 25
        Caption = 'Add Teacher'
        TabOrder = 2
        OnClick = btnAddTeacherClick
      end
      object btnEditTeacher: TButton
        Left = 89
        Top = 183
        Width = 75
        Height = 25
        Caption = 'Edit Teacher'
        TabOrder = 3
        OnClick = btnEditTeacherClick
      end
      object btnDeleteTeacher: TButton
        Left = 170
        Top = 183
        Width = 75
        Height = 25
        Caption = 'Delete Teacher'
        TabOrder = 4
        OnClick = btnDeleteTeacherClick
      end
      object StringGrid2: TStringGrid
        Left = 8
        Top = 214
        Width = 744
        Height = 296
        ColCount = 9
        FixedCols = 0
        RowCount = 2
        TabOrder = 5
        ColWidths = (
          80
          100
          100
          150
          80
          80
          100
          80
          120)
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Courses'
      ImageIndex = 2
      object GroupBox5: TGroupBox
        Left = 8
        Top = 8
        Width = 369
        Height = 169
        Caption = 'Course Information'
        TabOrder = 0
        object Label19: TLabel
          Left = 16
          Top = 24
          Width = 53
          Height = 13
          Caption = 'Course ID:'
        end
        object Label20: TLabel
          Left = 16
          Top = 51
          Width = 69
          Height = 13
          Caption = 'Course Name:'
        end
        object Label21: TLabel
          Left = 16
          Top = 78
          Width = 60
          Height = 13
          Caption = 'Department:'
        end
        object Label22: TLabel
          Left = 16
          Top = 105
          Width = 37
          Height = 13
          Caption = 'Credits:'
        end
        object Label23: TLabel
          Left = 16
          Top = 132
          Width = 53
          Height = 13
          Caption = 'Instructor:'
        end
        object edtCourseId: TEdit
          Left = 88
          Top = 21
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object edtCourseName: TEdit
          Left = 88
          Top = 48
          Width = 201
          Height = 21
          TabOrder = 1
        end
        object cmbCourseDepartment: TComboBox
          Left = 88
          Top = 75
          Width = 145
          Height = 21
          TabOrder = 2
          Items.Strings = (
            'Mathematics'
            'Science'
            'English'
            'History'
            'Physical Education'
            'Arts'
            'Music'
            'Computer Science')
        end
        object spnCredits: TSpinEdit
          Left = 88
          Top = 102
          Width = 121
          Height = 22
          MaxValue = 6
          MinValue = 1
          TabOrder = 3
          Value = 3
        end
        object cmbInstructor: TComboBox
          Left = 88
          Top = 129
          Width = 145
          Height = 21
          TabOrder = 4
        end
      end
      object GroupBox6: TGroupBox
        Left = 383
        Top = 8
        Width = 369
        Height = 169
        Caption = 'Schedule & Enrollment'
        TabOrder = 1
        object Label24: TLabel
          Left = 16
          Top = 24
          Width = 48
          Height = 13
          Caption = 'Schedule:'
        end
        object Label25: TLabel
          Left = 16
          Top = 51
          Width = 55
          Height = 13
          Caption = 'Classroom:'
        end
        object Label26: TLabel
          Left = 16
          Top = 78
          Width = 82
          Height = 13
          Caption = 'Max Enrollment:'
        end
        object Label27: TLabel
          Left = 16
          Top = 105
          Width = 95
          Height = 13
          Caption = 'Course Description:'
        end
        object edtSchedule: TEdit
          Left = 88
          Top = 21
          Width = 201
          Height = 21
          TabOrder = 0
        end
        object edtClassroom: TEdit
          Left = 88
          Top = 48
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object spnMaxEnrollment: TSpinEdit
          Left = 104
          Top = 75
          Width = 121
          Height = 22
          MaxValue = 500
          MinValue = 5
          TabOrder = 2
          Value = 30
        end
        object memoDescription: TMemo
          Left = 16
          Top = 124
          Width = 337
          Height = 37
          ScrollBars = ssVertical
          TabOrder = 3
        end
      end
      object btnAddCourse: TButton
        Left = 8
        Top = 183
        Width = 75
        Height = 25
        Caption = 'Add Course'
        TabOrder = 2
        OnClick = btnAddCourseClick
      end
      object btnEditCourse: TButton
        Left = 89
        Top = 183
        Width = 75
        Height = 25
        Caption = 'Edit Course'
        TabOrder = 3
        OnClick = btnEditCourseClick
      end
      object btnDeleteCourse: TButton
        Left = 170
        Top = 183
        Width = 75
        Height = 25
        Caption = 'Delete Course'
        TabOrder = 4
        OnClick = btnDeleteCourseClick
      end
      object StringGrid3: TStringGrid
        Left = 8
        Top = 214
        Width = 744
        Height = 296
        ColCount = 8
        FixedCols = 0
        RowCount = 2
        TabOrder = 5
        ColWidths = (
          80
          150
          100
          60
          100
          80
          100
          150)
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 543
    Width = 784
    Height = 19
    Panels = <
      item
        Text = 'Ready'
        Width = 200
      end
      item
        Text = 'Students: 0'
        Width = 150
      end
      item
        Text = 'Teachers: 0'
        Width = 150
      end
      item
        Text = 'Courses: 0'
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 720
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
      object New1: TMenuItem
        Caption = '&New Database'
        OnClick = New1Click
      end
      object Open1: TMenuItem
        Caption = '&Open Database'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = '&Save Database'
        OnClick = Save1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object SelectAll1: TMenuItem
        Caption = 'Select &All'
        OnClick = SelectAll1Click
      end
      object Copy1: TMenuItem
        Caption = '&Copy'
        OnClick = Copy1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Find1: TMenuItem
        Caption = '&Find'
        OnClick = Find1Click
      end
    end
    object Tools1: TMenuItem
      Caption = '&Tools'
      object GenerateReports1: TMenuItem
        Caption = '&Generate Reports'
        OnClick = GenerateReports1Click
      end
      object ImportData1: TMenuItem
        Caption = '&Import Data'
        OnClick = ImportData1Click
      end
      object ExportData1: TMenuItem
        Caption = '&Export Data'
        OnClick = ExportData1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Settings1: TMenuItem
        Caption = '&Settings'
        OnClick = Settings1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'sdb'
    Filter = 'School Database Files (*.sdb)|*.sdb|All Files (*.*)|*.*'
    Left = 688
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'sdb'
    Filter = 'School Database Files (*.sdb)|*.sdb|All Files (*.*)|*.*'
    Left = 656
    Top = 8
  end
end
