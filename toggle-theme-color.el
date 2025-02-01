;;; toggle-theme-color.el 用于切换主题的明暗色调 -*- lexical-binding: t -*-

(defun toggle-theme-color ()
  "Switch between light/dark theme variants if available."
  (interactive)
  (let* ((current-themes custom-enabled-themes)
         (current-theme (car current-themes))
         (current-name (when current-theme (symbol-name current-theme)))
         (suffix-info (cond
                       ((and current-name (string-suffix-p "light" current-name t)) (cons "-light" 6))
                       ((and current-name (string-suffix-p "dark" current-name t)) (cons "-dark" 5))
                       (t nil)))
         (original-suffix (car suffix-info))
         (original-length (cdr suffix-info))
         new-suffix new-theme-name new-theme)

    (unless current-name
      (user-error "No theme is currently enabled."))

    (if (not suffix-info)
        (message "The current theme '%s' does not seem to have any other tones" current-name)
      (setq new-suffix (if (equal original-suffix "-light") "-dark" "-light"))
      (setq new-theme-name (concat (substring current-name 0 (- (length current-name) original-length)) new-suffix))
      (setq new-theme (intern new-theme-name))

      (if (memq new-theme custom-known-themes)
          (progn
            (mapc #'disable-theme current-themes)
            (enable-theme new-theme)
            (message "Switched to new theme '%s'." new-theme))
        (message "Can't find another color for the current theme '%s'." current-theme)))))


(provide 'toggle-theme-color)
