c     second line are used in interpolation routines
      common/indices/in(ifull),is(ifull),iw(ifull),ie(ifull),
     .               inn(ifull),iss(ifull),iww(ifull),iee(ifull),
     .               ine(ifull),ise(ifull),ien(ifull),iwn(ifull),
     .               iwu(ifull),isv(ifull),    ! these for sflux, vertmix
     .               iwu2(ifull),isv2(ifull),ieu2(ifull),inv2(ifull) ! div calcs
     .               ,iev2(ifull),inu2(ifull)  ! upglobal
     .               ,ieu(ifull),inv(ifull)    ! staguv3
     .               ,lwws(0:npanels),lws (0:npanels),lwss(0:npanels)  ! ints
     .               ,les (0:npanels),lees(0:npanels),less(0:npanels)  ! ints
     .               ,lwwn(0:npanels),lwnn(0:npanels),leen(0:npanels)  ! ints
     .               ,lenn(0:npanels)                ,lsww(0:npanels)  ! ints
     .               ,lsw (0:npanels),lssw(0:npanels),lsee(0:npanels)  ! ints
     .               ,lsse(0:npanels),lnww(0:npanels),lnw (0:npanels)  ! ints
     .               ,lnnw(0:npanels),lnee(0:npanels),lnne(0:npanels)  ! ints
     .               ,npann(0:13),npane(0:13),npanw(0:13),npans(0:13)  ! hordifg
