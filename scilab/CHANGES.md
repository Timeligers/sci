Welcome to Scilab 2024.0.0
==========================

This file details the changes between Scilab 2024.0.0 (this version), and the previous 2023.1.0 release.
For changelogs of earlier releases, please see [Scilab 2023.1.0][1].

Summary:

- New features
- Obsolete functions & features
- Removed functions & features
- Installation, Compilation, Packaging, API/ABI changes
- Fixed bugs

Please report anything we could have missed, on the [mailing lists][2] or the [bug tracker][3].

[1]: https://help.scilab.org/docs/2023.1.0/en_US/CHANGES.html
[2]: https://www.scilab.org/about/community/mailing-lists
[3]: https://gitlab.com/scilab/scilab/-/issues

New features
------------
For a high-level description of the main new features of this release, please consult the [embedded help][4]. It is also available as the "What's new" page of the help, by simply typing `help` in the Scilab console.

[4]: modules/helptools/data/pages/homepage-en_US.html

In summary, the main new features and additions are:

* Use `curl` as default in `atomsDownload()` for all OS to handle local file repositories.
* Add headers as optional input argument in `http_*` functions.
* Add cookie management in webtools module.
* [ColPack](https://github.com/CSCsw/ColPack) graph coloring algorithms have been integrated.
* New markers types added for graphic objects:
  - triangles pointing to data: upward, downward, left, right,
  - horizontal line (minus sign) centered on data,
  - vertical line centered on data.
* `errbar()` function now uses horiontal line marks.
* Add compression and decompression functions to manage compressed archive.
* The number of characters used to define the body of any conditional instruction (`if`, `while`, `for`, or `select/case`) is no more limited to 16k (Scilab 6.x improvement).
* Add absolute and relative numerical tolerences in `intl()` input arguments.
* `url_encode()` and `url_decode()` are added to the webtools module.
* <TODO>


Obsolete functions or features
------------------------------

All these functions and features will be removed in Scilab 2025.0.0 (October 2024):

- __add your obsolete features before and keep this line__

Removed Functions
-----------------

The following functions have been removed:

- __add your removed functions before and keep this line__

Removed Features
----------------

The following features and usages have been removed or disabled:

Matlab Sparse datatype has been removed.
- __add your removed features before and keep this line__

Installation
------------

- __add your installation notes before and keep this line__

Compilation
-----------

- Update autotools to support Linux aarch64 and macOS Apple M1.
  Use Autoconf 2.71 and Automake 1.16.5 to update.
- Update JDK to Java 17.
- __add your compilation notes before and keep this line__

Packaging & Supported Operating Systems
---------------------------------------

- 32-bit Windows platforms are no more supported (no binary versions released).

- Scilab embedded JVM is Java 17.

- To run or compile Scilab you need at least:
  - Windows (amd64):
    - Windows 11 (Desktop)
    - Windows 10 (Desktop)
    - Windows 8 (Desktop)
  - macOS (amd64):
    - Intel-based Mac running macOS 10.9+ (run) and 10.14+ with Conda (compile)
    - Support of macOS Monterey & Ventura added in Scilab 2023.0.0
  - Linux (amd64):
    - debian:11
    - ubuntu:18.04, 20.04, 22.04
    - fedora:37

API/ABI modification
--------------------

- Javasci source/target version switched from 6 to 7 (minimal version supported by Java 17).
- __add your API/ABI modification notes before and keep this line__

Issue Fixes
-----------

- __THIS PART WILL BE GENERATED FROM THE MILESTONE/GIT LOG__
