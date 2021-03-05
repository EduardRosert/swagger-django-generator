VENV=./ve
PYTHON=$(VENV)/bin/python
PIP=$(VENV)/bin/pip
PROJECT=swagger_django_generator


.PHONY: check test virtualenv demo clean-demo

test:
	$(VENV)/bin/nosetests --verbose

$(VENV):
	virtualenv $(VENV) --python=python3

ipython:
	$(PIP) install ipython

virtualenv: $(VENV)
	$(PIP) install -r requirements.txt

clean-virtualenv:
	rm -rf $(VENV)

demo:
	[ -d "demo" ] || $(VENV)/bin/django-admin startproject demo
	$(PYTHON) swagger_django_generator/generator.py tests/resources/petstore.json --output-dir demo/demo/ --module-name demo
	cp -r ui demo/

aiohttpdemo:
	mkdir -p aiohttp-demo/demo
	$(PYTHON) swagger_django_generator/generator.py tests/resources/petstore.json --output-dir aiohttp-demo/demo --module-name demo --backend=aiohttp
	cp -r ui aiohttp-demo/

clean-demo:
	rm -rf demo

docker-build:
	docker build . --tag swagger-django-generator

docker-demo:
	[ -d "demo" ] || mkdir demo
	docker run --rm -it -v $$(pwd)/demo/:/app/demo/ swagger-django-generator tests/resources/petstore.yaml --output-dir demo/demo/ --module-name demo