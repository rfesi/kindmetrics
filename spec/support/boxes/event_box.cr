class EventBox < Avram::Box
  def initialize
    name "pageview"
    user_id sequence("session")
    referrer "https://www.test.com/best-analytics"
    url "https://kindmetrics.io/help/test"
    source nil
    user_agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36"
    screen_width nil
    path "/help/test"
    device "desktop"
    operative_system "GNU/Linux"
    referrer_domain "www.test.com"
    browser_name "Chrome"
    browser_version "81.0.4044.113"
    country "SE"
    session_id SessionBox.create.id
    domain_id DomainBox.create.id
  end
end
