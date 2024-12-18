;;; erlang-ts.el --- Major modes for editing and running Erlang -*- lexical-binding: t; -*-
;; %CopyrightBegin%
;;
;; Copyright Ericsson AB 2024. All Rights Reserved.
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.
;;
;; %CopyrightEnd%
;;

;; Introduction:
;; ------------
;; Currently handles font-locking for erlang-mode
;;
;; Devs See:
;;    M-x treesit-explore-mode
;; and also
;;   (info "(elisp) Parsing Program Source")

(require 'treesit)
(require 'erlang)


(defvar erlang-ts-keywords erlang-keywords)

(defvar erlang-ts-font-lock-rules
  '(;; HTML font locking
    :language erlang
    :feature string
    ((string) @font-lock-string-face)

    :language erlang
    :feature comment
    ((comment) @font-lock-comment-face)

    :language erlang
    :feature variable
    ((var) @font-lock-variable-name-face)

    :language erlang
    :feature keyword
    ;;([,@erlang-ts-keywords] @font-lock-keyword-face)
    ("when" @font-lock-keyword-face)

    ;; :language erlang
    ;; :feature operator
    ;; ([,@erlang-operators] @font-lock-operator-face)

    ;; :language erlang
    ;; :feature builtin
    ;; ([,@erlang-guards @erlang-int-bifs] @font-lock-builtin-face)

    )
    ;; ((script_element
    ;;   [(start_tag (tag_name) @font-lock-doc-face)
    ;;    (end_tag (tag_name) @font-lock-doc-face)]))

    ;; :language html
    ;; :feature tag
    ;; ([(start_tag (tag_name) @font-lock-function-call-face)
    ;;   (self_closing_tag (tag_name) @font-lock-function-call-face)
    ;;   (end_tag (tag_name)  @font-lock-function-call-face)])
    ;; :language html
    ;; :override t
    ;; :feature tag
    ;; ((doctype) @font-lock-keyword-face))
  )

(defun erlang-ts-setup ()
  "Setup treesit for erlang"

  (setq-local treesit-font-lock-settings
              (apply #'treesit-font-lock-rules
                     erlang-ts-font-lock-rules))

  (setq-local font-lock-defaults nil)
  (setq-local treesit-font-lock-feature-list
              '(
                (string)
                (comment)
                (variable)
                (keyword)
                (operator)
                (builtin)
                (preprocessor)
                (definition)
                (type)
                (doc)
                ))

  (setq-local treesit-font-lock-level 4)

  ;; (setq-local treesit-simple-indent-rules erlang-ts-indent-rules)

  (treesit-major-mode-setup))

;;;###autoload
(define-derived-mode erlang-ts-mode erlang-mode "erl-ts"
  "Major mode for editing erlang with tree-sitter."
  :syntax-table erlang-mode-syntax-table

  ;;(setq-local font-lock-defaults nil)
  (add-to-list 'lsp-language-id-configuration
               '(erlang-ts-mode . "erlang"))

  (when (treesit-ready-p 'erlang)
    (treesit-parser-create 'erlang)
    (erlang-ts-setup)))

(provide 'erlang-ts)
;;; erlang-ts-mode.el ends here
