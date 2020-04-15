(setenv "JAVA_HOME" (expand-file-name "sdk/jdk/openjdk" (getenv "EMACS_HOME")))
(setenv "ANDROID_SDK" (expand-file-name "sdk/AndroidSDK" (getenv "EMACS_HOME")))
(setenv "ANDROID_NDK" (expand-file-name "sdk/AndroidNDK64/android-ndk-r16b" (getenv "EMACS_HOME")))

(setenv "WINSDK" (expand-file-name "sdk/windows" (getenv "EMACS_HOME")))
(setenv "VC" (expand-file-name "sdk/VC" (getenv "EMACS_HOME")))

(add-default-execable-path-list
 (concat-path-home '(
                    "bin"
                    "other/git/bin"
		    "other/git/"
                    "other/MinGW/bin"
                    "other/MinGW/bin"
                    "other/MinGW/msys/1.0/bin"
                    "other/astyle/bin"
                    "sdk/jdk/openjdk/bin"
                    )
                   (getenv "EMACS_HOME")))

(add-default-execable-path-list (list (expand-file-name "system32" (getenv "SystemRoot"))))

(set-path "PATH" *default-execable-path*)

(add-hook 'java-mode-hook #'(lambda () (add-default-execable-path-list
                                       (list (expand-file-name "tools"  (getenv "ANDROID_SDK"))
                                             (expand-file-name "platform-tools" (getenv "ANDROID_SDK"))
                                             (expand-file-name "emulator" (getenv "ANDROID_SDK"))
                                             (expand-file-name "build-tools/29.0.3" (getenv "ANDROID_SDK"))
                                             (getenv "ANDROID_NDK")))
                              (set-path "PATH" *default-execable-path*)
                              ))

