require 'download'

namespace :download do
  task :chrome do
    MyDownload.chrome_download

    raise "Failed to download file with Chrome" unless File.exist?("/app/download.zip")
  end

  task :firefox do
    MyDownload.firefox_download

    raise "Failed to download file with Firefox" unless File.exist?("/app/download.zip")
  end
end
