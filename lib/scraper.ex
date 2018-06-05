defmodule Scraper do
  @moduledoc """
  Documentation for Scraper.
  """

  @doc """
  Hello world.

  ## Examples

  iex> Scraper.hello
  :world

  """
  def hello do
    :world
  end

  def scrape_rss(feed) do
    IO.inspect feed 
    res = Scrape.feed feed 
    IO.inspect length(res)
  end

  def website(domain) do
    Scrape.website domain
  end

  def rss([id, domain]) do
    scrape_rss domain
  end

  def read do
    {:ok, pid} = Task.Supervisor.start_link()
    File.stream!("files/100_domains.csv")
    |> CSV.decode(separator: ?;)
    |> Enum.each(fn row -> 
      :timer.sleep(45)
      Task.Supervisor.async(pid, fn ->
        rss(row)
      end)
    end)
  end

  def get_domains_result(domains) when is_list(domains) do
    domains 
    |> Enum.reduce([0, 0, []], fn({domain, feeds}, [f_count, e_count, empty_feeds]) -> 
     if (length(feeds) > 0) do
       [f_count + length(feeds), e_count, empty_feeds]
     else 
       [f_count, e_count + 1, [domain | empty_feeds]]
     end
    end)
  end

  def test_domains do
    {:ok, pid} = Task.Supervisor.start_link()
    domains = File.stream!("files/domains_all.csv")
    |> CSV.decode(separator: ?;)
    |> Enum.map(fn [domain] ->
      IO.inspect domain 
      :timer.sleep(500)
      Task.Supervisor.async(pid, fn ->
        %Scrape.Website{ feeds: feeds } = website("http://" <> domain)
        IO.inspect feeds
        {domain, feeds}
         end)
    end)
    |> Enum.map(fn task -> Task.await(task, 50000) end)

    IO.inspect "result dude "
    IO.inspect length(domains)
    get_domains_result(domains)
  end
end
