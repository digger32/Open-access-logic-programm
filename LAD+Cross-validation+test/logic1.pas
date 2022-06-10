unit logic1;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, Math, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, Grids, DBGrids, DB,
  sqldb, SdfData{, DBTables},
  ExtCtrls, CheckLst;

const
  okruglenie = -2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    CheckBox2: TCheckBox;
    ComboBox2: TComboBox;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    FixedFormatDataSet1: TFixedFormatDataSet;
    Label33: TLabel;
    Label34: TLabel;
    ListBox3: TListBox;
    PageControl1: TPageControl;
    SQLConnector1: TSQLConnector;
    StringGrid6: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button1: TButton;
    Table1: TSQLQuery;
    DataSource1: TDataSource;
    OpenDialog1: TOpenDialog;
    ComboBox1: TComboBox;
    Label1: TLabel;
    CheckListBox1: TCheckListBox;
    TabSheet3: TTabSheet;
    ListBox1: TListBox;
    RadioGroup1: TRadioGroup;
    Label2: TLabel;
    Edit1: TEdit;
    ListBox2: TListBox;
    Label3: TLabel;
    Button2: TButton;
    Button3: TButton;
    Label4: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Edit3: TEdit;
    TabSheet4: TTabSheet;
    Label6: TLabel;
    Edit4: TEdit;
    Button4: TButton;
    CheckListBox2: TCheckListBox;
    CheckListBox3: TCheckListBox;
    Label7: TLabel;
    Button5: TButton;
    Label8: TLabel;
    Edit5: TEdit;
    Label9: TLabel;
    Edit7: TEdit;
    Edit6: TEdit;
    Edit8: TEdit;
    Label10: TLabel;
    TabSheet5: TTabSheet;
    Label11: TLabel;
    Edit9: TEdit;
    Button6: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    Button7: TButton;
    Edit10: TEdit;
    Label12: TLabel;
    Edit11: TEdit;
    TabSheet6: TTabSheet;
    RadioGroup2: TRadioGroup;
    Label13: TLabel;
    Edit12: TEdit;
    Label14: TLabel;
    Edit13: TEdit;
    TabSheet7: TTabSheet;
    Button9: TButton;
    Label15: TLabel;
    Edit14: TEdit;
    Edit15: TEdit;
    Button10: TButton;
    StringGrid3: TStringGrid;
    TabSheet8: TTabSheet;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    Button11: TButton;
    Edit16: TEdit;
    Label16: TLabel;
    Edit17: TEdit;
    Label17: TLabel;
    Table2: TSQLQuery;
    Button12: TButton;
    SaveDialog1: TSaveDialog;
    Button13: TButton;
    SaveDialog2: TSaveDialog;
    Table3: TSQLQuery;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    ProgressBar3: TProgressBar;
    Edit18: TEdit;
    Label18: TLabel;
    Edit20: TEdit;
    Edit21: TEdit;
    Label19: TLabel;
    Label20: TLabel;
    Edit22: TEdit;
    Label21: TLabel;
    Edit23: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit19: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Button8: TButton;
    Label25: TLabel;
    Memo3: TMemo;
    Edit26: TEdit;
    Edit27: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    StatusBar1: TStatusBar;
    CheckBox1: TCheckBox;
    Memo4: TMemo;
    Button14: TButton;
    Memo5: TMemo;
    SaveDialog3: TSaveDialog;
    Button15: TButton;
    Label28: TLabel;
    Label29: TLabel;
    Edit28: TEdit;
    Label30: TLabel;
    Button16: TButton;
    Label31: TLabel;
    Edit29: TEdit;
    Button17: TButton;
    Button18: TButton;
    Label32: TLabel;
    List: TStringList; //выборка в строках
    TabSheet9: TTabSheet;
    procedure Button19Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckListBox2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
  


    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  kk, kk1 : Double;  //счетчик накопленных точностей в процедуре кросс-валидации, в %
  tt: integer;     //счетчик правильных объектов в процедуре кросс-валидация

  chislo_klassov : integer;
  imena_klassov : array[0..10] of string;
  //klassy : set of string;

implementation

uses classif1;

{$R *.lfm}

procedure TForm1.Button10Click(Sender: TObject);
begin      // сформировать обучающую выборку
  if RadioGroup2.ItemIndex=2 then  begin
       if (classif.objem mod StrToInt(Edit19.Text)>0) then begin
          ShowMessage('Введите число, на которое делится '+FloatToStr(classif.objem)+' без остатка');
          Exit;   end;
  end;
 
  if StrToFloat(Edit13.Text)>100 then
   Edit13.Text:= FloatToStr(95);
   if StrToFloat(Edit13.Text)<0 then
   Edit13.Text:= FloatToStr(5);

  classif.test_procent:=StrToFloat(Edit13.Text);
  if (StrToInt(Edit19.Text)=1)  then
  RadioGroup2.ItemIndex:=0;
  case RadioGroup2.ItemIndex of
    0: Classif.test_v1;
    1: Classif.test_v4;
    2: Classif.test_v5;
  end;

  if RadioGroup2.ItemIndex=1 then
     Edit12.Text:=FloatToStr(100-classif.test_procent);

  Classif.form_viborka;

  if RadioGroup2.ItemIndex=2 then
   begin
   Button2Click(Sender);
   Button5Click(Sender);
   Button6Click(Sender);
     Button7Click(Sender);
    Button11Click(Sender);
      Button9Click(Sender);
     if kt<StrToFloat(Edit19.Text) then
     begin
      Button10Click(Sender);

      end;
    if kt=StrToFloat(Edit19.Text) then
     begin
     kt:=0;
      end;
   end;
end;

procedure TForm1.Button11Click(Sender: TObject);
var       // построить классификатор
  i,j,i1,k:integer;
  start, stop: TDateTime;
  s,k1: double;
  //B: array of double;
begin
 Button14.Visible:= true;
 Memo5.Visible:= true;
 ProgressBar3.Position:=0;
  start:=Time();
  classif.d3:=StrToInt(Edit16.Text);
  classif.find_model;

  StringGrid4.RowCount:=classif.model0_count+3;
  StringGrid4.ColCount:=classif.num_var+6;

  for j := 0 to classif.num_var - 1 do  // названия столбцов
  begin
    StringGrid4.Cells[j+1,0]:=StringGrid6.Cells[Classif.select_var[j]+1,0]
    //StringGrid4.Cells[j+1,0]:=IntToStr(Classif.select_var[j]+1)+' ';
    //StringGrid4.Cells[j+1,0]:=StringGrid4.Cells[j+1,0]+Table1.Fields[Classif.select_var[j]].FieldName;
  end;
  StringGrid4.Cells[classif.num_var+1,0]:='покр_поз';
  StringGrid4.Cells[classif.num_var+2,0]:='степ';
  StringGrid4.Cells[classif.num_var+3,0]:='покр_нег';
  StringGrid4.Cells[classif.num_var+4,0]:='инф_прав';
  StringGrid4.Cells[classif.num_var+5,0]:='вес_прав';

  i1:=0;
  with Classif do
    for i := 0 to classif.pattern0_count-1 do
    if use_pattern0[i]=1 then
    begin
      for j := 0 to classif.num_var-1 do
      begin
        StringGrid4.Cells[j+1,i1+1]:='';
        if var_type[j]=0 then
        begin
          if patterns0_l[i,j]=1 then
            StringGrid4.Cells[j+1,i1+1]:=FloatToStr(1);
          if patterns0_r[i,j]=1 then
            StringGrid4.Cells[j+1,i1+1]:=FloatToStr(0);
        end else
        begin
          if patterns0_l[i,j]>=0 then
            StringGrid4.Cells[j+1,i1+1]:=FloatToStr(patterns0_l[i,j]);
          StringGrid4.Cells[j+1,i1+1]:=StringGrid4.Cells[j+1,i1+1]+' < ';
          if patterns0_r[i,j]>=0 then
            StringGrid4.Cells[j+1,i1+1]:=StringGrid4.Cells[j+1,i1+1]+FloatToStr(patterns0_r[i,j]);
        end;
      end;
      StringGrid4.Cells[classif.num_var+1,i1+1]:=IntToStr(classif.patterns0_pokr[i]);
      StringGrid4.Cells[classif.num_var+2,i1+1]:=IntToStr(classif.patterns0_step[i]);
      StringGrid4.Cells[classif.num_var+3,i1+1]:=IntToStr(classif.patterns0_neg[i]);
      inc(i1);
    end;

    for i := 0 to i1 - 1 do // нумерация рядов
       begin
     StringGrid4.Cells[0, i1+2]:='Важн %';
     StringGrid4.Cells[0, i1+1]:='Важность';
     StringGrid4.Cells[0,i+1]:=IntToStr(i+1);
     StringGrid4.Cells[classif.num_var+1,i1+2]:='';
     StringGrid4.Cells[classif.num_var+2,i1+2]:='';
     StringGrid4.Cells[classif.num_var+1,i1+1]:='';
     StringGrid4.Cells[classif.num_var+2,i1+1]:='';
     StringGrid4.Cells[classif.num_var+3,i1+1]:='';
     StringGrid4.Cells[classif.num_var+3,i1+2]:='';

      end;

     for j := 0 to classif.num_var-1 do
    begin
     k:=0;
        for i := 0 to i1-1 do
      begin
     if  StringGrid4.Cells[j+1,i+1]= '' then
         begin
         k:=k+1;
         end;
         if  StringGrid4.Cells[j+1,i+1]= ''+' < '+'' then
         begin
         k:=k+1;
         end;
         end;
          StringGrid4.Cells[j+1, i1+1]:= FloatToStr(i1 - k);   //важность
          StringGrid4.Cells[j+1, i1+2]:= FloatToStr((i1 - k)*100/i1);  //важность в %
         end;
         //--------------------------------------------------------
          for i := 0 to i1-1 do         //среднее покрытие
           begin
         s:=s+StrToFloat(StringGrid4.Cells[classif.num_var+1, i+1]);
         end;
         s:=s/i1;
          s:= RoundTo(s, 0);
          StringGrid4.Cells[classif.num_var+1, i1+1]:='срПокр';
         StringGrid4.Cells[classif.num_var+1, i1+2]:= FloatToStr(s);

        // -----------------------------------------------------
        //--------------------------------------------------------
          s:=0;                 //информативность
          for i := 0 to i1-1 do
           begin
         s:=sqrt(StrToFloat(StringGrid4.Cells[classif.num_var+1, i+1]))-sqrt(StrToFloat(StringGrid4.Cells[classif.num_var+3, i+1]));
         StringGrid4.Cells[classif.num_var+4, i+1]:= FloatToStr(s);
         end;


        // -----------------------------------------------------
         //--------------------------------------------------------
           s:=0;                                // средняя информативность
          for i := 0 to i1-1 do
           begin
         s:=s+StrToFloat(StringGrid4.Cells[classif.num_var+4, i+1]);
         end;
         s:=s/i1;
          //s:= RoundTo(s, 0);
          StringGrid4.Cells[classif.num_var+4, i1+1]:='срИнф';
         StringGrid4.Cells[classif.num_var+4, i1+2]:= FloatToStr(s);

        // -----------------------------------------------------
          s:=0;                               // средняя степень
          for i := 0 to i1-1 do
           begin
         s:=s+StrToFloat(StringGrid4.Cells[classif.num_var+2, i+1]);
         end;
         s:=s/i1;
          s:= RoundTo(s, 0);
          StringGrid4.Cells[classif.num_var+2, i1+1]:='срСтеп';
         StringGrid4.Cells[classif.num_var+2, i1+2]:= FloatToStr(s);
         StringGrid4.Cells[classif.num_var+3, i1+1]:='';
         StringGrid4.Cells[classif.num_var+3, i1+2]:='';
        // -----------------------------------------------------

         //--------------------------------------------------------   //вес правила
      {  SetLength(B,i1);
          for i:=1 to i1 do     //сортировка информативности по возрастанию
        begin
        B[i-1]:=StrToFloat(StringGrid4.Cells[classif.num_var+4, i]);
        end;

        k1:=0;
        for i:=0 to i1-2 do
        begin
        for j:=0 to i1-2-i do
        begin
        if B[j]>B[j+1] then
        begin
        k1:=B[j];
        B[j]:=B[j+1];
        B[j+1]:=k1;
        end;
        end;
        end;

         s:=0;                    //нормировка wi=(xi-xmin)/(xmax-xmin)
         for i := 0 to i1-1 do
           begin
         s:=(StrToFloat(StringGrid4.Cells[classif.num_var+4, i+1])-B[0])/(B[i1-1]-B[0]);
         StringGrid4.Cells[classif.num_var+5, i+1]:=FloatToStr(s);
         end;    }


          s:=0;         //wi=инф_прав/сумму инф_прав

          for i := 0 to i1-1 do
           begin
         s:=s+StrToFloat(StringGrid4.Cells[classif.num_var+4, i+1]);
         end;
            StringGrid4.Cells[classif.num_var+5, i1+1]:= FloatToStr(s);
        s:=0;
        k1:=0;
            for i := 0 to i1-1 do
           begin
         s:=StrToFloat(StringGrid4.Cells[classif.num_var+4, i+1])/StrToFloat(StringGrid4.Cells[classif.num_var+5, i1+1]);
          StringGrid4.Cells[classif.num_var+5, i+1]:= FloatToStr(s);
          k1:=k1+s;
         end;
           StringGrid4.Cells[classif.num_var+5, i1+2]:= FloatToStr(k1);
        // -----------------------------------------------------

////------------

  StringGrid5.RowCount:=classif.model1_count+3;
  StringGrid5.ColCount:=classif.num_var+6;

  for j := 0 to classif.num_var - 1 do  // названия столбцов
  begin
    StringGrid5.Cells[j+1,0]:=StringGrid6.Cells[Classif.select_var[j]+1,0]
    //StringGrid5.Cells[j+1,0]:=IntToStr(Classif.select_var[j]+1)+' ';
    //StringGrid5.Cells[j+1,0]:=StringGrid5.Cells[j+1,0]+Table1.Fields[Classif.select_var[j]].FieldName;
  end;
  StringGrid5.Cells[classif.num_var+1,0]:='покр_поз';
  StringGrid5.Cells[classif.num_var+2,0]:='степ';
  StringGrid5.Cells[classif.num_var+3,0]:='покр_нег';
  StringGrid5.Cells[classif.num_var+4,0]:='инф_прав';
  StringGrid5.Cells[classif.num_var+5,0]:='вес_прав';

  i1:=0;
  with Classif do
    for i := 0 to classif.pattern1_count-1 do
    if use_pattern1[i]=1 then
    begin
      for j := 0 to classif.num_var-1 do
      begin
        StringGrid5.Cells[j+1,i1+1]:='';
        if var_type[j]=0 then
        begin
          if patterns1_l[i,j]=1 then
            StringGrid5.Cells[j+1,i1+1]:=FloatToStr(1);
          if patterns1_r[i,j]=1 then
            StringGrid5.Cells[j+1,i1+1]:=FloatToStr(0);
        end else
        begin
          if patterns1_l[i,j]>=0 then
            StringGrid5.Cells[j+1,i1+1]:=FloatToStr(patterns1_l[i,j]);
          StringGrid5.Cells[j+1,i1+1]:=StringGrid5.Cells[j+1,i1+1]+' < ';
          if patterns1_r[i,j]>=0 then
            StringGrid5.Cells[j+1,i1+1]:=StringGrid5.Cells[j+1,i1+1]+FloatToStr(patterns1_r[i,j]);
        end;
      end;
      StringGrid5.Cells[classif.num_var+1,i1+1]:=IntToStr(classif.patterns1_pokr[i]);
      StringGrid5.Cells[classif.num_var+2,i1+1]:=IntToStr(classif.patterns1_step[i]);
      StringGrid5.Cells[classif.num_var+3,i1+1]:=IntToStr(classif.patterns1_neg[i]);
      inc(i1);
    end;

    for i := 0 to i1 - 1 do // нумерация рядов
        begin
     StringGrid5.Cells[0, i1+2]:='Важн %';
     StringGrid5.Cells[0, i1+1]:='Важность';
     StringGrid5.Cells[0,i+1]:=IntToStr(i+1);
     StringGrid5.Cells[classif.num_var+1,i1+2]:='';
     StringGrid5.Cells[classif.num_var+2,i1+2]:='';
     StringGrid5.Cells[classif.num_var+1,i1+1]:='';
     StringGrid5.Cells[classif.num_var+2,i1+1]:='';
     StringGrid5.Cells[classif.num_var+3,i1+1]:='';
     StringGrid5.Cells[classif.num_var+3,i1+2]:='';
       end;

      for j := 0 to classif.num_var-1 do
    begin
     k:=0;
        for i := 0 to i1-1 do
      begin
     if  StringGrid5.Cells[j+1,i+1]= '' then
         begin
         k:=k+1;
         end;
         if  StringGrid5.Cells[j+1,i+1]= ''+' < '+'' then
         begin
         k:=k+1;
         end;
         end;
          StringGrid5.Cells[j+1, i1+1]:= FloatToStr(i1 - k);    //важность
          StringGrid5.Cells[j+1, i1+2]:= FloatToStr((i1 - k)*100/i1);    //важность в %
         end;
         //--------------------------------------------------------
          for i := 0 to i1-1 do                        //среднее покрытие
           begin
         s:=s+StrToFloat(StringGrid5.Cells[classif.num_var+1, i+1]);
         end;
         s:=s/i1;
          s:= RoundTo(s, 0);
          StringGrid5.Cells[classif.num_var+1, i1+1]:='срПокр';
         StringGrid5.Cells[classif.num_var+1, i1+2]:= FloatToStr(s);

          //--------------------------------------------------------
          s:=0;                                                        //информативность
          for i := 0 to i1-1 do
           begin
         s:=sqrt(StrToFloat(StringGrid5.Cells[classif.num_var+1, i+1]))-sqrt(StrToFloat(StringGrid5.Cells[classif.num_var+3, i+1]));
         StringGrid5.Cells[classif.num_var+4, i+1]:= FloatToStr(s);
         end;


        // -----------------------------------------------------
         //--------------------------------------------------------
           s:=0;                                                    //средняя информативность
          for i := 0 to i1-1 do
           begin
         s:=s+StrToFloat(StringGrid5.Cells[classif.num_var+4, i+1]);
         end;
         s:=s/i1;
          //s:= RoundTo(s, 0);
          StringGrid5.Cells[classif.num_var+4, i1+1]:='срИнф';
         StringGrid5.Cells[classif.num_var+4, i1+2]:= FloatToStr(s);

        // -----------------------------------------------------
        // -----------------------------------------------------
          s:=0;                                            // средняя степень
          for i := 0 to i1-1 do
           begin
         s:=s+StrToFloat(StringGrid5.Cells[classif.num_var+2, i+1]);
         end;
         s:=s/i1;
          s:= RoundTo(s, 0);
          StringGrid5.Cells[classif.num_var+2, i1+1]:='срСтеп';
         StringGrid5.Cells[classif.num_var+2, i1+2]:= FloatToStr(s);
          StringGrid5.Cells[classif.num_var+3, i1+1]:='';
         StringGrid5.Cells[classif.num_var+3, i1+2]:= '';
        // -----------------------------------------------------
        
         //--------------------------------------------------------   //вес правила
      {  SetLength(B,i1);
          for i:=1 to i1 do     //сортировка информативности по возрастанию
        begin
        B[i-1]:=StrToFloat(StringGrid5.Cells[classif.num_var+4, i]);
        end;

        k1:=0;
        for i:=0 to i1-2 do
        begin
        for j:=0 to i1-2-i do
        begin
        if B[j]>B[j+1] then
        begin
        k1:=B[j];
        B[j]:=B[j+1];
        B[j+1]:=k1;
        end;
        end;
        end;

         s:=0;
         for i := 0 to i1-1 do
           begin
         s:=(StrToFloat(StringGrid5.Cells[classif.num_var+4, i+1])-B[0])/(B[i1-1]-B[0]);
         StringGrid5.Cells[classif.num_var+5, i+1]:=FloatToStr(s);
         end;    }


          s:=0;

          for i := 0 to i1-1 do
           begin
         s:=s+StrToFloat(StringGrid5.Cells[classif.num_var+4, i+1]);
         end;
            StringGrid5.Cells[classif.num_var+5, i1+1]:= FloatToStr(s);
        s:=0;
        k1:=0;
            for i := 0 to i1-1 do
           begin
         s:=StrToFloat(StringGrid5.Cells[classif.num_var+4, i+1])/StrToFloat(StringGrid5.Cells[classif.num_var+5, i1+1]);
          StringGrid5.Cells[classif.num_var+5, i+1]:= FloatToStr(s);
          k1:=k1+s;
         end;
           StringGrid5.Cells[classif.num_var+5, i1+2]:= FloatToStr(k1);
        // -----------------------------------------------------
        stop:=Time();
        Edit23.Text:=TimeToStr(stop-start);

end;

procedure TForm1.Button12Click(Sender: TObject);
var             // отчет по паттернам
  i,i1,i2:integer;


begin
{
  if SaveDialog1.Execute then
  begin
    Table2.Database:=SaveDialog1.InitialDir;
    Table2.TableName:=SaveDialog1.FileName;
  end;
   if not Table2.Exists then
     table2.CreateTable;

    Table2.Exclusive:=true;
    Table2.Active:=true;
    try
        Table2.EmptyTable;
      except
        ShowMessage('Cannot empty database');
      end;

  i1:=0;
  i2:=0;
  with classif do
    begin
    for i := 0 to objem_train - 1 do
    begin
      if set0_train[i1]=i then
      begin
        Table2.AppendRecord([i+1,0,patterns0_pokr[i1],patterns0_neg[i1],patterns0_step[i1],use_pattern0[i1]]);
        inc(i1);
      end else if set1_train[i2]=i then
      begin
        Table2.AppendRecord([i+1,1,patterns1_neg[i2],patterns1_pokr[i2],patterns1_step[i2],use_pattern1[i2]]);
        inc(i2);
      end;
    end;
  end;

  Table2.Active:=false;
}
end;

procedure TForm1.Button13Click(Sender: TObject);
var
  i:integer;
begin                      // отчет по результатам
 { if SaveDialog2.Execute then
  begin
    Table3.DatabaseName:=SaveDialog2.InitialDir;
    Table3.TableName:=SaveDialog2.FileName;
  end;
   if not Table3.Exists then
     table3.CreateTable;

    Table3.Exclusive:=true;
    Table3.Active:=true;
    try
        Table3.EmptyTable;
      except
        ShowMessage('Cannot empty database');
      end;

  with classif do
    for i := 0 to objem_test - 1 do
    begin
      Table3.AppendRecord([i+1,test_cover0[i],test_cover1[i],test_classif[i],test_classif_real[i]]);
        end;
        Table3.Active:=false;
      }
end;

procedure TForm1.Button1Click(Sender: TObject); // загрузка выборки
var
  i,k,j: integer;
  s,c: string;
begin
  if OpenDialog1.Execute then
  begin
    List:=TStringList.Create; //загрузка из файла
    List.LoadFromFile(OpenDialog1.FileName);
    stringGrid6.RowCount:=List.Count;

    if not checkbox2.Checked then
      stringGrid6.RowCount:=stringGrid6.RowCount+1;//inc(stringGrid6.RowCount);

    for i:=0 to List.Count-1 do begin //заполнение табл. формы
      stringgrid6.cells[0,i]:=inttostr(i);
      k:=0;
      s:=List[i];
      for j:=1 to length(s) do begin
          if (s[j]<>',') then c:=c+s[j];
          if (s[j]=',') or (j=length(s)) then begin
                   inc(k);
                   if i=0 then stringGrid6.ColCount:=k+1;
                   if checkbox2.Checked then
                     stringGrid6.Cells[k,i]:=c else
                       stringGrid6.Cells[k,i+1]:=c;
                   c:=''   end;
      end;
    end;

    if not checkbox2.Checked then begin
      stringgrid6.cells[0,stringGrid6.RowCount-1]:=inttostr(stringGrid6.RowCount-1);
      for i:=1 to stringGrid6.ColCount - 1 do
        stringGrid6.Cells[i,0]:='x'+ inttostr(i);
      end;

      CheckListBox1.Clear;  //заполняем перечень признаков
      Combobox1.Clear;
      for i := 1 to stringGrid6.ColCount - 1 do
      begin
        CheckListBox1.Items.Add(IntToStr(i)+' - '+stringGrid6.Cells[i,0]);
        CheckListBox1.Checked[i-1]:=true;
        Combobox1.Items.Add(stringGrid6.Cells[i,0]);
      end;
      Combobox1.ItemIndex:=stringGrid6.ColCount - 2;

  end;

end;

procedure TForm1.Button20Click(Sender: TObject);
begin
  Classif.zagruzka_binar;
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
  Classif.form_binar;
  Edit30.Text:=IntToStr(Classif.t);
  Edit31.Text:=IntToStr(Classif.objem1_train);
  Edit32.Text:=IntToStr(Classif.objem0_train);
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
  Classif.vigruzka_binar;
end;

procedure TForm1.Button2Click(Sender: TObject); // бинаризация
begin
    //Classif.upor;
 Classif.uporjad;
 Classif.Binarized:=true;
end;

procedure TForm1.Button3Click(Sender: TObject); // выбрать признаки
var
  i,j:integer;
  b:boolean;
begin

  chislo_klassov:=1;
  imena_klassov[0]:=stringGrid6.Cells[ComboBox1.ItemIndex+1,1];
  ListBox3.items.Clear;
  ListBox3.items.Add(stringGrid6.Cells[ComboBox1.ItemIndex+1,1]);

  for i := 2 to stringGrid6.RowCount - 1 do
  begin
    b:=false;
    j:=0;
    repeat
      if stringGrid6.Cells[ComboBox1.ItemIndex+1,i]=imena_klassov[j] then
        b:=true;
      inc(j);
    until j=chislo_klassov;
    if not b then
    begin
      inc(chislo_klassov);
      imena_klassov[chislo_klassov-1]:=stringGrid6.Cells[ComboBox1.ItemIndex+1,i];
      ListBox3.Items.Add(stringGrid6.Cells[ComboBox1.ItemIndex+1,i]);
    end;
  end;

  Classif:=TClassif.Create;
  Classif.select_variable;
  Classif.ident_variable;

  ListBox1.Clear; // заполнить перечень признаков для бинаризации
  for i := 0 to Classif.num_var - 1 do
  begin
    ListBox1.Items.Add(StringGrid6.Cells[Classif.select_var[i]+1,0]);
  end;
  RadioGroup1.ItemIndex:=Classif.var_type[0];

  Classif.Binarized:=false;
  Classif.find_sets;

  Edit6.Text:=IntToStr(Classif.objem0);
  Edit8.Text:=IntToStr(Classif.objem1);
  Edit4.Text:=IntToStr(Classif.num_var);

  Combobox2.Clear;

  for i:=0 to chislo_klassov-1 do
    ComboBox2.Items.Add(imena_klassov[i]);
  Combobox2.ItemIndex:=0;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Classif.find_thresholds;
end;

procedure TForm1.Button5Click(Sender: TObject);
var                   // поиск и отображение опорного множества
  i:integer;
   sss, kkk: TDateTime;
begin
  ProgressBar1.Position:=0;
    sss:=0;
   sss:= Time();
  classif.d1:=StrToInt(Edit7.Text);
  classif.find_support;

  CheckListBox2.Clear;
  for i := 0 to Classif.num_var - 1 do
  begin
    CheckListBox2.Items.Add(StringGrid6.Cells[Classif.select_var[i]+1,0]);
    //Table1.Fields[Classif.select_var[i]].FieldName);
    case Classif.var_sup[i] of
      0: CheckListBox2.State[i]:=cbUnChecked;
      1: CheckListBox2.State[i]:=cbGrayed;
      2: CheckListBox2.State[i]:=cbChecked;
    end;
    kkk:=Time();
         Edit21.Text:=TimeToStr(kkk-sss);
           ProgressBar1.Position:=ProgressBar1.Max;
  end;

  Edit5.Text:=IntToStr(classif.support_num);
end;

procedure TForm1.Button6Click(Sender: TObject);  //поиск правил
var
  i,j,k:integer;
  s: double;
  start,stop: TDateTime;
begin
  iii:=0;
  Edit20.Text:='Поиск правил...';
  Form1.Refresh;
  ProgressBar2.Position:=0;
  start:=Time();
  classif.d2:=StrToInt(Edit11.Text);
  classif.d22:=StrToInt(Edit17.Text);
  Classif.pattern0_count:=StrToInt(Edit9.Text);
  Classif.find_patterns0;
  StringGrid1.RowCount:=classif.pattern0_count+3;
  StringGrid1.ColCount:=classif.num_var+5;

  for j := 0 to classif.num_var-1 do  // названия столбцов
  begin
    StringGrid1.Font.Style:=[];
    if classif.var_sup[j]>0 then
      StringGrid1.Font.Style:=[fsBold];
    StringGrid1.Cells[j+1,0]:=StringGrid6.Cells[Classif.select_var[j]+1,0]
    // StringGrid1.Cells[j+1,0]:=IntToStr(Classif.select_var[j]+1)+' ';
    // StringGrid1.Cells[j+1,0]:=StringGrid1.Cells[j+1,0]+Table1.Fields[Classif.select_var[j]].FieldName;
  end;
  StringGrid1.Cells[classif.num_var+1,0]:='покр_поз';
  StringGrid1.Cells[classif.num_var+2,0]:='степ';
  StringGrid1.Cells[classif.num_var+3,0]:='покр_нег';
  StringGrid1.Cells[classif.num_var+4,0]:='инф_прав';


  for i := 0 to classif.pattern0_count-1 do // нумерация рядов
   begin
     StringGrid1.Cells[0, classif.pattern0_count+2]:='Важн %';
   StringGrid1.Cells[0, classif.pattern0_count+1]:='Важность';
   StringGrid1.Cells[0,i+1]:=IntToStr(i+1);

    end;
  with Classif do
    for i := 0 to classif.pattern0_count-1 do
    begin
      for j := 0 to classif.num_var-1 do
      begin

        StringGrid1.Cells[j+1,i+1]:='';
        if var_type[j]=0 then
        begin
          if patterns0_l[i,j]=1 then
            StringGrid1.Cells[j+1,i+1]:=FloatToStr(1);
          if patterns0_r[i,j]=1 then
            StringGrid1.Cells[j+1,i+1]:=FloatToStr(0);
        end else
        begin
          if patterns0_l[i,j]>=0 then
            StringGrid1.Cells[j+1,i+1]:=FloatToStrF(patterns0_l[i,j],ffGeneral,6,2);
          StringGrid1.Cells[j+1,i+1]:=StringGrid1.Cells[j+1,i+1]+' ~ ';
          if patterns0_r[i,j]>=0 then
            StringGrid1.Cells[j+1,i+1]:=StringGrid1.Cells[j+1,i+1]+FloatToStrF(patterns0_r[i,j],ffGeneral,6,2);
        end;
         end;
      StringGrid1.Cells[classif.num_var+1,i+1]:=IntToStr(classif.patterns0_pokr[i]);
      StringGrid1.Cells[classif.num_var+2,i+1]:=IntToStr(classif.patterns0_step[i]);
      StringGrid1.Cells[classif.num_var+3,i+1]:=IntToStr(classif.patterns0_neg[i]);
    end;

      for j := 0 to classif.num_var-1 do

    begin
     k:=0;
        for i := 0 to classif.pattern0_count-1 do
      begin
     if  StringGrid1.Cells[j+1,i+1]= '' then
         begin
         k:=k+1;
         end;
         if  StringGrid1.Cells[j+1,i+1]= ''+' - '+'' then
         begin
         k:=k+1;
         end
         end;
          StringGrid1.Cells[j+1, classif.pattern0_count+1]:= FloatToStr(classif.pattern0_count - k);
          StringGrid1.Cells[j+1, classif.pattern0_count+2]:= FloatToStr((classif.pattern0_count - k)*100/classif.pattern0_count);
         end;
         //--------------------------------------------------------
          for i := 0 to classif.pattern0_count-1 do
           begin
         s:=s+StrToFloat(StringGrid1.Cells[classif.num_var+1, i+1]);
         end;
         s:=s/classif.pattern0_count;
          s:= RoundTo(s, 0);
          StringGrid1.Cells[classif.num_var+1, classif.pattern0_count+1]:='срПокр';
         StringGrid1.Cells[classif.num_var+1, classif.pattern0_count+2]:= FloatToStr(s);

        // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern0_count-1 do
           begin
         s:=s+StrToFloat(StringGrid1.Cells[classif.num_var+2, i+1]);
         end;
         s:=s/classif.pattern0_count;
          s:= RoundTo(s, 0);
          StringGrid1.Cells[classif.num_var+2, classif.pattern0_count+1]:='срСтеп';
         StringGrid1.Cells[classif.num_var+2, classif.pattern0_count+2]:= FloatToStr(s);
         StringGrid1.Cells[classif.num_var+3, classif.pattern0_count+1]:='';
         StringGrid1.Cells[classif.num_var+3, classif.pattern0_count+2]:='';
        // -----------------------------------------------------
            // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern0_count-1 do
           begin
         s:=s+StrToFloat(StringGrid1.Cells[classif.num_var+3, i+1]);
         end;
         s:=s/classif.pattern0_count;
         // s:= RoundTo(s, 0);
          StringGrid1.Cells[classif.num_var+3, classif.pattern0_count+1]:='срПокрНег';
         StringGrid1.Cells[classif.num_var+3, classif.pattern0_count+2]:= FloatToStr(s);
         // StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+1]:='';
       //  StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+2]:= '';
        // -----------------------------------------------------
         s:=0;
          for i := 0 to classif.pattern0_count-1 do
           begin
         s:=sqrt(StrToFloat(StringGrid1.Cells[classif.num_var+1, i+1]))-sqrt(StrToFloat(StringGrid1.Cells[classif.num_var+3, i+1]));
          StringGrid1.Cells[classif.num_var+4, i+1] :=FloatToStr(s);
            // s:= RoundTo(s, 0);
          s:=0;
         end;

        // -----------------------------------------------------
        // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern0_count-1 do
           begin
         s:=s+StrToFloat(StringGrid1.Cells[classif.num_var+4, i+1]);
         end;
         s:=s/classif.pattern0_count;
        //  s:= RoundTo(s, 0);
          StringGrid1.Cells[classif.num_var+4, classif.pattern0_count+1]:='срИнф';
         StringGrid1.Cells[classif.num_var+4, classif.pattern0_count+2]:= FloatToStr(s);

        // -----------------------------------------------------
        ProgressBar2.Position:=ProgressBar2.Max;
        stop:=Time();
        Edit20.Text:=TimeToStr(stop-start);
       
    end;

procedure TForm1.Button7Click(Sender: TObject);
var
  i,j,k:integer;
  start, stop: TDateTime;
  s: double;
begin
  iii:=0;
  Edit22.Text:='Поиск правил...';
  Form1.Refresh;
  ProgressBar2.Position:=0;
  start:=Time();
  classif.d2:=StrToInt(Edit11.Text);
  classif.d22:=StrToInt(Edit17.Text);
  Classif.pattern1_count:=StrToInt(Edit10.Text);
  Classif.find_patterns1;
  StringGrid2.RowCount:=classif.pattern1_count+3;
  StringGrid2.ColCount:=classif.num_var+5;

  for j := 0 to classif.num_var - 1 do  // названия столбцов
  begin
    StringGrid2.Font.Style:=[];
    if classif.var_sup[j]>0 then
      StringGrid2.Font.Style:=[fsBold];
    StringGrid2.Cells[j+1,0]:=StringGrid6.Cells[Classif.select_var[j]+1,0]
    //StringGrid2.Cells[j+1,0]:=IntToStr(Classif.select_var[j]+1)+' ';
    //StringGrid2.Cells[j+1,0]:=StringGrid2.Cells[j+1,0]+Table1.Fields[Classif.select_var[j]].FieldName;
  end;
  StringGrid2.Cells[classif.num_var+1,0]:='покр_поз';
  StringGrid2.Cells[classif.num_var+2,0]:='степ';
  StringGrid2.Cells[classif.num_var+3,0]:='покр_нег';
   StringGrid2.Cells[classif.num_var+4,0]:='инф_прав';

  for i := 0 to classif.pattern1_count - 1 do // нумерация рядов
     begin
      StringGrid2.Cells[0, classif.pattern1_count+2]:='Важн %';
    StringGrid2.Cells[0, classif.pattern1_count+1]:='Важность';
    StringGrid2.Cells[0,i+1]:=IntToStr(i+1);
     end;
  with Classif do
    for i := 0 to classif.pattern1_count-1 do
    begin
      for j := 0 to classif.num_var-1 do
      begin
        StringGrid2.Cells[j+1,i+1]:='';
        if var_type[j]=0 then
        begin
          if patterns1_l[i,j]=1 then
            StringGrid2.Cells[j+1,i+1]:=FloatToStr(1);
          if patterns1_r[i,j]=1 then
            StringGrid2.Cells[j+1,i+1]:=FloatToStr(0);
        end else
        begin
          if patterns1_l[i,j]>=0 then
            StringGrid2.Cells[j+1,i+1]:=FloatToStrF(patterns1_l[i,j],ffGeneral,6,2);
          StringGrid2.Cells[j+1,i+1]:=StringGrid2.Cells[j+1,i+1]+' ~ ';
          if patterns1_r[i,j]>=0 then
            StringGrid2.Cells[j+1,i+1]:=StringGrid2.Cells[j+1,i+1]+FloatToStrF(patterns1_r[i,j],ffGeneral,6,2);
        end;
      end;
      StringGrid2.Cells[classif.num_var+1,i+1]:=IntToStr(classif.patterns1_pokr[i]);
      StringGrid2.Cells[classif.num_var+2,i+1]:=IntToStr(classif.patterns1_step[i]);
      StringGrid2.Cells[classif.num_var+3,i+1]:=IntToStr(classif.patterns1_neg[i]);
    end;
    //--------------------------------------
    for j := 0 to classif.num_var-1 do

    begin
     k:=0;
        for i := 0 to classif.pattern1_count-1 do
      begin
     if  StringGrid2.Cells[j+1,i+1]= '' then
         begin
         k:=k+1;
         end;
         if  StringGrid2.Cells[j+1,i+1]= ''+' - '+'' then
         begin
         k:=k+1;
         end
         end;
          StringGrid2.Cells[j+1, classif.pattern1_count+1]:= FloatToStr(classif.pattern1_count - k);
         StringGrid2.Cells[j+1, classif.pattern1_count+2]:= FloatToStr((classif.pattern1_count - k)*100/classif.pattern1_count);
         end;
          //--------------------------------------------------------
          for i := 0 to classif.pattern1_count-1 do
           begin
         s:=s+StrToFloat(StringGrid2.Cells[classif.num_var+1, i+1]);
         end;
         s:=s/classif.pattern1_count;
          s:= RoundTo(s, 0);
          StringGrid2.Cells[classif.num_var+1, classif.pattern1_count+1]:='срПокр';
         StringGrid2.Cells[classif.num_var+1, classif.pattern1_count+2]:= FloatToStr(s);

        // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern1_count-1 do
           begin
         s:=s+StrToFloat(StringGrid2.Cells[classif.num_var+2, i+1]);
         end;
         s:=s/classif.pattern1_count;
          s:= RoundTo(s, 0);
          StringGrid2.Cells[classif.num_var+2, classif.pattern1_count+1]:='срСтеп';
         StringGrid2.Cells[classif.num_var+2, classif.pattern1_count+2]:= FloatToStr(s);
          StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+1]:='';
         StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+2]:= '';
        // -----------------------------------------------------
            // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern1_count-1 do
           begin
         s:=s+StrToFloat(StringGrid2.Cells[classif.num_var+3, i+1]);
         end;
         s:=s/classif.pattern1_count;
         // s:= RoundTo(s, 0);
          StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+1]:='срПокрНег';
         StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+2]:= FloatToStr(s);
         // StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+1]:='';
       //  StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+2]:= '';
        // -----------------------------------------------------
        // -----------------------------------------------------
         s:=0;
          for i := 0 to classif.pattern1_count-1 do
           begin
         s:=sqrt(StrToFloat(StringGrid2.Cells[classif.num_var+1, i+1]))-sqrt(StrToFloat(StringGrid2.Cells[classif.num_var+3, i+1]));
          StringGrid2.Cells[classif.num_var+4, i+1] :=FloatToStr(s);
        //  s:= RoundTo(s, 0);
          s:=0;
         end;

        // -----------------------------------------------------
        // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern1_count-1 do
           begin
         s:=s+StrToFloat(StringGrid2.Cells[classif.num_var+4, i+1]);
         end;
         s:=s/classif.pattern1_count;
        //  s:= RoundTo(s, 0);
          StringGrid2.Cells[classif.num_var+4, classif.pattern1_count+1]:='срИнф';
         StringGrid2.Cells[classif.num_var+4, classif.pattern1_count+2]:= FloatToStr(s);

        // -----------------------------------------------------
        ProgressBar2.Position:=ProgressBar2.Max;
        stop:=Time();
        Edit22.Text:=TimeToStr(stop-start);


end;

procedure TForm1.Button9Click(Sender: TObject); // тестировать
var
  j,ss,tt1 :integer;
begin
 // tt:=0;
  tt1:=0;
  classif.test1;
  StringGrid3.RowCount:=classif.objem_test+1;
    StringGrid3.Cells[0,0]:='№';
    StringGrid3.Cells[1,0]:='покр0';
    StringGrid3.Cells[2,0]:='покр1';
    StringGrid3.Cells[3,0]:='тест_класс';
    StringGrid3.Cells[4,0]:='реал_класс';
  for j := 0 to classif.objem_test - 1 do
  begin
    StringGrid3.Cells[0,j+1]:=IntToStr(j+1);
    StringGrid3.Cells[1,j+1]:=IntToStr(classif.test_cover0[j]);
    StringGrid3.Cells[2,j+1]:=IntToStr(classif.test_cover1[j]);
    StringGrid3.Cells[3,j+1]:=IntToStr(classif.test_classif[j]);
    StringGrid3.Cells[4,j+1]:=IntToStr(classif.test_classif_real[j]);
  end;
  Edit14.text:=FloatToStr(classif.precision0);
  Edit15.text:=FloatToStr(classif.precision1);
  if (RadioGroup2.ItemIndex=2) then
  begin
  Memo1.Lines.Add(FloatToStr(classif.precision0));
  kk:=kk+classif.precision0;
  tt:=tt+(round(classif.precision0*classif.objem0_test/100));
  if kt=(StrToInt(Edit19.Text)) then
  begin
  if StrToInt(Edit19.Text)= classif.objem0+classif.objem1 then
  begin
   tt1:=round(kk);

  kk:=kk/classif.objem0;
  end;
  if StrToInt(Edit19.Text)< classif.objem0+classif.objem1 then
  begin

  kk :=kk/(kt-classif.chet0);
  classif.chet0:=0;

  end;
  Memo1.Lines.Add(FloatToStr(kk));
  kk:=0;
  end;
  Memo2.Lines.Add(FloatToStr(classif.precision1));
  kk1:=kk1+classif.precision1;
  tt:=tt+(round(classif.precision1*classif.objem1_test/100));
  if kt=(StrToInt(Edit19.Text)) then
  begin
  if StrToInt(Edit19.Text)= classif.objem0+classif.objem1 then
  begin
  tt1:=round((tt1+kk1)/100);
   Memo3.Lines.Add('Количество правильных: '+IntToStr(tt1)+' из '+IntToStr(classif.objem));
  kk1:=kk1/(classif.objem1);
  end;
  if StrToInt(Edit19.Text)< classif.objem0+classif.objem1 then
   begin

   Memo3.Lines.Add('Количество правильных: '+IntToStr(tt)+' из '+IntToStr(classif.objem));
   kk1 :=kk1/(kt-classif.chet1);
   classif.chet1:=0;
    tt:=0;
   end;
  Memo2.Lines.Add(FloatToStr(kk1));
  kk1:=0;
  end;
  end;
end;

procedure TForm1.CheckListBox2Click(Sender: TObject);
var                      // отображение опорного множества по порогам
  j,j1:integer;
begin
  j:=CheckListBox2.ItemIndex;
  CheckListBox3.Clear;
  for j1 := 0 to Classif.thresh_count[j] - 1 do
  begin
    CheckListBox3.Items.Add(FloatToStr(Classif.thresh[j,j1]));
    if classif.thresh_sup[j,j1]=1 then
      CheckListBox3.Checked[j1]:=true
      else CheckListBox3.Checked[j1]:=false;
  end;

end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  j, j1:integer;
begin
  j:=ListBox1.ItemIndex;
  RadioGroup1.ItemIndex:=Classif.var_type[j];
  if Classif.Binarized then
  begin
    Edit1.Text:=floattostr(Classif.thresh_count[j]);
    ListBox2.Clear;
    for j1 := 0 to Classif.thresh_count[j] - 1 do
    begin
      if Classif.thresh_use[j,j1] then begin
        ListBox2.Font.Style := [fsBold];
        ListBox2.Items.Add(FloatToStr(Classif.thresh[j,j1])+' !!!');
        ListBox2.Font.Style := [];
      end else ListBox2.Items.Add(FloatToStr(Classif.thresh[j,j1]));
    end;
    Edit2.Text:=IntToStr(Classif.objem_real[j]);
    //Edit3.Text:=IntToStr(Classif.t);
  end;
end;



procedure TForm1.Button8Click(Sender: TObject);
begin
Memo1.Clear;
Memo2.Clear;
Memo3.Clear;
end;

procedure TForm1.Button14Click(Sender: TObject);
var                                       //показать паттерны
j1,j,kk,kk1,mm, kk2 : integer;
FirstVisible : longint;
p : TPoint;
//aa, bb : array [0..400] of integer;
begin
//Memo4.Visible:=true;
Button15.Visible:=true;       //сохранить модель в *.txt
Memo4.Clear;
Memo5.Clear;
 for j1 := 0 to  StringGrid4.RowCount - 4 do      //считываем в Memo4 все закономерности с
                                                  // таблицы модели отр. паттернов
  begin

      for j := 0 to classif.num_var-1 do
      begin
     //  Memo3.Lines.Add('');
    //  Memo4.Lines.Add('ss');
      if StringGrid4.Cells[j+1,j1+1]<>'' then
      begin

     if  StringGrid4.Cells[j+1,j1+1]<>''+' < '+'' then
     begin

      if Classif.var_type[j]=0 then       // для бинарных переменных
        begin
       Memo4.Lines.Add('('+Table1.Fields[Classif.select_var[j]].FieldName+' = '+ StringGrid4.Cells[j+1,j1+1]+')');
      inc(kk);
       end;

       if Classif.var_type[j]<>0 then          // для количественных и номинальных
        begin
        if Classif.patterns0_l[Classif.S0[j1],j]>=0  then
        begin
        Memo4.Lines.Add('('+ StringGrid4.Cells[j+1,j1+1]+' '+Table1.Fields[Classif.select_var[j]].FieldName+')');
        inc(kk);
        end else
        begin
        Memo4.Lines.Add('('+ Table1.Fields[Classif.select_var[j]].FieldName+' '+StringGrid4.Cells[j+1,j1+1]+')');
        inc(kk);
        end;
        end;

        if Classif.var_type[j]<>0 then        //дублируем закономерность с двумя порогами
        begin
        if (Classif.patterns0_l[Classif.S0[j1],j]>=0) and (Classif.patterns0_r[Classif.S0[j1],j]>=0)  then
        begin
        Memo4.Lines.Add('('+ Table1.Fields[Classif.select_var[j]].FieldName+' '+StringGrid4.Cells[j+1,j1+1]+')');
        inc(kk);
        end;
        end;



     end;

      end;
      end;
     // Memo4.Lines.Strings[j1]:= Memo4.Lines.Text;

  end;
 // for j := 0 to StringGrid4.RowCount - 4 do
 // begin
 // проверка на двойное правило
 { j:=0;
  kk2:=0;
   for j1 := 0 to  kk-1 do
   begin


   if (Classif.patterns0_l[Classif.S0[j1],j]>=0) and (Classif.patterns0_r[Classif.S0[j1],j]>=0) then
   begin
   aa[j]:=   StrToint(StringGrid4.Cells[classif.num_var+2,j+1])-1;
   end else
   aa[j]:=  strtoint(StringGrid4.Cells[classif.num_var+2,j+1]);
   if kk2<=aa[j] then
    begin
    inc(kk2);
    end;
    if kk2>aa[j] then
    begin
    inc(j);
    kk2:=1;
    end;
   end; }
 j:=0;  // заполняем Memo5 из Memo4... получаем набор отрицательных паттернов
 Memo5.Lines.Strings[0]:= '=========================== Отрицательные правила =======================';
 Memo5.Lines.Add('Правило №'+inttostr(j+1)+'  ');
 j:=1;
  for j1 := 0 to  kk-1 do
  begin

   if Memo4.Lines.Strings[j1]<>'' then
   begin
   inc(kk1);
   end;

   if kk1 <=   StrToint(StringGrid4.Cells[classif.num_var+2,j]) then
   begin

   Memo5.Lines.Strings[j]:=Memo5.Lines.Strings[j]+' '+Memo4.Lines.Strings[j1];

   end;
   if kk1>StrToint(StringGrid4.Cells[classif.num_var+2,j]) then
   begin
   kk1:=1;
   inc(j);
   Memo5.Lines.Add('Правило №'+inttostr(j)+'  ');
  Memo5.Lines.Strings[j]:=Memo5.Lines.Strings[j]+' '+Memo4.Lines.Strings[j1];
   end;
  end;
  mm:=j;
  kk1:=0;
  kk:=0;
//===============================================================================
Memo4.Clear;
 for j1 := 0 to  StringGrid5.RowCount - 4 do             //считываем в Memo4 все закономерности с
                                                         // // таблицы модели пол. паттернов
  begin

      for j := 0 to classif.num_var-1 do
      begin
     //  Memo3.Lines.Add('');
    //  Memo4.Lines.Add('ss');
      if StringGrid5.Cells[j+1,j1+1]<>'' then
      begin

     if  StringGrid5.Cells[j+1,j1+1]<>''+' < '+'' then
     begin

      if Classif.var_type[j]=0 then                      // для бинарных переменных
        begin
       Memo4.Lines.Add('('+Table1.Fields[Classif.select_var[j]].FieldName+' = '+ StringGrid5.Cells[j+1,j1+1]+')');
      inc(kk);
       end;

       if Classif.var_type[j]<>0 then                          // для количественных и номинальных
        begin
        if Classif.patterns1_l[Classif.S1[j1],j]>=0  then
        begin
        Memo4.Lines.Add('('+ StringGrid5.Cells[j+1,j1+1]+' '+Table1.Fields[Classif.select_var[j]].FieldName+')');
        inc(kk);
        end else
        begin
        Memo4.Lines.Add('('+ Table1.Fields[Classif.select_var[j]].FieldName+' '+StringGrid5.Cells[j+1,j1+1]+')');
        inc(kk);
        end;
        end;

        if Classif.var_type[j]<>0 then                            //дублируем закономерность с двумя порогами
        begin
        if (Classif.patterns1_l[Classif.S1[j1],j]>=0) and (Classif.patterns1_r[Classif.S1[j1],j]>=0) then
        begin
        Memo4.Lines.Add('('+ Table1.Fields[Classif.select_var[j]].FieldName+' '+StringGrid5.Cells[j+1,j1+1]+')');
        inc(kk);
        end;
        end;



     end;

      end;
      end;
     // Memo4.Lines.Strings[j1]:= Memo4.Lines.Text;

  end;
 // for j := 0 to StringGrid4.RowCount - 4 do
 // begin
   //  SetLength(Classif.C0, 0);
  {  j:=mm+1;
    kk2:=0;
    for j1 := 0 to  kk-1 do
  begin

       if (Classif.patterns1_l[Classif.S1[j1],j-mm-1]>=0) and (Classif.patterns1_r[Classif.S1[j1],j-mm-1]>=0)  then
   begin
   bb[j-mm-1]:=   strtoint(StringGrid5.Cells[classif.num_var+2,j-mm-1])-1;
   end else
   bb[j-mm-1]:=  strtoint(StringGrid5.Cells[classif.num_var+2,j-mm-1]);
   end;

     if kk2<=bb[j] then
    begin
    inc(kk2);
    end;
    if kk2>bb[j] then
    begin
    inc(j);
    kk2:=1;
    end;       }

 j:=mm+2;  // продолжаем заполнять Memo5 из Memo4... получаем набор положительных паттернов
  Memo5.Lines.Add('=========================== Положительные правила =======================');
 //Memo5.Lines.Strings[j-1]:= '====================== Положительные правила ============================';
 Memo5.Lines.Add('Правило №'+inttostr(j-mm-1)+'  ');
 //Memo5.Lines.Strings[j]:= 'Правило №1';
  for j1 := 0 to  kk-1 do
  begin



   if Memo4.Lines.Strings[j1]<>'' then
   begin
   inc(kk1);
   end;
   if kk1 <=  strtoint(StringGrid5.Cells[classif.num_var+2,j-mm-1]) then
   begin
   Memo5.Lines.Strings[j]:=Memo5.Lines.Strings[j]+' '+Memo4.Lines.Strings[j1];

   end;
   if kk1>strtoint(StringGrid5.Cells[classif.num_var+2,j-mm-1]) then
   begin
   kk1:=1;
   inc(j);
   Memo5.Lines.Add('Правило №'+inttostr(j-mm-1)+'  ');
  Memo5.Lines.Strings[j]:=Memo5.Lines.Strings[j]+' '+Memo4.Lines.Strings[j1];
   end;
  end;
  p.X := 0;
  p.Y := 0;
  Memo5.CaretPos := p;
  // определяем номер первой видимой строки
  FirstVisible := SendMessage(Memo5.Handle,EM_GETFIRSTVISIBLELINE,0,0);
  // устанавливаем линию с курсором в качестве первой видимой
  SendMessage(Memo5.Handle,EM_LINESCROLL,0, p.Y - FirstVisible );
  Memo5.SetFocus;
    //  SetLength(Classif.C1, 0);
  //Classif.C0:=nil;
 // Classif.C1:=nil;
end;

procedure TForm1.Button15Click(Sender: TObject);    //сохраняем модель в *.txt из Memo5
begin
if SaveDialog3.Execute then
Memo5.Lines.SaveToFile(SaveDialog3.FileName);
end;

procedure TForm1.Button16Click(Sender: TObject); // настройка модели
var
i: integer;
k,m: double;
begin
{for i:=0 to 75 do
begin
if (Classif.model0_count>=15) and (Classif.model1_count>=15) then
if strtoint(Edit29.Text)>=strtoint(Edit28.Text) then
begin
k:=k+0.1;
Edit26.Text:=floattostr(k);
Edit27.Text:=floattostr(k);
Button11Click(Sender);
Button9Click(Sender);
end;
end;
k:=k-0.1;
Edit26.Text:=floattostr(k);
Edit27.Text:=floattostr(k);
Button11Click(Sender);
Button9Click(Sender);
m:=k;      }
k:=0;

repeat
k:=k+0.1;
Edit26.Text:=floattostr(k);
Edit27.Text:=floattostr(k);
Button11Click(Sender);
Button9Click(Sender);
until   ((Classif.model0_count<=15) or (Classif.model1_count<=15)) or (strtoint(Edit29.Text)<strtoint(Edit28.Text));

k:=k-0.1;
Edit26.Text:=floattostr(k);
Edit27.Text:=floattostr(k);
Button11Click(Sender);
Button9Click(Sender);
m:=k;

repeat
k:=k+0.1;
Edit26.Text:=floattostr(k);
Button11Click(Sender);
Button9Click(Sender);
until   (Classif.model0_count<=15) or (strtoint(Edit29.Text)<strtoint(Edit28.Text));
k:=k-0.1;
Edit26.Text:=floattostr(k);
Button11Click(Sender);
Button9Click(Sender);

repeat
m:=m+0.1;
Edit27.Text:=floattostr(m);
Button11Click(Sender);
Button9Click(Sender);
until   (Classif.model1_count<=15) or (strtoint(Edit29.Text)<strtoint(Edit28.Text));
m:=m-0.1;
Edit27.Text:=floattostr(m);
Button11Click(Sender);
Button9Click(Sender);
end;



procedure TForm1.Button17Click(Sender: TObject); // наращивание правил
var
  i,j,k:integer;
  s: double;
  start,stop: TDateTime;
begin
  iii:=0;
  num111:=1;
  ProgressBar2.Position:=0;
  start:=Time();
  classif.d2:=StrToInt(Edit11.Text);
  classif.d22:=StrToInt(Edit17.Text);
  Classif.pattern0_count:=StrToInt(Edit9.Text);
  Classif.find_patterns0_stab;
  StringGrid1.RowCount:=classif.pattern0_count+3;
  StringGrid1.ColCount:=classif.num_var+5;

  for j := 0 to classif.num_var-1 do  // названия столбцов
  begin
    StringGrid1.Font.Style:=[];
    if classif.var_sup[j]>0 then
      StringGrid1.Font.Style:=[fsBold];
    StringGrid1.Cells[j+1,0]:=IntToStr(Classif.select_var[j]+1)+' ';
    StringGrid1.Cells[j+1,0]:=StringGrid1.Cells[j+1,0]+Table1.Fields[Classif.select_var[j]].FieldName;
  end;
  StringGrid1.Cells[classif.num_var+1,0]:='покр_поз';
  StringGrid1.Cells[classif.num_var+2,0]:='степ';
  StringGrid1.Cells[classif.num_var+3,0]:='покр_нег';
  StringGrid1.Cells[classif.num_var+4,0]:='Инф_прав';

  for i := 0 to classif.pattern0_count-1 do // нумерация рядов
   begin
     StringGrid1.Cells[0, classif.pattern0_count+2]:='Важн %';
   StringGrid1.Cells[0, classif.pattern0_count+1]:='Важность';
   StringGrid1.Cells[0,i+1]:=IntToStr(i+1);

    end;
  with Classif do
    for i := 0 to classif.pattern0_count-1 do
    begin
      for j := 0 to classif.num_var-1 do
      begin

        StringGrid1.Cells[j+1,i+1]:='';
        if var_type[j]=0 then
        begin
          if patterns0_l[i,j]=1 then
            StringGrid1.Cells[j+1,i+1]:=FloatToStr(1);
          if patterns0_r[i,j]=1 then
            StringGrid1.Cells[j+1,i+1]:=FloatToStr(0);
        end else
        begin
          if patterns0_l[i,j]>=0 then
            StringGrid1.Cells[j+1,i+1]:=FloatToStr(patterns0_l[i,j]);
          StringGrid1.Cells[j+1,i+1]:=StringGrid1.Cells[j+1,i+1]+' - ';
          if patterns0_r[i,j]>=0 then
            StringGrid1.Cells[j+1,i+1]:=StringGrid1.Cells[j+1,i+1]+FloatToStr(patterns0_r[i,j]);
        end;
         end;
      StringGrid1.Cells[classif.num_var+1,i+1]:=IntToStr(classif.patterns0_pokr[i]);
      StringGrid1.Cells[classif.num_var+2,i+1]:=IntToStr(classif.patterns0_step[i]);
      StringGrid1.Cells[classif.num_var+3,i+1]:=IntToStr(classif.patterns0_neg[i]);
    end;

      for j := 0 to classif.num_var-1 do

    begin
     k:=0;
        for i := 0 to classif.pattern0_count-1 do
      begin
     if  StringGrid1.Cells[j+1,i+1]= '' then
         begin
         k:=k+1;
         end;
         if  StringGrid1.Cells[j+1,i+1]= ''+' - '+'' then
         begin
         k:=k+1;
         end
         end;
          StringGrid1.Cells[j+1, classif.pattern0_count+1]:= FloatToStr(classif.pattern0_count - k);
          StringGrid1.Cells[j+1, classif.pattern0_count+2]:= FloatToStr((classif.pattern0_count - k)*100/classif.pattern0_count);
         end;
         //--------------------------------------------------------
          for i := 0 to classif.pattern0_count-1 do
           begin
         s:=s+StrToFloat(StringGrid1.Cells[classif.num_var+1, i+1]);
         end;
         s:=s/classif.pattern0_count;
          s:= RoundTo(s, 0);
          StringGrid1.Cells[classif.num_var+1, classif.pattern0_count+1]:='срПокр';
         StringGrid1.Cells[classif.num_var+1, classif.pattern0_count+2]:= FloatToStr(s);

        // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern0_count-1 do
           begin
         s:=s+StrToFloat(StringGrid1.Cells[classif.num_var+2, i+1]);
         end;
         s:=s/classif.pattern0_count;
          s:= RoundTo(s, 0);
          StringGrid1.Cells[classif.num_var+2, classif.pattern0_count+1]:='срСтеп';
         StringGrid1.Cells[classif.num_var+2, classif.pattern0_count+2]:= FloatToStr(s);
         StringGrid1.Cells[classif.num_var+3, classif.pattern0_count+1]:='';
         StringGrid1.Cells[classif.num_var+3, classif.pattern0_count+2]:='';
        // -----------------------------------------------------
         // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern0_count-1 do
           begin
         s:=s+StrToFloat(StringGrid1.Cells[classif.num_var+3, i+1]);
         end;
         s:=s/classif.pattern0_count;
         // s:= RoundTo(s, 0);
          StringGrid1.Cells[classif.num_var+3, classif.pattern0_count+1]:='срПокрНег';
         StringGrid1.Cells[classif.num_var+3, classif.pattern0_count+2]:= FloatToStr(s);
      //   StringGrid1.Cells[classif.num_var+3, classif.pattern0_count+1]:='';
      //   StringGrid1.Cells[classif.num_var+3, classif.pattern0_count+2]:='';
        // -----------------------------------------------------

          // -----------------------------------------------------
         s:=0;
          for i := 0 to classif.pattern0_count-1 do
           begin
         s:=sqrt(StrToFloat(StringGrid1.Cells[classif.num_var+1, i+1]))-sqrt(StrToFloat(StringGrid1.Cells[classif.num_var+3, i+1]));
          StringGrid1.Cells[classif.num_var+4, i+1] :=FloatToStr(s);
            // s:= RoundTo(s, 0);
          s:=0;
         end;

        // -----------------------------------------------------

               // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern0_count-1 do
           begin
         s:=s+StrToFloat(StringGrid1.Cells[classif.num_var+4, i+1]);
         end;
         s:=s/classif.pattern0_count;
        //  s:= RoundTo(s, 0);
          StringGrid1.Cells[classif.num_var+4, classif.pattern0_count+1]:='срИнф';
         StringGrid1.Cells[classif.num_var+4, classif.pattern0_count+2]:= FloatToStr(s);

        // -----------------------------------------------------
         ProgressBar2.Position:=ProgressBar2.Max;
        stop:=Time();
        Edit20.Text:=TimeToStr(stop-start);
end;

procedure TForm1.Button18Click(Sender: TObject);
var
  i,j,k:integer;
  start, stop: TDateTime;
  s: double;
begin
  iii:=0;
  num111:=1;
  ProgressBar2.Position:=0;
  start:=Time();
  classif.d2:=StrToInt(Edit11.Text);
  classif.d22:=StrToInt(Edit17.Text);
  Classif.pattern1_count:=StrToInt(Edit10.Text);
  Classif.find_patterns1_stab;
  StringGrid2.RowCount:=classif.pattern1_count+3;
  StringGrid2.ColCount:=classif.num_var+5;

  for j := 0 to classif.num_var - 1 do  // названия столбцов
  begin
    StringGrid2.Font.Style:=[];
    if classif.var_sup[j]>0 then
      StringGrid2.Font.Style:=[fsBold];
    StringGrid2.Cells[j+1,0]:=IntToStr(Classif.select_var[j]+1)+' ';
    StringGrid2.Cells[j+1,0]:=StringGrid2.Cells[j+1,0]+Table1.Fields[Classif.select_var[j]].FieldName;
  end;
  StringGrid2.Cells[classif.num_var+1,0]:='покр_поз';
  StringGrid2.Cells[classif.num_var+2,0]:='степ';
  StringGrid2.Cells[classif.num_var+3,0]:='покр_нег';
   StringGrid2.Cells[classif.num_var+4,0]:='инф_прав';

  for i := 0 to classif.pattern1_count - 1 do // нумерация рядов
     begin
      StringGrid2.Cells[0, classif.pattern1_count+2]:='Важн %';
    StringGrid2.Cells[0, classif.pattern1_count+1]:='Важность';
    StringGrid2.Cells[0,i+1]:=IntToStr(i+1);
     end;
  with Classif do
    for i := 0 to classif.pattern1_count-1 do
    begin
      for j := 0 to classif.num_var-1 do
      begin
        StringGrid2.Cells[j+1,i+1]:='';
        if var_type[j]=0 then
        begin
          if patterns1_l[i,j]=1 then
            StringGrid2.Cells[j+1,i+1]:=FloatToStr(1);
          if patterns1_r[i,j]=1 then
            StringGrid2.Cells[j+1,i+1]:=FloatToStr(0);
        end else
        begin
          if patterns1_l[i,j]>=0 then
            StringGrid2.Cells[j+1,i+1]:=FloatToStr(patterns1_l[i,j]);
          StringGrid2.Cells[j+1,i+1]:=StringGrid2.Cells[j+1,i+1]+' - ';
          if patterns1_r[i,j]>=0 then
            StringGrid2.Cells[j+1,i+1]:=StringGrid2.Cells[j+1,i+1]+FloatToStr(patterns1_r[i,j]);
        end;
      end;
      StringGrid2.Cells[classif.num_var+1,i+1]:=IntToStr(classif.patterns1_pokr[i]);
      StringGrid2.Cells[classif.num_var+2,i+1]:=IntToStr(classif.patterns1_step[i]);
      StringGrid2.Cells[classif.num_var+3,i+1]:=IntToStr(classif.patterns1_neg[i]);
    end;
    //--------------------------------------
    for j := 0 to classif.num_var-1 do

    begin
     k:=0;
        for i := 0 to classif.pattern1_count-1 do
      begin
     if  StringGrid2.Cells[j+1,i+1]= '' then
         begin
         k:=k+1;
         end;
         if  StringGrid2.Cells[j+1,i+1]= ''+' - '+'' then
         begin
         k:=k+1;
         end
         end;
          StringGrid2.Cells[j+1, classif.pattern1_count+1]:= FloatToStr(classif.pattern1_count - k);
         StringGrid2.Cells[j+1, classif.pattern1_count+2]:= FloatToStr((classif.pattern1_count - k)*100/classif.pattern1_count);
         end;
          //--------------------------------------------------------
          for i := 0 to classif.pattern1_count-1 do
           begin
         s:=s+StrToFloat(StringGrid2.Cells[classif.num_var+1, i+1]);
         end;
         s:=s/classif.pattern1_count;
          s:= RoundTo(s, 0);
          StringGrid2.Cells[classif.num_var+1, classif.pattern1_count+1]:='срПокр';
         StringGrid2.Cells[classif.num_var+1, classif.pattern1_count+2]:= FloatToStr(s);

        // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern1_count-1 do
           begin
         s:=s+StrToFloat(StringGrid2.Cells[classif.num_var+2, i+1]);
         end;
         s:=s/classif.pattern1_count;
          s:= RoundTo(s, 0);
          StringGrid2.Cells[classif.num_var+2, classif.pattern1_count+1]:='срСтеп';
         StringGrid2.Cells[classif.num_var+2, classif.pattern1_count+2]:= FloatToStr(s);
          StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+1]:='';
         StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+2]:= '';
        // -----------------------------------------------------
           // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern1_count-1 do
           begin
         s:=s+StrToFloat(StringGrid2.Cells[classif.num_var+3, i+1]);
         end;
         s:=s/classif.pattern1_count;
         // s:= RoundTo(s, 0);
          StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+1]:='срПокрНег';
         StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+2]:= FloatToStr(s);
         // StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+1]:='';
       //  StringGrid2.Cells[classif.num_var+3, classif.pattern1_count+2]:= '';
        // -----------------------------------------------------
          // -----------------------------------------------------
         s:=0;
          for i := 0 to classif.pattern1_count-1 do
           begin
         s:=sqrt(StrToFloat(StringGrid2.Cells[classif.num_var+1, i+1]))-sqrt(StrToFloat(StringGrid2.Cells[classif.num_var+3, i+1]));
          StringGrid2.Cells[classif.num_var+4, i+1] :=FloatToStr(s);
            // s:= RoundTo(s, 0);
          s:=0;
         end;

        // -----------------------------------------------------
            // -----------------------------------------------------
          s:=0;
          for i := 0 to classif.pattern1_count-1 do
           begin
         s:=s+StrToFloat(StringGrid2.Cells[classif.num_var+4, i+1]);
         end;
         s:=s/classif.pattern1_count;
        //  s:= RoundTo(s, 0);
          StringGrid2.Cells[classif.num_var+4, classif.pattern1_count+1]:='срИнф';
         StringGrid2.Cells[classif.num_var+4, classif.pattern1_count+2]:= FloatToStr(s);

        // -----------------------------------------------------
         ProgressBar2.Position:=ProgressBar2.Max;
        stop:=Time();
        Edit22.Text:=TimeToStr(stop-start);

end;

end.
