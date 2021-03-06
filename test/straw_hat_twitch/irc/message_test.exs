defmodule StrawHat.Twitch.IRC.MessageTest do
  use ExUnit.Case, async: true

  alias StrawHat.Twitch.IRC.Message

  test "matching welcome message" do
    message = ":tmi.twitch.tv 001 alchemist_ubi :Welcome, GLHF!\r\n"
    assert Message.welcome_message?(message) == true
  end

  test "matching ping message" do
    message = "PING :tmi.twitch.tv\r\n"
    assert Message.ping?(message) == true
  end

  test "matching join message" do
    message = ":alchemist_ubi!alchemist_ubi@alchemist_ubi.tmi.twitch.tv JOIN #alchemist_ubi\r\n"
    assert Message.join?(message) == true
  end

  test "matching private message" do
    message =
      ":alchemist_ubi!alchemist_ubi@alchemist_ubi.tmi.twitch.tv PRIVMSG #alchemist_ubi :this is a message\r\n"

    assert Message.private_message?(message) == true
  end

  test "matching depart message" do
    message = ":alchemist_ubi!alchemist_ubi@alchemist_ubi.tmi.twitch.tv PART #alchemist_ubi\r\n"
    assert Message.part?(message) == true
  end

  test "join channel" do
    assert Message.join("pepega") == "JOIN #pepega"
  end

  test "part channel" do
    assert Message.part("pepega") == "PART #pepega"
  end

  test "pong message" do
    assert Message.pong() == "PONG :tmi.twitch.tv"
  end

  test "password message" do
    assert Message.password("123") == "PASS 123"
  end

  test "nick message" do
    assert Message.nick("alchemist_ubi") == "NICK alchemist_ubi"
  end

  test "private message" do
    assert Message.message("pepega", "Hello, World") == "PRIVMSG #pepega :Hello, World"
  end

  test "parse join" do
    data =
      Message.parse_join(
        ":alchemist_ubi!alchemist_ubi@alchemist_ubi.tmi.twitch.tv JOIN #alchemist_ubi\r\n"
      )

    assert data == %{"channel_name" => "alchemist_ubi"}
  end

  test "parse part" do
    data =
      Message.parse_part(
        ":alchemist_ubi!alchemist_ubi@alchemist_ubi.tmi.twitch.tv PART #alchemist_ubi\r\n"
      )

    assert data == %{"channel_name" => "alchemist_ubi"}
  end

  test "parse private message" do
    data =
      Message.parse_private_message(
        ":alchemist_ubi!alchemist_ubi@alchemist_ubi.tmi.twitch.tv PRIVMSG #alchemist_ubi :this is a message\r\n"
      )

    assert data == %Message{
             channel_name: "alchemist_ubi",
             username: "alchemist_ubi",
             body: "this is a message"
           }
  end
end
