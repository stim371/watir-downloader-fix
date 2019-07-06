build-image:
	docker build -t watir-downloader-fix .

run-test-chrome:
	docker run -t watir-downloader-fix bin/rails download:chrome

run-test-firefox:
	docker run -t watir-downloader-fix bin/rails download:firefox
