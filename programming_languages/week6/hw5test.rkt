#lang racket
;; Programming Languages Homework5 Simple Test
;; Save this file to the same directory as your homework file
;; These are basic tests. Passing these tests does not guarantee that your code will pass the actual homework grader

;; Be sure to put your homework file in the same folder as this test file.
;; Uncomment the line below and change HOMEWORK_FILE to the name of your homework file.
(require "hw5.rkt")

(require rackunit)

(define tests
  (test-suite
   "Tests for Assignment 5"
   
   ;; check racketlist to mupllist with normal list
   (check-equal? (racketlist->mupllist (list (int 3) (int 4))) (apair (int 3) (apair (int 4) (aunit))) "racketlist->mupllist test")
   
   ;; check mupllist to racketlist with normal list
   (check-equal? (mupllist->racketlist (apair (int 3) (apair (int 4) (aunit)))) (list (int 3) (int 4)) "racketlist->mupllist test")

   ;; ifgreater tests
   (check-equal? (eval-exp (ifgreater (int 3) (int 4) (int 3) (int 2))) (int 2) "ifgreater test1")
   (check-equal? (eval-exp (ifgreater (int 3) (int 2) (int 3) (int 2))) (int 3) "ifgreater test2")
   
   ;; mlet tests
   (check-equal? (eval-exp (mlet "x" (int 1) (add (int 5) (var "x")))) (int 6) "mlet test1")
   (check-equal? (eval-exp (mlet "x" (int 1) (mlet "y" (int 2) (add (var "x") (var "y"))))) (int 3)  "mlet test2")
   (check-equal? (eval-exp (mlet "x" (int 1) (mlet "x" (int 10) (var "x")))) (int 10)  "mlet test3")
   
   ;; apair test
   (check-equal? (eval-exp (apair (add (int 1) (int 2)) (add (int 3) (int 4)))) (apair (int 3) (int 7)) "apair test")
   
   ;; call test
   (check-equal? (eval-exp (call (closure '() (fun #f "x" (add (var "x") (int 7)))) (int 1))) (int 8) "call test")
   
   ;; fun tests
   (check-equal? (eval-exp (call (fun "sumto" "i" (add (var "i") (ifgreater (var "i") (int 0)
                                                                          (call (var "sumto") (add (var "i") (int -1)))
                                                                (int 0))))
                                 (int 5)))
                 (int 15) "recursive eval test")
   
   (check-equal? (eval-exp (call (call (fun #f "x" (fun #f "y" (apair (var "x") (var "y")))) (int 1)) (int 2)))
                 (apair (int 1) (int 2))
                 "closure test")
   
   ;; fst and snd tests
   (check-equal? (eval-exp (fst (apair (int 1) (int 2)))) (int 1) "fst test")
   (check-equal? (eval-exp (snd (apair (int 1) (int 2)))) (int 2) "snd test")
   
   ;; isaunit tests
   (check-equal? (eval-exp (isaunit (closure '() (fun #f "x" (aunit))))) (int 0) "isaunit test1")
   (check-equal? (eval-exp (isaunit (aunit))) (int 1) "isaunit test2")
   
   
   ;; ifaunit tests
   (check-equal? (eval-exp (ifaunit (int 1) (int 2) (int 3))) (int 3) "ifaunit test1")
   (check-equal? (eval-exp (ifaunit (aunit) (int 2) (int 3))) (int 2) "ifaunit test2")
   
   ;; mlet* tests
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10))) (var "x"))) (int 10) "mlet* test1")
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10)) (cons "y" (add (var "x") (int 1)))) (var "y"))) (int 11) "mlet* test2")
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10)) (cons "x" (int 0))) (var "x"))) (int 0) "mlet* test3")
   
   ;; ifeq test
   (check-equal? (eval-exp (ifeq (int 1) (int 2) (int 3) (int 4))) (int 4) "ifeq test1")
   (check-equal? (eval-exp (ifeq (int 2) (int 1) (int 3) (int 4))) (int 4) "ifeq test2")
   (check-equal? (eval-exp (ifeq (int 1) (int 1) (int 3) (int 4))) (int 3) "ifeq test3")
   
   ;; mupl-map test
   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 7)))) (apair (int 1) (apair (int 2) (aunit)))))
                 (apair (int 8) (apair (int 9) (aunit))) "mupl-map test")
   ;; mupl-mapAddN test
   (check-equal? (eval-exp (call (call mupl-mapAddN (int 10)) (apair (int 1) (apair (int 2) (aunit)))))
                 (apair (int 11) (apair (int 12) (aunit))) "mupl-mapAddN test")
   
   ;; problems 1, 2, and 4 combined test
   (check-equal? (mupllist->racketlist
   (eval-exp (call (call mupl-mapAddN (int 7))
                   (racketlist->mupllist 
                    (list (int 3) (int 4) (int 9)))))) (list (int 10) (int 11) (int 16)) "combined test")
   
   ))

(require rackunit/text-ui)
;; runs the test
(run-tests tests)
