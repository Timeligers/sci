Welcome to Scilab 2025.0.0
==========================

This file details the changes between Scilab 2025.0.0 (this version), and the previous 2024.1.0 release.
For changelogs of earlier releases, please see [Scilab 2024.1.0][1].

Summary:

- New features
- Obsolete functions & features
- Removed functions & features
- Installation, Compilation, Packaging, API/ABI changes
- Fixed bugs

Please report anything we could have missed, on the [mailing lists][2] or the [bug tracker][3].

[1]: https://help.scilab.org/docs/2024.1.0/en_US/CHANGES.html
[2]: https://www.scilab.org/about/community/mailing-lists
[3]: https://gitlab.com/scilab/scilab/-/issues

New features
------------

For a high-level description of the main new features of this release, please consult the [embedded help][4]. It is also available as the "What's new" page of the help, by simply typing `help` in the Scilab console.

[4]: modules/helptools/data/pages/homepage-en_US.html

In summary, the main new features and additions are:

### New functions

- __add information about new functions before and keep this line__

### Language changes

- __add information about language changes before and keep this line__

### Web tools

- __add information about web tools before and keep this line__

### Graphics

- __add information about graphics before and keep this line__

### Differential equations

- __add information about differential equations before and keep this line__

### Sparse matrices

- __add information about sparse matrices before and keep this line__

### String

<<<<<<< HEAD
- __add information about string before and keep this line__
=======
* [SSE2][6], Streaming SIMD Extensions 2 support is now mandatory to run Scilab on Linux i686.

[5]: http://java.com/en/download/help/sysreq.xml
[6]: https://en.wikipedia.org/wiki/SSE2

Feature changes and additions on 6.1.0
--------------------------------------

* `airy` has been added: Evaluation of Airy functions of the first and second kind, and their first derivative, possibly scaled.
* HTTP get, post, put, upload, patch, delete functions added
* JSON encoding / decoding for Scilab datatypes added
* Memory invalid accesses have been greatly reduced thanks to :
  - PVS-Studio inspections blog report
  - Coverity scan weekly source analysis
* `bitget` is upgraded:
  - It now accepts positive Signed encoded integers.
  - It now supports the new uint64 and int64 types of encoded integers.
  - For decimal numbers: bits with indices > 52 can now be retrieved (up to `log2(number_properties("huge"))` = 1024).
  - For decimal numbers `x > 2^52`, queried bits below `%eps` (indices < log2(x)-52) now return `Nan` instead of 0.
  - Several bits can now be retrieved from each component of an input array.
* `bitset` is upgraded:
  - It now accepts positive Signed encoded integers.
  - It now supports the new uint64 and int64 types of encoded integers.
  - For decimal numbers: bits with indices > 32 can now be set (up to #1024).
  - Several bits can now be set for each input component.
  - Distributive scalar inputs are now accepted.
* `bitstring` function added.
* `edit` now accepts a line number as text (like "23").
* `profileEnable`, `profileDisable`, `profileGetInfo` could be used to instrument functions and gather execution information within Scilab.
* `prettyprint` is upgraded:
  - Integer and Text input are now actually supported.
  - HTML is now supported as output format.
  - Default input arguments can be skipped instead of still having to be provided.
  - The result string is better formatted to be easily wrappable and indented.
* `mesh2d` has been introduced to compute a 2d mesh from vectors (x,y) of points.
* `loadmatfile` is upgraded:
  - Octave native text data files can now be read.
  - Automatic detection of the input data format implemented.
  - `-toStruct` option added, to return results in a structure instead of in the calling environment.
* `jremove` is optional and `clear` could be used to release Java objects mapped to Scilab.
* `blockdiag` is introduced to improve, replace, and extend `sysdiag` to strings.
* `assert_checkequal` is upgraded:
  - support added for Nan and void in lists, Nan in sparses, implicit lists, graphic handles, macros, libraries, and built-in.
  - For arrays of matching typeof and sizes, and for lists of matching lengths, the failure message now indicates the index and values of the first mismatching elements.
* `diophant` is improved:
  - Encoded integers are accepted, in addition to decimal numbers. Only integer solutions are then searched.
  - When there is no solution, `[]` is returned.
  - When there is an infinite number of solutions, the err flag has a specific value.
  - The output size gets the input's size.
* `csvRead` and `csvTextScan` are now implemented without extra copies.
* `editvar` GUI support copy-paste of strings removing quotes.
* `calendar` can now display formatted calendars.
* `xmlSetValues` clones `setPreferencesValue` that is now obsolete.
* `unique` is upgraded to:
  - return the number of occurrences of distinct entities found in the input array.
  - return distinct entities in their initial order (rather than sorted), with the `"keepOrder"` option.
  - consider all `Nan` values as the same one, with the `"uniqueNan"` option.
* `ellipj` function introduced, to compute the `sn`, `cn`, `dn`, `ns`, `nc` and `nd` Jacobi elliptic functions.
* `riccati` is upgraded:
  - `riccati(H)` and `riccati(H,E)` syntaxes added, to describe the Riccati equation through its Hamiltonian H or (E,H) pencil.
  - The residual is returned as a new 3rd output argument.
  - When no solution is found, `X=[]` | `X1=[]` is returned instead of yielding an error.
* `hallchart` is upgraded:
  - The default set of modules is set automatically, according to data bounds.
  - Handles of the grids and labels are returned. Post-processing them becomes easy.
  - Named colors accepted; better default colors.
  - Improved placement of labels.
* `playsnd` is upgraded:
  - the name of a wav file can now be specified (instead of the sound data).
  - the input sound can now be repeated a given number of times.
  - the modal/non-modal processing is improved.
* `nicholschart` is improved: more neutral default frame color; improved labels positioning; colors can now be specified by their predefined name or "#RRGGBB" hexa code; a structure of handles is now returned to easily post-process both subframes and the set of labels.
* `sciargs` returns a column instead of formerly a row.
* Booleans and encoded integers can now be concatenated together, as in `[%f int8(-5)]`.
* `gsort` can now perform multilevel sorting. This noticeably allows sorting completely complex numbers.
* `factorial` can be used now from n=171 up to n=10^14.
* `intersect` now supports complex numbers.
* `setdiff` now supports complex numbers.
* `twinkle` can now blink together several hierarchically independent objects, like a curve and its labels, etc.
* `repmat` has been rewritten. It is 7 times faster now.
* `plot` can now work in semi or bi-logarithmic mode with some input logflag.
* `plotimplicit` function added.
* The default smarter grid_style value is now 7 instead of 3.
* `weekday` accepts new date formats and new syntaxes. A language option applying to the day names is now available.
* `vectorfind` is upgraded:
  - vectorfind(m, []) now returns [] instead of an error.
  - A too-long needle now returns [] instead of an error.
  - %nan values never matched. They are now regularly processed, as other values.
  - A needle shorter than the haystack size can now be used.
  - A wildcard value matching any value of the haystack can now be specified and used in the needle. Actual matching ranges can then be returned: Options `joker` and `matching` added.
  - Hypermatrices are now accepted as the haystack.
  - The probing direction can now be numeric: 1, 2, ..
  - Returned indices can now be formatted with the new option `indType`.
  - There were no unit tests. More than 100 tests are added.
* `datafit` is now able to fit weighted data. It now supports any gap function vectorized for Data points, and so is much faster. It now accepts any matrix of parameters (not necessarily a column). It now returns the average Mode-to-data distance, and the termination status for the quasi-Newton algorithm.
* `tree_show` is upgraded:
  - New `rootTitle` and `styles` optional inputs.
  - New `arrayByFields` option, to allow displaying each array component as an object in its whole.
  - Improved layout: detailed indices for 2D arrays, simplified symbols, etc.
  - The content of implicit list objects, and information for Scilab functions and libraries of functions are now displayed.
* `nchoosek` is introduced, to compute the binomial coefficients.
* The left .\. and right ./. Kronecker divisions are now implemented, for arrays of decimal or complex numbers.
* `perms` can now build and return only unique permutations, without duplicates.
* Most of the graphic objects can be moved interactively in opened figures.
* `circshift` is introduced.
* `atomsGetInstalledPath` is no longer sensitive to the case or completeness of the names of the modules. Providing the version of the modules is now optional.
* `function` replaces `mc` as the new overloading code for functions in Scilab language.


Feature changes and additions on 6.1.1
--------------------------------------

* Axes labels and title default font size had been increased for better default rendering.
* `gsort` is upgraded:
  - It can now sort any sparse 2D matrix, in all `g, r, c, lr, lc` methods, including sparse booleans, and in a multi-level mode. It was formerly limited to sparse real or complex vectors and only to the `g` mode.
  - Any hypermatrix can be sorted along a dimension > 2.
* `unique` is enabled for any 2D sparse arrays, in simple, 'c' and 'r' modes.
* `%chars` constant added, to easily access to some selected sets of Unicode symbols.
* Lists are displayed more compactly and comprehensively.
* `interp1` is upgraded:
  - complex numbers `y` now supported: the real and imaginary parts are interpolated separately.
  - extrapolation option extended: `edgevalue` mode added for all interpolations; `periodic` mode added for linear and spline interpolations. `linear` mode added for the spline interpolations.
* `xlfont` did not support the documented 4th argument.
* `bitcmp` is upgraded:
  - Entended to 64-bit integers.
  - Extended to all signed integers.
  - Decimal positive integers > 2^52 up to 2^1024 = number_properties("huge") can now be processed, with bitnum up to 1024 instead of 52.
  - bitnum can be an array. It is now optional as well for input decimal integers.
* The `Arnoldi` module is now internal.
* `sgolay` and the companion `sgolayfilter` and `sgolaydiff` functions have been added to implement Savitsky-Golay filters.
* `clock` now returns the time zone and the daylight saving time.
* `mapsound` is rewritten and handle parameters in a different way.
* `mprintf`, `msprintf` and `mfprintf` can now print input booleans, as `0`|`1` or as `T`|`F`.
* `setdiff` now supports input booleans and sparse matrices (boolean or numeric).
* `intersect` is extended to any sparse boolean or numeric arrays, in all simple, 'c' or 'r' modes.
* `union` supports boolean, sparse boolean, and sparse numerical matrices.
* `kron` and `.*.` are extended to boolean arrays.
* `gamma` is extended to incomplete gamma integrals.
* `close` is extended to close the help browser, xcos, the variables browser, or editor GUIs.
* `polyint` is introduced to compute polynomial antiderivatives.
* `det` is now actually extended to sparse matrices.
* `deff` is upgraded:
   - The created function may be returned as an output argument.
   - Providing the function headline and body concatenated in a single input text vector is possible.
   - For a simple function, a single string input definition can be provided.
   - For assignable calls to `deff`, the `@` symbol can be used as function pseudo-name.
* `mgeti` can now read correctly 64-bit int64 / uint64 integers bigger than 2^52.
* `mopen` and `mclose` now handle multiple files and file descriptors.
* `hash` function with SHA-1, SHA-2 and SHA-3 Secure Hash Algorithms has been added.
* `loglog`, `semilogx`, `semilogy` Matlab-compatible functions added.
* `scatter` and `scatter3d` are reforged. New `scatter` options: `"smallOnTop"` and `"datatips"`.
* `asciimat` now supports input strings of different lengths or including international UTF8 extended characters.
* polynomials can now use a greek letter as variable.
* `int2d` can now compute direcly a double integral over a rectangle.
* `int3d` can now compute direcly a triple integral over a cuboid.
* `cutaxes` function added.
* Integers can be concatenated with real or complex numbers (dense encoding only).
* `complex` is extended to sparse arrays.
* `m2sci` Matlab-to-Scilab code converter upgraded for better code conversion.


Feature changes and additions on 6.1.2
--------------------------------------

* completion field names output can now be overloaed.

User Interface improvements
---------------------------

* The `ans` variable is editable as any other variable in Editvar.
* Commands history is saved before executing a command to have the correct history of a crash.
* Used memory per variable is displayed by BrowserVar to give the user numbers on memory usage repartition and let the user `clear` the big ones first.
* In browsevar, clicking on any function, library, list, cell, structure, custom tlist or mlist, or graphic handle now edits or displays their content.
* Autoscroll of the console in GUI mode is disabled when the user scrolls up until he scrolls to the bottom.
* Help browser improved:
  - The browser's language can be set independently of the session's language
  - The menu "Online" allows displaying in your web browser the online version of the current page
  - The menu "Issues" allows displaying bugzilla entries related to the feature of the current page
  - ATOMS chapters are automatically loaded in the browser.
  - The page left at exit is restored at the next startup.
  - On Preferences option, querying some Matlab terms can now redirect and display the documentation of the Scilab equivalent feature.
* `x_matrix` can now edit matrices of booleans, integers, or text. Matrices of real or complex numbers are better displayed.
* `importgui` is renamed `uiSpreadsheet`.


Xcos
----

* Default ending time reduced from 100000 to 30, to fit default scope block.
* `CURVE_c` settings did not always display a window.
* Exporting all layers from a diagram will generate one unique file per layer.

API/ABI modification
----------------

* Functions could return zeros arguments, the following gateway functions have been updated:
 - on APIv5 C `CheckOutputArgument(ctx, min, max)` the `min` argument should be set to `0` if needed.
 - on APIv5 C `getNbOutputArgument(ctx)` the return value could be `0`
 - on APIv6 C++ the `_iRetCount` argument value could be `0`.
* On APIv6 C++, a virtual method has been added on internal types which break the ABI. Toolboxes need to be recompiled.
* C `pause` symbol was conflicting with POSIX one, it was renamed to `pause_interpreter`.
>>>>>>> 29dccbc538311a22cff56c8e425c3a0a0fe82687

Obsolete functions or features
------------------------------

All these functions and features will be removed in Scilab 2025.0.0 (October 2024):

- __add information about obsolete features before and keep this line__

Removed Functions
-----------------

The following functions have been removed:

- __add information about removed functions before and keep this line__

Removed Features
----------------

The following features and usages have been removed or disabled:

- __add information about removed features before and keep this line__

Compilation
-----------

- __add information about compilation before and keep this line__

Packaging & Supported Operating Systems
---------------------------------------

- 32-bit platforms are not supported (no binary versions released).

- Native macOS M1/arm64 build is provided (at least 2 x faster than Intel build using Rosetta emulation).

- Scilab embedded JVM is Java 17 without a memory usage limit. Java heap size limit can still be set in Preferences (General / Java Heap Memory).

- To run or compile Scilab, you might need:
  - Windows (amd64):
    - Windows 11 (Desktop)
    - Windows 10 (Desktop)
    - Windows 8 (Desktop)
  - macOS:
    - Intel-based Mac running macOS 10.9+ (run) and 10.14+ (compile)
    - M1-based Mac running macOS 11+ (run, compile).
  - Linux (amd64):
    - debian:11, 12
    - ubuntu:20.04, 22.04, 23.10, 24.04
    - fedora:39, 40

API/ABI modification
--------------------

- __add information about api/abi modification before and keep this line__
