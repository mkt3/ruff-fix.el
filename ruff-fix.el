;;; ruff-fix.el --- Use ruff to fix lint violations -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Makoto Morinaga  <makoto@mkt3.me>

;; Author: Makoto Morinaga  <makoto@mkt3.me>
;; Maintainer: Makoto Morinaga  <makoto@mkt3.me>
;; Version: 0.1.0
;; URL: https://github.com/mkt3/ruff-fix.el

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; ruff-fix.el is an Emacs package that uses Ruff (https://beta.ruff.rs/docs/)
;; to automatically fix lint violations in Python code.
;;
;; Features:
;; - Automatically fix lint violations in the current buffer using Ruff.
;; - Optionally fix lint violations before saving the buffer.
;; - Follows Ruff's configuration rules as described in the Ruff documentation.
;;
;; Installation:
;; 1. Clone this repository to a directory of your choice.
;; 2. Add the cloned directory to your `load-path`.
;; 3. Require the package in your Emacs configuration.
;;
;; Usage:
;; - Fix lint violations manually by calling `M-x ruff-fix-buffer`.
;; - Fix lint violations automatically before saving by adding `ruff-fix-before-save`
;;   to the `before-save-hook`.
;; - The package follows Ruff's configuration rules as specified in the Ruff documentation.
;;   Please refer to the documentation to configure Ruff according to your requirements
;;   and preferences.
;;
;; For more information, please refer to the README file.

;;; Code:

;;;###autoload
(defun ruff-fix-buffer ()
  "Use ruff to fix lint violations in the current buffer."
  (interactive)
  (let* ((temporary-file-directory (if (buffer-file-name)
                                       (file-name-directory (buffer-file-name))
                                     temporary-file-directory))
         (temp-file (make-temp-file "temp-"))
         (current-point (point)))
    (write-region (point-min) (point-max) temp-file nil)
    (shell-command (format "ruff check --fix %s" temp-file))
    (erase-buffer)
    (insert-file-contents temp-file)
    (delete-file temp-file)
    (goto-char current-point)))

;;;###autoload
(defun ruff-fix-before-save ()
  (interactive)
  (when (memq major-mode '(python-mode python-ts-mode))
    (ruff-fix-buffer)))

(provide 'ruff-fix)

;;; ruff-fix.el ends here
