(defpackage noughts-and-crosses/tests/main
  (:use :cl
        :noughts-and-crosses
        :rove))
(in-package :noughts-and-crosses/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :noughts-and-crosses)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
