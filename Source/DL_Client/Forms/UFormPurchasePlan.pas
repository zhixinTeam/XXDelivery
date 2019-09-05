unit UFormPurchasePlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels, USysDB,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxLCPainter, cxContainer, cxEdit, StdCtrls, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, dxLayoutControl, cxCheckBox;

type
  PFormCommandParam = ^TFormCommandParam;
  TFormCommandParam = record
    FCommand: integer;
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Pointer;
  end;

  TfFormPurchasePlan = class(TfFormNormal)
    dxlytmLayout1Item3: TdxLayoutItem;
    cbbProvider: TcxComboBox;
    dxlytmLayout1Item31: TdxLayoutItem;
    cbbMaterials: TcxComboBox;
    dxlytmLayout1Item32: TdxLayoutItem;
    edt_MaxNum: TcxTextEdit;
    dxlytmLayout1Item33: TdxLayoutItem;
    lbl1: TLabel;
    dxLayout1Group2: TdxLayoutGroup;
    dxlytmLayout1Item34: TdxLayoutItem;
    edt_Provider: TcxTextEdit;
    dxlytmLayout1Item35: TdxLayoutItem;
    edt_Materials: TcxTextEdit;
    dxlytmLayout1Item36: TdxLayoutItem;
    lbl2: TLabel;
    dxlytmLayout1Item37: TdxLayoutItem;
    lbl3: TLabel;
    Chk1: TcxCheckBox;
    dxlytmLayout1Item38: TdxLayoutItem;
    procedure cbbMaterialsKeyPress(Sender: TObject; var Key: Char);
    procedure cbbProviderKeyPress(Sender: TObject; var Key: Char);
    procedure cbbProviderPropertiesCloseUp(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure cbbMaterialsPropertiesCloseUp(Sender: TObject);
  private
    { Private declarations }
    FRecordID:string;
  private
    function IsExit(nPrvID, nMID:string):Boolean;
    procedure LoadProvPlanInfo(nID:string);
    procedure LoadMaterials(nMt:string='');
    procedure LoadProvider(nMt:string='');
    procedure InitFormData(const nID: string);
    //载入数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormPurchasePlan: TfFormPurchasePlan;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UAdjustForm, USysGrid, USysConst,
  UDataModule;

var
  gForm: TfFormPurchasePlan = nil;
  //全局使用

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

class function TfFormPurchasePlan.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of

   cCmd_AddData:
    with TfFormPurchasePlan.Create(Application) do
    begin
      FRecordID := '';
      Caption := '采购限量计划 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;

   cCmd_EditData:
    with TfFormPurchasePlan.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      Caption := '采购限量计划 - 修改';

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;

   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormPurchasePlan.FormID: integer;
begin
  Result := cFI_FormPurchasePlan;
end;

procedure TfFormPurchasePlan.LoadProvPlanInfo(nID:string);
var nSQL : string;
begin
  nSQL:= 'Select * From %s Where R_ID=''' + FRecordID + '''';
  nSQL:= Format(nSQL, [ sTable_PurchasePlan, nID]);

  with FDM.QueryTemp(nSQL) do
  begin
    if recordCount>0 then
    begin
      edt_Materials.Text:= FieldByName('P_MID').AsString;
      cbbMaterials.Text := FieldByName('P_MID').AsString+'.'+FieldByName('P_MName').AsString;
      edt_Provider.Text := FieldByName('P_PrvID').AsString;
      cbbProvider.Text  := FieldByName('P_PrvID').AsString+'.'+FieldByName('P_PrvName').AsString;
      edt_MaxNum.Text   := FieldByName('P_MaxNum').AsString;
    end;
  end;
end;

procedure TfFormPurchasePlan.LoadMaterials(nMt:string);
var nStr, nWh: string;
begin
  nWh:= '';

  if nMt<>'' then
    nWh:= ' Where O_StockName Like ''%'+nMt+'%'' ';

    AdjustStringsItem(cbbMaterials.Properties.Items, True);
    nStr := 'O_StockNo=Select O_StockNo, O_StockName From P_Order '+nWh+' Group by O_StockNo, O_StockName Order by O_StockName ';

    FDM.FillStringsData(cbbMaterials.Properties.Items, nStr, -1, '.');
    AdjustStringsItem(cbbMaterials.Properties.Items, False);

    cbbMaterials.ItemIndex:= 0;
    cbbMaterials.DroppedDown:= True;
    cbbMaterials.SelLength:= 0;
end;

procedure TfFormPurchasePlan.LoadProvider(nMt:string);
var nStr, nWh: string;
begin
  nWh:= '';

  if nMt<>'' then
    nWh:= ' Where P_Name Like ''%'+nMt+'%'' ';

    AdjustStringsItem(cbbProvider.Properties.Items, True);
    nStr := 'P_ID=Select P_ID,P_Name From P_Provider '+nWh;

    FDM.FillStringsData(cbbProvider.Properties.Items, nStr, -1, '.');
    AdjustStringsItem(cbbProvider.Properties.Items, False);

    cbbProvider.ItemIndex:= 0;
    cbbProvider.DroppedDown:= True;
    cbbProvider.SelLength:= 0;
end;

procedure TfFormPurchasePlan.InitFormData(const nID: string);
var nStr: string;
begin
//  LoadMaterials;
//  LoadProvider;
  LoadProvPlanInfo(nID);
end;

procedure TfFormPurchasePlan.cbbMaterialsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_RETURN) then
    LoadMaterials(Trim(GetCtrlData(cbbMaterials)));
end;

procedure TfFormPurchasePlan.cbbProviderKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_RETURN) then
    LoadProvider(Trim(GetCtrlData(cbbProvider)));
end;

procedure TfFormPurchasePlan.cbbProviderPropertiesCloseUp(Sender: TObject);
begin
  edt_Provider.Text:= GetCtrlData(cbbProvider)
end;

function TfFormPurchasePlan.IsExit(nPrvID, nMID:string):Boolean;
var nSQL : string;
begin
  Result:= False;
  nSQL:= 'Select * From %s Where P_PrvID=''' + nPrvID + ''' And P_MID=''' + nMID + '''';
  nSQL:= Format(nSQL, [ sTable_PurchasePlan ]);

  with FDM.QueryTemp(nSQL) do
  begin
    Result:= RecordCount>0;
  end;
end;

procedure TfFormPurchasePlan.BtnOKClick(Sender: TObject);
var nList: TStrings;
    nSQL : string;
begin
  nList := TStringList.Create;
  try
    if (Trim(edt_Materials.Text)='')or(Trim(edt_Materials.Text)='')then
    begin
      ShowMsg('请选择供应商、品种信息', '提示');
      Exit;
    end;

    if FRecordID = '' then
    begin
      if not IsExit(Trim(edt_Provider.Text),Trim(edt_Materials.Text)) then
      begin
        nSQL:= 'Insert Into %s(P_MID,P_MName,P_PrvID,P_PrvName,P_MaxNum) '+
                'Select ''%s'',''%s'',''%s'',''%s'' ';
        nSQL:= Format(nSQL, [ sTable_PurchasePlan, Trim(edt_Materials.Text), GetRightStr('.', Trim(cbbMaterials.Text)),
                              Trim(edt_Provider.Text), GetRightStr('.', Trim(cbbProvider.Text))]);

        if Trim(edt_MaxNum.Text)='' then
          nSQL:= nSQL + ', Null '
        else nSQL:= nSQL + ', '''+Trim(edt_MaxNum.Text)+''' ';
      end
      else
      begin
        ShowMsg('已存在该客户、物料限量计划、请勿重复添加', '提示');
        Exit;
      end;
    end
    else
    begin
      nSQL:= 'UPDate %s Set P_MID=''%s'',P_MName=''%s'',P_PrvID=''%s'',P_PrvName=''%s'' ';
      nSQL:= Format(nSQL, [ sTable_PurchasePlan, Trim(edt_Materials.Text), GetRightStr('.', Trim(cbbMaterials.Text)),
                            Trim(edt_Provider.Text), GetRightStr('.', Trim(cbbProvider.Text))]);

      if Trim(edt_MaxNum.Text)='' then
        nSQL:= nSQL + ',P_MaxNum=Null '
      else nSQL:= nSQL + ',P_MaxNum= '''+Trim(edt_MaxNum.Text)+''' ';

      nSQL:= nSQL + ' Where R_ID=''' + FRecordID + '''';
    end;

    try
      FDM.ExecuteSQL(nSQL);
    except
      on Ex : Exception do
      begin
        ShowMsg('保存失败:'+Ex.Message, sHint);
        Exit;
      end;
    end;

    if not Chk1.Checked then ModalResult := mrOK;
    ShowMsg('供应商限量计划已保存', sHint);
  finally
    FreeAndNil(nList);
  end;
end;

procedure TfFormPurchasePlan.cbbMaterialsPropertiesCloseUp(
  Sender: TObject);
begin
  edt_Materials.Text:= GetCtrlData(cbbMaterials)
end;

initialization
  gControlManager.RegCtrl(TfFormPurchasePlan, TfFormPurchasePlan.FormID);

end.
