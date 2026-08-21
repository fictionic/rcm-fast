AC_PREREQ([2.69])
AC_INIT([rcm-fast],[2.1.0],[dylandforbes@gmail.com])
AM_INIT_AUTOMAKE([subdir-objects])

# /bin/sh on Solaris is not POSIX, so try to find another one.
case "$host_os" in
solaris*)
    AC_PATH_PROGS(POSIX_SHELL, [ksh93 ksh sh])
    SHELL="$POSIX_SHELL"
    ;;
esac
AC_SUBST([SHELL])

AC_CONFIG_FILES([Makefile share/rcm.sh arch/git-PKGBUILD NEWS.md bin/lsrc bin/mkrc bin/rcdn bin/rcup bin/rcgc])

# config.status does not copy the mode of the input file, so make this one
# executable. DEVELOPERS.md tells the maintainer to run it as ./maint/release .
AC_CONFIG_FILES([maint/release], [chmod +x maint/release])

AC_OUTPUT
