;; Package configs
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

; Disable windows views
;(menu-bar-mode -1)  
(tool-bar-mode -1) 
;(if (boundp 'fringe-mode)
; (fringe-mode -1))

; Autosave/backup folder
(setq backup-directory-alist '(("." . "~/bak/emacs/")))
(setq auto-save-file-name-transforms '((".*" "~/bak/emacs/" t)))

;; Font for all windows
(when (member "Consolas NF" (font-family-list)) (set-frame-font "Consolas NF-8" t t))
; set fallback font for unicode
(set-fontset-font "fontset-default" nil 
                  (font-spec :size 20 :name "Inconsolata"))

;; Let's set some variables
(setq-default
 auto-image-file-mode 1                       ; Open graphics files
 auto-window-vscroll nil                      ; Lighten vertical scroll
 cursor-in-non-selected-windows nil           ; Hide the cursor in inactive windows
 delete-by-moving-to-trash t                  ; Delete files to trash
 display-time-default-load-average nil        ; Don't display load average
 display-time-format "%H:%M"                  ; Format the time string
 echo-keystrokes 0.1)                         ; Show keystrokes in progress
 frame-title-format '(buffer-file-name "%f" ("%b") ; show full file name in title
 help-window-select t                         ; Focus new help windows when opened
 indent-tabs-mode nil                         ; Stop using tabs to indent
 mouse-yank-at-point t                        ; Yank at point rather than pointer
 recenter-positions '(5 top bottom)           ; Set re-centering positions
 scroll-margin 10                             ; Add a margin when scrolling vertically
 select-enable-clipboard t                     ; Merge system's and Emacs' clipboard
 max-mini-window-height 20                    ; Set minibuffer height
 tab-width 2                                  ; Set width for tabs
 uniquify-buffer-name-style 'forward          ; Uniquify buffer names
 visible-bell t                               ; Blink instead of beep
 window-combination-resize t                  ; Resize windows proportionally
 org-special-ctrl-a/e t                       ; Make org-beginning-of-line and org-end-of-line ignore leading stars or tags on headings
 x-stretch-cursor t)                          ; Stretch cursor to the glyph width

(cd "C:/Users/Peter")                         ; Move to the user directory
(fset 'yes-or-no-p 'y-or-n-p)                 ; Replace yes/no prompts with y/n
(global-subword-mode 1)                       ; Iterate through CamelCase words

(add-hook 'focus-out-hook #'garbage-collect)

(defadvice load-theme (before clear-previous-themes activate)
  "Clear existing theme settings instead of layering them"
  (mapc #'disable-theme custom-enabled-themes))

;; Auto update files if changed outside of emacs
(global-auto-revert-mode t)

;; Enable copy/paste from emacs to other apps
(setq
 interprogram-cut-function 'x-select-text
 interprogram-paste-function 'x-selection-value
 save-interprogram-paste-before-kill t
 select-active-regions t
 x-select-enable-clipboard t
 x-select-enable-primary t)

;; Highlight matching parenthesis
(defvar show-paren-delay)
(setq show-paren-delay 0.0)
(show-paren-mode t)

;; Modeline settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(display-time-mode 1)

;; Recent files
(recentf-mode 1)
(defvar recentf-max-saved-items)
(setq recentf-max-saved-items 200)

;; Remember last position in files
(if (version< emacs-version "25.0")
    (progn (require 'saveplace)
	   (setq-default save-place t))
(save-place-mode 1))

;; Smooth scrolling
(setq scroll-margin 0)
(setq scroll-conservatively 10000)
(setq scroll-preserve-screen-position t)

;; Use UTF-8
;; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
;;(setq utf-translate-cjk-mode nil)
(set-language-environment 'utf-8)
(setq locale-coding-system 'utf-8)
;; set the default encoding system
(prefer-coding-system 'utf-8)
(setq default-file-name-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; backwards compatibility as default-buffer-file-coding-system
;; is deprecated in 23.2.
(if (boundp buffer-file-coding-system)
    (setq buffer-file-coding-system 'utf-8)
  (setq default-buffer-file-coding-system 'utf-8))
;; Treat clipboard input as UTF-8 string first; compound text next, etc.                    
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Highlight current line when not using terminal
(when window-system (add-hook 'prog-mode-hook 'hl-line-mode))

;; Split the previous buffer instead of the current buffer
(defun vsplit-last-buffer ()
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer))
(defun hsplit-last-buffer ()
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer))
(bind-key "C-x 2" 'vsplit-last-buffer)
(bind-key "C-x 3" 'hsplit-last-buffer)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Keybindings
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; BUFFER-SWITCHING
;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)

;; MOVE LINE UP/DOWN
;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

; ibuffer
(autoload 'ibuffer "ibuffer" "List buffers." t)
(global-set-key (kbd "C-x C-b") 'ibuffer)

; kill buffer without question
(global-set-key (kbd "C-x k") 'kill-this-buffer)

; kill all buffers except current one
(global-set-key (kbd "C-x M-k") 'kill-other-buffers)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Themes/Plugins
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; EVIL-MODE
;;;;;;;;;;;;;;;;;;
(use-package evil
  :ensure t
  :config

  (evil-mode 1)
  (use-package evil-leader
    :ensure t
    :config
    (global-evil-leader-mode t)
    (evil-leader/set-leader "<SPC>")
    (evil-leader/set-key
      "s s" 'swiper
      "d x w" 'delete-trailing-whitespace))

  (use-package evil-surround
    :ensure t
    :config (global-evil-surround-mode))

  (use-package evil-indent-textobject
    :ensure t)

  (use-package evil-org
    :ensure t
    :config
    (evil-org-set-key-theme
    '(textobjects insert navigation additional shift todo heading))
    (add-hook 'org-mode-hook (lambda () (evil-org-mode))))
    (evil-define-key 'normal evil-org-mode-map
                 (kbd ">") 'org-metaright
                 (kbd "<") 'org-metaleft)

  (use-package powerline-evil
    :ensure t
    :config
    (powerline-evil-vim-color-theme)))

;; DESKTOP - SAVE BUFFERS WHEN EXITING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package desktop
  :defer nil
  :custom
  (desktop-restore-eager   1 "Restore the first buffer right away")
  (desktop-lazy-idle-delay 1 "Restore the other buffers 1 second later")
  (desktop-lazy-verbose  nil "Be silent about lazily opening buffers")
  :bind
  ("C-M-s-k" . desktop-clear)
  :config
  (desktop-save-mode))

; EYEBROWSE - DIFFERENT WORKSPACES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package eyebrowse
  :init
  (setq eyebrowse-keymap-prefix (kbd "C-c M-e"))
  ;(global-unset-key (kbd "C-c C-w"))
  :config (progn
           (define-key eyebrowse-mode-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
            (define-key eyebrowse-mode-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
            (define-key eyebrowse-mode-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
            (define-key eyebrowse-mode-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
            (define-key eyebrowse-mode-map (kbd "M-5") 'eyebrowse-switch-to-window-config-5)
            (define-key eyebrowse-mode-map (kbd "M-6") 'eyebrowse-switch-to-window-config-6)
  (eyebrowse-mode t)
  (eyebrowse-setup-evil-keys)
  (setq eyebrowse-new-workspace t)))

;; HIGHLIGHT CURRENT LINE
;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package hl-line
  :defer nil
  :config
  (defun zz/get-visual-line-range ()
    (let (b e)
      (save-excursion
        (beginning-of-visual-line)
        (setq b (point))
        (end-of-visual-line)
        (setq e (+ 1 (point)))
        )
      (cons b e)))
  (setq hl-line-range-function #'zz/get-visual-line-range)
  (global-hl-line-mode))

; HIGHTLIGHT NUMBERS/OPERATORS/ESCAPES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package highlight-numbers
  :hook (prog-mode . highlight-numbers-mode))
(use-package highlight-operators
  :hook (prog-mode . highlight-operators-mode))
(use-package highlight-escape-sequences
  :hook (prog-mode . hes-mode))

; IDO INSTEAD OF HELM
; C-n and C-p keybindings
;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ido
  :config
  (ido-mode +1)
  (setq ido-everywhere t
        ido-enable-flex-matching t))
(use-package ido-vertical-mode
  :config
  (ido-vertical-mode +1)
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down))
(use-package ido-completing-read+ :config (ido-ubiquitous-mode +1))
(use-package flx-ido :config (flx-ido-mode +1))

; SMEX - HELP IDO WITH M-X
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package smex
  :bind (
    ("M-x" . smex)
    ("M-x" . smex-major-mode-commands)
    ("C-c C-c M-x" . excute-extended-command))
  :config (smex-initialize))

;; THEME
;;;;;;;;;;;
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

;; UNDO-TREE
;;;;;;;;;;;;;;
(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode 1))

;; NEOTREE
;;;;;;;;;;;;
(use-package neotree
  :ensure t
  :bind (("<f8>" . neotree-toggle)))
(setq neo-theme 'nerd)
;; Every time when the neotree window is opened, let it find current file and jump to node
(setq neo-smart-open t)
;; When running ‘projectile-switch-project’ (C-c p p), ‘neotree’ will change root automatically
(setq projectile-switch-project-action 'neotree-projectile-action)
;; show hidden files
(setq-default neo-show-hidden-files t)
;;;;;;;;;;;;;;;;;;
;; all-the-icons
;;;;;;;;;;;;;;;;;;
; to use with neotree and such to display icons
(use-package all-the-icons
    :ensure t)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;; WHICH KEY
;;;;;;;;;;;;;;
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode))

;; unused options for where to display which-key
;(which-key-setup-minibuffer)
;(which-key-setup-side-window-right)
;(which-key-setup-side-window-bottom)

;; display which key, first try right side and then try bottom
(setq which-key-side-window-location '(bottom right))
(setq which-key-side-window-max-width 0.50)
(setq which-key-side-window-max-height 0.45)
(setq which-key-idle-delay 0.3)
(setq which-key-max-description-length 25)
;; The maximum number of columns to display in the which-key buffer. nil means
;; don't impose a maximum.
(setq which-key-max-display-columns nil)
;; Set the separator used between keys and descriptions. Change this setting to
;; an ASCII character if your font does not show the default arrow. The second
;; setting here allows for extra padding for Unicode characters. which-key uses
;; characters as a means of width measurement, so wide Unicode characters can
;; throw off the calculation.
(setq which-key-separator " → " )
(setq which-key-unicode-correction 3)
;; Set the prefix string that will be inserted in front of prefix commands
;; (i.e., commands that represent a sub-map).
(setq which-key-prefix-prefix "+" )
;; use padding to the left of a column
(setq which-key-add-column-padding 2)

;; centaur-tabs
;; this seems like a great package, but is way too laggy
;; possibly it's just Windows - maybe this would work in WSL
;(use-package centaur-tabs
;  :demand
;  :config
;    :bind
;  ("C-<prior>" . centaur-tabs-backward)
;  ("C-<next>" . centaur-tabs-forward))
;(setq centaur-tabs-style "chamfer"
;      centaur-tabs-set-icons t
;      centaur-tabs-height 32
;      centaur-tabs-gray-out-icons 'buffer
;      centaur-tabs-set-bar 'under
;      centaur-tabs-show-navigation-buttons t
;      x-underline-at-descent-line t
;      centaur-tabs-set-modified-marker t)
;(centaur-tabs-headline-match)
;(centaur-tabs-mode t)
;(define-key evil-normal-state-map (kbd "g t") 'centaur-tabs-forward)
;(define-key evil-normal-state-map (kbd "g T") 'centaur-tabs-backward))
;(:map evil-normal-state-map
;    ("g t" . centaur-tabs-forward)
;    ("g T" . centaur-tabs-backward)))

;; awesome tab
;; great package, also too slow. centaur tab was based off this
;; will try if centaur tab doesn't run well in WSL
;(use-package awesome-tab
;  :load-path "C:/Users/Peter/.emacs.d/elisp/awesome-tab/"
;  :config
;  (awesome-tab-mode t)
;)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Org
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; vertically align text with startup indented
; hide emphasis markers makes /italics/ and *bold*
; org-fontifys make it so that if you change the font / background color
; etc. of the heading / done / quote block / verse block then the change
; shows up for the whole line (across the buffer) instead of just 
; the text
(use-package org
  :custom-face
  (org-document-title ((t (:weight bold :height 1.2))))
  (org-todo ((t (:weight bold))))
  (org-done ((t (:strike-through t :weight bold))))
  (org-headline-done ((t (:strike-through t))))
  (org-level-1 ((t (:weight bold)))); :height 1.3))))
  ;(org-level-2 ((t (:weight normal :height 1.2))))
  ;(org-level-3 ((t (:weight normal :height 1.1))))
  :init 
(setq org-src-fontify-natively t
      org-startup-indented t
      org-pretty-entities t
      org-hide-emphasis-markers t
      org-agenda-block-separator ""
      org-fontify-whole-heading-line t
      org-fontify-done-headline t
      org-fontify-quote-and-verse-blocks t
      org-log-done t))

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq line-spacing 0.1);; Add more line padding for readability
;; set depth of refile
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 2))))

;; Open archive.org
;(global-set-key (kbd "C-c a") 
;                (lambda () (interactive) (find-file "~/blah/org/archive.org")))

(setq org-directory "~/blah/org")
(setq org-agenda-files '("~/blah/org"))
(setq org-agenda-inhibit-startup nil
      org-agenda-show-future-repeats nil
      org-agenda-start-on-weekday nil
      org-agenda-skip-deadline-if-done t
      org-agenda-skip-scheduled-if-done t)

; set states and their colors
(setq org-todo-keywords
  '((sequence 
    "BUY(b)" 
    "EDL(d)" 
    "ELAB(e)" 
    "LOOKUP(l)" 
    "MISC(m)" 
    "TODO(t)" 
    "URGENT(u)" 
    "|" "DONE(z!)" 
    "IRRLV(v!)")))

(setq org-todo-keyword-faces
      '(("BUY" . "cyan") 
        ("EDL" . "purple") 
        ("ELAB" . "magenta")
        ("LOOKUP" . "orange") 
        ("MISC". "lime green") 
        ("TODO" . "red") 
        ("URGENT" . "dodger blue")
        ("DONE" . (:inherit org-done :strike-through t))
        ("IRRLV" . (:inherit org-done :strike-through t))))

;; change task with C-c C-t <KEY>
;; also works with "t" with evil org bindings
(setq org-use-fast-todo-selection t)

; don't truncate lines and enable word wrap
(set-default 'truncate-lines nil)
(set-default 'word-wrap t)
(setq helm-buffers-truncate-lines nil)
(setq org-startup-truncated nil)

;; don't split items when pressing `C-RET'. Always create new item
(setq org-M-RET-may-split-line nil)

;; hide leading stars for headlines
(setq org-hide-leading-stars t)

; don't align tags automatically
(setq org-auto-align-tags nil)

;; fold / overview  - collapse everything, show only level 1 headlines
;; content          - show only headlines
;; nofold / showall - expand all headlines except the ones with :archive:
;;                    tag and property drawers
;; showeverything   - same as above but without exceptions
(setq org-startup-folded 'content)

; make todo's dependent on all subtasks being completed before being marked as done
(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)

;; add a tag to make ordered tasks more visible
(setq org-track-ordered-property-with-tag t)

; set text to match size of box
(add-hook 'org-mode-hook 'visual-line-mode)

;; prettify source code in org mode
(setq org-src-tab-acts-natively t)
(setq org-edit-src-content-indentation 0)
(use-package htmlize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Org-Plugins
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CALFW
;(use-package calfw
  :custom-face
;  (cfw:face-toolbar ((t (:background "midnight blue" :foreground "Steelblue4"))))
;  (cfw:face-toolbar-button-off ((t (:foreground "gray30" :weight bold)))))
;(use-package calfw-org)
;(use-package calfw-ical)
;(use-package calfw-cal)
;(cfw:open-ical-calendar "https://calendar.google.com/calendar/ical/pwertz%40gmail.com/private-03dbf528d925fa0b341dbe367c9763b0/basic.ics")

;; ORG-AGENDA
(use-package org-agenda
  :ensure nil
  :after org
  :custom
  (org-agenda-include-diary t)
  (org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t% s")
                              ;; Indent todo items by level to show nesting
                              (todo . " %i %-12:c%l")
                              (tags . " %i %-12:c")
                              (search . " %i %-12:c")))
  (org-agenda-start-on-weekday nil))

;; ORG-ARCHIVE
; not working, and need to redo for new setup
;(use-package org-archive
;  :ensure nil
;  :custom
;  (setq org-archive-location "archive.org::datetree/"))

(setq org-default-notes-file "~/blah/org/archive.org")
(setq org-capture-templates
      '(("b" "Buy" entry (file+olp org-default-notes-file "Buy")
        "* BUY %?\n")
       ("d" "Daily" entry (file+datetree "~/blah/org/daily.org")
        "** %U - %?\n")
       ("l" "Lookup" entry (file+olp org-default-notes-file "Lookup")
        "* LOOKUP %?\n")
       ("n" "Note" entry (file+olp org-default-notes-file "Scratch")
        "* %?\n")
       ("t" "Todo" entry (file+olp org-default-notes-file "Todo")
        "* TODO %?\n")))

;; ORG_CAPTURE
;; Example Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
;(setq org-capture-templates
;      (quote (("t" "todo" entry (file "~/git/org/refile.org")
;               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
;              ("r" "respond" entry (file "~/git/org/refile.org")
;               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
;              ("n" "note" entry (file "~/git/org/refile.org")
;               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
;              ("j" "Journal" entry (file+datetree "~/git/org/diary.org")
;               "* %?\n%U\n" :clock-in t :clock-resume t)
;              ("w" "org-protocol" entry (file "~/git/org/refile.org")
;               "* TODO Review %c\n%U\n" :immediate-finish t)
;              ("m" "Meeting" entry (file "~/git/org/refile.org")
;               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
;              ("p" "Phone call" entry (file "~/git/org/refile.org")
;               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
;              ("h" "Habit" entry (file "~/git/org/refile.org")
;               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;; ORG-CLIPLINK
(global-set-key (kbd "C-x p i") 'org-cliplink)

;; ORG-ELLIPSIS
;(setq org-ellipsis "⬎");
;; icon is faded and unable to be seen?

;; ORG-INDENT
(use-package org-indent
  :ensure nil
  :diminish
  :custom
  (org-indent-indentation-per-level 4))

; ORG-BULLETS
; package isn't working for some reason - it worked in earlier versions of emacs but as soon as I updated to 27 then it would no longer display the first few custom bullets
;(use-package org-bullets
;  :config
;  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
;; make available "org-bullet-face" such that I can control the font size individually
;  (setq org-bullets-face-name (quote org-bullet-face))
;  (setq org-bullets-bullet-list '("⭗" "⭘" "◉" "●" "○" "•" "▶" "►" "▸"))
;  (setq org-bullets-bullet-list '(“⚫” “⚪” "◉" “◯” "⭗" "●" "⭘" “⊙” "●" "○" "•" "▶" "►" "▸"))

; REPLACE -/+ WITH BULLETS
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([+]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "◦"))))))

; Original - requires space before "-"
;(font-lock-add-keywords 'org-mode
;                        '(("^ *\\([-*]\\) "
;                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; ORG-RIFLE
(use-package helm-org-rifle
  :bind ("C-c o" . helm-org-rifle))

;; ORG-SUPER-AGENDA
(use-package org-super-agenda
  :defer nil
  :custom
  (org-super-agenda-groups '((:auto-dir-name t)))
  :config
  (org-super-agenda-mode))

;; TOC-ORG
;; Maintains a TOC at the first heading that has a :TOC: tag.
(use-package toc-org
  :ensure t
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))
(add-to-list 'org-tag-alist '("TOC" . ?T))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("855eb24c0ea67e3b64d5d07730b96908bac6f4cd1e5a5986493cbac45e9d9636" default)))
 '(desktop-lazy-idle-delay 1)
 '(desktop-lazy-verbose nil)
 '(desktop-restore-eager 1)
 '(display-battery-mode t)
 '(display-time-mode t)
 '(package-selected-packages
   (quote
    (org-sidebar calfw-cal calfw-ical calfw-org calfw htmlize which-key use-package org-bullets doom-themes)))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cfw:face-toolbar ((t (:background "midnight blue" :foreground "Steelblue4"))))
 '(cfw:face-toolbar-button-off ((t (:foreground "gray30" :weight bold))))
 '(org-document-title ((t (:weight bold :height 1.2))))
 '(org-done ((t (:strike-through t :weight bold))))
 '(org-headline-done ((t (:strike-through t))))
 '(org-level-1 ((t (:weight bold))))
 '(org-todo ((t (:weight bold)))))
