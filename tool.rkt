#lang racket/unit

(require drracket/tool
         racket/gui/base
         racket/class
         "preferences.rkt")

(import drracket:tool^)
(export drracket:tool-exports^)

(define workspace-mixin
  (mixin (drracket:unit:frame<%>) ()
    (super-new)

    (inherit open-in-new-tab
             get-tabs)

    (define/override (file-menu:between-open-and-revert file-menu)
      (super file-menu:between-open-and-revert file-menu)
      (set! workspace-menu
            (new menu%
                 [parent file-menu]
                 [label "Workspaces"]))
      (populate-menu-items workspace-menu)
      (new separator-menu-item% [parent file-menu]))

    (define/private (populate-menu-items menu)
      (for ([i (in-naturals 1)]
            [ws (in-list (get-workspaces))])
        (new menu-item%
             [parent menu]
             [label (format "~a: ~a" i (workspace-name ws))]
             [callback
              (λ (i e)
                (for ([filename (in-list (workspace-filenames ws))])
                  (open-in-new-tab filename)))]))
      (new separator-menu-item% [parent menu])
      (new menu-item%
           [parent menu]
           [label "Save Tabs as New Workspace"]
           [callback
            (λ (i e)
              (define filenames (get-filenames-from-tabs (get-tabs)))
              (cond
                [(null? filenames)
                 (message-box "Workspaces"
                              "No saved file open, cannot add workspace.")]
                [else
                 (define name
                   (get-text-from-user "Workspaces"
                                       "Workspace Name"))
                 (when name
                   (add-workspace (workspace name filenames))
                   (reload-menu workspace-menu))]))])
      (new menu-item%
           [parent menu]
           [label "Print Saved Workspaces"]
           [callback
            (λ (i e)
              (message-box "Workspace" (format "~a" (get-workspaces))))])
      (new menu-item%
           [parent menu]
           [label "Clear Workspaces"]
           [callback (λ (i e)
                       (clear-workspaces)
                       (reload-menu workspace-menu))]))

    ; TODO: Make reload-menu a callback so menu gets reloaded whenever
    ; preference is changed.
    (define/private (reload-menu menu)
      (clear-menu-items menu)
      (populate-menu-items menu))
    (define/private (clear-menu-items menu)
      (for ([item (in-list (send menu get-items))])
        (send item delete)))))

(define (get-filenames-from-tabs tabs)
  (filter values
          (map
           (λ (tab)
             (define tab-def (send tab get-defs))
             (path->string (send tab-def get-filename)))
           tabs)))

; Variable to hold workspace-menu so we can reference it later to delete
; of its children when reloading the menu after making a change. I could
; not make this internal to my mixin. When I tried, it threw something
; like "cannot assign to a field before initialization". This is probably
; because we are using a mixin.
(define workspace-menu #f)

; It doesn't seem possible to store structs in preferences, although
; I am not sure where this is documented. Whenever I store things like
; a Path or a struct, preference changes disappear upon restarting
; DrRacket. So, for now, we are storing workspaces as the list
; '(name (listof filenames))
(define (workspace-name ws) (car ws))
(define (workspace-filenames ws) (car (cdr ws)))
(define (workspace name filenames) (list name filenames))

(define (phase1) (void))
(define (phase2) (void))

; This is required if we want to use preferences
(workspace-preference-set-default)
(drracket:get/extend:extend-unit-frame workspace-mixin)
