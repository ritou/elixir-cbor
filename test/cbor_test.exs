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
    round_trip(4_294_967_296)
    round_trip(18_446_744_073_709_551_615)

    assert Cbor.encode(0) == <<0>>
    assert Cbor.encode(23) == <<23>>
    assert Cbor.encode(24) == <<24, 24>>
    assert Cbor.encode(255) == <<24, 255>>
    assert Cbor.encode(256) == <<25, 1, 0>>
    assert Cbor.encode(65535) == <<25, 255, 255>>
    assert Cbor.encode(65536) == <<26, 0, 1, 0, 0>>
    assert Cbor.encode(4_294_967_295) == <<26, 255, 255, 255, 255>>
    assert Cbor.encode(4_294_967_296) == <<27, 0, 0, 0, 1, 0, 0, 0, 0>>
    assert Cbor.encode(18_446_744_073_709_551_615) == <<27, 255, 255, 255, 255, 255, 255, 255, 255>>
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

    assert Cbor.encode(-1) == <<32>>
    assert Cbor.encode(-24) == <<55>>
    assert Cbor.encode(-25) == <<56, 24>>
    assert Cbor.encode(-256) == <<56, 255>>
    assert Cbor.encode(-257) == <<57, 1, 0>>
    assert Cbor.encode(-65536) == <<57, 255, 255>>
    assert Cbor.encode(-65537) == <<58, 0, 1, 0, 0>>
    assert Cbor.encode(-4_294_967_296) == <<58, 255, 255, 255, 255>>
    assert Cbor.encode(-4_294_967_297) == <<59, 0, 0, 0, 1, 0, 0, 0, 0>>
    assert Cbor.encode(-18_446_744_073_709_551_616) == <<59, 255, 255, 255, 255, 255, 255, 255, 255>>
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
