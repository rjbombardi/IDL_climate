;####################################################################
;                          RODRIGO BOMBARDI
;
; Subroutine that generates the modeled variogram using the
; exponential model equation for a given distance array/matrix and the
; variogram parameters (range, nugget, and covariance of distance
; zero) 
;
;####################################################################
;============================ ATENTION ==============================
;       xvar  == distance variable (array/matrix)
;       par   == variogram parameters
;                par(0) --> range
;                par(1) --> nugget
;                par(2) --> covariance of distance zero
;	yvar  == modeled variogram
;	dpar  == analytical partial derivative of yvar
;                dpar(i,j) represents the derivative at the ith point
;                with respect to jth parameter. The derivatives are
;                computed only for array distances                     
;====================================================================
pro model_exp,xvar,par,yvar,dpar

ON_ERROR,2

yvar=xvar
cas=where(xvar lt 3*par(0),cas2)
yvar(*)=par(1)+par(2)
if(cas2 gt 0)then yvar(cas)=par(1)+par(2)*(1-exp(-3*xvar(cas)/par(0)))

res=size(xvar)
if(res(0) eq 1)then begin
dpar=fltarr(res(1),3)
if(cas2 gt 0)then dpar(cas,0)=-3*par(2)*xvar(cas)*exp(-3*xvar(cas)/par(0))/(par(0)^2)
dpar(*,1)=1.0
if(cas2 gt 0)then dpar(cas,2)=1.-exp(-3*xvar(cas)/par(0))
endif 

end
;====================================================================
;    END    END    END    END    END    END    END    END    END    
;====================================================================
