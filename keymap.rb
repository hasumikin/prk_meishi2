# Wait until Keyboard class is ready
while !$mutex
  relinquish
end

# Initialize a Keyboard
kbd = Keyboard.new

kbd.init_pins(
  [ 6, 7 ],   # row0, row1
  [ 28, 27 ]  # col0, col1
)

# default layer should be added at first
kbd.add_layer :default, %i[
  KC_A      KC_B    RAISE_ENTER LOWER_SPACE
]
kbd.add_layer :raise, %i[
  KC_C      KC_D    RAISE_ENTER ADJUST
]
kbd.add_layer :lower, %i[
  KC_E      KC_F    RAISE_ENTER LOWER_SPACE)
]
kbd.add_layer :adjust, %i[
  KC_SCOLON KC_LSFT RAISE_ENTER ADJUST
]
#
#                   Your custom     Keycode or             Keycode (only modifiers)      Release time      Re-push time
#                   key name        Array of Keycode       or Layer Symbol to be held    threshold(ms)     threshold(ms)
#                                   or Proc                or Proc which will run        to consider as    to consider as
#                                   when you click         while you keep press          `click the key`   `hold the key`
kbd.define_mode_key :RAISE_ENTER, [ :KC_ENTER,             :raise,                       200,              150 ]
kbd.define_mode_key :LOWER_SPACE, [ :KC_SPACE,             :lower,                       300,              400 ]
kbd.define_mode_key :ADJUST,      [ nil,                   :adjust,                      nil,              nil ]

# Alternatively, you can also write like:
#
# kbd.add_layer :default, [
#   %i(KC_A SHIFT_RAISE), %i(KC_B SHIFT_SPACE)
# ]
# kbd.add_layer :raise, [
#   %i(KC_C SHIFT_LOWER), %i(KC_D SPACE_LOWER)
# ]
# kbd.add_layer :lower, [
#   %i(KC_E SHIFT_DEFAULT), %i(KC_F LOWER_SPACE)
# ]
# kbd.define_mode_key :SHIFT_RAISE,   [ Proc.new { kbd.lock_layer :raise },   :KC_RSFT,         200,              200 ]
# kbd.define_mode_key :SHIFT_LOWER,   [ Proc.new { kbd.lock_layer :lower },   :KC_RSFT,         200,              200 ]
# kbd.define_mode_key :SHIFT_DEFAULT, [ Proc.new { kbd.lock_layer :default }, :KC_RSFT,         200,              200 ]
#                                                      ^^^^^^^^^^ `lock_layer` will "lock" layer to specified one
# kbd.define_mode_key :SHIFT_SPACE,   [ :KC_SPACE,                            :KC_LSFT,         300,              400 ]
# kbd.define_mode_key :SPACE_LOWER,   [ Proc.new { kbd.lower_layer },         :KC_LCTL,         200,              200 ]
#
# Other than `hold_layer` and `lock_layer`, `raise_layer` and `lower_layer` will switch current layer in order

# `before_report` will work just right before reporting what keys are pushed to USB host.
# You can use it to hack data by adding an instance method to Keyboard class by yourself.
# ex) Use Keyboard#before_report filter if you want to input `":" w/o shift` and `";" w/ shift`
kbd.before_report do
  kbd.invert_sft if kbd.keys_include?(:KC_SCOLON)
  # You'll be also able to write `invert_ctl`, `invert_alt` and `invert_gui`
end

kbd.start!
