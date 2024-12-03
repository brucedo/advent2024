defmodule Day3Test do
  require Logger
  use ExUnit.Case
  doctest Day3

  test "Given some string 'mul(1,2)' when passed to match_muls, then the return list will include 'mul(1,2)'" do
    mul_text = "mul(1,2)"

    assert Day3.match_muls(mul_text) == ["mul(1,2)"]
  end

  test "Given some string 'mul( 1,2)' when passed to match_muls, then the return list will be empty" do
    mul_text = "mul( 1,2)"

    assert Day3.match_muls(mul_text) == []
  end

  test "Given some string 'mul(1,2 )' when passed to match_muls, then the return list will be empty" do
    mul_text = "mul( 1,2)"

    assert Day3.match_muls(mul_text) == []
  end

  test "Given some string 'mul( 1,2 )' when passed to match_muls, then the return list will be empty" do
    mul_text = "mul( 1,2 )"

    assert Day3.match_muls(mul_text) == []
  end

  test "Given some string 'mul (1,2)' when passed to match_muls, then the return list will be empty" do
    mul_text = "mul (1,2)"

    assert Day3.match_muls(mul_text) == []
  end

  test "Given some string with several malformed muls, when passed to match_muls, then the return list will be empty" do
    mul_text = "mul(4*mul6,9!?(12,34)mul ( 2 , 4 )"

    assert Day3.match_muls(mul_text) == []
  end

  test "Given some string 'xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]thenmul(11,8)mul(8,5))', when passed to match_muls, the return list will contain mul(2,4), mul(5,5), mul(11,8) and mul(8,5)" do
    mul_text = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]thenmul(11,8)mul(8,5))"

    muls = Day3.match_muls(mul_text)

    Logger.debug("What was the result? #{muls}")

    assert length(muls) == 4
    assert Enum.member?(muls, "mul(2,4)")
    assert Enum.member?(muls, "mul(5,5)")
    assert Enum.member?(muls, "mul(11,8)")
    assert Enum.member?(muls, "mul(8,5)")
  end

  test "Given some string 'mul(x,y)' decode_str will return a pair of integers {x, y}" do
    mul = "mul(2,4)"

    assert Day3.decode_str(mul) == {2, 4}
  end

  test "Given some list inst and a status of :pause, when both are passed to eval, then an empty list will be returned" do
    inst = ["blahblah", "flawflaw", "glawglaw", "glugglug", "doowadiddy"]

    assert Day3.eval(inst, :pause) == []
  end

  test "Given some list inst and a status of :proceed, when both are passed to eval, then the returned list of strings will include all elements of INST" do
    inst = ["blahblah", "flawflaw", "glawglaw", "glugglug", "doowadiddy"]

    assert Day3.eval(inst, :proceed) == [
             "blahblah",
             "flawflaw",
             "glawglaw",
             "glugglug",
             "doowadiddy"
           ]
  end

  test "Given some list inst including the tag don't() and a status of :pause, when passed to eval, then an empty list will be returned" do
    inst = ["blahblah", "flawflaw", "glawglaw", "don't()", "glugglug", "doowadiddy"]

    assert Day3.eval(inst, :pause) == []
  end

  test "Given some list inst starting with the tag don't() and a status of :proceed, when both are passed toe val,then an empty list will be returned" do
    inst = ["don't()", "blahblah", "flawflaw", "glawglaw", "don't()", "glugglug", "doowadiddy"]

    assert Day3.eval(inst, :proceed) == []
  end

  test "Given some list inst ending with the tag don't() and a status of :proceed, when both are passed to eval, then the return list will include every element of INST except don't()" do
    inst = ["blahblah", "flawflaw", "glawglaw", "glugglug", "doowadiddy", "don't()"]

    assert Day3.eval(inst, :proceed) == [
             "blahblah",
             "flawflaw",
             "glawglaw",
             "glugglug",
             "doowadiddy"
           ]
  end

  test "Given some list inst containing the tag don't() at midpoint nad a status of :proceed, when both are passed to eval, then the return list will include only the elements of INST preceding don't()" do
    inst = ["blahblah", "flawflaw", "glawglaw", "don't()", "glugglug", "doowadiddy"]

    assert Day3.eval(inst, :proceed) == ["blahblah", "flawflaw", "glawglaw"]
  end

  test "Given some list inst endign with the tag do() and a status of :pause, when both are passed to eval, then an empty list will be returned." do
    inst = ["blahblah", "flawflaw", "glawglaw", "glugglug", "doowadiddy", "do()"]

    assert Day3.eval(inst, :pause) == []
  end

  test "Given some list inst ending with the tag do() and a status of :proceed, when both are passed to eval, then the returned list will contain every element of INST except do()" do
    inst = ["blahblah", "flawflaw", "glawglaw", "glugglug", "doowadiddy", "do()"]

    assert Day3.eval(inst, :proceed) == [
             "blahblah",
             "flawflaw",
             "glawglaw",
             "glugglug",
             "doowadiddy"
           ]
  end

  test "Given some list inst starting with the tag do() and a status of :pause, when both are passed to eval, then the returned list will contain ever element of INST except do()" do
    inst = ["do()", "blahblah", "flawflaw", "glawglaw", "glugglug", "doowadiddy"]

    assert Day3.eval(inst, :pause) == [
             "blahblah",
             "flawflaw",
             "glawglaw",
             "glugglug",
             "doowadiddy"
           ]
  end

  test "Given some list inst starting with the tag do() and a status of :proceed, when both are passed to eval, then the returned list will contain every element of INST except do()" do
    inst = ["do()", "blahblah", "flawflaw", "glawglaw", "glugglug", "doowadiddy"]

    assert Day3.eval(inst, :proceed) == [
             "blahblah",
             "flawflaw",
             "glawglaw",
             "glugglug",
             "doowadiddy"
           ]
  end
end
