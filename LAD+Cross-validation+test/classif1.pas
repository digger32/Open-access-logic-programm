unit classif1;

{$MODE Delphi}

interface

uses logic1, SysUtils, Dialogs, Math;

const
  const1 = 1;     // число признаков, по которым должны отличаться наблюдения
                  // при бинаризации
  var_max = 200;  // максимальное число переменных
  threshold_max = 1000; // максимальное число порогов (бин. переменных)
  viborka_max = 2000;  // наибольший объем выборки
  //thresh_num = 4; // начальное число порогов
  bin_max = 1000; // максимальное число булевых признаков
  //okruglenie = -2;

type
  massiv1=array[0..var_max-1] of integer;
  massiv2=array[0..var_max-1,0..threshold_max-1] of real;
  massiv30=array[0..var_max-1,0..threshold_max-1] of boolean;
  massiv3=array[0..var_max-1,0..viborka_max-1] of integer;
  massiv31=array[0..var_max-1,0..viborka_max-1] of string;
  massiv4=array[0..viborka_max-1] of real;
  massiv5=array[0..viborka_max-1] of integer;
  massiv51=array[0..viborka_max-1] of boolean;
  massiv6=array[0..var_max-1] of single;
  massiv7=array[0..bin_max-1] of shortint;
  massiv8=array[0..var_max-1,0..threshold_max-1] of integer;
  massiv9=array[0..viborka_max-1,0..bin_max-1] of shortint;
  massiv10=array[0..viborka_max-1,0..var_max-1] of single;
  massiv11=array[0..viborka_max-1,0..var_max-1] of string;
 // massiv12=array[0..viborka_max-1] of string;
{  observation=record
    attr: massiv6;
    izmeren: massiv6;
    klas: shortint;
  end;
  attribute=record
    name: string;
    typ:  shortint;
  end;
  ClassObserv=record
    observ: array[0..viborka_max-1] of observation_array;
    klas: shortint;
  end;   }

TClassif = class

  private
    porjadok:massiv3; // упорядочивание выборки
    thresh_add:massiv8; // где добавить пороги
    thresh_ind:massiv8; // номера упоряд. наблюдений, соотв. порогам

    function peresechenie:integer; // наложение полож. и отриц. наблюдений
    procedure count_bin;   // подсчитать число бинарных признаков

  public
    nomer_klassa : integer;

    d1,d2,d22,d3:integer;          // правая часть неравенств

    chislo_znach:massiv1;     //число разных значений номин. признака
    imena_znach:massiv31;    //наименования значений номин. признака

    objem:integer;   // объем выборки
    objem0, objem1:integer; // объем положительной и отрицательной выборки
    set0, set1:massiv5; // положительная и отрицательная выборки
    set_train:massiv51;  // обучающая выборка
    set_test:massiv51;   // контрольная выборка
    objem_train:integer; // объем обуч выборки
    objem_test:integer;  // объем тест выборки
    objem0_train, objem1_train:integer; // объем полож. и отр. обуч. выб.
    set0_train, set1_train:massiv5;
    objem0_test, objem1_test:integer; // объем полож. и отр. обуч. выб.
    set0_test, set1_test:massiv5;

    test_procent:double;  // деление выборки на обучающую-контрольную

    num_var:integer; // число выбранных признаков
    select_var:massiv1; // соответствие выбранных переменных исходным
    out_var:integer; // выход
    var_type:massiv1; // типы признаков
    thresh:massiv2;  // пороги
    thresh_use:massiv30; // бин. пер., указыв. использование порогов
    thresh_count:massiv1; // число порогов
    binarized:boolean;    // флаг бинаризации
    objem_real:massiv1; // число непустых значений по переменной
    t:integer; // число бинарных признаков

    viborka_train, viborka_test: massiv11; // обуч. и тест. выборки
   // klassy_train, klassy_test: massiv5;
    viborka0, viborka1:massiv9; // выборка данных

    support:massiv7;    // опорное мнгожество (для бинарных)
    thresh_sup:massiv8; // опорное множество (для порогов)
    var_sup:massiv1;    // опорное множество (для признаков)
    support_num:integer;        // объем опорного множества

    the_point:massiv7;  // текущее измерение
    the_cub:massiv7;    // текущий куб
    pokrytie:integer;   // покрытие подкуба
    stepen:integer;     // степень подкуба
    pokrytie_neg:integer;   // покрытие подкуба
    the_point_stab:massiv7;  //текущее измерен. стаб.

    pattern0_count:integer;
    pattern1_count:integer;
    patterns0:massiv9;  // паттерны
    patterns1:massiv9;
    patterns0_l:massiv10; // паттерны в числах
    patterns0_r:massiv10;
    patterns0_pokr:massiv5; // покрытие позитивное
    patterns0_step:massiv5; // степень
    patterns0_neg:massiv5; // покрытие негативное
    patterns1_l:massiv10; // паттерны в числах
    patterns1_r:massiv10;
    patterns1_pokr:massiv5; // покрытие позитивное
    patterns1_step:massiv5; // степень
    patterns1_neg:massiv5; // покрытие негативное

    use_pattern0:massiv5; // модель
    use_pattern1:massiv5;
    model0_count, model1_count: integer; // кол-во паттернов в модели
     S0: array [0..500] of integer; // номер отр. паттерна включенного в модель (показать паттерны)
     S1: array [0..500] of integer; // номер пол. паттерна включенного в модель (показать паттерны)
     C0: array [0..700] of double; //вес точки в обучающей выборке 0
     C1: array [0..700] of double; //вес точки в обучающей выборке 0


    test_cover0:massiv5;  // покрытие подкубами тестовой выборки
    test_cover1:massiv5;

    test_classif:massiv5; // прогноз модели для тестовой выборки
    test_classif_real:massiv5; // реальный выход

    precision0, precision1: real; // точность выхода
    chet0: integer; // счетчик групп, где не участвовали в тесте объекты 0 класса(для определения средней точности при процедуре кросс-валидация)
    chet1: integer; // счетчик групп, где не участвовали в тесте объекты 1 класса

    constructor Create;

    procedure test_v1;       // варианты тестов
    procedure test_v4;
    procedure test_v5;

    procedure select_variable;  // запомнить выбранные признаки
    procedure ident_variable;  // определить тип переменной
    procedure form_viborka;  // сформировать выборки

    procedure upor;
    procedure uporjad;          // упорядочить выборку по значениям переменной
    procedure find_sets;         // определить положит и отриц выборки
    procedure find_thresholds;  // найти пороги

//    function read_data(jj:integer):real; // прочитать данные из выборки
    function read_bin_data(ll:integer):massiv7;  // получить значение признако
    function read_bin_data_test(ll:integer):massiv7;  // получить значение признако

    procedure load_bin_data;    // ввести бинарную выборку в память

    procedure find_support;     // найти опорное множество
    procedure find_patterns0;    // найти паттерны
    procedure find_patterns1;
    procedure find_patterns0_stab;    // найти паттерны стабилиз
    procedure find_patterns1_stab;    // найти паттерны стабилиз

    procedure find_model;      // построить модель

    function covered(point,cub:massiv7):boolean; // покрывается ли точка подкубом
    function vihod(point:massiv7; var pokr0,pokr1:integer):shortint; // результат классификации
    procedure test1; // тестирование
    procedure vigruzka_binar;
    procedure zagruzka_binar;
    procedure form_binar;
end;

var
  Classif : TClassif;
  kt : Integer; // счетчик количество прогонов процедуры кросс-валидации
  patterns00_stab:massiv9;  // стабилизация
  patterns11_stab:massiv9;  // стабилизация
  iii, num111: integer;     // счетчик объектов стабилизации и паттернов StringGrid 1-2

implementation

uses search1;

constructor TClassif.Create;
begin
  DecimalSeparator:='.';

end; // create

procedure TClassif.find_sets;
var
  str {, str_class0}:string;
  j:integer;
begin
  //out_var:=Form1.ComboBox1.ItemIndex+1;

  objem:=0;               // подсчет объема выборки
  objem0:=0;
  objem1:=0;
  //Form1.Table1.First;
  //while not Form1.Table1.Eof do
  //str_class0:=Form1.StringGrid6.Cells[out_var,1];

  for j:=1 to Form1.StringGrid6.RowCount-1 do begin
    str:=Form1.StringGrid6.Cells[out_var+1,j];//Form1.Table1.Fields[out_var].AsString;

    if str=imena_klassov[0] then begin
      set0[objem0]:=objem;
      inc(objem0)  end; // else

    if str=imena_klassov[1] then
    begin
      set1[objem1]:=objem;
      inc(objem1);
    end;

    inc(objem);
    //Form1.Table1.Next
  end;
end;

procedure TClassif.select_variable; // выбрать признаки
var      // опр. вых. пр., число выбранных вх. пр., и указания на таблицу
  i:integer;
begin
  out_var:= Form1.ComboBox1.ItemIndex; // указание на класс
  num_var:=0;
  for i := 1 to Form1.StringGrid6.ColCount - 1 do
    if ((Form1.CheckListBox1.Checked[i-1]) and (i<>out_var+1)) then begin
      select_var[num_var]:=i-1; // множество используемых признаков
      inc(num_var)    end;
end;

procedure TClassif.ident_variable; // определить тип признаков
var
  i,j,ii,i1:integer;
  str:string;
  ch:double;
  b:boolean;
begin
  for j := 0 to num_var - 1 do
  begin
    i:=select_var[j];
    var_type[j]:=0;
    for ii:=1 to Form1.StringGrid6.RowCount-1 do begin
      str:=Form1.StringGrid6.Cells[i+1,ii];
      if ((str<>'') and (str<>'1') and (str<>'0')) then
      begin
        if ((var_type[j]<>1) and (trystrtofloat(str,ch))) then
          var_type[j]:=2 else var_type[j]:=1;
       {       ch:= strtoFloat(str);
        if ((ch<>0) and (ch<>1)) then
          if ((round(ch)=ch) and (var_type[j]<2) and (ch<11)) then
            var_type[j]:=1 else var_type[j]:=2;
    }
      end;
    end;
  end;

  for j := 0 to num_var - 1 do
    if var_type[j]=1 then begin
      i:=select_var[j];
      chislo_znach[j]:=1;
      imena_znach[j,0]:=Form1.stringGrid6.Cells[i+1,1];
    for i1 := 2 to Form1.stringGrid6.RowCount - 1 do
    begin
      b:=false;
      ii:=0;
      repeat
        if Form1.stringGrid6.Cells[i+1,i1]=imena_znach[j,ii] then
          b:=true;
        inc(ii);
      until (b or (ii=chislo_znach[j]));
      if not b then
      begin
        inc(chislo_znach[j]);
        imena_znach[j,chislo_znach[j]-1]:=Form1.stringGrid6.Cells[i+1,i1];
      end;
    end;
    end;
end;

procedure TClassif.test_v1;
var
  j:integer;
begin
  for j := 0 to objem - 1 do
  begin
    set_train[j]:=true;
    set_test[j]:=true;
  end;
  objem_train:=objem;
  objem_test:=objem;
end;


{procedure Tclassif.test_v4; //разделение выборки
var             //первая часть на обучение, остальные на контроль
  j:integer;
begin
  objem_train:=round(objem*test_procent/100);
  objem_test:=objem-objem_train;
  for j := 0 to objem_train - 1 do
  begin
    set_train[j]:=true;
    set_test[j]:=false;
  end;
  for j := objem_train to objem - 1 do
  begin
    set_train[j]:=false;
    set_test[j]:=true;
  end;
end;    }

procedure Tclassif.test_v4;  //разделение выборки на обуч. и контр.
var                          // случайным образом
  j,j1:integer;
begin
  objem_train:=round(objem*test_procent/100);
  objem_test:=objem-objem_train;
  for j := 0 to objem - 1 do
  begin
    set_train[j]:=true;
    set_test[j]:=false;
  end;

  j:=0;
  while j<objem_test do
  begin
    j1:=random(objem);
    if set_test[j1]=false then
    begin
      set_train[j1]:=false;
      set_test[j1]:=true;
      inc(j);
    end;
  end;
end;
 
procedure Tclassif.test_v5;
var
  j,j1:integer;

begin
  //вкладка "тестирование" появляются компоненты связанные с кросс-проверкой
  logic1.Form1.Label25.Visible:=true;
  logic1.Form1.Memo1.Visible:=true;
  logic1.Form1.Memo2.Visible:=true;
  logic1.Form1.Memo3.Visible:=true;
  logic1.Form1.Button8.Visible:=true;
  //--------------------------------------------
  objem_train:=round(objem/StrToInt(logic1.Form1.Edit19.Text)*(StrToInt(logic1.Form1.Edit19.Text)-1));
  objem_test:=objem-objem_train;
  for j := 0 to objem - 1 do
  begin
    set_train[j]:=true;
    set_test[j]:=false;
  end;

  j:=0;
  while j<objem_test do
  begin
    j1:=j+objem_test*kt;
    if set_test[j1]=false then
    begin
      set_train[j1]:=false;
      set_test[j1]:=true;
      inc(j);
    end;
  end;
  inc(kt);
end;

procedure Tclassif.form_viborka;
var  // формирование обучующей и контрольной выборок
  i, i1, i2, j:integer;
  str,str1:string;
begin
  //Form1.Table1.First;
  i1:=0;
  i2:=0;
  //i:=0;
  objem0_train:=0;
  objem1_train:=0;
  objem0_test:=0;
  objem1_test:=0;
  //while not Form1.Table1.Eof do
  //for j:=1 to  do begin
   //Form1.Table1.Fields[out_var].AsString;

  for i:=0 to objem-1 do begin
    str:= Form1.StringGrid6.Cells[out_var+1,i+1];

    if set_train[i] then
    begin
      for j := 0 to num_var - 1 do begin
        str1:=Form1.StringGrid6.Cells[select_var[j]+1,i+1];
        if str1='' then viborka_train[i1,j]:='' else
          viborka_train[i1,j]:=str1 end;//read_data(j);
      viborka_train[i1,num_var]:=Form1.StringGrid6.Cells[out_var+1,i+1];
{
      if str=imena_klassov[0] then begin
        set0_train[objem0_train]:=i1;
        inc(objem0_train) end;
      if str=imena_klassov[1] then begin
        set1_train[objem1_train]:=i1;
        inc(objem1_train) end;
       }
      inc(i1);

    end;

    if set_test[i] then
    begin
      for j := 0 to num_var - 1 do begin
        str1:=Form1.StringGrid6.Cells[select_var[j]+1,i+1];
        if str1='' then viborka_test[i2,j]:='' else    //ОШИБКИ
          viborka_test[i2,j]:=str1 end;//read_data(j);
      viborka_test[i1,num_var]:=Form1.StringGrid6.Cells[out_var+1,i+1];
 {
      if str=imena_klassov[0] then begin
        test_classif_real[i2]:=0;
        inc(objem0_test) end;
      if str=imena_klassov[1] then begin
        test_classif_real[i2]:=1;
        inc(objem1_test) end;
       }
      inc(i2);

    end;

    //inc(i);
    //Form1.Table1.Next;
  end;
end;


procedure TClassif.uporjad;
var
  j, l, k:integer;
  znach:massiv4;
  znach_klass:array[0..viborka_max-1] of string;
  ch:real;
  ind:integer;
  metka:boolean;

begin
  for j := 0 to num_var - 1 do
    if var_type[j]=2 then         // для каждой численной переменной
    begin
      objem_real[j]:=0;
      for l := 0 to objem_train - 1 do     // прочитать значения
      begin
        porjadok[j,l]:=l;
        if viborka_train[l,j]<>'' then
        begin
          znach[l]:=strtofloat(viborka_train[l,j]);
          inc(objem_real[j]);
        end else znach[l]:=-1;
      end; // while

      for k := 0 to objem_train - 2 do        // и упорядочить
        for l := k+1 to objem_train - 1 do
          if (((znach[k]>znach[l]) or (znach[k]=-1)) and (znach[l]<>-1)) then
          begin
            ch:=znach[l];
            ind:=porjadok[j,l];
            znach[l]:=znach[k];
            porjadok[j,l]:=porjadok[j,k];
            znach[k]:=ch;
            porjadok[j,k]:=ind;
          end;
                // для каждого значения определяю класс, к которому относится
      for k := 0 to objem_train - 1 do
        znach_klass[k]:=Form1.StringGrid6.Cells[out_var+1,porjadok[j,k]+1];
      k:=0;
      while (znach[k]<>-1) and (k<objem_train-1) do
      begin
        l:=k+1;
        metka:=false;
        while (znach[l]=znach[k]) and (l<=objem_train-1) do
        begin
          if znach_klass[l]<>znach_klass[k] then metka:=true;
          l:=l+1;
        end;
        if metka then
          repeat
            znach_klass[k]:='-1';
            k:=k+1;
          until k=l;
        k:=l;
      end;

      thresh_count[j]:=0;
      for k := 0 to objem_train - 2 do
      if znach[k]<znach[k+1] then
        if (znach_klass[k]<>znach_klass[k+1]) or (znach_klass[k]='-1') then
        begin
          thresh[j,thresh_count[j]]:=(znach[k]+znach[k+1])/2;
          inc(thresh_count[j]);
        end;
    end;
 {      thresh_num:=StrToInt(logic1.Form1.Edit18.Text);
      thresh_count[j]:=thresh_num;     // первичное назначение порогов
      ind:=round(objem_real[j]/(thresh_num+1)); // число измерений в интервале
      for k := 0 to thresh_num - 1 do
      begin
        thresh[j,k]:=znach[ind*(k+1)];  // может округлить????
        thresh_ind[j,k]:=ind*(k+1);
      end;
}
  {  end else if var_type[j]=1 then       // для каждой номинальной переменной
    begin
      objem_real[j]:=0;
      for l := 0 to objem_train - 1 do      // прочитать значения
      begin
        porjadok[j,l]:=l;
        if viborka_train[l,j]<>'' then begin
        znach[l]:=strtofloat(viborka_train[l,j]);
        inc(objem_real[j]);
        end else znach[l]:=-1;
      end; // while

      for k := 0 to objem_train - 2 do        // и упорядочить
        for l := k+1 to objem_train - 1 do
          if (((znach[k]>znach[l]) or (znach[k]=-1)) and (znach[l]<>-1)) then
          begin
            ch:=znach[l];
            ind:=porjadok[j,l];
            znach[l]:=znach[k];
            porjadok[j,l]:=porjadok[j,k];
            znach[k]:=ch;
            porjadok[j,k]:=ind;
          end;

      thresh_count[j]:=0;
      for l := 1 to objem_real[j] - 1 do
      begin
        if znach[l]>znach[l-1] then
        begin
          thresh[j,thresh_count[j]]:=znach[l];
          inc(thresh_count[j]);
        end;
      end;
     end
    else             // для каждой бинарной переменной
    begin
      thresh_count[j]:=1;
      thresh[j,0]:=1;
    end;
    }
 // count_bin;

  for k:=0 to num_var-1 do
    if var_type[k]=2 then
      for j:=0 to thresh_count[k]-1 do
        thresh_use[k,j]:=false;
end;

{function Tclassif.read_data(jj: Integer):real;
var
  ch:real;
  str:string;
begin
  str:=Form1.Table1.Fields[select_var[jj]].AsString;
  if str='' then ch:=-1
    else ch:=Form1.Table1.Fields[select_var[jj]].AsFloat;
  read_data:=ch;
end;
}

procedure TClassif.vigruzka_binar;
var
  pary, porogi:integer;
  f:textfile;
  i,j,i1,k,k1:integer;
  differ:array[0..var_max-1,0..threshold_max-1] of boolean;
  metka:boolean;
begin
  pary:=0;
  for i:=0 to objem_train-2 do
    for j:=i+1 to objem_train-1 do
      if viborka_train[i,num_var]<>viborka_train[j,num_var] then
         pary:=pary+1;
  porogi:=0;
  for i:=0 to num_var-1 do
    if var_type[i]=2 then
      porogi:=porogi+thresh_count[i];

  assignfile(f,'setcover.dat');
  rewrite(f);
  writeln(f,'data;');
  writeln(f,'param m:='+IntToStr(pary)+';');
  writeln(f,'param n:='+IntToStr(porogi)+';');
  write(f,'param a:');
  for i:=1 to porogi do
    write(f,'  '+IntToStr(i));
  writeln(f,':=');

  i1:=0;
  for i:=0 to objem_train-2 do
    for j:=i+1 to objem_train-1 do
      if viborka_train[i,num_var]<>viborka_train[j,num_var] then
      begin
        i1:=i1+1;  // последовательный номер пары наблюдений разных классов
        metka:=false;
        write(f,IntToStr(i1));
        for k:=0 to num_var-1 do
        begin
          if var_type[k]=2 then
            for k1:=0 to thresh_count[k]-1 do
            begin
              if ((viborka_train[i,k]<>'') and (viborka_train[j,k]<>'')) then
              begin
              if ((thresh[k,k1] >= strtofloat(viborka_train[i,k])) and
                (thresh[k,k1] < strtofloat(viborka_train[j,k]))) or
                ((thresh[k,k1] < strtofloat(viborka_train[i,k])) and
                (thresh[k,k1] >= strtofloat(viborka_train[j,k]))) then
                  differ[k,k1]:=true else differ[k,k1]:=false;
                  //write(f,'  1') else write(f,'  0');
              end else if ((viborka_train[i,k]='') and (viborka_train[j,k]=''))
                then differ[k,k1]:=false else differ[k,k1]:=true;
                //then write(f,'  0') else write(f,'  1');
              if differ[k,k1] then metka:=true;
            end;
        end;
        if metka then
        begin
          for k:=0 to num_var-1 do
            if var_type[k]=2 then
              for k1:=0 to thresh_count[k]-1 do
              begin
                if differ[k,k1] then write(f,'  1') else write(f,'  0');
              end;
          writeln(f);
        end;
      end;
    writeln(f,';');
  closefile(f);
end;

procedure TClassif.zagruzka_binar;
var
  f:textfile;
  ch:char;
  k,k1:integer;
begin
  assignfile(f,'solution.txt');
  reset(f);
  for k:=0 to num_var-1 do
    if var_type[k]=2 then
      for k1:=0 to thresh_count[k]-1 do begin
        repeat
          read(f,ch);
        until ((ch='0') or (ch='1'));
        if ch='1' then thresh_use[k,k1]:=true else thresh_use[k,k1]:=false;
      end;
  closefile(f);
end;

function TClassif.read_bin_data(ll:integer):massiv7;
var
  j, j1, i1 :integer;
  bin:massiv7;
  ch:real;
begin
  j1:=0;
  for j := 0 to num_var - 1 do
  begin
    ch:=strtofloat(viborka_train[ll,j]);
    for i1 := 0 to thresh_count[j] - 1 do
    begin
      if ch=-1 then bin[j1]:=-1 else
        if ch<thresh[j,i1] then bin[j1]:=0
          else bin[j1]:=1;
      inc(j1);
    end;
  end;
  read_bin_data:=bin;
end;


procedure Tclassif.count_bin;
var
  j:integer;
begin
  t:=0;
  for j := 0 to num_var - 1 do
    t:=t+thresh_count[j];
end;



procedure Tclassif.load_bin_data;
var
  l,k,j:integer;
  data0, data1:massiv7;
begin
    for l := 0 to objem0_train - 1 do   // для каждого отриц наблюдения
    begin
      data0:=read_bin_data(set0_train[l]);
      for j := 0 to t - 1 do
        viborka0[l,j]:=data0[j];
    end;

      for k := 0 to objem1_train - 1 do   // для каждого полож наблюдения
      begin
        data1:=read_bin_data(set1_train[k]);
        for j := 0 to t - 1 do
          viborka1[k,j]:=data1[j];
      end;
end;

procedure Tclassif.form_binar;
var
  l,k,k1,j,t1:integer;
//  data0, data1:massiv7;
  targ:integer;
  targ1:string;
begin
  targ:=Form1.ComboBox2.ItemIndex;
  targ1:=imena_klassov[targ];

  objem0_train:=0;
  objem1_train:=0;

  for l:=0 to objem_train-1 do
    if viborka_train[l,num_var]=targ1 then begin
      t1:=0;
      for k:=0 to num_var-1 do
        if var_type[k]=2 then begin
          for k1:=0 to thresh_count[k]-1 do begin
            if viborka_train[l,k]='' then viborka1[objem1_train,t1]:=-1
            else begin
              if strtofloat(viborka_train[l,k])<thresh[k,k1] then
              viborka1[objem1_train,t1]:=0
                else viborka1[objem1_train,t1]:=1;
            end;
            t1:=t1+1;
          end;
        end else if var_type[k]=1 then begin
          for k1:=0 to chislo_znach[k]-1 do begin
            if viborka_train[l,k]='' then viborka1[objem1_train,t1]:=-1
            else begin
              if viborka_train[l,k]=imena_znach[k,k1] then
              viborka1[objem1_train,t1]:=1
                else viborka1[objem1_train,t1]:=0;
            end;
            t1:=t1+1;
          end;
        end else if var_type[k]=0 then begin
          if viborka_train[l,k]='0' then viborka1[objem1_train,t1]:=0
            else if viborka_train[l,k]='1' then viborka1[objem1_train,t1]:=1
              else viborka1[objem1_train,t1]:=-1;
          t1:=t1+1;
        end;
      inc(objem1_train);
    end else begin

      t1:=0;
      for k:=0 to num_var-1 do
        if var_type[k]=2 then begin
          for k1:=0 to thresh_count[k]-1 do begin
            if viborka_train[l,k]='' then viborka0[objem0_train,t1]:=-1
            else begin
              if strtofloat(viborka_train[l,k])<thresh[k,k1] then
              viborka0[objem0_train,t1]:=0
                else viborka0[objem0_train,t1]:=1;
            end;
            t1:=t1+1;
          end;
        end else if var_type[k]=1 then begin
          for k1:=0 to chislo_znach[k]-1 do begin
            if viborka_train[l,k]='' then viborka0[objem0_train,t1]:=-1
            else begin
              if viborka_train[l,k]=imena_znach[k,k1] then
              viborka0[objem0_train,t1]:=1
                else viborka0[objem0_train,t1]:=0;
            end;
            t1:=t1+1;
          end;
        end else if var_type[k]=0 then begin
          if viborka_train[l,k]='0' then viborka0[objem0_train,t1]:=0
            else if viborka_train[l,k]='1' then viborka0[objem0_train,t1]:=1
              else viborka0[objem0_train,t1]:=-1;
          t1:=t1+1;
        end;
      inc(objem0_train);

    end;

    t:=t1;  // !!!!!!!!!!!!!!!!!

 {   for l := 0 to objem0_train - 1 do   // для каждого отриц наблюдения
    begin
      data0:=read_bin_data(set0_train[l]);
      for j := 0 to t - 1 do
        viborka0[l,j]:=data0[j];
    end;

      for k := 0 to objem1_train - 1 do   // для каждого полож наблюдения
      begin
        data1:=read_bin_data(set1_train[k]);
        for j := 0 to t - 1 do
          viborka1[k,j]:=data1[j];
      end;
      }
end;


function TClassif.peresechenie;
var
  j, j1, i1: integer;
  l, k, t1, peres:integer;
  data0, data1:massiv7;
  razl:integer;
  jj1, k1: integer;
  bool: boolean;
begin
  peres:=0;
  count_bin;
  load_bin_data;


  for j := 0 to num_var - 1 do
    thresh_add[j,0]:=0;

  for l := 0 to objem0_train - 1 do   // для каждого отриц наблюдения
  begin
    for j := 0 to t - 1 do
      data0[j]:=viborka0[l,j];

    for k := 0 to objem1_train - 1 do   // для каждого полож наблюдения
    begin
      for j := 0 to t - 1 do
        data1[j]:=viborka1[k,j];
                        // !!!!!!!!!!!!!!!!!!!!
      razl:=0;
      for t1 := 0 to t - 1 do      // рассчет числа различий по признакам

        if (data0[t1]>=0) and (data1[t1]>=0) then
          if data0[t1]<>data1[t1] then inc(razl);


      if razl < const1 then            // поиск порогов для детализации
      begin
        inc(peres);
        j1:=0;
        for j := 0 to num_var - 1 do
        begin
          if var_type[j]=2 then
          begin
            jj1:=0;
            bool:=true;    // показывает, надо ли добавлять порог
            for i1 := 0 to thresh_count[j] - 1 do
            begin
              if data0[j1+i1]=1 then inc(jj1);  // номер порога
              // jj1:=jj1+data0[j1+i1];
              if data0[j1+i1]<>data1[j1+i1] then
                bool:=false;
              if (data0[j1+i1]=-1) or (data1[j1+i1]=-1) then
                bool:=false;
            end;
            if bool then      // проверка на то, что этот порог уже добав.
              begin
              if thresh_add[j,0]>0 then
               begin
                for k1 := 1 to thresh_add[j,0] do
                 if jj1=thresh_add[j,k1] then
                    bool:=false;
                    end;

                    end;

            if bool then
            begin           // добавить порог

              inc(thresh_add[j,0]);
              thresh_add[j,thresh_add[j,0]]:=jj1;

            end;
          end;

          j1:=j1+thresh_count[j];
        end;
      end;
    end;
  end; 
  peresechenie:=peres;
end;


procedure Tclassif.find_thresholds;
var
  kk1:integer;
  jj, jj1:integer;
  num:integer;
  ind1:integer;
begin
  while peresechenie>0 do
  begin
    for jj := 0 to num_var - 1 do
      if var_type[jj]=2 then
      begin

        for kk1 := 1 to thresh_add[jj,0] do
        begin
          num:=thresh_add[jj,kk1];
          if num=0 then                  // определяем объем отрезка
            ind1:=thresh_ind[jj,num]
            else if num=thresh_count[jj] then
              ind1:=objem_real[jj]-thresh_ind[jj,num-1]
                else ind1:=thresh_ind[jj,num]-thresh_ind[jj,num-1];
          if num<thresh_count[jj] then
            for jj1 := thresh_count[jj] - 1 downto num do
            begin
              thresh[jj,jj1+1]:=thresh[jj,jj1];
              thresh_ind[jj,jj1+1]:=thresh_ind[jj,jj1];
            end;
          if num>0 then            // добавляем порог

            thresh_ind[jj,num]:=thresh_ind[jj,num-1]+round(ind1/2)
            else thresh_ind[jj,num]:=round(ind1/2);

          thresh[jj,num]:=strtofloat(viborka_train[porjadok[jj,thresh_ind[jj,num]],jj]);
          inc(thresh_count[jj]);
                 end;

      end;
  end;
end;


procedure TClassif.upor;
var
  j, l, k:integer;
  znach:massiv4;
  ch:real;
  ind, nn, kk, m, n:integer;

begin
   j := 0;
    if var_type[j]=2 then         // для каждой численной переменной
    begin
      objem_real[j]:=0;
      for l := 0 to objem_train - 1 do     // прочитать значения
      begin
        porjadok[j,l]:=l;
        znach[l]:=strtofloat(viborka_train[l,j]);
        if znach[l]<>-1 then inc(objem_real[j]);
      end; // while

      for k := 0 to objem_train - 2 do        // и упорядочить
        for l := k+1 to objem_train - 1 do
          if (((znach[k]>znach[l]) or (znach[k]=-1)) and (znach[l]<>-1)) then
          begin
            ch:=znach[l];
            ind:=porjadok[j,l];
            znach[l]:=znach[k];
            porjadok[j,l]:=porjadok[j,k];
            znach[k]:=ch;
            porjadok[j,k]:=ind;
          end;
          begin
           for m := 0 to objem_real[j] - 1 do
           for n := 0 to objem0 - 1 do
          if znach[m] = set0_train[j] then inc(nn)
          else inc(kk);
          end;
          

             end;

        end;

/////////////////////////////////////

procedure Tclassif.find_support; // нахождение опорного множества
var
  j1,l1:integer;
  t1:integer;
  ch1:integer;
begin
  count_bin;
  load_bin_data;

  search11:=Tsearch1.create;
  search11.pusk;               // алгоритм оптимизации
  search11.Free;

  support_num:=0;
  for j1 := 0 to t - 1 do
    if support[j1]=1 then
      inc(support_num);

  t1:=0;                       // выявление активных порогов
  for j1 := 0 to num_var - 1 do    // (интерпретация)
  begin
    ch1:=0;
    for l1 := 0 to thresh_count[j1] - 1 do
    begin
      thresh_sup[j1,l1]:=support[t1+l1];
      ch1:=ch1+thresh_sup[j1,l1];
    end;
    t1:=t1+thresh_count[j1];
    if ch1=thresh_count[j1] then
      var_sup[j1]:=2 else
      if ch1=0 then var_sup[j1]:=0 else
        var_sup[j1]:=1;
  end;

end;

procedure Tclassif.find_patterns0;    // нахождение паттернов
var
  l1,i1,jj,num, l:integer;
begin
      //==================инициализация весов===================
   for l := 0 to objem0_train - 1 do
   begin
   C0[l]:=1;
   end;
    //==================инициализация весов===================
  if pattern0_count>objem0_train then
    pattern0_count:=objem0_train;
  for l1 := 0 to pattern0_count - 1 do
  begin
    for i1 := 0 to t - 1 do
      the_point[i1]:=viborka0[l1,i1];

    search20:=Tsearch20.create;
    search20.pusk;
    search20.Free;

    for i1 := 0 to t - 1 do        // сохранение подкуба
      patterns0[l1,i1]:=the_cub[i1];
    patterns0_pokr[l1]:=pokrytie;
    patterns0_step[l1]:=stepen;
    patterns0_neg[l1]:=pokrytie_neg;

    for jj := 0 to num_var - 1 do
    begin
      patterns0_r[l1,jj]:=-1;
      patterns0_l[l1,jj]:=-1;
    end;

    jj:=0;       // номер переменной
    num:=0;      // номер порога
    for i1 := 0 to t - 1 do
    begin

        if (the_cub[i1]=0) and (patterns0_r[l1,jj]=-1) then
          patterns0_r[l1,jj]:=thresh[jj,num];
        if the_cub[i1]=1 then
          patterns0_l[l1,jj]:=thresh[jj,num];

      if num=thresh_count[jj]-1 then
      begin
        inc(jj); // след. переменная
        num:=0;
      end else
        inc(num);
    end;
  end;

end;


procedure Tclassif.find_patterns1;    // нахождение паттернов
var
  l1,i1,jj,num, l:integer;
begin
      //==================инициализация весов===================
   for l := 0 to objem0_train - 1 do
   begin
   C1[l]:=1;
   end;
    //==================инициализация весов===================
  if pattern1_count>objem1_train then
    pattern1_count:=objem1_train;
  for l1 := 0 to pattern1_count - 1 do
  begin
    for i1 := 0 to t - 1 do
      the_point[i1]:=viborka1[l1,i1];

    search21:=Tsearch21.create;
    search21.pusk;
    search21.Free;

    for i1 := 0 to t - 1 do        // сохранение подкуба
      patterns1[l1,i1]:=the_cub[i1];
    patterns1_pokr[l1]:=pokrytie;
    patterns1_step[l1]:=stepen;
    patterns1_neg[l1]:=pokrytie_neg;

    for jj := 0 to num_var - 1 do
    begin
      patterns1_r[l1,jj]:=-1;
      patterns1_l[l1,jj]:=-1;
    end;

    jj:=0;       // номер переменной
    num:=0;      // номер порога
    for i1 := 0 to t - 1 do
    begin
        if (the_cub[i1]=0) and (patterns1_r[l1,jj]=-1) then
          patterns1_r[l1,jj]:=thresh[jj,num];
        if the_cub[i1]=1 then
          patterns1_l[l1,jj]:=thresh[jj,num];

      if num=thresh_count[jj]-1 then
      begin
        inc(jj); // след. переменная
        num:=0;
      end else
        inc(num);
    end;
  end;
end;


//procedure Tclassif.find_model;
//var
 // ii:integer;
//begin

  //  search3:=Tsearch3.create;
 //   search3.pusk;
  //  search3.Free;

  //  model0_count:=0;
 //   for ii := 0 to pattern0_count - 1 do
  //    if use_pattern0[ii]=1 then
   //     inc(model0_count);

 //   model1_count:=0;
//    for ii := 0 to pattern1_count - 1 do
  //    if use_pattern1[ii]=1 then
    //    inc(model1_count);

//end;

procedure Tclassif.find_model;
var
  ii, kk:integer;
  km: double;
  B0: array [0..500] of integer;
  B1: array [0..500] of integer;
begin

   // search3:=Tsearch3.create;
   //search3.pusk;
  //  search3.Free;
  // SetLength(B0, 500);
  //  SetLength(S0, pattern0_count);
    model0_count:=0;
    for ii := 0 to pattern0_count - 1 do
    begin
      if StrToFloat(logic1.Form1.Edit26.Text)>StrtoFloat(logic1.Form1.StringGrid1.Cells[classif.num_var+4, ii+1]) then
       begin
       use_pattern0[ii]:=0;
      B0[ii]:= 0;
          end;
          if StrToFloat(logic1.Form1.Edit26.Text)<=StrtoFloat(logic1.Form1.StringGrid1.Cells[classif.num_var+4, ii+1]) then
       begin
       use_pattern0[ii]:=1 ;
     B0[ii]:= ii+1;
         inc(model0_count);
          end;
            end;
       //=============================  передаем номера паттернов, которые вошли в модель
       // необходимо для определения степени паттерна, которая исп. в процедуре "показать паттерны" при разделении закономерностей на паттерны
       kk:=0;
        for ii := 0 to pattern0_count - 1 do
        begin
        if B0[ii]<>0 then
        begin
        S0[kk]:= B0[ii]-1;
        inc(kk)
             end;
             end;


    //SetLength(B1, 500);
     // SetLength(S1, pattern1_count);
    model1_count:=0;
    for ii := 0 to pattern1_count - 1 do
    begin
      if StrToFloat(logic1.Form1.Edit27.Text)>StrtoFloat(logic1.Form1.StringGrid2.Cells[classif.num_var+4, ii+1]) then
       begin
        use_pattern1[ii]:=0;
       B1[ii]:= 0;
        end;
        if StrToFloat(logic1.Form1.Edit27.Text)<=StrtoFloat(logic1.Form1.StringGrid2.Cells[classif.num_var+4, ii+1]) then
       begin
        use_pattern1[ii]:=1;
           B1[ii]:= ii+1;
         inc(model1_count);
          end;

 //--------------------------------------------------------
   km:=logic1.Form1.ProgressBar3.Max/pattern1_count;
    if logic1.Form1.PageControl1.ActivePageIndex = 6 then
    begin
 logic1.Form1.ProgressBar3.Position:= logic1.Form1.ProgressBar3.Position+round(km);
    end;
 logic1.Form1.ProgressBar3.Position:=logic1.Form1.ProgressBar3.Max;
//---------------------------------------------------------------
          end;
 //============================================
         kk:=0;
        for ii := 0 to pattern1_count - 1 do
        begin
        if B1[ii]<>0 then
        begin
        S1[kk]:= B1[ii]-1;
        inc(kk)
             end;
             end;

      //B0:=nil;
     // B1:=nil;


end;
//////////////////////////////////////////
{procedure Tclassif.find_model;
var
  ii:integer;
begin

    search3:=Tsearch3.create;
    search3.pusk;
    search3.Free;

    model0_count:=0;
    for ii := 0 to pattern0_count - 1 do
      if use_pattern0[ii]=1 then
        inc(model0_count);

    model1_count:=0;
    for ii := 0 to pattern1_count - 1 do
      if use_pattern1[ii]=1 then
        inc(model1_count);

end;   }


//////////////////////////////////////////

function Tclassif.covered(point: massiv7; cub: massiv7):boolean;
var
  ii:integer;
  bool:boolean;
begin
  bool:=true;
  for ii := 0 to t - 1 do
    if cub[ii]>=0 then
      if (point[ii]<>cub[ii]) then
        bool:=false;
  covered:=bool;
end;

function TClassif.read_bin_data_test(ll:integer):massiv7;
var
  j, j1, i1 :integer;
  bin:massiv7;
  ch:real;
begin
  j1:=0;
  for j := 0 to num_var - 1 do
  begin
    ch:=strtofloat(viborka_test[ll,j]);
    for i1 := 0 to thresh_count[j] - 1 do
    begin
      if ch=-1 then bin[j1]:=-1 else
        if ch<thresh[j,i1] then bin[j1]:=0
          else bin[j1]:=1;
      inc(j1);
    end;
  end;
  read_bin_data_test:=bin;
end;


{function Tclassif.vihod(point: massiv7; var pokr0,pokr1:integer):shortint;
var
  l1,i1:integer;
  resultat01:real;
  a1,a2:double;
begin
  pokr0:=0;
  pokr1:=0;
  for l1 := 0 to pattern0_count - 1 do
    if use_pattern0[l1]=1 then
    begin
      for i1 := 0 to t - 1 do
        the_cub[i1]:=patterns0[l1,i1];
      if covered(point,the_cub) then inc(pokr0);
    end;

  for l1 := 0 to pattern1_count - 1 do
    if use_pattern1[l1]=1 then
    begin
      for i1 := 0 to t - 1 do
        the_cub[i1]:=patterns1[l1,i1];
      if covered(point,the_cub) then inc(pokr1);
    end;
     a1:= StrToFloat(logic1.Form1.Edit24.Text);
     if a1>1 then
     begin
     a1:=1;
     logic1.Form1.Edit24.Text:= FloatToStr(a1);
     end;
     if a1<0 then
     begin
     a1:=0;
     logic1.Form1.Edit24.Text:= FloatToStr(a1);
     end;
     a2:=1-a1;
     logic1.Form1.Edit25.Text:=FloatToStr(a2);
  resultat01:=a1*pokr0/model0_count - a2*pokr1/model1_count;

  if resultat01>0 then vihod:=0 else
    if resultat01<0 then vihod:=1 else
      vihod:=-1;
end; }

function Tclassif.vihod(point: massiv7; var pokr0,pokr1:integer):shortint;
var
  l1,i1:integer;
  resultat01:real;
  a1,a2,sum_wes0,sum_wes1:double;
   B: array[0..300] of double;
   B1: array [0..300] of double;
   C: array [0..300] of double;
   C1: array [0..300] of double;
begin
   //logic1.Form1.Memo3.Clear;
  //SetLength(B,model0_count);

  pokr0:=0;
  pokr1:=0;
  for l1 := 0 to model0_count - 1 do
    //if use_pattern0[l1]=1 then
    begin
      for i1 := 0 to t - 1 do
        the_cub[i1]:=patterns0[l1,i1];
      if covered(point,the_cub) then
      begin
       inc(pokr0);
       B[l1]:= StrToFloat(logic1.Form1.StringGrid4.Cells[classif.num_var+5, l1+1]);
       end;
       if not covered(point,the_cub) then
     begin
     B[l1]:=0; //logic1.Form1.Memo3.Lines.Add(FloatToStr(B[l1]));
     end;
    end;
       // SetLength(C,model0_count);                 //получение весов правил
       i1:=0;
      for l1 := 0 to model0_count - 1 do
      begin
      if B[l1]<>0 then
      begin
      C[i1]:=B[l1];
      logic1.Form1.Memo3.Lines.Add(FloatToStr(C[i1]));
      inc(i1);
      end;
       end;

      sum_wes0:=0;                 //определяем суммарный вес
      for l1 := 0 to i1 - 1 do
      begin
     sum_wes0:=sum_wes0+C[l1];
      end;
       logic1.Form1.Memo3.Lines.Add(FloatToStr(sum_wes0));


 //  SetLength(B1,model1_count);
  for l1 := 0 to model1_count - 1 do
   // if use_pattern1[l1]=1 then
    begin
      for i1 := 0 to t - 1 do
        the_cub[i1]:=patterns1[l1,i1];
      if covered(point,the_cub) then
       begin
       inc(pokr1);
       B1[l1]:= StrToFloat(logic1.Form1.StringGrid5.Cells[classif.num_var+5, l1+1]);
       end;
      if not covered(point,the_cub) then
     begin
     B1[l1]:=0;//logic1.Form1.Memo3.Lines.Add(FloatToStr(B[l1]));
     end;
    end;
    //    SetLength(C1,model1_count);                 //получение весов правил
       i1:=0;
      for l1 := 0 to model1_count - 1 do
      begin
      if B1[l1]<>0 then
      begin
      C1[i1]:=B1[l1];
      logic1.Form1.Memo3.Lines.Add(FloatToStr(C1[i1]));
      inc(i1);
      end;
       end;

      sum_wes1:=0;                 //определяем суммарный вес
      for l1 := 0 to i1 - 1 do
      begin
     sum_wes1:=sum_wes1+C1[l1];
      end;
       logic1.Form1.Memo3.Lines.Add(FloatToStr(sum_wes1));
   



     a1:= StrToFloat(logic1.Form1.Edit24.Text);
     if a1>1 then
     begin
     a1:=1;
     logic1.Form1.Edit24.Text:= FloatToStr(a1);
     end;
     if a1<0 then
     begin
     a1:=0;
     logic1.Form1.Edit24.Text:= FloatToStr(a1);
     end;
     a2:=1-a1;
     logic1.Form1.Edit25.Text:=FloatToStr(a2);
     if logic1.Form1.CheckBox1.Checked then
  // resultat01:=a1*sum_wes0/model0_count - a2*sum_wes1/model1_count
  // с учетом весов
   resultat01:=a1*sum_wes0{*(pokr0/model0_count)} - a2*sum_wes1{*(pokr1/model1_count)}
 //else resultat01:=a1*pokr0/model0_count - a2*pokr1/model1_count;
 // простое голосование
 else resultat01:=a1*pokr0/model0_count - a2*pokr1/model1_count;

  if resultat01>0 then vihod:=0 else
    if resultat01<0 then vihod:=1 else
      vihod:=-1;
end;



procedure Tclassif.test1;
var
  jj,tt,k:integer;
begin
  precision0:=0;
  precision1:=0;
  k:=0;
  for jj := 0 to objem_test-1 do
  begin

    the_point:=read_bin_data_test(jj);

    test_classif[jj]:=vihod(the_point,test_cover0[jj],test_cover1[jj]);

     if test_classif[jj]=-1 then      //подсчет неклассифицированных
     begin
     k:=k+1;
     end;


    if test_classif[jj]=test_classif_real[jj] then
      if test_classif_real[jj]=0 then
        precision0:=precision0+1 else precision1:=precision1+1;
  end;
  if classif.objem0_test=0 then
  begin
  classif.objem0_test:=1;
  inc(chet0);
  end;
  if classif.objem1_test=0 then
  begin
  classif.objem1_test:=1;
  inc(chet1);
  end;

  logic1.Form1.Edit28.Text:= inttostr(k);
  precision0:=round(precision0*100/objem0_test);
  precision1:=round(precision1*100/objem1_test);

end;

procedure Tclassif.find_patterns0_stab;    // нахождение паттернов
var
  l1,i1,jj,num:integer;
begin
  if pattern0_count>objem0_train then
    pattern0_count:=objem0_train;
  for l1 := 0 to pattern0_count - 1 do
  begin
    for i1 := 0 to t - 1 do
      the_point[i1]:=viborka0[l1,i1]; //patterns00_stab[l1,i1]; //

    for i1 := 0 to t - 1 do
      the_point_stab[i1]:= patterns00_stab[l1,i1]; //


    search20_stab:=Tsearch20_stab.create;
    search20_stab.pusk;
    search20_stab.Free;

    for i1 := 0 to t - 1 do        // сохранение подкуба
      patterns0[l1,i1]:=the_cub[i1];
    patterns0_pokr[l1]:=pokrytie;
    patterns0_step[l1]:=stepen;
    patterns0_neg[l1]:=pokrytie_neg;

    for jj := 0 to num_var - 1 do
    begin
      patterns0_r[l1,jj]:=-1;
      patterns0_l[l1,jj]:=-1;
    end;

    jj:=0;       // номер переменной
    num:=0;      // номер порога
    for i1 := 0 to t - 1 do
    begin

        if (the_cub[i1]=0) and (patterns0_r[l1,jj]=-1) then
          patterns0_r[l1,jj]:=thresh[jj,num];
        if the_cub[i1]=1 then
          patterns0_l[l1,jj]:=thresh[jj,num];

      if num=thresh_count[jj]-1 then
      begin
        inc(jj); // след. переменная
        num:=0;
      end else
        inc(num);
    end;
  end;

end;
//============================================================
procedure Tclassif.find_patterns1_stab;    // нахождение паттернов
var
  l1,i1,jj,num:integer;
begin
  if pattern1_count>objem1_train then
    pattern1_count:=objem1_train;
  for l1 := 0 to pattern1_count - 1 do
  begin
    for i1 := 0 to t - 1 do
      the_point[i1]:=viborka1[l1,i1];

         for i1 := 0 to t - 1 do
      the_point_stab[i1]:= patterns11_stab[l1,i1]; //

    search21_stab:=Tsearch21_stab.create;
    search21_stab.pusk;
    search21_stab.Free;

    for i1 := 0 to t - 1 do        // сохранение подкуба
      patterns1[l1,i1]:=the_cub[i1];
    patterns1_pokr[l1]:=pokrytie;
    patterns1_step[l1]:=stepen;
    patterns1_neg[l1]:=pokrytie_neg;

    for jj := 0 to num_var - 1 do
    begin
      patterns1_r[l1,jj]:=-1;
      patterns1_l[l1,jj]:=-1;
    end;

    jj:=0;       // номер переменной
    num:=0;      // номер порога
    for i1 := 0 to t - 1 do
    begin
        if (the_cub[i1]=0) and (patterns1_r[l1,jj]=-1) then
          patterns1_r[l1,jj]:=thresh[jj,num];
        if the_cub[i1]=1 then
          patterns1_l[l1,jj]:=thresh[jj,num];

      if num=thresh_count[jj]-1 then
      begin
        inc(jj); // след. переменная
        num:=0;
      end else
        inc(num);
    end;
  end;
end;



end.
