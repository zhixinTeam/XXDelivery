unit UFormSalePlanDtl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels, UFormBase,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxLCPainter, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxRadioGroup, cxDropDownEdit;

type
  TfFormSalePlanDtl = class(TfFormNormal)
    dxlytmLayout1Item31: TdxLayoutItem;
    Edt_CusName: TcxButtonEdit;
    dxlytmLayout1Item33: TdxLayoutItem;
    lbl_Cus: TLabel;
    dxLayout1Item3: TdxLayoutItem;
    edt_MaxNum: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    Rb1: TcxRadioButton;
    dxLayout1Item5: TdxLayoutItem;
    Rb2: TcxRadioButton;
    dxLayout1Item6: TdxLayoutItem;
    edt_MaxValue: TcxTextEdit;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxlytmLayout1Item7: TdxLayoutItem;
    lbl_CusID: TLabel;
    dxLayout1Group4: TdxLayoutGroup;
    dxlytmLayout1Item71: TdxLayoutItem;
    cbb_Plan: TcxComboBox;
    dxLayout1Group5: TdxLayoutGroup;
    dxlytmLayout1Item72: TdxLayoutItem;
    lbl1: TLabel;
    dxlytmLayout1Item73: TdxLayoutItem;
    lbl2: TLabel;
    dxlytmLayout1Item74: TdxLayoutItem;
    lbl3: TLabel;
    dxlytmLayout1Item75: TdxLayoutItem;
    lbl_ETime: TLabel;
    dxlytmLayout1Item76: TdxLayoutItem;
    lbl_STime: TLabel;
    dxlytmLayout1Item77: TdxLayoutItem;
    lbl_GroupName: TLabel;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    dxlytmLayout1Item78: TdxLayoutItem;
    lbl4: TLabel;
    procedure Edt_EditCus1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure Rb1Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbb_PlanPropertiesChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FID : string;
    FListCus : TStrings;
  private
    procedure IniData;
    procedure LoadPlans(nPlanID: string);
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormSalePlanDtl: TfFormSalePlanDtl;

implementation

{$R *.dfm}


uses
  IniFiles, ULibFun,UMgrControl, USysBusiness, USmallFunc, USysConst, USysDB,
  UDataModule, UFormCtrl;


function GetLeftStr(SubStr, Str: string): string;
begin
   Result := Copy(Str, 1, Pos(SubStr, Str) - 1);
end;
//-------------------------------------------

function GetRightStr(SubStr, Str: string): string;
var
   i: integer;
begin
   i := pos(SubStr, Str);
   if i > 0 then
     Result := Copy(Str
       , i + Length(SubStr)
       , Length(Str) - i - Length(SubStr) + 1)
   else
     Result := '';
end;
//-------------------------------------------

class function TfFormSalePlanDtl.FormID: integer;
begin
  Result := cFI_FormSalePlanDtl;
end;

class function TfFormSalePlanDtl.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP : PFormCommandParam;
    nPlan : TStrings;
    nStr : string;
begin
  Result:= nil;
  nPlan := TStringList.Create;

  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end
  else nP := nParam;

  with TfFormSalePlanDtl.Create(Application) do
  try
    IniData;

    case nP.FCommand of

       cCmd_AddData:
         begin
            //
         end;

       cCmd_EditData:
         begin
            nPlan.Delimiter := ',';
            nPlan.CommaText := nP.FParamA;
            //****************

            FID:= nPlan[0];
            lbl_CusID.Caption  := nPlan[1];
            Edt_CusName.Text   := StringReplace(nPlan[2], '@', ' ', [rfReplaceAll]);
            edt_MaxValue.Text  := nPlan[3];
            edt_MaxNum.Text    := nPlan[4];

            LoadPlans(nPlan[5]);

            nStr:= nPlan[5]+'、'+StringReplace(nPlan[6], '@', ' ', [rfReplaceAll]);
            cbb_Plan.ItemIndex:= cbb_Plan.Properties.Items.IndexOf(nStr);

            Rb1.Checked:= Trim(edt_MaxNum.Text)<>'';
            Rb2.Checked:= Trim(edt_MaxValue.Text)<>'';
            Edt_CusName.Enabled:= False;
         end;
    end;

    nP.FCommand:= ShowModal;
  finally
    cbb_Plan.SelStart:= Length(cbb_Plan.Text);
    Free;
    nPlan.Free;
  end;
end;

procedure TfFormSalePlanDtl.IniData;
var nStr, nTime : string;
begin
  edt_MaxNum.Text  := '';
  edt_MaxValue.Text:= '';
end;

procedure TfFormSalePlanDtl.Edt_EditCus1PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var nParam: TFormCommandParam;
    nStr:string;
begin
  CreateBaseFormItem(cFI_FormBatchGetCus, PopedomItem, @nParam);
  if (nParam.FParamA = mrOk) then
  begin
    nStr:= GetRightStr(',', nParam.FParamB);
    FListCus.CommaText:= nStr;

    lbl_CusID.Caption:= Copy(nStr, 0, 30)+' ...';
    Edt_CusName.Text := nParam.FParamC + ' 等（'+inttoStr(FListCus.Count)+'个）';
  end;
end;

procedure TfFormSalePlanDtl.Rb1Click(Sender: TObject);
begin
  edt_MaxNum.Enabled  := Rb1.Checked;
  edt_MaxValue.Enabled:= Rb2.Checked;
end;

procedure TfFormSalePlanDtl.BtnOKClick(Sender: TObject);
var nStr, nPlanId, nPlanName, nCusID, nCusName, nSql : string;
    nMaxNum   : Integer;
    nMaxValue : Double;
begin
  nPlanId  := GetLeftStr('、', Trim(cbb_Plan.Text));
  nPlanName:= GetRightStr('、', Trim(cbb_Plan.Text));
  if (nPlanId='')or(nPlanName='') then
  begin
    ShowMsg('请选择所属限量计划', '提示');  cbb_Plan.SetFocus;
    Exit;
  end;
  //*******
  nCusID  := Trim(lbl_CusID.Caption);
  nCusName:= Trim(Edt_CusName.Text);
  if (nCusID='')or(nCusName='') then
  begin
    ShowMsg('请选择限量客户', '提示');  Edt_CusName.SetFocus;
    Exit;
  end;

  //*******
  if (not Rb1.Checked)and(not Rb2.Checked) then
  begin
    ShowMsg('请选择限量方式', '提示');  
    Exit;
  end;
  nMaxNum:= StrToIntDef(Trim(edt_MaxNum.Text), -1);
  if (Rb1.Checked) And (nMaxNum<0) then
  begin
    ShowMsg('请输入限量车数', '提示');  edt_MaxNum.SetFocus;
    Exit;
  end;

  nMaxValue:= StrToIntDef(Trim(edt_MaxValue.Text), -1);
  if (Rb2.Checked) And (nMaxValue<0) then
  begin
    ShowMsg('请输入限量吨数', '提示');  edt_MaxValue.SetFocus;
    Exit;
  end;

  try
    if FID='' then
    begin
      nCusID:= AdjustListStrFormat2(FListCus, '''', True, ',', False);
      //*****
      nSql := 'Insert into $Table (S_PlanID,S_PlanName,S_MaxNum,S_MaxValue,S_CusID,S_CusName,S_Man,S_Date) '+
                        'Select ''$PlanID'',''$PlanName'', $MaxNum, $MaxValue, C_ID, C_Name, ''$Man'', GetDate() '+
                        'From S_Customer Where C_ID In ($CusIDs)';

      nSql := MacroValue(nSql, [MI('$Table' , sTable_SalePlanDtl),
                                MI('$PlanID', nPlanId), MI('$PlanName', nPlanName),
                                MI('$MaxNum', SF_IF([IntToStr(nMaxNum), 'Null'], Rb1.Checked)),
                                MI('$MaxValue', SF_IF([FloatToStr(nMaxValue), 'Null'], Rb2.Checked) ),
                                MI('$CusIDs', nCusID),
                                MI('$Man', gSysParam.FUserName)]);
    end
    else
    begin
      nSql := ' UPDate $Table Set S_PlanID=''$PlanID'',S_PlanName=''$PlanName'',S_MaxNum=$MaxNum,S_MaxValue=$MaxValue,'+
                                 'S_CusID=''$CusID'',S_CusName=''$CusName'',S_Man=''$Man'',S_Date=GetDate() '+
              ' Where R_ID=$RID ';

      nSql := MacroValue(nSql, [MI('$Table' , sTable_SalePlanDtl),
                                MI('$PlanID', nPlanId), MI('$PlanName', nPlanName),
                                MI('$MaxNum', SF_IF([IntToStr(nMaxNum), 'Null'], Rb1.Checked)),
                                MI('$MaxValue', SF_IF([FloatToStr(nMaxValue), 'Null'], Rb2.Checked) ),
                                MI('$CusID', nCusID), MI('$CusName', nCusName),
                                MI('$Man', gSysParam.FUserName), MI('$RID', FID)]);
    end;

    FDM.ExecuteSQL(nSql);
    ModalResult := mrOk;
    ShowMsg('操作成功', '提示');
  except
    on Ex: Exception do
    begin
      //ShowMsg('操作失败：' + Ex.Message, '提示');
      ShowMessage('操作失败：' + Ex.Message + ' '+nSql);
      Exit;
    end;
  end;
end;

procedure TfFormSalePlanDtl.LoadPlans(nPlanID: string);
var nStr : string;
begin
  //********************************************************************
  nStr := ' Select s.*,g.R_ID Grid, G_Name, CAST(g.R_ID AS VARCHAR(20))+''、''+G_Name GroupName '+
          ' From $SalePlan s Left Join $StockGroup g On g.R_ID=S_StockGid  Where 1=1 ';

  IF nPlanID<>'' then nStr:= nStr + ' And s.R_ID='+nPlanID;
  nStr := MacroValue(nStr, [MI('$SalePlan', sTable_SalePlan),MI('$StockGroup', sTable_StockGroup)]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      First;

      if nPlanID = '' then
      begin
        cbb_Plan.Properties.Items.Clear;

        while not Eof do
        begin
          cbb_Plan.Properties.Items.Add(FieldbyName('R_ID').AsString + '、' + FieldbyName('S_PlanName').AsString);
          Next;
        end;
      end
      else
      begin
        lbl_GroupName.Caption := FieldbyName('GroupName').AsString;
        lbl_STime.Caption := FieldbyName('S_StartTime').AsString;
        lbl_ETime.Caption := FieldbyName('S_EndTime').AsString;
      end;
    end;
  end;
end;

procedure TfFormSalePlanDtl.FormCreate(Sender: TObject);
var nStr : string;
begin
  FListCus := TStringList.Create;
  LoadPlans('');
end;

procedure TfFormSalePlanDtl.cbb_PlanPropertiesChange(Sender: TObject);
begin
  LoadPlans(GetLeftStr('、',Trim(cbb_Plan.Text)));
end;

procedure TfFormSalePlanDtl.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(FListCus);
end;

initialization
  gControlManager.RegCtrl(TfFormSalePlanDtl, TfFormSalePlanDtl.FormID);



end.
