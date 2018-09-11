unit ufrmSetupProfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Menus, uLeicaGPSData, janXMLTree;

type
  TfrmProfile = class(TForm)
    lstProfiles: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    miProfile_Rename: TMenuItem;
    miProfile_NewProfile: TMenuItem;
    N1: TMenuItem;
    miProfile_Delete: TMenuItem;
    chklstPoints: TCheckListBox;
    procedure FormCreate(Sender: TObject);
    procedure chklstPointsClickCheck(Sender: TObject);
    procedure miProfile_RenameClick(Sender: TObject);
    procedure miProfile_NewProfileClick(Sender: TObject);
    procedure miProfile_DeleteClick(Sender: TObject);
    procedure lstProfilesClick(Sender: TObject);
  private
    { Private declarations }
    FProfilesNode: TjanXMLNode;  //���涨�嶥�ڵ�
    procedure InitProfileList;
    { �ҳ�����AProfile�ĵ㣬����chklstPoints }
    procedure SetPointsBelongProfile(AProfile: String);
  public
    { Public declarations }
  end;

var
  frmProfile: TfrmProfile;

implementation

{$R *.dfm}
{-----------------------------------------------------------------------------
  Procedure:    TfrmProfile.FormCreate
  Description:
-----------------------------------------------------------------------------}
procedure TfrmProfile.FormCreate(Sender: TObject);
begin
        FProfilesNode := PrjSetting.findNamedNode('Profiles');
        InitProfileList;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmProfile.InitProfileList
  Description:
-----------------------------------------------------------------------------}
procedure TfrmProfile.InitProfileList;
var
        i: Integer;
begin
        if not FProfilesNode.hasChildNodes then Exit;
        for i := 0 to FProfilesNode.Nodes.Count -1 do
        begin
            lstProfiles.Items.Add(TjanXMLNode(FProfilesNode.Nodes.Items[i]).Name);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmProfile.SetPointsBelongProfile
  Description:
-----------------------------------------------------------------------------}
procedure TfrmProfile.SetPointsBelongProfile(AProfile: String);
var     pfNode: TjanXMLNode;
        i,j: Integer;
        PName: String;
begin
        for i:= 0 to chklstPoints.Count -1 do
            chklstPoints.Checked[i] := False;

        pfNode := FProfilesNode.findNamedNode(AProfile);
        if pfNode = nil then
        begin
            for i := 0 to chklstPoints.Count -1 do
                chklstPoints.Checked[i] := False;
            exit;
        end;

        for i := 0 to pfNode.Nodes.Count -1 do
        begin
            PName := TjanXMLNode(pfNode.Nodes[i]).Name;
            j := chklstPoints.Items.IndexOf(PName);
            if j <> -1 then chklstPoints.Checked[j] := True;
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmProfile.chklstPointsClickCheck
  Description:  ����ѡ��Profile�ĵ�  
-----------------------------------------------------------------------------}
procedure TfrmProfile.chklstPointsClickCheck(Sender: TObject);
var     PName,PFName: String;
        PFNode: TjanXMLNode;
        bChecked: Boolean;
begin
        if lstProfiles.ItemIndex = -1  then Exit;
        PFName := lstProfiles.Items[lstProfiles.ItemIndex];
        PName := chklstPoints.Items.Strings[chklstPoints.itemIndex];
        bChecked := chklstPoints.Checked[chklstPoints.ItemIndex];
        { ������ڣ���ɾ������������ڣ������ }
        pfNode := FProfilesNode.findNamedNode(pfname);
        if (pfnode.findNamedNode(pname) = nil) then
        begin
            if  bchecked then pfnode.AddNode(pname,'')
        end
        else
        begin
            if not bchecked then
                pfnode.removeChildNode(pfnode.findNamedNode(pname))
        end;
end;

procedure TfrmProfile.miProfile_RenameClick(Sender: TObject);
var     pfNode: TjanXMLNode;
        newName: string;
begin
        if lstProfiles.ItemIndex = -1 then Exit;
          
        pfNode := FProfilesNode.findNamedNode(lstProfiles.Items[lstProfiles.itemindex]);
        newName := Inputbox('����������','����������������',pfNode.Name);
        if Trim(newName) <> pfNode.Name  then pfNode.Name := Trim(newName);
        lstProfiles.Items[lstProfiles.ItemIndex] := newName;
end;

procedure TfrmProfile.miProfile_NewProfileClick(Sender: TObject);
var     pfNode: TjanXMLNode;
        newName: string;
begin
        newName := Inputbox('�����¶���','�������¶��������','�¶���01');
        if Trim(NewName) = '' then
        begin
            ShowMessage('��δ�����������');
            Exit;
        end;

        { �����Ƿ�������� }
        if FProfilesNode.findNamedNode(newName) <> nil then
        begin
            ShowMessage('����' + newName + '�Ѵ��ڣ��뻻�����ԡ�');
            Exit;
        end;

        FProfilesNode.AddNode(newName, '');
        lstProfiles.Items.Add(newName);
end;

procedure TfrmProfile.miProfile_DeleteClick(Sender: TObject);
var     pfName: String;
begin {  }
        if lstProfiles.ItemIndex = -1 then Exit;
        pfName := lstProfiles.Items[lstProfiles.itemindex];
        FProfilesNode.removeChildNode(FProfilesNode.findNamedNode(pfName));
        lstProfiles.Items.Delete(lstProfiles.ItemIndex);
end;

procedure TfrmProfile.lstProfilesClick(Sender: TObject);
begin
        SetPointsBelongProfile(lstProfiles.Items[lstProfiles.ItemIndex]);
end;

end.
