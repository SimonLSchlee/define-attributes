#lang info
(define collection "define-attributes")
(define deps '("base"))
(define build-deps '("pict-lib" "scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/define-attributes.scrbl" ())))
(define pkg-desc "a macro for accessing attributes with a common prefix and optionally renamed name mappings")
(define version "0.1")
(define pkg-authors '("schlee.simon@gmail.com"))
(define license '(MIT))
