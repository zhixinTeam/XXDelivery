unit UFromSalePlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels, UFormBase,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, DateUtils,
  dxSkinsdxLCPainter, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxRadioGroup, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxButtonEdit, cxCheckBox;

type
  TfFormSalePlan = class(TfFormNormal)
    dxlytmLayout1Item31: TdxLayoutItem;
    DateEdt_STime: TcxDateEdit;
    dxlytmLayout1Item32: TdxLayoutItem;
    DateEdt_ETime: TcxDateEdit;
    dxLayout1Group2: TdxLayoutGroup;
    dxlytmLayout1Item35: TdxLayoutItem;
    edt_Name: TcxTextEdit;
    cbb_GroupName: TcxComboBox;
    dxlytmLayout1Item61: TdxLayoutItem;
    Chk1: TcxCheckBox;
    dxlytmLayout1Item3: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
  private
    FID : string;
  private
    procedure IniData;
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormSalePlan: TfFormSalePlan;

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

class function TfFormSalePlan.FormID: integer;
begin
  Result := cFI_FormSalePlan;
end;

class function TfFormSalePlan.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP : PFormCommandParam;
    nPlan : TStrings;
begin
  Result:= nil;
  nPlan := TStringList.Create;

  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end
  else nP := nParam;

  with TfFormSalePlan.Create(Application) do
  try
    IniData;

    case nP.FCommand of

       cCmd_AddData:
         begin
            //
         end;

       cCmd_EditData:
         begin
            nPlan.Delimiter:= ',';
            nPlan.CommaText:= nP.FParamA;

            FID            := nPlan[0];
            edt_Name.Text  := StringReplace(nPlan[1], '@', ' ', [rfReplaceAll]);
            cbb_GroupName.Text := nPlan[2];
            DateEdt_STime.Date := StrToDateTime(StringReplace(nPlan[3], '@', ' ', [rfReplaceAll]));
            DateEdt_ETime.Date := StrToDateTime(StringReplace(nPlan[4], '@', ' ', [rfReplaceAll]));

            Chk1.Checked := nPlan[5]='Y';
         end;
    end;

    nP.FCommand:= ShowModal;
  finally
    Free;
    nPlan.Free;
  end;
end;

procedure TfFormSalePlan.IniData;
var nStr, nTime : string;
begin
  edt_Name.Text     := '';
  cbb_GroupName.Text:= '';
  //********************************************************************

  nStr := 'Select D_Value From %s Where D_Name=''SysParam'' And D_Memo=''SalePurPlanTime''' ;
  nStr := Format(nStr,[sTable_SysDict]);
  with FDM.QuerySQL(nStr) do
  begin
    nTime:= Fieldbyname('D_Value').AsString;
  end;
  if nTime='' then nTime:= '07:30:00';

  DateEdt_STime.Date:= StrToDateTime(FormatDateTime('yyyy-MM-dd '+nTime, Now));
  DateEdt_ETime.Date:= StrToDateTime(FormatDateTime('yyyy-MM-dd '+nTime, IncDay(Now,1)));

  //********************************************************************
  cbb_GroupName.Properties.Items.Clear;
  nStr := 'Select * From %s Order By R_ID';
  nStr := Format(nStr, [sTable_StockGroup]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        cbb_GroupName.Properties.Items.Add(Fields[0].AsString + '、' + Fields[1].AsString);
        Next;
      end;
    end;
  end;
end;

procedure TfFormSalePlan.BtnOKClick(Sender: TObject);
var nGroupId, nDf, nPlanName, nSql : string;
begin
  nPlanName := Trim(edt_Name.Text);
  if nPlanName='' then
  begin
    ShowMsg('请输入计划名称，方便您记忆相关信息', '提示');
    Exit;
  end;

  if (Trim(DateEdt_STime.Text)='') or
     (Trim(DateEdt_ETime.Text)='') then
  begin
    ShowMsg('请输入计划开始、结束时间', '提示');
    Exit;
  end;

  if Chk1.Checked then nDf:= 'Y'
  else nDf:= 'N';
  try
    nGroupId:= GetLeftStr('、', cbb_GroupName.Text);
    if FID='' then
    begin
      nSql := 'Insert into $Table (S_PlanName,S_StockGID,S_StartTime,S_EndTime,S_Man,S_Date,S_StopCreate) '+
                        'Select ''$PlanName'', $GID, ''$STime'', ''$ETime'', ''$Man'', GetDate(), ''$DF'' ';

      nSql := MacroValue(nSql, [MI('$Table' , sTable_SalePlan),
                                MI('$PlanName', nPlanName), MI('$GID', nGroupId),
                                MI('$STime' , DateTime2Str(DateEdt_STime.Date)),
                                MI('$ETime' , DateTime2Str(DateEdt_ETime.Date)),
                                MI('$Man', gSysParam.FUserName),
                                MI('$DF',  nDf)]);
    end
    else
    begin
      nSql := ' UPDate $Table Set S_PlanName=''$PlanName'',S_StockGID=$GID, S_StartTime=''$STime'','+
                             'S_EndTime=''$ETime'',S_Man=''$Man'',S_Date=GetDate(),S_StopCreate=''$DF''  '+
              ' Where R_ID=$RID ';

      nSql := MacroValue(nSql, [MI('$Table' , sTable_SalePlan),
                                MI('$PlanName', nPlanName), MI('$GID', nGroupId),
                                MI('$STime' , DateTime2Str(DateEdt_STime.Date)),
                                MI('$ETime' , DateTime2Str(DateEdt_ETime.Date)),
                                MI('$Man', gSysParam.FUserName), MI('$DF',  nDf),
                                MI('$RID', FID)]);
    end;

    FDM.ExecuteSQL(nSql);
    ModalResult := mrOk;
    ShowMsg('操作成功', '提示');
  except
    ShowMsg('操作失败', '提示');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormSalePlan, TfFormSalePlan.FormID);


end.
