unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, FMX.Memo.Types, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.StdCtrls, FMX.Layouts, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, REST.Types,
  FMX.Edit, FMX.Effects, REST.Response.Adapter, REST.Client,
  Data.Bind.ObjectScope, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.EditBox, FMX.ComboTrackBar, FMX.ComboEdit,
  FMX.ListView, FMX.TabControl, System.Threading
  {$IFDEF MSWINDOWS}
  , WinApi.Windows, FMX.MultiView, FMX.Grid.Style, Fmx.Bind.Grid,
  Data.Bind.Controls, Fmx.Bind.Navigator, Data.Bind.Grid, FMX.Grid
  {$ENDIF}
  ;

type
  TMainForm = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    InputMemo: TMemo;
    PromptMemo: TMemo;
    MaterialOxfordBlueSB: TStyleBook;
    OutputMemo: TMemo;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    APIKeyButton: TButton;
    OAAPIKeyEdit: TEdit;
    StatusBar1: TStatusBar;
    ComposeButton: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    RequestVariationButton: TButton;
    BindSourceDB2: TBindSourceDB;
    LinkFillControlToField: TLinkFillControlToField;
    BindSourceDB3: TBindSourceDB;
    LinkFillControlToField1: TLinkFillControlToField;
    BindSourceDB4: TBindSourceDB;
    StatusLabel: TLabel;
    BindSourceDB5: TBindSourceDB;
    TabControl2: TTabControl;
    TabItem4: TTabItem;
    TabItem5: TTabItem;
    HistoryGrid: TStringGrid;
    HistoryMT: TFDMemTable;
    BindSourceDB6: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB6: TLinkGridToDataSource;
    BindNavigator1: TBindNavigator;
    Layout8: TLayout;
    ModelsMT: TFDMemTable;
    BindSourceDB7: TBindSourceDB;
    ProgressBar: TProgressBar;
    Timer: TTimer;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    LoadRecordButton: TButton;
    APIKeyEdit: TEdit;
    RESTClient2: TRESTClient;
    RESTResponse2: TRESTResponse;
    RESTRequest2: TRESTRequest;
    RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter;
    FDMemTable2: TFDMemTable;
    RESTClient3: TRESTClient;
    RESTResponse3: TRESTResponse;
    RESTRequest3: TRESTRequest;
    RESTResponseDataSetAdapter3: TRESTResponseDataSetAdapter;
    FDMemTable3: TFDMemTable;
    PredictionMemo: TMemo;
    VersionEdit: TComboBox;
    LinkListControlToField1: TLinkListControlToField;
    BlogOutputMemo: TMemo;
    KeywordEdit: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    KeywordsEdit: TEdit;
    Label4: TLabel;
    procedure APIKeyButtonClick(Sender: TObject);
    procedure ComposeButtonClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure RequestVariationButtonClick(Sender: TObject);
    procedure OutputMemoChange(Sender: TObject);
    procedure LoadRecordButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function CreateOpenAIChatJSON(const AModel, APrompt: string; AMaxTokens: Integer): string;
    function CreateReplicateJSON(const AVersion, APrompt: string): string;
  public
    { Public declarations }
    FVariation: Boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  System.JSON, System.IOUtils, StrUtils;



function TMainForm.CreateOpenAIChatJSON(const AModel, APrompt: string; AMaxTokens: Integer): string;
var
  RootObj, SystemMessageObj, UserMessageObj: TJSONObject;
  MessagesArray: TJSONArray;
begin
  RootObj := TJSONObject.Create;
  try
    RootObj.AddPair('model', AModel);

    MessagesArray := TJSONArray.Create;
    try
      SystemMessageObj := TJSONObject.Create;
      SystemMessageObj.AddPair('role', 'system');
      SystemMessageObj.AddPair('content', 'You are the writer, blogger, and marketer in the world.');
      MessagesArray.AddElement(SystemMessageObj);

      //if OutPutMemo.Lines.Text='' then
      begin
        UserMessageObj := TJSONObject.Create;
        UserMessageObj.AddPair('role', 'user');
        UserMessageObj.AddPair('content', APrompt);
        MessagesArray.AddElement(UserMessageObj);
      end;

      if FVariation=True then
      begin
        if OutPutMemo.Lines.Text<>'' then
        begin
          UserMessageObj := TJSONObject.Create;
          UserMessageObj.AddPair('role', 'assistant');
          UserMessageObj.AddPair('content', OutPutMemo.Lines.Text);
          MessagesArray.AddElement(UserMessageObj);
        end;

        if OutPutMemo.Lines.Text<>'' then
        begin
          UserMessageObj := TJSONObject.Create;
          UserMessageObj.AddPair('role', 'user');
          UserMessageObj.AddPair('content', 'Use the outline you created and do the following:'+PromptMemo.Lines.Text.Replace('%prompt%',InputMemo.Lines.Text).Replace('%keyword%',KeywordEdit.Text).Replace('%keywords%',KeywordsEdit.Text));
          MessagesArray.AddElement(UserMessageObj);
        end;
      end;

      RootObj.AddPair('messages', MessagesArray);
    except
      MessagesArray.Free;
      raise;
    end;

  //  RootObj.AddPair('max_tokens', TJSONNumber.Create(AMaxTokens));

    Result := RootObj.Format(2); // The number 2 is to specify the formatting indent size
  finally
    RootObj.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  var LFilePath := TPath.Combine(TPath.GetDocumentsPath,'autoblogai.fds');
  if TFile.Exists(LFilePath) then
  begin
    HistoryMT.LoadFromFile(LFilepath);
  end;
end;

procedure TMainForm.LoadRecordButtonClick(Sender: TObject);
begin
  PromptMemo.Lines.Text := HistoryMT.FieldByName('PromptText').AsWideString;
  InputMemo.Lines.Text := HistoryMT.FieldByName('InputText').AsWideString;
  OutputMemo.Lines.Text := HistoryMT.FieldByName('OutputText').AsWideString;
end;

procedure TMainForm.OutputMemoChange(Sender: TObject);
begin
  if OutputMemo.Lines.Text<>'' then
    RequestVariationButton.Enabled := True
  else
    RequestVariationButton.Enabled := False;
end;

procedure TMainForm.RequestVariationButtonClick(Sender: TObject);
begin
  FVariation := True;
  RequestVariationButton.Enabled := False;
  ComposeButtonClick(Sender);
end;

procedure TMainForm.APIKeyButtonClick(Sender: TObject);
begin
  OAAPIKeyEdit.Visible := not OAAPIKeyEdit.Visible;
  APIKeyEdit.Visible := not APIKeyEdit.Visible;
end;

function GetMessageContent(const JSONArray: string): string;
var
  JSONData: TJSONArray;
  MessageObj: TJSONObject;
begin
  Result := '';
  JSONData := TJSONObject.ParseJSONValue(JSONArray) as TJSONArray;
  try
    MessageObj := (JSONData.Items[0] as TJSONObject).GetValue<TJSONObject>('message');
    Result := MessageObj.GetValue<string>('content');
  finally
    JSONData.Free;
  end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  if ProgressBar.Visible = False then
  begin
    Timer.Enabled := False;
  end
  else
  begin
    if ProgressBar.Value=ProgressBar.Max then
      ProgressBar.Value := ProgressBar.Min
    else
      ProgressBar.Value := ProgressBar.Value+5;
  end;
end;


function ConcatJSONStrings(const JSONArray: string): string;
var
  JSONData: TJSONArray;
  I: Integer;
begin
  if JSONArray[1]='[' then
  begin

  Result := '';
  JSONData := TJSONObject.ParseJSONValue(JSONArray) as TJSONArray;
  try
    for I := 0 to JSONData.Count - 1 do
      Result := Result + JSONData.Items[I].Value;
  finally
    JSONData.Free;
  end;
  end
  else
  Result := JSONArray;
end;


function TMainForm.CreateReplicateJSON(const AVersion, APrompt: string): string;
var
  RootObj, InputObj: TJSONObject;
begin
  RootObj := TJSONObject.Create;
  try
    RootObj.AddPair('version', AVersion);

    InputObj := TJSONObject.Create;
    try
      var LPrompt := 'You are the writer, blogger, and marketer in the world.';

      if FVariation=True then
      begin
        LPrompt := LPrompt + ' Here is an outline: ' + OutPutMemo.Lines.Text + ' Use the outline you created and do the following:'+PromptMemo.Lines.Text.Replace('%prompt%',APrompt).Replace('%keyword%',KeywordEdit.Text).Replace('%keywords%',KeywordsEdit.Text)
      end
      else
      begin
        LPrompt := LPrompt + 'Create an outline (all subtitles as questions; NEVER use roman numerals, numbers, or letters for outline sections) for an article about: ' + APrompt;
      end;


      InputObj.AddPair('prompt', LPrompt);
     // InputObj.AddPair('max_tokens', TJSONNumber.Create(AMaxTokens));

      RootObj.AddPair('input', InputObj);
    except
      InputObj.Free;
      raise;
    end;

    Result := RootObj.ToString;
  finally
    RootObj.Free;
  end;
end;

procedure TMainForm.ComposeButtonClick(Sender: TObject);
begin
  if OAAPIKeyEdit.Text='' then
  begin
    ShowMessage('Enter an OpenAI API key.');
    Exit;
  end;

  ComposeButton.Enabled := False;
  ProgressBar.Visible := True;
  Timer.Enabled := True;

  TTask.Run(procedure begin
    if ModelsMT.FieldByName('provider').AsWideString='openai' then
    begin
      RESTRequest1.Params[0].Value := 'Bearer ' + OAAPIKeyEdit.Text;
      RESTRequest1.Params[1].Value := CreateOpenAIChatJSON(VersionEdit.Selected.Text, 'Create an outline (all titles and subtitles as questions; NEVER use roman numerals, numbers, or letters for outline sections) for an article about: ' + InputMemo.Lines.Text, 2000);
      RESTRequest1.Execute;

      if FDMemTable1.FindField('choices')<>nil then
      begin
        TThread.Synchronize(nil,procedure begin
          if FVariation=True then
            BlogOutputMemo.Lines.Text := GetMessageContent(FDMemTable1.FieldByName('choices').AsWideString)
          else
            OutputMemo.Lines.Text := GetMessageContent(FDMemTable1.FieldByName('choices').AsWideString);

          StatusLabel.Text := FDMemTable1.FieldByName('usage').AsWideString;

          RequestVariationButton.Enabled := True;

          HistoryMT.AppendRecord([PromptMemo.Lines.Text, InputMemo.Lines.Text, OutputMemo.Lines.Text]);

          HistoryMT.SaveToFile(TPath.Combine(TPath.GetDocumentsPath,'autoblogai.fds'));
        end);
      end;
    end
    else if ModelsMT.FieldByName('provider').AsWideString='replicate' then
    begin
      RESTRequest2.Params[0].Value := 'Token ' + APIKeyEdit.Text;
      RESTRequest2.Params[1].Value := CreateReplicateJSON(ModelsMT.FieldByName('model').AsWideString, InputMemo.Lines.Text);
      RESTRequest2.Execute;

      if FDMemTable2.FindField('id')<>nil then
      begin
         var LStatus := 'started';
         while ((LStatus<>'succeeded') AND (LStatus<>'failed')) do
         begin
           RESTRequest3.Resource := FDMemTable2.FieldByName('id').AsWideString;
           RESTRequest3.Params[0].Value := 'Token ' + APIKeyEdit.Text;
           RESTRequest3.Execute;
           LStatus := FDMemTable3.FieldByName('status').AsWideString;

           if LStatus='succeeded' then
           begin
             var LOutput := ConcatJSONStrings(FDMemTable3.FieldByName('output').AsWideString);
             if LOutput<>'' then
             begin
                TThread.Synchronize(nil,procedure begin
                  if FVariation=True then
                    BlogOutputMemo.Lines.Text := LOutput
                  else
                    OutputMemo.Lines.Text := LOutput;

                  RequestVariationButton.Enabled := True;

                  HistoryMT.AppendRecord([PromptMemo.Lines.Text, InputMemo.Lines.Text, OutputMemo.Lines.Text]);

                  HistoryMT.SaveToFile(TPath.Combine(TPath.GetDocumentsPath,'autoblogai.fds'));
                end);

             end;
           end
           else
           begin
              TThread.Synchronize(nil,procedure begin
                 StatusLabel.Text := LStatus;
              end);
           end;

           Sleep(3000);

         end;
      end;

    end;

    TThread.Synchronize(nil,procedure begin
      ComposeButton.Enabled := True;
      ProgressBar.Visible := False;
    end);
    FVariation := False;
  end);
end;





end.
