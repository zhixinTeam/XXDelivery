{*******************************************************************************
  作者: juner11212436@163.com 2018-10-25
  描述: 恒河久远相关业务和数据处理
*******************************************************************************}
unit UWorkerBussinessHHJY;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, SysUtils, DB, ADODB, NativeXml, UBusinessWorker,
  UBusinessPacker, UBusinessConst, UMgrDBConn, UMgrParam, UFormCtrl, USysLoger,
  ZnMD5, ULibFun, USysDB, UMITConst, UMgrChannel, UWorkerBusiness,IdHTTP,Graphics,
  Variants, uLkJSON, V_Sys_Materiel_Intf, V_SaleConsignPlanBill_Intf,
  V_SupplyMaterialEntryPlan_Intf, xxykt_Intf;

type
  TMITDBWorker = class(TBusinessWorkerBase)
  protected
    FErrNum: Integer;
    //错误码
    FDBConn: PDBWorker;
    //数据通道
    FXXChannel: PChannelItem;
    FDataIn,FDataOut: PBWDataBase;
    //入参出参
    FDataOutNeedUnPack: Boolean;
    //需要解包
    FPackOut: Boolean;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); virtual; abstract;
    //出入参数
    function VerifyParamIn(var nData: string): Boolean; virtual;
    //验证入参
    function DoDBWork(var nData: string): Boolean; virtual; abstract;
    function DoAfterDBWork(var nData: string; nResult: Boolean): Boolean; virtual;
    //数据业务
  public
    function DoWork(var nData: string): Boolean; override;
    //执行业务
    procedure WriteLog(const nEvent: string);
    //记录日志
  end;

  TBusWorkerBusinessHHJY = class(TMITDBWorker)
  private
    FListA,FListB,FListC,FListD,FListE: TStrings;
    //list
    FIn: TWorkerHHJYData;
    FOut: TWorkerHHJYData;
    //in out
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function GetCusName(nCusID: string): string;
    function SyncHhSalePlan(var nData:string):boolean;
    //同步销售计划
    function SyncHhOrderPlan(var nData: string): Boolean;
    //获取普通原材料进厂计划
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function CallMe(const nCmd: Integer; const nData,nExt: string;
      const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

implementation

//Date: 2012-3-13
//Parm: 如参数护具
//Desc: 获取连接数据库所需的资源
function TMITDBWorker.DoWork(var nData: string): Boolean;
begin
  Result := False;
  FDBConn := nil;
  FXXChannel := nil;

  with gParamManager.ActiveParam^ do
  try
    FDBConn := gDBConnManager.GetConnection(FDB.FID, FErrNum);
    if not Assigned(FDBConn) then
    begin
      nData := '连接数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db

    FXXChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(FXXChannel) then
    begin
      nData := '连接ERP服务失败(Wechat Web Service No Channel).';
      Exit;
    end;

    with FXXChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := Coxxykt.Create(FMsg, FHttp);
      FHttp.TargetUrl := gSysParam.FERPSrv;
    end; //config web service channel

    FDataOutNeedUnPack := True;
    GetInOutData(FDataIn, FDataOut);
    FPacker.UnPackIn(nData, FDataIn);

    with FDataIn.FVia do
    begin
      FUser   := gSysParam.FAppFlag;
      FIP     := gSysParam.FLocalIP;
      FMAC    := gSysParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := FWorkTimeInit;
    end;

    {$IFDEF DEBUG}
    WriteLog('Fun: '+FunctionName+' InData:'+ FPacker.PackIn(FDataIn, False));
    {$ENDIF}
    if not VerifyParamIn(nData) then Exit;
    //invalid input parameter

    FPacker.InitData(FDataOut, False, True, False);
    //init exclude base
    FDataOut^ := FDataIn^;

    Result := DoDBWork(nData);
    //execute worker

    if Result then
    begin
      if FDataOutNeedUnPack then
        FPacker.UnPackOut(nData, FDataOut);
      //xxxxx

      Result := DoAfterDBWork(nData, True);
      if not Result then Exit;

      with FDataOut.FVia do
        FKpLong := GetTickCount - FWorkTimeInit;
      if FPackOut then
      begin
        WriteLog('打包');
        nData := FPacker.PackOut(FDataOut);
      end;

      {$IFDEF DEBUG}
      WriteLog('Fun: '+FunctionName+' OutData:'+ FPacker.PackOut(FDataOut, False));
      {$ENDIF}
    end else DoAfterDBWork(nData, False);
  finally
    gDBConnManager.ReleaseConnection(FDBConn);
    gChannelManager.ReleaseChannel(FXXChannel);
  end;
end;

//Date: 2012-3-22
//Parm: 输出数据;结果
//Desc: 数据业务执行完毕后的收尾操作
function TMITDBWorker.DoAfterDBWork(var nData: string; nResult: Boolean): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-18
//Parm: 入参数据
//Desc: 验证入参数据是否有效
function TMITDBWorker.VerifyParamIn(var nData: string): Boolean;
begin
  Result := True;
end;

//Desc: 记录nEvent日志
procedure TMITDBWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TMITDBWorker, FunctionName, nEvent);
end;

//------------------------------------------------------------------------------
class function TBusWorkerBusinessHHJY.FunctionName: string;
begin
  Result := sBus_BusinessHHJY;
end;

constructor TBusWorkerBusinessHHJY.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  FListD := TStringList.Create;
  FListE := TStringList.Create;
  inherited;
end;

destructor TBusWorkerBusinessHHJY.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  FreeAndNil(FListD);
  FreeAndNil(FListE);
  inherited;
end;

function TBusWorkerBusinessHHJY.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessHHJY;
  end;
end;

procedure TBusWorkerBusinessHHJY.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: 命令;数据;参数;输出
//Desc: 本地调用业务对象
class function TBusWorkerBusinessHHJY.CallMe(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerHHJYData;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessHHJY);
    nPacker.InitData(@nIn, True, False);
    //init

    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessHHJY);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2012-3-22
//Parm: 输入数据
//Desc: 执行nData业务指令
function TBusWorkerBusinessHHJY.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := '业务执行成功.';
  end;
  FPackOut := True;

  case FIn.FCommand of
   cBC_GetHhSalePlan           : Result := SyncHhSalePlan(nData);

   cBC_GetHhOrderPlan          : Result := SyncHhOrderPlan(nData);
  else
    begin
      Result := False;
      nData := '无效的业务代码(Code: %d Invalid Command).';
      nData := Format(nData, [FIn.FCommand]);
    end;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhSalePlan(
  var nData: string): boolean;
var nStr, nCusID, nCusName, nType: string;
    nInt, nIdx: Integer;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nMoney, nYf: Double;
    nOut: TWorkerBusinessCommand;
    nOnlYMoney : Boolean;
begin
  Result := False;
  nCusID := PackerDecodeStr(FIn.FData);
  nOnlYMoney := FIn.FExtParam = sFlag_Yes;
  if Trim(nCusID) = '' then
    Exit;

  nCusName := GetCusName(nCusID);

  try
    WriteLog('获取销售订单入参'+nCusID+','+nCusName);

    nStr := Ixxykt(FXXChannel^.FChannel).Customer_YE(nCusID);

    WriteLog('获取销售订单出参'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    if not Assigned(nJS) then
    begin
      nData := '同步销售订单接口调用异常.格式无法解析:' + nStr;
      WriteLog(nData);
      Exit;
    end;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '获取销售订单接口调用异常.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if not IsNumber(VarToStr(nJS.Field['Money'].Value), True) then
    begin
      nData := '获取销售订单接口调用异常.客户金额非法' + VarToStr(nJS.Field['Money'].Value);
      WriteLog(nData);
      Exit;
    end;
    nMoney := StrToFloat(VarToStr(nJS.Field['Money'].Value));

    if nMoney < 0 then
    begin
      nData := '客户金额不足：' + VarToStr(nJS.Field['Money'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nOnlYMoney then
    begin
      nData := VarToStr(nJS.Field['Money'].Value);
      Result := True;
      FOut.FData := nData;
      FOut.FBase.FResult := True;
      Exit;
    end;

    if not IsNumber(VarToStr(nJS.Field['yunfei'].Value), True) then
    begin
      nData := '获取销售订单接口调用异常.客户运费非法' + VarToStr(nJS.Field['yunfei'].Value);
      WriteLog(nData);
      Exit;
    end;
    nYf := StrToFloat(VarToStr(nJS.Field['yunfei'].Value));

    nStr := 'Update %s Set O_Valid = ''%s'' Where O_CusID=''%s''';
    nStr := Format(nStr, [sTable_SalesOrder, sFlag_No, nCusID]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    if nJS.Field['DATA'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['DATA'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '获取销售订单接口调用异常.' + FIn.FData + 'Data节点为空';
        WriteLog(nData);
        Exit;
      end;

      FDBConn.FConn.BeginTrans;
      try
        for nIdx := 0 to nJSRow.Count - 1 do
        begin
          nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

          FListA.Clear;
          for nInt := 0 to nJSCol.Count - 1 do
          begin
            FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
          end;

          if Pos('袋', FListA.Values['cInvName']) > 0 then
            nType := sFlag_Dai
          else
            nType := sFlag_San;

          nStr := SF('O_CusID', nCusID) + ' and '+SF('O_StockID', FListA.Values['cInvCode']);
          nStr := MakeSQLByStr([
                  SF('O_Factory', FListA.Values['FFactoryName']),
                  SF('O_CusName', nCusName),
                  SF('O_ConsignCusName', FListA.Values['FConsignName']),
                  SF('O_StockName', FListA.Values['cInvName']),
                  SF('O_StockType', nType),
                  SF('O_Lading', '自提'),
                  SF('O_CusPY', GetPinYinOfStr(nCusName)),
                  SF('O_PlanAmount', FListA.Values['FPlanAmount']),
                  SF('O_PlanDone', FListA.Values['FBillAmount']),
                  SF('O_PlanRemain', FListA.Values['FRemainAmount']),
                  SF('O_PlanBegin', StrToDateDef(FListA.Values['FBeginDate'],Now),sfDateTime),
                  SF('O_PlanEnd', StrToDateDef(FListA.Values['FEndDate'],Now),sfDateTime),
                  SF('O_Company', FListA.Values['FCompanyName']),
                  SF('O_Depart', FListA.Values['FSaleOrgName']),
                  SF('O_SaleMan', FListA.Values['FSaleManID']),
                  SF('O_Remark', FListA.Values['FRemark']),
                  SF('O_Price', StrToFloatDef(FListA.Values['iInvSCost'],0),sfVal),
                  SF('O_Valid', sFlag_Yes),
                  SF('O_CompanyID', FListA.Values['FCompanyID']),
                  SF('O_CusID', nCusID),
                  SF('O_StockID', FListA.Values['cInvCode']),
                  SF('O_PackingID', FListA.Values['FPackingID']),
                  SF('O_FactoryID', FListA.Values['FFactoryID']),
                  SF('O_Money', nMoney ,sfVal),
                  SF('O_YF', nYf, sfVal),
                  SF('O_Create', StrToDateDef(FListA.Values['FCreateTime'],Now),sfDateTime),
                  SF('O_Modify', StrToDateDef(FListA.Values['FModifyTime'],Now),sfDateTime)
                  ], sTable_SalesOrder, nStr, False);

          if gDBConnManager.WorkerExec(FDBConn,nStr) <= 0 then
          begin
            FListC.Clear;
            FListC.Values['Group'] :=sFlag_BusGroup;
            FListC.Values['Object'] := sFlag_SaleOrderNo;
            //to get serial no

            if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
                  FListC.Text, sFlag_Yes, @nOut) then
              raise Exception.Create(nOut.FData);
            //xxxxx

            nStr := MakeSQLByStr([SF('O_Order', nOut.FData),
                    SF('O_Factory', FListA.Values['FFactoryName']),
                    SF('O_CusName', nCusName),
                    SF('O_ConsignCusName', FListA.Values['FConsignName']),
                    SF('O_StockName', FListA.Values['cInvName']),
                    SF('O_StockType', nType),
                    SF('O_Lading', '自提'),
                    SF('O_CusPY', GetPinYinOfStr(nCusName)),
                    SF('O_PlanAmount', FListA.Values['FPlanAmount']),
                    SF('O_PlanDone', FListA.Values['FBillAmount']),
                    SF('O_PlanRemain', FListA.Values['FRemainAmount']),
                    SF('O_PlanBegin', StrToDateDef(FListA.Values['FBeginDate'],Now),sfDateTime),
                    SF('O_PlanEnd', StrToDateDef(FListA.Values['FEndDate'],Now),sfDateTime),
                    SF('O_Company', FListA.Values['FCompanyName']),
                    SF('O_Depart', FListA.Values['FSaleOrgName']),
                    SF('O_SaleMan', FListA.Values['FSaleManID']),
                    SF('O_Remark', FListA.Values['FRemark']),
                    SF('O_Price', StrToFloatDef(FListA.Values['iInvSCost'],0),sfVal),
                    SF('O_Valid', sFlag_Yes),
                    SF('O_CompanyID', FListA.Values['FCompanyID']),
                    SF('O_CusID', nCusID),
                    SF('O_StockID', FListA.Values['cInvCode']),
                    SF('O_PackingID', FListA.Values['FPackingID']),
                    SF('O_FactoryID', FListA.Values['FFactoryID']),
                    SF('O_Money', nMoney ,sfVal),
                    SF('O_YF', nYf, sfVal),
                    SF('O_Create', StrToDateDef(FListA.Values['FCreateTime'],Now),sfDateTime),
                    SF('O_Modify', StrToDateDef(FListA.Values['FModifyTime'],Now),sfDateTime)
                    ], sTable_SalesOrder, '', True);
            gDBConnManager.WorkerExec(FDBConn,nStr)
          end;
        end;

        FDBConn.FConn.CommitTrans;
      except
        if FDBConn.FConn.InTransaction then
          FDBConn.FConn.RollbackTrans;
        raise;
      end;
    end
    else
    begin
      nData := '获取销售订单接口调用异常.Data节点异常';
      WriteLog(nData);
      Exit;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    if Assigned(nJS) then
      nJS.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhOrderPlan(
  var nData: string): boolean;
var nStr: string;
    nInt, nIdx: Integer;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nValue: Double;
begin
  Result := False;
  nStr := PackerDecodeStr(FIn.FData);

  FListD.Clear;

  FListD.Text := nStr;

  try
    WriteLog('获取普通原材料订单入参'+nStr);

    nStr := Ixxykt(FXXChannel^.FChannel).VenInv(FListD.Values['ProviderNo']);

    WriteLog('获取普通原材料订单出参'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    if not Assigned(nJS) then
    begin
      nData := '同步销售订单接口调用异常.格式无法解析:' + nStr;
      WriteLog(nData);
      Exit;
    end;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '获取普通原材料订单接口调用异常.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['DATA'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['DATA'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '获取普通原材料订单接口调用异常.' + FIn.FData + 'Data节点为空';
        WriteLog(nData);
        Exit;
      end;

      FListA.Clear;
      FListC.Clear;
      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        FListB.Clear;
        FListC.Clear;
        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListC.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;

        with FListB do
        begin
          Values['Order']         := FListC.Values['Order'];
          Values['ProName']       := FListD.Values['ProviderName'];
          Values['ProID']         := FListD.Values['ProviderNo'];
          Values['StockName']     := FListC.Values['cInvName'];
          Values['StockID']       := FListC.Values['cInvCode'];
          Values['StockNo']       := FListC.Values['cInvCode'];

          Values['Value']         := '10000';//剩余量

          FListA.Add(PackerEncodeStr(FListB.Text));
        end;
      end;
      nData := PackerEncodeStr(FListA.Text);
    end
    else
    begin
      nData := '获取普通原材料订单接口调用异常.Data节点异常';
      WriteLog(nData);
      Exit;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    if Assigned(nJS) then
      nJS.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetCusName(nCusID: string): string;
var nStr: string;
begin
  Result := '';
  nStr := 'Select C_Name From %s Where C_ID=''%s'' ';
  nStr := Format(nStr, [sTable_Customer, nCusID]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
  end;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerBusinessHHJY, sPlug_ModuleBus);
end.
