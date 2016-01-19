unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gauges, ExtCtrls;

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
    Memo1: TMemo;
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
    Edit1: TEdit;
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
    procedure bAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.bAddClick(Sender: TObject);
begin
  if (od.Execute() and (FileExists(od.FileName))) then
  try
    mQueue.Lines.LoadFromFile(od.FileName);
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

end.
