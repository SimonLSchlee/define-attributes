#lang racket/base

(provide define-attributes)

(require syntax/parse/define
         (for-syntax racket/base racket/syntax))

(begin-for-syntax
  (define-syntax-class name-mapping
    #:description "name-mapping"
    [pattern  from:id           #:with to #'from]
    [pattern (from:id)          #:with to  '||] ; empty symbol
    [pattern (from:id to-id:id) #:with to #'to-id]))

(define-syntax-parser define-attributes
  [(_ (ids:name-mapping ...+) prefix:id (attributes:name-mapping ...+))
   #`(begin (define-attributes-id #,this-syntax ids prefix attributes ...) ...)])

(define-syntax-parser define-attributes-id
  [(_ loc id:name-mapping prefix:id attribute:name-mapping)
   #:with newid    (syntax-property
                    (format-id #'id "~a~a" #'id.to #'attribute.to #:subs? #t)
                    'original-for-check-syntax #t)
   #:with accessor (format-id #'loc "~a~a" #'prefix #'attribute.from #:source #'loc)
   #:with expr     #'(accessor id.from)
   #'(define newid expr)]
  [(_ loc id:name-mapping prefix:id attributes:name-mapping ...+)
   #'(begin (define-attributes-id loc id prefix attributes) ...)])


