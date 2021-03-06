(module
  (func $block (result i32)
    (block $exit
      (break $exit (i32.const 1))
      (i32.const 0)
    )
  )

  (func $loop1 (result i32)
    (local $i i32)
    (set_local $i (i32.const 0))
    (loop $exit
      (set_local $i (i32.add (get_local $i) (i32.const 1)))
      (if (i32.eq (get_local $i) (i32.const 5))
        (break $exit (get_local $i))
      )
    )
  )

  (func $loop2 (result i32)
    (local $i i32)
    (set_local $i (i32.const 0))
    (loop $exit $cont
      (set_local $i (i32.add (get_local $i) (i32.const 1)))
      (if (i32.eq (get_local $i) (i32.const 5))
        (break $cont (i32.const -1))
      )
      (if (i32.eq (get_local $i) (i32.const 8))
        (break $exit (get_local $i))
      )
      (set_local $i (i32.add (get_local $i) (i32.const 1)))
    )
  )

  (func $switch (param i32) (result i32)
    (label $ret
      (i32.mul (i32.const 10)
        (i32.switch $exit (get_local 0)
          (case 1 (i32.const 1))
          (case 2 (break $exit (i32.const 2)))
          (case 3 (break $ret (i32.const 3)))
          (i32.const 4)
        )
      )
    )
  )

  (func $return (param i32) (result i32)
    (i32.switch (get_local 0)
      (case 1 (return (i32.const 1)))
      (case 2 (i32.const 2))
      (i32.const 3)
    )
  )

  (export "block" $block)
  (export "loop1" $loop1)
  (export "loop2" $loop2)
  (export "switch" $switch)
  (export "return" $return)
)

(assert_return (invoke "block") (i32.const 1))
(assert_return (invoke "loop1") (i32.const 5))
(assert_return (invoke "loop2") (i32.const 8))
(assert_return (invoke "switch" (i32.const 1)) (i32.const 10))
(assert_return (invoke "switch" (i32.const 2)) (i32.const 20))
(assert_return (invoke "switch" (i32.const 3)) (i32.const 3))
(assert_return (invoke "switch" (i32.const 4)) (i32.const 40))
(assert_return (invoke "switch" (i32.const 5)) (i32.const 40))
(assert_return (invoke "return" (i32.const 1)) (i32.const 1))
(assert_return (invoke "return" (i32.const 2)) (i32.const 2))
(assert_return (invoke "return" (i32.const 3)) (i32.const 3))

