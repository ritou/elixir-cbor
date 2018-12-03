defmodule CborTest do
  use ExUnit.Case
  doctest Cbor

  test "unsigned integers" do
    round_trip(0)
    round_trip(23)
    round_trip(24)
    round_trip(255)
    round_trip(256)
    round_trip(65535)
    round_trip(65536)
    round_trip(4_294_967_295)
    round_trip(18_446_744_073_709_551_615)
  end

  test "negative integers" do
    round_trip(-1)
    round_trip(-24)
    round_trip(-25)
    round_trip(-256)
    round_trip(-257)
    round_trip(-65536)
    round_trip(-65537)
    round_trip(-4_294_967_296)
    round_trip(-18_446_744_073_709_551_616)
  end

  test "strings (symbols)" do
    round_trip(:test)
  end

  test "arrays" do
    round_trip([])
    round_trip([3,2,1])
    round_trip([100])
  end

  test "bytes" do
    round_trip(<<1,2,3>>)
  end

  test "maps" do
    round_trip(%{key1: :value1, key2: :value2})
  end

  test "invalid data" do
    assert {:error, :invalid_trailing_data} == Cbor.decode(<<1,2,3>>)
  end

  def round_trip(value) do
    assert value == Cbor.decode!(Cbor.encode(value))
  end
end
