defmodule HoundPlayground do
  # enables Hound helpers inside our module, e.g. navigate_to/1
  use Hound.Helpers

  def fetch_ip do
    # starts Hound session. Required before we can do anything
    Hound.start_session 

    # visit the website which shows the visitor's IP
    navigate_to "http://gamasutra.com"

    # display its raw source
    res = page_source()

    # cleanup
    Hound.end_session
    res
  end
end
