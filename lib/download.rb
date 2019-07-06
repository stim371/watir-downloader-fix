class MyDownload
  def self.chrome_download
    h = Headless.new
    h.start
    prefs = {
      download: {
        prompt_for_download: false,
        default_directory: "/app"
      }
    }

    b = Watir::Browser.new :chrome, headless: true, options: { prefs: prefs }

    b.goto("https://www.petrinex.ca/PD/Pages/APD.aspx")
    Rails.logger.info b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").checkbox(value: "All Infrastructure Files").wait_until(&:exists?)
    until b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").checkbox(value: "All Infrastructure Files").set?
      Rails.logger.info("*** Trying to set Infra checkbox")
      b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").checkbox(value: "All Infrastructure Files").click!
    end

    Rails.logger.info b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").radio(value: "csv").wait_until(&:exists?)
    until b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").radio(value: "csv").set?
      Rails.logger.info("*** Trying to set csv radio button")
      b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").radio(value: "csv").click!
    end

    Rails.logger.info b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").button(visible_text: /Download/).wait_until(&:exists?)
    b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").button(visible_text: /Download/).click!
    Rails.logger.info b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").button(visible_text: /Yes/).wait_until(&:exists?)
    b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").button(visible_text: /Yes/).click!


    Rails.logger.info("*** Waiting for download start")
    Watir::Wait.until do
      File.exist?("download.zip.part")
    end
    Rails.logger.info("*** Download started")

    Rails.logger.info("*** Waiting for download finish")
    Watir::Wait.until(timeout: 10.minutes) do
      !File.exist?("download.zip.part")
    end
    Rails.logger.info("*** Download complete")
  rescue => ex
    Rails.logger.info("***explode")
    Rails.logger.info(ex.message)
  ensure
    b.quit if b
    h.destroy if h
  end

  def self.firefox_download
    h = Headless.new
    h.start
    download_directory = Dir.pwd #"#{Dir.pwd}/downloads"
    download_directory.tr!('/', '\\') if Selenium::WebDriver::Platform.windows?

    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.folderList'] = 2 # custom location
    profile['browser.download.dir'] = download_directory
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/zip,application/octet-stream,application/x-zip-compressed,multipart/x-zip"

    # capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(accept_insecure_certs: true)

    # b = Watir::Browser.new :firefox, headless: true, desired_capabilities: capabilities, profile: profile
    b = Watir::Browser.new :firefox, headless: true, profile: profile

    b.goto("https://www.petrinex.ca/PD/Pages/APD.aspx")
    Rails.logger.info b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").checkbox(value: "All Infrastructure Files").wait_until(&:exists?)
    until b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").checkbox(value: "All Infrastructure Files").set?
      Rails.logger.info("*** Trying to set Infra checkbox")
      b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").checkbox(value: "All Infrastructure Files").click!
    end

    Rails.logger.info b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").radio(value: "csv").wait_until(&:exists?)
    until b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").radio(value: "csv").set?
      Rails.logger.info("*** Trying to set csv radio button")
      b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").radio(value: "csv").click!
    end

    Rails.logger.info b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").button(visible_text: /Download/).wait_until(&:exists?)
    b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").button(visible_text: /Download/).click!
    Rails.logger.info b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").button(visible_text: /Yes/).wait_until(&:exists?)
    b.iframe(src:"https://www.petrinex.gov.ab.ca/PublicData").button(visible_text: /Yes/).click!


    Rails.logger.info("*** Waiting for download start")
    Watir::Wait.until do
      File.exist?("download.zip.part")
    end
    Rails.logger.info("*** Download started")

    Rails.logger.info("*** Waiting for download finish")
    Watir::Wait.until(timeout: 10.minutes) do
      !File.exist?("download.zip.part")
    end
    Rails.logger.info("*** Download complete")
  rescue => ex
    Rails.logger.info("***explode")
    Rails.logger.info(ex.message)
  ensure
    b.quit if b
    h.destroy if h
  end
end
