(defsystem "noughts-and-crosses"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("ltk")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "noughts-and-crosses/tests"))))

(defsystem "noughts-and-crosses/tests"
  :author ""
  :license ""
  :depends-on ("noughts-and-crosses"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for noughts-and-crosses"
  :perform (test-op (op c) (symbol-call :rove :run c)))
