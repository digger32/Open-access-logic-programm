unit optim1;

{$MODE Delphi}

     // алгоритмы оптимизации

interface
 uses logic1, SysUtils,classif1;
const
  nmax = 2000;         // размерность булева вектора
  big = 100000;        // большое число
  verybig = 1000000;   // очень большое число

type
  mus1=array[1..nmax] of word;
  mus2=array[1..nmax] of real;


Toptim = class

  private
    f:real;      //ц.ф.
    T:integer;          //трудоемкость

    function next4:boolean;           // поиск след. точки
    function next41:boolean;
     function next41_stab:boolean;           // поиск след. точки
    function next42_stab:boolean;

  protected
    x:mus1;           //текущая точка поиска
    x1:mus1;          //след. точка
    level:word;    //текущий уровень

    function fc(xx:mus1):real; virtual; abstract;
    function fa(xx:mus1):real; virtual; abstract;
       function fc1(xx:mus1):real; virtual; abstract;
    procedure start_point; virtual;      // стартовая точка


  public
    L:word;           //кол-во повторений алгоритма
    R:word;           //кол-во просм. точек в новом алгоритме

    n:word;                  //размерность
    m:word;             // количество ограничений
    fopt:real;
    xopt:mus1;        //опт. точка
    km: double;         // накопление в ProgressBar1

    constructor create;
    procedure TurnirSearch;           // процедура поиска
    procedure TurnirSearch1;
     procedure TurnirSearch1_stab;           // процедура поиска
    procedure TurnirSearch2_stab;

end;

implementation

constructor Toptim.create;
begin

end;


procedure Toptim.start_point;
var
  i:word;
begin
  for i := 1 to n do
    x[i]:=1;
  level:=0;
end;

function Toptim.next4:boolean;
var
  x2:mus1;
  ok1:boolean;
  z:word;  //кол-во точек для выбора
  n1,n2:word;
  i1,j1:word;
  otn,otn1:real;
  r1:word;
  fa1:real;
  km1: double;
begin
  j1:=0;
  x2:=x;
  z:=n-level;    // кол-во соседних точек след. уровня
  otn:=verybig;
  ok1:=false;
  r1:=0;
  //-----------------------------

   //km1:=km+1.5;
    logic1.Form1.ProgressBar1.Position:= round(km);
//-------------------------------------------------------
  repeat
    r1:=r1+1;
    n1:=random(z)+1;  // случайно выбираем одну из соседних точек
    n2:=0;
    i1:=0;
    repeat      //ищем эту точку
      inc(i1);
      if x2[i1]=1 then inc(n2);
    until n2=n1;
    x2[i1]:=0;   // переходим в нее
    x1:=x;
    x1[i1]:=0;

    fa1:=fa(x1);
    if fa1>=0 then
    begin
      ok1:=true;      // найдена допустимая точка
      //if fa1>0 then
        otn1:=fc(x1)/(fa1+1);
        //  else otn1:=big;
      if otn1<otn then
      begin
        j1:=i1;
        otn:=otn1;
      end;
    end;
    T:=T+1;
    {if (not ok1) then} z:=z-1;
  until (z=0) or (ok1 and (r1>=R));

  x1:=x;
  x1[j1]:=0;
  next4:=ok1;
end;

procedure Toptim.TurnirSearch;
var
  ll:word;
  ok:boolean;

begin
 km:=0;
 T:=0;
 fopt:=verybig;
 for ll:=1 to L do
 begin
  start_point;

  f:=fc(x);
  repeat
  km:= km+1.3/L;
    ok:=next4;

    if ok then
    begin
      x:=x1;
      inc(level);
      f:=fc(x);
    end;
  until (not ok) or (level=n);
  if f<fopt then
  begin
    fopt:=f;
    xopt:=x;
  end;
 end;

end;

/////////////// альтернатива
function Toptim.next41:boolean;
var
  x2:mus1;
  ok1:boolean;
  z:word;  //кол-во точек для выбора
  n1,n2:word;
  i1,j1:word;
  otn,otn1:real;
  r1:word;
  fa1:real;
begin
  j1:=0;
  x2:=x;
  z:=n-level;    // кол-во соседних точек след. уровня
  otn:=verybig;
  ok1:=false;
  r1:=0;
  repeat
    r1:=r1+1;
    n1:=random(z)+1;  // случайно выбираем одну из соседних точек
    n2:=0;
    i1:=0;
    repeat      //ищем эту точку
      inc(i1);
      if x2[i1]=1 then inc(n2);
    until n2=n1;
    x2[i1]:=0;   // переходим в нее
    x1:=x;
    x1[i1]:=0;

    fa1:=fa(x1);
    if fa1>=0 then
    begin
      ok1:=true;      // найдена допустимая точка
      //if fa1>0 then
        otn1:=fc(x1); // /(fa1+1);
        //  else otn1:=big;
      if otn1<otn then
      begin
        j1:=i1;
        otn:=otn1;
      end;
    end;
    T:=T+1;
    {if (not ok1) then} z:=z-1;
  until (z=0) or (ok1 and (r1>=R));

  x1:=x;
  x1[j1]:=0;
  next41:=ok1;
end;

procedure Toptim.TurnirSearch1;
var
  ll:word;
  ok:boolean;
  km:double;
begin
 T:=0;
 fopt:=verybig;
 for ll:=1 to L do
 begin
  start_point;

  f:=fc(x);
  repeat
    ok:=next41;

    if ok then
    begin
      x:=x1;
      inc(level);
      f:=fc(x);
    end;
  until (not ok) or (level=n);
  if f<fopt then
  begin
    //fc1(x); //оптимизационная модель для увеличения различия правил в классификаторе
    fopt:=f;
    xopt:=x;
  end;
 end;
  {   km:=(200/StrToFloat( logic1.Form1.Edit9.Text));
     if logic1.Form1.PageControl1.ActivePageIndex = 5 then
    begin
 logic1.Form1.ProgressBar2.Position:= logic1.Form1.ProgressBar2.Position+round(km);
    end;
      if logic1.Form1.PageControl1.ActivePageIndex = 6 then
    begin
 logic1.Form1.ProgressBar3.Position:= logic1.Form1.ProgressBar3.Position+round(km);
    end; }
end;

/////////////// альтернатива стабилизация
function Toptim.next41_stab:boolean;
var
  x2:mus1;
  ok1:boolean;
  z:word;  //кол-во точек для выбора
  n1,n2:word;
  i1,j1:word;
  otn,otn1:real;
  r1:word;
  f1,f2, fa1, fa2:real;
  ii: integer;
begin
  j1:=0;
  x2:=x;
 // z:=n-level;    // кол-во соседних точек след. уровня
    z:=75;    // кол-во соседних точек след. уровня
   // randomize();

   fa2:=round(classif.d22-fa(x));
     otn:=fa2;
  ok1:=false;
  r1:=0;
  repeat
  r1:=r1+1;
    n1:=random(z)+1;  // случайно выбираем одну из соседних точек
    n2:=0;
    i1:=0;
    repeat      //ищем эту точку
      inc(i1);
      if x2[i1]=0 then inc(n2);
    until n2=n1;
    x2[i1]:=1;   // переходим в нее
    x1:=x;
    x1[i1]:=1;

    f1:=fc(x1);
    fa1:=round(classif.d22-fa(x1));
    fa2:=round(classif.d22-fa(x));
    f2:=strtofloat(logic1.Form1.StringGrid1.Cells[classif.num_var+1,num111]);
    if {(round(f2)+10>=round(-f1)) and }(round(-f1)>=round(f2)) and (fa1<fa2) then
    begin
      ok1:=true;      // найдена допустимая точка
      //if fa1>0 then
      //   otn:=fc(x);
     //   otn1:=fc(x1); // /(fa1+1);
        //  otn:=fa2;
          otn1:=fa1;
        //  else otn1:=big;
      if otn1<otn then
      begin
        j1:=i1;
        otn:=otn1;
      end;
    end;
    T:=T+1;
    {if (not ok1) then} z:=z-1;
  until (z=0) or (ok1 and (r1>=R));

  x1:=x;
  x1[j1]:=1;
  next41_stab:=ok1;

  { classif.stepen:=0;
   for ii := 1 to n do       // фиксируем подкуб
    begin
    if x1[ii]=1 then
    begin

      inc(classif.stepen);    // уровень
    end;
   end;
    if  (classif.stepen)>15 then
    next41_stab:=false;   }
end;

procedure Toptim.TurnirSearch1_stab;
var
  ll:word;
  ok:boolean;
  km:double;
begin
 T:=0;
 fopt:=verybig;
 for ll:=1 to L do
 begin
  start_point;

  f:=fc(x);
  repeat
    ok:=next41_stab;

    if ok then
    begin
      x:=x1;
      inc(level);
      f:=fc(x);
    end;
  until (not ok) or (level=n);
  if f<fopt then
  begin
    fopt:=f;
    xopt:=x;
  end;
 end;
     km:=(200/StrToFloat( logic1.Form1.Edit9.Text));
     if logic1.Form1.PageControl1.ActivePageIndex = 5 then
    begin
 logic1.Form1.ProgressBar2.Position:= logic1.Form1.ProgressBar2.Position+round(km);
    end;
      if logic1.Form1.PageControl1.ActivePageIndex = 6 then
    begin
 logic1.Form1.ProgressBar3.Position:= logic1.Form1.ProgressBar3.Position+round(km);
    end;
end;

 /////////////// альтернатива стабилизация
function Toptim.next42_stab:boolean;
var
  x2:mus1;
  ok1:boolean;
  z:word;  //кол-во точек для выбора
  n1,n2:word;
  i1,j1:word;
  otn,otn1:real;
  r1:word;
  f1,f2, fa1, fa2:real;
  ii: integer;
begin
  j1:=0;
  x2:=x;
 // z:=n-level;    // кол-во соседних точек след. уровня
  z:=75;
  fa2:=classif.d22-fa(x);
  otn:=fa2;
  ok1:=false;
  r1:=0;
  repeat
    r1:=r1+1;
    n1:=random(z)+1;  // случайно выбираем одну из соседних точек
    n2:=0;
    i1:=0;
    repeat      //ищем эту точку
      inc(i1);
      if x2[i1]=0 then inc(n2);
    until n2=n1;
    x2[i1]:=1;   // переходим в нее
    x1:=x;
    x1[i1]:=1;

    f1:=fc(x1);
   fa1:=classif.d22-fa(x1);


    f2:=strtofloat(logic1.Form1.StringGrid2.Cells[classif.num_var+1,num111]);
  if {(round(f2)+10>=round(-f1)) and} (round(-f1)>=round(f2)) and (fa1<fa2) then
    begin
      ok1:=true;      // найдена допустимая точка
      //if fa1>0 then
       //otn:=fa2;
        otn1:=fa1; // /(fa1+1);
        //  else otn1:=big;
      if otn1<otn then
      begin
        j1:=i1;
        otn:=otn1;
      end;
    end;
    T:=T+1;
    {if (not ok1) then} z:=z-1;
  until (z=0) or (ok1 and (r1>=R));

  x1:=x;
  x1[j1]:=1;
  next42_stab:=ok1;

 { classif.stepen:=0;
   for ii := 1 to n do       // фиксируем подкуб
    begin
    if x1[ii]=1 then
    begin

      inc(classif.stepen);    // уровень
    end;
   end;
    if  (classif.stepen)>15 then
    next42_stab:=false;         }
end;

procedure Toptim.TurnirSearch2_stab;
var
  ll:word;
  ok:boolean;
  km:double;
begin
 T:=0;
 fopt:=verybig;
 for ll:=1 to L do
 begin
  start_point;

  f:=fc(x);
  repeat
    ok:=next42_stab;

    if ok then
    begin
      x:=x1;
      inc(level);
      f:=fc(x);
    end;
  until (not ok) or (level=n);
  if f<fopt then
  begin
    fopt:=f;
    xopt:=x;
  end;
 end;
     km:=(200/StrToFloat( logic1.Form1.Edit9.Text));
     if logic1.Form1.PageControl1.ActivePageIndex = 5 then
    begin
 logic1.Form1.ProgressBar2.Position:= logic1.Form1.ProgressBar2.Position+round(km);
    end;
      if logic1.Form1.PageControl1.ActivePageIndex = 6 then
    begin
 logic1.Form1.ProgressBar3.Position:= logic1.Form1.ProgressBar3.Position+round(km);
    end;
end;




end.
