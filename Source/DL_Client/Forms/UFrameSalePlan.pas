{*******************************************************************************
  作者:  2018-08-20
  描述: 查询水销售品种限量  客户限量
*******************************************************************************}
unit UFrameSalePlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  IniFiles, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, cxTextEdit, Menus,
  dxLayoutControl, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxLCPainter;

type
  TfFrameSalePlan = class(TfFrameNormal)
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    cxLevel2: TcxGridLevel;
    cxView2: TcxGridDBTableView;
    DataSource2: TDataSource;
    SQLNo1: TADOQuery;
    N7: TMenuItem;
    Edt_StockName: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCus: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
      ALevel: TcxGridLevel);
    procedure BtnRefreshClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure cxView2DblClick(Sender: TObject);

  private
    { Private declarations }
  protected
    FWhereA : string;
    //未开条件
    FStart,FEnd: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    procedure OnSaveGridConfig(const nIni: TIniFile); override;
    procedure OnInitFormData(var nDefault: Boolean; const nWhere: string = '';
     const nQuery: TADOQuery = nil); override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysBusiness, UBusinessConst, UFormBase, USysDataDict,
  UDataModule, UFormDateFilter, UForminputbox, USysConst, USysDB, USysGrid;

//------------------------------------------------------------------------------
class function TfFrameSalePlan.FrameID: integer;
begin
  Result := cFI_FrameSalePlan;
end;

procedure TfFrameSalePlan.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
  cxGrid1.ActiveLevel := cxLevel1;
end;

procedure TfFrameSalePlan.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameSalePlan.OnLoadGridConfig(const nIni: TIniFile);
begin
  cxGrid1.ActiveLevel := cxLevel1;
  cxGrid1ActiveTabChanged(cxGrid1, cxGrid1.ActiveLevel);

  gSysEntityManager.BuildViewColumn(cxView2, 'MAIN_D15');
  InitTableView(Name, cxView2, nIni);
end;

procedure TfFrameSalePlan.OnSaveGridConfig(const nIni: TIniFile);
begin
  SaveUserDefineTableView(Name, cxView2, nIni);
end;

procedure TfFrameSalePlan.OnInitFormData(var nDefault: Boolean;
  const nWhere: string; const nQuery: TADOQuery);
var nStr: string;
begin
  nDefault := False;

  if (cxGrid1.ActiveLevel=cxLevel1) then
  begin
    nStr := ' Select s.*,g.R_ID Grid, G_Name, CAST(g.R_ID AS VARCHAR(20))+''、''+G_Name GroupName '+
            ' From $SalePlan s Left Join $StockGroup g On g.R_ID=S_StockGid Where 1=1 ';
    if FWhere <> '' then
      nStr := nStr + ' And (' + FWhere + ')';
    //xxxxx

    nStr := MacroValue(nStr, [MI('$SalePlan', sTable_SalePlan),MI('$StockGroup', sTable_StockGroup)]);
    FDM.QueryData(SQLQuery, nStr);
  end;

  if (cxGrid1.ActiveLevel=cxLevel2) then
  begin
    nStr := ' Select * From $SalePlanDtl Where 1=1 ';

    if FWhere <> '' then
        nStr := nStr + ' And (' + FWhere + ')';

    nStr := MacroValue(nStr, [MI('$SalePlanDtl', sTable_SalePlanDtl)]);
    //xxxxx

    FDM.QueryData(SQLNo1, nStr);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFrameSalePlan.cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
  ALevel: TcxGridLevel);
begin
end;

//Desc: 刷新
procedure TfFrameSalePlan.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '';
  InitFormData(FWhere);
end;

procedure TfFrameSalePlan.N1Click(Sender: TObject);
var nRID : string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nRID := SQLQuery.FieldByName('R_ID').AsString;

    FWhere := ' S_PlanID='+nRID+' ';
    cxGrid1.ActiveLevel := cxLevel2;
    InitFormData(FWhere);
  end;
end;

procedure TfFrameSalePlan.cxView1DblClick(Sender: TObject);
begin
  N1Click(Self);
end;

procedure TfFrameSalePlan.EditTruckPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  FWhereA:= '';
  if (Sender = Edt_StockName) and (cxGrid1.ActiveLevel= cxLevel1) then
  begin
    EditCus.Text := '';
  end;

  EditCus.Text := Trim(EditCus.Text);
  if EditCus.Text <> '' then
  begin
    cxGrid1.ActiveLevel:= cxLevel2;

    FWhereA := ' C_CusName like ''%%%s%%''' ;
    FWhere := Format(FWhereA, [ EditCus.Text]);
  end;

  Edt_StockName.Text := Trim(Edt_StockName.Text);
  if Edt_StockName.Text <> '' then
  begin
    if cxGrid1.ActiveLevel= cxLevel2 then
    begin
      if EditCus.Text <> '' then
        FWhere := FWhere + ' And C_StockName like ''%' + Edt_StockName.Text + '%'''

      else FWhere := ' C_StockName like ''%' + Edt_StockName.Text + '%''';
    end
    else  FWhere := ' S_StockName like ''%' + Edt_StockName.Text + '%''';
    //xxxxxx
  end;

  InitFormData(FWhere);
end;

procedure TfFrameSalePlan.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  if cxGrid1.ActiveLevel = cxLevel1 then
       CreateBaseFormItem(cFI_FormSalePlan, PopedomItem, @nParam)
  else CreateBaseFormItem(cFI_FormSalePlanDtl, PopedomItem, @nParam);

  if (nParam.FCommand = mrOk) then
  begin
    BtnRefresh.Click;
  end;
end;

procedure TfFrameSalePlan.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
    nStr, nPName, nMaxNum, nMaxValue, nSTime, nETime : string;
    nPlanID, nPlanName, nStockGID, nCusId, nCusName : string;
begin
  if cxGrid1.ActiveLevel = cxLevel1 then
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  if cxGrid1.ActiveLevel = cxLevel2 then
  if cxView2.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nParam.FCommand := cCmd_EditData;
  if cxGrid1.ActiveLevel = cxLevel1 then
  begin
    nStr     := SQLQuery.FieldByName('R_ID').AsString;
    nPName   := SQLQuery.FieldByName('S_PlanName').AsString;
    nStockGID:= SQLQuery.FieldByName('Grid').AsString +'、'+SQLQuery.FieldByName('G_Name').AsString;
    nSTime   := SQLQuery.FieldByName('S_StartTime').AsString;
    nETime   := SQLQuery.FieldByName('S_EndTime').AsString;
    //*************
    nStr := Format('%s,%s,%s,%s,%s', [nStr, nPName, nStockGID, nSTime, nETime]);
    nParam.FParamA := StringReplace(nStr, ' ', '@', [rfReplaceAll]);
    CreateBaseFormItem(cFI_FormSalePlan, PopedomItem, @nParam);
    ///  销售限量计划
  end
  else
  begin
    nStr      := SQLNo1.FieldByName('R_ID').AsString;
    nCusId    := SQLNo1.FieldByName('S_CusID').AsString;
    nCusName  := SQLNo1.FieldByName('S_CusName').AsString;
    nMaxNum   := SQLNo1.FieldByName('S_MaxNum').AsString;
    nMaxValue := SQLNo1.FieldByName('S_MaxValue').AsString;
    nPlanID   := SQLNo1.FieldByName('S_PlanID').AsString;
    nPlanName := SQLNo1.FieldByName('S_PlanName').AsString;
    //*************
    nParam.FParamA := Format('%s,%s,%s,%s,%s,%s,%s', [nStr, nCusId, nCusName, nMaxValue, nMaxNum, nPlanID, nPlanName]);
    nParam.FParamA := StringReplace(nParam.FParamA, ' ', '@', [rfReplaceAll]);
    CreateBaseFormItem(cFI_FormSalePlanDtl, PopedomItem, @nParam);
    //  客户、物料分组限量明细
  end;

  if (nParam.FCommand = mrOk) then
  begin
    BtnRefresh.Click;
  end;
end;

procedure TfFrameSalePlan.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxGrid1.ActiveLevel = cxLevel1 then
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要操作的记录', sHint); Exit;
  end;

  if cxGrid1.ActiveLevel = cxLevel2 then
  if cxView2.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要操作的记录', sHint); Exit;
  end;

  if not QueryDlg('确定要删除该供应设置么', sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    if cxGrid1.ActiveLevel = cxLevel1 then
    begin
      nStr := SQLQuery.FieldByName('R_ID').AsString;
      nSQL := 'Delete From %s Where R_ID=''%s''';
      nSQL := Format(nSQL, [sTable_SalePlan, nStr]);
    end
    else
    begin
      nStr := SQLNo1.FieldByName('R_ID').AsString;
      nSQL := 'Delete From %s Where R_ID=''%s''';
      nSQL := Format(nSQL, [sTable_SalePlanDtl, nStr]);
    end;

    FDM.ExecuteSQL(nSQL);

    FDM.ADOConn.CommitTrans;
    BtnRefresh.Click;
    ShowMsg('已成功删除记录', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('删除记录失败', '未知错误');
  end;
end;

procedure TfFrameSalePlan.cxView2DblClick(Sender: TObject);
begin
  BtnEdit.Click;
end;

initialization
  gControlManager.RegCtrl(TfFrameSalePlan, TfFrameSalePlan.FrameID);
end.
