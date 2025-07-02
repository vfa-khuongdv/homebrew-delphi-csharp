object StudentDetailsForm: TStudentDetailsForm
  Left = 0
  Top = 0
  Caption = 'Student Details'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 608
    Height = 393
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Personal Information'
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 584
        Height = 169
        Caption = 'Basic Information'
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
          Width = 50
          Height = 13
          Caption = 'Full Name:'
        end
        object Label5: TLabel
          Left = 16
          Top = 132
          Width = 69
          Height = 13
          Caption = 'Date of Birth:'
        end
        object Label6: TLabel
          Left = 304
          Top = 24
          Width = 23
          Height = 13
          Caption = 'Age:'
        end
        object Label7: TLabel
          Left = 304
          Top = 51
          Width = 32
          Height = 13
          Caption = 'Grade:'
        end
        object Label8: TLabel
          Left = 304
          Top = 78
          Width = 29
          Height = 13
          Caption = 'Class:'
        end
        object Label9: TLabel
          Left = 304
          Top = 105
          Width = 28
          Height = 13
          Caption = 'Email:'
        end
        object Label10: TLabel
          Left = 304
          Top = 132
          Width = 75
          Height = 13
          Caption = 'Phone Number:'
        end
        object edtStudentId: TEdit
          Left = 88
          Top = 21
          Width = 121
          Height = 21
          ReadOnly = True
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
        object edtFullName: TEdit
          Left = 88
          Top = 102
          Width = 201
          Height = 21
          ReadOnly = True
          TabOrder = 3
        end
        object dtpDateOfBirth: TDateTimePicker
          Left = 88
          Top = 129
          Width = 186
          Height = 21
          Date = 44927.000000000000000000
          Time = 0.364583333333333300
          TabOrder = 4
          OnChange = dtpDateOfBirthChange
        end
        object edtAge: TEdit
          Left = 336
          Top = 21
          Width = 57
          Height = 21
          ReadOnly = True
          TabOrder = 5
        end
        object cmbGrade: TComboBox
          Left = 336
          Top = 48
          Width = 73
          Height = 21
          TabOrder = 6
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
          Left = 336
          Top = 75
          Width = 121
          Height = 21
          TabOrder = 7
        end
        object edtEmail: TEdit
          Left = 336
          Top = 102
          Width = 201
          Height = 21
          TabOrder = 8
        end
        object edtPhoneNumber: TEdit
          Left = 384
          Top = 129
          Width = 121
          Height = 21
          TabOrder = 9
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 183
        Width = 584
        Height = 174
        Caption = 'Address Information'
        TabOrder = 1
        object Label11: TLabel
          Left = 16
          Top = 24
          Width = 41
          Height = 13
          Caption = 'Address:'
        end
        object Label12: TLabel
          Left = 16
          Top = 51
          Width = 23
          Height = 13
          Caption = 'City:'
        end
        object Label13: TLabel
          Left = 16
          Top = 78
          Width = 31
          Height = 13
          Caption = 'State:'
        end
        object Label14: TLabel
          Left = 16
          Top = 105
          Width = 53
          Height = 13
          Caption = 'Zip/Postal:'
        end
        object Label15: TLabel
          Left = 16
          Top = 132
          Width = 43
          Height = 13
          Caption = 'Country:'
        end
        object Label16: TLabel
          Left = 304
          Top = 24
          Width = 95
          Height = 13
          Caption = 'Emergency Contact:'
        end
        object Label17: TLabel
          Left = 304
          Top = 51
          Width = 88
          Height = 13
          Caption = 'Emergency Phone:'
        end
        object Label18: TLabel
          Left = 304
          Top = 78
          Width = 57
          Height = 13
          Caption = 'Relationship:'
        end
        object edtAddress: TEdit
          Left = 88
          Top = 21
          Width = 201
          Height = 21
          TabOrder = 0
        end
        object edtCity: TEdit
          Left = 88
          Top = 48
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object edtState: TEdit
          Left = 88
          Top = 75
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object edtZipCode: TEdit
          Left = 88
          Top = 102
          Width = 121
          Height = 21
          TabOrder = 3
        end
        object cmbCountry: TComboBox
          Left = 88
          Top = 129
          Width = 145
          Height = 21
          TabOrder = 4
          Items.Strings = (
            'United States'
            'Canada'
            'United Kingdom'
            'Australia'
            'Germany'
            'France'
            'Japan'
            'Other')
        end
        object edtEmergencyContact: TEdit
          Left = 408
          Top = 21
          Width = 153
          Height = 21
          TabOrder = 5
        end
        object edtEmergencyPhone: TEdit
          Left = 408
          Top = 48
          Width = 121
          Height = 21
          TabOrder = 6
        end
        object cmbRelationship: TComboBox
          Left = 408
          Top = 75
          Width = 121
          Height = 21
          TabOrder = 7
          Items.Strings = (
            'Parent'
            'Guardian'
            'Sibling'
            'Grandparent'
            'Other')
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Academic Information'
      ImageIndex = 1
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 584
        Height = 169
        Caption = 'Current Academic Status'
        TabOrder = 0
        object Label19: TLabel
          Left = 16
          Top = 24
          Width = 77
          Height = 13
          Caption = 'Enrollment Date:'
        end
        object Label20: TLabel
          Left = 16
          Top = 51
          Width = 71
          Height = 13
          Caption = 'Academic Year:'
        end
        object Label21: TLabel
          Left = 16
          Top = 78
          Width = 54
          Height = 13
          Caption = 'GPA/CGPA:'
        end
        object Label22: TLabel
          Left = 16
          Top = 105
          Width = 36
          Height = 13
          Caption = 'Status:'
        end
        object Label23: TLabel
          Left = 304
          Top = 24
          Width = 72
          Height = 13
          Caption = 'Credits Earned:'
        end
        object Label24: TLabel
          Left = 304
          Top = 51
          Width = 76
          Height = 13
          Caption = 'Credits Required:'
        end
        object Label25: TLabel
          Left = 304
          Top = 78
          Width = 91
          Height = 13
          Caption = 'Expected Grad Date:'
        end
        object dtpEnrollmentDate: TDateTimePicker
          Left = 104
          Top = 21
          Width = 186
          Height = 21
          Date = 44927.000000000000000000
          Time = 0.364583333333333300
          TabOrder = 0
        end
        object edtAcademicYear: TEdit
          Left = 104
          Top = 48
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object edtGPA: TEdit
          Left = 104
          Top = 75
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object cmbStatus: TComboBox
          Left = 104
          Top = 102
          Width = 145
          Height = 21
          TabOrder = 3
          Items.Strings = (
            'Active'
            'Inactive'
            'Suspended'
            'Graduated'
            'Transferred'
            'Withdrawn')
        end
        object edtCreditsEarned: TEdit
          Left = 408
          Top = 21
          Width = 121
          Height = 21
          TabOrder = 4
        end
        object edtCreditsRequired: TEdit
          Left = 408
          Top = 48
          Width = 121
          Height = 21
          TabOrder = 5
        end
        object dtpExpectedGradDate: TDateTimePicker
          Left = 408
          Top = 75
          Width = 153
          Height = 21
          Date = 44927.000000000000000000
          Time = 0.364583333333333300
          TabOrder = 6
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 183
        Width = 584
        Height = 174
        Caption = 'Course Enrollment'
        TabOrder = 1
        object ListView1: TListView
          Left = 16
          Top = 24
          Width = 553
          Height = 105
          Columns = <
            item
              Caption = 'Course ID'
              Width = 80
            end
            item
              Caption = 'Course Name'
              Width = 200
            end
            item
              Caption = 'Credits'
              Width = 60
            end
            item
              Caption = 'Grade'
              Width = 60
            end
            item
              Caption = 'Status'
              Width = 80
            end
            item
              Caption = 'Semester'
              Width = 70
            end>
          TabOrder = 0
          ViewStyle = vsReport
        end
        object btnAddCourse: TButton
          Left = 16
          Top = 135
          Width = 75
          Height = 25
          Caption = 'Add Course'
          TabOrder = 1
        end
        object btnRemoveCourse: TButton
          Left = 97
          Top = 135
          Width = 75
          Height = 25
          Caption = 'Remove Course'
          TabOrder = 2
        end
        object btnViewGrades: TButton
          Left = 178
          Top = 135
          Width = 75
          Height = 25
          Caption = 'View Grades'
          TabOrder = 3
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Notes & Comments'
      ImageIndex = 2
      object GroupBox5: TGroupBox
        Left = 8
        Top = 8
        Width = 584
        Height = 349
        Caption = 'Additional Information'
        TabOrder = 0
        object Label26: TLabel
          Left = 16
          Top = 24
          Width = 32
          Height = 13
          Caption = 'Notes:'
        end
        object Label27: TLabel
          Left = 16
          Top = 180
          Width = 55
          Height = 13
          Caption = 'Comments:'
        end
        object memoNotes: TMemo
          Left = 16
          Top = 43
          Width = 553
          Height = 124
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object memoComments: TMemo
          Left = 16
          Top = 199
          Width = 553
          Height = 124
          ScrollBars = ssVertical
          TabOrder = 1
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 407
    Width = 624
    Height = 34
    Align = alBottom
    TabOrder = 1
    object btnSave: TButton
      Left = 462
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 543
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnApply: TButton
      Left = 381
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Apply'
      TabOrder = 2
      OnClick = btnApplyClick
    end
  end
end
