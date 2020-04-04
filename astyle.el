(defvar astyle-command "astyle --style=google --indent-switches --indent=spaces=4 --convert-tabs")

(defun astyle (start end)
  "Run astyle on region or buffer"
  (interactive (if mark-active
		   (list (region-beginning) (region-end))
		 (list (point-min) (point-max))
		 ))
  (save-restriction
    (shell-command-on-region start end
			     astyle-command
			     (current-buffer) t
			     (get-buffer-create "*Astyle Errors*") t)))
(global-set-key [f8] 'astyle)
(provide 'astyle-utils)
