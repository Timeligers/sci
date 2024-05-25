#!/bin/sh

PATHTOCONFIGURE="$(realpath "${0}" | xargs dirname)"
if test -x "$(which gcc 2>/dev/null)"; then
    # Detect the actual path to the libstdc++ library. For the dynamic link
    # build, we want to use the same lib as the compiler installed.
    # CF bug #7887 for more information.
    # Note that, for the Makefile, the setup is done in the Scilab macros
    # ilib_compile
    GCClibpath=$(LC_ALL=C gcc -print-search-dirs|awk -F= '$1=="libraries: "{print $2}')

    if test -z "$(grep $GCClibpath $LD_LIBRARY_PATH 2>/dev/null)"; then
        LD_LIBRARY_PATH="$GCClibpath${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        export LD_LIBRARY_PATH
    fi
fi

# Relaunch configure if files are missing
if test ! -s "$PATHTOCONFIGURE/Makefile.orig" -o ! -s "$PATHTOCONFIGURE/libtool"; then
    echo "Detection of C/C++/Fortran Compilers"
    "$PATHTOCONFIGURE/configure" --disable-static --disable-dependency-tracking "$@"
    configure_exit_status=$?
    if [ $configure_exit_status -ne 0 ]; then
        cat "$PATHTOCONFIGURE/config.log"
        exit $configure_exit_status
    else
        mv "$PATHTOCONFIGURE/Makefile" "$PATHTOCONFIGURE/Makefile.orig"
    fi
else
    echo "Detection of compilers already done"
fi
