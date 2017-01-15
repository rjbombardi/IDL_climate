;####################################################################
;                          RODRIGO BOMBARDI
;
;	Subroutine that stipples a map
;
;####################################################################
;============================ ATENTION ==============================
;     Map MUST be a 2-d vector of 0 or 1. The number 1 denotes the
; areas that should be stippled. 
; ccolor MUST be a integer with the value of the color of the stipple
;       lat             == vector of latitudes
;       lon             == vector of longitudes
;====================================================================

pro stipple,map,ccolor,lat,lon

llat=n_elements(map(0,*))
llon=n_elements(map(*,0))

dist1=lon(1)-lon(0)
dist2=lat(1)-lat(0)

for j=0,llon-1 do begin
for i=0,llat-1 do begin

IF(map(j,i) EQ 1)THEN BEGIN
 vec1=indgen(10)*dist1/20+lon(j)-dist2/2
 vec2=indgen(10)*dist2/20+lat(i)-dist2/2
 vec3=reverse(vec1)

 oplot,vec1,vec2,color=ccolor
 oplot,vec3,vec2,color=ccolor
ENDIF

endfor
endfor

end
;============================================================================
;    END    END    END    END    END    END    END    END    END    END   END 
;============================================================================
