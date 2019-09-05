unit UFramePurchasePlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, dxSkinsdxLCPainter, cxContainer, ADODB, cxLabel,
  UBitmapPanel, cxSplitter, dxLayoutControl, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, cxTextEdit, cxMaskEdit,
  cxButtonEdit;

type
  TfFramePurchasePlan = class(TfFrameNormal)
    dxlytmLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure Edt_EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
    class function FrameID: integer; override;
  end;

var
  fFramePurchasePlan: TfFramePurchasePlan;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormBase, USysBusiness,
  UBusinessPacker;

class function TfFramePurchasePlan.FrameID: integer;
begin
  Result := cFI_FramePurchasePlan;
end;

function TfFramePurchasePlan.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_PurchasePlan;
  if nWhere <> '' then
    Result := Result + ' Where ( ' + nWhere + ' )';
    
  Result := Result + ' Order By P_PrvName';
end;

procedure TfFramePurchasePlan.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormPurchasePlan, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

procedure TfFramePurchasePlan.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('R_ID').AsString;
    CreateBaseFormItem(cFI_FormPurchasePlan, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  end;
end;

procedure TfFramePurchasePlan.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('P_PrvName').AsString;
    nStr := Format('确定要删除供应商 %s %s 限量计划么?', [nStr, SQLQuery.FieldByName('P_MName').AsString]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_PurchasePlan, SQLQuery.FieldByName('R_ID').AsString]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

procedure TfFramePurchasePlan.Edt_EditNamePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'P_PrvName like ''%%%s%%'' ';
    FWhere := Format(FWhere, [EditName.Text]);
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePurchasePlan, TfFramePurchasePlan.FrameID);


end.
 