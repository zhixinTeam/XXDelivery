{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-11-27
  描述: 统一管理系统级对象
*******************************************************************************}
unit USysObject;

interface

uses
  SysUtils, Classes, USysConst, USysMenu, USysPopedom, UMgrLog;

procedure InitSystemObject;
procedure FreeSystemObject;
//创建释放系统级对象    

implementation

//------------------------------------------------------------------------------
//Desc: 写日志文件
procedure WriteLog(const nThread: TLogThread; const nLogs: TList);
var nStr: string;
    nFile: TextFile;
    nItem: PLogItem;
    i,nCount: integer;
begin
  nStr := gPath + sLogDir;
  if not DirectoryExists(nStr) then CreateDir(nStr);
  nStr := nStr + DateToStr(Now) + sLogExt;

  AssignFile(nFile, nStr);
  if FileExists(nStr) then
       Append(nFile)
  else Rewrite(nFile);

  try
    nCount := nLogs.Count - 1;
    for i:=0 to nCount do
    begin
      if nThread.Terminated then Exit;
      nItem := nLogs[i];

      nStr := DateTimeToStr(nItem.FTime) + sLogField +       //时间
              nItem.FWriter.FOjbect.ClassName + sLogField +  //类名
              nItem.FWriter.FDesc + sLogField +              //描述
              nItem.FEvent;                                  //事件
      WriteLn(nFile, nStr);
    end;
  finally
    CloseFile(nFile);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化系统对象
procedure InitSystemObject;
begin
  if not Assigned(gLogManager) then
  begin
    gLogManager := TLogManager.Create;
    gLogManager.WriteProcedure := WriteLog;
  end;
end;

//Desc: 释放系统对象
procedure FreeSystemObject;
begin
  FreeAndNil(gLogManager);
end;

end.
