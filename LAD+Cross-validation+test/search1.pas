unit search1;

{$MODE Delphi}

       // функции и ограничения

interface

uses optim1, logic1, SysUtils;


type



Tsearch1 = class (Toptim)

protected

    function fc(xx:mus1):real; override;
    function fa(xx:mus1):real; override;



public
  constructor create;
  procedure pusk;
end;


Tsearch20 = class (Toptim)

protected

       function fc1(xx:mus1):real; override;
    function fc(xx:mus1):real; override;
    function fa(xx:mus1):real; override;
    procedure start_point; override;

public
  constructor create;
  procedure pusk;
end;

Tsearch20_stab = class (Toptim)

protected

    function fc(xx:mus1):real; override;
    function fa(xx:mus1):real; override;
    procedure start_point; override;

public
  constructor create;
  procedure pusk;
end;

Tsearch21_stab = class (Toptim)

protected

    function fc(xx:mus1):real; override;
    function fa(xx:mus1):real; override;
    procedure start_point; override;

public
  constructor create;
  procedure pusk;
end;

Tsearch21 = class (Toptim)

protected

  function fc1(xx:mus1):real; override;
    function fc(xx:mus1):real; override;
    function fa(xx:mus1):real; override;
    procedure start_point; override;

public
  constructor create;
  procedure pusk;
end;

Tsearch3 = class (Toptim)

protected


    function fc(xx:mus1):real; override;
    function fa(xx:mus1):real; override;

public
  constructor create;
  procedure pusk;
end;



var
  search11 : Tsearch1;
  search20 : Tsearch20;
  search21 : Tsearch21;
  search20_stab : Tsearch20_stab;
  search21_stab : Tsearch21_stab;
  search3 : Tsearch3;

implementation

uses classif1;

constructor Tsearch1.create;
begin
  n:=classif.t;
  L:=2;
  R:=40;

end;

function Tsearch1.fc(xx: mus1):real;
var
  ii1:integer;
  fcc:integer;
begin
  fcc:=0;
  for ii1 := 1 to n do
    fcc:=fcc+xx[ii1];
  fc:=fcc;
end;


function Tsearch1.fa(xx: mus1):real;
var
  l,k:integer;
  ii1:integer;
  summa:integer;
  summa_min:integer;
  znach0, znach1:shortint;
begin
  summa_min:=big;
  with classif do
  begin
    for l := 0 to objem0_train - 1 do   // для каждого отриц наблюдения
    begin

      for k := 0 to objem1_train - 1 do   // для каждого полож наблюдения
      begin

        summa:=0;
        for ii1 := 1 to n do
        begin
          znach0:=viborka0[l,ii1-1];
          znach1:=viborka1[k,ii1-1];
          if (znach0>=0) and (znach1>=0) then  // если признаки измерены
            if (znach0<>znach1) and (xx[ii1]=1) then // сама функция
              inc(summa);
        end;
        if summa<summa_min then
          summa_min:=summa;
      end;
    end;

  end;

  fa:=summa_min-classif.d1;  // вычитаем правую часть
end;

procedure Tsearch1.pusk;
var
  ii:integer;
begin
  TurnirSearch;
  
  for ii := 1 to n do
    classif.support[ii-1]:=xopt[ii];
end;

////////////////////////////////

constructor Tsearch20.create;
begin
  n:=classif.t;
  L:=4;
  R:=40;
end;

procedure Tsearch20.start_point;
var
  i:word;
begin
  level:=0;
  for i := 1 to n do
    if (Classif.the_point[i-1]>=0) and (classif.support[i-1]=1) then
      x[i]:=1 else
      begin
        x[i]:=0;
        inc(level);
      end;
end;

function Tsearch20.fc(xx: mus1):real;
var
  l:integer;
  ii1:integer;
  summa:double;
  prod:integer;

begin
  summa:=0;

  with classif do
  begin
    for l := 0 to objem0_train - 1 do   // для каждого отриц наблюдения
    begin
      prod:=1;
      for ii1 := 1 to n do
        if xx[ii1]=1 then
        begin
          if (viborka0[l,ii1-1]<>the_point[ii1-1]) {and (viborka0[l,ii1-1]>=0)} then
            prod:=0;
        end;
          summa:=summa+C0[l]*prod;
     end;
  end;
  fc:=-summa;
end;

function Tsearch20.fc1(xx: mus1):real;
var
  l:integer;
  ii1:integer;
  summa:double;
  prod:integer;

begin
  summa:=0;

  with classif do
  begin
    for l := 0 to objem0_train - 1 do   // для каждого отриц наблюдения
    begin
      prod:=1;
      for ii1 := 1 to n do
        if xx[ii1]=1 then
        begin
          if (viborka0[l,ii1-1]<>the_point[ii1-1]) {and (viborka0[l,ii1-1]>=0)} then
            prod:=0;
        end;
          summa:=summa+C0[l]*prod;
          //======================корректировка весов================
        if (prod=1) and (C0[l]>0) then
        begin
        C0[l]:= C0[l]-0.1;
        end;
     //======================корректировка весов================

    end;
  end;
  fc1:=-summa;
end;


function Tsearch20.fa(xx: mus1):real;  // ограничение
var                                   // с ослаблением
  k:integer;
  ii1:integer;
  summa:integer;
  summa1:integer;
begin
  summa1:=0; // число покрытых наблюдений
  with classif do
  begin
      for k := 0 to objem1_train - 1 do   // для каждого полож наблюдения
      begin
        summa:=0;
        for ii1 := 1 to n do
          if xx[ii1]=1 then
          begin
            if viborka1[k,ii1-1]<>the_point[ii1-1] then
                inc(summa);  // число переменных, по которым
          end;                 // различаются точки
        if summa<d2 then
          inc(summa1);       // точка покрывается
      end;

  end;

  fa:=classif.d22-summa1;
                             // fa>=0
end;

procedure Tsearch20.pusk;
var
  ii:integer;
   km:double;
begin

  TurnirSearch1;
  //---------------------------------------------------------  процесс на ProgressBar

      km:=logic1.Form1.ProgressBar2.Max/classif1.Classif.pattern0_count;
     if logic1.Form1.PageControl1.ActivePageIndex = 5 then
    begin
        km:= logic1.Form1.ProgressBar2.Position+km;
       logic1.Form1.ProgressBar2.Position:=round(km);
       end;
    //----------------------------------------------------------
  classif.stepen:=0;
  for ii := 1 to n do       // фиксируем подкуб
    if xopt[ii]=1 then
    begin
      classif.the_cub[ii-1]:=classif.the_point[ii-1];
      inc(classif.stepen);    // уровень
    end
        else classif.the_cub[ii-1]:=-1;
  classif.pokrytie:=round(-fopt);
  classif.pokrytie_neg:=round(classif.d22-fa(xopt));

      for ii := 1 to n do
        patterns00_stab[iii, ii-1]:=xopt[ii];
      inc(iii);

end;

/////////////////////////////////////////
constructor Tsearch20_stab.create;
begin
  n:=classif.t;
  L:=1;
  R:=65;
end;

procedure Tsearch20_stab.start_point;
var
  i:word;
begin
  level:=0;
  for i := 1 to n do
    begin
    if (Classif.the_point[i-1]>=0) and (classif.support[i-1]=1)and (classif.the_point_stab[i-1]>0) then
      begin
      x[i]:=1;
      inc(level);
      // logic1.Form1.Memo3.Lines.Add(inttostr(i)+' '+floattostr(x[i]));
      end
       else
      begin
       if (Classif.the_point[i-1]>=0) and (classif.support[i-1]=1) then
        x[i]:=0;
     // logic1.Form1.Memo3.Lines.Add(inttostr(i)+' '+floattostr(x[i]));
      end;
      end;
end;

function Tsearch20_stab.fc(xx: mus1):real;
var
  l:integer;
  ii1:integer;
  summa:integer;
  prod:integer;
begin
  summa:=0;
  with classif do
  begin
    for l := 0 to objem0_train - 1 do   // для каждого отриц наблюдения
    begin
      prod:=1;
      for ii1 := 1 to n do
        if xx[ii1]=1 then
        begin
          if (viborka0[l,ii1-1]<>the_point[ii1-1]) {and (viborka0[l,ii1-1]>=0)} then
            prod:=0;
        end;
      summa:=summa+prod;
    end;
  end;
  fc:=-summa;
end;


function Tsearch20_stab.fa(xx: mus1):real;  // ограничение
var                                   // с ослаблением
  k:integer;
  ii1:integer;
  summa:integer;
  summa1:integer;
begin
  summa1:=0;
  with classif do
  begin
      for k := 0 to objem1_train - 1 do   // для каждого полож наблюдения
      begin
        summa:=0;
        for ii1 := 1 to n do
          if xx[ii1]=1 then
          begin
            if viborka1[k,ii1-1]<>the_point[ii1-1] then
                inc(summa);  // число переменных, по которым
          end;                 // различаются точки
        if summa<d2 then
          inc(summa1);       // точка покрывается
      end;

  end;

  fa:=classif.d22-summa1;
                             // fa>=0
end;

procedure Tsearch20_stab.pusk;
var
  ii:integer;
begin
  TurnirSearch1_stab;
  classif.stepen:=0;
  for ii := 1 to n do       // фиксируем подкуб
    if xopt[ii]=1 then
    begin
      classif.the_cub[ii-1]:=classif.the_point[ii-1];
      inc(classif.stepen);    // уровень
    end
        else classif.the_cub[ii-1]:=-1;
  classif.pokrytie:=round(-fopt);
  classif.pokrytie_neg:=round(classif.d22-fa(xopt));
  inc(num111);
   for ii := 1 to n do
   logic1.Form1.Memo3.Lines.Add(inttostr(ii)+' '+floattostr(xopt[ii]));
end;


///////////////////////////////////////
constructor Tsearch21.create;
begin
  n:=classif.t;
  L:=4;
  R:=40;
end;

procedure Tsearch21.start_point;
var
  i:word;
begin
  level:=0;
  for i := 1 to n do
    if (Classif.the_point[i-1]>=0) and (classif.support[i-1]=1) then
      x[i]:=1 else
      begin
        x[i]:=0;
        inc(level);
      end;
end;

function Tsearch21.fc(xx: mus1):real;
var
  l:integer;
  ii1:integer;
  summa:double;
  prod:integer;

begin
  summa:=0;

  with classif do
  begin
    for l := 0 to objem1_train - 1 do   // для каждого отриц наблюдения
    begin
      prod:=1;
      for ii1 := 1 to n do
        if xx[ii1]=1 then
        begin
          if (viborka1[l,ii1-1]<>the_point[ii1-1]) {and (viborka1[l,ii1-1]>=0)} then
            prod:=0;
        end;
        summa:=summa+C1[l]*prod;
   end;
  end;
  fc:=-summa;
end;

function Tsearch21.fc1(xx: mus1):real;
var
  l:integer;
  ii1:integer;
  summa:double;
  prod:integer;

begin
  summa:=0;

  with classif do
  begin
    for l := 0 to objem1_train - 1 do   // для каждого отриц наблюдения
    begin
      prod:=1;
      for ii1 := 1 to n do
        if xx[ii1]=1 then
        begin
          if (viborka1[l,ii1-1]<>the_point[ii1-1]) {and (viborka1[l,ii1-1]>=0)} then
            prod:=0;
        end;
        summa:=summa+C1[l]*prod;

      //======================корректировка весов================
        if (prod=1) and (C1[l]>0) then
        begin
        C1[l]:= C1[l]-0.1;
        end;
     //======================корректировка весов================

    end;
  end;
  fc1:=-summa;
end;




function Tsearch21.fa(xx: mus1):real;  // ограничение
var                                   // с ослаблением
  k:integer;
  ii1:integer;
  summa:integer;
  summa1:integer;
begin
  summa1:=0;
  with classif do
  begin
      for k := 0 to objem0_train - 1 do   // для каждого полож наблюдения
      begin
        summa:=0;
        for ii1 := 1 to n do
          if xx[ii1]=1 then
          begin
            if viborka0[k,ii1-1]<>the_point[ii1-1] then
                inc(summa);  // число переменных, по которым
          end;                 // различаются точки
        if summa<d2 then
          inc(summa1);       // точка покрывается
      end;

  end;

  fa:=classif.d22-summa1;
                             // fa>=0
end;


procedure Tsearch21.pusk;
var
  ii:integer;
  km:double;
begin
  TurnirSearch1;
  //--------------------------------------------------------
    km:=(logic1.Form1.ProgressBar2.Max/classif1.Classif.pattern1_count);
     if logic1.Form1.PageControl1.ActivePageIndex = 5 then
    begin
    km:= logic1.Form1.ProgressBar2.Position+km;
       logic1.Form1.ProgressBar2.Position:=round(km);
 //logic1.Form1.ProgressBar2.Position:= logic1.Form1.ProgressBar2.Position+round(km);
    end;
 //------------------------------------------------------------
  classif.stepen:=0;
  for ii := 1 to n do       // фиксируем подкуб
    if xopt[ii]=1 then
    begin
      classif.the_cub[ii-1]:=classif.the_point[ii-1];
      inc(classif.stepen);    // уровень
    end
        else classif.the_cub[ii-1]:=-1;

  classif.pokrytie:=round(-fopt);
  classif.pokrytie_neg:=round(classif.d22-fa(xopt));
      for ii := 1 to n do
        patterns11_stab[iii, ii-1]:=xopt[ii];
      inc(iii);
end;

///////////////////////////////////////
constructor Tsearch21_stab.create;
begin
  n:=classif.t;
  L:=1;
  R:=65;
end;

procedure Tsearch21_stab.start_point;
var
  i:word;
begin
  level:=0;
  for i := 1 to n do
    if (Classif.the_point[i-1]>=0) and (classif.support[i-1]=1)and(classif.the_point_stab[i-1]>0) then
      begin
      x[i]:=1;
       inc(level);
       end
        else
      begin
       if (Classif.the_point[i-1]>=0) and (classif.support[i-1]=1) then
        x[i]:=0;

      end;
end;

{procedure Tsearch21_stab.start_point;
var
  i:word;
begin
  level:=0;
  for i := 1 to n do
    if (Classif.the_point[i-1]>=0) and (classif.support[i-1]=1)and(classif.the_point_stab[i-1]>0) then
      x[i]:=1 else
      begin
        x[i]:=0;
        inc(level);
      end;
end;
}

function Tsearch21_stab.fc(xx: mus1):real;
var
  l:integer;
  ii1:integer;
  summa:integer;
  prod:integer;
begin
  summa:=0;
  with classif do
  begin
    for l := 0 to objem1_train - 1 do   // для каждого отриц наблюдения
    begin
      prod:=1;
      for ii1 := 1 to n do
        if xx[ii1]=1 then
        begin
          if (viborka1[l,ii1-1]<>the_point[ii1-1]) {and (viborka1[l,ii1-1]>=0)} then
            prod:=0;
        end;
      summa:=summa+prod;
    end;
  end;
  fc:=-summa;
end;



function Tsearch21_stab.fa(xx: mus1):real;  // ограничение
var                                   // с ослаблением
  k:integer;
  ii1:integer;
  summa:integer;
  summa1:integer;
begin
  summa1:=0;
  with classif do
  begin
      for k := 0 to objem0_train - 1 do   // для каждого полож наблюдения
      begin
        summa:=0;
        for ii1 := 1 to n do
          if xx[ii1]=1 then
          begin
            if viborka0[k,ii1-1]<>the_point[ii1-1] then
                inc(summa);  // число переменных, по которым
          end;                 // различаются точки
        if summa<d2 then
          inc(summa1);       // точка покрывается
      end;

  end;

  fa:=classif.d22-summa1;
                             // fa>=0
end;


procedure Tsearch21_stab.pusk;
var
  ii:integer;
begin
  TurnirSearch2_stab;
  classif.stepen:=0;
  for ii := 1 to n do       // фиксируем подкуб
    if xopt[ii]=1 then
    begin
      classif.the_cub[ii-1]:=classif.the_point[ii-1];
      inc(classif.stepen);    // уровень
    end
        else classif.the_cub[ii-1]:=-1;

  classif.pokrytie:=round(-fopt);
  classif.pokrytie_neg:=round(classif.d22-fa(xopt));
  inc(num111);
end;

////////////////////////////////////////////////

////////////////////////////////////////////////

constructor Tsearch3.create;
begin
  n:=classif.pattern0_count+classif.pattern1_count;
  L:=5;
  R:=20;
end;


function Tsearch3.fc(xx: mus1):real;
var
  ii1:integer;
  fcc:integer;
begin
  fcc:=0;
  for ii1 := 1 to n do
    fcc:=fcc+xx[ii1];
  fc:=fcc;
end;


function Tsearch3.fa(xx: mus1):real;
var
  l,k:integer;
  ii1,jj1:integer;
  summa:integer;
  summa_min:integer;
  bool:boolean;
begin
  summa_min:=big;
  with classif do
  begin
    for l := 0 to objem0_train - 1 do   // для каждого отриц наблюдения
    begin
      summa:=0;
      for ii1 := 0 to pattern0_count - 1 do  // для каждого паттерна
        if xx[ii1+1]=1 then
        begin
          bool:=true;
          for jj1 := 0 to t - 1 do   // проверяем покрытие
            if patterns0[ii1,jj1]>=0 then
              if (viborka0[l,jj1]<>patterns0[ii1,jj1]) then
                bool:=false;
          if bool then
            inc(summa);
        end;
      if summa<summa_min then
        summa_min:=summa;
    end;

    for k := 0 to objem1_train - 1 do   // для каждого отриц наблюдения
    begin
      summa:=0;
      for ii1 := 0 to pattern1_count - 1 do  // для каждого паттерна
        if xx[pattern0_count+ii1+1]=1 then
        begin
          bool:=true;
          for jj1 := 0 to t - 1 do   // проверяем покрытие
            if patterns1[ii1,jj1]>=0 then
              if (viborka1[k,jj1]<>patterns1[ii1,jj1]) then
                bool:=false;
          if bool then
            inc(summa);
        end;
      if summa<summa_min then
        summa_min:=summa;
    end;


  end;

  fa:=summa_min-classif.d3;  // вычитаем правую часть
end;


procedure Tsearch3.pusk;
var
  ii:integer;
begin
  TurnirSearch1;
  for ii := 0 to classif.pattern0_count - 1 do
    classif.use_pattern0[ii]:=xopt[ii+1];
  for ii := 0 to classif.pattern1_count - 1 do
    classif.use_pattern1[ii]:=xopt[classif.pattern0_count+ii+1];

end;


end.
