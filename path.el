(add-default-execable-path-list
 (concat-path-home'(
                    "bin"
                    "other/git/bin"
		    "other/git/"
                    "other/MinGW/bin"
                    "other/MinGW/bin"
                    "other/MinGW/msys/1.0/bin"
                    "other/astyle/bin"
                    "sdk/jdk/openjdk14/bin"
                    )
                  (getenv "EMACS_HOME")))
(set-path "PATH" *default-execable-path*)

(setenv "JAVA_HOME")
(setenv "JAVA_HOME" (expand-file-name "sdk/jdk/openjdk14" (getenv "EMACS_HOME")))
