
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
