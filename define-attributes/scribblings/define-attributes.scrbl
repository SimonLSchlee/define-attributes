#lang scribble/manual
@require[@for-label[define-attributes
                    racket/base]]
@require[pict]
@require[racket/runtime-path]
@(define-runtime-path examplearrows "examplecodearrows.gif")

@title{define-attributes}
@author[(author+email "Simon Lukas Schlee" "schlee.simon@gmail.com")]

@defmodule[define-attributes]

This macro makes certain repetitive access patterns easier to write.
Its implementation was improved by feedback from the @hyperlink["https://racket.discourse.group/t/define-attributes-macro-is-this-useful-ideas-for-improvements/300?u=simonls"]{racket community}.

@margin-note{This animated gif shows the binding arrows in DrRacket for some example uses of the macro.}
@image[examplearrows]

@defform[(define-attributes (id ...) prefix (attribute ...))
         #:grammar
         [(id (code:line input-id)
              (code:line [input-id])
              [input-id renamed-id])
          (attribute (code:line attribute-id)
                     [attribute-id renamed-id])]]{
  For every @racket[id] the @racket[prefix] is combined with the @racket[attribute] and defined as a new binding.
  The binding name is a combination of the @racket[id] and the @racket[attribute], both can be renamed.
  The @racket[id] can be renamed to nothing in that case the binding name is only created with the @racket[attribute].

  @emph{Another way to describe this is:}@linebreak{}
  The different combinations of the @racket[id]s with the @racket[attribute]s creates a resulting matrix of new bindings.

  Lets say we have @racket[l] and @racket[r] defined as in the gif image above:
  @racketblock[
  (struct vec3 (x y z))
  (define l (vec3 3 5 7))
  (define r (vec3 0 2 4))
  ]

  Then the corresponding matrix looks like this:

  @(table 4
          (for/fold ([lst null]
                     [i 0]
                     #:result (reverse lst))
                    ([id (in-list '(#f l r))]
                     #:when #t
                     [attr (in-list '(#f x y z))])
            ;; not fully generic because it is only used once
            (define txt
             (cond
              [(= i 0) ""]   [(= i 1) "x"] [(= i 2) "y"] [(= i 3) "z"]
              [(= i 4) "l"]
              [(= i 8) "r"]  [else (format "~a~a: (vec3-~a ~a)" id attr attr id)]))
            (values (cons (text txt) lst)
                    (add1 i)))
         cc-superimpose
         cc-superimpose
         10
         10)

  And writing the following:
  @racketblock[
  (define-attributes (l r) vec3- (x y z))
  ]
  is equivalent to writing this:
  @racketblock[
  (define lx (vec3-x l))
  (define ly (vec3-y l))
  (define lz (vec3-z l))
  (define rx (vec3-x r))
  (define ry (vec3-y r))
  (define rz (vec3-z r))
  ]

  Writing @racket[(define-attributes ([l]) vec3- (x y z))] is equivalent to:
  @racketblock[
  (define x (vec3-x l))
  (define y (vec3-y l))
  (define z (vec3-z l))
  ]
  Here @racket[l] is renamed to nothing so only the attribute names remain.

  A few more examples:
  @#reader scribble/comment-reader
  (racketblock
  (define-attributes ([l o])  vec3- (x y z)) ; ox oy oz
  (define-attributes ([l l.]) vec3- (x y z)) ; l.x l.y l.z
  (define-attributes ([l])    vec3- (x y z [length len]))  ; x y z len
  )
}

