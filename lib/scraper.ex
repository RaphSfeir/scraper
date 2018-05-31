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
      :timer.sleep(150)
      Task.Supervisor.async(pid, fn ->
        rss(row)
      end)
    end)
  end

  def get_domains_result(domains) when is_list(domains) do
    domains 
    |> Enum.reduce([0, 0], fn(feeds, [f_count, e_count]) -> 
     if (length(feeds) > 0) do
       [f_count + length(feeds), e_count]
     else 
       [f_count, e_count + 1]
     end
    end)
  end

  def test_domains do
    {:ok, pid} = Task.Supervisor.start_link()
    domains = File.stream!("files/domains_feeds.csv")
    |> CSV.decode(separator: ?;)
    |> Enum.map(fn [domain, _domain_feed] ->
      IO.inspect domain 
      :timer.sleep(5)
      Task.Supervisor.async(pid, fn ->
        %Scrape.Website{ feeds: feeds } = website(domain)
        IO.inspect feeds
        end)
    end)
    |> Enum.map(fn task -> Task.await(task, 50000) end)

    IO.inspect "result dude "
    IO.inspect length(domains)
    get_domains_result(domains)
  end
end
