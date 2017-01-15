;************************************************************************
;                      Created by Rodrigo J. Bombardi
;
; Program that calculates the False Discovered Rate used to estimate
; the statistical significance of spatial coherent p-values as
; published in Wilks (2006,2016).
; 
; WILKS, D. S. On "Field Significance" and the False Discovery Rate. Journal of Applied Meteorology and Climatology,i
; v. 45, n. 9, p. 1181-1189, set. 2006.
;
; WILKS, D. S. "The stippling shows statistically significant gridpoints": How Research Results are Routinely Overstated
; and Over-interpreted, and What to Do About It. Bulletin of the American Meteorological Society, p. BAMS-D-15-00267.1, 9 mar. 2016. 
;
; tcut -  alpha: threshold of significane e.g. 0.05 for 5% level
; array1 - array of z-score values
; array2 - array with FDR test values: 0 = not significan; 1 =
;          significant
; missval - missing values
;
;************************************************************************
;------------------------------------------------------------------------
;                           Point patterns options
;------------------------------------------------------------------------
;------------------------------------------------------------------------
pro FDRzscore,tcut,array1,array2,missval
;------------------------------------------------------------------------
;                         
;------------------------------------------------------------------------
mlon=n_elements(array1(*,0))
mlat=n_elements(array1(0,*))
array2=fltarr(mlon,mlat)
pvalues=fltarr(long(mlon)*long(mlat))

tt=0L
for it=0L,mlat-1 do begin
for jt=0L,mlon-1 do begin
pvalues(tt)=array1(jt,it)
tt=tt+1
endfor
endfor

mtot=n_elements(pvalues)
id=where(pvalues(*) ne missval,mtot2)

tmp1=pvalues(id)
tmp2=fltarr(mtot2)
tmp2(*)=0.
 
ranked   = lon64arr(mtot2)
ranked(*) = sort(tmp1(*))

thres=fltarr(mtot2)
for tt=0L,mtot2-1 do thres(tt)=(tt+1)*tcut/float(mtot2)

cas=where(tmp1(ranked(*)) lt thres(*),cas2)
if(cas2 gt 0)then tmp2(ranked(0:cas(cas2-1)))=1.0

pvalues(*)=0.
pvalues(id)=tmp2(*)

jt=0L
it=0L
for tt=0L,mtot-1 do begin
array2(jt,it)=pvalues(tt)
jt=jt+1
if(jt eq mlon)then begin
jt=0L
it=it+1
endif 
endfor


end
;============================================================================
;                   
;    END    END    END    END    END    END    END    END    END    END   END 
;
;============================================================================
