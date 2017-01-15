;============================================================================
;      Code wirtten by Robson Negron and adapted by Rodrigo J. Bombardi
;============================================================================
function mks,x,undef=undef

;The non parametric mann-kendall (mk) statistics to determine if there
;is (or not) a signifcant trend . The slope is calculated
;by using the Sen's method(s). S is robust and less affected by
;outliers (Sen p.k. 1968, ASAJ).
;
;ex1. sl=mkstrend(x,undef=-999.). x: ts. ex: x=[0.5, 0.1, 0.2, 0.1, 0.3], (dt=1)
;                                 no slope = -999.
;
;20070225  Created by RNJ @ Georgia Tech
;20070307  Paola Arias @ Georgia Tech completed Vn (Eq. 2.6  Sen P.K. 1968, ASAJ).
;20080917  RNJ @ Tulane University. The trend and the p-val (two-sides) on your screen.
;
; This software is provided "as-is", without any express or
; implied warranty. The author WILL NOT BE
; resposable for any damage arising from its use.
;
; If you find bugs and have the solutions please contac me: rjuarez@tulane.edu


If Total(Finite(x,/nan)) Eq 0 Then Begin
  x=Float(x)
  nx=N_Elements(x)
  nx1=nx-1.
  n=long(nx*(nx-1)/2.)  ; The number of elements in d
  d=FltArr(n)
  m=long(0)

  For i=0,nx1-1 Do Begin
    For j=i+1,nx-1 Do Begin
    d(m)=x(j)-x(i)
    m=m+1
    Endfor
  Endfor

  For i=0L,n-1 Do Begin
    If d(i) LT 0. Then d(i)=-1.
    If d(i) EQ 0. Then d(i)= 0.
    If d(i) GT 0. Then d(i)= 1.
  EndFor

  s=total(d)

  U=x(uniq(x(sort(x))))
  Corr=0.       ;Correction for tied observations (equal value)

  For y=0,N_Elements(U)-1 Do Begin
    find=Where(x eq U(y))
    uj=N_Elements(find)
    Corr=Corr+uj*(uj-1)*(2*uj+5)
    if(abs(uj) gt 3000)then print,corr,uj
  EndFor

  Vs=(nx*(nx-1.)*(2*nx+5.)-Corr)/18.   ;For long series it is necessary to use the whole eq. 2.6 (Corr) (Sen p.k. 1968, ASAJ)

  If s GT 0. Then z=(s-1)/sqrt(Vs)
  If s LT 0. Then z=(s+1)/sqrt(Vs)
  If s EQ 0. Then z=0.

  ;nor=gauss_cvf(0.025)  ;nor=1.96;  ;Prob at 95% (two-side)
  ;nor=gauss_cvf(0.04)

  ;The slope

  Sn=fltarr(n)
  m=long(0)

  For i=0,nx1-1 Do Begin
    For j=i+1,nx-1 Do Begin
        Sn(m)=(x(i)-x(j))/(i-j)
        m=m+1
    EndFor
  EndFor

  Snsorted=Sn(sort(Sn))
  m=long(n/2.)

  pval=2*(1.-GAUSS_PDF(abs(z)))  ; (two-side)
  ;If abs(z) LT nor Then Begin
  ;  slope=undef
  ;Endif Else Begin
     If 2*m   Eq n Then slope=0.5*(Snsorted(m)+Snsorted(m+1))
     If 2*m+1 Eq n Then slope=Snsorted(m+1)
  ;EndElse
Endif Else Begin
   Print, 'There are missing values'
   slope=undef

EndElse
mksres=[slope, pval]
Return, mksres

End
