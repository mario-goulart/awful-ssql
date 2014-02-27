(use awful http-client intarweb test uri-common)

(define server-uri (sprintf "http://localhost:~a" (server-port)))

(define (get path/vars)
  (let ((val (with-input-from-request
              (make-pathname server-uri path/vars)
              #f
              read-string)))
    (close-all-connections!)
    val))

(test '((1 "one"))
      (with-input-from-string (get "/test/ssql") read))

(test '((1 "one"))
      (with-input-from-string (get "/test/sql") read))
