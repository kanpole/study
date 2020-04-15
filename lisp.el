(defvar *default-program-directory* (expand-file-name "program" (getenv "EMACS_HOME")));默认项目目录
(defvar nplugins-path (expand-file-name "plugin" (getenv "EMACS_HOME")));插件默认目录
(defvar nplugin-cnfname ".plugin");插件默认配置文件
(defvar *default-execable-path* (list )) ;初始默认环境变量的列表

(defun append-string-to-file (filename strings)
  "追加字符串到一个文件中"
  (let ((ifilename filename)
        (istrings strings))
    (save-excursion
      (set-buffer (find-file-noselect ifilename))
      (goto-char (point-max))
      (insert istrings)
      (save-buffer)
      (kill-buffer)
      )))

(defun concat-path-home (listval home)
  "将一个目录添加到列表中的每个值前"
  (mapcar #'(lambda(obj) (expand-file-name obj home)) listval)
  )
	  
(defun add-list-to-other-list (listfrom listto)
  "将一个列表的字符串添加到另一个列表,参数一是一个列表,参数二是一个列表的符号"
  (do ((varfrom 0 (1+ varfrom)))
      ((>= varfrom (length listfrom)))
    (let ((flag= nil))
      (do ((varto 0 (1+ varto)))
          ((>= varto (length (symbol-value listto))))
        (if (string= (elt listfrom varfrom) (elt (symbol-value listto) varto))
            (setf flag= t)
          ))
      (or flag= (set listto (cons (elt listfrom varfrom) (symbol-value listto))))
      )
    ))

(defun install-plugin (name &optional cnfname path gcnfname)
  "安装插件,创建目录,及文件"
  (let ((iname name) (ipath path) (icnfname cnfname) (filename nil) igcnfname gcnfname)
    (or ipath (setf ipath nplugins-path))
    (or icnfname (setf icnfname (concat "." name)))
    (or igcnfname (setf igcnfname nplugin-cnfname))
    (setf filename (expand-file-name (concat iname "/" icnfname) ipath))
    (block 'if-or-not
      (or (file-directory-p ipath)
          (progn 
            (make-directory ipath)
            (append-to-file 1 1 (expand-file-name igcnfname ipath))
            ))
      (if (not (file-directory-p (file-name-directory filename)))
          (if (yes-or-no-p "本插件目录不存在是否创建?:")
              (make-directory (file-name-directory filename))
            (return-from 'if-or-not nil)))
      (or (file-exists-p filename)
          (append-string-to-file (expand-file-name igcnfname ipath)
                                 (concat "\n(add-to-list 'load-path \"" (file-name-directory filename) "\")"
                                         "\n(load-file \"" filename "\")"
                                         )
                                 ))
      (progn (find-file filename) t)
      )))

(defun add-default-execable-path-list (listval)
  "将一个路径列表添加到默认执行环境变量列表中"
  (add-list-to-other-list listval '*default-execable-path*)
  )

(defun add-default-execable-path (strpath)
  "将一个路径添加到默认执行环境变量列表中"
  (block 'add-start
    (mapcar #'(lambda (object)
                (or (not (string= strpath object))
                    (return-from 'add-start nil)
                    ))
            *default-execable-path*)
    (add-to-list '*default-execable-path* strpath)
    )
  )

(defun set-path (strname listval)
  "设置自定义环境变量;变量名,路径列表"
  (setenv strname)
  (mapcar #'(lambda (object)
              (or (search object (getenv strname))
                  (setenv strname (concat  object ";" (getenv strname)))
                  ))
          listval)
  (getenv strname)
  )


(defun add-path (strname listval)
  "设置自定义环境变量;变量名,路径列表"
  (mapcar #'(lambda (object)
              (or (search object (getenv strname))
                  (setenv strname (concat  object ";" (getenv strname)))
                  ))
          listval)
  )

(defun create-program (proname &optional path type)
  "创建一个项目,并建立一个维护项目的清单"
  (let ((ipath path) (itype type))
    (or ipath (setf ipath (expand-file-name proname *default-program-directory*)))
    (or itype (setf itype "txt"))
    (block 'start
      (or (file-directory-p ipath)
          (if (yes-or-no-p (message "目录:%s不存在是否创建?" ipath))
              (make-directory ipath)
            (return-from 'start nil)
            )
          )
      (or (file-exists-p (expand-file-name ".program" ipath))
          (append-string-to-file (expand-file-name ".program" ipath)
                                 (concat "{\"program-name\":\"" proname "\",\n"
                                         "\"program-path\":\""  ipath "\",\n"
                                         "\"type\":\"" itype "\",\n"
                                         "\"files\":[null],\n"
                                         "\"subprograms\":[null]}"
                                         )
                                 )))))


(defun open-program (proname &optional program-path)
  "打开一个项目"
  (let ((filename (expand-file-name ".program" (expand-file-name proname (or program-path *default-program-directory*)))) (fileobj nil))
    (if (not (file-exists-p filename))
        (message "项目文件:%s不存在,请检查后重试." filename)
      (progn
        (setf fileobj (json-read-file filename))
        (split-window-right)
        (other-window 1)
        (dired (cdr (assoc 'program-path fileobj))
               )))))
