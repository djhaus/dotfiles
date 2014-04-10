; Initialize some variables that may be used later

(setq running-linux nil)
(setq running-unix nil)
(setq running-windows nil)
(setq running-osx nil)
(setq running-dos nil)
(setq running-cygwin nil)

; Determine which version of Emacs we're using

(setq running-xemacs (string-match "Lucid" emacs-version))
(setq running-emacs-19 (>= emacs-major-version 19))
(setq running-fsf-emacs-19 (and running-emacs-19 (not running-xemacs)))
(setq running-emacs-18 (< emacs-major-version 19))

; Determine if we're running X-Windows 

(setq running-x (eq window-system 'x))

; Set the window height on windowed systems

(if (window-system)
  (set-frame-height (selected-frame) 50))

; Determine which operating system we are running on

(if (string-equal system-type "gnu/linux")
    (setq running-linux t))
(if (string-equal system-type "usg-unix-v")
    (setq running-unix t))
(if (string-equal system-type "windows-nt")
    (setq running-windows t))
(if (string-equal system-type "darwin")
    (setq running-osx t))
(if (string-equal system-type "ms-dos")
    (setq running-dos t))
(if (string-equal system-type "cygwin")
    (setq running-cygwin t))

; Disable the Emacs splash/startup stuff

(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

; Don't follow symlinks for version controlled files this ensures
; that the proper major mode is selected for editing files

(setq vc-follow-symlinks nil)

; Enable automatic copy on selection

(setq mouse-drag-copy-region t)

; When using the mouse wheel to scroll only move 1 line at a time
(setq mouse-wheel-scroll-amount '(1))

; Use progressive mouse whell scrolling
(setq mouse-wheel-progressive-speed nil)

; Set the default face foreground and background colors

;(set-face-background 'default "black")
;(set-face-foreground 'default "grey70")

; Load Clearcase support only on Emacs versions 21.x.x on UNIX systems

;(cond (running-unix
;       (if (>= emacs-major-version 21)
;	   (require 'clearcase))))

; Load Cscope frontend on Emacs versions 21.x.x on UNIX systems

;(cond (running-unix
;       (if (>= emacs-major-version 21)
;	 (require 'xcscope))))


; Set the load path to the emacs directory in the user's home directory

(add-to-list 'load-path "~/emacs")

; Configue conservative scrolling so that the cursor doesn't jump
; back to the center line of the window after scolling up/down by a
; large number of lines

(setq scroll-conservatively 10000)

; Don't add newlines at the end of the file when hitting down arrow

(setq next-line-add-newlines nil)

; Turn off beeping/flashing alarms

;(setq visible-bell nil)
(setq ring-bell-function 'ignore)

; Set the autosave directory and save file prefix

(setq auto-save-list-file-prefix "~/autosave/saves-")

; Turn autosave on
(setq auto-save-mode t)

; Set the backup file directory 
(setq backup-directory-alist `(("." . "~/autosave")))

; Set backup mode to copy the file

(setq backup-by-copying t)

; Save multiple backup file versions
 
(setq delete-old-versions t)

; Compilation related

(setq compilation-scroll-output t)
(setq compilation-window-height 20)

; Re-map home and end keys to jump to start and end of line

(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)

; Re-map CTRL-HOME and CTRL-END to jump to start and end of file

(global-set-key [C-home] 'beginning-of-buffer)
(global-set-key [C-end] 'end-of-buffer)

; On Apple keyboards they are usually missing the home and end
; keys so make some simple aliases for the functions the get
; us to the beginning of the buffer and end of the buffer

(defalias 'home 'beginning-of-buffer)
(defalias 'end 'end-of-buffer)

; Re-map CTRL-J to jump to a specific line number

(global-set-key "\C-j" 'goto-line)

; Keybindings for my custom functions

;(global-set-key [f3] 'my-find-tag)
;(global-set-key [f4] 'next-find-tag)
(global-set-key [f5] 'mparen)
(global-set-key [f6] 'c-inside)
(global-set-key [f7] 'match-paren)

; When run on a Mac map the help key to be insert

;(cond (running-osx
;       (global-set-key [help] 'overwrite-mode)))

(global-set-key [help] 'overwrite-mode)

; Allow selected text to be deleted by pressing the delete key

;(cond (running-fsf-emacs-19
(delete-selection-mode t)
;      (running-xemacs
(pending-delete-mode t)

; Show line and column number in the mode line

(line-number-mode t)
(column-number-mode t)

; Show the current time in the mode line

;(display-time)

; Show the name of the current function in the mode line

(which-func-mode 1)
(setq which-func-maxout 0)

; Show matching parenthesises
;(show-paren-mode 1)

; Set the size of the font-lock buffer

(setq font-lock-maximum-size 1024000)

; Mouse scrolling

;(defun up-slightly ()
;  (interactive) 
;  (scroll-up 5))

;(defun down-slightly ()
;  (interactive)
;  (scroll-down 5))

;(global-set-key [mouse-4] 'down-slightly)
;(global-set-key [mouse-5] 'up-slightly)
 
;(defun up-one ()
;  (interactive)
;  (scroll-up 1))

;(defun down-one ()
;  (interactive)
;  (scroll-down 1))

;(global-set-key [S-mouse-4] 'down-one)
;(global-set-key [S-mouse-5] 'up-one)
 
;(defun up-a-lot ()
;  (interactive)
;  (scroll-up))

;(defun down-a-lot ()
;  (interactive)
;  (scroll-down))

;(global-set-key [C-mouse-4] 'down-a-lot)
;(global-set-key [C-mouse-5] 'up-a-lot)


; Turn syntax highlighting on when editing source code

(add-hook 'emacs-lisp-mode-hook 'turn-on-font-lock)
(add-hook 'lisp-mode-hook       'turn-on-font-lock)
(add-hook 'c-mode-hook          'turn-on-font-lock)
(add-hook 'c++-mode-hook        'turn-on-font-lock)
(add-hook 'java-mode-hook       'turn-on-font-lock)
(add-hook 'perl-mode-hook       'turn-on-font-lock)
(add-hook 'tcl-mode-hook        'turn-on-font-lock)
(add-hook 'makefile-mode-hook   'turn-on-font-lock)
(require 'font-lock)

; Set font lock colors for Emacs and Xemacs

(cond (running-fsf-emacs-19
      (make-face 'my-red-face)
      (set-face-foreground 'my-red-face "red")
      (make-face 'my-green-face)
      (set-face-foreground 'my-green-face "limegreen")
      (make-face 'my-blue-face)
      (set-face-foreground 'my-blue-face "DeepSkyBlue")
      (make-face 'my-magenta-face)
      (set-face-foreground 'my-magenta-face "magenta")
      (make-face 'my-greenyellow-face)
      (set-face-foreground 'my-greenyellow-face "GreenYellow")
      (make-face 'my-yellow-face)
      (set-face-foreground 'my-yellow-face "Yellow")
      (make-face 'my-CornFlowerBlue-face)
      (set-face-foreground 'my-CornFlowerBlue-face "CornFlowerBlue")
      (make-face 'my-FireBrick-face)
      (set-face-foreground 'my-FireBrick-face "FireBrick")
      (set-face-foreground 'font-lock-function-name-face "Red")
      (set-face-foreground 'font-lock-comment-face "LimeGreen")
      (set-face-foreground 'font-lock-string-face "SkyBlue")
      (set-face-foreground 'font-lock-keyword-face "Red")
;     (set-face-foreground 'font-lock-doc-string-face "SkyBlue")
      (set-face-foreground 'font-lock-type-face "Magenta")
      (set-face-foreground 'font-lock-variable-name-face "Brown")
;     (set-face-foreground 'font-lock-reference-face "CadetBlue")
;     (set-face-foreground 'font-lock-preprocessor-face "CornFlowerBlue")
      (set-border-color "Grey70")
      (set-mouse-color "Yellow")
      (set-cursor-color "White")
      (set-background-color "Black")
      (set-foreground-color "Grey70"))
      (running-xemacs
      (set-face-foreground 'font-lock-function-name-face "Red")
      (set-face-foreground 'font-lock-comment-face "LimeGreen")
      (set-face-foreground 'font-lock-string-face "SkyBlue")
      (set-face-foreground 'font-lock-keyword-face "Red")
      (set-face-foreground 'font-lock-doc-string-face "SkyBlue")
      (set-face-foreground 'font-lock-type-face "Magenta")
      (set-face-foreground 'font-lock-variable-name-face "Brown")
      (set-face-foreground 'font-lock-reference-face "CadetBlue")
      (set-face-foreground 'font-lock-preprocessor-face "CornFlowerBlue")))

; My-Find-Tag

(defun my-find-tag ()
  ""
  (interactive)
  (split-window)
  (call-interactively(function find-tag)))

; Next-Find-Tag

(defun next-find-tag ()
  ""
  (interactive)
  (split-window)
  (find-tag last-tag t))

; Function to get date

(defun get-date()
  ""
  (interactive)
  (shell-command "date" 1)
  (end-of-line)
  (kill-line))

; Function to customize identation for C source code

(defun my-c-mode-common-hook ()
  (c-set-style "BSD")
  (column-number-mode 1)
  (setq c-auto-newline nil)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4))

; Function to customize identation for C source code

(defun my-c++-mode-common-hook ()
  (c-set-style "BSD")
  (column-number-mode 1)
  (setq c-auto-newline nil)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4))

; Run customized indentation functions for major modes

(add-hook 'c-mode-hook 'my-c-mode-common-hook)
(add-hook 'c++-mode-hook 'my-c++-mode-common-hook)

; Function to find matching parenthesis

(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

; Insert source file header description

(defun insert-file-header ()
  ""
  (interactive) 
  (setq lw_file (buffer-name))
  (setq tdate (shell-command-to-string "date +%C%y"))
  (setq tyear (shell-command-to-string "date +%Y"))
  (setq myname (shell-command-to-string "echo $USER" )) 
  (insert-string "/*****************************************************************************/\n")
  (insert-string "/**\n")
  (insert-string " *\n")

  (insert-string " * @file: ")
  (insert-string lw_file)
  (insert-string "\n")

  (insert-string " * This file defines all of the source code for the <fill-in name> component.\n")
  (insert-string " *\n")
  (insert-string " *\n")
  (insert-string " *\n")
  (insert-string " *//* Copyright ") (insert-string tyear) (delete-backward-char 1) (insert-string " ")
  (insert-string "Motorola, Inc.\n")
  (insert-string " *\n")
  (insert-string " * This program is confidential and proprietary to Motorola, Inc. and, without\n")
  (insert-string " * the express prior written permission of an officer of Motorola, may not be\n")
  (insert-string " * copied, reproduced, disclosed to others, published or used, in whole or in\n")
  (insert-string " * part, for any purpose other than that for which it is being made available.\n")
  (insert-string " * This program is protected pursuant to applicable copyright laws, including\n")
  (insert-string " * the U.S. Copyright Act. This program is to be returned to Motorola upon the\n")
  (insert-string " * earlier of demand and the accomplishment of the purpose for which it was\n")
  (insert-string " * provided.\n")
  (insert-string " *\n")
  (insert-string " *****************************************************************************/\n")
  (insert-string "\n")
)

; Insert function header

(defun insert-function-header () 
  ""
  (interactive) 
  (insert-string "/******************************************************************************\n")
  (insert-string " *\n")
  (insert-string " * FunctionNameGoesHere()\n")
  (insert-string " */\n")
  (insert-string "/**\n")
  (insert-string " * @brief Short verb phrase describing function goes here.\n")
  (insert-string " *\n")
  (insert-string " * @details Detailed description of function and it's use goes here.\n")
  (insert-string " *\n")
  (insert-string " * @param[in] inputVariableName1 - Description of variable1 goes here.\n")
  (insert-string " * @param[in] inputVariableName2 - Description of variable2 goes here.\n")
  (insert-string " * @param[in] inputVariableName2 - Description of variable3 goes here.\n")
  (insert-string " * @param[out] outputVariableName - Description of variable goes here.\n")
  (insert-string " * @param[inout] inOutVariableName - Description of variable passed by reference and modified.\n")
  (insert-string " *\n")
  (insert-string " * @return OK or ERROR\n")
  (insert-string " *\n")
  (insert-string " */\n")
  (insert-string "/*****************************************************************************/\n")
  (insert-string "\n")
)

; Function to insert code review text

(defun insert-code-review ()
  ""
  (interactive) 
  (insert-string "Code review: results stored in CR <CR number>\n")
  (insert-string "Code review: not needed since this is a minor change\n")
)

; Function checks if this line of C is inside an outer "if", "while", etc...

(defun c-inside ()
  "Check current line of C code is inside an outer if, while, etc..." 
  (interactive)
  (savehere)
  (message "Searching...")
  (setq lchr "{") (setq rchr "}")
  (backward-char) (setq cnt 1)
  (while (and (> cnt 0) (not (= (point) (point-min))))
    (progn
      (if (looking-at lchr)
	  (setq cnt (- cnt 1))
	)
      (if (looking-at rchr)
	  (setq cnt (+ cnt 1))
	)
      (backward-char)
      )
    )
  
  (if (= (point) (point-min) )
      (progn
	(gothere) (error "Line is not inside outer C block") 
	)
    (progn
      (forward-char)
      (message "Line is inside outer C block")
      )
    )
)

; Function to perform a search within a function, eg to find a variable
; inside the current function where the cursor is located

(defun c-narrow-to-function ()
  "Limit view to current function of the current file"
  (interactive)
  (setq save1 (point))
  (c-beginning-of-defun 1)
  (c-beginning-of-statement 1)
  (setq save2 (point))
  (c-end-of-defun 1)
  (setq save3 (point))
  (narrow-to-region save2 save3)
  (goto-char save1)
)

(defun c-widen ()
  "Undo narrowing of current file"
  (interactive)
  (widen)
)

(defun reload-dot-emacs ()
  "Reload the .emacs file from user's home directory"
  (interactive)
  (load-file "~/.emacs")
)

(defun c-print-defun-name ()
  "Find the name of the function you are in"
  (interactive)
  (save-excursion
    (c-beginning-of-defun 1)
    (end-of-line 0)
    (let ((end (point)))
      (c-beginning-of-statement)
      (let ((start (point)))
        (setq string (buffer-substring start end))
        (message "%s" string))))
)

; Function to save current position

(defun savehere ()
  "Save cursor position" (interactive)
  (setq save1 (point))
)

; Function to go to saved cursor position

(defun gothere ()
  "Go to saved cursor position"
  (interactive) (goto-char save1)
)


(defun mfparen (lchr rchr)
  (setq totalch 0)
  (forward-char) (setq cnt 1)
  (while (> cnt 0)
    (progn
      (if (looking-at lchr)
	  (setq cnt (+ cnt 1))
	)
      (if (looking-at rchr)
	  (setq cnt (- cnt 1))
	)
      (forward-char) (setq totalch (+ totalch 1))
      )
    )
  (backward-char) (setq totalch (- totalch 1))
  (if (looking-at "\"")
      (message (concat "Characters: "  (int-to-string totalch)))
    )
)

(defun mbparen (lchr rchr)
  (backward-char) (setq cnt 1)
  (while (> cnt 0)
    (progn
      (if (looking-at lchr)
	  (setq cnt (- cnt 1))
	)
      (if (looking-at rchr)
	  (setq cnt (+ cnt 1))
	)
      (backward-char)
      )
    )
  (forward-char)
)

; FINDIF- internal to "mparen, used to search backward for matching #if

(defun findif()
  (while (> cnt 0)
    (progn
      (if (re-search-backward "^#[ie][fn]" nil t) 
	  (progn
	    (forward-char)
	    (if (looking-at "i")
		(progn
		  (forward-char)
		  (if (looking-at "f")
		      (setq cnt (- cnt 1))
		    )
		  )
	      (setq cnt (+ cnt 1))
	      )
	    )
	(setq cnt -1)
	)
      )
    )
  (beginning-of-line)
  )

; FINDENDELSE - internal to "mparen, used to search forward for #else, #end

(defun findendelse()
  (while (> cnt 0)
    (progn
      (re-search-forward "^#[ie][fln]") (search-backward "#") (forward-char)
      (if (looking-at "i")
	  (progn
	    (forward-char)
	    (if (looking-at "f")
		(setq cnt (+ cnt 1))
	      )
	    )
	(progn
	  (forward-char) 
	  (if (looking-at "n")
	      (setq cnt (- cnt 1))
	    )
	  (if (and (looking-at "l") (= cnt 1))
	      (setq cnt (- cnt 1))
	    )
	  )
        )
      )
    )
  (beginning-of-line)
)

; MCONDIT- internal to "mparen", used to match #if, #else, #end

(defun mcondit ()
  (setq cnt 1)
  (forward-char) 
  (if (looking-at "i")
      (findendelse)
    (progn
      (forward-char)
      (if (looking-at "l")
	  (findendelse)
	(findif)
	(if (< cnt 0)
	    (progn
	      (message "No matching #if statment")
	      (gothere)
	      )
	  )
	)
      )
    )
  
  )

; CHKCONDIT- check if current C line is within an #if conditioal

(defun chkcondit ()
  (setq cnt 1) (findif)
  (if (< cnt 0)
      (progn
	(message "Not inside #if block")
	(gothere)
	)
    (message "Inside #if block")
    )
  
  )

; MPAREN:      Match parenthesis, brace, #if.  
;        <or> If on a quote, count length of string.
;        <or> If anything else, test if within a #if conditional.

(defun mparen ()
  "match parenthesis, brace, #if"
  (interactive)
  (savehere)
  (if (looking-at "(" )
      (mfparen "(" ")")
    (if (looking-at "{")
        (mfparen "{" "}")
      (if (looking-at ")")
          (mbparen "(" ")")
	(if (looking-at "}")
            (mbparen "{" "}")
	  (if (looking-at "\"")
              (mfparen (int-to-string 27) "\"")
	    (if (looking-at "#")
                (mcondit)
	      (chkcondit)
              )
            )
          )
        )        
      )
    )
)

