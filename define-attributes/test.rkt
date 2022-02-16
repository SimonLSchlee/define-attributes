#lang racket/base

(module+ test
  (require rackunit
           define-attributes)

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
