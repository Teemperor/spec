;; Test files can define multiple modules. Test that implementations treat
;; each module independently from the other.

(module
  (func $foo (result i32) (i32.const 0))
  (export "foo" $foo)
)

(assert_return (invoke "foo") (i32.const 0))

;; Another module, same function name, different contents.

(module
  (func $foo (result i32) (i32.const 1))
  (export "foo" $foo)
)

(assert_return (invoke "foo") (i32.const 1))


(module
  ;; Test that we can use the empty string as a symbol.
  (func (result f32) (f32.const 0x1.91p+2))
  (export "" 0)

  ;; Test that we can use common libc names without conflict.
  (func $malloc (result f32) (f32.const 0x1.92p+2))
  (export "malloc" $malloc)

  ;; Test that we can use some libc hidden names without conflict.
  (func $_malloc (result f32) (f32.const 0x1.93p+2))
  (func $__malloc (result f32) (f32.const 0x1.94p+2))
  (func (result f32) (f32.const 0x1.95p+2))
  (export "_malloc" $_malloc)
  (export "__malloc" $__malloc)
  (export "malloc" 4)

  ;; Test that we can use non-alphanumeric names.
  (func (result f32) (f32.const 0x1.96p+2))
  (export "~!@#$%^&*()_+`-={}|[]\\:\";'<>?,./ " 5)

  ;; Test that we can use names beginning with a digit.
  (func (result f32) (f32.const 0x1.97p+2))
  (export "0" 6)

  ;; Test that we can use names beginning with an underscore.
  (func $_ (result f32) (f32.const 0x1.98p+2))
  (export "_" $_)

  ;; Test that we can use names beginning with a dollar sign.
  (func (result f32) (f32.const 0x1.99p+2))
  (export "$" 8)

  ;; Test that we can use names beginning with an at sign.
  (func (result f32) (f32.const 0x2.00p+2))
  (export "@" 9)

  ;; Test that we can use names with non-ASCII characters.
  (func (result f32) (f32.const 0x2.01p+2))
  (export "日本人の氏名" 10)

  ;; Test that we can use names with ASCII control characters.
  (func (result f32) (f32.const 0x2.02p+2))
  (export "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x7f" 11)

  ;; Test for Unicode stunts.
  (func (result f32) (f32.const 0x2.03p+2))
  (export "ḍ̨̧̛̛̪̞̣̘ͤi̴̮͔̝̖͇̓̀ͫ͠a̸͈͙̣̞̔͋͛ͮ͘c̵̴͎̥̖̊͐̇͢ͅŕ̢̡̢̭̬̫͂̕͢i̛̺̯̘̖̥ͥͩͫ̌t̸͎̣̺̟̽̾̿ͣ͞i̱̲̯̅̾̏ͦ͌͌͡c̸̖͗̒͋̇ͧ̆̆a̤̤̰͊ͮͤ͢͜͞l̠̝̒ͥͩ̆͌͋ m͉̓͏̷̷ä̦́̊̐r̷͈̀̂k͈̇̈́̕s̡" 12)

  ;; Test for Unicode special characters (BOMs of various encodings, LRM, NBSP).
  (func (result f32) (f32.const 0x2.04p+2))
  (func (result f32) (f32.const 0x2.05p+2))
  (func (result f32) (f32.const 0x2.06p+2))
  (func (result f32) (f32.const 0x2.07p+2))
  (func (result f32) (f32.const 0x2.08p+2))
  (func (result f32) (f32.const 0x2.09p+2))
  (func (result f32) (f32.const 0x2.10p+2))
  (export "﻿malloc" 13)
  (export "��malloc" 14)
  (export "��malloc" 15)
  (export "  ��malloc" 16)
  (export "��  malloc" 17)
  (export "‎malloc" 18)
  (export " malloc" 19)
)

(assert_return (invoke "") (f32.const 0x1.91p+2))
(assert_return (invoke "malloc") (f32.const 0x1.92p+2))
(assert_return (invoke "_malloc") (f32.const 0x1.93p+2))
(assert_return (invoke "__malloc") (f32.const 0x1.94p+2))
(assert_return (invoke "malloc") (f32.const 0x1.95p+2))
(assert_return (invoke "~!@#$%^&*()_+`-={}|[]\\:\";'<>?,./ ") (f32.const 0x1.96p+2))
(assert_return (invoke "0") (f32.const 0x1.97p+2))
(assert_return (invoke "_") (f32.const 0x1.98p+2))
(assert_return (invoke "$") (f32.const 0x1.99p+2))
(assert_return (invoke "@") (f32.const 0x2.00p+2))
(assert_return (invoke "日本人の氏名") (f32.const 0x2.01p+2))
(assert_return (invoke "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x7f") (f32.const 0x2.02p+2))
(assert_return (invoke "ḍ̨̧̛̛̪̞̣̘ͤi̴̮͔̝̖͇̓̀ͫ͠a̸͈͙̣̞̔͋͛ͮ͘c̵̴͎̥̖̊͐̇͢ͅŕ̢̡̢̭̬̫͂̕͢i̛̺̯̘̖̥ͥͩͫ̌t̸͎̣̺̟̽̾̿ͣ͞i̱̲̯̅̾̏ͦ͌͌͡c̸̖͗̒͋̇ͧ̆̆a̤̤̰͊ͮͤ͢͜͞l̠̝̒ͥͩ̆͌͋ m͉̓͏̷̷ä̦́̊̐r̷͈̀̂k͈̇̈́̕s̡") (f32.const 0x2.03p+2))
(assert_return (invoke "﻿malloc") (f32.const 0x2.04p+2))
(assert_return (invoke "��malloc") (f32.const 0x2.05p+2))
(assert_return (invoke "��malloc") (f32.const 0x2.06p+2))
(assert_return (invoke "  ��malloc") (f32.const 0x2.07p+2))
(assert_return (invoke "��  malloc") (f32.const 0x2.08p+2))
(assert_return (invoke "‎malloc") (f32.const 0x2.09p+2))
(assert_return (invoke " malloc") (f32.const 0x2.10p+2))
