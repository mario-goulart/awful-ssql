(module awful-ssql (enable-ssql)

(import chicken scheme)
(use ssql awful)

(define enable-ssql (make-parameter #f))

(db-query-transformer
 (lambda (q)
   (if (enable-ssql)
       (ssql->sql #f q)
       q)))

) ;; end module
