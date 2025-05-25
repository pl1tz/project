web:
	unset PORT && bin/rails s -b 0.0.0.0
vite:
	yarn install
	bin/vite dev
