;####################################################################
;                          RODRIGO BOMBARDI
;
; Subroutine that generates the harmonic curve for a given time series,
; and the parameters (average, amplitude and phase)
;
;####################################################################
;============================ ATENTION ==============================
;       xvar  == time series
;       par   == parameters
;                par(0) --> average
;                par(1) --> amplitude
;                par(2) --> phase
;	yvar  == harmonic
;	dpar  == analytical partial derivative of yvar
;                dpar(i,j) represents the derivative at the ith point
;                with respect to jth parameter. The derivatives are
;                computed only for array distances                     
;====================================================================
pro harmon,xvar,par,yvar,dpar

ON_ERROR,2

pi=4.*ATAN(1.)
ncas=size(xvar)
time=findgen(ncas(1))+1.
yvar=xvar
yvar(*)=par(0)+par(1)*cos(2*pi*time(*)/float(ncas(1))-par(2))

if(ncas(0) eq 1)then begin
dpar=fltarr(ncas(1),3)
dpar(*,0)=1.0
dpar(*,1)=cos(2*pi*time(*)/float(ncas(1))-par(2))
dpar(*,2)=-par(1)*sin(2*pi*time(*)/float(ncas(1))-par(2))*(-1.)
endif


end
;====================================================================
;    END    END    END    END    END    END    END    END    END    
;====================================================================

