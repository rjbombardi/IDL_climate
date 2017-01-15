;************************************************************************
;                      Created by Rodrigo Bombardi
;
;              Based on the paper from: 
;Hodges KI (1996) Spherical Nonparametric Estimators Applied to the
;UGAMP Model Integration for AMIP. Monthly Weather Review 124:
;2914-2932.
;
; Program that computes spherical kernel estimations for 2D dataset
;
; IMPORTANT: As it is the code should only be applied to INDEPENDENT
; tracks such as the calculation of cyclogenesis or cyclolisis. This
; technique should not be applied to the full tracks of a single event
; since those tracks are dependent in time. Dr. Hodges has developed
; techniques to calculate kernel estimates for cases when there is
; time dependency.
;
;************************************************************************
;------------------------------------------------------------------------
;                           Point patterns options
;------------------------------------------------------------------------
;---- kerntype --> Kernel type
; 0 - Power
; 1 - Quadratic
; 2 - Biweight

;---- data dimension
; nxp - number of points in the x axis
; nyp - number of points in the y axis

;---- Band width for Kernel estimates
; bandwx - Band width on x axis
; bandwy - Band width on y axis

;---- Coordinates of the point of interest
; x0 - Longitudinal position of the point of interest
; y0 - Latitudinal position of the point of interest

;----Coordinates of the whole domain
; dx - Vector with longitudinal coordinates with regular increments
; dy - Vector with latitudinal coordinates with regular increments

;----Printing kernel coordinates
; flag1=1 - On
; flag1=0 - Off
;------------------------------------------------------------------------
pro skernel,kerntype,nxp,nyp,bandw,x0,y0,vlon,vlat,wfunc,flag1
;------------------------------------------------------------------------
;                         Computing Kernel estimates
;------------------------------------------------------------------------
pi=4*atan(1.)
fac=pi/180.
cn_tilt=1.+1./bandw
wfunc=fltarr(nxp,nyp)
;---- Avoiding boundary issues
dx=vlon
dy=vlat
id=where(dx gt 180,id2)
if(id2 gt 0)then dx(id)=dx(id)-360
if(abs(abs(x0)-180) lt abs(x0))then begin
id=where(dx lt 0,id2)
if(id2 gt 0)then dx(id)=dx(id)+360
if(x0 lt 0)then x0=x0+360
endif 
;---- Generating coordinate matrix
lat=fltarr(nxp,nyp)
for jt=0,nxp-1 do lat(jt,*)=dy(*)
lon=fltarr(nxp,nyp)
for it=0,nyp-1 do lon(*,it)=dx(*)
;---- Computing matrix distance
angle=fltarr(nxp,nyp)
angle(*,*)=sqrt((lon(*,*)-x0(0))^2+(lat(*,*)-y0(0))^2)
dist=cos(angle*fac)
;---- Computing spherical kernel
m=1.
id=where(dist ge 1./cn_tilt)
if(kerntype eq 0)then wfunc(id)=((m+1)*cn_tilt*(cn_tilt*dist(id)-1)^m)/(2*pi*(cn_tilt-1)^(m+1))
if(kerntype eq 1)then wfunc(id)=(3*cn_tilt*((cn_tilt*dist(id))^2-1))/(2*pi*(cn_tilt+2)*(cn_tilt-1)^2)
if(kerntype eq 2)then wfunc(id)=(15*cn_tilt*((cn_tilt*dist(id))^2-1)^2)/(2*pi*(3*cn_tilt^2+9*cn_tilt+8)*(cn_tilt-1)^3)
;---- Printing kernel coordinates
if(flag1 eq 1)then print,"Spherical Kernel computed for point lat: ",y0," lon: ",x0
end
;============================================================================
;                   
;    END    END    END    END    END    END    END    END    END    END   END 
;
;============================================================================







