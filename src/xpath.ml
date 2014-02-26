open Ctypes
open PosixTypes
open Foreign
open Dl


let filename = "libxml2.so"
let libxml2 = dlopen ~filename ~flags:[RTLD_NOW; RTLD_GLOBAL]

let filename = "libxml_wrap.so"
let libwrap = dlopen ~filename ~flags:[RTLD_NOW]

let xpath_matching = foreign ~from:libwrap "execute_xpath_str_on_memory"
  (string @-> string @-> returning int)
