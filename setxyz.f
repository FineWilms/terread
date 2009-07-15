      subroutine setxyz
      parameter (ntang=2)   ! ntang=0 for tang. vectors from rancic et al.
c                           ! ntang=1 for tang. vectors by finite diffs
c                           ! ntang=2 for map factors by finite diffs too
c     schmidt included
c     *** to fix vecpanel & getting i & j from x,y,z; outfile; veg-files
c     sets up x, y, z on sphere and unit u,v vectors
c     note that x,y,z have been normalized by rearth, the radius of the earth
c     suffix 6 denotes hex (6)
      include 'newmpar.h'
      include 'dates.h'   ! rearth
      include 'map.h'
      include 'parm.h'
      include 'xyzinfo.h'  ! x,y,z,rlat,rlong,wts
      include 'vecsuv.h'   ! vecsuv info
      include 'indices.h' ! in,is,iw,ie,inn,iss,iww,iee
      include 'bigxy4.h' ! common/bigxy4/xx4(iquad,iquad),yy4(iquad,iquad)
c     common/work2/em4(iquad,iquad),ax4(4*il,4*il),ay4(4*il,4*il),
c    .     az4(4*il,4*il),dum2(18*il*jl -(iquad)*(iquad) - 3*16*il*il)
      common/work3/inw(ifull),isw(ifull),ies(ifull),iws(ifull)  ! just for bdys
     .             ,dum3(4*ijk-4*ifull)
      common/work2/em4(iquad,iquad)     ! to agree with call jimcc
     .    ,ax4(iquad,iquad),ay4(iquad,iquad),az4(iquad,iquad)
     .    ,axx(ifull),ayy(ifull),azz(ifull)
     .    ,bxx(ifull),byy(ifull),bzz(ifull)
c    .    ,inw(ifull),isw(ifull),ies(ifull),iws(ifull)  ! just for panel bdys
     .    ,dum2(12*il*jl -4*(iquad)*(iquad) )
      real rotpole(3,3)
!     dimension npann(0:13),npane(0:13),npanw(0:13),npans(0:13)  ! in indices.h
      dimension npan6n(0:5),npan6e(0:5),npan6w(0:5),npan6s(0:5)
!                  0  1   2   3   4   5   6   7   8   9  10  11  12  13
      data npann/  1, 2,107,  4,106,  6,  7,109,  9,112, 11, 12,102,101/
      data npane/103, 3,  4,105,  5,110,108,  8, 10, 11,100,113, 13,  0/
      data npanw/13,113,112,  1,  2,  4,104,102,  7,107,  8,  9,109, 12/
      data npans/110, 0,  1,100,  3,103,  5,  6,106,  8,105, 10, 11,111/
      data npan6n/1,103,3,105,5,101/,npan6e/102,2,104,4,100,0/
      data npan6w/5,105,1,101,3,103/,npan6s/104,0,100,2,102,4/
c     character*80 chars
      data ndiag/0/
      data pi/3.1415926536/
      ind(i,j,n)=i+(j-1)*il+n*il*il  ! *** for n=0,npanels
c     When using the ifull notation: in, ie, iw and is give the
c     indices for the n, e, w, s neighbours respectively
c     a, b denote unit vectors in the direction of x, y (e & n) respectively
      rearth=6.371220 e6   ! goes into common/dates
      schm13=1.            ! only used for conf-octagon
      idjd=id+il*(jd-1)
      do iq=1,ifull
       in(iq)=iq+il
       is(iq)=iq-il
       ie(iq)=iq+1
       iw(iq)=iq-1
      enddo   ! iq loop

      if(npanels.eq.5)then
        do n=0,npanels
         npann(n)=npan6n(n)
         npane(n)=npan6e(n)
         npanw(n)=npan6w(n)
         npans(n)=npan6s(n)
        enddo
      endif    ! (npanels.eq.5)

      do n=0,npanels
c     print *,'ina il/2,n ',in(ind(il/2,il,n)),n
      if(npann(n).lt.100)then
        do ii=1,il
         in(ind(ii,il,n))=ind(ii,1,npann(n))
        enddo    ! ii loop
      else
        do ii=1,il
         in(ind(ii,il,n))=ind(1,il+1-ii,npann(n)-100)
        enddo    ! ii loop
      endif      ! (npann(n).lt.100)
c     print *,'inb il/2,n ',in(ind(il/2,il,n)),n
c     print *,'iea il/2,n ',ie(ind(il,il/2,n)),n
      if(npane(n).lt.100)then
        do ii=1,il
         ie(ind(il,ii,n))=ind(1,ii,npane(n))
        enddo    ! ii loop
      else
        do ii=1,il
         ie(ind(il,ii,n))=ind(il+1-ii,1,npane(n)-100)
        enddo    ! ii loop
      endif      ! (npane(n).lt.100)
c     print *,'ieb il/2,n ',ie(ind(il,il/2,n)),n
c     print *,'iwa il/2,n ',iw(ind(1,il/2,n)),n
      if(npanw(n).lt.100)then
        do ii=1,il
         iw(ind(1,ii,n))=ind(il,ii,npanw(n))
        enddo    ! ii loop
      else
        do ii=1,il
         iw(ind(1,ii,n))=ind(il+1-ii,il,npanw(n)-100)
        enddo    ! ii loop
      endif      ! (npanw(n).lt.100)
c     print *,'iwb il/2,n ',iw(ind(1,il/2,n)),n
c     print *,'isa il/2,n ',is(ind(il/2,1,n)),n
      if(npans(n).lt.100)then
        do ii=1,il
         is(ind(ii,1,n))=ind(ii,il,npans(n))
        enddo    ! ii loop
      else
        do ii=1,il
         is(ind(ii,1,n))=ind(il,il+1-ii,npans(n)-100)
        enddo    ! ii loop
      endif      ! (npans(n).lt.100)
c     print *,'isb il/2,n ',is(ind(il/2,1,n)),n
      enddo      ! n loop

      do iq=1,ifull
       inn(iq)=in(in(iq))
       iss(iq)=is(is(iq))
       iee(iq)=ie(ie(iq))
       iww(iq)=iw(iw(iq))
       ine(iq)=in(ie(iq))
       ise(iq)=is(ie(iq))
       ien(iq)=ie(in(iq))
       iwn(iq)=iw(in(iq))
       iwu(iq)=iw(iq)
       isv(iq)=is(iq)
       iwu2(iq)=iw(iq)    ! N.B. use for unstaggered u,v in hordifg
       isv2(iq)=is(iq)    ! N.B. use for unstaggered u,v in hordifg
       ieu2(iq)=ie(iq)    ! N.B. use for unstaggered u,v in hordifg
       inv2(iq)=in(iq)    ! N.B. use for unstaggered u,v in hordifg
       ieu(iq)=ie(iq)     ! N.B. use for staguv3
       inv(iq)=in(iq)     ! N.B. use for staguv3
!      following are extras not needed in model, just here for bdy values
       inw(iq)=in(iw(iq)) ! in temporary arrays
       isw(iq)=is(iw(iq)) ! in temporary arrays
       ies(iq)=ie(is(iq)) ! in temporary arrays
       iws(iq)=iw(is(iq)) ! in temporary arrays
      enddo    ! iq loop

      do n=0,npanels
c      following treats unusual panel boundaries
c      print *,'ina il/2,n ',in(ind(il/2,il,n)),n
       if(npann(n).ge.100)then
        do i=1,il
         iq=ind(i,il,n)
         inn(iq)=ie(in(iq))
         ien(iq)=is(in(iq))
         iwn(iq)=in(in(iq))
         inv2(iq)=in(iq) - ifull   ! converts 2D v array into u array
         inv(iq)=in(iq) - ijk      ! converts 3D v array into u array
        enddo  ! i loop
      endif      ! (npann(n).ge.100)
c     print *,'inb il/2,n ',in(ind(il/2,il,n)),n
c     print *,'iea il/2,n ',ie(ind(il,il/2,n)),n
      if(npane(n).ge.100)then
        do j=1,il
         iq=ind(il,j,n)
         iee(iq)=in(ie(iq))
         ine(iq)=iw(ie(iq))
         ise(iq)=ie(ie(iq))
         ieu2(iq)=ie(iq) + ifull   ! converts 2D u array into v array
         ieu(iq)=ie(iq) + ijk      ! converts 3D u array into v array
        enddo   ! j loop
      endif      ! (npane(n).ge.100)
c     print *,'ieb il/2,n ',ie(ind(il,il/2,n)),n
c     print *,'iwa il/2,n ',iw(ind(1,il/2,n)),n
      if(npanw(n).ge.100)then
        do j=1,il
         iq=ind(1,j,n)
         iww(iq)=is(iw(iq))
         inw(iq)=iw(iw(iq)) ! in temporary arrays
         isw(iq)=ie(iw(iq)) ! in temporary arrays
         iwu2(iq)=iw(iq) + ifull   ! converts 2D u array into v array
         iwu(iq)=iw(iq) + ijk      ! converts 3D u array into v array
        enddo   ! j loop
      endif      ! (npanw(n).ge.100)
c     print *,'iwb il/2,n ',iw(ind(1,il/2,n)),n
c     print *,'isa il/2,n ',is(ind(il/2,1,n)),n
      if(npans(n).ge.100)then
        do i=1,il
         iq=ind(i,1,n)
         iss(iq)=iw(is(iq))
         ies(iq)=is(is(iq)) ! in temporary arrays
         iws(iq)=in(is(iq)) ! in temporary arrays
         isv2(iq)=is(iq) - ifull   ! converts 2D v array into u array
         isv(iq)=is(iq) - ijk      ! converts 3D v array into u array
        enddo   ! i loop
      endif      ! (npans(n).ge.100)
c     print *,'isb il/2,n ',is(ind(il/2,1,n)),n
      enddo      ! n loop

c     print *,'lsw a  ',lsw
c     print *,'lnw a  ',lnw
c     print *,'lws a  ',lws
c     print *,'les a  ',les
c     print *,'leen a  ',leen
c     print *,'lenn a  ',lenn
c     print *,'lwwn a  ',lwwn
c     print *,'lwnn a  ',lwnn
c     print *,'lsee a  ',lsee
c     print *,'lsse a  ',lsse
c     print *,'lnee a  ',lnee
c     print *,'lnne a  ',lnne
c     print *,'lsww a  ',lsww
c     print *,'lssw a  ',lssw
c     print *,'lnww a  ',lnww
c     print *,'lnnw a  ',lnnw
c     print *,'lwws a  ',lwws
c     print *,'lwss a  ',lwss
c     print *,'lees a  ',lees
c     print *,'less a  ',less
      do n=0,npanels
       lsw(n)=isw( ind( 1, 1,n) )
       lnw(n)=inw( ind( 1,il,n) )
       lws(n)=iws( ind( 1, 1,n) )
       les(n)=ies( ind(il, 1,n) )
       leen(n)=iee(in( ind(il,il,n) ))
       lenn(n)=ien(in( ind(il,il,n) ))
       lwnn(n)=iwn(in( ind( 1,il,n) ))
       lsee(n)=ise(ie( ind(il, 1,n) ))
       lnee(n)=ine(ie( ind(il,il,n) ))
       lnne(n)=inn(ie( ind(il,il,n) ))
       lsww(n)=isw(iw( ind( 1, 1,n) ))
       lssw(n)=iss(iw( ind( 1, 1,n) ))
       lnww(n)=inw(iw( ind( 1,il,n) ))
       lwws(n)=iww(is( ind( 1, 1,n) ))
       lwss(n)=iws(is( ind( 1, 1,n) ))
       less(n)=ies(is( ind(il, 1,n) ))
       lwwn(n)=iww(in( ind( 1,il,n) ))
       lsse(n)=iss(ie( ind(il, 1,n) ))
       lnnw(n)=inn(iw( ind( 1,il,n) ))
       lees(n)=iee(is( ind(il, 1,n) ))
       if(npann(n).ge.100)then
         leen(n)=iss(in( ind(il,il,n) ))
         lenn(n)=ise(in( ind(il,il,n) ))
         lwnn(n)=ine(in( ind( 1,il,n) ))
         lwwn(n)=inn(in( ind( 1,il,n) ))
       endif      ! (npann(n).ge.100)
       if(npane(n).ge.100)then
         lsee(n)=ien(ie( ind(il, 1,n) ))
         lnee(n)=iwn(ie( ind(il,il,n) ))
         lnne(n)=iww(ie( ind(il,il,n) ))
         lsse(n)=iee(ie( ind(il, 1,n) ))
       endif      ! (npane(n).ge.100)
       if(npanw(n).ge.100)then
         lsww(n)=ies(iw( ind( 1, 1,n) ))
         lssw(n)=iee(iw( ind( 1, 1,n) ))
         lnww(n)=iws(iw( ind( 1,il,n) ))
         lnnw(n)=iww(iw( ind( 1,il,n) ))
       endif      ! (npanw(n).ge.100)
       if(npans(n).ge.100)then
         lwws(n)=inn(is( ind( 1, 1,n) ))
         lwss(n)=inw(is( ind( 1, 1,n) ))
         less(n)=isw(is( ind(il, 1,n) ))
         lees(n)=iss(is( ind(il, 1,n) ))
       endif      ! (npans(n).ge.100)
      enddo       ! n loop
c     print *,'lsw b  ',lsw
c     print *,'lnw b  ',lnw
c     print *,'lws b  ',lws
c     print *,'les b  ',les
c     print *,'leen b  ',leen
c     print *,'lenn b  ',lenn
c     print *,'lwwn b  ',lwwn
c     print *,'lwnn b  ',lwnn
c     print *,'lsee b  ',lsee
c     print *,'lsse b  ',lsse
c     print *,'lnee b  ',lnee
c     print *,'lnne b  ',lnne
c     print *,'lsww b  ',lsww
c     print *,'lssw b  ',lssw
c     print *,'lnww b  ',lnww
c     print *,'lnnw b  ',lnnw
c     print *,'lwws b  ',lwws
c     print *,'lwss b  ',lwss
c     print *,'lees b  ',lees
c     print *,'less b  ',less

      if(ndiag.eq.3)then
        do n=0,npanels
         do j=1,il
          do i=1,il
           iq=ind(i,j,n)
           call indv(iq,i0,j0,n0)
           call indv(in(iq),in0,jn0,nn0)
           call indv(is(iq),is0,js0,ns0)
           call indv(ie(iq),ie0,je0,ne0)
           call indv(iw(iq),iw0,jw0,nw0)
           call indv(inn(iq),inn0,jnn0,nnn0)
           call indv(iss(iq),iss0,jss0,nss0)
           call indv(iee(iq),iee0,jee0,nee0)
           call indv(iww(iq),iww0,jww0,nww0)
           print 91,i0,j0,n0,
     .      in0,jn0,nn0,is0,js0,ns0,ie0,je0,ne0,iw0,jw0,nw0,
     .      inn0,jnn0,nnn0,iss0,jss0,nss0,iee0,jee0,nee0,iww0,jww0,nww0
91         format(9(i4,i2,i2))
          enddo   ! i loop
         enddo   ! j loop
        enddo    ! n loop
      endif      ! (ndiag.eq.3)

!----------------------------------------------------------------------------
c     calculate grid information using quadruple resolution grid
      if(npanels.eq.5)then
        call jimcc
        dsfact=4*il/(2.*pi)     ! con-cube
        ds=rearth/dsfact
        print *,'xx4 first & last ',xx4(1,1),xx4(iquad,iquad)
        print *,'xx4 (5,5),(7,7),(9,9) ',xx4(5,5),xx4(7,7),xx4(9,9)
        print *,'yy4 first & last ',yy4(1,1),yy4(iquad,iquad)
        print *,'yy4 (5,5),(7,7),(9,9) ',yy4(5,5),yy4(7,7),yy4(9,9)
        print *,'xx4, yy4 central',xx4(2*il+1,2*il+1),yy4(2*il+1,2*il+1)

c       extend em4 to uppermost i and j rows
        do j=1,4*il
         em4(iquad,j)=em4(1,j)
        enddo
        do i=1,4*il
         em4(i,iquad)=em4(i,1)
        enddo

        do j=1,il
         do i=1,il
          do n=0,5
c          average Purser em is pi/2
           em (i,il*n+j)=pi/(2.*em4(4*i-1,4*j-1))
           emu(i,il*n+j)=pi/(2.*em4(4*i+1,4*j-1))
           emv(i,il*n+j)=pi/(2.*em4(4*i-1,4*j+1))
          enddo ! n loop
          xx=xx4(4*i-1,4*j-1)
          yy=yy4(4*i-1,4*j-1)
          ax6(i,j,0)=ax4(4*i-1,4*j-1)
          ay6(i,j,0)=ay4(4*i-1,4*j-1)
          az6(i,j,0)=az4(4*i-1,4*j-1)

c         set up x0, y0, z0 coords on cube -1 to 1
c         to save space have equivalenced x,x0  etc
          x06(i,j,0)= 1.
          y06(i,j,0)=xx
          z06(i,j,0)=yy
          x06(i,j,3)=-1.
          z06(i,j,3)=-xx
          y06(i,j,3)=-yy

          x06(i,j,1)=-yy
          y06(i,j,1)=xx
          z06(i,j,1)= 1.
          y06(i,j,4)=-yy
          x06(i,j,4)=xx
          z06(i,j,4)=-1.

          x06(i,j,2)=-yy
          y06(i,j,2)= 1.
          z06(i,j,2)=-xx
          z06(i,j,5)=yy
          y06(i,j,5)=-1.
          x06(i,j,5)=xx
          if(i.eq.(il+1)/2.and.j.eq.(il+1)/2)print *,'xx,yy: ',xx,yy
         enddo  ! i loop
        enddo   ! j loop
        print *,'em (1,1) & (2,2) ',em(1,1),em(2,2)
        print *,'ax6 (1,1,0) & (2,2,0) ',ax6(1,1,0),ax6(2,2,0)
        print *,'ay6 (1,1,0) & (2,2,0) ',ay6(1,1,0),ay6(2,2,0)
        print *,'az6 (1,1,0) & (2,2,0) ',az6(1,1,0),az6(2,2,0)
        do iq=1,ifull
         call norm(x(iq),y(iq),z(iq),den) ! x, y, z are coords on sphere  -1 to 1
        enddo   ! iq loop
      endif     ! (npanels.eq.5)

      if(npanels.eq.13)then
        call jimco
        dsfact=(3.+3.*sqrt(2.))*il/(2.*pi)     ! con-octagon
        ds=rearth/dsfact
!       Silicon Graphics has trouble with (1,1) so set here
        xx4(1,1)=0.
        yy4(1,1)=0.
        em4(1,1)=1.
        print *,'xyz (1,1) ',xx4(1,1),yy4(1,1),em4(1,1)
        print *,'xyz (iquad,1) ',xx4(iquad,1),yy4(iquad,1),em4(iquad,1)
        print *,'xyz (1,iquad) ',xx4(1,iquad),yy4(1,iquad),em4(1,iquad)
        print *,'xyz (iquad,iquad) '
     .          ,xx4(iquad,iquad),yy4(iquad,iquad),em4(iquad,iquad)
        print *,'xyz (iquad/2,iquad/2) '
     .   ,xx4(iquad/2,iquad/2),yy4(iquad/2,iquad/2),em4(iquad/2,iquad/2)
        do j=il/2+1,il
         jj=4*j -2*il -1
         do i=(il+1)/2,il        ! NE corner of panel 2
          ii=4*i -2*il -1
          x6(i,j,2)=xx4(ii,jj)
          y6(i,j,2)=yy4(ii,jj)
          z6(i,j,2)=em4(ii,jj)
!         define SE corner of panel 2
          x6(i,il+1-j,2)=-x6(i,j,2)
          y6(i,il+1-j,2)= y6(i,j,2)
          z6(i,il+1-j,2)= z6(i,j,2)
         enddo  ! i loop
         do i=1,il               ! N half of panel 4
          ii=4*(i+il) -2*il -1
          x6(i,j,4)=xx4(ii,jj)
          y6(i,j,4)=yy4(ii,jj)
          z6(i,j,4)=em4(ii,jj)
!         define S half of panel 4
          x6(i,il+1-j,4)=-x6(i,j,4)
          y6(i,il+1-j,4)= y6(i,j,4)
          z6(i,il+1-j,4)= z6(i,j,4)
         enddo  ! i loop
        enddo   ! j loop
        do jx=1,il
         jj=4*(jx+il) -2*il -1
c        do iyy=1,jx             ! SW half of panel 6
c         iy=il+1-iyy
         do iy=jx,il             ! SW half of panel 6
          iyy=il+1-iy
          ii=4*(iyy+il) -2*il -1
          x6(jx,iy,6)=xx4(ii,jj)
          y6(jx,iy,6)=yy4(ii,jj)
          z6(jx,iy,6)=em4(ii,jj)
!         define other half of panel 6
          x6(iy,jx,6)= x6(jx,iy,6)
          y6(iy,jx,6)= y6(jx,iy,6)
          z6(iy,jx,6)=-z6(jx,iy,6)
         enddo  ! iyy loop
         do i=1,il/2             ! W half of panel 2
!         define W half of panel 2
          x6(i,jx,2)= x6(il+1-i,jx,2)
          y6(i,jx,2)=-y6(il+1-i,jx,2)
          z6(i,jx,2)= z6(il+1-i,jx,2)
         enddo  ! i loop
        enddo   ! jx loop
c                      nn=2
c                      print *,'x for panel ',nn
c                      do j=il,1,-1
c                       print '(i3,30f6.3)',j,(x6(i,j,nn),i=1,il)
c                      enddo
c                      print *,'y for panel ',nn
c                      do j=il,1,-1
c                       print '(i3,30f6.3)',j,(y6(i,j,nn),i=1,il)
c                      enddo
c                      print *,'z for panel ',nn
c                      do j=il,1,-1
c                       print '(i3,30f6.3)',j,(z6(i,j,nn),i=1,il)
c                      enddo
!       define remaining 11 panels
        do j=1,il
         do i=1,il
          x6(i,j,10)= y6(i,j,2)            ! C2
          y6(i,j,10)= x6(i,j,2)
          z6(i,j,10)=-z6(i,j,2)
          x6(i,j,3)= y6(i,j,6)             ! SE
          y6(i,j,3)=-x6(i,j,6)
          z6(i,j,3)= z6(i,j,6)
          x6(i,j,9)=-y6(i,j,6)             ! NW
          y6(i,j,9)= x6(i,j,6)
          z6(i,j,9)= z6(i,j,6)
          x6(i,j,13)=-x6(i,j,6)             ! SW
          y6(i,j,13)=-y6(i,j,6)
          z6(i,j,13)= z6(i,j,6)
          x6(i,j,1)= y6(il+1-j,i,4)       ! SC1
          y6(i,j,1)=-x6(il+1-j,i,4)
          z6(i,j,1)= z6(il+1-j,i,4)
          x6(i,j,7)=-y6(i,j,4)            ! NC1
          y6(i,j,7)= x6(i,j,4)
          z6(i,j,7)= z6(i,j,4)
          x6(i,j,12)=-x6(il+1-j,i,4)       ! WC1
          y6(i,j,12)=-y6(il+1-j,i,4)
          z6(i,j,12)= z6(il+1-j,i,4)
          x6(i,j,5)= x6(il+1-i,j,4)       ! EC2
          y6(i,j,5)= y6(il+1-i,j,4)
          z6(i,j,5)=-z6(il+1-i,j,4)
          x6(i,j,11)= x6(j,il+1-i,4)       ! WC2
          y6(i,j,11)=-y6(j,il+1-i,4)
          z6(i,j,11)=-z6(j,il+1-i,4)
          x6(i,j,8)=-y6(il+1-i,j,4)     ! =x6(il+1-i,j,7)       ! NC2
          y6(i,j,8)= x6(il+1-i,j,4)
          z6(i,j,8)=-z6(il+1-i,j,4)
          x6(i,j,0)= y6(j,i,4)          ! =x6(i,il+1-j,1)       ! SC2
          y6(i,j,0)=-x6(j,i,4)
          z6(i,j,0)=-z6(j,i,4)
         enddo  ! i loop
        enddo   ! j loop
!       for conformal octagon, save only xx4 and yy4
!           as absolute values and as if schmidt=.5
!           flip xx and yy (fix up later in jimco & above)
        schm13=.1
        alf=(1.-schm13**2)/(1.+schm13**2)
        do jj=1,iquad
         do ii=1,iquad
          temp      =abs(xx4(ii,jj))*schm13*(1.+alf)/(1.+alf*em4(ii,jj))
          xx4(ii,jj)=abs(yy4(ii,jj))*schm13*(1.+alf)/(1.+alf*em4(ii,jj))
          yy4(ii,jj)=temp
         enddo    ! ii loop
        enddo     ! jj loop
      endif       ! (npanels.eq.13)

      print *,'basic grid length ds =',ds
      if(schmidt.ne.1.)then
        alf=(1.-schmidt**2)/(1.+schmidt**2)
        print *,'doing schmidt with schmidt,alf: ',schmidt,alf
        do iq=1,ifull
         xin=x(iq)
         yin=y(iq)
         zin=z(iq)
         x(iq)=xin*schmidt*(1.+alf)/(1.+alf*zin)
         y(iq)=yin*schmidt*(1.+alf)/(1.+alf*zin)
         z(iq)=(alf+zin)/(1.+alf*zin)
         if(ntang.ne.2)em(iq,1)=em(iq,1)*schmidt*(1.+alf*zin)/(1.-alf)
         do n=0,npanels
          iqn=ind((il+1)/2,(il+1)/2,n)
c         iqn= (il+1)*(il/2)+n*il*il
          if(iq.eq.iqn)then
            print *,'After Schmidt at centre of face n:',n
            print '('' xin,yin,zin,x,y,z '',3f7.3,2x,3f7.3)',
     .                 xin,yin,zin,x(iq),y(iq),z(iq)
          endif
         enddo  ! n loop
        enddo   ! iq loop

        if(ntang.ne.2)then
          do iq=1,ifull
!          with schmidt must average em to get emu & emv
           emu(iq,1)=.5*(em(iq,1)+em(ie(iq),1))
           emv(iq,1)=.5*(em(iq,1)+em(in(iq),1))
          enddo   ! iq loop
        endif
      endif    !  (schmidt.ne.1.)

      if(ndiag.eq.2)call printp('x   ', x)
      if(ndiag.eq.2)call printp('y   ', y)
      if(ndiag.eq.2)call printp('z   ', z)

c     set up vectors in direction of u and v
      if(ntang.eq.0)then
        call vecpanel(ax6,ay6,az6) ! define x-vectors on panels 1:5 from panel 0
        call cross3(bx,by,bz, x,y,z, ax,ay,az)  ! define y-vectors
      else
        do iq=1,ifull
c        first guess tang vectors by finite differences
         ax(iq)=x(ie(iq))-x(iw(iq))
         ay(iq)=y(ie(iq))-y(iw(iq))
         az(iq)=z(ie(iq))-z(iw(iq))
         bx(iq)=x(in(iq))-x(is(iq))
         by(iq)=y(in(iq))-y(is(iq))
         bz(iq)=z(in(iq))-z(is(iq))
         if(iq.eq.idjd.or.iq.eq.in(idjd))then
           print *,'first guess values for ax,bx'
           print *,'iq,ax,ay,az',iq,ax(iq),ay(iq),az(iq)
           print *,'iq,bx,by,bz',iq,bx(iq),by(iq),bz(iq)
           print *,'iq,x,y,z   ',iq,x(iq),y(iq),z(iq)
           print *,'iq,x,y,z n ',iq,x(in(iq)),y(in(iq)),z(in(iq))
           print *,'iq,x,y,z e ',iq,x(ie(iq)),y(ie(iq)),z(ie(iq))
           print *,'iq,x,y,z w ',iq,x(iw(iq)),y(iw(iq)),z(iw(iq))
           print *,'iq,x,y,z s ',iq,x(is(iq)),y(is(iq)),z(is(iq))
         endif
        enddo   ! iq loop
c       form axx and bxx tangential to the sphere
        call cross3(axx,ayy,azz, bx,by,bz, x,y,z)
        call cross3(bxx,byy,bzz, x,y,z, ax,ay,az)
        do iq=1,ifull
c        if(iq.gt.0)print *,'b iq,axx,ayy,azz'
c    .                        ,iq,axx(iq),ayy(iq),azz(iq)
c        if(iq.gt.0)print *,'b iq,bxx,byy,bzz'
c    .                         ,iq,bxx(iq),byy(iq),bzz(iq)
         call norm(axx(iq),ayy(iq),azz(iq),den)
         call norm(bxx(iq),byy(iq),bzz(iq),den)
c        if(iq.eq.18)print *,'c iq,axx,ayy,azz'
c    .                         ,iq,axx(iq),ayy(iq),azz(iq)
c        if(iq.eq.18)print *,'c iq,bxx,byy,bzz'
c    .                         ,iq,bxx(iq),byy(iq),bzz(iq)
c        make sure they are perpendicular & normalize
         dot=axx(iq)*bxx(iq)+ayy(iq)*byy(iq)+azz(iq)*bzz(iq)
         eps=-dot/(1.+sqrt(1.-dot*dot))
         ax(iq)=axx(iq)+eps*bxx(iq)
         ay(iq)=ayy(iq)+eps*byy(iq)
         az(iq)=azz(iq)+eps*bzz(iq)
         bx(iq)=bxx(iq)+eps*axx(iq)
         by(iq)=byy(iq)+eps*ayy(iq)
         bz(iq)=bzz(iq)+eps*azz(iq)
c        if(iq.eq.18)print *,'dot,eps',dot,eps
c        if(iq.eq.18)print *,'d iq,ax,ay,az',iq,ax(iq),ay(iq),az(iq)
c        if(iq.eq.18)print *,'d iq,bx,by,bz',iq,bx(iq),by(iq),bz(iq)
         call norm(ax(iq),ay(iq),az(iq),den)
         call norm(bx(iq),by(iq),bz(iq),den)
        enddo   ! iq loop
        if(ntang.eq.2)then
          do iq=1,ifull
!          calculate inverse of emu & emv first
           dx2=(x(ie(iq))-x(iq))**2+(y(ie(iq))-y(iq))**2
     .                             +(z(ie(iq))-z(iq))**2
           emu(iq,1)=sqrt(dx2)*(1.+dx2/24.) *dsfact
           dy2=(x(in(iq))-x(iq))**2+(y(in(iq))-y(iq))**2
     .                             +(z(in(iq))-z(iq))**2
           emv(iq,1)=sqrt(dy2)*(1.+dy2/24.) *dsfact
          enddo   ! iq loop
          do iq=1,ifull   ! based on inverse values of emu & emv
           em(iq,1)=4./(emu(iwu2(iq),1)+emu(iq,1)+
     .                  emv(isv2(iq),1)+emv(iq,1))
c          experimental option follows - only tiniest difference for il=20
c          em(iq,1)=2./sqrt((emu(iwu2(iq),1)+emu(iq,1))*
c    .                  (emv(isv2(iq),1)+emv(iq,1)))
          enddo   ! iq loop
          do iq=1,ifull
           emu(iq,1)=1./emu(iq,1)
           emv(iq,1)=1./emv(iq,1)
          enddo   ! iq loop
        endif   ! (ntang.eq.2)
      endif     ! (ntang.eq.0)
      do iq=il-2,il
       print *,'iq,em,emu,emv',iq,em(iq,1),emu(iq,1),emv(iq,1)
      enddo   ! iq loop
      if(id.le.il.and.jd.le.jl)then
        iq=id+il*(jd-1)
        print *,'values at idjd',id,jd,iq
        print *,'iq,ax,ay,az',iq,ax(iq),ay(iq),az(iq)
        print *,'iq,bx,by,bz',iq,bx(iq),by(iq),bz(iq)
        iq=in(id+il*(jd-1))
        print *,'values at in(idjd)'
        print *,'iq,ax,ay,az',iq,ax(in(iq)),ay(in(iq)),az(in(iq))
        print *,'iq,bx,by,bz',iq,bx(in(iq)),by(in(iq)),bz(in(iq))
        print *,'values at ie(idjd)'
        print *,'iq,ax,ay,az',iq,ax(ie(iq)),ay(ie(iq)),az(ie(iq))
        print *,'iq,bx,by,bz',iq,bx(ie(iq)),by(ie(iq)),bz(ie(iq))
        print *,'values at iw(idjd)'
        print *,'iq,ax,ay,az',iq,ax(iw(iq)),ay(iw(iq)),az(iw(iq))
        print *,'iq,bx,by,bz',iq,bx(iw(iq)),by(iw(iq)),bz(iw(iq))
        print *,'values at is(idjd)'
        print *,'iq,ax,ay,az',iq,ax(is(iq)),ay(is(iq)),az(is(iq))
        print *,'iq,bx,by,bz',iq,bx(is(iq)),by(is(iq)),bz(is(iq))
      endif

c     calculate approx areas around each grid point
c     just used for error diagnostics
c     now use 1/(em**2) to cope with schmidt, rotated and ocatagon coordinates
      sumwts=0.
      do iq=1,ifull
       wts(iq)=1./em(iq,1)**2
       sumwts=sumwts+wts(iq)
c      cosa is dot product of unit vectors
c      *** only useful as diagnostic for gnew
       cosa(iq)=ax(iq)*bx(iq)+ay(iq)*by(iq)+az(iq)*bz(iq)
      enddo   ! iq loop
      if(ndiag.eq.2)then
c       call printp('dx  ',dx)
c       call printp('dy  ',dy)
        call printp('cosa',cosa)
      endif
      print *,'sumwts/ifull ',sumwts/ifull  ! ideally equals 4*pi ??

c     previously calculates approx areas around each grid point using modulus of
c     cross-products; used for error diagnostics
c     do j=1,il
c      do i=1,il
c       iq=ind(i,j,0)
c       wts(iq)=.5*(crossmod(iq,4*i-3,4*j+1,4*i+1,4*j+1)  ! nw,ne  with xx4,yy4
c    .             +crossmod(iq,4*i+1,4*j+1,4*i+1,4*j-3)  ! ne,se  with xx4,yy4
c    .             +crossmod(iq,4*i+1,4*j-3,4*i-3,4*j-3)  ! se,sw  with xx4,yy4
c    .             +crossmod(iq,4*i-3,4*j-3,4*i-3,4*j+1)) ! sw,nw  with xx4,yy4
c       sumwts=sumwts+wts(iq)
c       do n=1,5
c        wts(iq+n*il*il)=wts(iq)
c       enddo  ! n loop
c      enddo   ! i loop
c     enddo    ! j loop
c     print *,'sumwts ',sumwts  ! ideally equals 4*pi/6, 2.09440

      coslong=cos(rlong0*pi/180.)
      sinlong=sin(rlong0*pi/180.)
      coslat=cos(rlat0*pi/180.)
      sinlat=sin(rlat0*pi/180.)
      rotpole(1,1)=coslong*sinlat
      rotpole(1,2)=-sinlong
      rotpole(1,3)=coslong*coslat
      rotpole(2,1)=sinlong*sinlat
      rotpole(2,2)=coslong
      rotpole(2,3)=sinlong*coslat
      rotpole(3,1)=-coslat
      rotpole(3,2)=0.
      rotpole(3,3)=sinlat

      print *,'in setxyz rlong0,rlat0,schmidt ',rlong0,rlat0,schmidt
      do iq=1,ifull
c      scale wts so sum over globe is 1.
c      wts(iq)=wts(iq)/(6.*sumwts)  ! for old conf-cub defn
       wts(iq)=wts(iq)/sumwts
c      also provide latitudes and longitudes (-pi to pi)
       if(rlong0.eq.0..and.rlat0.eq.90.)then
         xx=x(iq)
         yy=y(iq)
         zz=z(iq)
       else
         xx=rotpole(1,1)*x(iq)+rotpole(1,2)*y(iq)+rotpole(1,3)*z(iq)
         yy=rotpole(2,1)*x(iq)+rotpole(2,2)*y(iq)+rotpole(2,3)*z(iq)
         zz=rotpole(3,1)*x(iq)+rotpole(3,2)*y(iq)+rotpole(3,3)*z(iq)
       endif
c      f(iq,1)=2. *2.*pi *(z(iq)/rdiv) /86400.
       rlat(iq)=asin(zz)
       f(iq,1)=2. *2.*pi *zz /86400.
       if(yy.ne.0..or.xx.ne.0.)then
         rlong(iq)=atan2(yy,xx)                       ! N.B. -pi to pi
         if(rlong(iq).lt.0.)rlong(iq)=rlong(iq)+2.*pi ! 0 to 2*pi  09-25-1997
       else
         rlong(iq)=0.    ! a default value for NP/SP
       endif
       if(iq.eq.idjd)print *,'iq,x,y,z,xx,yy,zz,rlong,rlat ',
     .                  iq,x(iq),y(iq),z(iq),xx,yy,zz,rlong(iq),rlat(iq)
      enddo   ! iq loop
      if(ndiag.eq.2)then
        do iq=1,ifull
         cosa(iq)=100.*wts(iq)
        enddo
        call printp('wts ',cosa)
        call printp('lat ',rlat)
        call printp('long',rlong)
      endif
      print *,'At centre of the faces:'
      do n=0,npanels
       iq=ind((il+1)/2,(il+1)/2,n)
       print '('' n,iq,x,y,z,long,lat,f '',i3,i5,3f7.3,2f8.2,f9.5)',n,
     .   iq,x(iq),y(iq),z(iq),rlong(iq)*180./pi,rlat(iq)*180./pi,f(iq,1)
      enddo
      print *,
     .     'On each panel map factors for (1,1),(1,2),(1,3),(2,2),(3,2)'
      do n=0,npanels
       iq11=ind(1,1,n)
       iq12=ind(1,2,n)
       iq13=ind(1,3,n)
       iq22=ind(2,2,n)
       iq32=ind(3,2,n)
       print '(i3,5f8.3)',n,
     .   em(iq11,1),em(iq12,1),em(iq13,1),em(iq22,1),em(iq32,1)
      enddo
      print *,'On each panel demu  demv for (1,1),(1,2),(1,3)'
      do n=0,npanels
       iq=ind(1,1,n)
       demu11=emu(iwu2(iq),1)-emu(iq,1)
       demv11=emv(isv2(iq),1)-emv(iq,1)
       iq=ind(2,1,n)
       demu21=emu(iwu2(iq),1)-emu(iq,1)
       demv21=emv(isv2(iq),1)-emv(iq,1)
       iq=ind(3,1,n)
       demu31=emu(iwu2(iq),1)-emu(iq,1)
       demv31=emv(isv2(iq),1)-emv(iq,1)
       print '(i3,6f8.3)',n,
     .   demu11,demv11,demu21,demv21,demu31,demv31
      enddo
      do iq=1,ifull   ! set up Coriolis
       dmdx(iq,1)=(em(ie(iq),1)-em(iq,1))/ds  ! ok: [2,il-1;2,jl]  u point
       dmdy(iq,1)=(em(in(iq),1)-em(iq,1))/ds  ! ok: [2,il;2,jl-1]  v point
       fu(iq,1)=(f(iq,1)+f(ie(iq),1))*.5
       fv(iq,1)=(f(iq,1)+f(in(iq),1))*.5
      enddo   ! iq loop
      do iq=1,ifull   ! average map factor derivatives needed for nxmap=1
c      may need more thought  $$$
       dmdx(iq,1)=abs(emu(iwu2(iq),1)-emu(iq,1))
     .           +abs(emv(isv2(iq),1)-emv(iq,1))
       dmdyu(iq,1)=(em(in(ie(iq)),1)-em(is(ie(iq)),1)+
     .              em(in(iq),1)-em(is(iq),1))/(4.*ds)
       dmdxv(iq,1)=(em(ie(in(iq)),1)-em(iw(in(iq)),1)+
     .              em(ie(iq),1)-em(iw(iq),1))/(4.*ds)
      enddo   ! iq loop
      print *,
     . 'On each panel abs(demu..demv) for (1,1),(1,2),(1,3),(2,2),(3,2)'
      do n=0,npanels
       iq11=ind(1,1,n)
       iq12=ind(1,2,n)
       iq13=ind(1,3,n)
       iq22=ind(2,2,n)
       iq32=ind(3,2,n)
       print '(i3,5f8.3)',n,
     .  dmdx(iq11,1),dmdx(iq12,1),dmdx(iq13,1),dmdx(iq22,1),dmdx(iq32,1)
      enddo

c     For calculating zonal and meridional wind components, use the
c     following information, where theta is the angle between the
c     (ax,ay,az) vector [along the xg axis] and the zonal-component-vector:
c     veczon = k x r, i.e. (-y,x,0)/sqrt(x**2 + y**2)
c     vecmer = r x veczon, i.e. (-xz,-yz,x**2 + y**2)/sqrt(x**2 + y**2)
c     costh is (veczon . a) = (-y*ax + x*ay)/sqrt(x**2 + y**2)
c     sinth is (vecmer . a) = [-xz*ax - yz*ay + (x**2 + y**2)*az]/sqrt
c      using (r . a)=0, sinth collapses to az/sqrt(x**2 + y**2)
c     With more effort than expected, it can be verified that
c     costh**2 + sinth**2 = 0, by again using r.a =0.

      return
      end
      subroutine indv(iq,i,j,n)
c     calculates simple i,j,n indices from supplied iq
      include 'newmpar.h'
      n=(iq-1)/(il*il)
      j=1+(iq-n*il*il-1)/il
      i=iq-(j-1)*il-n*il*il
      return
      end
      subroutine norm(a,b,c,den)
      den=sqrt(a**2+b**2+c**2)
      a=a/den
      b=b/den
      c=c/den
      return
      end
      subroutine vecpanel(ax6,ay6,az6)
c     define vectors on panels 1:5 from panel 0
      include 'newmpar.h'
      dimension ax6(il,il,0:5),ay6(il,il,0:5),az6(il,il,0:5)
      do j=1,il
       do i=1,il
        a1=ax6(i,j,0)
        a2=ay6(i,j,0)
        a3=az6(i,j,0)
        ax6(i,j,1)=-a3
        ay6(i,j,1)=a2
        az6(i,j,1)=a1
        ax6(i,j,2)=-a3
        ay6(i,j,2)=a1
        az6(i,j,2)=-a2
        ax6(i,j,3)=-a1
        ay6(i,j,3)=-a3
        az6(i,j,3)=-a2
        ax6(i,j,4)=a2
        ay6(i,j,4)=-a3
        az6(i,j,4)=-a1
        ax6(i,j,5)=a2
        ay6(i,j,5)=-a1
        az6(i,j,5)=a3
       enddo  ! i loop
      enddo   ! j loop
      return
      end

      subroutine printp(name,s6)
      include 'newmpar.h'
      character *4 name
      dimension s6(il,il,0:5)  ! no longer access s(ifull-1), s(ifull)
      dimension s1f(0:il+1,3*il),s2f(0:il+1,3*il)

c     s1 is Grenwich-NP section i.e.  0-1-3
c     s2 is Oz-SP section i.e.  2-4-5
      call strip2(s6,s6,s1f,s2f)
      print *, name,'  013'
        do j=3*il,1,-1
         print 9,j,(s1f(i,j),i=0,il+1)
        enddo
9        format(i3,1x,21f6.3)
      print *
      print *, name,'  245'
        do j=3*il,1,-1
         print 9,j,(s2f(i,j),i=0,il+1)
        enddo
      return
      end

      subroutine strip2(s,s6,s1,s2)
      include 'newmpar.h'
      include 'indices.h'
      dimension in6(il,il,0:5),is6(il,il,0:5),iw6(il,il,0:5)
     .         ,ie6(il,il,0:5)
      equivalence (in,in6),(is,is6),(iw,iw6),(ie,ie6)
      dimension s(ifull),s6(il,il,0:5)
c     N.B.  s & s6 are equivalenced via the call
c     dimension s1f(0:il+1,3*il),s2f(0:il+1,3*il)
      dimension s1(0:il+1,il,3),s2(0:il+1,il,3)  ! equiv to s1f, s2f via call
c     s1 is Grenwich-NP section i.e.  0-1-3
c     s2 is Oz-SP section i.e.  2-4-5
c     for gnewst, these are extended on the sides only (i=0 & il+1)
      do j=1,il
       do i=1,il
        s1(i,j,1)=s6(i,j,0)
        s1(i,j,2)=s6(i,j,1)
        s1(i,j,3)=s6(j,il+1-i,3)
        s2(i,j,1)=s6(j,il+1-i,2)
        s2(i,j,2)=s6(i,j,4)
        s2(i,j,3)=s6(i,j,5)
       enddo  ! i loop
       s1(0,j,1)=s(iw6(1,j,0))
c      print *,'j,iw6(1,j,0),s1(0,j,1) ',j,iw6(1,j,0),s1(0,j,1)
       s1(0,j,2)=s(iw6(1,j,1))
       s1(0,j,3)=s(in6(j,il,3))
       s2(0,j,1)=s(in6(j,il,2))
       s2(0,j,2)=s(iw6(1,j,4))
       s2(0,j,3)=s(iw6(1,j,5))
       s1(il+1,j,1)=s(ie6(il,j,0))
       s1(il+1,j,2)=s(ie6(il,j,1))
       s1(il+1,j,3)=s(is6(j,1,3))
       s2(il+1,j,1)=s(is6(j,1,2))
       s2(il+1,j,2)=s(ie6(il,j,4))
       s2(il+1,j,3)=s(ie6(il,j,5))
      enddo   ! j loop
      return
      end

      subroutine cross3(c1,c2,c3,a1,a2,a3,b1,b2,b3)
c     calculate vector components of c = a x b
c     where each RHS component represents 3 vector components
c     this one need not have contiguous memory in common
      include 'newmpar.h'
      dimension a1(ifull),a2(ifull),a3(ifull)
      dimension b1(ifull),b2(ifull),b3(ifull)
      dimension c1(ifull),c2(ifull),c3(ifull)
      do i=1,ifull
       c1(i)=a2(i)*b3(i)-b2(i)*a3(i)
       c2(i)=a3(i)*b1(i)-b3(i)*a1(i)
       c3(i)=a1(i)*b2(i)-b1(i)*a2(i)
      enddo
      return
      end
      function crossmod(iq,i4a,j4a,i4b,j4b)  ! version for gnewst
      include 'newmpar.h'
      include 'bigxy4.h' ! common/bigxy4/xx4(iquad,iquad),yy4(iquad,iquad)
      include 'xyzinfo.h'  ! x,y,z,rlat,rlong,wts
      y4a=xx4(i4a,j4a)
      z4a=yy4(i4a,j4a)
      x4a=1.
      y4b=xx4(i4b,j4b)
      z4b=yy4(i4b,j4b)
      x4b=1.
c     if(iq.eq.1.or.iq.eq.il*il)then
c      print *,'iq,x,y,z ',iq,x(iq),y(iq),z(iq)
c      print *,'i4a,j4a,y4a,y4a ',i4a,j4a,y4a,y4a
c      print *,'i4b,j4b,z4b,z4b ',i4b,j4b,z4b,z4b
c     endif
      call norm(x4a,y4a,z4a,den) ! converts xx4, yy4 to coords on sphere
      call norm(x4b,y4b,z4b,den) ! converts xx4, yy4 to coords on sphere
c     if(iq.eq.1.or.iq.eq.il*il)then
c      print *,'after norm'
c      print *,'x4a,y4a,z4a ',x4a,y4a,z4a
c      print *,'x4b,y4b,z4b ',x4b,y4b,z4b
c     endif
      vecax=x4a-x(iq)
      vecay=y4a-y(iq)
      vecaz=z4a-z(iq)
      vecbx=x4b-x(iq)
      vecby=y4b-y(iq)
      vecbz=z4b-z(iq)
      crossx=vecay*vecbz-vecby*vecaz
      crossy=vecaz*vecbx-vecbz*vecax
      crossz=vecax*vecby-vecbx*vecay
      crossmod=sqrt(crossx**2+crossy**2+crossz**2)
c     if(iq.eq.6.or.iq.eq.31)then
c       print *,'iq,iqa,iqb,crossmod ',iq,iqa,iqb,crossmod
c       print *,'veca ',vecax,vecay,vecaz
c       print *,'vecb ',vecbx,vecby,vecbz
c     endif
      return
      end
