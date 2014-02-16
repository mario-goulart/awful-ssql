(use posix)
(use awful awful-sql-de-lite awful-ssql sql-de-lite)

(delete-file* "db")

(db-credentials "db")

(enable-db #t)
(enable-ssql #t)

(page-template
 (lambda (content . args)
   content))

;; set up the database
(let ()
  (define (db-query db-conn q #!key (values '()))
    (apply query (append (list (map-rows (lambda (data) data))
                               (sql db-conn ((db-query-transformer) q)))
                         values)))

  (parameterize ((enable-ssql #f))
    (call-with-database (db-credentials)
      (lambda (db)
        (db-query db "create table sometable (foo integer, bar text)")))))


(define-page "/test/ssql"
  (lambda ()
    ($db '(insert (into sometable)
                  (columns foo bar)
                  (values #(1 "one"))))
    (let ((vals ($db '(select (columns foo bar)
                              (from sometable)))))
      (with-output-to-string
        (lambda ()
          (pp vals))))))


(define-page "/test/sql"
  (lambda ()
    (parameterize ((enable-ssql #f))
      ($db "delete from sometable")
      ($db "insert into sometable (foo, bar) values (1, 'one')")
      (let ((vals ($db "select foo, bar from sometable")))
        (with-output-to-string
          (lambda ()
            (pp vals)))))))
