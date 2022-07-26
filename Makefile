build:
	docker build -t nvim-florentc .

build-amd64:
	docker build --platform linux/amd64 -t nvim-florentc .

run:
	docker run --rm -it --name nvim-florentc nvim-florentc
