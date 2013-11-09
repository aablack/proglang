
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

; Q1
(define (sequence low high stride)
  (if (> low high)
      null
      (cons low (sequence (+ low stride) high stride))))

; Q2
(define (string-append-map xs suffix)
  (map (lambda (item) (string-append item suffix)) xs)) 

; Q3
(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: empty list")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [#t (car (list-tail
                  xs
                  (remainder n (length xs))))]))

; Q4
(define (stream-for-n-steps s n)
  (define pair (s))
  (if (<= n 0)
      null
      (cons (car pair)
            (stream-for-n-steps (cdr pair) (- n 1)))))

; Q5
(define (funny-number-stream)
  (define (count x) (cons (if (= (remainder x 5) 0) (- x) x)
                          (lambda () (count (+ x 1)))))
  (count 1))

; Q6
(define (dan-then-dog)
  (define (dan) (cons "dan.jpg" dog))
  (define (dog) (cons "dog.jpg" dan))
  (dan))

; Q7
(define (stream-add-zero s)
  (define pair (s))
  (lambda () (cons (cons 0 (car pair))
                   (stream-add-zero (cdr pair)))))

; Q8
(define (cycle-lists xs ys)
  (define (cycle i)
    (lambda() (cons (cons (list-nth-mod xs i) (list-nth-mod ys i))
          (cycle (+ i 1)))))
  (cycle 0))

; Q9
(define (vector-assoc v vec)
  (define (check-assoc i)
    (if (< i (vector-length vec))
        (let ([elem (vector-ref vec i)])
          (if (and (pair? elem) (equal? v (car elem)))
              elem
              (check-assoc (+ i 1))))
        #f))
  (check-assoc 0))
  
; Q10
(define (cached-assoc xs n)
  (define index 0)
  (define cache (make-vector n #f))
  ; Return a function to lookup v from the cache first
  (lambda (v)
    (let ([ans (vector-assoc v cache)])
      (or ans
          (let ([ans (assoc v xs)])
            (if ans
                (begin (vector-set! cache index ans)
                       (set! index (remainder (+ index 1) n))
                       ans)
                #f))))))
  
  
                
    
                    
    
    
  