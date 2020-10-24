#lang racket/base

(require framework/preferences)

(provide (all-defined-out))

(define workspaces-pref 'drracket:workspaces)
(define (workspace-preference-set-default)
  (preferences:set-default workspaces-pref '() list?))
(define (get-workspaces)
  (preferences:get workspaces-pref))
(define (set-workspaces ws-l)
  (preferences:set workspaces-pref ws-l))
(define (clear-workspaces)
  (set-workspaces '()))
(define (add-workspace ws)
  (define current-workspaces (get-workspaces))
  (set-workspaces (cons ws current-workspaces)))
