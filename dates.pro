;####################################################################
;                          RODRIGO BOMBARDI
;
;	Subroutine that generates arrays of hours, days, months,
; and years for hourly data
;
;####################################################################
;============================ ATENTION ==============================
;       The dataset MUST start at hour 00 or otherwise the dataset
; must have daily resolution (dh = 24)
;       Incomplete date arrays are filled with 0 (zero)
;       dh              == hourly interval. Examples:
;                          dh=1  --> One record each hour
;                          dh=3  --> One record every 3 hours
;                          dh=24 --> One record a day (MAXIMUM)
;       day0            == first day of the dataset
;       month0          == first month of the dataset
;       year0           == first year of the dataset
;	mtot		== total number of data
;	hour            == vector with hourly data
;	day             == vector with daily data
;	month           == vector with monthly data
;	year            == vector with yearly data
;====================================================================
pro dates,dh,mtot,day0,month0,year0,hour,day,month,year

;---------------------------------------------------------------------
; Generating hourly array
;---------------------------------------------------------------------
tot=long(24/dh)
hh=indgen(tot)*dh+0
dtot=tot-1
mtot=long(mtot)
hour=intarr(mtot)
if(mtot mod tot eq 0)then fin=1
if(mtot mod tot ne 0)then fin=tot
for tt=0L,mtot-fin,tot do hour(tt:tt+dtot)=hh(*)
;---- Correcting for incomplete datasets
beg=mtot mod tot
if(beg gt 0)then hour(mtot-beg:mtot-1)=hh(0:beg-1)
;---------------------------------------------------------------------
; Generating daily, monthly, and yearly arrays
;---------------------------------------------------------------------
dt=day0
mt=month0
yt=year0
;---- Checking for loop years and defyning monthly days
if((yt mod 4 eq 0 and yt mod 100 ne 0) or (yt mod 4 eq 0 and $
  yt mod 400 eq 0))then begin
  mm=[31,29,31,30,31,30,31,31,30,31,30,31]
endif else begin
  mm=[31,28,31,30,31,30,31,31,30,31,30,31]
endelse

day=intarr(mtot)
month=intarr(mtot)
year=intarr(mtot)
for tt=0L,mtot-fin,tot do begin
day(tt:tt+dtot)=dt
month(tt:tt+dtot)=mt
year(tt:tt+dtot)=yt
dt=dt+1
if(dt gt mm(mt-1))then begin ;---- Checking for month changes
  dt=1
  mt=mt+1
  if(mt gt 12)then begin     ;---- Checking for year changes
    mt=1
    yt=yt+1
;---- Checking for loop years and defyning monthly days again
    if((yt mod 4 eq 0 and yt mod 100 ne 0) or (yt mod 4 eq 0 and $
    yt mod 400 eq 0))then begin
    mm=[31,29,31,30,31,30,31,31,30,31,30,31]
    endif else begin
    mm=[31,28,31,30,31,30,31,31,30,31,30,31]
    endelse 
  endif  
endif  
endfor
end
;============================================================================
;                   
;    END    END    END    END    END    END    END    END    END    END   END 
;
;============================================================================

