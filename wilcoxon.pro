;************************************************************************
;                      Created by Rodrigo J. Bombardi
;
; Program that calculates the statistical significance of paired
; forecast data using the Wilcoxon Signed-Sum Test
;
;************************************************************************
;------------------------------------------------------------------------
; Giving two arrays of forecast error the subroutine calculates the exact
; test of equality skill using the Wilcoxon Signed-Rank Test at 5%
; significance level.
;  array1  = An n-element single-precision floating-point vector.
;  array2  = An n-element single-precision floating-point vector.
;  rsig    = Wilcoxon Sgned_Rank significance test flag.
;            rsig = 1.0 -> reject null hypotheis
;            rsig = 0.0 -> Do not reject null hypotheis
;  pvalue  = p-value
;  missval = Value for missing value in case the test cannot be
;            calculated.
;------------------------------------------------------------------------
;------------------------------------------------------------------------
pro wilcoxon,array1,array2,rsig,pvalue,missval
;------------------------------------------------------------------------
;                         
;------------------------------------------------------------------------
tmp1=reform(array1)
tmp2=reform(array2)

id=where(tmp1(*)-tmp2(*) ne 0. and tmp1(*) ne missval and $
         tmp2(*) ne missval,mtot)

if(mtot gt 6)then begin

  tmp1=tmp1(id)
  tmp2=tmp2(id)

  original = fltarr(mtot)
  absolute = fltarr(mtot)
  ranked   = fltarr(mtot)
  signed   = fltarr(mtot)

  original(*) = tmp1(*)-tmp2(*)
  absolute(*) = abs(original(*))
  ranked(*) = sort(absolute(*))
  signed(*) = ranked(*)
  cas=where(original(*) lt absolute(*),cas2)
  if(cas2 gt 0)then signed(cas)=(-1.)*ranked(cas)

  sigmaw=sqrt(mtot*(mtot+1.)*(2.*mtot+1.)/24.)
  mt=mtot*(mtot+1.)/4.
  sig1=0.
  sig2=0.
  cas=where(signed(*) gt 0.,cas2)
  if(cas2 gt 0)then  sig1=total(signed(cas))
  cas=where(signed(*) lt 0.,cas2)
  if(cas2 gt 0)then sig2=total(signed(cas))
  sig=max([sig1,abs(sig2)])
  zscore=(sig-mt)/sigmaw
;    sigmaw=sqrt(mtot*(mtot+1.)*(2.*mtot+1.)/6.)
;    if(total(signed(*)) lt 0.)then mt=0.5
;    if(total(signed(*)) gt 0.)then mt=-0.5
;    zscore=(total(signed(*))+mt)/sigmaw
     pvalue=2.*gauss_pdf(-abs(zscore))
  if(mtot ge 10)then begin
    if(abs(zscore) gt 1.96)then rsig=1.
    if(abs(zscore) le 1.96)then rsig=0.    
  endif else begin
    if(mtot eq 6)then begin
      if(sig gt 21.)then rsig=1.
      if(sig le 21.)then rsig=0.
    endif
    if(mtot eq 7)then begin
      if(sig gt 24.)then rsig=1.
      if(sig le 24.)then rsig=0.
    endif
    if(mtot eq 8)then begin
      if(sig gt 30.)then rsig=1.
      if(sig le 30.)then rsig=0.
    endif
    if(mtot eq 9)then begin
      if(sig gt 35.)then rsig=1.
      if(sig le 35.)then rsig=0.
    endif
  endelse 

endif else begin
   rsig=missval
   pvalue=missval
endelse 

end
;============================================================================
;                   
;    END    END    END    END    END    END    END    END    END    END   END 
;
;============================================================================
