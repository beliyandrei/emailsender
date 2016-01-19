unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gauges, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdMessage;

type
  TfMain = class(TForm)
    bStartStop: TButton;
    pQueue: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    mSent: TMemo;
    mQueue: TMemo;
    bAdd: TButton;
    bClear: TButton;
    bClearSent: TButton;
    pProgress: TPanel;
    Label3: TLabel;
    mLog: TMemo;
    gProgress: TGauge;
    pEmail: TPanel;
    edSubject: TEdit;
    Label4: TLabel;
    edText: TMemo;
    Label5: TLabel;
    pServer: TPanel;
    Label6: TLabel;
    edServer: TEdit;
    Label7: TLabel;
    edPort: TEdit;
    Label8: TLabel;
    edLogin: TEdit;
    Label9: TLabel;
    edPass: TEdit;
    Label10: TLabel;
    edEmailFrom: TEdit;
    Label11: TLabel;
    edNameFrom: TEdit;
    cbUseSSL: TCheckBox;
    Label12: TLabel;
    edMaxRec: TEdit;
    Label13: TLabel;
    edDelay: TEdit;
    od: TOpenDialog;
    smtp: TIdSMTP;
    ssl: TIdSSLIOHandlerSocketOpenSSL;
    mess: TIdMessage;
    Label14: TLabel;
    edEmailClient: TEdit;
    Label15: TLabel;
    edHelo: TEdit;
    cbUseHelo: TCheckBox;
    procedure bAddClick(Sender: TObject);
    procedure bClearClick(Sender: TObject);
    procedure bClearSentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bStartStopClick(Sender: TObject);
  private
    iniFile : string;
    isStop:boolean;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure StartSending;
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

uses IniFiles;
{$R *.dfm}

procedure TfMain.bAddClick(Sender: TObject);
var i:integer;
begin
  if (od.Execute() and (FileExists(od.FileName))) then
  try
    mQueue.Lines.LoadFromFile(od.FileName);
    if mQueue.Lines.Count > 0 then
      for I := mQueue.Lines.Count - 1 downto 0 do
        if pos('@',mQueue.Lines.Strings[i])<=0 then
          mQueue.Lines.Delete(i);
    if pos('@',mQueue.Lines.Text) > 0 then
      MessageDlg('Added ['+inttostr(mQueue.Lines.Count)+'] emails into queue.',mtInformation,[mbOk],-1) else
      MessageDlg('Emails seems to be not valid!',mtWarning,[mbOk],-1);
  except
    on e:exception do
      begin
        MessageDlg('Error loading file'+sLineBreak+e.Message,mtError,[mbOk],-1);
      end;
  end;

end;

procedure TfMain.bClearClick(Sender: TObject);
begin
  if mQueue.Lines.Count = 0 then exit;

  if MessageDlg('Do you want to clear queue?',mtConfirmation,[mbYes,mbNo],-1)=mrYes then
    mQueue.Lines.Clear;
end;

procedure TfMain.bClearSentClick(Sender: TObject);
begin
  if mSent.Lines.Count = 0 then exit;

  if MessageDlg('Do you want to clear sent?',mtConfirmation,[mbYes,mbNo],-1)=mrYes then
    mSent.Lines.Clear;
end;

procedure TfMain.bStartStopClick(Sender: TObject);
begin
  if isStop and (mQueue.Lines.Count = 0) then exit;

  if isStop then
    StartSending else
    isStop := true;
end;

procedure TfMain.StartSending;
var added:integer;
    emails:string;
begin
  gProgress.MinValue := 0;
  gProgress.Progress := 0;
  gProgress.MaxValue := mQueue.Lines.Count;
  mLog.Lines.Insert(0, DateTimeToStr(now)+' - SMTP Sending start');

  isStop := false;
  try
    if smtp.Connected then
      smtp.Disconnect();
  except
    on e:exception do
      begin
        mLog.Lines.Insert(0,DateTimeToStr(now)+' - SMTP Disconnection ERROR '+e.Message);
        isStop := true;
      end;
  end;
  if isStop then exit;

  smtp.MailAgent := edEmailClient.Text;
  smtp.HeloName := edHelo.Text;
  smtp.UseEhlo := cbUseHelo.Checked;
  smtp.Host := edServer.Text;
  smtp.Port := StrToInt(edPort.Text);
  smtp.Username := edLogin.Text;
  smtp.Password := edPass.Text;

  if cbUseSSL.Checked then
  begin
    SSL.Destination := smtp.Host + ':' + inttostr(smtp.Port);
    SSL.Host := smtp.Host;
    SSL.Port := smtp.Port;
    SSL.SSLOptions.Method := sslvSSLv3;
    SSL.SSLOptions.Mode := sslmUnassigned;
    smtp.IOHandler := SSL;
    smtp.UseTLS := utUseImplicitTLS;
  end else
    begin
      smtp.IOHandler := nil;
      smtp.UseTLS := utNoTLSSupport;
    end;

  mess.CharSet := 'utf-8';
  mess.ContentType := 'text/plain';
  SysLocale.PriLangID := LANG_SYSTEM_DEFAULT;
  mess.Subject := edSubject.Text;
  mess.Body.TEXT := edText.Lines.Text;
  mess.From.Address := edEmailFrom.Text;
  mess.From.Name := edNameFrom.Text;

  bStartStop.Caption := 'STOP';
  pQueue.Enabled := false;
  pProgress.Enabled := false;
  pEmail.Enabled := false;
  pServer.Enabled := false;

  while not(isStop) and (mQueue.Lines.Count > 0) do
  begin
    try
      if smtp.Connected then
      smtp.Disconnect();
      smtp.Connect;
    except
      on e:exception do
      begin
        mLog.Lines.Insert(0,DateTimeToStr(now)+' - SMTP Connection ERROR '+e.Message);
        isStop := true;
      end;
    end;
    if isStop then break;

    emails := '';
    mess.Recipients.Clear;
    added := 0;
    while (added < StrToIntDef(edMaxRec.Text,1)) and ((mQueue.Lines.Count - added) > 0) do
    begin
      mess.Recipients.Add.Address := mQueue.Lines.Strings[added];
      if added > 0 then
      emails := emails + ',';
      emails := emails + mQueue.Lines.Strings[added];
      added := added + 1;
    end;

    try
      smtp.Send(mess);
      smtp.Disconnect;
      mLog.Lines.Insert(0, DateTimeToStr(now)+' - SMTP Sending OK :'+emails);
      gProgress.Progress := gProgress.Progress + added;
      while added > 0 do
      begin
        mSent.Lines.Add(mQueue.Lines.Strings[0]);
        mQueue.Lines.Delete(0);
        added := added - 1;
      end;
      Application.ProcessMessages;
      if StrToIntDef(edDelay.Text,1) > 0 then
        Sleep(StrToIntDef(edDelay.Text,1));
    except
      on e:exception do
      begin
        mLog.Lines.Insert(0,DateTimeToStr(now)+' - SMTP Sending ERROR '+e.Message);
        isStop := true;
      end;
    end;
    Application.ProcessMessages;
  end;

  isStop := true;
  bStartStop.Caption := 'START';
  pQueue.Enabled := true;
  pProgress.Enabled := true;
  pEmail.Enabled := true;
  pServer.Enabled := true;
  mLog.Lines.SaveToFile('Sending.log',TEncoding.UTF8);
end;

procedure TfMain.SaveToIni;
var ini:TIniFile;
begin
  mQueue.Lines.SaveToFile('Queue.txt',TEncoding.UTF8);
  mSent.Lines.SaveToFile('Sent.txt',TEncoding.UTF8);
  mLog.Lines.SaveToFile('Sending.log',TEncoding.UTF8);
  edText.Lines.SaveToFile('EmailText.txt',TEncoding.UTF8);

  ini := TIniFile.Create(iniFile);
  ini.WriteString('EMAIL','SUBJECT',edSubject.Text);
  ini.WriteString('SERVER','SMTP',edServer.Text);
  ini.WriteString('SERVER','PORT',edPort.Text);
  ini.WriteString('SERVER','LOGIN',edLogin.Text);
  ini.WriteString('SERVER','PASS',edPass.Text);
  ini.WriteString('SERVER','EMAILFROM',edEmailFrom.Text);
  ini.WriteString('SERVER','NAMEFROM',edNameFrom.Text);
  if cbUseSSL.Checked then
    ini.WriteString('SERVER','IS_SSL','1') else
    ini.WriteString('SERVER','IS_SSL','0');
  ini.WriteInteger('SERVER','MAXREC',StrToIntDef(edMaxRec.Text,1));
  ini.WriteInteger('SERVER','DELAY',StrToIntDef(edDelay.Text,1000));

  ini.WriteString('SERVER','HELONAME',edHelo.Text);
  ini.WriteString('SERVER','EMAILCLIENT',edEmailClient.Text);
  if cbUseHelo.Checked then
    ini.ReadString('SERVER','USE_HELO','1') else
    ini.ReadString('SERVER','USE_HELO','0');

  ini.Free;
end;

procedure TfMain.LoadFromIni;
var ini:TIniFile;
begin
  if FileExists('Queue.txt') then
    mQueue.Lines.LoadFromFile('Queue.txt',TEncoding.UTF8);
  if FileExists('Sent.txt') then
    mSent.Lines.LoadFromFile('Sent.txt',TEncoding.UTF8);
  if FileExists('Sending.log') then
    mLog.Lines.LoadFromFile('Sending.log',TEncoding.UTF8);
  if FileExists('EmailText.txt') then
    edText.Lines.LoadFromFile('EmailText.txt',TEncoding.UTF8);

  ini := TIniFile.Create(iniFile);
  edSubject.Text := ini.ReadString('EMAIL','SUBJECT','Subject');
  edServer.Text := ini.ReadString('SERVER','SMTP','smtp.server.com');
  edPort.Text := ini.ReadString('SERVER','PORT','25');
  edLogin.Text := ini.ReadString('SERVER','LOGIN','user@user.com');
  edPass.Text := ini.ReadString('SERVER','PASS','1234');
  edEmailFrom.Text := ini.ReadString('SERVER','EMAILFROM','user@user.com');
  edNameFrom.Text := ini.ReadString('SERVER','NAMEFROM','Email sender');
  cbUseSSL.Checked := (ini.ReadString('SERVER','IS_SSL','0') = '1');
  edMaxRec.Text := IntToStr(ini.ReadInteger('SERVER','MAXREC',1));
  edDelay.Text := IntToStr(ini.ReadInteger('SERVER','DELAY',1000));

  edHelo.Text := ini.ReadString('SERVER','HELONAME','');
  edEmailClient.Text := ini.ReadString('SERVER','EMAILCLIENT','');
  cbUseHelo.Checked := (ini.ReadString('SERVER','USE_HELO','1') = '1');

  ini.Free;

end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveToIni;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  iniFile := ExtractFilePath(ParamStr(0))+StringReplace(ExtractFileName(ParamStr(0)),ExtractFileExt(ParamStr(0)),'.ini',[]);
  LoadFromIni;
  isStop := true;
end;

end.
