.. cython_optimizations documentation master file, created by
   sphinx-quickstart on Mon Oct 22 09:16:59 2012.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Optimizing python in cython
================================================

Speedup what you want as fast as you want...

.. image:: _static/speed2.jpg
    :align: right
    :class: full-screen

Who's cython?
-------------

    * Cython is a language that makes writing C extensions for the Python language 
      as easy as Python itself.
    * It is based on the well-known Pyrex, but supports 
      more cutting edge functionality and optimizations.
    * It's **fast&easy** and gives you ability to **speedup only critical parts** 
      of code with only **basic knowledge of C**.
    * It gives you ability to be lazy and still have very good perfomance.
    * His best friend is **numpy**.

.. image:: _static/who.jpg
    :align: right
    :class: full-screen

Tell me more...
---------------

    * Cython converts your python code into C code and at the same time gives
      you ability to use native or cython optimized libraries for speedups

      .. code-block:: c

              /* "zss.pyx":204
              * fd[0]= fd_factory(&fd_buffer[buf_idx],0,0,0)
              * buf_idx+=1
              * for x from 1 <= x < m:  # <<<<<<<<<<<<<<
              *     fd0= fd[x-1]
              *     fd[x] = fd_factory(&fd_buffer[buf_idx], fd0.cost + 1, An[x-1].id, 0, fd0-fd_buffer)
              */

              __pyx_t_23 = __pyx_v_m;
              for (__pyx_v_x = 1; __pyx_v_x < __pyx_t_23; __pyx_v_x++) {

.. image:: _static/speed3.jpg
    :align: right
    :class: full-screen

Calling cython:
---------------

* Simple as putting that into your **setup.py**::

    from Cython.Distutils import build_ext

    ...

    cmdclass = {'build_ext': build_ext},
    ext_modules = [Extension("test", ["test.pyx"],
                               extra_compile_args=['-O3'])],
    install_requires=[
        "cython"
    ]

* Making **test.pyx** file with any python code
* And running **python setup.py build_ext --inplace**

.. image:: _static/speed4.jpg
    :align: right
    :class: full-screen

What just happened?
-------------------

* C code was generated and compiled
* Generated C code is in **test.c** file
* Compiled python module is in **test.so** file

Importing classes/functions from test is now as simple as calling:

    >>> from test import something

.. image:: _static/speed6.jpg
    :align: right
    :class: full-screen

This is native code, should it run fast?
----------------------------------------

* Yes this is native code.
* No it would usually run even slightly slower than python compiled interpreter code.

**Cython does not magically optimize code by itself, you must optimize it by writing
cython speciffic code optimizations in cython speciffic code syntax.**

Cython even gives you ability to write same code and have two versions automatically
avalible, one native and one for python interpreter in case when cython code
cannot be compiled.

.. image:: _static/speed5.jpg
    :align: right
    :class: full-screen

What to (not) optimize?
-----------------------

* Optimize only slow parts of code.
* Don't bother with parts of code running fast.
* Optimize only if you don't find faster algorithm O(n^3) > O(n^2)
* First look into **numpy**
* Recursive algorithms
* ... but not the ones that can be calculated using matrices::

    >>> a = np.array([[3,1], [1,2]])
    >>> b = np.array([9,8])
    >>> x = np.linalg.solve(a, b)
    >>> x
    array([ 2.,  3.])

Relevant syntax in 4 lines
--------------------------

* Cython imports for native modules

  .. code-block:: cython

    cimport numpy as np

* Native type defintions

  .. code-block:: cython

    cdef Fd_t* fd_buffer= <Fd_t*>malloc(150000000*sizeof(Fd_t))

* Structure/Class declarations

  .. code-block:: cython

    cdef struct Fd_t:
        np.uint16_t cost
        np.uint16_t source

    cdef class Fd:
        cdef public np.uint16_t cost
        cdef public np.uint16_t source

* Native function decalarations

  .. code-block:: cython

    cdef inline Fd_t* fd_factory(Fd_t *instance, np.uint_t cost)

.. image:: _static/speed10.jpg
    :align: right
    :class: full-screen

Before you do it, prepare your data!
------------------------------------

First prepare your data to be ready for fast processing. Any non-optimized dynamic
datai will slow down your code rapidly.

* ... store it into numpy arrays 
  
  .. code-block:: cython

    cdef np.ndarray[np.uint_t,ndim=2] Ak = np.array(Ak_t, dtype=np.uint)

* ... or in C structures inside numpy arrays

  .. code-block:: cython

    Node_dt= np.dtype({'names':('hash','id'), 'formats':(np.int,np.uint)})
    cdef struct Node:
        np.int_t hash
        np.uint_t id

    ...

    cdef np.ndarray[Node, ndim=1] An = np.array(An_t1, dtype=Node_dt)

.. image:: _static/speed9.jpg
    :align: right
    :class: full-screen

How to optimize?
----------------

* Don't use classes, they are slow, use numpy arrays

  .. code-block:: cython

    cdef np.ndarray[np.uint_t,ndim=2] Ak = np.array(Ak_t, dtype=np.uint)

* Turn off garbage collector if not needed
  
  .. code-block:: cython
    
    gc.disable()

* Use basic for loops like this one

  .. code-block:: cython
  
    for x from 1 <= x < m:

* Set compiler directives like disabing array bounds checks and wrapp around
  array support.

  .. code-block:: cython

    @cython.boundscheck(False)
    @cython.wraparound(False)
    cdef test()

.. image:: _static/speed8.jpg
    :align: right
    :class: full-screen

How to optimize even better?
----------------------------

* Instead of dynamic strucutres preallocate memory if you've got enough

  .. code-block:: cython

    cdef Fd_t* fd_buffer= <Fd_t*>malloc(150000000*sizeof(Fd_t))

* Index your arrays using comma and **numpy** will optimize
  
  .. code-block:: cython

      treedists[x+ioff, y+joff] = fd[x, y]

* Use inline functions

  .. code-block:: cython

    cdef inline Fd_t* fd_factory( ... )

* If you are using classes, use factory to construct them

  .. code-block:: cython

   cdef inline Fd_t* fd_factory(Fd_t *instance, np.uint_t cost, np.uint_t source):
       instance.cost = cost
       instance.source = source

       return instance

.. image:: _static/speed11.jpg
    :align: right
    :class: full-screen


If felix can do it, you can do it!
==================================

* Example
* Q&A

Thanks!

.. image:: _static/speed7.jpg
    :align: right
    :class: full-screen

