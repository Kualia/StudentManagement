object Form4: TForm4
  Left = 388
  Top = 187
  Caption = 'StudentManagement'
  ClientHeight = 642
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 48
    Top = 91
    Width = 46
    Height = 15
    Caption = 'Students'
  end
  object Label2: TLabel
    Left = 240
    Top = 91
    Width = 38
    Height = 15
    Caption = 'Classes'
  end
  object Label3: TLabel
    Left = 424
    Top = 275
    Width = 109
    Height = 15
    Caption = 'Avg score of student'
  end
  object Label4: TLabel
    Left = 424
    Top = 325
    Width = 94
    Height = 15
    Caption = 'Avg score of class'
  end
  object Label_student: TLabel
    Left = 424
    Top = 91
    Width = 49
    Height = 15
    Caption = '(Student)'
  end
  object Label_class: TLabel
    Left = 424
    Top = 112
    Width = 35
    Height = 15
    Caption = '(Class)'
  end
  object ListBox_students: TListBox
    Left = 48
    Top = 112
    Width = 162
    Height = 265
    ItemHeight = 15
    Sorted = True
    TabOrder = 0
    OnClick = OnStudentSelectionChange
  end
  object ListBox_classes: TListBox
    Left = 240
    Top = 112
    Width = 162
    Height = 265
    ItemHeight = 15
    Sorted = True
    TabOrder = 1
    OnClick = OnClassSelectionChange
  end
  object Edit_score: TEdit
    Left = 424
    Top = 133
    Width = 75
    Height = 23
    NumbersOnly = True
    TabOrder = 2
  end
  object Edit_avgStudentScore: TEdit
    Left = 424
    Top = 296
    Width = 121
    Height = 23
    ImeName = 'Turkish Q'
    NumbersOnly = True
    ReadOnly = True
    TabOrder = 3
  end
  object Edit_avgClassScore: TEdit
    Left = 424
    Top = 346
    Width = 121
    Height = 23
    ImeName = 'Turkish Q'
    NumbersOnly = True
    ReadOnly = True
    TabOrder = 4
  end
  object Btn_updateStudentScore: TButton
    Left = 505
    Top = 133
    Width = 52
    Height = 23
    Caption = 'Update'
    TabOrder = 5
    OnClick = Btn_updateStudentScoreClick
  end
  object Edit_addStudent: TEdit
    Left = 48
    Top = 383
    Width = 162
    Height = 23
    ImeName = 'Turkish Q'
    TabOrder = 6
    TextHint = 'New student name'
  end
  object Edit_addClass: TEdit
    Left = 240
    Top = 383
    Width = 162
    Height = 23
    ImeName = 'Turkish Q'
    TabOrder = 7
    TextHint = 'New class name'
  end
  object Btn_addStudent: TButton
    Left = 135
    Top = 412
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 8
    OnClick = Btn_addStudentClick
  end
  object Btn_addClass: TButton
    Left = 327
    Top = 412
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 9
    OnClick = Btn_addClassClick
  end
  object Btn_deleteStudent: TButton
    Left = 135
    Top = 443
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 10
    OnClick = Btn_deleteStudentClick
  end
  object Btn_deleteClass: TButton
    Left = 327
    Top = 443
    Width = 75
    Height = 25
    Caption = 'Delete'
    DisabledImageName = 'Btn_DeleteClass'
    TabOrder = 11
    OnClick = Btn_deleteClassClick
  end
  object MainMenu: TMainMenu
    Left = 32
    Top = 584
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Action = Action_open
      end
      object Save1: TMenuItem
        Action = Action_Save
      end
      object SaveAs1: TMenuItem
        Action = Action_SaveAs
      end
    end
  end
  object BindingsList1: TBindingsList
    Methods = <>
    OutputConverters = <>
    Left = 468
    Top = 597
    object LinkFillControlToPropertyCaption: TLinkFillControlToProperty
      Category = 'Quick Bindings'
      Track = True
      Control = ListBox_classes
      Component = Label_class
      ComponentProperty = 'Caption'
      AutoFill = True
      FillExpressions = <>
      FillHeaderExpressions = <>
      FillBreakGroups = <>
    end
    object LinkFillControlToPropertyCaption2: TLinkFillControlToProperty
      Category = 'Quick Bindings'
      Track = True
      Control = ListBox_students
      Component = Label_student
      ComponentProperty = 'Caption'
      AutoFill = True
      FillExpressions = <>
      FillHeaderExpressions = <>
      FillBreakGroups = <>
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Json|*.json|All files|*.*'
    FilterIndex = 0
    Left = 504
    Top = 592
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.json'
    Filter = 'Json|*.json'
    FilterIndex = 0
    Left = 544
    Top = 592
  end
  object ActionManager1: TActionManager
    Left = 80
    Top = 584
    StyleName = 'Platform Default'
    object Action_open: TAction
      Caption = 'Open...'
      ShortCut = 16463
      OnExecute = Action_openExecute
    end
    object Action_Save: TAction
      Caption = 'Save'
      ShortCut = 16467
      OnExecute = Action_SaveExecute
    end
    object Action_SaveAs: TAction
      Caption = 'Save As...'
      OnExecute = Action_SaveAsExecute
    end
  end
end
