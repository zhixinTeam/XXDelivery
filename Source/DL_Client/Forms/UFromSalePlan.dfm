inherited fFormSalePlan: TfFormSalePlan
  Left = 703
  Top = 271
  Caption = #21697#31181#38480#37327#35745#21010
  ClientHeight = 259
  ClientWidth = 421
  Font.Height = -13
  Font.Name = #24494#36719#38597#40657
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 19
  inherited dxLayout1: TdxLayoutControl
    Width = 421
    Height = 259
    inherited BtnOK: TButton
      Left = 272
      Top = 223
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 342
      Top = 223
      TabOrder = 6
    end
    object DateEdt_STime: TcxDateEdit [2]
      Left = 93
      Top = 114
      ParentFont = False
      Properties.Kind = ckDateTime
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 2
      Width = 160
    end
    object DateEdt_ETime: TcxDateEdit [3]
      Left = 93
      Top = 146
      ParentFont = False
      Properties.Kind = ckDateTime
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      Width = 160
    end
    object edt_Name: TcxTextEdit [4]
      Left = 93
      Top = 50
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsOffice11
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 397
    end
    object cbb_GroupName: TcxComboBox [5]
      Left = 93
      Top = 82
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Width = 207
    end
    object Chk1: TcxCheckBox [6]
      Left = 29
      Top = 178
      Caption = #26410#35774#32622#26412#35745#21010#23458#25143#31105#27490#24320#21333
      ParentColor = False
      ParentFont = False
      State = cbsChecked
      Style.Color = clWhite
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.TextColor = clRed
      Style.TextStyle = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 4
      Width = 346
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxlytmLayout1Item35: TdxLayoutItem
          Caption = #35745#21010#21517#31216#65306
          Control = edt_Name
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item61: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #21697#31181#20998#32452#65306
          Control = cbb_GroupName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxlytmLayout1Item31: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #24320#22987#26102#38388#65306
            Control = DateEdt_STime
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item32: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #32467#26463#26102#38388#65306
            Control = DateEdt_ETime
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item3: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = Chk1
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
