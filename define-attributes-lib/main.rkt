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

(module+ test
  (require rackunit)

  (struct vec3 (x y z))

  (define (x² x) (* x x))
  (define (vec3-length² v)
    (define-attributes ([v]) vec3- (x y z))
    (+ (x² x) (x² y) (x² z)))

  (define l (vec3 3 5 7))
  (define r (vec3 0 2 4))
  (define-attributes (l r) vec3- (x y z))
  (check-equal? (list lx ly lz rx ry rz) (list 3 5 7 0 2 4))

  (define-attributes ([l]) vec3- (x y z))
  (check-equal? (list x y z) (list 3 5 7))

  (define-attributes ([l o])  vec3- (x y z))
  (check-equal? (list ox oy oz) (list 3 5 7))

  (define-attributes ([l])    vec3- ([length² len]))
  (check-equal? len 83))
