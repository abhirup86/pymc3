from PyMCBase import Variable, ContainerBase
from copy import copy
from numpy import ndarray, array, zeros, shape, arange, where

cdef extern from "numpy/ndarrayobject.h":
    void* PyArray_DATA(object obj)

def LTCValue(container):

    cdef int i, ind
    cdef object _value, val_ind, nonval_ind
    
    val_ind = container.val_ind
    nonval_ind = container.nonval_ind
    _value = container._value
    
    for i from 0 <= i < container.n_val:
        ind = val_ind[i]
        _value[ind] = container[ind].value
    for i from 0 <= i < container.n_nonval:
        ind = nonval_ind[i]
        _value[ind] = container[ind]

def DCValue(container):
    cdef int i
    cdef object _value, val_keys, nonval_keys, key
    
    val_keys = container.val_keys
    nonval_keys = container.nonval_keys
    _value = container._value
    
    for i from 0 <= i < container.n_val:
        key = val_keys[i]
        _value[key] = container[key].value
    for i from 0 <= i < container.n_nonval:
        key = nonval_keys[i]
        _value[key] = container[key]

def OCValue(container):
    cdef int i
    cdef object _value, val_keys, nonval_keys, key, _dict_container
    
    _dict_container = container._dict_container
    val_keys = _dict_container.val_keys
    nonval_keys = _dict_container.nonval_keys
    _value = container._value.__dict__
    
    
    for i from 0 <= i < _dict_container.n_val:
        key = val_keys[i]
        _value[key] = _dict_container[key].value
    for i from 0 <= i < _dict_container.n_nonval:
        key = nonval_keys[i]
        _value[key] = _dict_container[key]
    
def ACValue(container):
    ACValue_under(container)
    
cdef void ACValue_under(object container):
    cdef int i
    cdef long *p_val_ind, *p_nonval_ind, ind
    cdef void **p_ravelledvalue, **p_ravelleddata
    cdef object val_now
    
    p_ravelledvalue = <void**> PyArray_DATA(container._ravelledvalue)
    p_ravelleddata = <void**> PyArray_DATA(container._ravelleddata)    
    
    p_val_ind = <long*> PyArray_DATA(container.val_ind)
    p_nonval_ind = <long*> PyArray_DATA(container.nonval_ind)
    
    for i from 0 <= i < container.n_val:
        ind = p_val_ind[i]
        val_now = (<object> p_ravelleddata[ind]).value
        p_ravelledvalue[ind] = <void*> val_now

    for i from 0 <= i < container.n_nonval:
        ind = p_nonval_ind[i]
        p_ravelledvalue[ind] = p_ravelleddata[ind]
    