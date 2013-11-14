;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

; Q1
(define (racketlist->mupllist xs)
  (if (null? xs)
      (aunit)
      (apair (car xs) (racketlist->mupllist (cdr xs)))))

(define (mupllist->racketlist ms)
  (if (aunit? ms)
      null
      (cons (apair-e1 ms) (mupllist->racketlist (apair-e2 ms)))))

;; lookup a variable in an environment
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (define (get-pair e)
    (let ([v (eval-under-env e env)])
           (if (apair? v)
               v
               (error "MUPL expression is not a pair"))))
    
  (cond [(var? e)
         (envlookup env (var-string e))]
        [(int? e) e]
        [(closure? e) e]
        [(aunit? e) e]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (eval-under-env (ifgreater-e3 e) env)
                   (eval-under-env (ifgreater-e4 e) env))
               (error "MUPL ifgreater applied to a non-number")))]
        [(mlet? e)
         (let ([var (mlet-var e)]
               [val (eval-under-env (mlet-e e) env)])
           (eval-under-env (mlet-body e) (cons (cons var val)
                                               env)))]
        [(apair? e)
         (apair (eval-under-env (apair-e1 e) env)
                (eval-under-env (apair-e2 e) env))]
        [(fst? e)
         (apair-e1 (get-pair (fst-e e)))]
        [(snd? e)
         (apair-e2 (get-pair (snd-e e)))]
        [(isaunit? e)
         (let ([v (eval-under-env (isaunit-e e) env)])
           (int (if (aunit? v) 1 0)))]
        [(fun? e) (closure env e)]
        [(call? e)
         (let ([cl (eval-under-env (call-funexp e) env)]
               [param (eval-under-env (call-actual e) env)])
           (let ([cenv (closure-env cl)]
                 [fun (closure-fun cl)])
             (let ([fname (fun-nameopt fun)]
                   [fargname (fun-formal fun)]
                   [fbody (fun-body fun)])
               (let ([extenv (cons (cons fargname param)
                                   (if fname
                                       (cons (cons fname cl) cenv)
                                       cenv))])
                 (eval-under-env fbody extenv)))))]
        [#t (error "Unrecognised MUPL expression")]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

(define (ifaunit e1 e2 e3) (ifgreater (isaunit e1) (int 0) e2 e3))

(define (mlet* lstlst e2)
  (if (null? lstlst) e2
      (let ([var (caar lstlst)] ;first element in first pair
            [expr (cdar lstlst)]) ;second element in first pair
        (mlet var expr (mlet* (cdr lstlst) e2)))))

(define (ifeq e1 e2 e3 e4)
  (mlet* (list (cons "_x" e1) (cons "_y" e2))
         (ifgreater (var "_x") (var "_y") e4
                    (ifgreater (var "_y") (var "_x") e4 e3))))


;; Problem 4

(define mupl-map
  (fun #f "fn" (fun "map" "lst"
                    (ifaunit (var "lst")
                             (aunit)
                             (apair (call (var "fn") (fst (var "lst"))) (call (var "map") (snd (var "lst"))))))))

(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun #f "i" (call (var "map") (fun #f "x" (add (var "i") (var "x")))))))


;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

; given a MUPL expression return a new MUPL expression
; where fun is replaced by fun-challenge.
(define (compute-free-vars e)
  ; given a function expression get free vars (gfv).
  (define (gfv shadowed-vars e)
    (cond [(var? e) (set-subtract (set (var-string e)) shadowed-vars)]
          [(add? e) (set-union
                     (gfv shadowed-vars (add-e1 e))
                     (gfv shadowed-vars (add-e2 e)))]
          [(ifgreater? e) (set-union
                           (gfv shadowed-vars (ifgreater-e1 e))
                           (gfv shadowed-vars (ifgreater-e2 e))
                           (gfv shadowed-vars (ifgreater-e3 e))
                           (gfv shadowed-vars (ifgreater-e4 e)))]
          [(call? e) (set-union (gfv shadowed-vars (call-funexp e))
                                (gfv shadowed-vars (call-actual e)))]
          [(mlet? e) (set-union
                      (gfv shadowed-vars (mlet-e e))
                      (gfv (set-add shadowed-vars (mlet-var e)) (mlet-body e)))]
          [(apair? e) (set-union
                       (gfv shadowed-vars (apair-e1 e))
                       (gfv shadowed-vars (apair-e2 e)))]
          [(fun? e) (set-subtract (gfv (set (fun-formal e)) (fun-body e))
                                  (set (fun-nameopt e)
                                       (fun-formal e)))]
          [(fst? e) (gfv shadowed-vars (fst-e e))]
          [(snd? e) (gfv shadowed-vars (snd-e e))]
          [(isaunit? e) (gfv shadowed-vars (isaunit-e e))]
          [#t (set)]))
     
    (cond [(fun? e)
           (fun-challenge (fun-nameopt e)
                          (fun-formal e)
                          (compute-free-vars (fun-body e))
                          (gfv (set) e))]
          [(mlet? e)
           (mlet (mlet-var e) 
                 (compute-free-vars (mlet-e e))
                 (compute-free-vars (mlet-body e)))]
          [(ifgreater? e)
           (ifgreater (ifgreater-e1 e)
                      (ifgreater-e2 e)
                      (compute-free-vars (ifgreater-e3 e))
                      (compute-free-vars (ifgreater-e4 e)))]
          [(apair? e)
           (apair (compute-free-vars (apair-e1 e)) (compute-free-vars (apair-e2 e)))]
          [(add? e)
           (add (compute-free-vars (add-e1 e)) (compute-free-vars (add-e2 e)))]
          [(call? e)
           (call (compute-free-vars (call-funexp e)) (compute-free-vars (call-actual e)))]
          [(fst? e)
           (fst (compute-free-vars (fst-e e)))]
          [(snd? e)
           (snd (compute-free-vars (snd-e e)))]
          [(isaunit? e)
           (isaunit (compute-free-vars (isaunit-e e)))]
          [#t e]))
  
;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env)
    (define (get-pair e)
    (let ([v (eval-under-env-c e env)])
           (if (apair? v)
               v
               (error "MUPL expression is not a pair"))))
    
  (cond [(var? e)
         (envlookup env (var-string e))]
        [(int? e) e]
        [(closure? e) e]
        [(aunit? e) e]
        [(add? e) 
         (let ([v1 (eval-under-env-c (add-e1 e) env)]
               [v2 (eval-under-env-c (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(ifgreater? e)
         (let ([v1 (eval-under-env-c (ifgreater-e1 e) env)]
               [v2 (eval-under-env-c (ifgreater-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (eval-under-env-c (ifgreater-e3 e) env)
                   (eval-under-env-c (ifgreater-e4 e) env))
               (error "MUPL ifgreater applied to a non-number")))]
        [(mlet? e)
         (let ([var (mlet-var e)]
               [val (eval-under-env-c (mlet-e e) env)])
           (eval-under-env-c (mlet-body e) (cons (cons var val)
                                               env)))]
        [(apair? e)
         (apair (eval-under-env-c (apair-e1 e) env)
                (eval-under-env-c (apair-e2 e) env))]
        [(fst? e)
         (apair-e1 (get-pair (fst-e e)))]
        [(snd? e)
         (apair-e2 (get-pair (snd-e e)))]
        [(isaunit? e)
         (let ([v (eval-under-env-c (isaunit-e e) env)])
           (int (if (aunit? v) 1 0)))]
        [(fun-challenge? e)
         (closure (set-map (fun-challenge-freevars e) (lambda (var) (assoc var env)))
                  e)]
        [(call? e)
         (let ([cl (eval-under-env-c (call-funexp e) env)]
               [param (eval-under-env-c (call-actual e) env)])
           (let ([cenv (closure-env cl)]
                 [fun (closure-fun cl)])
             (let ([fname (fun-challenge-nameopt fun)]
                   [fargname (fun-challenge-formal fun)]
                   [fbody (fun-challenge-body fun)])
               (let ([extenv (cons (cons fargname param)
                                   (if fname
                                       (cons (cons fname cl) cenv)
                                       cenv))])
                 (eval-under-env-c fbody extenv)))))]
        [#t (error "Unrecognised MUPL expression " e)]))

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
